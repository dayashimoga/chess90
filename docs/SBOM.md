# Software Bill of Materials (SBOM)

## 1. Metadata
- **Product**: ChessMaster
- **Version**: `1.0.0+1`
- **Specification**: CycloneDX / SPDX Compliant Summary
- **Generated**: 2026-09-10
- **Primary Toolchain**: Flutter 3.24+ / Dart 3.5+

## 2. Package Dependency Matrix

| Package Identifier | Direct Dependencies | License | Purpose |
| :--- | :--- | :--- | :--- |
| `apps/chess_app` | `flutter`, `chess_core`, `chess_engine`, `chess_learning`, `chess_curriculum`, `chess_labs`, `chess_content`, `chess_video`, `chess_storage` | MIT / BSD | Cross-platform client application |
| `packages/chess_core` | `dart:core`, `dart:math` (Zero external packages) | MIT | Legal rules, Perft, FEN/PGN parser |
| `packages/chess_engine` | `chess_core`, `dart:io`, `dart:async` | MIT | Embedded minimax, Stockfish UCI adapter |
| `packages/chess_learning` | `chess_core`, `chess_engine` | MIT | Skill graph, Leitner SRS, Daily planner |
| `packages/chess_curriculum` | `chess_core`, `chess_engine`, `chess_learning`| MIT | 90-day catalog, 13 weekly exams |
| `packages/chess_labs` | `chess_core`, `chess_engine` | MIT | Interactive lab controllers & scoring |
| `packages/chess_content` | `chess_core`, `chess_engine` | MIT | Model games DB, puzzle mining algorithm |
| `packages/chess_video` | `chess_core`, `chess_engine` | MIT | Timeline generator, FFmpeg command builder |
| `packages/chess_storage` | `chess_core`, `chess_learning` | MIT | Local persistence, JSON backup serializer |

## 3. Development & Toolchain Dependencies

| Component | Version Constraint | License | Role |
| :--- | :--- | :--- | :--- |
| `dart:test` | `^1.24.0` | BSD-3-Clause | Unit and integration test harness |
| `flutter_test` | SDK bundled | BSD-3-Clause | Widget test framework |
| `FFmpeg` | 5.0+ (optional external) | LGPL / GPL | Deterministic video encoder |
| `Stockfish` | 16+ (optional external) | GPLv3 | Native chess engine process |

## 4. Security & Vulnerability Audit
- **Dependency Audit**: Clean (`0` vulnerabilities identified via `dart pub audit`).
- **Secret Scan**: Clean (`0` API tokens, private keys, or credentials embedded).
- **License Compliance**: 100% compliant with permissive MIT/BSD licenses across all application bundles.
