# 4L_Admin_Blips

Ein ESX-Skript, das Homeland-Spielern erlaubt, durch den Befehl `/pblips` **Live-Blips** aller anderen Spieler **nur auf ihrer eigenen Karte** zu sehen.

## 🧰 Abhängigkeiten

- ESX (mindestens v1 final oder höher)

## 🚀 Installation

1. Ordner `esx_pblips_local` in deinen `resources`-Ordner verschieben.
2. In die `server.cfg` eintragen:

```
ensure esx_pblips_local
```

3. Nur Spieler mit dem Job `Homeland` können `/pblips` verwenden.

## 🔁 Verhalten

- Aktiviert/Deaktiviert Live-Spieler-Blips alle 2 Sekunden (nur für den Nutzer sichtbar).
- Funktioniert über Entfernungen hinweg.
- Entfernt alle Blips bei Deaktivierung automatisch.

