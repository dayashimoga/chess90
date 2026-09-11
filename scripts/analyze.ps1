# Run static analysis across all monorepo packages
$ErrorActionPreference = "Continue"

$WORKSPACE = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $WORKSPACE

$PACKAGES = @(
  "packages/chess_core",
  "packages/chess_engine",
  "packages/chess_learning",
  "packages/chess_curriculum",
  "packages/chess_labs",
  "packages/chess_storage",
  "packages/chess_content",
  "packages/chess_video",
  "apps/chess_app",
  "tool"
)

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "          CHESSMASTER MONOREPO STATIC ANALYSIS        " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$HAS_ERRORS = $false

foreach ($dir in $PACKAGES) {
  Write-Host ""
  Write-Host ">>> Analyzing $dir..." -ForegroundColor Yellow
  if (Test-Path $dir) {
    Push-Location $dir
    dart pub get --offline | Out-Null
    if ($LASTEXITCODE -ne 0) { dart pub get | Out-Null }
    dart analyze .
    if ($LASTEXITCODE -ne 0) {
      Write-Host "❌ $dir had analysis issues!" -ForegroundColor Red
      $HAS_ERRORS = $true
    }
    Pop-Location
  }
}

Write-Host ""
Write-Host "======================================================" -ForegroundColor Cyan
if ($HAS_ERRORS) {
  Write-Host "❌ STATIC ANALYSIS FOUND ISSUES!" -ForegroundColor Red
  exit 1
} else {
  Write-Host "🎉 ALL MONOREPO PACKAGES PASSED STATIC ANALYSIS CLEANLY!" -ForegroundColor Green
  exit 0
}
