[Index](Index.md) > Architecture

# Architecture

## Project layout

```
Projet Bateau/
├── setup_env.ps1           # Env init (PATH, COB_* vars)
├── build-game.ps1          # Build: cobc -x game.cbl + subprograms → boat-game.exe
├── test-game.ps1           # Integration test suite
├── AGENTS.md               # Agent instructions
│
├── src/                    # COBOL sources
│   ├── game.cbl            # Main — loop, quit check, save/load file I/O
│   ├── initialisation.cbl  # Init state + prices
│   ├── port-screen.cbl     # Port display, menu, buy/sell/refuel/navigate
│   ├── end-screen.cbl      # Win/lose/quit screen
│   ├── *.cbl (banking)     # Archived, superseded programs (kept on disk)
│   └── copybooks/
│       ├── game-dat        # WS-GAME-DATA (LINKAGE structure)
│       ├── port-dat        # WS-PORT-TABLE (5 ports)
│       ├── gds-dat         # WS-GOODS-LIST (5 goods, base prices)
│       ├── pric-dat        # WS-GOODS-PRICES-LIST (5×5 price grid)
│       └── save-dat        # WS-SAVE-RECORD (one save slot record)
│
├── data/                   # Runtime save slots GAME1.DAT … GAME5.DAT (gitignored)
├── bin/boat-game.exe       # Build output (gitignored)
│
├── gnu-cobol/              # Portable GnuCOBOL 3.2.0 MinGW (gitignored)
│
└── docs/                   # Wiki (api/, data/, jcl/, legacy/)
```

## Data flow

```
game.cbl
  ├── CALL INITIALISATION (game-data, port-table, goods-list, prices-list)
  │      → money=120000, port=1, fuel=0, cargo empty, goods 1..5, ports 1..5, random prices
  ├── CHECK-EXISTING-SAVES → marks occupied slots (data/GAME1.DAT … GAME5.DAT)
  ├── IF a save exists → DISPLAY-SAVE-LIST + load prompt
  │     ├── ASK-LOAD-SLOT (occupied slots only) → LOAD-GAME
  │     └── "new game" → keep INITIALISATION state
  ├── LOOP (until status ≠ "PLAYING"):
  │     ├── CALL PORT-SCREEN (action, arg, game-data, port-table, goods-list, prices-list)
  │     │      → displays port screen, handles menu, returns action+arg
  │     ├── action 0 → ASK-SAVE-SLOT (optional save) → MOVE "QUIT" TO status
  │     ├── action 5 → ASK-SAVE-SLOT → SAVE-GAME
  │     ├── action 6 → CHECK-EXISTING-SAVES → DISPLAY-SAVE-LIST → ASK-LOAD-SLOT → LOAD-GAME
  │     └── (loop back)
  ├── CALL END-SCREEN (game-data) → displays result
  └── STOP RUN
```

Save/load paragraphs live in `game.cbl` (see [API-Game](api/API-Game.md)).

## Module interfaces

| Subprogram | Parameters | Role |
|---|---|---|
| `INITIALISATION` | `GAME-DATA`, `PORT-TABLE`, `GOODS-LIST`, `GOODS-PRICES-LIST` | Set initial values, populate tables, generate random prices |
| `PORT-SCREEN` | `ACTION`, `ARG`, `GAME-DATA`, `PORT-TABLE`, `GOODS-LIST`, `GOODS-PRICES-LIST` | Display screen, handle menu (buy/sell/refuel/navigate), validate input, pass save/load choices through to the caller |
| `END-SCREEN` | `GAME-DATA` | Display win/lose/quit result |

Navigation logic (fuel check, port move, visited marking, price fluctuation, win check) lives inside `PORT-SCREEN`. `game.cbl` only loops, intercepts quit, and handles save/load.

## Design principles

- **Single executable**: all modules compiled together via `cobc -x game.cbl mod1.cbl ...`
- **In-memory state while playing**: mutable game state lives in `WS-GAME-DATA`; static tables (ports, goods) are rebuilt by `INITIALISATION` on load
- **Save slots**: 5 sequential files `data/GAME1.DAT` … `GAME5.DAT`, one record per slot, `save-dat` layout
- **`cls` screen clears**: both `port-screen.cbl` and `end-screen.cbl` call `CALL "SYSTEM" USING "cls"` for readability

## Legacy

Archived banking architecture at [legacy/LegacyArchitecture.md](legacy/LegacyArchitecture.md).
