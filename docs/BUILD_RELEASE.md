# ChessMaster Build & Release Engineering Guide

## 1. Overview & Reproducibility Guarantees

ChessMaster employs containerized, hermetic tooling to ensure 100% reproducible builds across all target operating systems. Builds are executed either inside the disposable OCI container (`localhost/chessmaster:latest`) or via standardized CI/CD runners with zero required host-level system modifications.

```
Clean Checkout ──> Container / CI Runner ──> Compile Target ──> Automated Smoke Test ──> Package Archive ──> SHA256 & SBOM
```

---

## 2. Release Distribution Artifacts

Upon release, five canonical distribution packages are generated alongside forensic integrity manifests:

| Target Platform | Package Filename | Compression | Contents |
|:---|:---|:---:|:---|
| **Web Production Bundle** | `ChessMaster-Web.zip` | ZIP | Minified CanvasKit web application, service worker, `_headers`, `_routes.json` |
| **Windows Desktop x64** | `ChessMaster-Windows-x64.zip`<br>`ChessMaster-Portable.exe`<br>`ChessMaster-Setup.exe` | ZIP / EXE | Standalone `ChessMaster.exe`, single-file portable SFX `ChessMaster-Portable.exe`, Inno Setup installer `ChessMaster-Setup.exe`, Flutter engine DLLs, and data assets |
| **Linux Desktop x64** | `ChessMaster-Linux-x64.tar.gz` | TAR.GZ | Native GTK3 ELF executable `ChessMaster`, bundle assets, and Stockfish binary |
| **Android Sideload APK** | `ChessMaster.apk` | Signed APK | Universal release APK for ARM64 and x86_64 devices |
| **Android Play Store AAB**| `ChessMaster.aab` | Signed AAB | Android App Bundle optimized for dynamic delivery via Google Play |

Additionally:
- `SHA256SUMS`: Cryptographic SHA-256 hash list of all generated artifacts.
- `sbom.json`: CycloneDX v1.5 Software Bill of Materials manifest.
- `acceptance.json` / `acceptance.html`: Machine- and human-readable acceptance test reports.
- `performance.json` / `performance.html`: Runtime UX benchmark audits.
- `security.json` / `security.html`: Forensic security audit results.

---

## 3. Local One-Command Automation Scripts

Release operations can be executed on any developer machine equipped with Podman or Docker.

### PowerShell (Windows)
```powershell
# Complete build and test pass
.\scripts\run_container.ps1 -Action build

# Execute full test suite
.\scripts\run_container.ps1 -Action test

# Run coverage audit with strict fail-under gates
.\scripts\run_container.ps1 -Action coverage

# Run acceptance certification
.\scripts\run_container.ps1 -Action acceptance

# Complete cleanup and container teardown
.\scripts\clean.ps1
```

### Bash (POSIX / Linux / macOS)
```bash
# Complete build and test pass
./scripts/run_container.sh build

# Execute full test suite
./scripts/run_container.sh test

# Run coverage audit with strict fail-under gates
./scripts/run_container.sh coverage

# Run acceptance certification
./scripts/run_container.sh acceptance

# Complete cleanup and container teardown
./scripts/clean.sh
```

---

## 4. Platform Compilation Recipes

### 4.1 Web Production Bundle
```bash
cd apps/chess_app
flutter build web --release
cd build/web
zip -r ../../../ChessMaster-Web.zip .
```

### 4.2 Linux Desktop (via Container)
```bash
podman run --rm -v "$(pwd):/workspace" -w /workspace/apps/chess_app localhost/chessmaster:latest \
  flutter build linux --release
cd apps/chess_app/build/linux/x64/release/bundle
tar -czf ../../../../../ChessMaster-Linux-x64.tar.gz .
```

### 4.3 Windows Desktop (via Windows CI / Host)
```powershell
cd apps\chess_app
flutter build windows --release
Compress-Archive -Path build\windows\x64\runner\Release\* -DestinationPath ..\..\ChessMaster-Windows-x64.zip -Force
```

### 4.4 Android APK & App Bundle
```bash
cd apps/chess_app
flutter build apk --release
cp build/app/outputs/flutter-apk/app-release.apk ../../ChessMaster.apk

flutter build appbundle --release
cp build/app/outputs/bundle/release/app-release.aab ../../ChessMaster.aab
```

---

## 5. Security & Checksum Verification

To independently verify artifact integrity:
```bash
sha256sum -c SHA256SUMS
```
Every binary and bundle must match the certified hash published in GitHub Releases.
