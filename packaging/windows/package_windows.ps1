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
        Write-Host "  -> Successfully built ChessMaster-Portable.exe via 7-Zip SFX ($sizeMb MB)" -ForegroundColor Green
        Copy-Item $portableExe (Join-Path $stagingDir "ChessMaster-Portable.exe") -Force
        Copy-Item $portableExe (Join-Path $rootDir "ChessMaster-Portable.exe") -Force
    }
} else {
    Write-Host "  7-Zip SFX module not detected. Using native Windows C# compiler to generate standalone ChessMaster-Portable.exe..." -ForegroundColor Gray
    $cscExe = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
    if (Test-Path $cscExe) {
        $tempPayloadZip = Join-Path $OutputDir "payload.zip"
        if (Test-Path $tempPayloadZip) { Remove-Item $tempPayloadZip -Force }

        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($stagingDir, $tempPayloadZip, [System.IO.Compression.CompressionLevel]::Optimal, $false)

        $launcherCs = @"
using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Reflection;

namespace ChessMaster
{
    class Program
    {
        [STAThread]
        static int Main(string[] args)
        {
            try
            {
                string localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                string targetDir = Path.Combine(localAppData, "ChessMaster", "portable");
                string exePath = Path.Combine(targetDir, "ChessMaster.exe");

                Assembly currentAssembly = Assembly.GetExecutingAssembly();
                DateTime exeWriteTime = File.GetLastWriteTime(currentAssembly.Location);
                string stampFile = Path.Combine(targetDir, ".stamp");

                bool needsExtract = !File.Exists(exePath) || !File.Exists(stampFile) ||
                    File.ReadAllText(stampFile) != exeWriteTime.Ticks.ToString();

                if (needsExtract)
                {
                    if (Directory.Exists(targetDir))
                    {
                        try { Directory.Delete(targetDir, true); } catch { }
                    }
                    Directory.CreateDirectory(targetDir);

                    using (Stream stream = currentAssembly.GetManifestResourceStream("payload.zip"))
                    {
                        if (stream == null) return 1;
                        using (ZipArchive archive = new ZipArchive(stream, ZipArchiveMode.Read))
                        {
                            archive.ExtractToDirectory(targetDir);
                        }
                    }
                    try { File.WriteAllText(stampFile, exeWriteTime.Ticks.ToString()); } catch { }
                }

                if (!File.Exists(exePath))
                {
                    string fallback = Path.Combine(targetDir, "chess_app.exe");
                    if (File.Exists(fallback)) exePath = fallback;
                }

                ProcessStartInfo psi = new ProcessStartInfo(exePath);
                psi.WorkingDirectory = targetDir;
                psi.Arguments = string.Join(" ", args);
                psi.UseShellExecute = false;

                Process p = Process.Start(psi);
                p.WaitForExit();
                return p.ExitCode;
            }
            catch
            {
                return 1;
            }
        }
    }
}
"@
        $csFile = Join-Path $OutputDir "PortableLauncher.cs"
        [System.IO.File]::WriteAllText($csFile, $launcherCs)
        $portableExe = Join-Path $OutputDir "ChessMaster-Portable.exe"

        & $cscExe /nologo /target:winexe /platform:x64 /optimize+ "/out:$portableExe" "/resource:$tempPayloadZip,payload.zip" /r:System.IO.Compression.dll /r:System.IO.Compression.FileSystem.dll "$csFile" | Out-Null

        Remove-Item $csFile -Force -ErrorAction SilentlyContinue
        Remove-Item $tempPayloadZip -Force -ErrorAction SilentlyContinue

        if (Test-Path $portableExe) {
            $sizeMb = [math]::Round((Get-Item $portableExe).Length / 1MB, 2)
            Write-Host "  -> Successfully compiled standalone ChessMaster-Portable.exe ($sizeMb MB)" -ForegroundColor Green
            Copy-Item $portableExe (Join-Path $stagingDir "ChessMaster-Portable.exe") -Force
            Copy-Item $portableExe (Join-Path $rootDir "ChessMaster-Portable.exe") -Force
        }
    } else {
        Write-Host "  [WARNING] Neither 7z SFX nor csc.exe available to build single-file portable executable." -ForegroundColor Yellow
    }
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
