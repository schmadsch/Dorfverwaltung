# Offene Aufgaben
## Unmittelbar
- [x] Browser-Verbindungstest bestätigt (4 Ortsoptionen, 10 Kategorien).
- [ ] RLS/API mit anonymen, inaktiven, aktiven und Admin-Benutzern testen.
- [ ] Auth-Konfiguration und Anmeldung prüfen.
## Terminverwaltung (vorgeschlagene Reihenfolge)
- [ ] Öffentliche Terminübersicht, Kalender, Orts- und Kategoriefilter.
- [ ] Anmeldung und geschützter Mitgliederbereich.
- [ ] Termine erstellen, bearbeiten, löschen.
- [ ] Admin-Oberfläche für Freischaltung und Stammdaten; Schutz des letzten Admins.
- [ ] Kalenderabonnement (ICS; technische Bereitstellung klären).
- [ ] Zeitzone Europe/Berlin und ganztägige Termine konsistent behandeln.
- [ ] Änderungsverfolgung / letzten Bearbeiter bei Bedarf ergänzen.
## Später
- [ ] Inventar, Lagerorte, Ansprechpartner.
- [ ] Ressourcenbuchung und Verfügbarkeit.
- [ ] Separates vertrauliches Backup der tatsächlichen Datenbank und Auth-Konfiguration planen.

## Ergänzte Anforderungen
- [ ] Öffentliche Selbstregistrierung in Supabase deaktivieren.
- [ ] Geschützte Admin-Funktion für Anlegen und Löschen von Auth-Konten implementieren.
- [ ] Mehrere externe Kalender über Google-iCal-/ICS-URLs einbinden; Verwaltung ausschließlich durch Admins.
- [ ] Serverseitige Synchronisierung, sichere URL-Speicherung, Dubletten- und Serienbehandlung; Zugriffsschutz und Schutz vor unsicheren Abrufzielen.
- [ ] Schreibschutz importierter Termine mit Nutzer bestätigen und serverseitig durchsetzen.
