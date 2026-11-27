import ICAL from "npm:ical.js@2.2.1";
import postgres from "npm:postgres@3.4.5";
const sql=postgres(Deno.env.get("SUPABASE_DB_URL")!,{max:1,prepare:false});
function iso(t:any){
 if(t.isDate || t.zone.tzid==="floating"){
 const s=t.toString(); return s.length===10?s+"T00:00:00":s;
 }
 return t.toJSDate().toISOString();
}
Deno.serve(async req=>{
 if(req.method!=="POST")return new Response("Method not allowed",{status:405});
 const [secret]=await sql`select token::text from calendar_internal.sync_token limit 1`;
 if(!secret || req.headers.get("x-calendar-token")!==secret.token)return new Response("Unauthorized",{status:401});
 const sources=await sql`select * from public.calendar_sources where active and (last_sync_at is null or last_sync_at <= now()-make_interval(mins=>sync_interval))`;
 const results=[];
 for(const s of sources){
 try{
 const u=new URL(s.feed_url);
 if(u.origin!=="https://calendar.google.com" || !u.pathname.startsWith("/calendar/ical/") || !u.pathname.endsWith(".ics") || u.username || u.password)throw Error("unsupported_source");
 const r=await fetch(u,{redirect:"error",signal:AbortSignal.timeout(15000)});
 if(!r.ok)throw Error("http_"+r.status);
 const raw=await r.text(); if(raw.length>5000000 || !raw.trim().endsWith("END:VCALENDAR"))throw Error("invalid_feed");
 const cal=new ICAL.Component(ICAL.parse(raw));
 if(cal.name!=="vcalendar")throw Error("invalid_calendar");
 for(const z of cal.getAllSubcomponents("vtimezone"))ICAL.TimezoneService.register(new ICAL.Timezone({component:z,tzid:z.getFirstPropertyValue("tzid")}));
 const groups=new Map();
 for(const c of cal.getAllSubcomponents("vevent")){
 const e=new ICAL.Event(c); if(!e.uid)throw Error("missing_uid");
 const g=groups.get(e.uid)||[];g.push(e);groups.set(e.uid,g);
 }
 const from=new Date();
 const until=new Date();until.setUTCFullYear(until.getUTCFullYear()+1);
 const localDate=(d)=>new Intl.DateTimeFormat('sv-SE',{timeZone:'Europe/Berlin',year:'numeric',month:'2-digit',day:'2-digit'}).format(d);
 const first=localDate(from),last=localDate(until);
 const rows=[];
 for(const [uid,g] of groups){
 const master=g.find(e=>!e.isRecurrenceException());
 const exceptions=g.filter(e=>e.isRecurrenceException());
 const add=(e,start,end,key)=>{
 if(e.component.getFirstPropertyValue("status")==="CANCELLED")return;
 if(!start||!end)throw Error("missing_dates");
 const a=iso(start),b=iso(end);
 if((a.endsWith("Z")?localDate(new Date(a)):a.slice(0,10))>last||(b.endsWith("Z")?localDate(new Date(b)):b.slice(0,10))<first)return;
 rows.push({uid,key,title:e.summary||"(Ohne Titel)",description:e.description||null,venue:e.location||null,start:a,end:b,all_day:start.isDate});
 };
 if(master && master.component.getFirstPropertyValue("status")!=="CANCELLED"){
 if(master.isRecurring()){
 for(const e of exceptions)master.relateException(e);
 const it=master.iterator();let n=0;
 while(true){const t=it.next();if(!t)break;if(++n>20000)throw Error("recurrence_limit");if(t.toString().slice(0,10)>until.toISOString().slice(0,10))break;
 const d=master.getOccurrenceDetails(t);add(d.item,d.startDate,d.endDate,t.toString());}
 }else add(master,master.startDate,master.endDate,"");
 }else if(!master){for(const e of exceptions)add(e,e.startDate,e.endDate,e.recurrenceId.toString());}
 }
 await sql.begin(async tx=>{
 const [current]=await tx`select * from public.calendar_sources where id=${s.id} for update`;
 if(!current?.active || current.feed_url!==s.feed_url || String(current.last_sync_at)!==String(s.last_sync_at))throw Error("source_changed");
 const stamp=new Date().toISOString();
 for(const e of rows)await tx`insert into public.events(title,description,venue,start_at,end_at,all_day,location_id,category_id,is_public,calendar_source_id,external_uid,external_recurrence_id,last_synced_at) values(${e.title},${e.description},${e.venue},case when ${e.start} ~ '(Z|[+-][0-9]{2}:[0-9]{2})$' then ${e.start}::timestamptz else ${e.start}::timestamp at time zone 'Europe/Berlin' end, greatest(case when ${e.end} ~ '(Z|[+-][0-9]{2}:[0-9]{2})$' then ${e.end}::timestamptz else ${e.end}::timestamp at time zone 'Europe/Berlin' end, (case when ${e.start} ~ '(Z|[+-][0-9]{2}:[0-9]{2})$' then ${e.start}::timestamptz else ${e.start}::timestamp at time zone 'Europe/Berlin' end)+interval '1 second'),${e.all_day},${current.location_id},${current.category_id},${current.is_public},${s.id},${e.uid},${e.key},${stamp}) on conflict(calendar_source_id,external_uid,external_recurrence_id) do update set title=excluded.title,description=excluded.description,venue=excluded.venue,start_at=excluded.start_at,end_at=excluded.end_at,all_day=excluded.all_day,location_id=excluded.location_id,category_id=excluded.category_id,is_public=excluded.is_public,last_synced_at=excluded.last_synced_at`;
 await tx`delete from public.events where calendar_source_id=${s.id} and last_synced_at is distinct from ${stamp}::timestamptz`;
 await tx`update public.calendar_sources set last_sync_at=${stamp},sync_status='ok' where id=${s.id}`;
 });
 results.push({id:s.id,count:rows.length,status:"ok"});
 }catch(e){console.error("calendar sync failed",s.id,e instanceof Error?e.name:"error");await sql`update public.calendar_sources set sync_status='error' where id=${s.id}`;results.push({id:s.id,status:"error"});}
 }
 return Response.json({results});
});