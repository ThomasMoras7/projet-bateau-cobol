# COBOL Development Environment (Portable)

This environment is pre-configured with **GnuCOBOL 3.2.0** (Community Build) for Windows.

## 📁 Project Structure

- `gnu-cobol/`: Portable compiler binaries, libraries, and includes.

- `setup_env.ps1`: PowerShell script to initialize the environment in the current terminal session.
- `src/`: Directory for COBOL source files.
- `src/hello.cbl`: Simple Hello World source file.


## 🚀 How to Use

### 1. Initialize the Environment
Before compiling or running any COBOL program, you **must** run the setup script in your PowerShell terminal to add the compiler to your PATH and set required variables:

```powershell
./setup_env.ps1
```

### 2. Compile a Program
To compile `src/hello.cbl` into an executable:

```powershell
cobc -x src/hello.cbl
```

- `-x`: Builds an executable (instead of a shared object).
- `-free`: (Optional) If you use free format instead of fixed format.

### 3. Run the Program
```powershell
./hello.exe
```

## 🛠 Recommended VS Code Extensions

For a clean and productive experience, install these extensions from the VS Code Marketplace:

1.  **[COBOL](https://marketplace.visualstudio.com/items?itemName=bitlang.cobol)** (by bitlang): Syntax highlighting, snippets, and basic linting.
2.  **[COBOL Language Support](https://marketplace.visualstudio.com/items?itemName=broadcom.cobol-language-support)** (by Broadcom): Advanced features like go-to-definition and linting.

## 📝 Configuration Note
This setup was manually extracted and localized in `cobol-workspace`. The `setup_env.ps1` script dynamically detects its location, making it truly portable.
