# ChessMaster Platform

> **Production-grade, offline-first, cross-platform chess mastery platform and deterministic video factory.**

[![Acceptance](https://img.shields.io/badge/Acceptance-100%25%20Verified-brightgreen)](#)
[![License](https://img.shields.io/badge/License-MIT-blue)](#)
[![Offline-First](https://img.shields.io/badge/Offline--First-Core%20Ready-emerald)](#)
[![Deployment](https://img.shields.io/badge/Deploy-Cloudflare%20Pages%20Free-orange)](#)

---

## Overview

**ChessMaster** is an offline-first chess platform structured around a rigorous **90-Day GM-Style Mastery Program**. It transforms chess education from passive video watching into active, high-intensity cognitive training following the core grandmaster loop:

```
Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain
```

### User Journey Loop:
```
Diagnostic → Skill Graph → Adaptive Daily Plan → Labs → Serious Game → Self-Analysis → Engine Analysis → Root Cause → Retraining → Exam
```

> [!IMPORTANT]
> **FIDE Title Clarification**:
> ChessMaster develops grandmaster-level analytical discipline, tactical pattern vision, and endgame precision, but **never promises an official FIDE Grandmaster title**, which requires in-person participation in official FIDE-rated norm tournaments.

---

## Core Capabilities

1. **Complete 90-Day Curriculum**:
   - Day 1: Comprehensive Baseline Diagnostic across 12 skill axes.
   - Days 2–14: Tactical Foundation & Pattern Vision.
   - Days 15–28: Concrete Calculation Trees & Blindfold Visualization.
   - Days 29–42: Positional Strategy & Deep Pawn Structures.
   - Days 43–56: Theoretical Endgames (Opposition, Lucena, Philidor, Vancura).
   - Days 57–63: Compact Personalized Opening Repertoire.
   - Days 64–70: King Attacks & Defensive Tenacity.
   - Days 71–77: Advantage Conversion & Practical Decision Making.
   - Days 78–84: Tournament Mode (Classical 45+15, 60+30, 90+30 time controls).
   - Days 85–90: Integration, Retention Stabilization & Day 90 Final Certification.
   - Weekly Exams on Days `7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90`.

2. **Interactive Learn-by-Doing Labs**:
   - Tactical Recognition & Execution
   - Candidate Move Selection & Tree Pruning
   - Blindfold Calculation & Mental Stepping
   - Board Geometry Memory
   - Improving the Worst Piece
   - Pawn-Break Timing
   - Theoretical Endgame Win & Defend vs Engine
   - Guess-the-Move Master Game Reconstruction
   - Critical "No Tactic Exists" Recognition Drills.

3. **Cognitive Root-Cause Diagnostic Engine**:
   - Moves classified into: *Brilliant, Best, Great, Good, Inaccuracy, Mistake, Blunder, Missed Win*.
   - Inaccuracies and blunders diagnosed into 11 concrete cognitive root causes:
     1. Missed Tactic / Opponent Forcing Move
     2. Inadequate Candidate Generation
     3. Calculation Horizon / Visualization Cutoff
     4. Faulty Static Evaluation
     5. Positional / Pawn-Structure Error
     6. Opening Memory / Plan Deviation
     7. Endgame Technical Gap
     8. Advantage Conversion / Defensive Breakdown
     9. Time Pressure Panic (<30s)
     10. Impulsive / Rushed Move (<3s)
     11. Blunder Check Omission.
   - Automatically schedules targeted retraining in the Leitner spaced repetition queue.

4. **Deterministic Chess Video Generator**:
   - `PGN → parse → board states → Stockfish → annotations → animated board → overlays → FFmpeg → MP4/WebM/GIF`.
   - Profiles: 16:9 YouTube (1920x1080), 9:16 Shorts/Reels (1080x1920), 1:1 Social (1080x1080), Animated GIF.
   - Smooth 30/60fps piece motion, dynamic evaluation gauge, arrow overlays, critical pauses, and subtitles.

5. **Cloudflare Pages Free Deployment**:
   - Zero host dependencies for web deployment.
   - Static PWA bundle with service worker offline caching, `_headers`, and `_routes.json`.

---

## Quickstart

### 1. Run Acceptance Suite
```powershell
# Windows
powershell -ExecutionPolicy Bypass -File scripts/acceptance.ps1 -Full

# Linux / macOS
bash scripts/acceptance.sh --full
```
Outputs `acceptance.json` and `acceptance.html`.

### 2. Run Monorepo Test Suite
```powershell
powershell -ExecutionPolicy Bypass -File scripts/test.ps1
```

### 3. Launch Locally
```powershell
powershell -ExecutionPolicy Bypass -File scripts/up.ps1
```
Serves the web application on `http://localhost:8080`.

---

## Monorepo Architecture

```
chess90/
├── apps/
│   └── chess_app/             # Flutter cross-platform UI app (Web, Android, Desktop)
├── packages/
│   ├── chess_core/            # Legal chess rules, perft, bitboard, FEN, PGN, Zobrist, clocks
│   ├── chess_engine/          # UCI Stockfish adapter & embedded heuristic minimax engine
│   ├── chess_learning/        # 12-axis skill graph, mastery gates, Leitner review, daily planner
│   ├── chess_curriculum/      # Complete 90-day curriculum database, exercises, exams, cert
│   ├── chess_labs/            # Interactive lab sessions, progressive hints, scoring
│   ├── chess_content/         # Model games DB, automated PGN puzzle miner, ECO book
│   ├── chess_video/           # Deterministic video timeline generator & FFmpeg builder
│   └── chess_storage/         # Offline-first persistence, game history, JSON backup
├── scripts/                   # up, down, test, acceptance, clean (.ps1 & .sh)
├── infra/                     # Containerfile & compose.yml for Podman/Docker
├── docs/                      # Complete system documentation (34 files)
└── tests/                     # Acceptance verification test runner
```
