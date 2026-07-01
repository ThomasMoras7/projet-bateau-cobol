# Build the game (compile modules to bin/, then link)
. "$PSScriptRoot\setup_env.ps1"

$srcDir = Join-Path $PSScriptRoot "src"
$binDir = Join-Path $PSScriptRoot "bin"
$includeArg = "-I", (Join-Path $srcDir "copybooks")

if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

$modules = @(
    "initialisation.cbl"
    "port-screen.cbl"
    "end-screen.cbl"
)

foreach ($mod in $modules) {
    $src = Join-Path $srcDir $mod
    $obj = Join-Path $binDir ($mod -replace '\.cbl$', '.o')
    cobc -c -o $obj $src $includeArg
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$mainFile = Join-Path $srcDir "game.cbl"
$outPath = Join-Path $binDir "boat-game.exe"
$objFiles = $modules | ForEach-Object { Join-Path $binDir ($_ -replace '\.cbl$', '.o') }

cobc -x -o $outPath $mainFile $objFiles $includeArg

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully built boat-game.exe"
}
else {
    Write-Error "Failed to compile boat-game"
}
