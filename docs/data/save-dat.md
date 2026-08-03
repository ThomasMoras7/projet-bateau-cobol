[Index](../Index.md) > [Data](index.md) > save-dat

# save-dat — Save Record

## Structure

| Field | Level | PIC | Usage |
|-------|-------|-----|-------|
| WS-SAVE-RECORD | 01 | — | Root of save record |
| WS-SAVE-MONEY | 05 | S9(10)V99 | Player treasury |
| WS-SAVE-CURRENT-PORT | 05 | 9(10) | Current port ID (1-5) |
| WS-SAVE-VISITED-PORTS-COUNT | 05 | 9(10) | Distinct ports visited |
| WS-SAVE-STATUS | 05 | X(10) | "PLAYING" / "WON" / "LOST" / "QUIT" |
| WS-SAVE-FUEL-FLAG | 05 | 9(01) | 0 = empty, 1 = full |
| WS-SAVE-CARGO-QUANTITY | 05 | 9(10) OCCURS 5 | Quantity of each good in cargo |
| WS-SAVE-PORT-VISITED | 05 | X(01) OCCURS 5 | Visited flag per port |
| WS-SAVE-GOODS-PRICES | 05 | 9(10)V99 OCCURS 25 | 5×5 price grid flattened (port-major) |

## Notes

- Written to and read from `data/GAMEx.DAT` (sequential file, single record).
- Price grid flattened port-major: index = (port-1) × 5 + good.
