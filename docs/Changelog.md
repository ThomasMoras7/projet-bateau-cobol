# Changelog

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
- Create, delete, and list bank accounts
- Portable GnuCOBOL 3.2.0 environment with automatic data file creation
- Project wiki in `docs/`
