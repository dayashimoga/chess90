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
- Classifies into 14 distinct cognitive root causes (`RootCauseCategory`: tactical blindness, calculation shortfall, candidate omission, time pressure panic, autopilot moves, prophylaxis deficits, board vision failures, endgame deficits, overconfidence, opening gaps, piece coordination breakdowns, eval misjudgments, defensive desperation, or psychological tilt).

### 5. `MasteryGates` (`packages/chess_learning/lib/src/mastery/mastery_gates.dart`)
- `computeOverallMasteryPercentage(...)`: Computes continuous composite mastery index $M = 0.35 \cdot S_{\text{skills}} + 0.35 \cdot C_{\text{curriculum}} + 0.20 \cdot E_{\text{exams}} + 0.10 \cdot R_{\text{retention}}$, avoiding binary threshold truncation.
- `hasMastered(SkillNode)`: Enforces strict quantitative thresholds for individual node mastery:
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

### 7. `CurriculumCatalog` (`packages/chess_curriculum/lib/src/curriculum_catalog.dart`)
- Repository containing complete definitions for Day 1 through Day 90.
- Indexes 10 progression phases, 13 weekly milestone exams, and explicit prerequisite trees.
- Validates that Day 90 delivers the capstone mastery report with the required FIDE title non-promise notice.

### 8. `LabController` & Hierarchy (`packages/chess_labs/lib/src/`)
- Base stateful controller for 16 specialized lab engines (`TacticalLab`, `CandidateSelectionLab`, etc.).
- Manages move legality, hint deduction logic (-20% score penalty per hint), automated engine reply moves, and genuine no-tactic declarations.

### 9. `StorageRepository` (`packages/chess_storage/lib/src/storage_repository.dart`)
- Local-first persistence layer with V1->V2 schema migration and atomic file replacement.
- Exposes full roundtrip JSON backup export and import for user data portability.

### 10. `TrainingBanks` & `ModelGamesDatabase` (`packages/chess_content/lib/src/`)
- 7 modular training banks comprising 3,694 curated exercises + 92 curriculum days = 3,786 interactive positions, all 100% legal-move validated.
- 60 master model games deeply annotated with PGN move trees across classical, pawn structure, tactical, strategic, and theoretical endgame milestones.
- 72 ECO opening variations spanning volumes A–E indexed with move trie matching.

### 11. Presentation Architecture (`apps/chess_app/lib/src/`)
- Responsive shell adapting between compact phone NavigationBar and expanded desktop NavigationRail.
- High-performance `ChessBoardWidget` supporting touch/drag interactions, legal move dots, SVG/Unicode glyphs, and screen-reader accessibility Semantics.
