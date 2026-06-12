# Data Structure

## Goods tables (in-memory)

Goods list (base prices) and price grid across ports. Stored in WORKING-STORAGE only (never persisted — prices are ephemeral).

### WS-GOODS-LIST — copybook `goods-data`

```
01 WS-GOODS-LIST.
    05 WS-GOOD OCCURS 5.
        10 WS-GOOD-ID        PIC 9(10).
        10 WS-GOOD-NAME      PIC X(20).
        10 WS-GOOD-BASE-PRICE PIC 9(10)V99.
```

### WS-GOODS-PRICES-LIST — copybook `gd-price`

```
01 WS-GOODS-PRICES-LIST.
    05 WS-GOODS-PRICES OCCURS 5.
        10 WS-GOODS-PRICES-PORT-ID     PIC 9(10).
        10 WS-GOODS-PRICES-GOOD OCCURS 5.
            15 WS-GOODS-PRICES-GOOD-ID PIC 9(10).
            15 WS-GOODS-PRICES-PRICE   PIC 9(10)V99.
```

**Price algorithm**:
1. Initial price for each (port, good) = BASE-PRICE × (1 ± random(0.5)) — large ±50 % spread
2. Fluctuation at each departure = CURRENT-PRICE × (1 ± random(0.1)) — small ±10 % change

---

## GAME-DATA copybook (LINKAGE structure)

Shared between main and subprograms via `LINKAGE SECTION`.

| Field | PIC | Purpose |
|-------|-----|---------|
| `WS-MONEY` | `S9(10)V99` | Current treasury |
| `WS-CURRENT-PORT` | `9(10)` | Current port ID |
| `WS-VISITED-PORTS-COUNT` | `9(10)` | Ports visited count |
| `WS-STATUS` | `X(10)` | Game status |

---

## Working-Storage Variables

### game.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| `WS-ACTION` | `9(01)` | 0=quit, 1=navigate, 2=buy, 3=sell, 4=refuel |
| `WS-ARG` | `9(10)` | Value (e.g. port ID; good ID...) |
| `WS-FUEL-COST` | `9(10)V99` | Constant 30 |
| `WS-CURRENT-PORT` | `9(10)` | Current port ID |
| `WS-DESTINATION-PORT` | `9(10)` | Destination port ID |
| `WS-RESULT` | `X(10)` | Win/lose result |
| `WS-PORT-TABLE` | — | Table of 5 port entries |
| `WS-GOODS-LIST` | — | Table of 5 goods (ID + name + base price) |
| `WS-GOODS-PRICES` | — | Prices grid (5 ports × 5 goods) |

### WS-PORT-TABLE structure

| Level | Field | PIC | OCCURS |
|-------|-------|-----|--------|
| 10 | `WS-PORT-ID` | `9(10)` | 5 |
| 10 | `WS-PORT-NAME` | `X(20)` | — |
| 10 | `WS-PORT-DESC` | `X(60)` | — |
| 10 | `WS-PORT-VISITED` | `X(01)` | — |

### initialisation.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| *(no WS — pure linkage)* | | |

### port-screen.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| `WS-PORT-TABLE` | *(same as main)* | Local copy for display |
| `WS-VALID-CHOICE` | `X(01)` | Input validation flag |
| `WS-GOODS-LIST` | *(same as main)* | Local copy for goods display |
| `WS-GOODS-PRICES` | *(same as main)* | Local copy for price display |

### end-screen.cbl

| Variable | PIC | Purpose |
|----------|-----|---------|
| *(none — pure display)* | | |

---
**Legacy** — Archived banking data structures at [LegacyDataStructure.md](legacy/LegacyDataStructure.md).
