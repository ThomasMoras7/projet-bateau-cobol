[Index](../Index.md) > [Data](index.md) > port-dat

# `port-dat` — WS-PORT-TABLE

5 port entries.

## Structure

| Field | Level | PIC | Usage |
|-------|-------|-----|-------|
| `WS-PORT-ENTRY` | 05 | OCCURS 5 | — |
| `WS-PORT-ID` | 10 | 9(10) | 1-5 |
| `WS-PORT-NAME` | 10 | X(20) | Display name (`"Shanghai (Chine)"` etc.) |
| `WS-PORT-DESCRIPTION` | 10 | X(60) | Flavor text |
| `WS-PORT-VISITED` | 10 | X(01) | `"1"` if visited, SPACES otherwise |

## Ports

| ID | Name | Description |
|----|------|-------------|
| 1 | Shanghai (Chine) | Le plus grand port du monde. Trafic non-stop. |
| 2 | Rotterdam (Pays-Bas) | Porte d'entree de l'Europe. Attention aux ecluses. |
| 3 | Singapour (Singapour) | Plateforme asiatique ultramoderne. Taxes ultra basses. |
| 4 | New York (Etats-Unis) | La statue de la Liberte veille sur les bateaux. |
| 5 | Marseille (France) | Le premier port de France. Le pastis coule a flots. |
