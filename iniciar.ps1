# PowerShell 5.1+ / 7: .\iniciar.ps1 -servidores 2
# Si ExecutionPolicy bloquea este archivo, use en su lugar: activar.cmd --servidores 2
param(
    [ValidateSet(2, 3)]
    [int]$servidores = 3
)
$ErrorActionPreference = 'Stop'
$activar = Join-Path -Path $PSScriptRoot -ChildPath 'activar.cmd'
if (-not (Test-Path -LiteralPath $activar)) {
    throw "Falta activar.cmd junto a este script ($PSScriptRoot)."
}
$process = Start-Process -FilePath $env:ComSpec `
    -ArgumentList @('/c', "`"$activar`" --servidores $servidores") `
    -WorkingDirectory $PSScriptRoot `
    -NoNewWindow -Wait -PassThru
if ($null -eq $process.ExitCode) { exit 1 }
exit $process.ExitCode
