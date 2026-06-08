# Projet Bateau — Agent Instructions

COBOL bank account manager. 5 standalone CLI programs under GnuCOBOL 3.2.0 (portable MinGW build, no system install needed).

## Quick commands

```powershell
# Setup environment (PATH, COB_* vars) — required before cobc
.\setup_env.ps1

# Build everything
.\build.ps1

# Build one program
cobc -x src\account-creation.cbl -o bin\account-creation.exe -I src\copybooks

# Run (⚠️ see "Data files" below)
.\bin\account-creation.exe
```

## Key facts

- **Language**: COBOL (GnuCOBOL). No tests, no linter, no formatter.
- **Copybooks** in `src/copybooks/` — `acc-rec` (accounts), `tran-rec` (transactions). Include via `-I src\copybooks` (build.ps1 does this).
- **All programs are interactive** — no CLI args. Messages in French (DISPLAY/ACCEPT).
- **Full variable names only** — never abbreviate field names (e.g. use `TIMESTAMP`, never `TS`; use `BALANCE`, never `BAL`).
- **Copybook names must be ≤ 8 characters** (GnuCOBOL fixed-format limit).
- **`.gitignore`**: `*.exe`, `*.obj`, `gnu-cobol/**` excluded. Data files (`ACCOUNTS.DAT`, `ACCOUNTS-COUNTER.DAT`, `TRANSACTIONS.DAT`, `TRANSACTIONS-COUNTER.DAT`) in `bin/` are tracked.
- **Architecture**: flat, one `.cbl` = one executable. No subprograms, no shared runtime.
- **Data files auto-create** on first run (file status "35" pattern in every program).

## Data files quirk

Programs reference `ACCOUNTS.DAT` / `ACCOUNTS-COUNTER.DAT` **relative to CWD**, not to the exe path. Running from project root creates/reads data files in the root, while `bin/` is where they're tracked in git. Prefer `cd bin; .\account-creation.exe` to keep data files colocated.

## Structure

- `src/*.cbl` — source, `build.ps1` compiles all `*.cbl` files automatically
- `bin/*.exe` — build output (gitignored)
- `bin/*.DAT` — persistent data (tracked in git)
- `gnu-cobol/` — portable GnuCOBOL (gitignored)
- `docs/` — wiki (Architecture.md, DataStructure.md, API*.md, etc.)

## COBOL coding style

- **Comment markers**: I (the human) write `*> Section name` headers to delimit logical blocks. The agent must never add comments.
- **CLOSE at end**: All `CLOSE` statements grouped unconditionally at the end of the program, after all conditional blocks.
- **IF scoping**: No periods inside IF blocks — period only on the final `END-IF.` of the outermost IF. A period terminates all active COBOL scopes.
- **Counter pattern** (for auto-increment fields):
  1. `DISPLAY "Generation de l'ID..."` (message before reading counter)
  2. `READ counter-file`
  3. `IF status = "10"` (repair: `MOVE 0`, display repair message)
  4. `ADD 1 TO last-id`
  5. `MOVE last-id TO id-field`
  6. `REWRITE counter-record`
- **Journal writing**: MOVE data fields, WRITE record — after counter increment.
- **Display results inside IF block** — before END-IF and CLOSE.
