BEGIN;

-- Benutzeranmeldung simulieren; Platzhalter durch Test-Benutzer-ID ersetzen.
SELECT set_config(
    'request.jwt.claim.sub',
    '00000000-0000-0000-0000-000000000000',
    true
);

SET LOCAL ROLE authenticated;

-- Berechtigungen pruefen
SELECT
    auth.uid() AS benutzer_id,
    public.is_active_member() AS aktives_mitglied,
    public.is_admin() AS administrator;

ROLLBACK;
