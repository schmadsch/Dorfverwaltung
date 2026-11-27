# Dorfverwaltung

Gemeinsame Verwaltung Kleinopitz, Braunsdorf und Oberhermsdorf.

- [Homepage](https://schmadsch.github.io/Dorfverwaltung/index.html)
- [Supabase-Verbindungstest](https://schmadsch.github.io/Dorfverwaltung/test.html)

## Projektstand (27.11.2026)
GitHub Pages mit HTML/CSS/JavaScript, Supabase als Datenbank und Auth-Backend. Startseite und Verbindungstest implementiert; eigentliche Fachmodule noch in Vorbereitung.

## Dokumentation
- [Projektbeschreibung](docs/Projektbeschreibung.md)
- [Datenbankstruktur](docs/Datenbankstruktur.md)
- [Berechtigungskonzept](docs/Berechtigungskonzept.md)
- [Entwicklungsstand](docs/Entwicklungsstand.md)
- [Offene Aufgaben](docs/Offene_Aufgaben.md)
- [Änderungshistorie](docs/Aenderungshistorie.md)

## SQL-Sicherung
Die Skripte wurden aus den bereitgestellten Supabase-Skripten rekonstruiert und in der Formatierung gestrafft.
1. [Datenbankstruktur](sql/01_Datenbankstruktur.sql)
2. [Zugriffsrechte](sql/02_zugriffsrechte.sql)
3. [Stammdaten](sql/03_Stammdaten.sql)
4. [Benutzerverwaltung](sql/04_Benutzerverwaltung.sql)
5. [Berechtigungstest](sql/05_Berechtigungstest.sql)

01–04 sind für den initialen Aufbau eines neuen Supabase-Projekts vorgesehen, nicht blind in der bestehenden Datenbank erneut ausführen. Für 05 die Platzhalter-UUID durch eine lokale Test-Benutzer-ID ersetzen. Der Test endet mit ROLLBACK. Auth-Einstellungen, tatsächliche Benutzer, Administratorfreischaltung und produktive Daten müssen separat gesichert bzw. eingerichtet werden.

## Weiterarbeiten
Zuerst den Entwicklungsstand und offene Aufgaben lesen, dann Verbindungstest bestätigen. Bei Änderungen Dokumentation und SQL-Migrationen mitpflegen. Keine Passwörter, geheimen Schlüssel oder personenbezogenen Daten in diesem öffentlichen Repository speichern.
