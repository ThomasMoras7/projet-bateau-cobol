# Architecture

## Project Hierarchy

```
Projet Bateau/
├── README.md                  # Game description, quick start
├── setup_env.ps1              # Env initializer (PATH, COB_* vars) — shared
├── build-game.ps1              # Build script for game
├── .gitignore                 # Excludes exe, obj, gnu-cobol/, .vscode/
├── LICENSE
│
├── gnu-cobol/                 # Portable GnuCOBOL 3.2.0 (gitignored)
│
├── src/                       # COBOL source files
│   ├── [game]
│   │   ├── game.cbl               #   Main program — game loop
│   │   ├── initialisation.cbl     #   Initialize game state + prices
│   │   ├── port-screen.cbl        #   Port screen: display, market, navigation
│   │   ├── end-screen.cbl         #   Win/lose end screen
│   │   ├── copybooks/
│   │   │   ├── port-dat           #   Port table in WORKING-STORAGE
│   │   │   ├── game-rec           #   Game save record (RUN 2+)
│   │   │   ├── game-dat          #   Game state shared between modules
│   │   │   ├── gds-dat           #   Goods list (5 goods with base prices)
│   │   │   └── pric-dat          #   Goods prices grid (5 ports × 5 goods)
│   │   │   ├── acc-rec            #   Legacy (banking)
│   │   │   └── tran-rec           #   Legacy (banking)
│   │
│   └── [legacy] — superseded, git history preserves it
│       ├── account-creation.cbl
│       ├── account-deletion.cbl
│       ├── account-list.cbl
│       ├── history-list.cbl
│       ├── search-account-balance.cbl
│       ├── transfer-money.cbl
│       └── build.ps1
│
├── bin/                       # Build output
│   ├── boat-game.exe          #   (gitignored)
│   ├── PORTS.DAT              #   Indexed port records (RUN 2+)
│   └── GAME.DAT               #   Sequential game save (RUN 2+)
│
└── docs/                      # Project wiki
    ├── Index.md
    ├── GameDesign.md
    ├── Features.md
    ├── Architecture.md
    ├── DataStructure.md
    ├── API.md
    ├── API-Run1.md
    ├── API-Run2.md
    ├── API-Run3.md
    ├── API-Run4.md
    └── Changelog.md
```

## Design Principles

- **Main + subprograms** (provisional) : currently split into modules for clarity.
- **Single executable** : all modules compiled together via `cobc -x main.cbl mod1.cbl ...` into one `.exe`
- **No `.DAT` files in RUN 1** : state is purely in-memory. Persistence is planned for RUN 2+.

## Data Flow (RUN 1)

```
game (main)
  ├── CALL initialisation(game-data, port-table, goods-list, goods-prices)
  │      → sets money, port, visited, status; populates port table + goods + prices
  ├── LOOP (until status != "PLAYING"):
  │     ├── CALL port-screen(action, arg, game-data, port-table, goods-list, goods-prices)
  │     │      → user selects action; for navigation, also reads destination
  │     ├── IF action = 0 → status = "QUIT"
  │     └── (loop back)
  ├── CALL end-screen(game-data)
  │      → displays win/lose/quit message based on status
  └── STOP RUN
```

## Module Interfaces (RUN 1)

| Subprogram | Parameters (USING) | Description |
|------------|-------------------|-------------|
| `INITIALISATION` | `GAME-DATA`, `PORT-TABLE`, `GOODS-LIST`, `GOODS-PRICES-LIST` | Sets initial state + generates prices + populates all data |
| `PORT-SCREEN` | `ACTION`, `ARG`, `GAME-DATA`, `PORT-TABLE`, `GOODS-PRICES-LIST` | Display port + goods + destinations ; buy/sell ; pick destination |
| `END-SCREEN` | `GAME-DATA` | Win/lose/quit screen based on WS-STATUS |

Travel narrative is inline in the main loop (no separate module needed).

---
**Legacy** — Archived banking architecture at [LegacyArchitecture.md](legacy/LegacyArchitecture.md).
