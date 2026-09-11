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
