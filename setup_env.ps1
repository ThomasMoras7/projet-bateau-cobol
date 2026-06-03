$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$COB_MAIN_DIR = Join-Path $PSScriptRoot "gnu-cobol\"


if (-not (Test-Path $COB_MAIN_DIR)) {
    Write-Error "GnuCOBOL directory not found at $COB_MAIN_DIR"
    return
}

# Core environment variables
$env:COB_MAIN_DIR = $COB_MAIN_DIR
$env:COB_CONFIG_DIR = Join-Path $COB_MAIN_DIR "config"
$env:COB_COPY_DIR = Join-Path $COB_MAIN_DIR "copy"
$env:COB_CFLAGS = "-I`"$(Join-Path $COB_MAIN_DIR "include")`" " + $env:COB_CFLAGS
$env:COB_LDFLAGS = "-L`"$(Join-Path $COB_MAIN_DIR "lib")`" " + $env:COB_LDFLAGS
$env:COB_LIBRARY_PATH = Join-Path $COB_MAIN_DIR "extras"

# Add bin to Path
$binPath = Join-Path $COB_MAIN_DIR "bin"
if ($env:PATH -notlike "*$binPath*") {
    $env:PATH = "$binPath;" + $env:PATH
}

# Locales
$env:LOCALEDIR = Join-Path $COB_MAIN_DIR "locale"

# Timezone (if exists)
$tzPath = Join-Path $COB_MAIN_DIR "share\zoneinfo"
if (Test-Path $tzPath) {
    $env:TZDIR = $tzPath
}

# VS Code configuration — copybook search paths for COBOL extension
$vscodeDir = Join-Path $PSScriptRoot ".vscode"
$settingsFile = Join-Path $vscodeDir "settings.json"

if (-not (Test-Path $vscodeDir)) {
    New-Item -ItemType Directory -Path $vscodeDir -Force | Out-Null
}

$settings = @{
    "cobol-lsp.cpy-manager.paths-local" = @(
        "src/copybooks"
    )
}
$settings | ConvertTo-Json | Set-Content -Path $settingsFile -Force
Write-Host "[VS Code] $settingsFile updated (overwritten)"

Write-Host "----------------------------------------------------"
Write-Host " GnuCOBOL Portable Environment Initialized"
Write-Host "----------------------------------------------------"
Write-Host "COB_MAIN_DIR: $env:COB_MAIN_DIR"
cobc --version
Write-Host "----------------------------------------------------"
