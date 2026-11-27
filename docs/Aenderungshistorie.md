# Änderungshistorie
## 27.11.2026
- Ursprüngliche GitHub-Commits: Repository, Startseite, Supabase-Konfiguration, Client und Verbindungstest.
- Supabase-Schema, Zugriffsschutz, Stammdaten, Profiltrigger und Berechtigungstest aus Nutzerangaben rekonstruiert.
- SQL-Sicherung und Projektdokumentation angelegt; SQL-Formatierung gestrafft, Test-ID anonymisiert. Keine beabsichtigte Änderung der SQL-Logik.
- Keine Änderung an produktiver Datenbank oder Anwendungsdateien durch die Sicherung.
Künftige Änderungen mit Datum, betroffenen Dateien, Entscheidungen und offenen Tests dokumentieren. Git-Historie bleibt maßgeblich für Codeänderungen.

- Browser-Verbindungstest erfolgreich: vier Ortsoptionen und zehn farbcodierte Kategorien laut Screenshot geladen.

- Anforderungen präzisiert: externe Kalenderquellen und Benutzerkonten ausschließlich durch Admins verwalten; aktive Mitglieder dürfen auch fremde lokal verwaltete Termine bearbeiten und löschen. Mehrere Google-/ICS-Kalender vorgesehen. Nur Dokumentation aktualisiert; Umsetzung offen.

- Nutzer bestätigt: importierte Termine auch für Admins schreibgeschützt; Änderungen ausschließlich im Ursprungskalender.
