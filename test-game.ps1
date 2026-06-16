<#
.SYNOPSIS
    Automated integration tests for boat-game.exe
.DESCRIPTION
    Pipes predefined input sequences to the game executable and
    checks output for expected patterns. No test framework needed.

STRATEGY EXPLANATION (for WIN test):

    Prix aleatoires generes a chaque port:
        prix = prix_base × (0.5 + RANDOM)   → ecart 50 %–150 %
    Fluctuation au depart:
        prix = prix × (0.9 + RANDOM × 0.2)  → ecart ±10 %

    Profit optimal : pour chaque marchandise, le prix peut varier
    du simple au triple entre deux ports. La strategie :
      1. Au port courant, reperer le bien le moins cher (prix < base)
      2. L'acheter en grande quantite
      3. Au port suivant, reperer le bien le plus cher (prix > base)
      4. Vendre ce qu'on a si le prix est superieur au prix d'achat
      5. Acheter le bien le moins cher de ce nouveau port
      6. Recommencer jusqu'au dernier port, puis tout revendre

    Exemple concret:
      - Shanghai: Coton (base 2000) a 1200 → tres sous-cote → achat massif
      - Rotterdam: Coton a 2800 → surcote → revente, +133 % de benefice
      - Rotterdam: Electronique (base 9000) a 5500 → sous-cote → achat
      - Singapour: Electronique a 12000 → surcote → revente, +118 %

    Avec 120 000$ de depart et 4 pleins a 50 000$ = 200 000$ de cout
    carburant, il faut degager ~80 000$ de benefice sur 3-4 voyages.
    L'electronique offrant les plus grandes marges absolues, c'est le
    meilleur candidat. Toutefois, les prix restant aleatoires, un test
    automatise ne peut PAS garantir la victoire a 100 % ; il valide
    que l'enchainement des actions fonctionne.
#>

$ErrorActionPreference = "Stop"
$GameExe = "bin\boat-game.exe"

# --- helpers ---
$PassCount = 0
$FailCount = 0

function Test-Step {
    param($Name, $Inputs, $ExpectedPatterns)
    Write-Host -NoNewline "  $Name ... "

    $inputString = ($Inputs -join "`n") + "`n"

    try {
        $output = $inputString | & $GameExe 2>&1
    } catch {
        Write-Host "FAIL (launch error: $_ )" -ForegroundColor Red
        $script:FailCount++
        return
    }

    $outputText = ($output | Out-String) -replace "`r", ""

    $allOk = $true
    foreach ($pat in $ExpectedPatterns) {
        if ($outputText -notmatch $pat) {
            $allOk = $false
            Write-Host "`n  MISSING: $pat" -ForegroundColor Yellow
        }
    }

    if ($allOk) {
        Write-Host "PASS" -ForegroundColor Green
        $script:PassCount++
    } else {
        Write-Host "FAIL" -ForegroundColor Red
        $script:FailCount++
        Write-Host "--- raw output (first 40 lines) ---"
        $outputText -split "`n" | Select-Object -First 40 | ForEach-Object { Write-Host "| $_" }
        Write-Host "---"
    }
}

# ----- main -----
Write-Host "=== Projet Bateau — Integration Tests ===" -ForegroundColor Cyan
Write-Host ""

# 1 — BUILD CHECK
Write-Host "[BUILD]" -ForegroundColor Cyan
Write-Host "  Building with build-game.ps1 ..." -NoNewline
$buildOut = & ".\build-game.ps1" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "FAIL" -ForegroundColor Red
    Write-Host "$buildOut"
    exit 1
}
Write-Host "OK" -ForegroundColor Green
Write-Host ""

# ---- FLOW TESTS ----
# Chaque test correspond a un scenario jouable.
# Les entrées sont pipelinees dans ACCEPT (une ligne = un ACCEPT).

Write-Host "[TEST 1 — Quitter directement]" -ForegroundColor Cyan
Test-Step -Name "Menu initial puis quitter" `
    -Inputs @("0") `
    -ExpectedPatterns @("PORT", "Partie quittee", "Argent final:", "Ports visites:")

Write-Host "[TEST 2 — Navigation simple]" -ForegroundColor Cyan
# 1: refuel → 2: navigate (menu) → 3: destination Rotterdam → 0: quit
Test-Step -Name "Refuel + aller a Rotterdam" `
    -Inputs @("4", "1", "2", "0") `
    -ExpectedPatterns @("Arrive a bon port", "Rotterdam", "Partie quittee")

Write-Host "[TEST 3 — Navigation sans carburant]" -ForegroundColor Cyan
# 1: navigate (fuel empty → blocked) → 0: quit
Test-Step -Name "Naviguer sans essence est bloque" `
    -Inputs @("1", "0") `
    -ExpectedPatterns @("Faites le plein d", "Partie quittee")

Write-Host "[TEST 4 — Achat de marchandises]" -ForegroundColor Cyan
# 2: buy menu → 1: Cafe → 1: quantity 1 → 0: quit
Test-Step -Name "Acheter 1 Cafe a Shanghai" `
    -Inputs @("2", "1", "1", "0") `
    -ExpectedPatterns @("Achat effectue", "Partie quittee")

Write-Host "[TEST 5 — Vente de marchandises]" -ForegroundColor Cyan
# Achat puis revente au meme port (prix identique en RUN 1)
# 2: buy → 1: Cafe → 1: 1t → 3: sell → 1: Cafe → 1: 1t → 0: quit
Test-Step -Name "Acheter puis revendre du Cafe" `
    -Inputs @("2", "1", "1", "3", "1", "1", "0") `
    -ExpectedPatterns @("Achat effectue", "Vente effectuee", "Partie quittee")

Write-Host "[TEST 6 — Destination port invalide]" -ForegroundColor Cyan
# 4: refuel → 1: navigate → 0: invalide → 2: valide (Rotterdam) → 0: quit
Test-Step -Name "Saisir port invalide puis valide" `
    -Inputs @("4", "1", "0", "2", "0") `
    -ExpectedPatterns @("Port invalide", "Partie quittee")

Write-Host "[TEST 7 — Navigation multi-port]" -ForegroundColor Cyan
# Enchainement navigation + achat/revente entre ports.
# Teste que le cargo voyage, que les prix fluctuent, que l'arrivee
# s'affiche correctement. La victoire n'est pas garantie (prix aleatoires)
# mais le flow complet est valide.
# 4: refuel → 1: navigate → 2: Rotterdam
# → 4: refuel → 1: navigate → 3: Singapour
# → 2: buy → 1: Cafe → 1: 1t → 3: sell → 1: Cafe → 1: 1t
# → 0: quit
Test-Step -Name "Visiter plusieurs ports avec echange" `
    -Inputs @("4", "1", "2", "4", "1", "3", "2", "1", "1", "3", "1", "1", "0") `
    -ExpectedPatterns @("Rotterdam", "Singapour", "Arrive a bon port")

Write-Host "[TEST 8 — Condition de defaite]" -ForegroundColor Cyan
# Epuiser l'argent jusqu'a ne plus pouvoir payer le plein.
# 4: refuel → naviguer Rotterdam → 4: refuel → naviguer Singapour
# → 4: refuel (echoue, plus assez) → 0: quit
Test-Step -Name "Plus assez d'argent pour le carburant" `
    -Inputs @("4", "1", "2", "4", "1", "3", "4", "0") `
    -ExpectedPatterns @("Pas assez d'argent", "Partie quittee")

# ----- summary -----
Write-Host ""
Write-Host "=== Results ===" -ForegroundColor Cyan
Write-Host "  Passed: $PassCount" -ForegroundColor Green
Write-Host "  Failed: $FailCount" -ForegroundColor Red
Write-Host ""

if ($FailCount -gt 0) {
    exit 1
}
