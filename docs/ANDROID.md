# ChessMaster Android Deployment & Operations Guide

## 1. Overview & Architectural Design

ChessMaster on Android provides a native mobile experience optimized for touch interaction, diverse screen densities, and low-power offline execution. The application requires zero internet connectivity for core operation, ensuring privacy, instant responsiveness, and zero telemetry.

---

## 2. Technical Specifications

| Parameter | Specification |
|:---|:---|
| **Min SDK** | Android 5.0 (API Level 21) |
| **Target SDK** | Android 14 (API Level 34) |
| **Compile SDK** | Android 14 (API Level 34) |
| **Architectures** | `arm64-v8a`, `armeabi-v7a`, `x86_64` |
| **Graphics Engine**| Impeller (Vulkan) with OpenGLES fallback |
| **Storage Sandbox**| App-private internal storage (`/data/data/com.chessmaster.chess_app/files`) |
| **Required Permissions** | None (100% offline; no internet or location permission required) |

---

## 3. UI/UX & Touch Adaptations

- **Board Interaction**: Smooth touch drag-and-drop and tap-tap move selection with haptic feedback options.
- **Safe Area & Display Cutouts**: Explicit `SafeArea` handling to avoid notches, status bars, and system navigation pill clipping.
- **Orientation & Resizing**: Responsive layout supporting portrait orientation on phones and responsive adaptive layout on foldable/tablet form factors.
- **Background & Lifecycle Resilience**: Automatic persistence of active board state to local database upon `AppLifecycleState.paused`, preventing loss of progress when switching apps or taking calls.

---

## 4. Build Instructions

### 4.1 Universal Sideload APK
```bash
cd apps/chess_app
flutter build apk --release --target-platform=android-arm,android-arm64,android-x64
```
Output artifact: `build/app/outputs/flutter-apk/app-release.apk` (packaged as `ChessMaster.apk`).

### 4.2 Google Play Store AAB (Android App Bundle)
```bash
cd apps/chess_app
flutter build appbundle --release
```
Output artifact: `build/app/outputs/bundle/release/app-release.aab` (packaged as `ChessMaster.aab`).

---

## 5. Offline Operation & Battery Optimization

- **Zero Network Traffic**: Network permissions are omitted from `AndroidManifest.xml`.
- **Adaptive Engine Throttling**: The in-process minimax engine caps search depth during battery-saver mode to prevent CPU throttling and conserve battery.
