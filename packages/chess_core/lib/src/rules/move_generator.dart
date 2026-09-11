import '../board/board.dart';
import '../models/move.dart';
import '../models/piece.dart';
import '../models/square.dart';
import 'game_state.dart';

/// Complete legal chess move generator and game rules validator.
class MoveGenerator {
  // Knight move offsets: (dFile, dRank)
  static const List<List<int>> _knightDeltas = [
    [1, 2], [2, 1], [2, -1], [1, -2],
    [-1, -2], [-2, -1], [-2, 1], [-1, 2],
  ];

  // Bishop ray directions: (dFile, dRank)
  static const List<List<int>> _bishopDirections = [
    [1, 1], [1, -1], [-1, 1], [-1, -1],
  ];

  // Rook ray directions: (dFile, dRank)
  static const List<List<int>> _rookDirections = [
    [1, 0], [-1, 0], [0, 1], [0, -1],
  ];

  // King move offsets
  static const List<List<int>> _kingDeltas = [
    [1, 0], [-1, 0], [0, 1], [0, -1],
    [1, 1], [1, -1], [-1, 1], [-1, -1],
  ];

  /// Tests whether a given square is attacked by any piece of the specified attacking color.
  static bool isSquareAttacked(Square square, PieceColor attackerColor, Board board) {
    final sqFile = square.file;
    final sqRank = square.rank;

    // 1. Attacked by pawns
    final pawnDir = attackerColor == PieceColor.white ? 1 : -1;
    // An attacking pawn must be at (sqRank - pawnDir) and (sqFile +/- 1)
    final pRank = sqRank - pawnDir;
    if (pRank >= 0 && pRank < 8) {
      if (sqFile > 0) {
        final p = board.pieceAt(Square.fromCoords(sqFile - 1, pRank));
        if (p != null && p.color == attackerColor && p.type == PieceType.pawn) {
          return true;
        }
      }
      if (sqFile < 7) {
        final p = board.pieceAt(Square.fromCoords(sqFile + 1, pRank));
        if (p != null && p.color == attackerColor && p.type == PieceType.pawn) {
          return true;
        }
      }
    }

    // 2. Attacked by knights
    for (final delta in _knightDeltas) {
      final f = sqFile + delta[0];
      final r = sqRank + delta[1];
      if (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final p = board.pieceAt(Square.fromCoords(f, r));
        if (p != null && p.color == attackerColor && p.type == PieceType.knight) {
          return true;
        }
      }
    }

    // 3. Attacked along diagonals (bishops / queens)
    for (final dir in _bishopDirections) {
      int f = sqFile + dir[0];
      int r = sqRank + dir[1];
      while (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final p = board.pieceAt(Square.fromCoords(f, r));
        if (p != null) {
          if (p.color == attackerColor && (p.type == PieceType.bishop || p.type == PieceType.queen)) {
            return true;
          }
          break; // Line blocked
        }
        f += dir[0];
        r += dir[1];
      }
    }

    // 4. Attacked along straight lines (rooks / queens)
    for (final dir in _rookDirections) {
      int f = sqFile + dir[0];
      int r = sqRank + dir[1];
      while (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final p = board.pieceAt(Square.fromCoords(f, r));
        if (p != null) {
          if (p.color == attackerColor && (p.type == PieceType.rook || p.type == PieceType.queen)) {
            return true;
          }
          break; // Line blocked
        }
        f += dir[0];
        r += dir[1];
      }
    }

    // 5. Attacked by king
    for (final delta in _kingDeltas) {
      final f = sqFile + delta[0];
      final r = sqRank + delta[1];
      if (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final p = board.pieceAt(Square.fromCoords(f, r));
        if (p != null && p.color == attackerColor && p.type == PieceType.king) {
          return true;
        }
      }
    }

    return false;
  }

  /// True if the active color's king is in check.
  static bool isInCheck(Board board, [PieceColor? color]) {
    final kingColor = color ?? board.activeColor;
    final kingSq = board.kingSquare(kingColor);
    if (kingSq == null) return false;
    return isSquareAttacked(kingSq, kingColor.opponent, board);
  }

  /// Returns all enemy squares currently delivering check to the specified king.
  static List<Square> getCheckingSquares(Board board, [PieceColor? color]) {
    final kingColor = color ?? board.activeColor;
    final kingSq = board.kingSquare(kingColor);
    if (kingSq == null) return const [];
    final attackerColor = kingColor.opposite;
    final checkingSquares = <Square>[];
    final sqFile = kingSq.file;
    final sqRank = kingSq.rank;

    // 1. Pawns
    final pawnRankDelta = attackerColor == PieceColor.white ? -1 : 1;
    final pawnRank = sqRank + pawnRankDelta;
    if (pawnRank >= 0 && pawnRank < 8) {
      for (final f in [sqFile - 1, sqFile + 1]) {
        if (f >= 0 && f < 8) {
          final sq = Square.fromCoords(f, pawnRank);
          final p = board.pieceAt(sq);
          if (p != null && p.color == attackerColor && p.type == PieceType.pawn) {
            checkingSquares.add(sq);
          }
        }
      }
    }

    // 2. Knights
    for (final delta in _knightDeltas) {
      final f = sqFile + delta[0];
      final r = sqRank + delta[1];
      if (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final sq = Square.fromCoords(f, r);
        final p = board.pieceAt(sq);
        if (p != null && p.color == attackerColor && p.type == PieceType.knight) {
          checkingSquares.add(sq);
        }
      }
    }

    // 3. Bishops & Queens
    for (final dir in _bishopDirections) {
      int f = sqFile + dir[0];
      int r = sqRank + dir[1];
      while (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final sq = Square.fromCoords(f, r);
        final p = board.pieceAt(sq);
        if (p != null) {
          if (p.color == attackerColor && (p.type == PieceType.bishop || p.type == PieceType.queen)) {
            checkingSquares.add(sq);
          }
          break;
        }
        f += dir[0];
        r += dir[1];
      }
    }

    // 4. Rooks & Queens
    for (final dir in _rookDirections) {
      int f = sqFile + dir[0];
      int r = sqRank + dir[1];
      while (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final sq = Square.fromCoords(f, r);
        final p = board.pieceAt(sq);
        if (p != null) {
          if (p.color == attackerColor && (p.type == PieceType.rook || p.type == PieceType.queen)) {
            checkingSquares.add(sq);
          }
          break;
        }
        f += dir[0];
        r += dir[1];
      }
    }

    return checkingSquares;
  }

  /// True if the king is attacked by two or more pieces simultaneously (double check).
  /// In double check, the ONLY legal check evasions are king moves.
  static bool isDoubleCheck(Board board, [PieceColor? color]) {
    return getCheckingSquares(board, color).length >= 2;
  }

  /// Generates all pseudo-legal moves for the active side.
  static List<Move> generatePseudoLegalMoves(Board board) {
    final moves = <Move>[];
    final color = board.activeColor;
    final pawnDir = color.direction;
    final startRank = color.pawnStartRank;
    final promoRank = color.promotionRank;

    for (int i = 0; i < 64; i++) {
      final piece = board.pieceAtIndex(i);
      if (piece == null || piece.color != color) continue;

      final from = Square(i);
      final file = from.file;
      final rank = from.rank;

      switch (piece.type) {
        case PieceType.pawn:
          // Single push forward
          final forwardRank = rank + pawnDir;
          if (forwardRank >= 0 && forwardRank < 8) {
            final forwardSq = Square.fromCoords(file, forwardRank);
            if (board.pieceAt(forwardSq) == null) {
              if (forwardRank == promoRank) {
                // Promotions to Q, R, B, N
                for (final promo in [PieceType.queen, PieceType.rook, PieceType.bishop, PieceType.knight]) {
                  moves.add(Move(from: from, to: forwardSq, promotion: promo, flag: MoveFlag.promotion));
                }
              } else {
                moves.add(Move(from: from, to: forwardSq));

                // Double push from initial rank
                if (rank == startRank) {
                  final doubleSq = Square.fromCoords(file, rank + 2 * pawnDir);
                  if (board.pieceAt(doubleSq) == null) {
                    moves.add(Move(from: from, to: doubleSq, flag: MoveFlag.pawnDoublePush));
                  }
                }
              }
            }
          }

          // Diagonal captures (left and right)
          for (final dFile in [-1, 1]) {
            final capFile = file + dFile;
            if (capFile >= 0 && capFile < 8 && forwardRank >= 0 && forwardRank < 8) {
              final capSq = Square.fromCoords(capFile, forwardRank);
              final target = board.pieceAt(capSq);

              // Standard piece capture
              if (target != null && target.color != color) {
                if (forwardRank == promoRank) {
                  for (final promo in [PieceType.queen, PieceType.rook, PieceType.bishop, PieceType.knight]) {
                    moves.add(Move(from: from, to: capSq, promotion: promo, flag: MoveFlag.promotion, isCapture: true));
                  }
                } else {
                  moves.add(Move(from: from, to: capSq, isCapture: true));
                }
              }

              // En passant capture
              if (board.enPassantSquare != null && capSq == board.enPassantSquare) {
                moves.add(Move(from: from, to: capSq, flag: MoveFlag.enPassant, isCapture: true));
              }
            }
          }
          break;

        case PieceType.knight:
          for (final d in _knightDeltas) {
            final f = file + d[0];
            final r = rank + d[1];
            if (f >= 0 && f < 8 && r >= 0 && r < 8) {
              final to = Square.fromCoords(f, r);
              final target = board.pieceAt(to);
              if (target == null) {
                moves.add(Move(from: from, to: to));
              } else if (target.color != color) {
                moves.add(Move(from: from, to: to, isCapture: true));
              }
            }
          }
          break;

        case PieceType.bishop:
          _addSlidingMoves(moves, board, from, _bishopDirections, color);
          break;

        case PieceType.rook:
          _addSlidingMoves(moves, board, from, _rookDirections, color);
          break;

        case PieceType.queen:
          _addSlidingMoves(moves, board, from, _bishopDirections, color);
          _addSlidingMoves(moves, board, from, _rookDirections, color);
          break;

        case PieceType.king:
          for (final d in _kingDeltas) {
            final f = file + d[0];
            final r = rank + d[1];
            if (f >= 0 && f < 8 && r >= 0 && r < 8) {
              final to = Square.fromCoords(f, r);
              final target = board.pieceAt(to);
              if (target == null) {
                moves.add(Move(from: from, to: to));
              } else if (target.color != color) {
                moves.add(Move(from: from, to: to, isCapture: true));
              }
            }
          }

          // Castling
          if (color == PieceColor.white) {
            // Kingside castling (O-O)
            if ((board.castlingRights & CastlingRights.whiteKingside) != 0 &&
                board.pieceAt(Square.f1) == null &&
                board.pieceAt(Square.g1) == null &&
                board.pieceAt(Square.h1)?.type == PieceType.rook) {
              if (!isSquareAttacked(Square.e1, PieceColor.black, board) &&
                  !isSquareAttacked(Square.f1, PieceColor.black, board) &&
                  !isSquareAttacked(Square.g1, PieceColor.black, board)) {
                moves.add(const Move(
                  from: Square.e1,
                  to: Square.g1,
                  flag: MoveFlag.castleKingside,
                ));
              }
            }
            // Queenside castling (O-O-O)
            if ((board.castlingRights & CastlingRights.whiteQueenside) != 0 &&
                board.pieceAt(Square.d1) == null &&
                board.pieceAt(Square.c1) == null &&
                board.pieceAt(Square.b1) == null &&
                board.pieceAt(Square.a1)?.type == PieceType.rook) {
              if (!isSquareAttacked(Square.e1, PieceColor.black, board) &&
                  !isSquareAttacked(Square.d1, PieceColor.black, board) &&
                  !isSquareAttacked(Square.c1, PieceColor.black, board)) {
                moves.add(const Move(
                  from: Square.e1,
                  to: Square.c1,
                  flag: MoveFlag.castleQueenside,
                ));
              }
            }
          } else {
            // Black Kingside castling (O-O)
            if ((board.castlingRights & CastlingRights.blackKingside) != 0 &&
                board.pieceAt(Square.f8) == null &&
                board.pieceAt(Square.g8) == null &&
                board.pieceAt(Square.h8)?.type == PieceType.rook) {
              if (!isSquareAttacked(Square.e8, PieceColor.white, board) &&
                  !isSquareAttacked(Square.f8, PieceColor.white, board) &&
                  !isSquareAttacked(Square.g8, PieceColor.white, board)) {
                moves.add(const Move(
                  from: Square.e8,
                  to: Square.g8,
                  flag: MoveFlag.castleKingside,
                ));
              }
            }
            // Black Queenside castling (O-O-O)
            if ((board.castlingRights & CastlingRights.blackQueenside) != 0 &&
                board.pieceAt(Square.d8) == null &&
                board.pieceAt(Square.c8) == null &&
                board.pieceAt(Square.b8) == null &&
                board.pieceAt(Square.a8)?.type == PieceType.rook) {
              if (!isSquareAttacked(Square.e8, PieceColor.white, board) &&
                  !isSquareAttacked(Square.d8, PieceColor.white, board) &&
                  !isSquareAttacked(Square.c8, PieceColor.white, board)) {
                moves.add(const Move(
                  from: Square.e8,
                  to: Square.c8,
                  flag: MoveFlag.castleQueenside,
                ));
              }
            }
          }
          break;
      }
    }

    return moves;
  }

  static void _addSlidingMoves(
    List<Move> moves,
    Board board,
    Square from,
    List<List<int>> directions,
    PieceColor color,
  ) {
    for (final dir in directions) {
      int f = from.file + dir[0];
      int r = from.rank + dir[1];
      while (f >= 0 && f < 8 && r >= 0 && r < 8) {
        final to = Square.fromCoords(f, r);
        final target = board.pieceAt(to);
        if (target == null) {
          moves.add(Move(from: from, to: to));
        } else {
          if (target.color != color) {
            moves.add(Move(from: from, to: to, isCapture: true));
          }
          break; // Ray blocked
        }
        f += dir[0];
        r += dir[1];
      }
    }
  }

  /// Generates all strictly legal moves for the active side.
  /// Filters out pseudo-legal moves that leave active side's king in check.
  static List<Move> generateLegalMoves(Board board) {
    final pseudoMoves = generatePseudoLegalMoves(board);
    final legalMoves = <Move>[];
    final color = board.activeColor;

    for (final move in pseudoMoves) {
      board.makeMove(move);
      // King of the side that just moved must NOT be in check
      if (!isInCheck(board, color)) {
        legalMoves.add(move);
      }
      board.unmakeMove();
    }

    return legalMoves;
  }

  /// Evaluates current game status (checkmate, stalemate, draw by repetition/50-move/material, or in progress).
  static GameStatus getGameStatus(Board board) {
    final legalMoves = generateLegalMoves(board);

    if (legalMoves.isEmpty) {
      if (isInCheck(board)) {
        return GameStatus.checkmate;
      } else {
        return GameStatus.stalemate;
      }
    }

    // Threefold repetition
    if (board.currentPositionOccurrences >= 3) {
      return GameStatus.threefoldRepetition;
    }

    // 75-move rule: automatic draw without requiring a claim (150 half-moves)
    if (board.halfmoveClock >= 150) {
      return GameStatus.seventyFiveMoveRule;
    }

    // 50-move rule: claimable draw at 50 full moves (100 half-moves)
    if (board.halfmoveClock >= 100) {
      return GameStatus.fiftyMoveRule;
    }

    // Insufficient material
    if (isInsufficientMaterial(board)) {
      return GameStatus.insufficientMaterial;
    }

    return GameStatus.inProgress;
  }

  /// Checks if neither side has sufficient material to force checkmate:
  /// - K vs K
  /// - K+B vs K
  /// - K+N vs K
  /// - K+B vs K+B (same color bishops)
  static bool isInsufficientMaterial(Board board) {
    int whitePawns = 0, blackPawns = 0;
    int whiteRooks = 0, blackRooks = 0;
    int whiteQueens = 0, blackQueens = 0;
    final whiteKnights = <Square>[];
    final blackKnights = <Square>[];
    final whiteBishops = <Square>[];
    final blackBishops = <Square>[];

    for (int i = 0; i < 64; i++) {
      final p = board.pieceAtIndex(i);
      if (p == null) continue;
      if (p.type == PieceType.king) continue;

      if (p.color == PieceColor.white) {
        if (p.type == PieceType.pawn) whitePawns++;
        else if (p.type == PieceType.rook) whiteRooks++;
        else if (p.type == PieceType.queen) whiteQueens++;
        else if (p.type == PieceType.knight) whiteKnights.add(Square(i));
        else if (p.type == PieceType.bishop) whiteBishops.add(Square(i));
      } else {
        if (p.type == PieceType.pawn) blackPawns++;
        else if (p.type == PieceType.rook) blackRooks++;
        else if (p.type == PieceType.queen) blackQueens++;
        else if (p.type == PieceType.knight) blackKnights.add(Square(i));
        else if (p.type == PieceType.bishop) blackBishops.add(Square(i));
      }
    }

    if (whitePawns > 0 || blackPawns > 0 || whiteRooks > 0 || blackRooks > 0 || whiteQueens > 0 || blackQueens > 0) {
      return false;
    }

    final totalWhiteMinors = whiteKnights.length + whiteBishops.length;
    final totalBlackMinors = blackKnights.length + blackBishops.length;

    // K vs K
    if (totalWhiteMinors == 0 && totalBlackMinors == 0) return true;

    // K+minor vs K
    if (totalWhiteMinors == 1 && totalBlackMinors == 0) return true;
    if (totalWhiteMinors == 0 && totalBlackMinors == 1) return true;

    // K+B vs K+B (same color square bishops)
    if (whiteBishops.length == 1 && blackBishops.length == 1 && whiteKnights.isEmpty && blackKnights.isEmpty) {
      final wLight = whiteBishops.first.isLightSquare;
      final bLight = blackBishops.first.isLightSquare;
      if (wLight == bLight) return true;
    }

    return false;
  }

  /// Converts a legal move into Standard Algebraic Notation (SAN) like 'Nf3', 'exd5', 'O-O', 'Qh5#'.
  static String moveToSan(Board board, Move move) {
    if (move.flag == MoveFlag.castleKingside) return 'O-O';
    if (move.flag == MoveFlag.castleQueenside) return 'O-O-O';

    final piece = board.pieceAt(move.from);
    if (piece == null) return move.uci;

    final sb = StringBuffer();

    if (piece.type == PieceType.pawn) {
      if (move.isCapture || move.flag == MoveFlag.enPassant) {
        sb.write(move.from.fileName);
        sb.write('x');
      }
      sb.write(move.to.name);
      if (move.promotion != null) {
        sb.write('=${move.promotion!.fenChar.toUpperCase()}');
      }
    } else {
      sb.write(piece.type.fenChar.toUpperCase());

      // Disambiguation: find if other pieces of the same type can move to 'to'
      final allLegal = generateLegalMoves(board);
      final ambiguous = allLegal.where((m) {
        if (m == move || m.to != move.to) return false;
        final p = board.pieceAt(m.from);
        return p != null && p.type == piece.type && p.color == piece.color;
      }).toList();

      if (ambiguous.isNotEmpty) {
        final sameFile = ambiguous.any((m) => m.from.file == move.from.file);
        final sameRank = ambiguous.any((m) => m.from.rank == move.from.rank);

        if (!sameFile) {
          sb.write(move.from.fileName);
        } else if (!sameRank) {
          sb.write(move.from.rankName);
        } else {
          sb.write(move.from.name);
        }
      }

      if (move.isCapture) {
        sb.write('x');
      }
      sb.write(move.to.name);
    }

    // Check / checkmate notation suffix
    board.makeMove(move);
    final inCheck = isInCheck(board);
    final isMate = inCheck && generateLegalMoves(board).isEmpty;
    board.unmakeMove();

    if (isMate) {
      sb.write('#');
    } else if (inCheck) {
      sb.write('+');
    }

    return sb.toString();
  }

  /// Parses a SAN move string into a legal Move on the current board.
  static Move? sanToMove(Board board, String san) {
    var cleaned = san.replaceAll(RegExp(r'[+#?!]'), '').trim();
    if (cleaned.isEmpty) return null;

    final legalMoves = generateLegalMoves(board);

    // Castling
    if (cleaned == 'O-O' || cleaned == '0-0') {
      return legalMoves.where((m) => m.flag == MoveFlag.castleKingside).firstOrNull;
    }
    if (cleaned == 'O-O-O' || cleaned == '0-0-0') {
      return legalMoves.where((m) => m.flag == MoveFlag.castleQueenside).firstOrNull;
    }

    PieceType? promo;
    if (cleaned.contains('=')) {
      final parts = cleaned.split('=');
      if (parts.length != 2 || parts[1].isEmpty) return null;
      cleaned = parts[0];
      promo = PieceType.fromFen(parts[1]);
      if (promo == null) return null;
    }

    if (cleaned.isEmpty) return null;

    bool isPawnMove = cleaned[0] == cleaned[0].toLowerCase();
    PieceType? targetPieceType;
    if (isPawnMove) {
      targetPieceType = PieceType.pawn;
    } else {
      targetPieceType = PieceType.fromFen(cleaned[0]);
      if (targetPieceType == null) return null;
    }

    String moveBody = isPawnMove ? cleaned : cleaned.substring(1);
    moveBody = moveBody.replaceAll('x', '');

    if (moveBody.length < 2) return null;
    final toName = moveBody.substring(moveBody.length - 2);
    final toSq = Square.fromName(toName);
    if (toSq == null) return null;

    final disambiguation = moveBody.substring(0, moveBody.length - 2);

    for (final move in legalMoves) {
      if (move.to != toSq) continue;
      if (promo != null && move.promotion != promo) continue;

      final piece = board.pieceAt(move.from);
      if (piece == null || piece.type != targetPieceType) continue;

      if (disambiguation.isNotEmpty) {
        if (disambiguation.length == 1) {
          final char = disambiguation[0];
          if (char.codeUnitAt(0) >= 'a'.codeUnitAt(0) && char.codeUnitAt(0) <= 'h'.codeUnitAt(0)) {
            if (move.from.fileName != char) continue;
          } else {
            if (move.from.rankName != char) continue;
          }
        } else if (disambiguation.length == 2) {
          if (move.from.name != disambiguation) continue;
        }
      }

      return move;
    }

    return null;
  }
}
