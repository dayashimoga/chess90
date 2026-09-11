# Stockfish & Teaching Engine Integration

## Universal Engine Adapter

ChessMaster implements a multi-backend engine architecture conforming to `ChessEngine`:

```
                    ChessEngine Interface
                              |
       +----------------------+----------------------+
       |                      |                      |
NativeStockfishEngine  WebStockfishEngine   EmbeddedHeuristicEngine
 (Process stdin/stdout)  (WASM Worker)       (Pure-Dart Minimax)
```

1. **`NativeStockfishEngine`**:
   - Launches external Stockfish binary via UCI protocol (`isready`, `position fen ... moves ...`, `go depth ... movetime ...`, `stop`).
   - Automatically falls back to `EmbeddedHeuristicEngine` if no native binary is detected.
2. **`WebStockfishEngine`**:
   - Interfaces with Stockfish.js running in a browser Web Worker.
   - Falls back seamlessly to `EmbeddedHeuristicEngine` for full offline reliability on web.
3. **`EmbeddedHeuristicEngine`**:
   - 100% pure Dart, zero-dependency minimax engine.
   - Alpha-beta pruning, quiescence search on capture lines, piece-square tables, king shelter, and mobility evaluation.
   - Guaranteed offline execution everywhere without native installs.

## The 11 Cognitive Root-Cause Classifications

1. `missedTacticOpponentForcingMove`: Overlooked concrete forcing line (check, capture, threat).
2. `badCandidateGeneration`: Failed to brainstorm viable candidate moves.
3. `visualizationCalculationHorizon`: Cut off calculation 1-2 moves too early.
4. `wrongEvaluation`: Reached correct end position, but misjudged who stood better.
5. `positionalPawnStructureMisunderstanding`: Weakened pawn structure or conceded outposts.
6. `openingMemoryPlan`: Deviated from opening principles or known repertoire.
7. `endgameGap`: Theoretical endgame mistake (<6 pieces remaining).
8. `conversionDefenseFailure`: Failed to convert winning position or defend under pressure.
9. `timePressure`: Blundered with <30 seconds remaining on clock.
10. `impulsiveMove`: Made a suboptimal move in <3 seconds thought time.
11. `failedBlunderCheck`: Left a piece hanging or missed 1-ply capture.
