import '../models/move.dart';
import '../models/piece.dart';
import '../models/square.dart';
import '../zobrist/zobrist.dart';

/// Castling rights bitmask constants
class CastlingRights {
  static const int whiteKingside = 1;
  static const int whiteQueenside = 2;
  static const int blackKingside = 4;
  static const int blackQueenside = 8;
  static const int all = 15;
  static const int none = 0;
}

/// Represents an undoable move record on the board.
class MoveHistoryRecord {
  final Move move;
  final Piece? capturedPiece;
  final int previousCastlingRights;
  final Square? previousEnPassant;
  final int previousHalfmoveClock;
  final BigInt previousZobrist;

  const MoveHistoryRecord({
    required this.move,
    required this.capturedPiece,
    required this.previousCastlingRights,
    required this.previousEnPassant,
    required this.previousHalfmoveClock,
    required this.previousZobrist,
  });
}

/// The 8x8 chess board holding current piece placement, game history, and state flags.
class Board {
  final List<Piece?> _squares;
  PieceColor activeColor;
  int castlingRights;
  Square? enPassantSquare;
  int halfmoveClock;
  int fullmoveNumber;

  Square? _whiteKingSquare;
  Square? _blackKingSquare;

  final List<MoveHistoryRecord> _history = [];
  final Map<BigInt, int> _positionOccurrences = {};
  late BigInt _currentZobrist;

  Board._raw({
    required List<Piece?> squares,
    required this.activeColor,
    required this.castlingRights,
    required this.enPassantSquare,
    required this.halfmoveClock,
    required this.fullmoveNumber,
    Square? whiteKing,
    Square? blackKing,
  }) : _squares = List<Piece?>.from(squares, growable: false) {
    _whiteKingSquare = whiteKing;
    _blackKingSquare = blackKing;
    if (_whiteKingSquare == null || _blackKingSquare == null) {
      _findKings();
    }
    _currentZobrist = _computeZobrist();
    _positionOccurrences[_currentZobrist] = 1;
  }

  /// Creates a board in the standard chess starting position.
  factory Board.initial() {
    return Board.fromFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');
  }

  /// Creates an empty board.
  factory Board.empty() {
    return Board._raw(
      squares: List<Piece?>.filled(64, null),
      activeColor: PieceColor.white,
      castlingRights: CastlingRights.none,
      enPassantSquare: null,
      halfmoveClock: 0,
      fullmoveNumber: 1,
    );
  }

  /// Parses a board from a FEN string.
  factory Board.fromFen(String fen) {
    final parts = fen.trim().split(RegExp(r'\s+'));
    if (parts.length < 4) {
      throw ArgumentError('Invalid FEN format: expected at least 4 fields, got ${parts.length}');
    }

    final piecePlacement = parts[0];
    final activeColorStr = parts[1];
    final castlingStr = parts[2];
    final epStr = parts[3];
    final halfmove = parts.length > 4 ? int.tryParse(parts[4]) ?? 0 : 0;
    final fullmove = parts.length > 5 ? int.tryParse(parts[5]) ?? 1 : 1;

    final squares = List<Piece?>.filled(64, null);
    final ranks = piecePlacement.split('/');
    if (ranks.length != 8) {
      throw ArgumentError('Invalid FEN: expected 8 ranks in piece placement');
    }

    for (int rankIndex = 0; rankIndex < 8; rankIndex++) {
      final rankStr = ranks[rankIndex];
      final actualRank = 7 - rankIndex; // FEN begins with rank 8 down to 1
      int fileIndex = 0;

      for (int i = 0; i < rankStr.length; i++) {
        final char = rankStr[i];
        final digit = int.tryParse(char);
        if (digit != null) {
          fileIndex += digit;
        } else {
          final piece = Piece.fromFenChar(char);
          if (piece != null && fileIndex < 8) {
            final sq = actualRank * 8 + fileIndex;
            squares[sq] = piece;
          }
          fileIndex++;
        }
      }
    }

    final activeColor = activeColorStr.toLowerCase() == 'b' ? PieceColor.black : PieceColor.white;

    int castling = CastlingRights.none;
    if (castlingStr.contains('K')) castling |= CastlingRights.whiteKingside;
    if (castlingStr.contains('Q')) castling |= CastlingRights.whiteQueenside;
    if (castlingStr.contains('k')) castling |= CastlingRights.blackKingside;
    if (castlingStr.contains('q')) castling |= CastlingRights.blackQueenside;

    Square? epSquare;
    if (epStr != '-') {
      epSquare = Square.fromName(epStr);
    }

    return Board._raw(
      squares: squares,
      activeColor: activeColor,
      castlingRights: castling,
      enPassantSquare: epSquare,
      halfmoveClock: halfmove,
      fullmoveNumber: fullmove,
    );
  }

  void _findKings() {
    _whiteKingSquare = null;
    _blackKingSquare = null;
    for (int i = 0; i < 64; i++) {
      final p = _squares[i];
      if (p != null && p.type == PieceType.king) {
        if (p.color == PieceColor.white) {
          _whiteKingSquare = Square(i);
        } else {
          _blackKingSquare = Square(i);
        }
      }
    }
  }

  BigInt _computeZobrist() {
    BigInt h = BigInt.zero;
    for (int i = 0; i < 64; i++) {
      final p = _squares[i];
      if (p != null) {
        h ^= Zobrist.pieceKey(p, Square(i));
      }
    }
    h ^= Zobrist.castlingKey(castlingRights);
    h ^= Zobrist.enPassantKey(enPassantSquare?.file);
    if (activeColor == PieceColor.black) {
      h ^= Zobrist.sideKey();
    }
    return h;
  }

  BigInt get currentZobrist => _currentZobrist;

  /// Returns the piece at the given square.
  Piece? pieceAt(Square square) => _squares[square.index];

  /// Returns the piece at the given index (0..63).
  Piece? pieceAtIndex(int index) => _squares[index];

  /// Returns the square of the king of the given color.
  Square? kingSquare(PieceColor color) =>
      color == PieceColor.white ? _whiteKingSquare : _blackKingSquare;

  /// Returns how many times the current position has occurred in the game history.
  int get currentPositionOccurrences => _positionOccurrences[_currentZobrist] ?? 1;

  /// Clones the board into an independent copy.
  Board clone() {
    final b = Board._raw(
      squares: _squares,
      activeColor: activeColor,
      castlingRights: castlingRights,
      enPassantSquare: enPassantSquare,
      halfmoveClock: halfmoveClock,
      fullmoveNumber: fullmoveNumber,
      whiteKing: _whiteKingSquare,
      blackKing: _blackKingSquare,
    );
    // Copy history and occurrences
    b._history.addAll(_history);
    b._positionOccurrences.clear();
    b._positionOccurrences.addAll(_positionOccurrences);
    b._currentZobrist = _currentZobrist;
    return b;
  }

  /// Sets a piece directly on a square (clearing king caches if necessary).
  void setPiece(Square square, Piece? piece) {
    final old = _squares[square.index];
    if (old != null) {
      _currentZobrist ^= Zobrist.pieceKey(old, square);
      if (old.type == PieceType.king) {
        if (old.color == PieceColor.white) {
          _whiteKingSquare = null;
        } else {
          _blackKingSquare = null;
        }
      }
    }
    _squares[square.index] = piece;
    if (piece != null) {
      _currentZobrist ^= Zobrist.pieceKey(piece, square);
      if (piece.type == PieceType.king) {
        if (piece.color == PieceColor.white) {
          _whiteKingSquare = square;
        } else {
          _blackKingSquare = square;
        }
      }
    }
  }

  /// Executes a move on the board, updating all state, clocks, castling rights, and Zobrist hash.
  void makeMove(Move move) {
    final piece = _squares[move.from.index];
    if (piece == null) {
      throw StateError('Cannot make move: no piece at ${move.from}');
    }

    final prevCastling = castlingRights;
    final prevEp = enPassantSquare;
    final prevHalfmove = halfmoveClock;
    final prevZobrist = _currentZobrist;

    Piece? capturedPiece = _squares[move.to.index];

    // Handle en passant capture
    if (move.flag == MoveFlag.enPassant) {
      final capSqIndex = activeColor == PieceColor.white ? move.to.index - 8 : move.to.index + 8;
      capturedPiece = _squares[capSqIndex];
      _squares[capSqIndex] = null;
      _currentZobrist ^= Zobrist.pieceKey(capturedPiece!, Square(capSqIndex));
    } else if (capturedPiece != null) {
      _currentZobrist ^= Zobrist.pieceKey(capturedPiece, move.to);
    }

    // Move moving piece
    _squares[move.from.index] = null;
    _currentZobrist ^= Zobrist.pieceKey(piece, move.from);

    Piece placedPiece = piece;
    if (move.promotion != null) {
      placedPiece = Piece(move.promotion!, activeColor);
    }
    _squares[move.to.index] = placedPiece;
    _currentZobrist ^= Zobrist.pieceKey(placedPiece, move.to);

    // Update King square cache
    if (piece.type == PieceType.king) {
      if (activeColor == PieceColor.white) {
        _whiteKingSquare = move.to;
      } else {
        _blackKingSquare = move.to;
      }
    }

    // Handle castling rook movement
    if (move.flag == MoveFlag.castleKingside) {
      final rookFrom = activeColor == PieceColor.white ? Square.h1 : Square.h8;
      final rookTo = activeColor == PieceColor.white ? Square.f1 : Square.f8;
      final rook = _squares[rookFrom.index]!;
      _squares[rookFrom.index] = null;
      _squares[rookTo.index] = rook;
      _currentZobrist ^= Zobrist.pieceKey(rook, rookFrom);
      _currentZobrist ^= Zobrist.pieceKey(rook, rookTo);
    } else if (move.flag == MoveFlag.castleQueenside) {
      final rookFrom = activeColor == PieceColor.white ? Square.a1 : Square.a8;
      final rookTo = activeColor == PieceColor.white ? Square.d1 : Square.d8;
      final rook = _squares[rookFrom.index]!;
      _squares[rookFrom.index] = null;
      _squares[rookTo.index] = rook;
      _currentZobrist ^= Zobrist.pieceKey(rook, rookFrom);
      _currentZobrist ^= Zobrist.pieceKey(rook, rookTo);
    }

    // Update castling rights
    // If king moved
    if (piece.type == PieceType.king) {
      if (activeColor == PieceColor.white) {
        castlingRights &= ~(CastlingRights.whiteKingside | CastlingRights.whiteQueenside);
      } else {
        castlingRights &= ~(CastlingRights.blackKingside | CastlingRights.blackQueenside);
      }
    }
    // If rook moved from home square
    if (move.from == Square.a1) castlingRights &= ~CastlingRights.whiteQueenside;
    if (move.from == Square.h1) castlingRights &= ~CastlingRights.whiteKingside;
    if (move.from == Square.a8) castlingRights &= ~CastlingRights.blackQueenside;
    if (move.from == Square.h8) castlingRights &= ~CastlingRights.blackKingside;

    // If rook was captured on home square
    if (move.to == Square.a1) castlingRights &= ~CastlingRights.whiteQueenside;
    if (move.to == Square.h1) castlingRights &= ~CastlingRights.whiteKingside;
    if (move.to == Square.a8) castlingRights &= ~CastlingRights.blackQueenside;
    if (move.to == Square.h8) castlingRights &= ~CastlingRights.blackKingside;

    _currentZobrist ^= Zobrist.castlingKey(prevCastling);
    _currentZobrist ^= Zobrist.castlingKey(castlingRights);

    // Update En Passant square
    _currentZobrist ^= Zobrist.enPassantKey(prevEp?.file);
    if (move.flag == MoveFlag.pawnDoublePush) {
      final epIndex = activeColor == PieceColor.white ? move.from.index + 8 : move.from.index - 8;
      enPassantSquare = Square(epIndex);
    } else {
      enPassantSquare = null;
    }
    _currentZobrist ^= Zobrist.enPassantKey(enPassantSquare?.file);

    // Update halfmove clock (50-move rule: reset on pawn move or capture)
    if (piece.type == PieceType.pawn || capturedPiece != null) {
      halfmoveClock = 0;
    } else {
      halfmoveClock++;
    }

    // Update fullmove counter after Black moves
    if (activeColor == PieceColor.black) {
      fullmoveNumber++;
    }

    // Switch active color
    activeColor = activeColor.opponent;
    _currentZobrist ^= Zobrist.sideKey();

    // Push history record
    final record = MoveHistoryRecord(
      move: move,
      capturedPiece: capturedPiece,
      previousCastlingRights: prevCastling,
      previousEnPassant: prevEp,
      previousHalfmoveClock: prevHalfmove,
      previousZobrist: prevZobrist,
    );
    _history.add(record);

    // Update position occurrence
    _positionOccurrences[_currentZobrist] = (_positionOccurrences[_currentZobrist] ?? 0) + 1;
  }

  /// Undoes the most recently made move.
  void unmakeMove() {
    if (_history.isEmpty) return;
    final record = _history.removeLast();

    // Decrement position occurrence
    final occ = _positionOccurrences[_currentZobrist] ?? 1;
    if (occ <= 1) {
      _positionOccurrences.remove(_currentZobrist);
    } else {
      _positionOccurrences[_currentZobrist] = occ - 1;
    }

    final move = record.move;
    final movedPieceColor = activeColor.opponent;

    // Switch active color back
    activeColor = movedPieceColor;
    if (activeColor == PieceColor.black) {
      fullmoveNumber--;
    }

    halfmoveClock = record.previousHalfmoveClock;
    enPassantSquare = record.previousEnPassant;
    castlingRights = record.previousCastlingRights;

    // Restore moved piece
    Piece? placedPiece = _squares[move.to.index];
    if (move.promotion != null) {
      placedPiece = Piece(PieceType.pawn, movedPieceColor);
    }
    _squares[move.from.index] = placedPiece;
    _squares[move.to.index] = null;

    if (placedPiece != null && placedPiece.type == PieceType.king) {
      if (movedPieceColor == PieceColor.white) {
        _whiteKingSquare = move.from;
      } else {
        _blackKingSquare = move.from;
      }
    }

    // Restore captured piece
    if (move.flag == MoveFlag.enPassant) {
      final capSqIndex = movedPieceColor == PieceColor.white ? move.to.index - 8 : move.to.index + 8;
      _squares[capSqIndex] = record.capturedPiece;
    } else if (record.capturedPiece != null) {
      _squares[move.to.index] = record.capturedPiece;
    }

    // Restore castled rook
    if (move.flag == MoveFlag.castleKingside) {
      final rookFrom = movedPieceColor == PieceColor.white ? Square.h1 : Square.h8;
      final rookTo = movedPieceColor == PieceColor.white ? Square.f1 : Square.f8;
      final rook = _squares[rookTo.index]!;
      _squares[rookTo.index] = null;
      _squares[rookFrom.index] = rook;
    } else if (move.flag == MoveFlag.castleQueenside) {
      final rookFrom = movedPieceColor == PieceColor.white ? Square.a1 : Square.a8;
      final rookTo = movedPieceColor == PieceColor.white ? Square.d1 : Square.d8;
      final rook = _squares[rookTo.index]!;
      _squares[rookTo.index] = null;
      _squares[rookFrom.index] = rook;
    }

    _currentZobrist = record.previousZobrist;
  }

  /// Converts the board to standard FEN representation.
  String toFen() {
    final sb = StringBuffer();

    for (int rankIndex = 7; rankIndex >= 0; rankIndex--) {
      int emptyCount = 0;
      for (int fileIndex = 0; fileIndex < 8; fileIndex++) {
        final sq = rankIndex * 8 + fileIndex;
        final piece = _squares[sq];
        if (piece == null) {
          emptyCount++;
        } else {
          if (emptyCount > 0) {
            sb.write(emptyCount);
            emptyCount = 0;
          }
          sb.write(piece.fenChar);
        }
      }
      if (emptyCount > 0) {
        sb.write(emptyCount);
      }
      if (rankIndex > 0) {
        sb.write('/');
      }
    }

    sb.write(' ');
    sb.write(activeColor == PieceColor.white ? 'w' : 'b');

    sb.write(' ');
    if (castlingRights == CastlingRights.none) {
      sb.write('-');
    } else {
      if (castlingRights & CastlingRights.whiteKingside != 0) sb.write('K');
      if (castlingRights & CastlingRights.whiteQueenside != 0) sb.write('Q');
      if (castlingRights & CastlingRights.blackKingside != 0) sb.write('k');
      if (castlingRights & CastlingRights.blackQueenside != 0) sb.write('q');
    }

    sb.write(' ');
    sb.write(enPassantSquare?.name ?? '-');

    sb.write(' ');
    sb.write(halfmoveClock);

    sb.write(' ');
    sb.write(fullmoveNumber);

    return sb.toString();
  }

  List<MoveHistoryRecord> get history => List.unmodifiable(_history);
}
