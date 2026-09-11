# ChessMaster Multi-Platform Build Script (PowerShell)
param (
    [ValidateSet("all", "web", "windows", "linux", "android")]
    [string]$Target = "all"
)

$ErrorActionPreference = "Stop"
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

Write-Host "Building ChessMaster target: $Target" -ForegroundColor Cyan
Push-Location (Join-Path $rootDir "apps/chess_app")

if ($Target -eq "all" -or $Target -eq "web") {
    Write-Host "Building Web Production Bundle..." -ForegroundColor Yellow
    flutter build web --release
}

if ($Target -eq "all" -or $Target -eq "windows") {
    if ($IsWindows -or $env:OS -match "Windows") {
        Write-Host "Building Windows x64 Release Executable..." -ForegroundColor Yellow
        flutter config --enable-windows-desktop
        flutter build windows --release
    }
}

if ($Target -eq "all" -or $Target -eq "android") {
    Write-Host "Building Android Release APK and AAB..." -ForegroundColor Yellow
    flutter build apk --release
    flutter build appbundle --release
}

Pop-Location
Write-Host "Build completed for target: $Target" -ForegroundColor Green
