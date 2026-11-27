# Berechtigungskonzept
RLS auf allen vier Tabellen, zunächst Entzug der Tabellenrechte, anschließend gezielte Grants und Policies (SQL 01/02).
| Funktion | Besucher | Inaktiver Benutzer | Aktives Mitglied | Aktiver Admin |
|---|---|---|---|---|
| Öffentliche Termine / aktive Stammdaten lesen | ja | ja | ja | ja |
| Interne Termine / inaktive Stammdaten lesen | nein | nein | ja | ja |
| Alle Termine erstellen/bearbeiten/löschen | nein | nein | ja | ja |
| Eigenes Profil lesen | nein | ja | ja | ja |
| Stammdaten und Profile verwalten | nein | nein | nein | ja |

Neue Auth-Benutzer erhalten automatisch ein inaktives member-Profil (SQL 04). Administratoren schalten frei. created_by wird automatisch aus auth.uid() gesetzt. Interne IDs und Zeitstempel von events sind nicht für API-SELECT freigegeben; explizite Spaltenliste statt SELECT *.
is_active_member() und is_admin() sind SECURITY DEFINER mit leerem search_path und EXECUTE nur für authenticated.
Admin-Simulation ergab true/true laut bereitgestelltem Screenshot. Vollständige RLS- und API-Tests stehen aus; insbesondere anonyme Zugriffe, inaktive Nutzer, aktive Mitglieder, geschützte Spalten und Schreiboperationen prüfen. Letzten Admin vor versehentlicher Deaktivierung schützen (noch nicht implementiert).

## Verbindliche Anforderungen zur weiteren Umsetzung
Keine öffentliche Selbstregistrierung. Nur Administratoren dürfen Auth-Benutzerkonten anlegen und löschen sowie externe Kalenderquellen hinzufügen, ändern und entfernen. Aktive Mitglieder dürfen sämtliche eigenen und fremden lokal verwalteten Termine anlegen, bearbeiten und löschen. Importierte Termine sind für alle Benutzer einschließlich Administratoren schreibgeschützt; Änderungen erfolgen ausschließlich im Ursprungskalender. Admin-Operationen für Auth-Konten serverseitig mit geprüfter Admin-Rolle durchführen; keine geheimen Schlüssel im Frontend. Selbstregistrierung in Supabase deaktivieren (noch offen).
