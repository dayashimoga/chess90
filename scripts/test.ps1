param (
    [switch]$Container
)

$ErrorActionPreference = "Stop"

$localDartAvailable = $false
$dartBin = "dart"
if (Test-Path "C:\flutter\bin\dart.bat") {
    $dartBin = "C:\flutter\bin\dart.bat"
    $localDartAvailable = $true
} elseif (Get-Command "dart" -ErrorAction SilentlyContinue) {
    $localDartAvailable = $true
}

$localFlutterAvailable = $false
$flutterBin = "flutter"
if (Test-Path "C:\flutter\bin\flutter.bat") {
    $flutterBin = "C:\flutter\bin\flutter.bat"
    $localFlutterAvailable = $true
} elseif (Get-Command "flutter" -ErrorAction SilentlyContinue) {
    $localFlutterAvailable = $true
}

$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

# If tools are not installed locally or -Container specified, seamlessly proceed via Podman
if ($Container -or (-not $localDartAvailable) -or (-not $localFlutterAvailable)) {
    if (Get-Command "podman" -ErrorAction SilentlyContinue -or Get-Command "docker" -ErrorAction SilentlyContinue) {
        Write-Host "Local Dart/Flutter environment missing or -Container requested. Proceeding with Podman..." -ForegroundColor Cyan
        & (Join-Path $PSScriptRoot "run_container.ps1") -Action "test"
        exit $LASTEXITCODE
    } else {
        Write-Error "Neither local Dart/Flutter SDK nor Podman/Docker found. Please install Flutter or Podman."
        exit 1
    }
}

$packages = @(
    "packages\chess_core",
    "packages\chess_engine",
    "packages\chess_learning",
    "packages\chess_curriculum",
    "packages\chess_labs",
    "packages\chess_content",
    "packages\chess_video",
    "packages\chess_storage"
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       RUNNING ALL CHESSMASTER TESTS      " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$passedPackages = 0

foreach ($pkg in $packages) {
    $pkgDir = Join-Path $rootDir $pkg
    Write-Host "`nTesting $pkg..." -ForegroundColor Yellow
    Push-Location $pkgDir
    & $dartBin pub get
    & $dartBin test
    if ($LASTEXITCODE -eq 0) {
        $passedPackages++
        Write-Host "PASSED: $pkg" -ForegroundColor Green
    } else {
        Write-Host "FAILED: $pkg" -ForegroundColor Red
        Pop-Location
        exit 1
    }
    Pop-Location
}

# App widget tests
$appDir = Join-Path $rootDir "apps\chess_app"
Write-Host "`nTesting apps/chess_app widgets..." -ForegroundColor Yellow
Push-Location $appDir
& $flutterBin pub get
& $flutterBin test
if ($LASTEXITCODE -eq 0) {
    Write-Host "PASSED: apps/chess_app" -ForegroundColor Green
} else {
    Write-Host "FAILED: apps/chess_app" -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location

Write-Host "`n==========================================" -ForegroundColor Green
Write-Host " ALL TEST SUITES PASSED CLEANLY (100%)    " -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
