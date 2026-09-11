# ChessMaster Complete Production Certification Script (PowerShell)
param (
    [switch]$Container
)

$ErrorActionPreference = "Stop"
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "   CHESSMASTER FULL PRODUCTION CERTIFICATION PASS     " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

if ($Container) {
    & (Join-Path $PSScriptRoot "run_container.ps1") -Action "certify"
    exit $LASTEXITCODE
}

Write-Host "`n[1/6] Running Monorepo Tests..." -ForegroundColor Cyan
& (Join-Path $PSScriptRoot "test.ps1")

Write-Host "`n[2/6] Running 90-Day Content Validator..." -ForegroundColor Cyan
& (Join-Path $PSScriptRoot "content_validate.ps1")

Write-Host "`n[3/6] Running 90-Day Simulation Engine..." -ForegroundColor Cyan
& (Join-Path $PSScriptRoot "simulation_validate.ps1")

Write-Host "`n[4/6] Collecting Coverage & Enforcing Gates..." -ForegroundColor Cyan
Push-Location (Join-Path $rootDir "tool")
& dart pub get
& dart run coverage_runner.dart
Pop-Location

Write-Host "`n[5/6] Running Performance Truth Benchmarks..." -ForegroundColor Cyan
Push-Location (Join-Path $rootDir "tool")
& dart run performance_runner.dart
Pop-Location

Write-Host "`n[6/6] Running Security & Secret Audits..." -ForegroundColor Cyan
Push-Location (Join-Path $rootDir "tool")
& dart run security_runner.dart
Pop-Location

Write-Host "`n======================================================" -ForegroundColor Green
Write-Host "   ALL PRODUCTION CERTIFICATION GATES SATISFIED       " -ForegroundColor Green
Write-Host "======================================================`n" -ForegroundColor Green
