# ChessMaster Technical Architecture

## Monorepo Dependency Graph

```
apps/chess_app
  ├── packages/chess_core
  ├── packages/chess_engine
  ├── packages/chess_learning
  ├── packages/chess_curriculum
  ├── packages/chess_labs
  ├── packages/chess_content
  ├── packages/chess_video
  └── packages/chess_storage

packages/chess_engine      ──> packages/chess_core
packages/chess_learning    ──> packages/chess_core, packages/chess_engine
packages/chess_curriculum  ──> packages/chess_core, packages/chess_learning
packages/chess_labs        ──> packages/chess_core, packages/chess_engine, packages/chess_learning
packages/chess_content     ──> packages/chess_core, packages/chess_engine, packages/chess_curriculum
packages/chess_video       ──> packages/chess_core, packages/chess_engine
packages/chess_storage     ──> packages/chess_core, packages/chess_learning, packages/chess_curriculum
```

## Package Responsibilities

1. **`chess_core`**: Zero-dependency pure Dart package. Implements bitboards, board array, legal move generator, perft, FEN parser, PGN reader/writer, Zobrist 64-bit hashing, and chess clocks.
2. **`chess_engine`**: Universal engine adapter supporting UCI Stockfish native process, WebAssembly browser Stockfish worker, and embedded pure-Dart heuristic minimax alpha-beta chess engine ensuring 100% offline functionality everywhere.
3. **`chess_learning`**: 12-axis hierarchical skill graph, strict GM mastery gates, Leitner spaced-repetition engine, and dynamic daily study planner.
4. **`chess_curriculum`**: Complete 90-day syllabus database, interactive exercises, 13 weekly exam gates, and Day 90 certification.
5. **`chess_labs`**: Interactive lab engine with progressive hints, score deductions (-20% hint penalty), auto-reply moves, and "no tactic exists" recognition.
6. **`chess_content`**: Public-domain model games repository, automated PGN puzzle miner, and ECO openings book.
7. **`chess_video`**: Deterministic 30/60fps video timeline interpolation, frame calculation, dynamic evaluation gauge, arrow overlays, and FFmpeg command generation.
8. **`chess_storage`**: Local-first repository managing user profile, game records, error logs, and full JSON backup export and import.
9. **`chess_app`**: Cross-platform Flutter UI (Web, Android, Desktop) with luxury dark theme, responsive navigation shell, interactive board, and Cloudflare Pages Free deployment files.
