[Index](../Index.md) > [API](index.md) > game

# game

## Overview
Main program — game loop. Calls [`INITIALISATION`](API-Initialisation.md), then loops [`PORT-SCREEN`](API-PortScreen.md) until the game ends, then calls [`END-SCREEN`](API-EndScreen.md).

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

### Workspace

| Variable | Level | Type | Usage |
|----------|-------|------|-------|
| `WS-ACTION` | 01 | PIC 9(01) | Menu choice forwarded to PORT-SCREEN |
| `WS-ARG` | 01 | PIC 9(10) | Argument forwarded to PORT-SCREEN |

## Flow

1. Initialize game state and tables via [`INITIALISATION`](API-Initialisation.md).
2. Repeatedly show the current port via [`PORT-SCREEN`](API-PortScreen.md) and process the player's choices. If the player chooses to quit, the game status becomes QUIT.
3. Once the loop ends (win, lose, or quit), display the result via [`END-SCREEN`](API-EndScreen.md).
4. Terminate.

## Error Handling

No error handling — [`PORT-SCREEN`](API-PortScreen.md) validates all inputs internally. The main program only intercepts the quit action.

## Rules

- Quit is the only action handled by the main program itself — all other actions (navigation, buy, sell, refuel, lose condition, win condition) are processed inside [`PORT-SCREEN`](API-PortScreen.md).
