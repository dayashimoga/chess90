# Testing Strategy & Test Suites

## 1. Quality Philosophy & Mandatory Gates
ChessMaster enforces a strict zero-regression quality standard:
- **100% Tests Passing**: No failed or skipped critical tests are permitted in CI or local runs.
- **Coverage Target**: $>90\%$ across the entire monorepo, targeting $\ge 95\%$ on core chess logic.
- **Fail-Under Gating**: Pull requests and release builds automatically fail if unit or integration tests break.

## 2. Test Suites by Package

### 2.1 Core Rules Correctness (`packages/chess_core`)
- **Perft Benchmarks (`test/perft_test.dart`)**:
  - Initial Position:
    - Depth 1: 20 nodes
    - Depth 2: 400 nodes
    - Depth 3: 8,902 nodes
    - Depth 4: 197,281 nodes
  - Complex Positions:
    - *Kiwipete* (`r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq -`): Depth 1 (48 nodes), Depth 2 (2,039 nodes).
    - *Position 3* (`8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - -`): Tests en passant pin edge cases and rook check interactions.
- **Rules & Notation (`test/chess_core_test.dart`)**:
  - Castling rights invalidation upon king or rook move.
  - En passant expiration after 1 ply.
  - Pawn promotion to Queen, Rook, Bishop, Knight.
  - Insufficient material recognition (K vs K, K+B vs K, K+N vs K, K+B vs K+B same-color).
  - Threefold repetition detection via 64-bit Zobrist hash history.
  - 50-move rule counter verification.
  - Full SAN disambiguation and reversible FEN serialization.

### 2.2 Universal Engine & Root-Cause Classifier (`packages/chess_engine`)
- **Minimax Search & PST (`test/chess_engine_test.dart`)**:
  - Confirms deterministic evaluations for basic tactical shots (detects hanging Queen within depth 3).
  - Confirms mate-in-1 and mate-in-2 execution.
  - Evaluates king safety penalties when castling rights are lost under enemy fire.
- **Root-Cause Classification**:
  - Classifies moves played in under 3.0s as `impulsiveMove`.
  - Classifies blunders under clock $< 30\text{s}$ as `timePressure`.
  - Distinguishes between tactical oversights (`hangingPiece`, `missedForcingTactic`) and positional misunderstandings (`pawnStructureError`, `staticEvalError`).

### 2.3 Learning, Mastery Gates & Planner (`packages/chess_learning`)
- **Mastery Criteria (`test/chess_learning_test.dart`)**:
  - Verifies mastery thresholds: Knowledge $\ge 90\%$, Isolated $\ge 90\%$, Mixed $\ge 85\%$, Real-Game $\ge 80\%$, 7-Day $\ge 85\%$, 30-Day $\ge 80\%$.
  - Validates decay detection after 14 days of inactivity.
- **Adaptive Daily Planner**:
  - Generates 8h Intensive GM schedule, 60m Standard schedule, and 15m Express schedule.
  - Dynamically redistributes time away from mastered skills toward active diagnostic weaknesses.
- **Leitner Spaced Repetition**:
  - Confirms interval expansion: 1d $\rightarrow$ 3d $\rightarrow$ 7d $\rightarrow$ 14d $\rightarrow$ 30d.
  - Verifies immediate demotion to Box 1 upon calculation error.

### 2.4 Curriculum Catalog (`packages/chess_curriculum`)
- **90-Day Full Verification (`test/curriculum_test.dart`)**:
  - Iterates through all 90 days of the curriculum.
  - Asserts that every single day has valid FEN, instructions, exercise type, target moves, and pedagogical explanations.
  - Asserts that all 13 weekly exams (days 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90) have passing thresholds and comprehensive questions.

### 2.5 Interactive Labs Framework (`packages/chess_labs`)
- **Lab Sessions (`test/chess_labs_test.dart`)**:
  - Progressive hint penalties: Deducts 20 points per hint requested.
  - Mistake penalties: Deducts 25 points on wrong move.
  - Auto-reply: Verifies that when the user plays the correct move, the lab automatically plays the defensive refutation.
  - "No Tactic Exists" detection: Validates anti-puzzle decision logic.

### 2.6 Video Generation (`packages/chess_video`)
- **Timeline & FFmpeg (`test/chess_video_test.dart`)**:
  - Verifies frame indexing, timestamp continuity, and interpolation values (0.0 to 1.0).
  - Asserts critical pause injection when centipawn swing exceeds threshold.
  - Verifies generated FFmpeg command lines for H.264 MP4 and palette-optimized GIF.

### 2.7 Storage & Backup (`packages/chess_storage`)
- **Roundtrip Serialization (`test/chess_storage_test.dart`)**:
  - Exports user profile, 90-day progress, skill graph, and played games to JSON.
  - Imports the JSON into a fresh repository and asserts 100% field equality.

### 2.8 UI & App Deep Test Suite (`apps/chess_app/test/`)
- **`play_screen_deep_test.dart`**: Game clock transitions, sudden death, move execution, unfinished game state recovery.
- **`analysis_screen_deep_test.dart`**: PGN pasting, step-by-step navigation, self-analysis notes, engine audit lock.
- **`endgame_workspace_deep_test.dart`**: Lucena bridge, Philidor defense, Queen vs 7th pawn interactive drills against engine replies.
- **`labs_screen_deep_test.dart`**: Multi-mode lab switching, hint penalty deductions (-20%), reset exercises, evaluation gauge updates.
- **`video_studio_deep_test.dart`**: Aspect ratio selection (16:9, 9:16, 1:1), timeline scrubbing, overlay checkboxes, FFmpeg command generation.
- **`golden_responsive_regression_test.dart`**: Responsive layout testing across 5 viewports (360x640, 390x844, 600x900, 1280x800, 1920x1080), light and dark themes, and 1.5x accessibility text scaling.
- **`closed_loop_learning_test.dart`**: End-to-end flow from game blunder to root cause diagnosis, weakness profile update, Leitner SRS injection, reassessment, and mastery schedule update.
- **`extra_screens_deep_test.dart`**: Pawn promotion dialogs, ECO opening search, Guess-the-move lab, and study budget chips.
- **`final_coverage_booster_test.dart`**: Root cause badge cards, diagnostic prescriptions, and keyboard navigation.

### 2.9 Browser E2E & Production Bundle Smoke (`tool/web_e2e.py`)
- Automated Chrome DevTools Protocol test driving headless Chrome against exported production CanvasKit bundle.
- Tests SPA routing, Daily Journey, Curriculum, Play, and Labs screens.
- Captures production screenshots (`docs/screenshots/web_e2e_*.png`) and asserts 0 browser console errors.

## 3. Verified Line Coverage Matrix

| Package | Lines Covered | Total Lines | Coverage % | Release Gate | Verdict |
|:---|:---:|:---:|:---:|:---:|:---:|
| **`chess_core`** | 886 | 932 | **95.1%** | $\ge 95.0\%$ | **PASS** |
| **`chess_learning`** | 215 | 219 | **98.2%** | $\ge 95.0\%$ | **PASS** |
| **`chess_curriculum`**| 500 | 501 | **99.8%** | $\ge 90.0\%$ | **PASS** |
| **`chess_storage`** | 232 | 244 | **95.1%** | $\ge 90.0\%$ | **PASS** |
| **`chess_content`** | 213 | 230 | **92.6%** | $\ge 90.0\%$ | **PASS** |
| **`chess_video`** | 318 | 350 | **90.9%** | $\ge 90.0\%$ | **PASS** |
| **`chess_engine`** | 384 | 424 | **90.6%** | $\ge 90.0\%$ | **PASS** |
| **`chess_labs`** | 156 | 173 | **90.2%** | $\ge 90.0\%$ | **PASS** |
| **`apps/chess_app`** | 1,934 | 2,117 | **91.4%** | $\ge 90.0\%$ | **PASS** |
| **TOTAL AGGREGATE** | **4,838** | **5,190** | **93.2%** | $\ge 90.0\%$ | **PASS** |

## 4. Running Tests Locally

### Quick Execution
```bash
./scripts/test.sh        # Linux/macOS
.\scripts\test.ps1       # Windows PowerShell
```

### Coverage Audit & Fail-Under Validation
```bash
dart run tool/coverage_runner.dart
# Or via wrapper:
./scripts/coverage.sh         # Linux/macOS
.\scripts\coverage.ps1        # Windows PowerShell
```

### 90-Day Content Validation & Legality Gate
```bash
./scripts/content_validate.sh   # Linux/macOS
.\scripts\content_validate.ps1  # Windows PowerShell
```

### 90-Day Simulation & Persona Trajectories
```bash
./scripts/simulation_validate.sh   # Linux/macOS
.\scripts\simulation_validate.ps1  # Windows PowerShell
```

### Performance Truth Suite
```bash
./scripts/performance.sh      # Linux/macOS
.\scripts\performance.ps1     # Windows PowerShell
```

### Security & Secret Audit
```bash
./scripts/security.sh         # Linux/macOS
.\scripts\security.ps1        # Windows PowerShell
```

### Full Production Certification Pass
```bash
./scripts/certify.sh          # Linux/macOS
.\scripts\certify.ps1         # Windows PowerShell
```

### Acceptance Test Suite
```bash
./scripts/acceptance.sh --full    # Linux/macOS
.\scripts\acceptance.ps1 -Full    # Windows PowerShell
```
