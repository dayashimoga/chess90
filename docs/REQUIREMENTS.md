# ChessMaster Requirements Specification

## 1. Functional Requirements

### 1.1 Core Chess Mechanics
- Complete legal chess rules validation adhering strictly to FIDE laws of chess.
- Legal move generation with bitboards / 64-square representation.
- Special moves: Castling (kingside/queenside with check interception validation), En Passant, Pawn Promotions (Queen, Rook, Bishop, Knight).
- Game termination: Checkmate, Stalemate, Threefold repetition via 64-bit Zobrist keys, 50-move rule, Insufficient material.
- Perft verification: Must achieve 100% exact node counts up to depth 4 from standard start position and complex test positions (Kiwipete).

### 1.2 90-Day GM-Style Curriculum
- Exactly 90 continuous days of structured educational and interactive content with zero placeholders.
- 10 distinct phases covering diagnostic, tactics, calculation, strategy, endgames, openings, attack/defense, advantage conversion, tournament simulation, and certification.
- Weekly mastery exams on days 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90.
- Day 1: Baseline diagnostic battery across all 12 skill axes.
- Day 90: Final Certification, Day 1 vs Day 90 certified comparison, and next 90-day master roadmap.

### 1.3 Adaptive Mastery Engine & Skill Graph
- 12 Core Skill Axes: Tactics, Calculation, Visualization, Strategy, Pawn Structures, Endgames, Openings, Attack, Defense, Conversion, Time Management, Tournament Play.
- Strict mastery gate rule:
  `knowledge >= 90%, isolated >= 90%, mixed >= 85%, real-game >= 80%, 7-day retention >= 85%, 30-day >= 80%`.
- Spaced repetition intervals: same session → 1 day → 3 days → 7 days → 14 days → 30 days.
- Dynamic daily time budget redistribution (15m, 60m, 8h intensive modes).

### 1.4 Interactive Learn-by-Doing Labs
- 12 specialized lab environments: tactical recognition, candidate selection, blind calculation, board memory, positional evaluation, worst piece improvement, pawn breaks, endgame win/defense against engine, guess-the-move.
- Progressive hints with -20% score deduction per hint.
- Critical "Declare No Tactic" functionality for positions where intuitive sacrifices fail.

### 1.5 Teaching Engine & Root-Cause Diagnosis
- Multi-engine adapter: Native UCI Stockfish, WebAssembly browser Stockfish worker, and zero-dependency Embedded Minimax Alpha-Beta engine fallback.
- Move quality classification: Brilliant, Best, Great, Good, Inaccuracy, Mistake, Blunder, Missed Win.
- 11 cognitive root causes: Missed tactic, Inadequate candidates, Horizon cutoff, Wrong evaluation, Positional/pawn structure error, Opening deviation, Endgame gap, Conversion failure, Time pressure (<30s), Impulsive move (<3s), Blunder check omission.
- Automated creation of review items from game blunders.

### 1.6 Deterministic Video Creation Pipeline
- `PGN → parse → board states → Stockfish → annotations → animated board → overlays → FFmpeg → MP4/WebM/GIF`.
- 16:9 YouTube, 9:16 Shorts/Reels, 1:1 Social, Animated GIF.
- Smooth piece motion interpolation, dynamic eval gauge, arrow overlays, critical pauses, subtitles.

## 2. Non-Functional Requirements
- **Offline-First Core**: All core rules, embedded engine, labs, curriculum, and storage run completely offline with zero server requirements.
- **Cross-Platform**: Runs seamlessly on Web (Chrome/Edge/Safari/Firefox), Android, Windows Desktop, macOS, and Linux.
- **Deployment**: Deploys statically to Cloudflare Pages Free with PWA manifest, service worker, `_headers`, and `_routes.json`.
- **Test Coverage**: 100% automated test pass rate with coverage >90% (>95% on core modules).
