# Production Deployment & Hosting Guide

## 1. Cloudflare Pages Free Deployment
ChessMaster is designed to deploy seamlessly to **Cloudflare Pages Free Tier** as a high-performance, globally edge-cached Single Page Application (SPA).

### 1.1 Static SPA Configuration
To ensure proper client-side routing and multithreaded WASM support on Cloudflare Pages, the following files are pre-configured in `apps/chess_app/web/`:

- **`_headers`**: Provides essential security and cross-origin isolation headers for Stockfish WASM threads:
  ```http
  /*
    X-Frame-Options: DENY
    X-Content-Type-Options: nosniff
    Referrer-Policy: strict-origin-when-cross-origin
    Cross-Origin-Embedder-Policy: require-corp
    Cross-Origin-Opener-Policy: same-origin
  ```
- **`_routes.json`**: Directs all deep routes (e.g., `/curriculum/day/42`, `/labs/tactics`) back to `index.html` for client-side routing while serving static assets (`.js`, `.wasm`, `.png`) directly from the edge cache.

### 1.2 Building the Web Bundle
Run the production web build command:
```bash
cd apps/chess_app
flutter build web --release
```
The compiled output is generated in `apps/chess_app/build/web/`.

### 1.3 Deploying via Wrangler CLI
Deploy directly to Cloudflare Pages using Wrangler (no host install required with `npx`):
```bash
npx wrangler pages deploy apps/chess_app/build/web --project-name chessmaster
```

### 1.4 Automated Git Deployment via Cloudflare Dashboard
1. Connect your GitHub repository to Cloudflare Pages.
2. Configure build settings:
   - **Framework Preset**: *None*
   - **Build Command**: `cd apps/chess_app && flutter build web --release`
   - **Build Output Directory**: `apps/chess_app/build/web`
   - **Root Directory**: `/`

---

## 2. Cross-Platform Desktop & Mobile Releases

### 2.1 Android APK & AAB
```bash
cd apps/chess_app
flutter build appbundle --release   # For Google Play Store submission
flutter build apk --release         # For direct offline sideloading
```

### 2.2 Windows Desktop
```bash
cd apps/chess_app
flutter build windows --release
```
Produces an optimized, standalone 64-bit Windows executable in `build/windows/x64/runner/Release/`.

### 2.3 Linux Desktop
```bash
cd apps/chess_app
flutter build linux --release
```
Produces an ELF binary in `build/linux/x64/release/bundle/`.

### 2.4 macOS Desktop
```bash
cd apps/chess_app
flutter build macos --release
```
Produces a signed macOS Application bundle (`.app`).
