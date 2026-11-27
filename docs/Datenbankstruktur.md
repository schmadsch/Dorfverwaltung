# Datenbankstruktur
Stand 27.11.2026, aus den bereitgestellten SQL-Skripten rekonstruiert.
Maßgeblich: [SQL 01](../sql/01_Datenbankstruktur.sql).
- locations: bigint identity PK, name eindeutig, active.
- categories: bigint identity PK, name eindeutig, color (#RRGGBB), active.
- profiles: UUID PK/FK auth.users (CASCADE), display_name, role member/admin, active, created_at, updated_at.
- events: UUID PK, title, description, start_at/end_at (timestamptz, Ende > Beginn), all_day, venue, organizer, location_id und category_id (optionale FK), is_public, created_by (auth.users, SET NULL), created_at, updated_at.
Indizes: Beginn, Ende, Ortschaft, Kategorie, Ersteller. Trigger aktualisieren updated_at in events und profiles.
Stammdaten: vier Ortsoptionen und zehn farbcodierte Kategorien, siehe SQL 03.
Keine Live-Datenbanksicherung: weder Nutzerdaten noch Termine oder Auth-Konfiguration exportiert.
