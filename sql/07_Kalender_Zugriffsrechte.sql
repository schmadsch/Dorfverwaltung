grant select,insert,update,delete on public.calendar_sources to authenticated;
grant all on public.calendar_sources to service_role;
create policy calendar_sources_admin on public.calendar_sources for all to authenticated using ((select public.is_admin())) with check ((select public.is_admin()));
grant select(calendar_source_id) on public.events to anon,authenticated;
create policy events_local_insert_guard on public.events as restrictive for insert to authenticated with check (calendar_source_id is null);
create policy events_local_update_guard on public.events as restrictive for update to authenticated using (calendar_source_id is null) with check (calendar_source_id is null);
create policy events_local_delete_guard on public.events as restrictive for delete to authenticated using (calendar_source_id is null);
-- Source visibility changes must immediately propagate to imported events.
create function public.calendar_source_visibility_update() returns trigger language plpgsql security definer set search_path = '' as $$
begin
 update public.events set is_public = new.is_public and new.active where calendar_source_id = new.id;
 return new;
end; $$;
revoke all on function public.calendar_source_visibility_update() from public,anon,authenticated;
create trigger calendar_source_visibility_update after update of is_public,active on public.calendar_sources for each row execute function public.calendar_source_visibility_update();
