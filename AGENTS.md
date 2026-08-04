# Projet Bateau — Agent Instructions

Maritime shipping game in COBOL (GnuCOBOL 3.2.0, portable MinGW).

## Quick commands

```powershell
.\setup_env.ps1          # Setup environment
.\build-game.ps1         # Build game (all modules + main linked into single exe)
.\test-game.ps1          # Run automated integration tests
cd bin; .\boat-game.exe  # Run
```

## Key facts

- **Language**: COBOL (GnuCOBOL). No tests, no linter, no formatter.
- **Copybooks** in `src/copybooks/`. Include via `-I src\copybooks`.
- **All programs interactive** — DISPLAY/ACCEPT in French.
- **Full variable names only** — never abbreviate. No prefix shortcuts (`WS-GP-` is forbidden, write `WS-GOODS-PRICES-PRICE`). No single-word abbreviations (`TS` instead of `TIMESTAMP`). Every level of the name must be a full, readable word.
- **No ambiguous names** — even loop counters and temporary variables must have semantic names (`WS-GOOD-INDEX`, `WS-PRICE`, `WS-PORT-LOOP-INDEX`). Every variable must be self-documenting.
**Exception**: `WS-I`, `WS-J`, etc. are acceptable for loop iteration indices only (convention). Temporary/computation variables still need full semantic names.
- **Copybook 1:1 rule** — each copybook contains exactly one `01` level. Never put multiple structures in the same copybook (exception: copybook filename may use mild abbreviation to stay ≤ 8 chars). Suffix convention: `-rec` for records, `-dat` for data tables.
- **Copybook names ≤ 8 characters** (GnuCOBOL fixed-format limit).
- **JCL samples** in `docs/jcl/`. `.jcl` files — mainframe JCL for portfolio (not executable on this machine).
- **`.gitignore`**: `*.exe`, `*.obj`, `gnu-cobol/**` excluded.
- **Architecture**: Main program `game.cbl` + CALLed subprograms (`initialisation.cbl`, `port-screen.cbl`, `end-screen.cbl`), compiled together into one executable.
- **State**: purely in-memory while playing.
- **Saves** : 5 sequential files `data/GAME1.DAT`…`GAME5.DAT`, one record each (copybook `save-dat`). Load prompt at startup, menu options 5 (Save) / 6 (Load), save prompt on quit.

## Win / Lose

Player loses when `money < fuel_cost` (50000) at the moment of trying to depart.
Win: visit all 5 ports.

## COBOL coding style

- **Comment markers**: I (the human) write `*> Section name` headers. Agent never adds comments.
- **CLOSE at end**: All CLOSE grouped unconditionally at program end.
- **IF scoping**: No periods inside IF blocks — period only on final `END-IF.`
- **English names**: All paragraph names, function names, and labels must be in English.
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

## Documentation style

### File layout
```
docs/
├── Index.md              # Root index — simple list of links
├── data/index.md         # Copybook index — link list + concepts (price algorithm, display format)
├── data/name-dat.md      # One file per copybook — structure table (Field, Level, PIC, Usage) + notes
├── api/index.md          # Program index — simple list of links
├── api/API-Name.md       # One file per program — see section order below
└── (other top-level .md) # GameDesign, Features, Architecture, Optimisations, Changelog
```

### Section order per API doc

```
# Title

## Overview          — one paragraph: what it does, who calls it
## Sommaire          — clickable TOC (only sections that exist)
## Data
### LINKAGE          — table: copybook, direction, usage (link to data/name-dat.md)
### Parameters       — table: name, level, PIC, direction, usage (only if parameters exist)
### Workspace        — table: variable, level, type, usage
## Procedure           — only if the program has declared paragraphs
                     — summary table: paragraph, role, arguments
                     — then one subsection per paragraph with step-by-step
                     — arguments: only list what the handler actually receives (e.g. WS-ARG), not the trigger action (e.g. WS-ACTION)
## Flow              — main execution flow (high-level, NOT duplicating Procedure)
## Error Handling    — table: condition, behavior
## Rules             — one-shot design rules, edge cases
```

### Content rules

- **Copybook docs**: one file per copybook in `data/`. Structure as table with columns: Field, Level, PIC, Usage. Concept notes (e.g. notification lifecycle) as prose below the table.
- **API LINKAGE**: table with columns: copybook (linked), direction, usage. Point to `../data/copybook-name.md`, never expand fields inline.
- **French UI text**: reproduce DISPLAY strings verbatim in French where referenced.
- **No abbreviations**: match COBOL variable naming conventions in docs.

Old banking programs (`src/account-creation.cbl`, etc.) remain on disk but are superseded by the game. Git history preserves them. The `build.ps1` script is kept for reference; use `build-game.ps1` for the game.
