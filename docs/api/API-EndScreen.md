[Index](../Index.md) > [API](index.md) > end-screen

# end-screen

## Overview
Displays the game result (win/lose/quit) with final money and ports visited count. Called once from [`game.cbl`](API-Game.md) after the game loop exits.

## Sommaire

- [Data](#data)
- [Flow](#flow)
- [Error Handling](#error-handling)
- [Rules](#rules)

## Data

### LINKAGE (via COPY)

| Copybook | Direction | Usage |
|----------|-----------|-------|
| [`game-dat`](../data/game-dat.md) | IN | Read money, visited count, status for result display |

### Workspace

None.

## Flow

1. Clear the screen.
2. Check the final game status:
   - **Won**: display a congratulations message.
   - **Lost**: display a game-over message.
   - **Otherwise** (quit or unknown): display a farewell message.
3. Show the final money amount and the number of ports visited.

## Error Handling

None — pure display. All states are set before the call.

## Rules

- The end screen also clears the screen (cls) before displaying results.
- The `OTHER` case handles "QUIT" but also any unrecognized status — always displays a farewell message.
