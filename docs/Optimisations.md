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

The adaptive WIN test (`Test-Win-Adaptive`) is probabilistic because `FUNCTION RANDOM` accepts no documented seed. Prices differ every run, so victory is not guaranteed (practical success rate: 4 to 62 attempts observed, but unbounded in theory).

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

Goods (names, base prices) and ports (names, descriptions) are inline literals in `initialisation.cbl`. RUN 2 externalised save data (sequential slot files), but the planned indexed `PORTS.DAT` was dropped — ports/goods stay hardcoded. A future RUN could load them from data files.

### SIM-4 — Startup load prompt is a hidden dependency for tests 🟡

The test suite only behaves when `data/` is empty at launch; any leftover save slot triggers the interactive load prompt, which consumes piped test input. End-of-input is treated as cancel (0) by both slot prompts, so the run continues, but the dependency is undocumented in `test-game.ps1` headers and `Clear-Saves` is required.
