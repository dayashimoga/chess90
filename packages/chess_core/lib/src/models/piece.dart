/// Represents the color of chess pieces and players.
enum PieceColor {
  white,
  black;

  /// Returns the opponent's color.
  PieceColor get opponent => this == PieceColor.white ? PieceColor.black : PieceColor.white;
  PieceColor get opposite => opponent;

  /// Returns 1 for white, -1 for black.
  int get direction => this == PieceColor.white ? 1 : -1;

  /// Returns the starting pawn rank (1 for white, 6 for black in 0-indexed).
  int get pawnStartRank => this == PieceColor.white ? 1 : 6;

  /// Returns the pawn promotion rank (7 for white, 0 for black in 0-indexed).
  int get promotionRank => this == PieceColor.white ? 7 : 0;
}

/// Represents the piece types in standard chess.
enum PieceType {
  pawn(100, 'p'),
  knight(320, 'n'),
  bishop(330, 'b'),
  rook(500, 'r'),
  queen(900, 'q'),
  king(20000, 'k');

  final int baseValue;
  final String fenChar;

  const PieceType(this.baseValue, this.fenChar);

  static PieceType? fromFen(String char) {
    switch (char.toLowerCase()) {
      case 'p':
        return PieceType.pawn;
      case 'n':
        return PieceType.knight;
      case 'b':
        return PieceType.bishop;
      case 'r':
        return PieceType.rook;
      case 'q':
        return PieceType.queen;
      case 'k':
        return PieceType.king;
      default:
        return null;
    }
  }
}

/// Represents an immutable chess piece on the board.
class Piece {
  final PieceType type;
  final PieceColor color;

  const Piece(this.type, this.color);

  static const Piece whitePawn = Piece(PieceType.pawn, PieceColor.white);
  static const Piece whiteKnight = Piece(PieceType.knight, PieceColor.white);
  static const Piece whiteBishop = Piece(PieceType.bishop, PieceColor.white);
  static const Piece whiteRook = Piece(PieceType.rook, PieceColor.white);
  static const Piece whiteQueen = Piece(PieceType.queen, PieceColor.white);
  static const Piece whiteKing = Piece(PieceType.king, PieceColor.white);

  static const Piece blackPawn = Piece(PieceType.pawn, PieceColor.black);
  static const Piece blackKnight = Piece(PieceType.knight, PieceColor.black);
  static const Piece blackBishop = Piece(PieceType.bishop, PieceColor.black);
  static const Piece blackRook = Piece(PieceType.rook, PieceColor.black);
  static const Piece blackQueen = Piece(PieceType.queen, PieceColor.black);
  static const Piece blackKing = Piece(PieceType.king, PieceColor.black);

  /// Returns the standard FEN character for this piece (uppercase for White, lowercase for Black).
  String get fenChar => color == PieceColor.white ? type.fenChar.toUpperCase() : type.fenChar.toLowerCase();

  /// Returns the Unicode symbol for display.
  String get unicodeSymbol {
    if (color == PieceColor.white) {
      switch (type) {
        case PieceType.pawn:
          return '♙';
        case PieceType.knight:
          return '♘';
        case PieceType.bishop:
          return '♗';
        case PieceType.rook:
          return '♖';
        case PieceType.queen:
          return '♕';
        case PieceType.king:
          return '♔';
      }
    } else {
      switch (type) {
        case PieceType.pawn:
          return '♟';
        case PieceType.knight:
          return '♞';
        case PieceType.bishop:
          return '♝';
        case PieceType.rook:
          return '♜';
        case PieceType.queen:
          return '♛';
        case PieceType.king:
          return '♚';
      }
    }
  }

  static Piece? fromFenChar(String char) {
    if (char.isEmpty) return null;
    final type = PieceType.fromFen(char);
    if (type == null) return null;
    final color = char == char.toUpperCase() ? PieceColor.white : PieceColor.black;
    return Piece(type, color);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Piece && runtimeType == other.runtimeType && type == other.type && color == other.color;

  @override
  int get hashCode => type.hashCode ^ color.hashCode;

  @override
  String toString() => fenChar;
}
