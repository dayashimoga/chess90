# Repository Structure

```
chess90/
├── apps/
│   └── chess_app/                    # Cross-Platform Flutter Client App
│       ├── lib/
│       │   ├── src/
│       │   │   ├── screens/          # Daily, Curriculum, Labs, Play, Analysis, Video, Cert
│       │   │   ├── theme/            # Luxury dark theme design tokens
│       │   │   └── widgets/          # Board, EvalBar, MoveList, SkillRadar
│       │   └── main.dart             # Application shell & NavigationRail
│       ├── web/                      # Cloudflare Pages Free deployment config
│       │   ├── index.html            # Static HTML5 entry & PWA loader
│       │   ├── manifest.json         # Web App Manifest
│       │   ├── _headers              # Cloudflare security & WASM caching headers
│       │   └── _routes.json          # Cloudflare SPA routing rules
│       ├── test/                     # Widget tests
│       └── pubspec.yaml
│
├── packages/
│   ├── chess_core/                   # Complete Legal Chess Engine Domain
│   │   ├── lib/src/
│   │   │   ├── board/board.dart      # 64-square board array + state flags
│   │   │   ├── clock/chess_clock.dart # Classical / Rapid / Blitz chess clocks
│   │   │   ├── fen/fen_parser.dart   # FEN import / export & validation
│   │   │   ├── models/               # Piece, Square, Move representations
│   │   │   ├── pgn/pgn_parser.dart   # Full PGN move tree & variation parser
│   │   │   ├── rules/                # Legal move generator & game state evaluation
│   │   │   └── zobrist/zobrist.dart  # 64-bit cross-platform Zobrist hashing
│   │   └── test/                     # Unit & Perft correctness test suites
│   │
│   ├── chess_engine/                 # Universal Engine & Analysis Adapter
│   │   ├── lib/src/
│   │   │   ├── analysis/             # MoveQuality & 11 RootCauseClassifier
│   │   │   ├── embedded_heuristic_engine.dart # Minimax Alpha-Beta engine
│   │   │   ├── engine_interface.dart # Common engine API
│   │   │   ├── native_stockfish.dart # Native UCI process client
│   │   │   └── web_stockfish.dart    # Web Worker WASM Stockfish interface
│   │   └── test/                     # Engine & diagnostic unit tests
│   │
│   ├── chess_learning/               # Adaptive Mastery & Skill Graph
│   │   ├── lib/src/
│   │   │   ├── adaptive_planner/     # Daily planner & time redistributor
│   │   │   ├── mastery/              # MasteryGates validator
│   │   │   ├── skill_graph/          # 12 SkillAxis & SkillNode representations
│   │   │   └── spaced_repetition/    # LeitnerEngine (same -> 1d -> 3d -> 7d -> 14d -> 30d)
│   │   └── test/                     # Mastery gates & planner tests
│   │
│   ├── chess_curriculum/             # Complete 90-Day Curriculum Database
│   │   ├── lib/src/
│   │   │   ├── data/                 # Complete 90-day syllabus database
│   │   │   └── models/               # CurriculumDay & CurriculumExercise
│   │   └── test/                     # Curriculum completeness tests
│   │
│   ├── chess_labs/                   # Interactive Learn-by-Doing Lab Framework
│   │   ├── lib/src/
│   │   │   ├── lab_session.dart      # Generic lab session controller
│   │   │   └── labs/                 # Tactical, Candidate, Blindfold, Endgame vs Engine
│   │   └── test/                     # Lab interaction & hint penalty tests
│   │
│   ├── chess_content/                # Master Model Games & Puzzle Miner
│   │   ├── lib/src/
│   │   │   ├── eco/                  # ECO opening book & move matcher
│   │   │   ├── model_games/          # Morphy, Capablanca, Fischer, Rubinstein DB
│   │   │   └── puzzle_miner/         # Automated PGN puzzle generator
│   │   └── test/                     # Content & puzzle miner tests
│   │
│   ├── chess_video/                  # Deterministic Video Generation Pipeline
│   │   ├── lib/src/
│   │   │   ├── ffmpeg_command_builder.dart # Command generator for MP4/GIF
│   │   │   ├── models/               # VideoProfile & VideoFrame representations
│   │   │   └── video_timeline_generator.dart # 30/60 FPS frame interpolator
│   │   └── test/                     # Timeline & FFmpeg command tests
│   │
│   └── chess_storage/                # Offline-First Persistence & JSON Backup
│       ├── lib/src/
│       │   ├── models/               # UserProfile & GameRecord
│       │   └── storage_repository.dart # Full JSON export & import repository
│       └── test/                     # Persistence & backup roundtrip tests
│
├── scripts/                          # Lifecycle Automation Scripts (.ps1 & .sh)
│   ├── up.ps1 / up.sh                # Local dev server launcher
│   ├── down.ps1 / down.sh            # Server teardown
│   ├── test.ps1 / test.sh            # Monorepo test runner
│   ├── acceptance.ps1 / acceptance.sh # Full acceptance verification suite
│   └── clean.ps1 / clean.sh          # Cache & artifact clean
│
├── infra/                            # Disposable Container Configurations
│   ├── Containerfile                 # Podman / Docker container specification
│   └── compose.yml                   # Compose service setup
│
├── tests/                            # Comprehensive Acceptance Suite
│   ├── acceptance_runner.dart        # Runner generating acceptance.json and acceptance.html
│   └── pubspec.yaml
│
├── docs/                             # 34 Complete System Documentation Files
├── .github/workflows/                # GitHub Actions PR & Release Pipelines
├── acceptance.json                   # Verified acceptance test outputs (JSON)
├── acceptance.html                   # Verified acceptance test dashboard (HTML)
└── pubspec.yaml                      # Root monorepo workspace definition
```
