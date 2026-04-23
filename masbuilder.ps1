# ============================================================
# SETTINGS
# ============================================================

$modMgrPath  = "C:\Program Files (x86)\Steam\steamapps\common\rFactor 2\Bin64\ModMgr.exe"
$pastaOutput = "" # Leave empty to use "_OutputMAS" in the script's folder

# ============================================================

$pastaRaiz = Split-Path -Parent $MyInvocation.MyCommand.Path

# Falls back to default output folder if none is set
if ([string]::IsNullOrWhiteSpace($pastaOutput)) {
    $pastaOutput = Join-Path $pastaRaiz "_OutputMAS"
}

# Creates the output folder if it doesn't exist
if (!(Test-Path $pastaOutput)) {
    New-Item -ItemType Directory -Path $pastaOutput | Out-Null
}

# Lists available subfolders, excluding the output folder
$subpastas = Get-ChildItem -Path $pastaRaiz -Directory |
    Where-Object { $_.FullName -ne $pastaOutput }

if ($subpastas.Count -eq 0) {
    Write-Host "No subfolders found. Closing..."
    Pause
    exit
}

Write-Host ""
Write-Host "Available subfolders:"
Write-Host ""
for ($i = 0; $i -lt $subpastas.Count; $i++) {
    Write-Host "  [$($i + 1)] $($subpastas[$i].Name)"
}

Write-Host ""
Write-Host "  [0] Select all"
Write-Host ""

# Validates user input - rejects empty, non-numeric, and out-of-range values
$selecionadas = $null
while ($null -eq $selecionadas) {
    $escolha = Read-Host "Enter the numbers separated by spaces"
    $escolha = $escolha.Trim()

    if ([string]::IsNullOrWhiteSpace($escolha)) {
        Write-Host "Empty input. Please try again."
        continue
    }

    if ($escolha -eq "0") {
        $selecionadas = $subpastas
        break
    }

    $partes = $escolha -split "\s+"
    $valido = $true
    $indices = @()

    foreach ($parte in $partes) {
        # Checks if each part is a valid integer
        if ($parte -notmatch "^\d+$") {
            Write-Host "'$parte' is not a valid number. Please try again."
            $valido = $false
            break
        }

        $indice = [int]$parte - 1

        # Checks if the index is within the available range
        if ($indice -lt 0 -or $indice -ge $subpastas.Count) {
            Write-Host "Number '$parte' is out of range. Please try again."
            $valido = $false
            break
        }

        $indices += $indice
    }

    if ($valido) {
        $selecionadas = $indices | ForEach-Object { $subpastas[$_] }
    }
}

# Processes each selected subfolder
foreach ($pasta in $selecionadas) {

    Write-Host ""
    Write-Host "------------------------------------------"
    Write-Host "Folder: $($pasta.Name)"

    # Excludes .mas and .rfcmp files from packaging
    $arquivos = Get-ChildItem -Path $pasta.FullName -File |
        Where-Object { $_.Extension.ToLower() -notin @(".mas", ".rfcmp") }

    if ($arquivos.Count -eq 0) {
        Write-Host "No files found. Skipping..."
        continue
    }

    $Host.UI.RawUI.FlushInputBuffer()
    $usarNomePasta = Read-Host "Use '$($pasta.Name)' as the .mas filename? (Y/N)"

    if ($usarNomePasta.Trim().ToUpper() -eq "Y") {
        $nomeMas = "$($pasta.Name).mas"
    } else {
        $nomeMas = Read-Host "Enter the .mas filename"
        # Appends .mas extension if the user didn't type it
        if (-not $nomeMas.EndsWith(".mas")) {
            $nomeMas = "$nomeMas.mas"
        }
    }

    $masPath = Join-Path $pastaOutput $nomeMas

    Write-Host ""
    Write-Host "Packing '$nomeMas' with the following files:"
    $arquivos | ForEach-Object { Write-Host "   - $($_.Name)" }

    $processo = Start-Process -FilePath $modMgrPath `
        -ArgumentList "*.* -m`"$nomeMas`" -c`"$($pasta.FullName)`" -z9" `
        -PassThru -WorkingDirectory $pasta.FullName
    $processo.WaitForExit()

    # Moves the generated .mas from the subfolder to the output folder
    $masCriado = Join-Path $pasta.FullName $nomeMas
    if (Test-Path $masCriado) {
        Move-Item $masCriado $pastaOutput -Force
        Write-Host "Done: $masPath"
    } else {
        Write-Host "Error: .mas was not generated for '$($pasta.Name)'"
    }
}

Write-Host ""
Write-Host "=========================================="
Write-Host "All done."
Pause
