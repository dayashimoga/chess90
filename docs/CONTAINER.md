# ChessMaster Container Architecture & Podman Guide

## 1. Overview & Principles

ChessMaster is designed with an offline-first, hermetic architecture. To ensure 100% reproducible execution across disparate developer environments, operating systems, and CI runners without local toolchain pollution, ChessMaster provides first-class support for **Podman** (Pod Manager tool) and standard OCI container runtimes.

If any local compiler, SDK (such as Flutter SDK, Android toolchain, or Dart), or system binary (such as Stockfish 19 or FFmpeg 9.0.1) is not installed locally on the host machine, the recommended approach is to execute through Podman containers.

### Why Podman?

* **Daemonless & Rootless**: Podman executes without a background root daemon (`dockerd`), conforming to strict enterprise zero-trust security standards.
* **Volume Isolation & SELinux Compliance**: Uses the `:z` volume flag for secure mount isolation between host and container.
* **OCI Standard**: Full interoperability with Dockerfiles and standard Containerfiles (`infra/Containerfile`).
* **Deterministic Toolchains**: Guarantees identical Dart, Flutter, FFmpeg, and Stockfish versions in both local development and GitHub Actions CI.

---

## 2. Container Architecture & Components

```
                +-------------------------------------------------+
                |        Host Machine (Windows / Linux / macOS)   |
                |   Workspace: H:/chess90 (Mounted as /workspace)  |
                +-----------------------+-------------------------+
                                        | (Volume Mount -v .:/workspace:z)
                                        v
+---------------------------------------------------------------------------------+
| Podman Container: chessmaster:latest                                            |
|                                                                                 |
|  [Base Layer: Debian Bookworm Slim]                                             |
|  * Git, Curl, Unzip, XZ-Utils, CA-Certificates                                  |
|                                                                                 |
|  [Media & Engine Layer]                                                         |
|  * Stockfish 19 UCI Chess Engine (/usr/games/stockfish)                         |
|  * FFmpeg 9.0.1 / FFprobe Audio-Visual Pipeline (/usr/bin/ffmpeg)                |
|                                                                                 |
|  [Language & SDK Layer]                                                         |
|  * Dart SDK Stable (/usr/lib/dart)                                              |
|  * Flutter SDK Stable (/opt/flutter) with Web Tools Precached                   |
|                                                                                 |
|  [Quality & Acceptance Automation]                                              |
|  * scripts/test.sh              -> Monorepo 100% Unit/Widget Suite              |
|  * tool/coverage_runner.dart    -> Fail-under line coverage gates (>90%)        |
|  * tool/performance_runner.dart -> Latency, perft, and throughput benchmarks    |
|  * tool/security_runner.dart    -> Offline zero-trust security audit             |
|  * scripts/acceptance.sh --full -> 16 Production acceptance gates certification |
+---------------------------------------------------------------------------------+
```

---

## 3. Quick Start with Podman

### Automatic Helper Scripts

The repository includes cross-platform scripts that automatically detect Podman (falling back to Docker if Podman is absent):

#### On Windows (PowerShell):
```powershell
# 1. Build the container image
.\scripts\run_container.ps1 -Action build

# 2. Run all unit and widget tests
.\scripts\run_container.ps1 -Action test

# 3. Collect coverage and verify fail-under gates (>90%)
.\scripts\run_container.ps1 -Action coverage

# 4. Execute performance benchmarks
.\scripts\run_container.ps1 -Action performance

# 5. Run deterministic security audit
.\scripts\run_container.ps1 -Action security

# 6. Run complete 16-gate production acceptance certification
.\scripts\run_container.ps1 -Action acceptance

# 7. Launch local web server on port 8080
.\scripts\run_container.ps1 -Action serve -Port 8080
```

#### On Linux / macOS (Bash):
```bash
# 1. Build container image
bash scripts/run_container.sh build

# 2. Run all tests
bash scripts/run_container.sh test

# 3. Collect coverage and enforce fail-under gates
bash scripts/run_container.sh coverage

# 4. Run performance benchmark suite
bash scripts/run_container.sh performance

# 5. Run security audit
bash scripts/run_container.sh security

# 6. Run full acceptance certification
bash scripts/run_container.sh acceptance

# 7. Start web application
bash scripts/run_container.sh serve 8080
```

---

## 4. Manual Podman CLI Execution

If you prefer raw Podman commands without using helper scripts:

### Build Image:
```bash
podman build -t chessmaster:latest -f infra/Containerfile .
```

### Run Tests:
```bash
podman run --rm -v ".:/workspace:z" -w /workspace chessmaster:latest bash scripts/test.sh
```

### Run Full Acceptance Certification:
```bash
podman run --rm -v ".:/workspace:z" -w /workspace chessmaster:latest bash scripts/acceptance.sh --full
```

### Run Web Server via Podman Compose:
```bash
podman compose -f infra/compose.yml up
```
Open `http://localhost:8080` in any modern web browser to access the application.

---

## 5. Continuous Integration (CI/CD) Parity

The GitHub Actions workflow (`.github/workflows/pr.yml`) executes the containerized pipeline via the `container-validate` job:

```yaml
container-validate:
  name: Podman / OCI Container Hermetic Validation
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - name: Build and Validate via Podman Container
      run: |
        podman build -t chessmaster:ci -f infra/Containerfile .
        podman run --rm chessmaster:ci bash scripts/test.sh
```

This guarantees 1:1 parity between local development and remote quality assurance gating.
