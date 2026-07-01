[Index](../Index.md) > [Data](index.md) > game-dat

# `game-dat` — WS-GAME-DATA

Game state shared between all modules (LINKAGE).

## Structure

| Field | Level | PIC | Usage |
|-------|-------|-----|-------|
| `WS-MONEY` | 05 | S9(10)V99 | Current treasury (120000 start) |
| `WS-CURRENT-PORT` | 05 | 9(10) | Current port ID (1-5) |
| `WS-VISITED-PORTS-COUNT` | 05 | 9(10) | Distinct ports visited |
| `WS-STATUS` | 05 | X(10) | `"PLAYING"` / `"WON"` / `"LOST"` / `"QUIT"` |
| `WS-FUEL-FLAG` | 05 | 9(01) | 0=empty, 1=full |
| `WS-NOTIFICATION` | 05 | X(60) | Notification message |
| `WS-CARGO-QUANTITY` | 05 | 9(10) OCCURS 5 | Cargo per good |

## Notification lifecycle

After each action (buy/sell/refuel/navigate), a message is queued in `WS-NOTIFICATION`. On the next screen render, it is displayed once then automatically cleared. One-shot — each message is shown exactly once.
