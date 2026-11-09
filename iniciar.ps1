# PowerShell 5.1+ / 7: .\iniciar.ps1 -servidores 2 (o 3)
param(
    [ValidateSet(2, 3)]
    [int]$servidores = 3
)
$ErrorActionPreference = 'Stop'
$Venv = Join-Path $PSScriptRoot '.venv'
$Python = Join-Path $Venv 'Scripts\python.exe'
if (-not (Test-Path $Python)) {
    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 -m venv $Venv
    } else {
        & python -m venv $Venv
    }
    if ($LASTEXITCODE -ne 0) { throw 'No se pudo crear el entorno Python.' }
}
& $Python -m pip install -q -r (Join-Path $PSScriptRoot 'requirements-cli.txt')
if ($LASTEXITCODE -ne 0) { throw 'No se pudieron instalar las dependencias del lanzador.' }
& $Python (Join-Path $PSScriptRoot 'launcher.py') --servidores $servidores
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
