# Features

## Run 1 — Navigation (Prologue)

### Game Lifecycle
- Title screen, always fresh start (no save/load)
- No file I/O — everything in memory

### Goods Trading
- 5 types of goods with per-port prices
- Prices randomized at game start from base values (±50 %)
- Prices fluctuate on each departure (±10 %)
- Buy at current port, sell at destination

### Port Navigation
- 5 fixed ports, each with name + flavor description
- Display current port info + list of reachable ports
- Navigate to any port in one turn
- First visit marked as "new port!"

### Fuel
- Each journey costs 30 in fuel
- Fuel deducted when departing
- Lose if you can't afford fuel

### Win/Lose
- Win: visit all 5 ports
- Lose: money < 30 when trying to depart (can't afford fuel)
- Game over screen with result message

## Run 2 — Commerce + Persistence

*See API-Run2.md for details*

- Save/load game state
- Delivery contracts between ports
- Economy: money tracking, treasury
- Win condition: 5 profitable deliveries
- Lose condition: bankruptcy

## Run 3 — Fleet

*See API-Run3.md for details*

- Ship data model, shipyard module
- Multiple ships, fleet management
- Ship acquisition / maintenance

## Run 4 — Full Integration

*See API-Run4.md for details*

- UI polish, balance tuning
- Difficulty modes

## Portable Environment

- Self-contained GnuCOBOL 3.2.0 distribution
- Single PowerShell script sets up PATH and compiler variables
- No system-wide installation required

---
**Legacy** — Archived banking features at [LegacyFeatures.md](legacy/LegacyFeatures.md).
