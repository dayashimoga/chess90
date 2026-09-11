import 'piece.dart';
import 'square.dart';

/// Represents flags associated with a chess move.
enum MoveFlag {
  normal,
  pawnDoublePush,
  enPassant,
  castleKingside,
  castleQueenside,
  promotion,
}

/// Represents a chess move.
class Move {
  final Square from;
  final Square to;
  final PieceType? promotion;
  final MoveFlag flag;
  final bool isCapture;

  const Move({
    required this.from,
    required this.to,
    this.promotion,
    this.flag = MoveFlag.normal,
    this.isCapture = false,
  });

  /// True if this move is a promotion.
  bool get isPromotion => promotion != null || flag == MoveFlag.promotion;

  /// True if this move is a castling move.
  bool get isCastling =>
      flag == MoveFlag.castleKingside || flag == MoveFlag.castleQueenside;

  /// Returns standard UCI format string: e.g. 'e2e4', 'g1f3', 'e7e8q'.
  String get uci {
    final promo = promotion != null ? promotion!.fenChar.toLowerCase() : '';
    return '${from.name}${to.name}$promo';
  }

  /// Parses a UCI string like 'e2e4', 'e7e8q'.
  static Move? fromUci(String uci) {
    if (uci.length < 4 || uci.length > 5) return null;
    final fromSq = Square.fromName(uci.substring(0, 2));
    final toSq = Square.fromName(uci.substring(2, 4));
    if (fromSq == null || toSq == null) return null;

    PieceType? promo;
    if (uci.length == 5) {
      promo = PieceType.fromFen(uci[4]);
    }

    return Move(
      from: fromSq,
      to: toSq,
      promotion: promo,
      flag: promo != null ? MoveFlag.promotion : MoveFlag.normal,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Move &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to &&
          promotion == other.promotion;

  @override
  int get hashCode => from.hashCode ^ to.hashCode ^ (promotion?.hashCode ?? 0);

  @override
  String toString() => uci;
}
