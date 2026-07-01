[Index](Index.md) > Features

# Features — RUN 1

## Game Lifecycle
- Fresh start on every run (no save/load)
- No file I/O — everything in memory
- `cls` printed before both the port screen and the end screen for readability
- One-shot notifications: after each action a message is queued, displayed once on the next screen, then cleared

## Goods Trading
- 5 goods: Cafe (3000), Coton (2000), Epices (5500), Vin (4000), Electronique (9000)
- Cargo array (`WS-CARGO-QUANTITY`) initialized to zero for all 5 goods at game start
- Per-port prices randomized at startup: `BASE × (0.5 + RANDOM)` → 50 % - 150 % of base
- Prices fluctuate on each departure: `PRICE × (0.9 + RANDOM × 0.2)` → 90 % - 110 % of current
- Each good fluctuates independently (no shared global multiplier)
- Buy at current port, sell at destination (same price at a given port — no bid/ask spread)
- **Buy screen**: lists goods with ID, name, current price; prompts for product (1-5, 0=cancel) then quantity; validates ID range, quantity > 0, money ≥ cost
- **Sell screen**: lists cargo with ID, name, quantity held, and current sell price per unit; prompts for product (1-5, 0=cancel) then quantity; validates ID range, quantity > 0, quantity ≤ cargo held

## Port Navigation
- 5 fixed ports (Shanghai, Rotterdam, Singapour, New York, Marseille)
- Display current port info + list of reachable ports with visit status
- Navigate to any other port in one turn (fuel required)
- First visit to each port tracked; win requires visiting all 5

## Fuel
- Fuel is binary: empty (0) or full (1), starts empty
- Refuel costs **50 000 $** (option 4)
- Navigation empties the tank
- Lose condition triggered when fuel is empty AND money < 50 000 on navigation attempt

## Starting Port
- Game starts at port 1 (Shanghai).

## Win / Lose
- **Win**: visit all 5 ports (count reaches 5)
- **Lose**: can't afford 50 000 $ refuel when tank empty
- **Quit**: option 0 at any time
- End screen with result, final money, and ports visited count
