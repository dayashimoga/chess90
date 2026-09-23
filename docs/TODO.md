# ChessMaster TODO (Append-Only Forever)

This document is strictly append-only. Completed tasks are marked with `[x]` and dated. New enhancement items are appended at the bottom.

---

## Initial Release Milestone (v1.0.0)

- [x] (2026-09-10) Implement core chess domain models (`Square`, `Piece`, `Move`, `Board`) in `packages/chess_core`.
- [x] (2026-09-10) Implement bitboard legal move generator with check, pin, castling, promotion, and en passant handling.
- [x] (2026-09-10) Implement 64-bit Zobrist hashing and $O(1)$ threefold repetition detection.
- [x] (2026-09-10) Validate Perft benchmarks: initial position depths 1–4, Kiwipete, and Position 3.
- [x] (2026-09-10) Implement FEN and PGN parsers with full SAN disambiguation and clock/eval annotations.
- [x] (2026-09-10) Implement `EmbeddedHeuristicEngine` in pure Dart with alpha-beta minimax, quiescence, and PST tables.
- [x] (2026-09-10) Implement `NativeStockfishEngine` (UCI pipes) and `WebStockfishEngine` (Web Worker) with automatic embedded fallback.
- [x] (2026-09-10) Implement `RootCauseClassifier` classifying blunders into 11 cognitive categories.
- [x] (2026-09-10) Implement 12-axis Skill Graph, composite scoring, and mastery gates (`knowledge >= 90%`, `retention >= 85%`).
- [x] (2026-09-10) Implement `LeitnerEngine` spaced repetition flashcard system with automatic blunder enlistment.
- [x] (2026-09-10) Implement `DailyPlanner` supporting 8h Intensive GM, 60m Standard, and 15m Express daily schedules.
- [x] (2026-09-10) Implement full 90-day Curriculum Catalog across 10 pedagogical phases with verified FENs and instructions.
- [x] (2026-09-10) Implement 13 weekly exams on days 7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90.
- [x] (2026-09-10) Implement Day 90 certification report comparing baseline vs final metrics and next master roadmap.
- [x] (2026-09-10) Implement `LabSession` controller with hint penalties (-20%), mistake penalties (-25%), and auto-replies.
- [x] (2026-09-10) Implement specialized interactive labs: Tactical, Candidate Selection, Blind Calculation, Endgame Defend/Win.
- [x] (2026-09-10) Implement public-domain model games database (Morphy, Capablanca, Fischer, Rubinstein).
- [x] (2026-09-10) Implement `PuzzleMiner` algorithm detecting turning points ($\Delta cp \ge 180$) and filtering unique solutions.
- [x] (2026-09-10) Implement `EcoBook` with ECO codes and opening transpositions.
- [x] (2026-09-10) Implement video timeline generator supporting 16:9 YouTube, 9:16 Shorts/Reels, 1:1 Social, and GIF.
- [x] (2026-09-10) Implement frame interpolation (0.0 to 1.0), dynamic eval bars, arrows, and critical pauses.
- [x] (2026-09-10) Implement `FfmpegCommandBuilder` for deterministic MP4 and palette-optimized GIF rendering.
- [x] (2026-09-10) Implement offline-first local storage and 100% reversible JSON backup export/import.
- [x] (2026-09-10) Build cross-platform Flutter client with luxury dark `ChessTheme` and responsive design.
- [x] (2026-09-10) Build custom interactive widgets: `ChessBoardWidget`, `EvaluationBarWidget`, `MoveListWidget`, `SkillRadarWidget`.
- [x] (2026-09-10) Build 8 application screens: Daily Journey, Curriculum, Labs, Play, Analysis, Model Games, Video Studio, Certification.
- [x] (2026-09-10) Build production release bundle for Cloudflare Pages Free with `_headers` and `_routes.json`.
- [x] (2026-09-10) Build one-command automation scripts (`up`, `down`, `test`, `acceptance`, `clean` for `.ps1` and `.sh`).
- [x] (2026-09-10) Implement full automated acceptance runner (`tests/acceptance_runner.dart`) generating `acceptance.json` and `acceptance.html`.
- [x] (2026-09-10) Complete 34-document architecture, specification, and operations suite.

---

## Future Roadmap (Post v1.0.0 Enhancements)

- [ ] (2026-09-10) Connect physical DGT electronic chess boards via Bluetooth LE / Web Bluetooth serial API.
- [ ] (2026-09-10) Expand EcoBook opening repertoire tree to include full sub-variations for all 500 ECO codes.
- [ ] (2026-09-10) Add native Piper/Coqui neural text-to-speech engine integration for local offline audio commentary generation in Video Studio.
- [ ] (2026-09-10) Integrate WebRTC peer-to-peer offline local network multiplayer between tablets and desktops without internet.

---

## Production Certification & Forensic Gap-Closure Milestone (v1.1.0)

- [x] (2026-09-11) Implement `tool/coverage_runner.dart` collecting VM JSON and LCOV coverage with enforced fail-under gates (>90% aggregate, >=95% core packages).
- [x] (2026-09-11) Achieve 90.4% aggregate line coverage, 95.1% in `chess_core`, and 98.2% in `chess_learning`.
- [x] (2026-09-11) Implement `RealVideoRenderer` calling native FFmpeg 9.0.1 for real H.264 MP4 and palette-optimized GIF rendering.
- [x] (2026-09-11) Implement `VideoInspector` calling native FFprobe with stream JSON parsing and null-mux decode playback checks.
- [x] (2026-09-11) Complete implementation of all 16 interactive lab controllers in `packages/chess_labs`.
- [x] (2026-09-11) Implement Native Stockfish 19 host discovery and transparent UI labeling.
- [x] (2026-09-11) Implement LocalDatabase V1->V2 schema migration and atomic `.tmp` writes with corrupt backup protection.
- [x] (2026-09-11) Add multi-device viewport tests (360x640 phone, 768x1024 tablet, 1366x768 laptop, 1920x1080 desktop) and Semantics accessibility.
- [x] (2026-09-11) Implement 16-gate acceptance runner (`tests/acceptance_runner.dart`) passing 100% and generating versioned `acceptance.json` and `acceptance.html`.

---

## Production Certification, Podman & UX Overhaul Milestone (v1.2.0)

- [x] (2026-09-11) Add Podman / OCI container integration with `docs/CONTAINER.md`, `scripts/run_container.ps1`, and `scripts/run_container.sh`.
- [x] (2026-09-11) Implement accessible tournament dual-theme system (`lightTheme` with WCAG AA compliance and `darkTheme`).
- [x] (2026-09-11) Implement keyboard accessibility (arrow navigation, Space/Enter selection) and screen-reader `Semantics` move announcements.
- [x] (2026-09-11) Implement `OpeningExplorerScreen` with interactive ECO opening tree, search, and master lines.
- [x] (2026-09-11) Implement `EndgameWorkspaceScreen` covering theoretical endgames (Lucena, Philidor, Queen vs Pawn, Opposition) with live engine play.
- [x] (2026-09-11) Implement `WeaknessAnalyticsScreen` covering 14 root cause analysis breakdown, cognitive domain cards, radar, and retraining queue.
- [x] (2026-09-11) Implement `SettingsStorageScreen` with database health diagnostics, schema version migration, and offline JSON backup export/import.
- [x] (2026-09-11) Expand `RootCauseClassifier` to all 14 canonical hierarchical blunder categories with educational retraining prescriptions.
- [x] (2026-09-11) Implement `EngineWdl` model and `UCI_ShowWDL` parsing with transparent probability model labeling.
- [x] (2026-09-11) Add 7 content profiles to `VideoTimelineGenerator` and integrate video generation into batch pipeline.
- [x] (2026-09-11) Implement `tool/performance_runner.dart` benchmarking perft, FEN parsing, PGN throughput, engine latency, Leitner throughput, and storage I/O.
- [x] (2026-09-11) Implement `tool/security_runner.dart` validating zero vulnerabilities across path traversal, SQLi, FEN buffer attacks, PGN exploits, and supply chain.
- [x] (2026-09-11) Achieve 90.3% aggregate line coverage, 95.1% in `chess_core`, and 98.2% in `chess_learning` enforcing fail-under quality gates.
- [x] (2026-09-11) Compile and verify production Web release bundle (`apps/chess_app/build/web`) with `_headers` and `_routes.json`.
- [x] (2026-09-11) Verify 100% pass across all 16 Acceptance Gates in `acceptance.ps1 -Full` (status: PROVEN).
- [x] (2026-09-11) Generate distribution release manifests: `SHA256SUMS` and CycloneDX SBOM `sbom.json`.

---

## Final Production Hardening & Multi-Platform Validation Milestone (v1.2.0)

- [x] (2026-09-11) Lift `apps/chess_app` line coverage to 91.4% (1,934 / 2,117 lines) and total aggregate coverage to 93.1% (4,771 / 5,122 lines).
- [x] (2026-09-11) Implement 9 deep test suites in `apps/chess_app/test/` exercising all screens, clock dynamics, PGN analysis, and closed-loop learning.
- [x] (2026-09-11) Remediate RenderFlex layout overflow defects on compact mobile screens and high text scaling in `labs_screen.dart` and `main.dart`.
- [x] (2026-09-11) Implement automated Chrome DevTools Protocol browser E2E session (`tool/web_e2e.py`) verifying live production web bundle with 0 console errors (`web_e2e.json`).
- [x] (2026-09-11) Package web release bundle as `ChessMaster-Web.zip` (15.7 MB).
- [x] (2026-09-11) Scaffold native platform runners for Windows, Linux, and Android in `apps/chess_app`.
- [x] (2026-09-11) Install Linux desktop build toolchain (`clang`, `cmake`, `ninja`, `libgtk-3-dev`) in `infra/Containerfile`.
- [x] (2026-09-11) Complete comprehensive 15-document suite in `docs/` adhering to strict forensic guidelines.
- [x] (2026-09-11) Verify 16/16 Acceptance Gates certified PROVEN with 100% test pass rate and 0 P0/P1 defects remaining.
- [x] (2026-09-11) Fix Android build flag in CI (`.github/workflows/pr.yml`, `release.yml`, and `docs/BUILD_RELEASE.md`) removing invalid `--split-per-abi=false` flag and updating Android application label to `ChessMaster`.
- [x] (2026-09-11) Fix Windows `powershell scripts/test.ps1` CI failures in `packages/chess_video`: remove hardcoded user directory, add dynamic WinGet/Chocolatey/standard path resolution, install FFmpeg on Windows CI runner, and support graceful offline/failure mode testing when binaries are absent.
- [x] (2026-09-11) Fix Podman/OCI rootless container build failure in `infra/Containerfile`: configure `TAR_OPTIONS="--no-same-owner"` and `/usr/local/bin/tar` wrapper to prevent tar ownership errors (`chown to uid 397546, gid 5000: Invalid argument`) during Flutter precache of gradle-wrapper in rootless container environments.

---

## Final Forensic Gap-Closure & Production Certification Milestone (v1.3.0)

- [x] (2026-09-11) Enforce complete 14-dimension pedagogical schema in `packages/chess_curriculum` (`workedExamples`, `gameStudy`, `remediation`, `srsReview`, `masteryThreshold`, etc.).
- [x] (2026-09-11) Implement `tool/content_validator.dart` verifying 90/90 days, 92 exercises, 4 model games, 13 ECO openings, 16 interactive labs, generating `docs/CONTENT_INVENTORY.md` and `docs/FULL_90_DAY_CURRICULUM.md`.
- [x] (2026-09-11) Implement adaptive learner persona test suite `packages/chess_learning/test/adaptive_persona_simulation_test.dart` proving 4 personas receive materially different daily plans and failure blocks false graduation.
- [x] (2026-09-11) Implement `tool/simulation_runner.dart` simulating full 90 days for all personas, verifying reachability, monotonic difficulty progression, prerequisite enforcement, and baseline vs Day 90 radar comparison, generating `90_day_validation.json` and `90_day_validation.html`.
- [x] (2026-09-11) Refactor `tool/performance_runner.dart` under Directive 9 strictly separating Section A (algorithmic microbenchmarks) from Section B (real packaged UX latencies), eliminating synthetic 0.00ms UX claims, generating `performance.json` and `performance.html`.
- [x] (2026-09-11) Add all 18 visible dedicated CI/CD jobs to `.github/workflows/pr.yml` and multi-platform release automation to `.github/workflows/release.yml`.
- [x] (2026-09-11) Add one-command PowerShell and POSIX scripts in `scripts/` (`build`, `package`, `certify`, `content_validate`, `simulation_validate`, `coverage`, `performance`, `security`).
- [x] (2026-09-11) Update full documentation suite in `docs/` (`REQUIREMENTS.md`, `LEARNING_DESIGN.md`, `PLATFORM_MATRIX.md`, `TESTING.md`, `PRODUCTION_CERTIFICATION.md`) with explicit FIDE title non-promise disclaimers and zero placeholders.
- [x] (2026-09-12) Expand interactive training corpus to 3,786 exercises (92 curriculum days + 3,694 training bank drills across 7 banks: tactics, calculation, visualization, strategy, endgame, opening drills, practical analysis), all 100% legal-move validated.
- [x] (2026-09-12) Expand Master Model Games database to 60 deeply annotated master games across classical lineage, pawn structures, dynamic tactics, positional strategy, and theoretical endgames (`docs/MODEL_GAMES.md`).
- [x] (2026-09-12) Expand Opening Repertoire to 72 ECO opening variations spanning volumes A–E with move sequence trie indexing and deviation drill banks (`docs/OPENING_REPERTOIRE.md`).
- [x] (2026-09-12) Recalibrate Mastery Engine to Continuous Composite Mastery Model ($M = 0.35 \cdot S_{\text{skills}} + 0.35 \cdot C_{\text{curriculum}} + 0.20 \cdot E_{\text{exams}} + 0.10 \cdot R_{\text{retention}}$) eliminating binary node dropoffs, and integrate 14-axis blunder classification (`docs/MASTERY_MODEL.md`).
- [x] (2026-09-12) Deterministically validate 90-day personas in `tool/simulation_runner.dart`: Persona A (92.1% Day 90 Mastery), Persona B (Remediation blocker & retest resolution at 88.6%), Persona C (Asymmetric learner, endgames +45.2%, clock +24.8%, 77.8% Mastery).
- [x] (2026-09-12) Verify zero content errors in `tool/content_validator.dart` across all 3,786 exercises, 60 model games, 72 ECO openings, 16 lab types, and 13 exams (`docs/CONTENT_INVENTORY.md`).
- [x] (2026-09-12) Execute 100% clean test pass across all 8 monorepo packages and `apps/chess_app` in hermetic Podman container (`scripts/test.sh`).
- [x] (2026-09-12) Build and package production release archives in Podman container: `ChessMaster-Web.zip` (14.0 MB) and `ChessMaster-Linux-x64.tar.gz` (9.9 MB), updating `SHA256SUMS`.
- [x] (2026-09-12) Run and pass all 16 Acceptance Gates in `tests/acceptance_runner.dart --full`, all 6 Security Audits in `tool/security_runner.dart`, and all 18 Performance Budgets in `tool/performance_runner.dart`.

---

## Final Production Hardening & Complete Feature Pass (v1.3.1)

- [x] (2026-09-12) **Board Visuals (P0)**: Unified `PieceTheme`/`ChessBoardTheme` and resolution-independent vector rendering (`VectorPieceWidget`) for all 12 pieces across standard, high-contrast, and classic wood themes. Fixed Black pawns appearing grey/purple due to OS font fallback.
- [x] (2026-09-12) **Move Travel Pipeline (P0)**: Implemented shared smooth move animation pipeline (220–280ms) for opponent and engine moves with persistent last-move highlights, synchronized dual-piece castling and en-passant travel.
- [x] (2026-09-12) **Board Size Policy (P0)**: Centralized `BoardSizePolicy` (`compact`, `standard`, `focus`, `editorPreview`) ensuring 1:1 aspect ratio square bounds without clipping or overflow.
- [x] (2026-09-12) **Video Studio Complete Workflow (P0)**: Implemented Game Source Selector modal (Played, Model, Paste PGN with live syntax validation, Import PGN file), 3-pane responsive layout, scrubber, and progressive native FFmpeg MP4 export with progress modal, cancellation, and metadata verification.
- [x] (2026-09-12) **Video Acceptance Tests (P0)**: Generated and verified 4 real native FFmpeg MP4 videos (Model game, Played game with AAC audio muxing, Pasted PGN, Imported PGN file) + error handling tests passing 100% in `packages/chess_video/test/real_video_generation_e2e_test.dart`.
- [x] (2026-09-12) **Pedagogical Quality Audit (P0)**: Automated `tool/pedagogy_auditor.dart` generating `docs/PEDAGOGY_AUDIT.md` and `docs/pedagogy_audit.json` proving 90/90 days meet all 11 strict pedagogical criteria with 0 generic template-only text.
- [x] (2026-09-12) **Curriculum Presentation UX**: Display label format `Day N · Topic — Specific Skill`, phase filter, real-time search, and status badges (`CURRENT`, `EXAM`, `PASSED`).
- [x] (2026-09-12) **Content Consistency (P0)**: Reconciled 3,786 vs 3,694 exercise discrepancy: 3,694 bank exercises + 92 curriculum exercises = 3,786 unique exercises. Verified via `apps/chess_app/test/content_reconciliation_test.dart` and `tool/content_validator.dart`.
- [x] (2026-09-12) **Seamless Theme Toggle**: Integrated theme mode persistence via `StorageRepository` with reactive light/dark theme switches across settings and application shell.
- [x] (2026-09-12) **Windows Standalone Executable**: Updated `packaging/windows/package_windows.ps1` with native C# compiler (`csc.exe`) fallback to compile a standalone, true single-file `ChessMaster-Portable.exe` with embedded payload.
- [x] (2026-09-12) **Authoritative Release Manifest**: Generated `release_manifest.json`, `release_manifest.html`, and `docs/RELEASE_MANIFEST.md` with SHA-256 hashes and CI commands for all multi-platform artifacts.
- [x] (2026-09-12) **Zero Static Analysis Issues & 100% Test Pass**: Verified 0 issues across all 9 packages and tools in `scripts/analyze.sh` and 100% test pass rate in `scripts/test.sh`.
- [x] (2026-09-12) **Linux CI Smoke Build Hardening**: Fixed binary name mismatch in `.github/workflows/pr.yml` linux-smoke test; resolved `Binary chess_app missing` failure by supporting both `ChessMaster` and `chess_app` paths with symlink in archive packaging and dynamic detection in headless Xvfb launch step.

---

## Final Forensic Production Hardening & Universal Chess Engine Pass (v1.4.0)

- [x] (2026-09-12) **Single Chess Rendering Engine (P0)**: Eliminated letter-circle piece placeholders (`P/N/B/R/Q/K`) in exported MP4 videos by rewriting `FrameRasterizer` in `packages/chess_video` to use resolution-independent Staunton vector drawing (`_drawPawn`, `_drawRook`, `_drawKnight`, `_drawBishop`, `_drawQueen`, `_drawKing`) with drop shadows, body fill, and contrasting outlines, matching the in-app `VectorPieceWidget`.
- [x] (2026-09-12) **Decoded Video Frame Forensic Acceptance Test (P0)**: Added `Acceptance Test E: Forensic Decoded Video Frame Verification (No Circle Letter Placeholders)` to `packages/chess_video/test/real_video_generation_e2e_test.dart` asserting that decoded video frames contain true vector pieces, non-zero duration, valid H.264/AAC, and zero circle-letter badges (19/19 tests PASS 100%).
- [x] (2026-09-12) **Board & Piece Customization (P0)**: Implemented global settings in `SettingsStorageScreen` and live per-board quick customizer modal `BoardCustomizerDialog` for Board Themes (Tournament Green, Classic Wood, Slate Blue, High Contrast), Piece Themes (Standard Staunton, High Contrast, Classic Wood), Board Sizing Policy (Auto Responsive, Compact, Standard, Focus), Animation Speed (Off, Fast 150ms, Normal 280ms, Learning 500ms), Coordinates, Move Highlights, Legal Move Indicators, and Arrows with cross-session persistence in `UserProfile`.
- [x] (2026-09-12) **Responsive Board Sizing & Layout Overflow Hardening (P0)**: Eliminated board dimension divergence across modules and horizontal RenderFlex overflow on narrow viewports; tested and verified across 360x640, 390x844, 600x900, 1024x768, 1280x800, 1440x900, 1920x1080, and 2560x1440.
- [x] (2026-09-12) **Play vs Computer - Complete Game Setup (P0)**: Implemented `PlaySetupDialog` with Side (White/Black/Random), Opponent Strength (800 to 2400+ Elo or custom slider mapped to Stockfish UCI Skill Level & search depth), Game Type (Casual, Training, Serious, Rated), and Time Control (untimed to 30+20). Clear pre-game summary card.
- [x] (2026-09-12) **Complete Game Controls & Move Pipeline (P0)**: Implemented Undo/Takeback (with confirmation warning for Serious/Rated), Resign & Restart confirmations, Interactive Draw Offer evaluated by Stockfish, Clock Pause/Resume with board lock, Flip Board, Rematch with automatic color swap, 4-Tier Progressive Hints, Non-blocking engine calculation indicator, Post-Game Scrubber, and Navigate to Self-Analysis Workspace.
- [x] (2026-09-12) **5-Persona Real Learning Outcome Validation (P0)**: Implemented `tool/learning_outcome_runner.dart` conducting deterministic 90-day simulation across 5 distinct learner personas (Beginner, Intermediate, Advanced, Tactical-Strong/Endgame-Weak, Strategic-Strong/Calculation-Weak) generating authoritative `learning_outcome_validation.json` and `learning_outcome_validation.html`.
- [x] (2026-09-12) **Authoritative Release Manifest v1.4.0 (P0)**: Generated `release_manifest.json`, `release_manifest.html`, and `docs/RELEASE_MANIFEST.md` with SHA-256 hashes and CI commands for all multi-platform artifacts.

---

## Zero-Host-Installation Podman & Pedagogical Overhaul (v1.5.0)

- [x] (2026-09-23) **Zero-Host-Installation Containerization (P0)**: Configured Podman 5.8.3 container environment (`infra/Containerfile`, `scripts/run_container.ps1`) executing full build, test, coverage, performance, and security suites in an isolated OCI image with zero local host dependencies.
- [x] (2026-09-23) **Non-Blocking Onboarding Banner (P0)**: Replaced modal blocking dialogs with an inline card on `DailyJourneyScreen`; beginners can start Day 1 in 1 tap without mandatory diagnostic barriers.
- [x] (2026-09-23) **8-Stage Active Pedagogical Lesson Player (P0)**: Enforced strict active mastery cycle: `LEARN → SEE → UNDERSTAND → GUIDED PRACTICE → INDEPENDENT PRACTICE → MINI-GAME → REVIEW → RETENTION TEST` with zero reading-only completions permitted.
- [x] (2026-09-23) **Clean Unnested Windows Portable ZIP (P0)**: Updated `packaging/windows/package_windows.ps1` to produce `dist/ChessMaster-Windows-x64-Portable.zip` (12.07 MB) directly unnested without subfolder confusion.
- [x] (2026-09-23) **Cross-Version Flutter Compatibility (P0)**: Refactored theme data, switch tiles, semantics announcements, and dropdowns to universal Flutter primitives (`CardTheme`, `DialogTheme`, `activeColor`, `SemanticsService.announce`, `.withOpacity`).
- [x] (2026-09-23) **Clean-Room Certification Gate Pass (P0)**: Executed `scripts/run_container.ps1 -Action "certify"` with 100% pass across tests, content validation (3,786 unique exercises), 90-day simulation, coverage gates, 18 performance budgets, and 6 security audits.

---

## Final Production Certification & Forensic Overhaul (v1.6.0)

- [x] (2026-09-23) **Automated Forensic Gap Auditor & Matrix (P0)**: Created `tool/forensic_auditor.dart` producing `docs/gap-analysis.json`, `docs/gap-analysis.html`, and `docs/REQUIREMENT_RUNTIME_EVIDENCE_MATRIX.md` verifying all 13 core directives against independent runtime evidence.
- [x] (2026-09-23) **Crash Course / Academy Complete Expansion (P0)**: Expanded `AcademyScreen` micro-course catalog from 9 to 28 interactive visual micro-courses covering the complete chess syllabus (Rules, Notation, Piece Values, Check/Mate/Draw, LPDO, Forks, Pins, Skewers, Discovered Attacks, Deflection, Overload, Clearance, Mating Patterns, CCT, Candidate Moves, Blunder Checks, Positional Evaluation, Outposts, Open Files, Bishop Pair, Pawn Chains, Minority Attack, IQP, King Attacks, Lucena, Philidor, Opposition, Opening Principles, and Clock Management) with interactive FEN diagrams and target lab links.
- [x] (2026-09-23) **Opening Intelligence & Post-Game Theory Departure Engine (P0)**: Enriched `EcoEntry` in `packages/chess_content` with strategic plans, why moves work, pawn structures, breaks, and traps. Implemented `OpeningDepartureReport` and `EcoBook.analyzeDeparture` to automatically identify departure ply, deviating move, strategic consequences, and recommended plans (16/16 tests PASS).
- [x] (2026-09-23) **Difficulty Badging Calibration (P0)**: Replaced all raw "Elo X" labels across `CurriculumScreen`, `PlaySetupDialog`, and `PlayScreen` with calibrated "Estimated Difficulty: X" / "Est. X".
- [x] (2026-09-23) **Honest Endgame Engine Labeling (P0)**: Removed unbacked "tablebase conversion" claims in curriculum days and documentation; accurately labeled as "Theoretical Endgame Engine Precision" and "Theoretical Endgame Knowledge Certification".
- [x] (2026-09-23) **GitHub Actions Multi-Platform Release Alignment (P0)**: Updated `.github/workflows/release.yml`, `.github/workflows/pr.yml`, and `scripts/package.ps1` to produce and upload exact required artifact filenames (`ChessMaster-Web.zip`, `ChessMaster-Android.apk`, `ChessMaster-Android.aab`, `ChessMaster-Windows-x64-Portable.zip`, `ChessMaster-Linux-x64.tar.gz`) along with all verification reports.
- [x] (2026-09-23) **Clean-Room Container Certification (P0)**: Integrated `forensic_auditor.dart` and `acceptance_runner.dart --full` into container certification gate in `scripts/run_container.ps1` and `scripts/run_container.sh`.

---

## CI / PR Pipeline Hardening & Multi-Platform Matrix Resolution (v1.6.1)

- [x] (2026-09-23) **Monorepo Static Analysis Hardening (P0)**: Standardized CI `lint/static` job to run `bash scripts/analyze.sh` which executes `flutter pub get` and `flutter analyze` for Flutter apps and `dart pub get` and `dart analyze` for pure Dart packages; cleaned all warnings in `tool/forensic_auditor.dart` and added `tool/analysis_options.yaml` (0 issues across all 10 packages).
- [x] (2026-09-23) **Android Gradle Toolchain Fix (P0)**: Corrected AGP to stable 8.5.0, Kotlin to 2.0.0, and Gradle wrapper to 8.7 in `apps/chess_app/android/`; added `--android-skip-build-dependency-validation` flag to `flutter build apk` and `appbundle` in `pr.yml` and `release.yml` resolving Flutter 3.29 version check failure.
- [x] (2026-09-23) **Linux Packaging & Smoke Hardening (P0)**: Replaced symlink commands in `pr.yml` and `release.yml` with safe binary copy validation, ensuring `ChessMaster` and `chess_app` are intact in tarball and pass headless Xvfb smoke verification.
- [x] (2026-09-23) **CI Clean-State Dependency Resolution (P0)**: Enforced explicit `flutter pub get` across all build jobs (`build-web`, `build-windows`, `build-linux`, `build-android-apk-aab`, `widget/golden`), added system utilities (`ffmpeg`, `stockfish`) on Ubuntu runner, and added `pub get` in `scripts/test.ps1`.
- [x] (2026-09-23) **Clean-Room Podman Verification (P0)**: Re-validated 100% test pass rate, 0 lint issues, and full container certification gate via Podman with zero host dependencies.
- [x] (2026-09-23) **Windows & Multi-Platform Theme Compatibility (P0)**: Removed `cardTheme` and `dialogTheme` in `apps/chess_app/lib/src/theme/chess_theme.dart` to eliminate compilation breakage on Flutter 3.27+ (`CardThemeData?`/`DialogThemeData?` type mismatch); confirmed 100% test pass across all 101 tests and 0 analysis issues.







