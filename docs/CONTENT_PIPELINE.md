# Content Pipeline & Puzzle Factory

## 1. Overview
The ChessMaster content factory transforms raw chess games, public-domain masterpieces, and user-imported PGN archives into structured, interactive curriculum assets, tactical puzzles, guess-the-move exercises, and opening studies.

## 2. Public-Domain Model Games Database
To guarantee ethical, legal, and license-compliant distribution, ChessMaster bundles only verifiable public-domain master games or author-generated analytical trees. **No copyrighted human commentary from commercial books or proprietary subscription services is ever bundled.**

### Bundled Historic Model Games:
1. **Paul Morphy vs. Duke of Brunswick and Count Isouard (1858, Paris Opera)**
   - *Theme*: Rapid mobilization, queen sacrifice, open lines, coordination against uncastled king.
   - *ECO*: `C41` (Philidor Defense).
2. **Jose Raul Capablanca vs. Savielly Tartakower (1924, New York)**
   - *Theme*: Classic endgame technique, active king march, rook behind passed pawn, cutting off the enemy king.
   - *ECO*: `A80` (Dutch Defense).
3. **Donald Byrne vs. Bobby Fischer (1956, "Game of the Century")**
   - *Theme*: Dynamic piece sacrifice, knight maneuver, queen sacrifice leading to windmill attack.
   - *ECO*: `D92` (Grünfeld Defense).
4. **Akiba Rubinstein vs. Georg Rotlewi (1907, "Rubinstein's Immortal")**
   - *Theme*: Total board harmony, double bishop battery, queen sacrifice, unstoppable mating net.
   - *ECO*: `D40` (Queen's Gambit Declined / Semi-Tarrasch).

## 3. Automated Puzzle Mining Architecture
The `PuzzleMiner` (`packages/chess_content/lib/src/puzzle_miner.dart`) automatically mines high-quality tactical puzzles from raw PGN files without human intervention.

```
       Raw PGN File
            │
            ▼
    [PgnParser] -> Game & Move Tree
            │
            ▼
    [Engine Ply Evaluation] (depth >= 12)
            │
            ▼
   Centipawn Delta Filter:
   (Eval[ply] - Eval[ply-1]) >= 180 cp ?
            │
       Yes  ├───────────────┐ No
            ▼               ▼
   [Uniqueness Filter]    [Discard]
   Best move vs 2nd best > 150 cp?
            │
       Yes  ├───────────────┐ No
            ▼               ▼
   [Motif Classifier]     [Discard Ambiguous]
   (Pin, Fork, Skewer, Deflection, Mate)
            │
            ▼
   Validated Puzzle Candidate:
   - FEN Setup
   - Solution Move (UCI/SAN)
   - Motif Tag
   - Difficulty Rating
   - Source Attribution
```

### 3.1 Quality Criteria & Rejection Rules
A position is rejected if:
1. **Ambiguity**: The second-best move is within 150 centipawns of the top move (multiple acceptable plans).
2. **Quiet Advantage**: The score improves due to long-term positional grinding rather than a concrete tactical sequence.
3. **Pre-existing Massive Advantage**: The side was already winning by $+6.0$ pawns before the opponent's move.
4. **Trivial Recapture**: The only tactic is recapturing an already lost piece with no secondary threats.

## 4. ECO Opening Book Integration
The `EcoBook` maps standard opening branches to structured master nodes.
- Over 500 ECO classifications (`A00` to `E99`).
- Fast trie lookup by move sequence (e.g., `1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6` $\rightarrow$ `B90 Sicilian Najdorf`).
- Transposition detection: Identifies when alternate move orders converge into known pawn structures (e.g., French Rubinstein transposition into Caro-Kann Tartakower).
