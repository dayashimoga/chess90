# Offline-First Architecture & Data Sovereignty

## 1. Offline-First Principles
ChessMaster operates on an uncompromising offline-first philosophy:
1. **Zero Mandatory Network Connectivity**: All core features—chess rules, move generation, embedded heuristic minimax engine, 90-day curriculum, interactive labs, weekly exams, spaced repetition, model games, and timeline generation—execute locally on the device without an internet connection.
2. **Local Data Sovereignty**: All user profiles, training logs, game histories, self-analysis notes, and skill scores are stored strictly on the local device.
3. **Optional, Non-Intrusive Sync**: Sync is decoupled from the core platform; users synchronize data across devices by exporting and importing standard JSON backup files rather than relying on mandatory cloud accounts.

## 2. Web PWA & Service Worker Caching
When accessed in a web browser, ChessMaster functions as a certified Progressive Web App (PWA):
- **Web App Manifest (`apps/chess_app/web/manifest.json`)**: Configures display mode `standalone`, dark theme background colors, and app icons for home-screen installation.
- **Service Worker (`apps/chess_app/web/flutter_service_worker.js`)**: Employs a cache-first caching strategy for application assets (`index.html`, `main.dart.js`, WASM runtimes, and piece bitmaps). Once loaded, the web app can be launched and used completely offline (e.g., in airplane mode).

## 3. Local Persistence Hierarchy

| Platform Target | Persistence Engine | Storage Location |
| :--- | :--- | :--- |
| **Desktop (Windows/Linux/macOS)** | SQLite / JSON Flat-File | Application Data Directory / AppData |
| **Mobile (Android)** | SQLite (`sqflite`) | Protected Application Sandbox |
| **Web Browser** | IndexedDB / LocalStorage | Browser Origin Sandbox Storage |

## 4. Reversible JSON Export & Import
To enable seamless data backup, migration, and offline synchronization across heterogeneous devices:
1. Navigate to **Settings $\rightarrow$ Export Backup (JSON)**.
2. ChessMaster produces a structured JSON archive containing:
   - User profile and experience metrics.
   - 90-day curriculum completion flags and test scores.
   - Detailed 12-axis skill graph nodes.
   - Leitner spaced repetition flashcard bins.
   - Comprehensive game records with self-analysis and engine evaluation tags.
3. On any other platform (e.g., moving from Desktop to Android tablet), select **Import Backup (JSON)**. The `StorageRepository` validates schema integrity and restores the user's complete training state in milliseconds.
