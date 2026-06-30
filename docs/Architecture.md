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
│   ├── game.cbl            # Main — loop, quit check
│   ├── initialisation.cbl  # Init state + prices
│   ├── port-screen.cbl     # Port display, menu, buy/sell/refuel/navigate
│   ├── end-screen.cbl      # Win/lose/quit screen
│   └── copybooks/
│       ├── game-dat        # WS-GAME-DATA (LINKAGE structure)
│       ├── port-dat        # WS-PORT-TABLE (5 ports)
│       ├── gds-dat         # WS-GOODS-LIST (5 goods, base prices)
│       └── pric-dat        # WS-GOODS-PRICES-LIST (5×5 price grid)
│
├── bin/boat-game.exe       # Build output (gitignored)
│
├── gnu-cobol/              # Portable GnuCOBOL 3.2.0 MinGW (gitignored)
│
├── docs/                   # Wiki
└── src/[legacy]            # Archived banking programs (git history)
```

## Data flow

```
game.cbl
  ├── CALL INITIALISATION (game-data, port-table, goods-list, prices-list)
  │      → money=120000, port=1, fuel=0, cargo empty, goods 1..5, ports 1..5, random prices
  ├── LOOP (until status ≠ "PLAYING"):
  │     ├── CALL PORT-SCREEN (action, arg, game-data, port-table, goods-list, prices-list)
  │     │      → displays port screen, handles menu, returns action+arg
  │     ├── IF action = 0 → MOVE "QUIT" TO status
  │     └── (loop back)
  ├── CALL END-SCREEN (game-data) → displays result
  └── STOP RUN
```

## Module interfaces

| Subprogram | Parameters | Role |
|---|---|---|
| `INITIALISATION` | `GAME-DATA`, `PORT-TABLE`, `GOODS-LIST`, `GOODS-PRICES-LIST` | Set initial values, populate tables, generate random prices |
| `PORT-SCREEN` | `ACTION`, `ARG`, `GAME-DATA`, `PORT-TABLE`, `GOODS-LIST`, `GOODS-PRICES-LIST` | Display screen, handle menu (buy/sell/refuel/navigate), validate input |
| `END-SCREEN` | `GAME-DATA` | Display win/lose/quit result |

Navigation logic (fuel check, port move, visited marking, price fluctuation, win check) lives inside `PORT-SCREEN`. `game.cbl` only loops and intercepts quit.

## Design principles

- **Single executable**: all modules compiled together via `cobc -x game.cbl mod1.cbl ...`
- **No data files in RUN 1**: state is purely in-memory
- **`cls` screen clears**: both `port-screen.cbl` and `end-screen.cbl` call `CALL "SYSTEM" USING "cls"` for readability

## Legacy

Archived banking architecture at [legacy/LegacyArchitecture.md](legacy/LegacyArchitecture.md).
