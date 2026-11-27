BEGIN;
CREATE FUNCTION public.is_active_member()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = ''
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.profiles WHERE id = auth.uid() AND active = true
    );
$$;
CREATE FUNCTION public.is_admin()
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER SET search_path = ''
AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.profiles WHERE id = auth.uid() AND active = true AND role = 'admin'
    );
$$;
REVOKE ALL ON FUNCTION public.is_active_member() FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.is_admin() FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.is_active_member() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT ON public.locations, public.categories TO anon, authenticated;
GRANT INSERT, UPDATE, DELETE ON public.locations, public.categories TO authenticated;
GRANT USAGE ON SEQUENCE public.locations_id_seq, public.categories_id_seq TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.profiles TO authenticated;
GRANT SELECT (id, title, description, start_at, end_at, all_day, venue, organizer, location_id, category_id, is_public) ON public.events TO anon, authenticated;
GRANT INSERT (title, description, start_at, end_at, all_day, venue, organizer, location_id, category_id, is_public) ON public.events TO authenticated;
GRANT UPDATE (title, description, start_at, end_at, all_day, venue, organizer, location_id, category_id, is_public) ON public.events TO authenticated;
GRANT DELETE ON public.events TO authenticated;
CREATE POLICY events_public_read ON public.events FOR SELECT TO anon, authenticated USING (is_public = true);
CREATE POLICY events_member_read ON public.events FOR SELECT TO authenticated USING (public.is_active_member());
CREATE POLICY events_member_insert ON public.events FOR INSERT TO authenticated WITH CHECK (public.is_active_member() AND created_by = auth.uid());
CREATE POLICY events_member_update ON public.events FOR UPDATE TO authenticated USING (public.is_active_member()) WITH CHECK (public.is_active_member());
CREATE POLICY events_member_delete ON public.events FOR DELETE TO authenticated USING (public.is_active_member());
CREATE POLICY locations_public_read ON public.locations FOR SELECT TO anon, authenticated USING (active = true);
CREATE POLICY locations_member_read ON public.locations FOR SELECT TO authenticated USING (public.is_active_member());
CREATE POLICY locations_admin_manage ON public.locations FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY categories_public_read ON public.categories FOR SELECT TO anon, authenticated USING (active = true);
CREATE POLICY categories_member_read ON public.categories FOR SELECT TO authenticated USING (public.is_active_member());
CREATE POLICY categories_admin_manage ON public.categories FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
CREATE POLICY profiles_own_read ON public.profiles FOR SELECT TO authenticated USING (id = auth.uid());
CREATE POLICY profiles_admin_manage ON public.profiles FOR ALL TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
COMMIT;
