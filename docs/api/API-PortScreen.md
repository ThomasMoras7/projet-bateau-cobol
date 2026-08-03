[Index](../Index.md) > [API](index.md) > port-screen

# port-screen

## Overview
Handles all port interaction: display, menu, buy/sell/refuel/navigate. Called in a loop from [`game.cbl`](API-Game.md) until the game ends. The action and argument variables serve as return values to the caller. Also sets the game status to LOST or WON directly when conditions are met.

## Sommaire

- [Data](#data)
- [Procedure](#procedure)
- [Flow](#flow)
- [Error Handling](#error-handling)
- [Rules](#rules)

## Data

### LINKAGE (via COPY)

| Copybook | Direction | Usage |
|----------|-----------|-------|
| [`game-dat`](../data/game-dat.md) | IN/OUT | Money, port, fuel, cargo, status, notifications |
| [`port-dat`](../data/port-dat.md) | IN/OUT | Port display, visited marking |
| [`gds-dat`](../data/gds-dat.md) | IN | Good names for display |
| [`pric-dat`](../data/pric-dat.md) | IN/OUT | Price display, fluctuation |

### Parameters

| Name | Level | PIC | Direction | Usage |
|------|-------|-----|-----------|-------|
| `WS-ACTION` | 01 | 9(01) | IN/OUT | Menu choice (read via ACCEPT, returned to caller) |
| `WS-ARG` | 01 | 9(10) | IN/OUT | Argument (destination port, product ID, etc.) |

### Workspace

| Variable | Level | Type | Usage |
|----------|-------|------|-------|
| `WS-GOODS-INDEX` | 01 | PIC 9(10) | Loop counter — goods display |
| `WS-PORT-INDEX` | 01 | PIC 9(10) | Loop counter — port list |
| `WS-I` | 01 | PIC 9(10) | Loop counter — price fluctuation (port) |
| `WS-J` | 01 | PIC 9(10) | Loop counter — price fluctuation (good) |
| `WS-PRICE` | 01 | PIC 9(10) | Computed total price during buy/sell |
| `WS-EXIT-FLAG` | 01 | PIC 9(01) | Input validation loop flag |
| `WS-QUANTITY` | 01 | PIC 9(10) | Quantity for buy/sell |
| `WS-CLS-COMMAND` | 01 | PIC X(03) | `"cls"` for `CALL "SYSTEM"` (screen clear) |

## Procedure

Six handlers, dispatched from the main flow:

| Paragraph | Role | Arguments |
|-----------|------|-----------|
| `PROCESS-NAVIGATION` | Select destination, move ship, mark visited, fluctuate prices, check win | `WS-ARG`=destination |
| `BUY-GOODS` | Let the player purchase goods at current port prices | `WS-ARG`=product |
| `SELL-GOODS` | Let the player sell goods from their cargo | `WS-ARG`=product |
| `DISPLAY-PORTS-LIST` | Show reachable ports, let the player pick a destination | `WS-ARG`=destination (called from PROCESS-NAVIGATION) |
| `DISPLAY-GOODS-TABLE` | Render the current port's price list | none |
| `FLUCTUATE-PRICES` | Randomise all 5×5 prices | none |

### PROCESS-NAVIGATION

**Arguments**: `WS-ARG` = destination port ID (1-5)

The player selects a destination from a list of reachable ports. The fuel tank is emptied, the ship moves to the chosen port, and if it is a new port it is marked visited. All goods prices fluctuate randomly. An arrival notification is queued. If all five ports have now been visited, the game status is set to won.

### BUY-GOODS

**Arguments**: `WS-ARG` = product ID (1-5, 0 = cancel)

The current port's price table is displayed. The player picks a product and a quantity. If they can afford the total cost, the money is deducted and the goods are added to the cargo. Otherwise an insufficient-funds notification is shown.

### SELL-GOODS

**Arguments**: `WS-ARG` = product ID (1-5, 0 = cancel)

The player's cargo is displayed (only goods with non-zero quantity). The player picks a product and a quantity. If they hold enough units, the sale value is added to their money and the cargo is reduced. Otherwise an error notification is shown.

### DISPLAY-PORTS-LIST

**Arguments**: `WS-ARG` receives the chosen destination (called from PROCESS-NAVIGATION)

All ports except the current one are shown, each labelled as previously visited or new. The player picks a destination; invalid choices are rejected.

### DISPLAY-GOODS-TABLE

**Arguments**: none (called from BUY-GOODS)

Print a header then list each good with its ID, name, and current price at the player's port.

### FLUCTUATE-PRICES

**Arguments**: none (called from PROCESS-NAVIGATION)

For every port-good pair, the current price is multiplied by a random factor between 90% and 110%.

## Flow

### Main

1. Clear the screen and render the current port (name, description, money, fuel level).
2. Show the menu: Navigate, Buy, Sell, Refuel, Save, Load.
3. If a pending notification exists, display it.
4. Read the player's choice.
5. Dispatch to the corresponding handler, or show an error for invalid choices.
6. Return to the main game loop.

## Error Handling

| Condition | Behavior |
|-----------|----------|
| Invalid menu choice | Notification "Choix invalide.", loop continues |
| Navigate with empty fuel + money ≥ 50000 | Notification "Faites le plein d'abord !" |
| Navigate with empty fuel + money < 50000 | Game status set to LOST |
| Refuel while full | Notification "Plein deja fait !" |
| Refuel with insufficient money | Notification "Pas assez d'argent !" |
| Buy: invalid product ID (not 1-5) | "Produit invalide.", retry |
| Buy: bad good ID or qty=0 | Notification "Quantite invalide." / "Achat annule." |
| Buy: money < cost | Notification "Pas assez d'argent !" |
| Sell: invalid product ID | "Produit invalide.", retry |
| Sell: cargo quantity = 0 | Notification "Vous n'avez pas ce produit." |
| Sell: qty > held | Notification "Quantite invalide." |
| Navigation: invalid destination | "Port invalide.", retry |

## Rules

- Menu options 5 (Save) and 6 (Load) are not processed here — `WS-ACTION` keeps their value and is returned to the caller, which performs the file I/O. All other valid choices are dispatched to the matching handler.
- Navigation requires a full tank. The cost is the refuel (50000), not the journey itself.
- Origin port is NOT pre-marked visited — must revisit it to reach win condition.
- Notifications are one-shot: set during an action, displayed once on the next screen, then cleared.
- Prices fluctuate on EVERY departure (not per-leg). All 5×5 prices change independently.
- PROCESS-NAVIGATION handles both destination selection and the actual move/visit/win check.
