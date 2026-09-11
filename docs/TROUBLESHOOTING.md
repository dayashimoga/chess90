# Troubleshooting & Diagnostic FAQ

## 1. Engine & Analysis Issues

### Issue: "Native Stockfish binary not found on system PATH"
- **Cause**: Stockfish is not installed natively or not added to your system environment `PATH`.
- **Resolution**: No action required! ChessMaster is architected with automatic fallback. When native Stockfish is missing, `NativeStockfishEngine` transparently engages `EmbeddedHeuristicEngine`—a zero-dependency, pure Dart minimax engine with piece-square tables, quiescence search, and king safety heuristics. If you wish to use native Stockfish, install it (e.g., `choco install stockfish` or `brew install stockfish`) and define `CHESSMASTER_STOCKFISH_PATH=/path/to/stockfish`.

### Issue: "SharedArrayBuffer is not defined" in Web Browser
- **Cause**: The web server hosting the Flutter Web app is not emitting cross-origin isolation headers required for multithreaded WASM.
- **Resolution**: Ensure your server serves the headers defined in `apps/chess_app/web/_headers`:
  ```http
  Cross-Origin-Embedder-Policy: require-corp
  Cross-Origin-Opener-Policy: same-origin
  ```
  On Cloudflare Pages Free, these headers are applied automatically.

---

## 2. Video Studio & FFmpeg Issues

### Issue: "FFmpeg executable not found"
- **Cause**: You clicked "Generate Video", but FFmpeg is not installed on your system PATH.
- **Resolution**:
  - Install FFmpeg from [ffmpeg.org](https://ffmpeg.org) or via your package manager (`winget install Gyan.FFmpeg`, `apt install ffmpeg`, `brew install ffmpeg`).
  - Alternatively, click the **"Copy Command"** button in Video Studio to copy the deterministic command string and run it on any server or machine with FFmpeg available.

### Issue: Generated video has stuttering or dropped frames
- **Cause**: Slow disk I/O when writing uncompressed frame buffers.
- **Resolution**: Use an SSD for output scratch directories, or switch the video profile to **Animated GIF** or **30 FPS MP4** for lightweight rendering.

---

## 3. Storage & Data Persistence Issues

### Issue: "I switched browsers / devices and lost my training history"
- **Cause**: ChessMaster is offline-first and stores training history locally in the device sandbox / browser IndexedDB.
- **Resolution**: Before switching devices, go to **Settings / Profile**, click **"Export Backup (JSON)"**, and save your `.json` file. On your new device or browser, click **"Import Backup (JSON)"** to restore your complete profile, 90-day progress, skill graph, and played games instantaneously.

### Issue: "Corrupted local storage state"
- **Resolution**: You can reset to a clean state by running `./scripts/clean.sh` or selecting **"Reset Local Database"** in Settings. Always export a JSON backup first.

---

## 4. Container & Tooling Issues

### Issue: "podman: command not found" or "docker daemon not running"
- **Cause**: Container engine is not installed or the daemon process is halted.
- **Resolution**: Install [Podman](https://podman.io/) or Docker Desktop. `scripts/run_container.ps1` and `scripts/run_container.sh` automatically detect whichever engine is available.

### Issue: "Network Disabled / Complete Offline Mode"
- **Cause**: Device has no internet connection or network interface is down.
- **Resolution**: Expected behavior. ChessMaster operates 100% offline. All move validation, FEN/PGN parsing, 90-day lessons, 16 labs, Leitner spaced repetition, and heuristic engine evaluation require zero network packets.

---

## 5. UI, Viewport & Display Troubleshooting

### Issue: "Text clipped or overlapping on extreme text scaling (>1.5x)"
- **Cause**: High OS text scaling settings on small-screen phones.
- **Resolution**: All core screens incorporate responsive `FittedBox` scaling, horizontal sliders, and scrollable single-child views. If controls are obscured, rotate device to landscape or adjust font scale in application settings.
