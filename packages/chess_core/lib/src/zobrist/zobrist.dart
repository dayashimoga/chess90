import '../models/piece.dart';
import '../models/square.dart';

/// Deterministic 64-bit Zobrist keys for position hashing and threefold repetition detection.
/// Uses BigInt to ensure identical behavior across 64-bit Native platforms and Web JS.
class Zobrist {
  static final BigInt _mask64 = (BigInt.one << 64) - BigInt.one;

  // [pieceIndex][squareIndex] where pieceIndex is 0..11
  static final List<List<BigInt>> _pieceKeys = List.generate(
    12,
    (p) => List.generate(64, (sq) => _generatePseudoRandomKey(p * 64 + sq)),
  );

  // Castling rights keys: 16 possibilities (4 bits: WK, WQ, BK, BQ)
  static final List<BigInt> _castlingKeys = List.generate(
    16,
    (i) => _generatePseudoRandomKey(12 * 64 + i),
  );

  // En passant file keys: 8 files (0..7) + 1 for no EP
  static final List<BigInt> _enPassantKeys = List.generate(
    9,
    (i) => _generatePseudoRandomKey(12 * 64 + 16 + i),
  );

  // Side to move key
  static final BigInt _sideKey = _generatePseudoRandomKey(12 * 64 + 16 + 9);

  /// Deterministic pseudo-random number generator (splitmix64)
  static BigInt _generatePseudoRandomKey(int seedIndex) {
    BigInt state = BigInt.from(seedIndex + 1) ^ BigInt.parse('0x9E3779B97F4A7C15');
    state = (state ^ (state >> 30)) * BigInt.parse('0xBF58476D1CE4E5B9') & _mask64;
    state = (state ^ (state >> 27)) * BigInt.parse('0x94D049BB133111EB') & _mask64;
    return (state ^ (state >> 31)) & _mask64;
  }

  static int _pieceToIndex(Piece piece) {
    final base = piece.color == PieceColor.white ? 0 : 6;
    switch (piece.type) {
      case PieceType.pawn:
        return base;
      case PieceType.knight:
        return base + 1;
      case PieceType.bishop:
        return base + 2;
      case PieceType.rook:
        return base + 3;
      case PieceType.queen:
        return base + 4;
      case PieceType.king:
        return base + 5;
    }
  }

  static BigInt pieceKey(Piece piece, Square square) {
    return _pieceKeys[_pieceToIndex(piece)][square.index];
  }

  static BigInt castlingKey(int castlingBits) {
    return _castlingKeys[castlingBits & 0x0F];
  }

  static BigInt enPassantKey(int? file) {
    if (file == null || file < 0 || file > 7) {
      return _enPassantKeys[8];
    }
    return _enPassantKeys[file];
  }

  static BigInt sideKey() => _sideKey;
}
