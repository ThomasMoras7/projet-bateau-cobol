[Index](../Index.md) > [API](index.md) > game

# game

## Overview
Main program — game loop. Calls [`INITIALISATION`](API-Initialisation.md), optionally loads a saved game, then loops [`PORT-SCREEN`](API-PortScreen.md) until the game ends, then calls [`END-SCREEN`](API-EndScreen.md). Owns the save/load file I/O.

## Sommaire

- [Data](#data)
- [Flow](#flow)
- [Error Handling](#error-handling)
- [Rules](#rules)

## Data

### LINKAGE (via COPY)

| Copybook | Direction | Usage |
|----------|-----------|-------|
| [`game-dat`](../data/game-dat.md) | IN/OUT (status set to QUIT) | Money, port, fuel, cargo, status |
| [`port-dat`](../data/port-dat.md) | IN (passed through to subprograms) | Port names, visited flags |
| [`gds-dat`](../data/gds-dat.md) | IN (passed through to subprograms) | Good names, base prices |
| [`pric-dat`](../data/pric-dat.md) | IN (passed through to subprograms) | 5×5 price grid |

### Files

| File | Organization | Copybook | Usage |
|------|--------------|----------|-------|
| `data/GAME1.DAT` … `GAME5.DAT` | Sequential | [`save-dat`](../data/save-dat.md) | Save slots, one record per slot |

### Workspace

| Variable | Level | Type | Usage |
|----------|-------|------|-------|
| `WS-ACTION` | 01 | PIC 9(01) | Menu choice forwarded to PORT-SCREEN |
| `WS-ARG` | 01 | PIC 9(10) | Argument forwarded to PORT-SCREEN |
| `WS-SAVE-FILE-STATUS` | 01 | PIC XX | File status of the save file |
| `WS-SLOT-NUMBER` | 01 | PIC 9(01) | Currently selected slot (1-5) |
| `WS-FILE-NAME` | 01 | PIC X(30) | Built slot filename (`data/GAMEx.DAT`) |
| `WS-LOAD-CHOICE` | 01 | PIC 9(01) | Startup choice: load (1) or new game (0) |
| `WS-SLOT-OCCUPIED` | 01 | PIC X(01) OCCURS 5 | Per-slot occupied flag ('1' = has a save) |
| `WS-SAVE-COUNT` | 01 | PIC 9(01) | Number of occupied slots |
| `WS-VALID-SLOT-CHOSEN` | 01 | PIC 9(01) | Whether the chosen load slot is occupied |
| `WS-SLOT-INDEX` | 01 | PIC 9(10) | Loop index over the 5 slots |
| `WS-PRICE-INDEX` | 01 | PIC 9(10) | Flattened price grid index `(port-1)×5+good` |
| `WS-I`, `WS-J` | 01 | PIC 9(10) | Loop iteration indices |

## Flow

1. Initialize game state and tables via [`INITIALISATION`](API-Initialisation.md).
2. Scan slots 1-5 and mark each occupied one. If any save exists, list the occupied slots and ask the player whether to load and which slot; if yes, restore the saved state via `LOAD-GAME` (overwrites the mutable state set by initialization). Only occupied slots are accepted.
3. Repeatedly show the current port via [`PORT-SCREEN`](API-PortScreen.md) and process the player's choices.
4. Menu option 5 (Save) prompts for a slot (0 = cancel) via `ASK-SAVE-SLOT` and writes the state via `SAVE-GAME`. Menu option 6 (Load) re-scans the slots, lists the occupied ones, asks which slot to restore, and loads it via `LOAD-GAME`; if no save exists it shows "Aucune sauvegarde disponible." and returns to the menu.
5. On quit, the player is asked whether to save; `ASK-SAVE-SLOT` prompts for a slot (0 = no save) and `SAVE-GAME` writes the state, then the game status is set to QUIT.
6. Once the loop ends (win, lose, or quit), display the result via [`END-SCREEN`](API-EndScreen.md).
7. Terminate.

## Error Handling

| Condition | Behavior |
|-----------|----------|
| `WS-SAVE-FILE-STATUS = "35"` on load | Display "Slot vide." — the fresh initialized state stays active |
| `WS-SAVE-FILE-STATUS` other than "00" on read | Display "Lecture impossible." and close the file |
| `WS-SAVE-FILE-STATUS` other than "00" on save open | Display "Echec de l'ouverture du fichier." — the file is neither written nor closed |
| `WS-SAVE-FILE-STATUS` other than "00" on save write | Display "Echec de l'ecriture de la sauvegarde." and close the file |
| `WS-SAVE-COUNT = 0` | No prompt — the game starts fresh from initialization |
| Load requested but `WS-SAVE-COUNT = 0` | Display "Aucune sauvegarde disponible." and return to the menu |
| Load slot chosen but not occupied | Display "Ce slot est vide." and re-prompt |

## Rules

- `INITIALISATION` always runs first: it provides the static tables (port names, goods) that are not stored in the save record. Loading only overwrites the mutable state.
- The price grid is stored flattened (port-major) in `WS-SAVE-GOODS-PRICES(1..25)`.
- Quit is the only action handled by the main program itself — all other actions (navigation, buy, sell, refuel, lose condition, win condition) are processed inside [`PORT-SCREEN`](API-PortScreen.md).
- Saving opens the file with `OUTPUT` (create/overwrite), loading with `INPUT`. A slot is skipped without closing if the open fails.
