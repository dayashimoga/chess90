# Developer Guide & Monorepo Architecture

## 1. Monorepo Layering & Dependency Hierarchy
ChessMaster is organized as a clean, modular monorepo to ensure strict separation of concerns, zero circular dependencies, and complete portability:

```
apps/chess_app  (Flutter Client: Web, Desktop, Android)
  │
  ├── packages/chess_storage     (Persistence, JSON Export/Import)
  ├── packages/chess_curriculum  (90 Days, 13 Exams, Certification)
  ├── packages/chess_labs        (Interactive Sandboxes, Hint Logic)
  ├── packages/chess_content     (Model Games, Puzzle Mining, ECO)
  ├── packages/chess_video       (Timeline Generator, FFmpeg Builder)
  │
  ├── packages/chess_learning    (Skill Graph, Mastery Gates, Planner)
  │     └── packages/chess_engine (Minimax, Stockfish UCI, Root Cause)
  │           └── packages/chess_core (Rules, MoveGen, Perft, FEN/PGN)
```

### Dependency Rules:
1. `packages/chess_core` is strictly standalone pure Dart with zero external package dependencies.
2. Domain logic in `packages/` must **never** import Flutter framework UI packages (`flutter/material.dart`). All domain models, algorithms, and engines remain testable in pure headless Dart runtimes.
3. UI widgets in `apps/chess_app` consume package controllers and streams via reactive state management.

---

## 2. Adding a New Interactive Lab

To implement a new specialized training lab:

### Step 1: Define Lab Logic in `packages/chess_labs`
Create a specialized configuration or subclass of `LabSession`:
```dart
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'lab_session.dart';

class ProphylaxisLab extends LabSession {
  final List<String> opponentThreats;

  ProphylaxisLab({
    required super.initialFen,
    required super.expectedSolutionMoves,
    required super.explanation,
    required this.opponentThreats,
  }) : super(exerciseType: 'prophylaxis');
}
```

### Step 2: Register in `CurriculumCatalog`
In `packages/chess_curriculum/lib/src/curriculum_catalog.dart`, assign the lab to the relevant day's curriculum definition:
```dart
CurriculumDay(
  day: 35,
  title: 'Positional Prophylaxis & Preventing Counterplay',
  phase: CurriculumPhase.strategy,
  axis: SkillAxis.strategy,
  fen: 'r1bqk2r/pp2bppp/2n1pn2/2pp4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQkq - 0 8',
  instruction: 'White must prevent Black from establishing an outpost on e4. Find the prophylactic prophylactic move.',
  targetMoves: ['a3', 'h3'],
  explanation: 'Restricts active minor pieces and maintains central stability.',
  exerciseType: 'prophylaxis',
)
```

### Step 3: Wire into `apps/chess_app`
In `apps/chess_app/lib/src/screens/labs_screen.dart`, add a UI chip or filter card so the user can launch the lab sandbox interactively.

---

## 3. Formatting, Linting & Quality Verification

Before committing changes:
```bash
# Format all packages and apps
dart format packages/ apps/ tests/

# Analyze static code
dart analyze packages/chess_core
dart analyze packages/chess_engine
dart analyze packages/chess_learning
dart analyze packages/chess_curriculum
dart analyze packages/chess_labs
dart analyze packages/chess_content
dart analyze packages/chess_video
dart analyze packages/chess_storage
flutter analyze apps/chess_app

# Run all tests
./scripts/test.sh # or .\scripts\test.ps1
```
