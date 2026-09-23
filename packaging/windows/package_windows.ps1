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

# 2. Generate True Pure Single-File Portable Executable (Zero Extraction Prompts)
Write-Host "`n[2/4] Generating Pure Single-File Portable Executable (ChessMaster-Portable.exe)..." -ForegroundColor Yellow

$cscExe = "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if (-not (Test-Path $cscExe)) {
    $cmd = Get-Command "csc.exe" -ErrorAction SilentlyContinue
    if ($cmd) { $cscExe = $cmd.Source }
}

if ($cscExe -and (Test-Path $cscExe)) {
    Write-Host "  Using C# Compiler: $cscExe" -ForegroundColor Gray

    # 1. Compress payload to temp zip
    $tempPayloadZip = Join-Path $OutputDir "payload.zip"
    if (Test-Path $tempPayloadZip) { Remove-Item $tempPayloadZip -Force }

    $7zExe = $null
    $candidate7zPaths = @(
        "C:\Program Files\7-Zip\7z.exe",
        "C:\Program Files (x86)\7-Zip\7z.exe"
    )
    foreach ($p in $candidate7zPaths) {
        if (Test-Path $p) { $7zExe = $p; break }
    }
    if (-not $7zExe) {
        $cmd7z = Get-Command "7z.exe" -ErrorAction SilentlyContinue
        if ($cmd7z) { $7zExe = $cmd7z.Source }
    }

    if ($7zExe) {
        Write-Host "  Creating high-compression payload with 7-Zip..." -ForegroundColor Gray
        & $7zExe a -tzip -mx=9 "$tempPayloadZip" "$stagingDir\*" | Out-Null
    } else {
        Write-Host "  Creating payload with System.IO.Compression..." -ForegroundColor Gray
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($stagingDir, $tempPayloadZip, [System.IO.Compression.CompressionLevel]::Optimal, $false)
    }

    # 2. Locate official application icon
    $iconCandidate = Join-Path $rootDir "apps\chess_app\windows\runner\resources\app_icon.ico"
    $iconArg = ""
    if (Test-Path $iconCandidate) {
        Write-Host "  Embedding application icon: $iconCandidate" -ForegroundColor Gray
        $iconArg = "/win32icon:`"$iconCandidate`""
    }

    # 3. Create pure standalone launcher C# source
    $launcherCs = @"
using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Reflection;
using System.Windows.Forms;

namespace ChessMaster
{
    static class Program
    {
        private const string AppName = "ChessMaster";
        private const string ResourceName = "payload.zip";

        [STAThread]
        static int Main(string[] args)
        {
            try
            {
                string localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
                if (string.IsNullOrEmpty(localAppData))
                {
                    localAppData = Path.GetTempPath();
                }

                Assembly assembly = Assembly.GetExecutingAssembly();
                long resourceLength = 0;
                using (Stream resStream = assembly.GetManifestResourceStream(ResourceName))
                {
                    if (resStream == null)
                    {
                        MessageBox.Show("Corrupted executable: embedded payload resource not found.", AppName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return 1;
                    }
                    resourceLength = resStream.Length;
                }

                string versionStamp = "rt_" + resourceLength.ToString("X8");
                string baseDir = Path.Combine(localAppData, AppName);
                string targetDir = Path.Combine(baseDir, versionStamp);
                string exePath = Path.Combine(targetDir, "ChessMaster.exe");
                string readyMarker = Path.Combine(targetDir, ".ready");

                // If not already extracted, unpack silently with zero prompts
                if (!File.Exists(exePath) || !File.Exists(readyMarker))
                {
                    string tempDir = Path.Combine(baseDir, "extract_" + Guid.NewGuid().ToString("N"));
                    Directory.CreateDirectory(tempDir);

                    using (Stream resStream = assembly.GetManifestResourceStream(ResourceName))
                    {
                        using (ZipArchive archive = new ZipArchive(resStream, ZipArchiveMode.Read))
                        {
                            archive.ExtractToDirectory(tempDir);
                        }
                    }

                    File.WriteAllText(Path.Combine(tempDir, ".ready"), versionStamp);

                    if (!Directory.Exists(targetDir))
                    {
                        try
                        {
                            Directory.Move(tempDir, targetDir);
                        }
                        catch
                        {
                            try { Directory.Delete(tempDir, true); } catch { }
                        }
                    }
                    else
                    {
                        try { Directory.Delete(tempDir, true); } catch { }
                    }
                }

                if (!File.Exists(exePath))
                {
                    string fallback = Path.Combine(targetDir, "chess_app.exe");
                    if (File.Exists(fallback))
                    {
                        exePath = fallback;
                    }
                }

                if (!File.Exists(exePath))
                {
                    MessageBox.Show("Failed to locate ChessMaster executable after extraction.", AppName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return 1;
                }

                ProcessStartInfo psi = new ProcessStartInfo(exePath)
                {
                    WorkingDirectory = targetDir,
                    Arguments = string.Join(" ", args),
                    UseShellExecute = false
                };

                Process process = Process.Start(psi);
                if (process == null)
                {
                    MessageBox.Show("Failed to launch ChessMaster process.", AppName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return 1;
                }

                process.WaitForExit();
                return process.ExitCode;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error launching ChessMaster: " + ex.Message, AppName, MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 1;
            }
        }
    }
}
"@
    $csFile = Join-Path $OutputDir "PortableLauncher.cs"
    [System.IO.File]::WriteAllText($csFile, $launcherCs)
    $portableExe = Join-Path $OutputDir "ChessMaster-Portable.exe"

    Write-Host "  Compiling native zero-dialog GUI launcher..." -ForegroundColor Gray
    $cscArgs = @(
        "/nologo",
        "/target:winexe",
        "/platform:x64",
        "/optimize+",
        "/out:$portableExe",
        "/resource:$tempPayloadZip,payload.zip",
        "/r:System.IO.Compression.dll",
        "/r:System.IO.Compression.FileSystem.dll",
        "/r:System.Windows.Forms.dll"
    )
    if ($iconArg) {
        $cscArgs += $iconArg
    }
    $cscArgs += "`"$csFile`""

    & $cscExe $cscArgs | Out-Null

    Remove-Item $csFile -Force -ErrorAction SilentlyContinue
    Remove-Item $tempPayloadZip -Force -ErrorAction SilentlyContinue

    if (Test-Path $portableExe) {
        $sizeMb = [math]::Round((Get-Item $portableExe).Length / 1MB, 2)
        Write-Host "  -> Successfully built Pure Portable ChessMaster-Portable.exe ($sizeMb MB)" -ForegroundColor Green
        Copy-Item $portableExe (Join-Path $rootDir "ChessMaster-Portable.exe") -Force

        # Also copy directly to user's Downloads if present for immediate testing
        $userDownloads = Join-Path $env:USERPROFILE "Downloads"
        if (Test-Path $userDownloads) {
            Copy-Item $portableExe (Join-Path $userDownloads "ChessMaster-Portable.exe") -Force
            Write-Host "  -> Updated $userDownloads\ChessMaster-Portable.exe" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  [WARNING] C# compiler (csc.exe) not available to build single-file portable executable." -ForegroundColor Yellow
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
Write-Host "`n[4/4] Creating Clean Unnested Portable ZIP Archive (ChessMaster-Windows-x64-Portable.zip)..." -ForegroundColor Yellow
$outPortableZip = Join-Path $OutputDir "ChessMaster-Windows-x64-Portable.zip"
$outLegacyZip = Join-Path $OutputDir "ChessMaster-Windows-x64.zip"

if (Test-Path $outPortableZip) { Remove-Item $outPortableZip -Force }
if (Test-Path $outLegacyZip) { Remove-Item $outLegacyZip -Force }

Compress-Archive -Path "$stagingDir\*" -DestinationPath $outPortableZip -Force
Copy-Item $outPortableZip $outLegacyZip -Force

$zipSizeMb = [math]::Round((Get-Item $outPortableZip).Length / 1MB, 2)
Write-Host "  -> Generated ChessMaster-Windows-x64-Portable.zip ($zipSizeMb MB)" -ForegroundColor Green

# Copy to workspace root for release scripts
Copy-Item $outPortableZip (Join-Path $rootDir "ChessMaster-Windows-x64-Portable.zip") -Force
Copy-Item $outLegacyZip (Join-Path $rootDir "ChessMaster-Windows-x64.zip") -Force

Write-Host "`n======================================================" -ForegroundColor Cyan
Write-Host "         WINDOWS PACKAGING COMPLETED CLEANLY          " -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan
