# ChessMaster Acceptance Suite (PowerShell)
param (
    [switch]$Full,
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

# If Dart is not installed locally or -Container specified, seamlessly proceed via Podman
if ($Container -or (-not $localDartAvailable)) {
    if (Get-Command "podman" -ErrorAction SilentlyContinue -or Get-Command "docker" -ErrorAction SilentlyContinue) {
        Write-Host "Local Dart SDK missing or -Container requested. Proceeding with Podman..." -ForegroundColor Cyan
        & (Join-Path $PSScriptRoot "run_container.ps1") -Action "acceptance"
        exit $LASTEXITCODE
    } else {
        Write-Error "Neither local Dart SDK nor Podman/Docker found. Please install Dart or Podman."
        exit 1
    }
}

Write-Host "Running ChessMaster Acceptance Suite..." -ForegroundColor Cyan

Push-Location (Join-Path $rootDir "tests")
& $dartBin pub get
$argsList = @("acceptance_runner.dart")
if ($Full) {
    $argsList += "--full"
}
& $dartBin run @argsList
Pop-Location
