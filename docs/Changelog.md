# Changelog

## v1.1.0 — RUN 2 : Save / Load System

### Added
- 5 save slots: `data/GAME1.DAT` … `GAME5.DAT` (sequential files, one record per slot)
- `save-dat` copybook for the save record (money, port, fuel, cargo, visited flags, flattened price grid)
- Occupied-slot detection and listing at startup
- Load prompt at startup; menu options 5 (Save) and 6 (Load); save prompt on quit
- File-status handling on save open/write and load open/read (including "35" file-not-found)
- `ASK-SAVE-SLOT` paragraph shared by the quit and menu save flows

### Improved
- `test-game.ps1` clears `data/GAME*.DAT` at start and after each save test to avoid interference
- Test suite extended: 4 save/load integration tests (menu save + file check, startup load, mid-game load, no-save message) and automatic slot cleanup between runs

## v1.0.0 — RUN 1 : Navigation Basics

### Added
- Full game loop with start, port interactions, and end screen
- Port menu: buy goods, sell goods, refuel, navigate to next port
- 5 ports to visit (Shanghai, Rotterdam, Singapour, New York, Marseille)
- 5 goods to trade (Cafe, Coton, Epices, Vin, Electronique)
- Fuel system: costs 50 000$ to fill, required before each departure
- Win condition: visit all 5 ports
- Lose condition: stranded with empty tank and less than 50 000$
- Automated test suite with 10 edge cases and adaptive WIN strategy
- One-command build script

### Improved
- Screen output switched to stdout — now works correctly with Windows pipes
- All variable names made self-documenting (full words, no abbreviations)
- Test suite handles ANSI escape codes from screen clears, V99 decimal display, and adaptive retry logic

### Changed
- Non-standard `ELSE IF` replaced with standard COBOL nested `ELSE`/`IF`/`END-IF`

## v0.2.0 — Account Operations (banking prototype, superseded)

### Added
- Bank account search and money transfer between accounts
- Build script

### Improved
- Documentation structure (wiki index, features, architecture)

## v0.1.0 — Initial Prototype (banking, superseded)

### Added
- Account CRUD, portable GnuCOBOL 3.2.0 environment, project wiki in `docs/`
