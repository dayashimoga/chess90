import '../board/board.dart';
import '../models/piece.dart';
import '../rules/move_generator.dart';

/// Utilities for validating and parsing FEN (Forsyth-Edwards Notation) strings.
class FenParser {
  static const String initialFen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  /// Validates whether a FEN string has valid structure and strictly legal piece layout:
  /// - Exactly 6 space-separated fields (or at least 4 for simplified FENs).
  /// - Exactly 8 ranks separated by `/`.
  /// - Each rank sums to exactly 8 squares.
  /// - Exactly 1 White king and 1 Black king.
  /// - No pawns on 1st rank or 8th rank.
  /// - Active color is strictly 'w' or 'b'.
  /// - Castling rights are '-' or a valid combination of 'K', 'Q', 'k', 'q' without duplicate letters or extraneous characters.
  /// - En passant square is '-' or a legal coordinate on rank 3 or 6.
  /// - Halfmove and fullmove are non-negative integers if provided.
  /// - The non-active side cannot be in check (impossible position).
  static bool isValidFen(String fen) {
    try {
      final parts = fen.trim().split(RegExp(r'\s+'));
      if (parts.length < 4 || parts.length > 6) return false;

      final ranks = parts[0].split('/');
      if (ranks.length != 8) return false;

      int whiteKings = 0;
      int blackKings = 0;

      for (int rankIdx = 0; rankIdx < 8; rankIdx++) {
        final rank = ranks[rankIdx];
        int count = 0;
        for (int i = 0; i < rank.length; i++) {
          final c = rank[i];
          final digit = int.tryParse(c);
          if (digit != null) {
            if (digit < 1 || digit > 8) return false;
            count += digit;
          } else {
            count++;
            if (!'pnbrqkPNBRQK'.contains(c)) return false;
            if (c == 'K') whiteKings++;
            if (c == 'k') blackKings++;
            // Pawns cannot exist on 8th rank (rankIdx == 0) or 1st rank (rankIdx == 7)
            if ((rankIdx == 0 || rankIdx == 7) && (c == 'p' || c == 'P')) {
              return false;
            }
          }
        }
        if (count != 8) return false;
      }

      if (whiteKings != 1 || blackKings != 1) return false;

      final side = parts[1];
      if (side != 'w' && side != 'b') return false;

      final castling = parts[2];
      if (castling != '-') {
        if (!RegExp(r'^(K?Q?k?q?)$').hasMatch(castling) || castling.isEmpty) {
          return false;
        }
      }

      final ep = parts[3];
      if (ep != '-') {
        if (!RegExp(r'^[a-h][36]$').hasMatch(ep)) return false;
        // If White to move, en-passant square must be on rank 6 (Black pushed 2 squares)
        if (side == 'w' && ep[1] != '6') return false;
        // If Black to move, en-passant square must be on rank 3 (White pushed 2 squares)
        if (side == 'b' && ep[1] != '3') return false;
      }

      if (parts.length > 4) {
        final halfmove = int.tryParse(parts[4]);
        if (halfmove == null || halfmove < 0) return false;
      }

      if (parts.length > 5) {
        final fullmove = int.tryParse(parts[5]);
        if (fullmove == null || fullmove < 1) return false;
      }

      // Check king legality: the side that just moved (opposite of active color) cannot be in check
      final board = Board.fromFen(fen);
      final inactiveColor = side == 'w' ? PieceColor.black : PieceColor.white;
      if (MoveGenerator.isInCheck(board, inactiveColor)) {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Parses FEN into a new Board instance.
  static Board parse(String fen) {
    return Board.fromFen(fen);
  }

  /// Converts Board into FEN string.
  static String export(Board board) {
    return board.toFen();
  }
}
