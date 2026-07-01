[Index](../Index.md) > [Data](index.md) > pric-dat

# `pric-dat` — WS-GOODS-PRICES-LIST

5 ports × 5 goods current prices. Nested OCCURS.

## Structure

| Field | Level | PIC | Usage |
|-------|-------|-----|-------|
| `WS-GOODS-PRICES` | 05 | OCCURS 5 | One per port |
| `WS-GOODS-PRICES-PORT-ID` | 10 | 9(10) | Port ID |
| `WS-GOODS-PRICES-GOOD` | 10 | OCCURS 5 | One per good |
| `WS-GOODS-PRICES-GOOD-ID` | 15 | 9(10) | Good ID |
| `WS-GOODS-PRICES-PRICE` | 15 | 9(10)V99 | Current price for this port × good |

## Access

```
WS-GOODS-PRICES-PRICE(port-index, good-index)
```

| [Port](port-dat.md) ↓  [Good](gds-dat.md) → | Cafe 1 | Coton 2 | Epices 3 | Vin 4 | Electro 5 |
|----------------|--------|---------|----------|-------|-----------|
| Shanghai 1     | price$ | price$  | price$   | price$| price$    |
| Rotterdam 2    | price$ | price$  | price$   | price$| price$    |
| Singapour 3    | price$ | price$  | price$   | price$| price$    |
| New York 4     | price$ | price$  | price$   | price$| price$    |
| Marseille 5    | price$ | price$  | price$   | price$| price$    |
