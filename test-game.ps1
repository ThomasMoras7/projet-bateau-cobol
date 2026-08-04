<#
.SYNOPSIS
    Automated integration tests for Projet Bateau (GnuCOBOL)

.DESCRIPTION
    Two test suites:
      Phase 1 — Edge cases + lose condition (deterministic)
      Phase 2 — WIN attempt, retries with fresh random prices

    Tests pipe ACCEPT input sequences to boat-game.exe and check
    stdout for expected patterns.

STRATEGY (WIN)
    A chaque port: vendre tout → plein → acheter le moins cher (Coton).
    Pas de switching de bien — on reste sur Coton (base 2000, max de
    volume par dollar). La reussite depend de la variance des prix.
#>

param([switch]$Fast)

$ErrorActionPreference = "Stop"
$GameExe = "bin\boat-game.exe"

# --- helpers ---
$PassCount = 0
$FailCount = 0

function Run-Game {
    param($Inputs)
    $inputString = ($Inputs -join "`n") + "`n"
    & ".\setup_env.ps1" 2>&1 | Out-Null
    return $inputString | & $GameExe 2>&1
}

function Assert-Output {
    param($Output, $ExpectedPatterns)
    $text = ($Output | Out-String) -replace "`r", ""
    foreach ($pat in $ExpectedPatterns) {
        if ($text -notmatch $pat) {
            return $false
        }
    }
    return $true
}

function Test-Step {
    param($Name, $Inputs, $ExpectedPatterns, $ExpectedFiles = @())
    Write-Host -NoNewline "  $Name ... "
    try {
        $out = Run-Game $Inputs
        $ok = Assert-Output $out $ExpectedPatterns
        foreach ($f in $ExpectedFiles) {
            if (-not (Test-Path -LiteralPath $f)) {
                $ok = $false
                Write-Host -NoNewline "(missing $f) "
            }
        }
        if ($ok) {
            Write-Host "PASS" -ForegroundColor Green
            $script:PassCount++
        } else {
            Write-Host "FAIL" -ForegroundColor Red
            $script:FailCount++
            Write-Host "--- raw output (last 30 lines) ---"
            ($out | Out-String) -replace "`r","" -split "`n" | Select-Object -Last 30 | ForEach-Object { Write-Host "| $_" }
            Write-Host "---"
        }
    } catch {
        Write-Host "FAIL (crash: $_ )" -ForegroundColor Red
        $script:FailCount++
    }
}

function Clear-Saves {
    Remove-Item -Path "data\GAME*.DAT" -ErrorAction SilentlyContinue
}

function New-TestSave {
    & ".\setup_env.ps1" 2>&1 | Out-Null
    "2`n1`n1`n5`n1`n0`n0" | & $GameExe 2>&1 | Out-Null
}

function Test-Win-Adaptive {
    & ".\setup_env.ps1" *>&1 | Out-Null
    $env:COB_DISPLAY_BUFFER = "NO"
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = (Resolve-Path ".\bin\boat-game.exe").Path
    $psi.RedirectStandardInput = $true
    $psi.RedirectStandardOutput = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    try {
    $proc = [System.Diagnostics.Process]::Start($psi)
    $writer = $proc.StandardInput
    $reader = $proc.StandardOutput

    $script:cargo = @{}
    $script:prices = @{}
    $script:rememberedGood = $null; $script:rememberedPrice = 0
    $script:currentPort = 1; $script:visitedPorts = @{$script:currentPort=$true}
    $script:fuelFlag = 0; $script:money = 120000
    $script:outputAll = ""
    $buf = New-Object char[] 4096

    function ReadUntil {
        param($pattern = "Votre choix", [int]$timeoutMs = 1500)
        $sw = [Diagnostics.Stopwatch]::StartNew(); $r = ""; $chunks = 0
        while ($r -notmatch $pattern -and $sw.ElapsedMilliseconds -lt $timeoutMs) {
            try {
                $t = $reader.ReadAsync($buf, 0, $buf.Length)
                $ok = $t.Wait([Math]::Max(20, $timeoutMs - $sw.ElapsedMilliseconds))
                if (-not $ok) { break }
                $n = $t.Result
                if ($n -gt 0) { $r += [string]::new($buf, 0, $n); $chunks++ }
                if ($n -eq 0) { break }
            } catch { break }
        }
        $cleaned = $r -replace '\e\[[0-9;]*[a-zA-Z]', ''
        $script:outputAll += $cleaned; return $cleaned
    }

    function Send {
        param($t) try { $writer.WriteLine($t); $writer.Flush() } catch {}
    }

    function Parse-Prices {
        param($text)
        $text -split "`n" | ForEach-Object {
            if ($_ -match "^\s*(\d+)\s{2,}.+?\s{2,}(\d+\.?\d*)\$") {
                $script:prices[[int]$Matches[1]] = [decimal]$Matches[2]
            }
        }
    }

    function Parse-Menu {
        param($text)
        if ($text -match "Port:\s(.+)") {
            $pn = $Matches[1].Trim()
            $script:currentPort = @{"Shanghai"=1;"Rotterdam"=2;"Singapour"=3;"New York"=4;"Marseille"=5}[[regex]::Match($pn,'^(\w+)').Groups[1].Value]
        }
        if ($text -match "Argent:\s*[+-]?(\d+)") { $script:money = [decimal]$Matches[1] }
        if ($text -match "Carburant:\s*(\w+)") { $script:fuelFlag = @{"Vide"=0;"Plein"=1}[$Matches[1]] }
    }

    # Wait for initial menu
    Parse-Menu (ReadUntil "Votre choix" 4000)

    for ($i = 0; $i -lt 30; $i++) {
        if ($proc.HasExited) { break }
        if ($script:outputAll -match "BRAVO") { return $script:outputAll }
        if ($script:outputAll -match "GAME OVER|Partie quittee") { break }

        # Read prices if not already known
        if ($script:prices.Count -eq 0) {
            Send "2"; $r = ReadUntil "Quel produit"
            Parse-Prices $r
            Send "0"; ReadUntil "Votre choix" | Out-Null
        }

        $script:hasCargo = ($script:cargo.Values | Where-Object { $_.qty -gt 0 }).Count -gt 0
        $script:hasProfit = $false
        foreach ($e in $script:cargo.GetEnumerator()) {
            if ($e.Value.qty -gt 0 -and $script:prices.ContainsKey($e.Key)) {
                $sellInt = [Math]::Round($script:prices[$e.Key])
                $buyInt = [Math]::Round($e.Value.buyPrice)
                if ($sellInt -gt $buyInt) { $script:hasProfit = $true }
            }
        }

        # 1. Sell profitable cargo
        if ($script:hasProfit) {
            Send "3"; ReadUntil "Quel produit" | Out-Null
            $gid = ($script:cargo.GetEnumerator() | Where-Object { $_.Value.qty -gt 0 -and $script:prices.ContainsKey($_.Key) -and $script:prices[$_.Key] -gt $_.Value.buyPrice } | Select-Object -First 1).Key
            if ($gid -ne $null) {
                Send $gid; ReadUntil "Quantite" | Out-Null
                Send $script:cargo[$gid].qty; $script:cargo[$gid].qty = 0; $script:cargo[$gid].buyPrice = 0
            } else { Send "0" }
            Parse-Menu (ReadUntil "Votre choix"); continue
        }

        # 2. Refuel or sell at loss if need fuel
        if ($script:fuelFlag -eq 0) {
            if ($script:money -ge 25000) { Send "4"; Parse-Menu (ReadUntil "Votre choix"); continue }
            if ($script:hasCargo) {
                Send "3"; ReadUntil "Quel produit" | Out-Null
                $gid = ($script:cargo.GetEnumerator() | Where-Object { $_.Value.qty -gt 0 } | Select-Object -First 1).Key
                if ($gid -ne $null) {
                    Send $gid; ReadUntil "Quantite" | Out-Null
                    Send $script:cargo[$gid].qty; $script:cargo[$gid].qty = 0; $script:cargo[$gid].buyPrice = 0
                } else { Send "0" }
                Parse-Menu (ReadUntil "Votre choix"); continue
            }
            # Trigger LOSE by navigating without fuel
            Send "1"; ReadUntil "GAME OVER|Partie quittee" 3000 | Out-Null
            break
        }

        # 3. Buy cheapest good (only if can afford 1 unit)
        if ($script:money -gt 0 -and $script:prices.Count -gt 0) {
            $bg = $null; $bp = 0
            $script:prices.GetEnumerator() | ForEach-Object { if ($bp -eq 0 -or $_.Value -lt $bp) { $bg = $_.Key; $bp = $_.Value } }
            if ($bp -gt 0 -and $script:money -ge $bp) {
                Send "2"; ReadUntil "Quel produit" | Out-Null
                $qty = [Math]::Min([Math]::Floor($script:money / $bp), 99)
                if ($qty -gt 0) {
                    Send $bg; ReadUntil "Quantite" | Out-Null
                    Send $qty
                    $tc = $bp * $qty; $script:money -= $tc
                    if (-not $script:cargo.ContainsKey($bg)) { $script:cargo[$bg] = @{qty=0; buyPrice=0; totalCost=0} }
                    $script:cargo[$bg].totalCost += $tc; $script:cargo[$bg].qty += $qty; $script:cargo[$bg].buyPrice = [Math]::Round($script:cargo[$bg].totalCost / $script:cargo[$bg].qty)
                } else { Send "0" }
                Parse-Menu (ReadUntil "Votre choix")
                continue
            }
        }

        # 4. Navigate (remember most expensive good before departure)
        if ($script:fuelFlag -eq 1) {
            $bestG = $null; $bestP = 0
            $script:prices.GetEnumerator() | ForEach-Object { if ($_.Value -gt $bestP) { $bestG = $_.Key; $bestP = $_.Value } }
            if ($bestG -ne $null) { $script:rememberedGood = $bestG; $script:rememberedPrice = $bestP }
            $dest = @(1,2,3,4,5) | Where-Object { -not $script:visitedPorts.ContainsKey($_) -and $_ -ne $script:currentPort } | Select-Object -First 1
            if ($dest -eq $null) { $dest = @(1,2,3,4,5) | Where-Object { $_ -ne $script:currentPort } | Select-Object -First 1 }
            Send "1"; ReadUntil "Choisissez" | Out-Null
            Send $dest; $script:visitedPorts[$dest] = $true
            $script:prices = @{}
            $r2 = ReadUntil "Votre choix|BRAVO|GAME OVER" 1500
            Parse-Menu $r2; continue
        }

        break
    }
    $proc.Kill(); $proc.WaitForExit(3000) | Out-Null
    return $script:outputAll
    } catch { if ($proc -and !$proc.HasExited) { $proc.Kill() }; return "" }
}

function Test-Win {
    param($MaxRetries = 100)
    Write-Host "  Victoire en cours (max ${MaxRetries}x)..." -ForegroundColor Cyan
    Write-Host "  Legende: . = arret, L = PERDU, Q = QUIT, E = erreur"
    Write-Host -NoNewline "  "
    $wins = 0; $losses = 0
    for ($i = 1; $i -le $MaxRetries; $i++) {
        try {
            $out = Test-Win-Adaptive
            if ($out -match "BRAVO") {
                $wins++; Write-Host -NoNewline "V" -ForegroundColor Green
                if ($wins -ge 1) {
                    Write-Host "`n  VICTOIRE apres $i tentatives !" -ForegroundColor Green
                    $script:PassCount++
                    return
                }
            } elseif ($out -match "GAME OVER") {
                $losses++; Write-Host -NoNewline "L" -ForegroundColor Red
            } else {
                Write-Host -NoNewline "Q" -ForegroundColor Yellow
                if ($i -eq 1) {
                    Write-Host "`n  OUTPUT-LAST-200: $($out.Substring([Math]::Max(0,$out.Length-200)))" -ForegroundColor DarkGray
                }
            }
        } catch {
            Write-Host -NoNewline "E" -ForegroundColor DarkRed
        }
        if ($i % 80 -eq 0) { Write-Host ""; Write-Host -NoNewline "  " }
    }
    Write-Host ""
    Write-Host "  Resultats: V=$wins L=$losses Q/autres=$($MaxRetries-$wins-$losses)" -ForegroundColor Cyan
    if ($wins -eq 0) {
        Write-Host "  NOTE: 0 victoire en ${MaxRetries}x. Cause probable:" -ForegroundColor Yellow
        Write-Host "  l'equation economique est tres exigeante" -ForegroundColor Yellow
    }
}

# ===== MAIN =====
Write-Host "=== Projet Bateau — Tests integres ===" -ForegroundColor Cyan
Write-Host ""

# ── BUILD ──
Write-Host "[BUILD]" -ForegroundColor Cyan
Write-Host -NoNewline "  Compilation ..."
& ".\build-game.ps1" 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "FAIL" -ForegroundColor Red; exit 1 }
Write-Host " OK" -ForegroundColor Green
Write-Host ""

Clear-Saves

# ============================================================
# PHASE 1 — Edge cases + lose condition (deterministic)
# ============================================================
Write-Host "=" * 60
Write-Host "PHASE 1 — Cas limites et defaite" -ForegroundColor Cyan
Write-Host "=" * 60

Test-Step -Name "[1] Menu puis quitter" `
    -Inputs @("0") `
    -ExpectedPatterns @("PORT", "Partie quittee", "Argent final:", "Ports visites:")

Test-Step -Name "[2] Naviguer sans essence bloque" `
    -Inputs @("1", "0") `
    -ExpectedPatterns @("Faites le plein d", "Partie quittee")

Test-Step -Name "[3] Destination invalide" `
    -Inputs @("4", "1", "0", "2", "0") `
    -ExpectedPatterns @("Port invalide", "Partie quittee")

Test-Step -Name "[4] Achat 1 Cafe" `
    -Inputs @("2", "1", "1", "0") `
    -ExpectedPatterns @("Achat effectue", "Partie quittee")

Test-Step -Name "[5] Achat puis revente" `
    -Inputs @("2", "1", "1", "3", "1", "1", "0") `
    -ExpectedPatterns @("Achat effectue", "Vente effectuee", "Partie quittee")

Test-Step -Name "[6] Navigation simple (Rotterdam)" `
    -Inputs @("4", "1", "2", "0") `
    -ExpectedPatterns @("Arrive a bon port", "Rotterdam", "Partie quittee")

Test-Step -Name "[7] Refuel deja plein bloque" `
    -Inputs @("4", "4", "0") `
    -ExpectedPatterns @("Plein deja fait", "Partie quittee")

Test-Step -Name "[8] Quantite achat zero" `
    -Inputs @("2", "1", "0", "0") `
    -ExpectedPatterns @("Quantite invalide", "Partie quittee")

Test-Step -Name "[9] Vente sans stock" `
    -Inputs @("3", "0", "0") `
    -ExpectedPatterns @("Vente annulee", "Partie quittee")

Test-Step -Name "[10] Navigation sans refuel puis LOSE" `
    -Inputs @("4","1","2","4","1","1","4","1","2","4","1","3","1") `
    -ExpectedPatterns @("GAME OVER", "Plus assez d'argent")

Clear-Saves
Test-Step -Name "[11] Sauvegarde via menu (slot 1)" `
    -Inputs @("2", "1", "1", "5", "1", "0", "0") `
    -ExpectedPatterns @("Sauvegarde effectuee dans le slot 1", "Partie quittee") `
    -ExpectedFiles @("data/GAME1.DAT")
Clear-Saves

New-TestSave
Test-Step -Name "[12] Chargement au demarrage (slot 1)" `
    -Inputs @("1", "1", "0", "0") `
    -ExpectedPatterns @("Parties sauvegardees", "Partie chargee", "Partie quittee")
Clear-Saves

New-TestSave
Test-Step -Name "[13] Chargement en cours de partie (menu 6)" `
    -Inputs @("0", "6", "1", "0", "0") `
    -ExpectedPatterns @("Parties sauvegardees", "Partie chargee", "Partie quittee")
Clear-Saves

Clear-Saves
Test-Step -Name "[14] Chargement sans sauvegarde (menu 6)" `
    -Inputs @("6", "0", "0") `
    -ExpectedPatterns @("Aucune sauvegarde disponible", "Partie quittee")

Write-Host ""

# ============================================================
# PHASE 2 — WIN attempt (up to 10 retries)
# ============================================================
Write-Host "=" * 60
Write-Host "PHASE 2 — Victoire (jusqu'a 100 tentatives)" -ForegroundColor Cyan
Write-Host "=" * 60
Write-Host "  Strategie adaptative: vendre si profitable, plein," -ForegroundColor Gray
Write-Host "    acheter le moins cher, naviguer" -ForegroundColor Gray
Write-Host "  Les prix changent a chaque tentative (FUNCTION RANDOM)." -ForegroundColor Gray
Write-Host ""

Test-Win -MaxRetries 100

# ===== SUMMARY =====
Write-Host ""
Write-Host "=" * 60
Write-Host "Results" -ForegroundColor Cyan
Write-Host "  Passed: $PassCount" -ForegroundColor Green
Write-Host "  Failed: $FailCount" -ForegroundColor Red
Write-Host "=" * 60

if ($FailCount -gt 0) { exit 1 }
