# ChessMaster Product Requirements & Specification

**Document Version:** 1.3.0  
**Status:** Certified Production Ready  
**Standard:** 100% Zero Placeholders, 0 Fake Mocks, Deterministic Verification

---

## 1. Product Definition & Purpose

### What is ChessMaster?
ChessMaster is an offline-first, multi-platform, comprehensive 90-Day Chess Mastery training system built on Flutter and pure Dart. It couples a rigorous, FIDE-law compliant chess engine with an adaptive learning architecture, 16 interactive laboratory simulators, a 12-axis cognitive diagnostic radar, a Leitner spaced-repetition engine, and a deterministic video creation pipeline.

### What Does "90-Day Chess Mastery" Mean?
"90-Day Chess Mastery" means the **systematic, objective mastery of the 90-Day Grandmaster Curriculum Syllabus**. Over 90 structured training days across 10 progressive phases, learners internalize:
1. Core board geometry and tactical motifs (forks, pins, skewers, deflection, clearance, batteries).
2. Concrete calculation trees, candidate move selection, and blunder prevention.
3. Positional evaluation, key outposts, weak squares, and pawn structures (IQP, Carlsbad, Hedgehog).
4. Theoretical and practical endgames (Lucena bridge, Philidor defense, opposition, rook transitions).
5. Cohesive opening repertoires for White and Black, including anti-deviation defenses.
6. King safety, attacking technique, prophylactic defense, and conversion of advantages.
7. Clock pacing, time pressure composure, and tournament discipline.

> [!IMPORTANT]
> **FIDE Title Non-Promise Disclaimer (SEC-REG-001)**:  
> ChessMaster is an intensive educational curriculum. "Mastery" specifically denotes comprehensive command of the documented syllabus material and the passing of all 13 milestone exams. **Completion does NOT guarantee or confer an official FIDE title (Grandmaster, International Master, FIDE Master, Candidate Master) or official tournament Elo rating.** Official titles are awarded exclusively by the International Chess Federation (FIDE) based on norm performances in FIDE-rated over-the-board tournaments.

---

## 2. Target Learner Profiles & Entry Assessment

### Target Learner Levels
- **Beginner / Novice (1000–1400 Elo)**: Needs basic coordinate vision, blunder check discipline, primary tactical motifs, and opening fundamentals.
- **Intermediate / Club Player (1400–1800 Elo)**: Possesses tactical intuition; struggles with candidate move pruning, pawn structure dynamics, and endgame technique.
- **Advanced / Tournament Aspirant (1800–2200 Elo)**: Strong theoretical foundation; struggles with clock management under blitz pressure, subtle prophylaxis, and converting technical advantages against engine defense.
- **Asymmetric-Weakness Learners**: Players with sharp attacking skills but severe defensive blindspots (or vice versa).

### Entry Assessment (Day 1 Diagnostic Battery)
Every learner begins with the Day 1 Comprehensive Baseline Diagnostic:
- 10 coordinate recall and board vision probes.
- 10 multi-theme tactical recognition tests.
- 5 candidate move identification positions.
- Initial calculation depth threshold check.
- Automatic baseline scoring across all 12 Skill Axes to establish the initial Radar Profile.

---

## 3. Training Time Budget & Tracks

Learners select from three daily training tracks:
- **15-Minute Express Track (22.5 Total Hours)**: Core theory, 3 interactive exercises, and SRS flashcard recall.
- **1-Hour Standard Track (90.0 Total Hours)**: Theory, worked examples, exercises, model game analysis, and 1 engine sparring game.
- **8-Hour Intensive GM Track (720.0 Total Hours)**: Deep calculation trees, multi-variation opening drills, 16-lab simulations, master game annotations, and classical time-control tournament simulation.

---

## 4. Measurable Milestone Outcomes

### Day 30 Outcomes (Foundations, Tactics & Calculation)
- Tactical vision accuracy >=85% on mixed motif sets with zero hints.
- Unforced blunder rate reduced to <5% in practical sparring.
- Calculation tree visualization depth reliably reaches 3+ plies with candidate pruning.
- Passed Milestone Exams 1, 2, 3, and 4 (Days 7, 14, 21, 28).

### Day 60 Outcomes (Strategy, Structures & Endgames)
- Accurate identification of all 7 canonical pawn structures (IQP, Carlsbad, Hanging Pawns, Hedgehog, Closed Center, Open Center, Pawn Majority).
- 100% technical conversion in essential theoretical endgames (Lucena position, Philidor defense, King+Pawn opposition).
- Repertoire variation tree depth reaches 8–12 plies with strategic plan recall.
- Passed Milestone Exams 5, 6, 7, and 8 (Days 35, 42, 49, 56).

### Day 90 Outcomes (Full Integration & Exit Certification)
- 12-Axis Skill Radar demonstrates balanced development with no axis below 80% and aggregate syllabus mastery >=90%.
- Successful defense of inferior positions against heuristic engine utilizing fortress construction and counterplay.
- Clock management efficiency with <2% time-trouble blunder rate.
- Completion of Day 90 Comprehensive Exit Assessment comparing Day 1 baseline vs Day 90 certified performance.
- Generation of personalized Post-90-Day Continuous Improvement Roadmap.

---

## 5. Mastery Criteria & Remediation Rules

### Mastery Gate Criteria
For any skill node or curriculum day to be declared **Mastered**:
$$\text{Knowledge} \ge 90\%, \quad \text{Isolated Accuracy} \ge 90\%, \quad \text{Mixed Accuracy} \ge 85\%$$
$$\text{Real-Game Application} \ge 80\%, \quad \text{7-Day Retention} \ge 85\%, \quad \text{30-Day Retention} \ge 80\%$$

### Failure & Remediation Protocol
- If a learner scores $<80\%$ on daily exercises or $<70\%$ on a weekly milestone exam:
  1. **Advancement is strictly blocked**: Next curriculum day is locked.
  2. **Root cause diagnosis**: Engine classifies error into one of 14 root causes (`RootCauseCategory`).
  3. **Targeted training queued**: Leitner SRS flashcards focused specifically on the failed motif are generated.
  4. **Remediation lab assigned**: The learner must execute the prescribed interactive lab session with zero hint usage.
  5. **Retest required**: A new randomized position set must be passed at $\ge 85\%$ before unlocking progression.
- **No Free Passes**: No user can advance simply by clicking "Next" or skipping exercises.

---

## 6. Functional System Requirements

### 6.1 Core Chess Mechanics (`chess_core`)
- FIDE-compliant move generator with bitboard and 64-square array representation.
- Castling with check interception, En Passant, Promotions (Q, R, B, N).
- Termination: Checkmate, Stalemate, Threefold repetition (Zobrist hashing), 50-move rule, Insufficient material.
- Complete Perft suite: Depth 1–4 verified 100% against Shannon/Stockfish standard counts.

### 6.2 90-Day Curriculum (`chess_curriculum`)
- Full 90 days implemented with 0 reading-only days.
- Every day contains: Topic, Objectives, Prerequisites, Lesson, Worked Examples, Interactive Exercises, Game Study, Sparring Task, Assessment, Mastery Threshold, Remediation Protocol, SRS Review Tags, Estimated Minutes.
- 92 validated curriculum-day interactive exercises plus 3,694 training bank exercises = 3,786 interactive exercises with 100% legal moves verified via `MoveGenerator.sanToMove`.

### 6.3 Adaptive Learning & Skill Graph (`chess_learning`)
- 12 tracked skill axes with continuous composite mastery formula ($M = 0.35 \cdot S_{\text{skills}} + 0.35 \cdot C_{\text{curriculum}} + 0.20 \cdot E_{\text{exams}} + 0.10 \cdot R_{\text{retention}}$).
- DailyPlanner generates customized daily study schedules matching user time budget.
- LeitnerEngine provides 5-stage exponential spaced repetition.
- Closed-loop error feedback: learner blunder -> engine evaluation -> 14-axis root cause classification -> skill node decay -> SRS queue -> planner block injection -> retest.

### 6.4 Interactive Labs (`chess_labs`)
- 16 interactive training modes with hint penalties (-20% per hint) and auto-reply moves.
- Specialized labs: Tactical Recognition, Candidate Selection, Blind Calculation, Endgame Win/Defend, Board Memory, Visualization, Find The Plan, Positional Evaluation, Worst Piece Improvement, Pawn Break Discovery, Pawn Structure Lab, Opening Plan, Guess The Move, Defensive Resourcefulness, Conversion Challenge, Time Management.

### 6.5 Chess Engine Adapter (`chess_engine`)
- Triple-engine support: Native UCI Stockfish binary, WebAssembly browser Stockfish worker, and zero-dependency Embedded Minimax Alpha-Beta heuristic fallback engine.

### 6.6 Persistent Storage (`chess_storage`)
- Offline SQLite / SharedPreferences repository for profile, games, PGN library, study cards, and curriculum progress.

### 6.7 Video Pipeline (`chess_video`)
- Deterministic rendering pipeline producing MP4 (H.264), animated GIF, and thumbnail images from PGN with evaluation bars, arrows, and move text overlays.

---

## 7. Multi-Platform Release Requirements
1. **Web**: Production CanvasKit bundle (`ChessMaster-Web.zip`), deployed to Cloudflare Pages with COOP/COEP headers.
2. **Windows x64**: Packaged desktop executable and DLLs (`ChessMaster-Windows-x64.zip`).
3. **Linux x64**: Packaged desktop executable bundle (`ChessMaster-Linux-x64.tar.gz`).
4. **Android**: Universal release APK (`ChessMaster.apk`) and Google Play App Bundle (`ChessMaster.aab`).
5. **iOS / macOS**: Supported via Flutter codebase; labeled `PLATFORM_REQUIRED` when running in non-macOS environments.
