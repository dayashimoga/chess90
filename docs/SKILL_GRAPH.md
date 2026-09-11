# Skill Graph Architecture

The ChessMaster platform models player chess ability across 12 distinct dimensions, organized hierarchically into sub-skills and tracked quantitatively.

## The 12 Core Skill Axes

1. **Tactics**: Pattern recognition of forks, pins, skewers, deflection, decoy, clearance, overload, trapped pieces, zwischenzug, and multi-motif mating nets.
2. **Calculation**: Tree generation, candidate selection, move ordering, pruning, and deep forcing variations.
3. **Visualization**: Blindfold calculation, mental board stepping, and board geometry memory.
4. **Strategy**: Static imbalances, king safety, development, initiative, tempo, space, outposts, and piece activity.
5. **Pawn Structures**: IQP, Carlsbad minority attack, Maroczy Bind, Hedgehog, pawn chains, and passed pawns.
6. **Endgames**: Opposition, key squares, triangulation, zugzwang, Lucena bridge, Philidor defense, and Vancura technique.
7. **Openings**: Repertoire mastery, structural understanding, plans, pawn breaks, and transpositions.
8. **Attack**: Piece concentration against castled king, opposite-side castling pawn storms, and sound sacrifices.
9. **Defense**: Prophylaxis, counterplay, fortress construction, and king evacuation under pressure.
10. **Conversion**: Simplifying winning positions, managing tension, and technical conversion of +1 pawn or exchange advantages.
11. **Time Management**: Clock pacing, time pressure composure (<30s), and critical position detection.
12. **Tournament Play**: Strict tournament time controls, absence of hints, and deep self-analysis discipline.

## Node Metrics Formula

Each node computes a difficulty-adjusted composite score (0.0 to 1.0):
```dart
compositeScore = (knowledgeScore * 0.15) +
                 (isolatedAccuracy * 0.20) +
                 (mixedAccuracy * 0.25) +
                 (realGameApplication * 0.20) +
                 (retention7Day * 0.10) +
                 (retention30Day * 0.10);
```

## State Transitions
```
[UNSEEN]
   ↓ (study theory)
[LEARNING]
   ↓ (isolated lab drills >= 75%)
[PRACTICING]
   ↓ (meet all 6 gate thresholds)
[MASTERED]
   ↓ (>14 days without review or score drop)
[DECAYING] ──> [RETEST]
```
If recurrent blunders occur (>=3 recent mistakes) or real-game application < 60%, the node transitions immediately to **`[WEAK]`**, triggering priority allocation in the Daily Planner.
