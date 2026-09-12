# ChessMaster Board UX & Move Visibility Architecture

## 1. Executive Summary
The ChessMaster board UX eliminates arbitrary board dimensions, piece visual defects, and "teleporting" move animations. A centralized sizing policy and deterministic animated travel pipeline guarantee predictable visual clarity across all game modes (Play, Curriculum, Labs, Analysis, Openings, Endgame, Model Games, and Video Studio).

---

## 2. Centralized Board Size Policy
Defined in `apps/chess_app/lib/src/theme/board_size_policy.dart`:

```dart
enum BoardPresentationMode {
  compact,       // Mobile portrait, dense layouts (max 380px)
  standard,      // Default desktop split-pane (max 640px)
  focus,         // Analysis full-focus mode (max 780px)
  editorPreview, // Video Studio preview canvas (max 880px)
}
```

### 2.1 Sizing Calculations
`BoardSizePolicy.calculateSquareSize(...)` guarantees:
1. Strict 1:1 aspect ratio for all 64 squares.
2. Square size clamped between `minSquareSize` (28px on ultra-compact mobile) and `maxSquareSize` (110px on 4K displays).
3. Zero clipping or viewport overflow by factoring in panel widths, navigation bars, coordinate labels (18px margin), and padding.

---

## 3. Animated Move Travel Pipeline
Opponent and engine moves must never teleport instantaneously. The animation pipeline consists of 7 distinct visual phases:

```
[Thinking Indicator] 
       │
       ▼
[Source Square Highlight]
       │
       ▼
[Piece Travels Source ➔ Destination (220-280ms smooth curve)]
       │
       ▼
[Capture Transition / Dissolve (if applicable)]
       │
       ▼
[Destination Square Highlight]
       │
       ▼
[Notation PGN Highlight]
       │
       ▼
[Board Settles into Idle State]
```

### 3.1 Special Moves Synchronization
- **Castling**: The King travels first, and the corresponding Rook moves simultaneously along its trajectory.
- **En-Passant**: The pawn advances diagonally to the empty destination square while the captured enemy pawn fades smoothly from its neighboring square.
- **Pawn Promotion**: The advancing pawn travels to the 8th/1st rank and morphs seamlessly into the promoted piece upon landing.
- **Check Overlay**: The King's square immediately pulses with a translucent red warning overlay upon landing in check.

### 3.2 Speed Configuration Profiles
Configurable in Settings and Video Studio:
- **Off**: 0ms instant placement (for high-speed batch analysis).
- **Fast**: 140ms quick transition.
- **Normal (Default)**: 240ms balanced presentation.
- **Learning**: 450ms deliberate slow travel for pattern absorption.

---

## 4. Persistent Highlights
- The source and destination squares of the most recent move remain highlighted until the next move is initiated.
- Highlights are drawn on a distinct canvas layer beneath piece sprites, preserving complete contrast and readability.
