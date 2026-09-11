# ChessMaster Local Development Launcher (PowerShell)
param (
    [int]$Port = 8080,
    [switch]$Build,
    [switch]$Container
)

$ErrorActionPreference = "Stop"
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName
$appDir = Join-Path $rootDir "apps\chess_app"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       CHESSMASTER PLATFORM LAUNCHER      " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Check if container requested
if ($Container) {
    Write-Host "Proceeding with Podman container web server on port $Port..." -ForegroundColor Cyan
    & (Join-Path $PSScriptRoot "run_container.ps1") -Action "serve" -Port "$Port"
    exit $LASTEXITCODE
}

# Locate flutter
$flutterBin = "flutter"
$localFlutterAvailable = $false
if (Test-Path "C:\flutter\bin\flutter.bat") {
    $flutterBin = "C:\flutter\bin\flutter.bat"
    $localFlutterAvailable = $true
} elseif (Get-Command "flutter" -ErrorAction SilentlyContinue) {
    $localFlutterAvailable = $true
}

$localPythonAvailable = $false
if (Get-Command "python" -ErrorAction SilentlyContinue -or Get-Command "python3" -ErrorAction SilentlyContinue) {
    $localPythonAvailable = $true
}

if ((-not $localFlutterAvailable) -or (-not $localPythonAvailable)) {
    if (Get-Command "podman" -ErrorAction SilentlyContinue -or Get-Command "docker" -ErrorAction SilentlyContinue) {
        Write-Host "Local Flutter or Python environment incomplete. Seamlessly launching via Podman container..." -ForegroundColor Cyan
        & (Join-Path $PSScriptRoot "run_container.ps1") -Action "serve" -Port "$Port"
        exit $LASTEXITCODE
    }
}

if ($Build) {
    Write-Host "Building web distribution..." -ForegroundColor Yellow
    Push-Location $appDir
    & $flutterBin build web --release
    Pop-Location
}

$webDist = Join-Path $appDir "build\web"
if (-not (Test-Path $webDist)) {
    Write-Host "Building web distribution first..." -ForegroundColor Yellow
    Push-Location $appDir
    & $flutterBin build web --release
    Pop-Location
}

Write-Host "Serving ChessMaster Web from $webDist on http://localhost:$Port..." -ForegroundColor Green
Push-Location $webDist
Start-Process "http://localhost:$Port"
python -m http.server $Port
Pop-Location
