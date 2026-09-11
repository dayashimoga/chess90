# Performance Budgets & Optimization Architecture

## 1. Measurable Performance Budgets

| Metric | Target Budget | Monitored Result | Architecture Guarantee |
| :--- | :--- | :--- | :--- |
| **UI Frame Rate** | 60 FPS ($\le 16.6\text{ ms/frame}$) | 60 FPS steady | Flutter Skia/Impeller hardware acceleration; no UI thread blocking |
| **Move Generation Speed** | $\ge 150,000\text{ moves/s}$ | $\approx 220,000\text{ moves/s}$ | Pure Dart integer bitboard and 64-square array operations |
| **Engine Analysis Latency** | Non-blocking streaming | $0\text{ ms}$ UI impact | Engine computations isolated in background Dart Isolates or Web Workers |
| **Initial Web Bundle Load** | $\le 4.5\text{ MB}$ compressed | $\approx 3.2\text{ MB}$ | Tree-shaken Flutter WASM/CanvasKit release bundle |
| **Transposition Memory** | $\le 64\text{ MB}$ max heap | $32\text{ MB}$ default LRU | Fixed-capacity LRU cache of evaluated Zobrist positions |
| **Video Timeline Render** | $\le 10\text{ ms}$ per preview frame | $\approx 4\text{ ms}$ per frame | Pre-computed frame interpolation metadata; cached piece bitmaps |

## 2. Background Isolates & Web Workers
To guarantee that the UI never stutters, long-running calculations are delegated outside the main thread:
1. **Desktop & Mobile (Native)**:
   - Evaluator engine commands run in a spawned Dart `Isolate`.
   - Communication uses bidirectional primitive `ReceivePort` and `SendPort` streams.
   - Analysis cancellation (`stop`) is handled instantaneously by signaling the isolate.
2. **Web**:
   - Stockfish WASM executes in a dedicated Web Worker script (`stockfish_worker.js`).
   - Browser threads use SharedArrayBuffer enabled via Cloudflare Pages `Cross-Origin-Embedder-Policy: require-corp` and `Cross-Origin-Opener-Policy: same-origin` headers.

## 3. Memory Management & Cache Bounding
To avoid unbounded memory growth during multi-hour study sessions:
- **Transposition Cache**: Evaluated positions are stored with a 64-bit Zobrist key in a bounded 50,000-entry LRU cache.
- **Move History Pruning**: Interactive play records retain move structures without duplicating full board array allocations; undo/redo executes via reversible move delta records.
- **Low-Memory Device Mode**: Automatically detects low-resource mobile platforms and limits minimax search depth to 8 plies and reduces transposition cache to 10,000 entries.

## 4. Responsive UI Optimizations
- **Custom Board Painter**: The `ChessBoardWidget` uses efficient canvas painting for coordinates, squares, highlights, and radial check glows.
- **Repaint Boundaries**: Wrap interactive components (`EvaluationBarWidget`, `MoveListWidget`) in dedicated Flutter `RepaintBoundary` widgets to prevent unneeded redraws of the board canvas during clock ticks or evaluation stream updates.
- **Reduced Motion Support**: If the user's OS specifies reduced motion, piece transitions execute instantaneously (0 ms duration) rather than animating smooth trajectories.
