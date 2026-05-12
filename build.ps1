# Build all COBOL programs
. "$PSScriptRoot\setup_env.ps1"

$srcDir = Join-Path $PSScriptRoot "src"
$binDir = Join-Path $PSScriptRoot "bin"

if (-not (Test-Path $binDir)) {
    New-Item -ItemType Directory -Path $binDir | Out-Null
}

Get-ChildItem -Path $srcDir -Filter *.cbl | ForEach-Object {
    $srcFile = $_.FullName
    $exeName = $_.BaseName + ".exe"
    $outPath = Join-Path $binDir $exeName
    cobc -x -o $outPath -I "$srcDir\copybooks" $srcFile
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully built $exeName"
    }
    else {
        Write-Error "Failed to compile $($_.Name)"
    }
}
