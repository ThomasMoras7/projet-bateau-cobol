# Legacy Banking — Architecture

## Project Hierarchy

```
Projet Bateau/
├── README.md                  # Install guide, quick start
├── setup_env.ps1              # Env initializer (PATH, COB_* vars)
├── .gitignore                 # Excludes exe, obj, gnu-cobol/, .vscode/
├── LICENSE
│
├── gnu-cobol/                 # Portable GnuCOBOL 3.2.0 (gitignored)
│   ├── bin/                   #   Compiler binaries (cobc, cobcrun…)
│   ├── lib/                   #   Runtime libraries
│   ├── include/               #   C headers for COBOL runtime
│   ├── config/                #   Compiler config files
│   ├── copy/                  #   Copybook directory
│   ├── extras/                #   Extra library modules
│   ├── locale/                #   Localization files
│   └── share/zoneinfo/        #   Timezone data (optional)
│
├── src/                       # COBOL source files
│   ├── account-creation.cbl   #   Create new account
│   ├── account-deletion.cbl   #   Delete account by ID
│   └── account-list.cbl       #   List all accounts
│
├── bin/                       # Build output + data files
│   ├── account-creation.exe   #   (gitignored)
│   ├── account-deletion.exe   #   (gitignored)
│   ├── account-list.exe       #   (gitignored)
│   ├── ACCOUNTS.DAT           #   Indexed account records
│   └── ACCOUNTS-COUNTER.DAT   #   Sequential ID counter
│
└── docs/                      # Project wiki
    ├── Index.md
    ├── Features.md
    ├── Architecture.md
    ├── DataStructure.md
    ├── API.md
    ├── Optimisations.md
    └── Changelog.md
```

## Design Principles

- **One program per operation** — each `.cbl` file standalone executable, no shared runtime
- **Flat structure** — no nested modules, copybooks, or subprograms
- **File-based persistence** — indexed `ACCOUNTS.DAT` for keyed access, sequential `ACCOUNTS-COUNTER.DAT` for ID generation
- **Portable toolchain** — `gnu-cobol/` directory self-contained, `setup_env.ps1` dynamically resolves paths

See [LegacyIndex.md](LegacyIndex.md) for the full legacy documentation index.
