[Index](../Index.md) > [Data](index.md) > gds-dat

# `gds-dat` — WS-GOODS-LIST

5 goods with names and base prices.

## Structure

| Field | Level | PIC | Usage |
|-------|-------|-----|-------|
| `WS-GOOD` | 05 | OCCURS 5 | — |
| `WS-GOOD-ID` | 10 | 9(10) | 1-5 |
| `WS-GOOD-NAME` | 10 | X(20) | `"Cafe"`, `"Coton"`, `"Epices"`, `"Vin"`, `"Electronique"` |
| `WS-GOOD-BASE-PRICE` | 10 | 9(10)V99 | 3000, 2000, 5500, 4000, 9000 |

## Base prices

| Name | ID | Base price |
|------|----|------------|
| Cafe | 1 | 3000 |
| Coton | 2 | 2000 |
| Epices | 3 | 5500 |
| Vin | 4 | 4000 |
| Electronique | 5 | 9000 |
