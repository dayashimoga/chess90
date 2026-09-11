# ChessMaster Content Validator (PowerShell)
param (
    [switch]$Container
)

$ErrorActionPreference = "Stop"
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

$localDartAvailable = $false
$dartBin = "dart"
if (Test-Path "C:\flutter\bin\dart.bat") {
    $dartBin = "C:\flutter\bin\dart.bat"
    $localDartAvailable = $true
} elseif (Get-Command "dart" -ErrorAction SilentlyContinue) {
    $localDartAvailable = $true
}

if ($Container -or (-not $localDartAvailable)) {
    if (Get-Command "podman" -ErrorAction SilentlyContinue -or Get-Command "docker" -ErrorAction SilentlyContinue) {
        Write-Host "Proceeding with containerized content validation..." -ForegroundColor Cyan
        & (Join-Path $PSScriptRoot "run_container.ps1") -Action "content-validate"
        exit $LASTEXITCODE
    } else {
        Write-Error "Neither local Dart SDK nor Podman/Docker found."
        exit 1
    }
}

Push-Location (Join-Path $rootDir "tool")
& $dartBin pub get
& $dartBin run content_validator.dart
Pop-Location
