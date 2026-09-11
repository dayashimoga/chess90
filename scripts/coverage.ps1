# ChessMaster Coverage Runner (PowerShell)
param (
    [switch]$Container
)

$ErrorActionPreference = "Stop"
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

if ($Container) {
    & (Join-Path $PSScriptRoot "run_container.ps1") -Action "coverage"
    exit $LASTEXITCODE
}

Push-Location (Join-Path $rootDir "tool")
& dart pub get
& dart run coverage_runner.dart
Pop-Location
