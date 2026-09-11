# ChessMaster Cross-Platform Matrix & Release Certification

## 1. Multi-Platform Support Matrix

Status classification conforms strictly to release criteria:
- **`PROVEN`**: Packaged executable/bundle generated, launched, and behaviorally verified with runtime evidence.
- **`EMULATOR-PROVEN`**: Packaged bundle installed and verified in an emulator/virtual container environment.
- **`PLATFORM_REQUIRED`**: Truthfully marked when specific proprietary host hardware/OS (e.g. Apple macOS/Xcode for iOS) is not present in the current execution environment.
- **`UNVERIFIED`**: Code exists but unvalidated at runtime.
- **`FAIL`**: Build, launch, or runtime failure detected.

| Capability / Gate | Web (PWA / CanvasKit) | Windows Desktop (x64) | Linux Desktop (x64) | Android (APK / AAB) | iOS (Mobile) |
|:---|:---:|:---:|:---:|:---:|:---:|
| **BUILD** | `PROVEN` | `PROVEN` | `PROVEN` | `PROVEN` | `PLATFORM_REQUIRED` |
| **LAUNCH** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **CORE CHESS** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **TRAINING** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **PUZZLES** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **OPENINGS** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **ENDGAMES** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **LABS** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **ENGINE** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **SAVE** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **IMPORT/EXPORT** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **VIDEO** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **OFFLINE** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **UI** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **PERFORMANCE** | `PROVEN` | `PROVEN` | `PROVEN` | `EMULATOR-PROVEN` | `PLATFORM_REQUIRED` |
| **OVERALL RESULT**| **`PROVEN`** | **`PROVEN`** | **`PROVEN`** | **`EMULATOR-PROVEN`** | **`PLATFORM_REQUIRED`** |

---

## 2. Platform Delivery Artifacts

| Platform | Output Artifact File | Format | Checksum Target | Deployment Target |
|:---|:---|:---:|:---:|:---|
| **Web** | `ChessMaster-Web.zip` | Zip Archive | `SHA256SUMS` | Cloudflare Pages / Static CDN |
| **Windows Desktop** | `ChessMaster-Windows-x64.zip` | Zip Archive | `SHA256SUMS` | GitHub Releases / MSIX |
| **Linux Desktop** | `ChessMaster-Linux-x64.tar.gz` | Tar Gzip | `SHA256SUMS` | GitHub Releases / Flatpak / AppImage |
| **Android (APK)** | `ChessMaster.apk` | Signed APK | `SHA256SUMS` | Sideload / Direct Download |
| **Android (AAB)** | `ChessMaster.aab` | App Bundle | `SHA256SUMS` | Google Play Store Release |
| **iOS** | `ChessMaster.ipa` | IPA Archive | — | App Store TestFlight (`PLATFORM_REQUIRED`) |

---

## 3. Platform Architecture & Engine Fallback Strategies

### Web Architecture (Browser CanvasKit & Web Workers)
- **Engine Execution**: Operates the pure-Dart `EmbeddedHeuristicEngine` directly inside the Dart JS runtime. On browsers supporting Web Workers and SharedArrayBuffer, WebAssembly Stockfish can be spawned.
- **Storage**: Uses `window.localStorage` and IndexedDB with atomic serializations.
- **Media**: Generates deterministic timeline keyframes with canvas exports; provides FFmpeg CLI commands for export.

### Desktop Architecture (Windows x64 & Linux x64)
- **Engine Execution**: Direct process spawning of host `stockfish` binary via standard input/output pipes (`NativeStockfishEngine`), automatically falling back to `EmbeddedHeuristicEngine` if binary is missing.
- **Storage**: Direct filesystem persistence with atomic write-and-rename semantics (`.tmp` write followed by rename).
- **Media**: Automatic discovery of host `ffmpeg` and `ffprobe` for native MP4 video and GIF rendering.

### Android Architecture (ARM64 / x86_64)
- **Engine Execution**: In-process heuristic minimax engine supplemented by packaged native NDK Stockfish binary when bundled.
- **Storage**: App-private internal storage sandbox via Android path provider.
- **Lifecycle**: Handles background/resume and device rotation without memory leak or state loss.
