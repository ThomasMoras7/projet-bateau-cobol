# Optimisations

## Tracker

| # | Category | Description | Priority | Status |
|---|----------|-------------|----------|--------|
| 1 | DRY | Extract shared file-open logic into a copybook (ex: opening accounts file) | High | Pending |
| 2 | Feature | Add account update/edit program (modify name or balance) | Medium | Pending |
| 3 | Feature | Add main menu program that calls sub-programs | Medium | Pending |
| 4 | Quality | Add input validation for deletion ID (numeric check) | Low | Pending |
| 5 | Quality | Counter file not decremented on deletion — ID gaps accumulate | Low | Pending |
| 6 | Portability | Move data files out of `bin/` into dedicated `data/` folder | Low | Pending |
| 7 | UX | Standardize messages (currently mix French/error styles) | Low | Pending |
| 8 | VS Code | Add VS Code settings for COBOL extension, CPY search paths into the setup_env.ps1 | High | Pending | 
| 9 | Architecture | Force data creation in same directory as exe | High | Pending |


## Details

### 1 & 2 — Copybooks
All three programs duplicate `ACCOUNT-RECORD` FD and the "open, check status 35, create if missing" pattern. Extracting to `copy/account-record.cpy` and `copy/open-accounts.cpy` removes ~30 duplicated lines.

### 4 — Main Menu
Single entry-point program using `CALL` to invoke creation/deletion/list sub-programs. Avoids running three separate executables.

### 6 — ID Gaps
Counter only increments, never decrements. Deleting account #3 then creating new one gives #4, not #3. Acceptable for prototype, problematic at scale.
