# Data Model Specification

## Core Domain Entities

### `Piece`
```dart
class Piece {
  final PieceType type;   // pawn, knight, bishop, rook, queen, king
  final PieceColor color; // white, black
  String get fenChar;     // 'P', 'p', 'N', 'n', etc.
  String get unicodeSymbol; // '♙', '♟', '♘', '♞', etc.
}
```

### `Square`
```dart
class Square {
  final int index;        // 0 (a1) to 63 (h8)
  int get file;           // 0 (a) to 7 (h)
  int get rank;           // 0 (1) to 7 (8)
  String get name;        // e.g. 'e4'
  bool get isLightSquare;
}
```

### `Move`
```dart
class Move {
  final Square from;
  final Square to;
  final PieceType? promotion;
  final MoveFlag flag; // normal, pawnDoublePush, enPassant, castleKingside, castleQueenside, promotion
  final bool isCapture;
  String get uci; // e.g. 'e2e4', 'e7e8q'
}
```

### `Board`
```dart
class Board {
  List<Piece?> _squares;      // 64 squares
  PieceColor activeColor;
  int castlingRights;        // 4-bit bitmask (WK, WQ, BK, BQ)
  Square? enPassantSquare;
  int halfmoveClock;         // 50-move counter
  int fullmoveNumber;
  BigInt _currentZobrist;     // 64-bit Zobrist key
}
```

### `SkillNode`
```dart
class SkillNode {
  final String id;
  final String name;
  final SkillAxis axis;
  double knowledgeScore;      // 0.0 - 1.0
  double isolatedAccuracy;    // 0.0 - 1.0
  double mixedAccuracy;       // 0.0 - 1.0
  double realGameApplication; // 0.0 - 1.0
  double retention7Day;       // 0.0 - 1.0
  double retention30Day;      // 0.0 - 1.0
  int responseTimeMs;
  int recurrenceCount;
  SkillStatus status;         // unseen, learning, practicing, weak, retest, mastered, decaying
  DateTime lastPracticed;
}
```

### `ReviewItem` (Leitner Spaced Repetition)
```dart
class ReviewItem {
  final String id;
  final String fen;
  final List<String> solutionSan;
  final String skillNodeId;
  final String motif;
  int stage;                  // 0 (same) -> 1 (1d) -> 2 (3d) -> 3 (7d) -> 4 (14d) -> 5 (30d)
  DateTime nextReviewDate;
  int successStreak;
  int failureCount;
}
```

### `GameRecord`
```dart
class GameRecord {
  final String id;
  final String pgn;
  final DateTime playedDate;
  final String whitePlayer;
  final String blackPlayer;
  final String result;
  final String timeControl;
  final Map<int, String> selfAnalysisNotes;
  final List<Map<String, dynamic>> diagnosedErrors;
}
```
