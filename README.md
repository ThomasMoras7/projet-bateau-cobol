# Projet Bateau — COBOL Account Manager

Portable COBOL development environment with **GnuCOBOL 3.2.0** on Windows.
Three CLI programs manage bank accounts via indexed file I/O.

## 🚀 Quick Start

### 1. Initialize Environment
```powershell
./setup_env.ps1
```

### 2. Compile All Programs
```powershell
cobc -x src/account-creation.cbl -o bin/account-creation.exe
cobc -x src/account-deletion.cbl -o bin/account-deletion.exe
cobc -x src/account-list.cbl -o bin/account-list.exe
```

### 3. Run
```powershell
./bin/account-creation.exe
./bin/account-list.exe
./bin/account-deletion.exe
```

## 📁 Project Structure

| Path | Description |
|------|-------------|
| `gnu-cobol/` | Portable compiler binaries, libs, includes |
| `setup_env.ps1` | PowerShell env initializer (PATH, COB vars) |
| `src/` | COBOL source files |
| `bin/` | Compiled executables + data files |
| `docs/` | Project wiki |

## 🛠 Recommended VS Code Extensions

1. **[COBOL](https://marketplace.visualstudio.com/items?itemName=bitlang.cobol)** (bitlang) — Syntax highlighting, snippets
2. **[COBOL Language Support](https://marketplace.visualstudio.com/items?itemName=broadcom.cobol-language-support)** (Broadcom) — Go-to-definition, linting

## 📝 Notes

- `setup_env.ps1` auto-detects its own location → fully portable
- Data files (`ACCOUNTS.DAT`, `ACCOUNTS-COUNTER.DAT`) auto-created on first run
- **`setup_env.ps1` overwrites `.vscode/settings.json`** on every run (VS Code config is generated, not hand-edited)

## 📖 Documentation

Full wiki → [docs/Index.md](docs/Index.md)
