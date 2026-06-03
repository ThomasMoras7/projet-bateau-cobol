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
- **Single copybook**: `src/copybooks/acc-rec` — shared record layout. Include via `-I src\copybooks` (build.ps1 does this).
- **All programs are interactive** — no CLI args. Messages in French (DISPLAY/ACCEPT).
- **`.gitignore`**: `*.exe`, `*.obj`, `gnu-cobol/**` excluded. Data files (`ACCOUNTS.DAT`, `ACCOUNTS-COUNTER.DAT`) in `bin/` are tracked.
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
