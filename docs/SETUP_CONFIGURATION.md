# Setup & Configuration Guide

## 1. System Prerequisites

To build and run ChessMaster locally, ensure your host has the following toolchains installed:
- **Flutter SDK**: Version 3.24+ (includes Dart SDK 3.5+)
- **Git**: For version control and submodule resolution
- **FFmpeg** *(Optional, for video rendering)*: FFmpeg 5.0+ installed and available on system PATH
- **Podman / Docker** *(Optional, for isolated container workflows)*: Podman 4.0+ or Docker 20.10+

## 2. Quickstart with One-Command Scripts

ChessMaster provides standardized automation scripts for both Unix/macOS shells (`.sh`) and Windows PowerShell (`.ps1`):

### Starting Development Services
```bash
# Unix / macOS
./scripts/up.sh

# Windows PowerShell
.\scripts\up.ps1
```

### Running the Full Test Suite
```bash
# Unix / macOS
./scripts/test.sh

# Windows PowerShell
.\scripts\test.ps1
```

### Running Full Acceptance Verification
```bash
# Unix / macOS
./scripts/acceptance.sh --full

# Windows PowerShell
.\scripts\acceptance.ps1 -Full
```

### Stopping Services & Cleaning Build Artifacts
```bash
# Unix / macOS
./scripts/down.sh
./scripts/clean.sh

# Windows PowerShell
.\scripts\down.ps1
.\scripts\clean.ps1
```

## 3. Running the Client Application Directly

Navigate to the `apps/chess_app` directory:

```bash
cd apps/chess_app
```

### Web (Chrome / Edge)
```bash
flutter run -d chrome
```

### Windows Desktop
```bash
flutter run -d windows
```

### Linux Desktop
```bash
flutter run -d linux
```

### macOS Desktop
```bash
flutter run -d macos
```

### Android Emulator / Physical Device
```bash
flutter run -d android
```

## 4. Containerized Workflow (Podman / Docker)
If you prefer zero host toolchain installations:

```bash
# Start containerized development environment
podman compose -f infra/compose.yml up -d

# Execute tests inside the container
podman compose -f infra/compose.yml exec chessmaster ./scripts/test.sh
```

## 5. Configuration & Environment Variables

| Variable | Default | Description |
| :--- | :--- | :--- |
| `CHESSMASTER_STOCKFISH_PATH` | System PATH or fallback | Absolute path to custom Stockfish binary (e.g., `/usr/bin/stockfish` or `C:\stockfish\stockfish.exe`). If omitted or unavailable, the embedded heuristic minimax engine activates automatically. |
| `CHESSMASTER_FFMPEG_PATH` | System PATH or `ffmpeg` | Path to FFmpeg executable used by `packages/chess_video`. |
| `CHESSMASTER_STORAGE_DIR` | App sandbox directory | Override local filesystem path for storing games and JSON backups. |
| `CHESSMASTER_LOW_MEMORY` | `false` | When set to `true`, limits engine search depth to 8 plies and caps transposition caches. |
