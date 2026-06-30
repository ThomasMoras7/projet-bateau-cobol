[Index](../Index.md) > Data

# Data Structure

- [`game-dat`](game-dat.md) — Game state (money, port, fuel, cargo, status, notification)
- [`port-dat`](port-dat.md) — Port table (5 entries with name, description, visited)
- [`gds-dat`](gds-dat.md) — Goods list (5 goods with name, base price)
- [`pric-dat`](pric-dat.md) — Prices grid (5 ports × 5 goods)
- [Price algorithm](#price-algorithm)
- [Display format](#display-format)

---

## Price algorithm

1. **Initial**: `PRICE(port, good) = BASE(good) × (0.5 + FUNCTION RANDOM)`
   - Range: 50 % - 150 % of base. Large ±50 % initial spread
   - Each port-good pair computed independently at startup

2. **Fluctuation**: `PRICE(port, good) = PRICE × (0.9 + FUNCTION RANDOM × 0.2)`
   - Range: 90 % - 110 % of current. Small ±10 % per departure
   - Each good fluctuates independently (no global multiplier)
   - Runs on every departure from any port

3. `FUNCTION RANDOM` with no arguments returns uniform [0, 1). GnuCOBOL's seed is not controllable (test is probabilistic).

## Display format

- `PIC S9(10)V99` fields display with decimal point (e.g. `2393.13`, not `000000239313`)
- Parse regex for price: `(\d+\.?\d*)` — use the decimal value directly, do NOT divide by 100
- Parse regex for money: `Argent:\s*[+-]?(\d+)` — captures only integer portion (e.g. `95000.00` → `95000`)
