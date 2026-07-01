[Index](../Index.md) > [API](index.md) > initialisation

# initialisation

## Overview
Sets initial game state, populates port/goods tables, generates random prices. Called once at game start from [`game.cbl`](API-Game.md).

## Sommaire

- [Data](#data)
- [Flow](#flow)
- [Output](#output)
- [Rules](#rules)

## Data

### LINKAGE (via COPY)

| Copybook | Direction | Usage |
|----------|-----------|-------|
| [`game-dat`](../data/game-dat.md) | OUT (write initial values) | Game state init: 120000 money, PLAYING status, zero fuel/cargo |
| [`port-dat`](../data/port-dat.md) | OUT (populate 5 ports) | Port names, descriptions, all visited=0 |
| [`gds-dat`](../data/gds-dat.md) | OUT (populate 5 goods) | Good names, base prices |
| [`pric-dat`](../data/pric-dat.md) | OUT (generate random prices) | 5×5 initial prices = base × (0.5 + RANDOM) |

### Workspace

| Variable | Level | Type | Usage |
|----------|-------|------|-------|
| `WS-I` | 01 | PIC 9(10) | Outer loop — port index (1-5) |
| `WS-J` | 01 | PIC 9(10) | Inner loop — good index (1-5) |

## Flow

1. Initialize game state ([`game-dat`](../data/game-dat.md)): starting money, first port, zero visited count, PLAYING status, empty fuel tank, cleared notification.
2. Reset cargo ([`game-dat`](../data/game-dat.md)): all quantities to zero.
3. Populate goods ([`gds-dat`](../data/gds-dat.md)) with names and base prices.
4. Populate ports ([`port-dat`](../data/port-dat.md)) with names and descriptions, all unvisited.
5. Generate initial prices ([`pric-dat`](../data/pric-dat.md)) for every port-good pair.

## Output

No DISPLAY — pure data initialization.

## Rules

- Prices are random each run — no seed control.
- Origin port (Shanghai) is NOT pre-marked visited; player must revisit it during navigation to reach the 5-visit win condition.
