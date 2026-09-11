# ChessMaster Security Audit Runner (PowerShell)
param (
    [switch]$Container
)

$ErrorActionPreference = "Stop"
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

if ($Container) {
    & (Join-Path $PSScriptRoot "run_container.ps1") -Action "security"
    exit $LASTEXITCODE
}

Push-Location (Join-Path $rootDir "tool")
& dart pub get
& dart run security_runner.dart
Pop-Location
