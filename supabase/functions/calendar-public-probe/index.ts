import ICAL from "npm:ical.js@2.2.1";
Deno.serve(async (req) => {
 if(req.method!=="GET") return new Response("Method not allowed",{status:405});
 try {
 const r=await fetch("https://calendar.google.com/calendar/ical/ffwbraunsdorf%40gmail.com/public/basic.ics",{signal:AbortSignal.timeout(15000),redirect:"error"});
 if(!r.ok) return Response.json({reachable:false,http_status:r.status});
 const raw=await r.text();
 const cal=new ICAL.Component(ICAL.parse(raw));
 const events=cal.getAllSubcomponents("vevent");
 const matches=[];
 for(const component of events){
 const e=new ICAL.Event(component);
 const it=e.iterator();
 for(let i=0;i<20000;i++){
 const t=it.next(); if(!t)break;
 const date=t.toString();
 if(date.slice(0,10)>"2026-11-28")break;
 if(date.slice(0,10)>="2026-11-26") matches.push({title:e.summary,start:date,timezone:t.zone.tzid});
 }
 }
 return Response.json({reachable:true,http_status:r.status,components:events.length,matches});
 }catch(e){return Response.json({reachable:false,error:String(e)}, {status:502});}
});