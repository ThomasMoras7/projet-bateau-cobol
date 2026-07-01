[Index](Index.md) > Optimisations

# Optimisations

| Category | Code | Description |
|----------|------|-------------|
| Optimisations | `OPT` | Performance, logic, lightweight architecture |
| Factorisation | `FAC` | Strict DRY, atomic decomposition, feature-driven |
| Externalisation | `EXT` | Config files, no magic numbers/strings |
| Simplification | `SIM` | More lightweight, no unasked flavor text, no superfluous |

---

## Open

### OPT-1 — Deterministic WIN test 🟡

The adaptive WIN test (`Test-Win-Adaptive`) is probabilistic because `FUNCTION RANDOM` accepts no documented seed. Prices differ every run, so victory is not guaranteed (practical success rate ~1-5 attempts, but unbounded in theory).

Solutions:
- **Option A** — Test mode via env variable: if `TEST_MODE=1`, skip `FUNCTION RANDOM` in `initialisation.cbl` and use fixed profitable prices.
- **Option B** — Verify whether `FUNCTION RANDOM(seed)` works in GnuCOBOL 3.2 to fix the generator.

### OPT-2 — "New York" not parsed by test regex 🟢

The regex `^(\w+)` in `Parse-Menu` captures only `"New"` instead of `"New York"`. The port lookup returns `$null` for ports 4 and 5. The test still functions (destination chosen from unvisited list), but the internal state display is incomplete.

### OPT-3 — "CLS" CALL spawns a process every screen 🟢

`CALL "SYSTEM" USING "cls"` creates a new OS process on every port-screen iteration and at end-screen. ANSI escape sequences (`\e[2J\e[H`) could clear the screen directly without the overhead.

### OPT-4 — WS-EXIT-FLAG pattern verbose 🟢

Input validation loops in BUY-GOODS, SELL-GOODS, and DISPLAY-PORTS-LIST use a dedicated `WS-EXIT-FLAG` variable with `PERFORM UNTIL`. COBOL supports `EXIT PERFORM` which would eliminate the flag variable entirely.

### FAC-1 — "CLS" call repeated 🟢

`CALL "SYSTEM" USING "cls"` appears in both `port-screen.cbl` and `end-screen.cbl`. A shared `CLEAR-SCREEN` paragraph would avoid duplication and centralise any future migration to ANSI escapes.

### FAC-2 — Price fluctuation loop duplicated 🟢

The nested loop (`VARYING I/J UNTIL > 5` with `FUNCTION RANDOM`) appears in both `initialisation.cbl` (price generation) and `port-screen.cbl` (price fluctuation). Only the formula differs: `BASE × (0.5 + RANDOM)` vs `CURRENT × (0.9 + RANDOM × 0.2)`. A single paragraph parameterised by formula would DRY this up.

### EXT-1 — 50000 fuel cost hardcoded 🔴

The value 50000 appears 4× in `port-screen.cbl`: refuel check, refuel cost, lose threshold, and display string. Should be a named constant or config value.

### EXT-2 — 120000 starting money hardcoded 🟡

Starting money is a literal in `initialisation.cbl`. Should be a named constant for easier balancing.

### EXT-3 — Magic numbers in price formulas 🟢

Price computation uses raw decimals (`0.5`, `0.9`, `0.2`) with no named constants. These should be declared as `WS-PRICE-MIN-FACTOR`, `WS-PRICE-FLUCT-LOW`, `WS-PRICE-FLUCT-RANGE` (or similar) for clarity.

### EXT-4 — Goods and ports data hardcoded 🟢

Goods (names, base prices) and ports (names, descriptions) are inline literals in `initialisation.cbl`. RUN 2+ should load them from data files.

### SIM-1 — Dead code in WS-ACTION 0 handler 🟡

The `WHEN 0` branch in `port-screen.cbl` sets a placeholder notification (`"Placeholder: quitter"`). This notification is never displayed — `game.cbl` immediately catches `WS-ACTION = 0`, sets status to `"QUIT"`, and calls `END-SCREEN` directly. The notification assignment is unreachable dead code.

### SIM-2 — WS-CLS-COMMAND variable unnecessary 🟢

The workspace variable `WS-CLS-COMMAND` (PIC X(03) `"cls"`) is declared only to be passed to `CALL "SYSTEM"`. The literal `"cls"` can be inlined directly in the `CALL` statement, removing the variable.

### SIM-3 — Stray build artifacts and data files in project root 🟡

Compilation produces `.o`/`.obj` files in `src/`, and runtime creates `.DAT` files at the project root. These clutter the workspace and risk accidental commits. Build output should go to `bin/` (already `.gitignore`d), and `.DAT` files should be created in a dedicated `data/` directory.
