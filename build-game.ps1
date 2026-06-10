# Build the game (main + modules linked together)
. "$PSScriptRoot\setup_env.ps1"

$srcDir = Join-Path $PSScriptRoot "src"
$binDir = Join-Path $PSScriptRoot "bin"

if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

$mainFile = Join-Path $srcDir "game.cbl"
$modules = @(
    "initialisation.cbl"
    "port-screen.cbl"
    "end-screen.cbl"
)
$moduleFiles = $modules | ForEach-Object { Join-Path $srcDir $_ }
$outPath = Join-Path $binDir "boat-game.exe"

cobc -x -o $outPath -I "$srcDir\copybooks" $mainFile $moduleFiles

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully built boat-game.exe"
}
else {
    Write-Error "Failed to compile boat-game"
}
