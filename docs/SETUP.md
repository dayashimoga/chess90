# ChessMaster Developer Setup & Tooling Guide

## 1. Zero-Install Containerized Setup (Recommended)

ChessMaster is designed to build, test, and release using disposable container tooling with **zero host software dependencies** beyond a container runtime.

### Prerequisites
- [Podman](https://podman.io/) (preferred) or [Docker Desktop](https://www.docker.com/)

### One-Command Bring-Up
#### Windows (PowerShell)
```powershell
# Bring up disposable development container and run verification
.\scripts\up.ps1
```

#### POSIX (Linux / macOS)
```bash
# Bring up disposable development container and run verification
./scripts/up.sh
```

The script automatically detects whether `podman` or `docker` is installed, builds the hermetic OCI image (`localhost/chessmaster:latest`), mounts the workspace, and runs the initial verification suite.

---

## 2. Local Native SDK Setup (Optional)

If developing directly on the host machine without containers:

### Prerequisites
- **Dart SDK**: `^3.0.0 <4.0.0`
- **Flutter SDK**: `3.47.x` stable channel
- **Stockfish**: Version 16 or 17 (placed on system `PATH` as `stockfish`)
- **FFmpeg**: Version 5.x, 6.x, or 7.x (with `ffmpeg` and `ffprobe` on `PATH`)

### Dependency Installation
```bash
# Fetch dependencies across all monorepo packages
dart pub get --directory=packages/chess_core
dart pub get --directory=packages/chess_engine
dart pub get --directory=packages/chess_learning
dart pub get --directory=packages/chess_curriculum
dart pub get --directory=packages/chess_labs
dart pub get --directory=packages/chess_content
dart pub get --directory=packages/chess_video
dart pub get --directory=packages/chess_storage
dart pub get --directory=apps/chess_app
dart pub get --directory=tool
```

---

## 3. Standard Development Workflows

### Running All Unit & Integration Tests
```bash
bash scripts/test.sh          # POSIX
powershell scripts\test.ps1   # Windows
```

### Collecting Coverage & Validating Fail-Under Gates
```bash
dart run tool/coverage_runner.dart
```

### Running Performance Benchmarks
```bash
dart run tool/performance_runner.dart
```

### Running Acceptance Certification
```bash
bash scripts/acceptance.sh --full
```

### Building & Serving Web Application
```bash
cd apps/chess_app
flutter build web --release
python -m http.server 8080 --directory build/web
```

---

## 4. Teardown & Cleanup
```powershell
.\scripts\down.ps1    # Stops running container instances
.\scripts\clean.ps1   # Removes ephemeral build artifacts and caches
```
Zero residue is left behind on the host system.
