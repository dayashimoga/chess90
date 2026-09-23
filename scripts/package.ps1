# ChessMaster Multi-Platform Packaging & Hash Generation (PowerShell)
$ErrorActionPreference = "Stop"
$rootDir = (Get-Item $PSScriptRoot).Parent.FullName

Write-Host "Packaging ChessMaster Release Artifacts..." -ForegroundColor Cyan

# 1. Package Web
$webDist = Join-Path $rootDir "apps\chess_app\build\web"
if (Test-Path $webDist) {
    Write-Host "Packaging ChessMaster-Web.zip..." -ForegroundColor Yellow
    $webZip = Join-Path $rootDir "ChessMaster-Web.zip"
    if (Test-Path $webZip) { Remove-Item $webZip -Force }
    Compress-Archive -Path "$webDist\*" -DestinationPath $webZip -Force
}

# 2. Package Windows
$winDist = Join-Path $rootDir "apps\chess_app\build\windows\x64\runner\Release"
if (Test-Path $winDist) {
    Write-Host "Packaging Windows Artifacts (Portable & Installer)..." -ForegroundColor Yellow
    $winPackScript = Join-Path $rootDir "packaging\windows\package_windows.ps1"
    & $winPackScript -SourceDir $winDist -OutputDir (Join-Path $rootDir "dist")
}

# 3. Copy Android artifacts if present
$apkSource = Join-Path $rootDir "apps\chess_app\build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $apkSource) {
    Copy-Item $apkSource (Join-Path $rootDir "ChessMaster-Android.apk") -Force
    Copy-Item $apkSource (Join-Path $rootDir "ChessMaster.apk") -Force
}
$aabSource = Join-Path $rootDir "apps\chess_app\build\app\outputs\bundle\release\app-release.aab"
if (Test-Path $aabSource) {
    Copy-Item $aabSource (Join-Path $rootDir "ChessMaster-Android.aab") -Force
    Copy-Item $aabSource (Join-Path $rootDir "ChessMaster.aab") -Force
}

# 4. Generate SHA256SUMS
Write-Host "Generating SHA256SUMS..." -ForegroundColor Yellow
$artifacts = @(
    "ChessMaster-Web.zip",
    "ChessMaster-Windows-x64-Portable.zip",
    "ChessMaster-Windows-x64.zip",
    "ChessMaster-Portable.exe",
    "ChessMaster-Setup.exe",
    "ChessMaster-Linux-x64.tar.gz",
    "ChessMaster-Android.apk",
    "ChessMaster-Android.aab",
    "ChessMaster.apk",
    "ChessMaster.aab"
)

$hashLines = @()
foreach ($art in $artifacts) {
    $artPath = Join-Path $rootDir $art
    if (Test-Path $artPath) {
        $h = (Get-FileHash -Path $artPath -Algorithm SHA256).Hash.ToLower()
        $hashLines += "$h  $art"
        Write-Host "  $art -> $h" -ForegroundColor Gray
    }
}

if ($hashLines.Count -gt 0) {
    $shaFile = Join-Path $rootDir "SHA256SUMS"
    $hashLines | Out-File -FilePath $shaFile -Encoding ascii -Force
    Write-Host "Wrote SHA256SUMS" -ForegroundColor Green
}
