# Code Understanding Guide

This document assists developers and agents in navigating the core abstractions across the ChessMaster codebase.

## Key Abstractions

### 1. `Board` (`packages/chess_core/lib/src/board/board.dart`)
- **Storage**: Fixed-length 64-element array of `Piece?` plus cached king positions (`_whiteKingSquare`, `_blackKingSquare`).
- **State**: `activeColor`, `castlingRights` (4-bit bitmask), `enPassantSquare`, `halfmoveClock`, `fullmoveNumber`.
- **Zobrist**: `currentZobrist` updated incrementally on each `makeMove` and restored on `unmakeMove`.
- **Threefold Repetition**: Increments occurrence count in `_positionOccurrences` map using Zobrist hash.

### 2. `MoveGenerator` (`packages/chess_core/lib/src/rules/move_generator.dart`)
- `generateLegalMoves(Board)`: Generates pseudo-legal moves and filters moves where the king remains in check.
- `isSquareAttacked(...)`: High-speed ray-casting and offset testing for pawn, knight, bishop, rook, queen, and king attacks.
- `moveToSan` & `sanToMove`: Robust bidirectional standard algebraic notation parser with full disambiguation (file, rank, or both).

### 3. `EmbeddedHeuristicEngine` (`packages/chess_engine/lib/src/embedded_heuristic_engine.dart`)
- Standalone minimax search with alpha-beta pruning.
- Quiescence search evaluating capture chains to prevent horizon effect.
- Piece-square tables for center control, king shelter, and mobility.
- Fallback guaranteed for all platforms when external binaries are unavailable.

### 4. `RootCauseClassifier` (`packages/chess_engine/lib/src/analysis/root_cause_classifier.dart`)
- `diagnose(...)`: Takes board before/after, move played, duration spent, and remaining clock.
- Classifies into 11 distinct cognitive root causes (e.g. time pressure if <30s remaining, impulsive move if <3s spent, hanging piece if 1-ply capture available, etc.).

### 5. `MasteryGates` (`packages/chess_learning/lib/src/mastery/mastery_gates.dart`)
- `hasMastered(SkillNode)`: Enforces strict quantitative thresholds:
  - Knowledge score >= 90%
  - Isolated drill accuracy >= 90%
  - Mixed accuracy >= 85%
  - Real game application >= 80%
  - 7-day retention >= 85%
  - 30-day retention >= 80%.

### 6. `VideoTimelineGenerator` (`packages/chess_video/lib/src/video_timeline_generator.dart`)
- Converts `PgnGame` into discrete `VideoFrame` sequence.
- Interpolates piece moving coordinates across frames for smooth 30/60 FPS animation.
- Computes evaluation bar heights, arrow overlays, and pause durations at critical moments.
