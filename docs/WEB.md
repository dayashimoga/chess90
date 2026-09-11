# ChessMaster Web Deployment & Operations Guide

## 1. Overview & Architectural Design

ChessMaster Web compiles the complete Flutter application into an optimized WebAssembly / CanvasKit single-page application (SPA) deployable to Cloudflare Pages, GitHub Pages, or any static CDN.

```
Flutter Dart Sources ──> dart2js Minification ──> CanvasKit WASM ──> Cloudflare Pages Edge (Free Tier)
```

---

## 2. Technical Specifications

| Parameter | Specification |
|:---|:---|
| **Rendering Backend** | CanvasKit (Skia WebAssembly) |
| **PWA Support** | Full offline Progressive Web App via `flutter_service_worker.js` |
| **Isolation Headers** | COOP (`same-origin`) and COEP (`require-corp`) enabled via `_headers` |
| **SPA Routing** | `_routes.json` configured for zero-404 client-side pushState routing |
| **Storage Engine** | `window.localStorage` with JSON serialization and IndexedDB |
| **Engine Execution**| In-process pure-Dart `EmbeddedHeuristicEngine` |

---

## 3. Security & Cross-Origin Isolation Headers

The `build/web/_headers` file configures enterprise-grade security and isolation:

```http
/*
  Cross-Origin-Opener-Policy: same-origin
  Cross-Origin-Embedder-Policy: require-corp
  Cross-Origin-Resource-Policy: cross-origin
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: geolocation=(), camera=(), microphone=(), payment=()
```

These headers enable browser security sandboxing while granting high-resolution timer access (`performance.now()`) and SharedArrayBuffer memory allocation for multithreaded WASM workloads.

---

## 4. Single-Page Routing Configuration

`build/web/_routes.json` ensures that deep URLs resolve cleanly without web server 404 errors:

```json
{
  "version": 1,
  "include": ["/*"],
  "exclude": [
    "/assets/*",
    "/canvaskit/*",
    "/icons/*",
    "/favicon.png",
    "/manifest.json",
    "/flutter_bootstrap.js",
    "/flutter_service_worker.js"
  ]
}
```

---

## 5. Build & Verification

### 5.1 Compilation
```bash
cd apps/chess_app
flutter build web --release
```

### 5.2 Local Serving
```bash
python -m http.server 8080 --directory apps/chess_app/build/web
```

### 5.3 Automated Headless Chrome CDP Verification
```bash
python tool/web_e2e.py
```
This automated test launches headless Chrome, attaches via Chrome DevTools Protocol, renders the CanvasKit viewport, captures screenshots, and asserts 0 browser console errors.
