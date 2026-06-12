# Projet Bateau — Agent Instructions

Maritime shipping game in COBOL (GnuCOBOL 3.2.0, portable MinGW).

## Quick commands

```powershell
.\setup_env.ps1          # Setup environment
.\build-game.ps1         # Build game (all modules + main linked into single exe)
cd bin; .\boat-game.exe  # Run
```

## Key facts

- **Language**: COBOL (GnuCOBOL). No tests, no linter, no formatter.
- **Copybooks** in `src/copybooks/`. Include via `-I src\copybooks`.
- **All programs interactive** — DISPLAY/ACCEPT in French.
- **Full variable names only** — never abbreviate. No prefix shortcuts (`WS-GP-` is forbidden, write `WS-GOODS-PRICES-PRICE`). No single-word abbreviations (`TS` instead of `TIMESTAMP`). Every level of the name must be a full, readable word.
- **Copybook 1:1 rule** — each copybook contains exactly one `01` level. Never put multiple structures in the same copybook (exception: copybook filename may use mild abbreviation to stay ≤ 8 chars).
- **Copybook names ≤ 8 characters** (GnuCOBOL fixed-format limit).
- **`.gitignore`**: `*.exe`, `*.obj`, `gnu-cobol/**` excluded.
- **Architecture**: Main program `game.cbl` + CALLed subprograms (`initialisation.cbl`, `port-screen.cbl`, `end-screen.cbl`), compiled together into one executable. **Open question**: subprograms may be merged into a single file depending on complexity.
- **No `.DAT` files in RUN 1** — state is purely in-memory.
- **Data files** (RUN 2+): `PORTS.DAT` indexed, `GAME.DAT` sequential. **Open question**: a single save file may suffice.

## Lose condition (RUN 1)

Player loses when `money < fuel_cost` (30) at the moment of trying to depart.
Win: visit all 5 ports.

## COBOL coding style

- **Comment markers**: I (the human) write `*> Section name` headers. Agent never adds comments.
- **CLOSE at end**: All CLOSE grouped unconditionally at program end.
- **IF scoping**: No periods inside IF blocks — period only on final `END-IF.`
- **Counter pattern** (for auto-increment, RUN 2+):
  1. `DISPLAY "Generation de l'ID..."`
  2. READ counter-file
  3. IF status = "10" (repair: MOVE 0, display repair message)
  4. ADD 1 TO last-id
  5. MOVE last-id TO id-field
  6. REWRITE counter-record
- **Display results inside IF block** — before END-IF and CLOSE.

## RUN workflow — milestone-by-milestone

### Structure
- Plan the project as **milestones** (RUNs), each a vertical slice.
- Each RUN has a dedicated doc `docs/API-RunN.md` with numbered issues:
  `Issue X.Y — Title`
  - `- [ ] Task 1`
  - `- [ ] Task 2`
- Every issue is a **standalone deliverable** with clear dependency order.
- Issues map 1:1 to GitHub Issues for tracking.

### Workflow
1. Read the RUN doc (`docs/API-RunN.md`) before starting.
2. Work issues **in order** — dependencies are explicit.
3. After each issue, **stop and ask the user to test + commit** before continuing.
4. Keep docs/ in sync with every code change.
5. **Never modify Changelog.md** unless explicitly asked.

### Key rules
- One change at a time, small and verifiable.
- No comments in code (docs/ is the source of truth).
- Mark checklist items `[x]` in the RUN doc as they land.
- When a task is multi-step, add intermediate commit prompts.
- No speculation — only implement what the spec says.

## Legacy

Old banking programs (`src/account-creation.cbl`, etc.) remain on disk but are superseded by the game. Git history preserves them. The `build.ps1` script is kept for reference; use `build-game.ps1` for the game.
