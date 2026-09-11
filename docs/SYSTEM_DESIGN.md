# ChessMaster System Design

## 1. High-Level Runtime Architecture

```
+-------------------------------------------------------------------------+
|                         ChessMaster Client App                          |
|  (Flutter Cross-Platform: Web / Android / Windows / Linux / macOS)      |
+-------------------------------------------------------------------------+
       |                           |                          |
       v                           v                          v
+------------------+     +-------------------+      +---------------------+
| Interactive Labs |     | Analysis & Review |      | Tournament / Play   |
| (Session Engine) |     | (Root Cause Diag) |      | (Clocks & Engines)  |
+------------------+     +-------------------+      +---------------------+
       |                           |                          |
       +---------------------------+--------------------------+
                                   |
                                   v
+-------------------------------------------------------------------------+
|                      Domain & Learning Engine Layer                     |
|  [DailyPlanner]    [MasteryGates]    [LeitnerEngine]    [PuzzleMiner]   |
|  [CurriculumDB]    [MoveGenerator]   [ZobristHash]      [VideoTimeline] |
+-------------------------------------------------------------------------+
                                   |
         +-------------------------+-------------------------+
         |                                                   |
         v                                                   v
+------------------------------------+             +--------------------+
|       Universal Engine Adapter     |             | Storage Repository |
| - Native Stockfish (Process UCI)   |             | - Offline SQLite   |
| - Browser Stockfish (WASM Worker)  |             | - IndexedDB (Web)  |
| - Embedded Minimax Alpha-Beta      |             | - Full JSON Backup |
+------------------------------------+             +--------------------+
```

## 2. Background Isolates & Concurrency
- Long-running engine searches and deep Alpha-Beta minimax calculations execute asynchronously using Streams and Dart asynchronous isolates so the UI thread remains at a steady 60/120 FPS.
- Video timeline frame generation and PGN multi-game parsing execute in streaming chunks with cancellation tokens.
- User move inputs are processed deterministically within < 16ms.

## 3. Data Flow in Game Analysis
```
Game Finished (PGN recorded)
       ↓
Self-Analysis Workspace (Human enters original candidate moves and thought process)
       ↓
Engine Audit (Stockfish/Heuristic engine evaluates every ply, records CP swing)
       ↓
Root-Cause Classifier (Identifies 1 of 11 cognitive root causes)
       ↓
Skill Graph Update (Increments recurrence counter, adjusts axis score)
       ↓
Leitner Queue (Inserts targeted review position for spaced repetition)
       ↓
Daily Planner (Dynamically shifts tomorrow's time budget to address the blunder)
```
