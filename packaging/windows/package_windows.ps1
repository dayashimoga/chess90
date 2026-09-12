# ChessMaster Automated Windows Packaging Script
# Generates Portable Folder, Single-File Portable Executable, Inno Setup Installer, and unnested ZIP.
param (
    [string]$SourceDir = "",
    [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = $PSScriptRoot
$rootDir = (Get-Item $scriptDir).Parent.Parent.FullName

if (-not $SourceDir) {
    $SourceDir = Join-Path $rootDir "apps\chess_app\build\windows\x64\runner\Release"
}

if (-not $OutputDir) {
    $OutputDir = Join-Path $rootDir "dist"
}

Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "         CHESSMASTER WINDOWS PACKAGING SUITE          " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
Write-Host "Source Directory: $SourceDir" -ForegroundColor Gray
Write-Host "Output Directory: $OutputDir" -ForegroundColor Gray

if (-not (Test-Path $SourceDir)) {
    throw "Source release directory does not exist: $SourceDir`nRun 'flutter build windows --release' first."
}

# 1. Setup Staging Directory
$stagingDir = Join-Path $OutputDir "windows\ChessMaster"
Write-Host "`n[1/4] Staging portable distribution directory..." -ForegroundColor Yellow
if (Test-Path $stagingDir) {
    Remove-Item $stagingDir -Recurse -Force
}
New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null

# Copy release files
Copy-Item "$SourceDir\*" $stagingDir -Recurse -Force

# Ensure binary is named ChessMaster.exe
$targetExe = Join-Path $stagingDir "ChessMaster.exe"
$fallbackExe = Join-Path $stagingDir "chess_app.exe"
if (-not (Test-Path $targetExe) -and (Test-Path $fallbackExe)) {
    Write-Host "  -> Copying chess_app.exe to ChessMaster.exe..." -ForegroundColor Gray
    Copy-Item $fallbackExe $targetExe -Force
}

# Copy launcher and documentation
Copy-Item (Join-Path $scriptDir "Launch-ChessMaster.bat") $stagingDir -Force
Copy-Item (Join-Path $scriptDir "README.txt") $stagingDir -Force

Write-Host "  -> Staging completed successfully at: $stagingDir" -ForegroundColor Green

# 2. Generate True Single-File Portable Executable (7-Zip SFX)
Write-Host "`n[2/4] Generating Single-File Portable Executable (ChessMaster-Portable.exe)..." -ForegroundColor Yellow

$7zExe = $null
$sfxModule = $null

$candidate7zPaths = @(
    "C:\Program Files\7-Zip\7z.exe",
    "C:\Program Files (x86)\7-Zip\7z.exe"
)
foreach ($p in $candidate7zPaths) {
    if (Test-Path $p) {
        $7zExe = $p
        break
    }
}
if (-not $7zExe) {
    $cmd = Get-Command "7z.exe" -ErrorAction SilentlyContinue
    if ($cmd) { $7zExe = $cmd.Source }
}

if ($7zExe) {
    $sfxCandidate = Join-Path (Split-Path $7zExe) "7z.sfx"
    if (Test-Path $sfxCandidate) {
        $sfxModule = $sfxCandidate
    }
}

if ($7zExe -and $sfxModule) {
    Write-Host "  Using 7-Zip: $7zExe" -ForegroundColor Gray
    Write-Host "  Using SFX:   $sfxModule" -ForegroundColor Gray

    $tempArchive = Join-Path $OutputDir "temp_app.7z"
    if (Test-Path $tempArchive) { Remove-Item $tempArchive -Force }

    # Create 7z archive of staging directory
    & $7zExe a -t7z -mx=9 "$tempArchive" "$stagingDir\*" | Out-Null

    $portableExe = Join-Path $OutputDir "ChessMaster-Portable.exe"
    $sfxConfig = Join-Path $scriptDir "sfx_config.txt"

    # Combine SFX + Config + Archive
    cmd.exe /c "copy /b `"$sfxModule`" + `"$sfxConfig`" + `"$tempArchive`" `"$portableExe`"" | Out-Null
    Remove-Item $tempArchive -Force -ErrorAction SilentlyContinue

    if (Test-Path $portableExe) {
        $sizeMb = [math]::Round((Get-Item $portableExe).Length / 1MB, 2)
        Write-Host "  -> Successfully built ChessMaster-Portable.exe ($sizeMb MB)" -ForegroundColor Green
        # Copy into portable bundle as well
        Copy-Item $portableExe (Join-Path $stagingDir "ChessMaster-Portable.exe") -Force
        # Copy to root
        Copy-Item $portableExe (Join-Path $rootDir "ChessMaster-Portable.exe") -Force
    }
} else {
    Write-Host "  [NOTICE] 7-Zip SFX module not detected; skipping single-file SFX generation." -ForegroundColor Gray
}

# 3. Compile Inno Setup Installer (if ISCC is available)
Write-Host "`n[3/4] Checking Inno Setup Compiler for Windows Installer..." -ForegroundColor Yellow
$isccExe = $null
$candidateIsccPaths = @(
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe"
)
foreach ($p in $candidateIsccPaths) {
    if (Test-Path $p) {
        $isccExe = $p
        break
    }
}
if (-not $isccExe) {
    $cmd = Get-Command "ISCC.exe" -ErrorAction SilentlyContinue
    if ($cmd) { $isccExe = $cmd.Source }
}

if ($isccExe) {
    Write-Host "  Using Inno Setup: $isccExe" -ForegroundColor Gray
    $issScript = Join-Path $scriptDir "chessmaster.iss"
    & $isccExe $issScript | Out-Null

    $setupExe = Join-Path $OutputDir "ChessMaster-Setup.exe"
    if (Test-Path $setupExe) {
        $setupSizeMb = [math]::Round((Get-Item $setupExe).Length / 1MB, 2)
        Write-Host "  -> Successfully compiled ChessMaster-Setup.exe ($setupSizeMb MB)" -ForegroundColor Green
        Copy-Item $setupExe (Join-Path $rootDir "ChessMaster-Setup.exe") -Force
    }
} else {
    Write-Host "  [NOTICE] Inno Setup compiler (ISCC.exe) not found; skipping installer creation." -ForegroundColor Gray
}

# 4. Create Clean Unnested Portable ZIP Archive
Write-Host "`n[4/4] Creating Clean Unnested Portable ZIP Archive..." -ForegroundColor Yellow
$outZip = Join-Path $OutputDir "ChessMaster-Windows-x64.zip"
if (Test-Path $outZip) { Remove-Item $outZip -Force }

Compress-Archive -Path "$stagingDir\*" -DestinationPath $outZip -Force
$zipSizeMb = [math]::Round((Get-Item $outZip).Length / 1MB, 2)
Write-Host "  -> Generated ChessMaster-Windows-x64.zip ($zipSizeMb MB)" -ForegroundColor Green

# Copy to workspace root for release scripts
Copy-Item $outZip (Join-Path $rootDir "ChessMaster-Windows-x64.zip") -Force

Write-Host "`n======================================================" -ForegroundColor Cyan
Write-Host "         WINDOWS PACKAGING COMPLETED CLEANLY          " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
