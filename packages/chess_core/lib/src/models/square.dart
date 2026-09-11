/// Represents an 8x8 chess square mapped from 0 (a1) to 63 (h8).
/// Indexing: square = rank * 8 + file
/// rank 0 = '1', rank 7 = '8'
/// file 0 = 'a', file 7 = 'h'
class Square {
  final int index;

  const Square(this.index) : assert(index >= 0 && index < 64, 'Square index must be between 0 and 63');

  int get file => index % 8;
  int get rank => index ~/ 8;

  String get fileName => String.fromCharCode('a'.codeUnitAt(0) + file);
  String get rankName => '${rank + 1}';

  /// Standard algebraic notation: e.g. 'e4', 'a1', 'h8'.
  String get name => '$fileName$rankName';

  /// True if the square is light-colored.
  bool get isLightSquare => (file + rank) % 2 != 0;

  /// Returns 64-bit bitboard mask with only this square bit set.
  int get mask => 1 << index;

  static Square fromCoords(int file, int rank) {
    assert(file >= 0 && file < 8 && rank >= 0 && rank < 8);
    return Square(rank * 8 + file);
  }

  static Square? fromName(String name) {
    if (name.length != 2) return null;
    final fileChar = name[0].toLowerCase();
    final rankChar = name[1];

    final file = fileChar.codeUnitAt(0) - 'a'.codeUnitAt(0);
    final rank = int.tryParse(rankChar);

    if (file < 0 || file > 7 || rank == null || rank < 1 || rank > 8) {
      return null;
    }

    return Square((rank - 1) * 8 + file);
  }

  static const Square a1 = Square(0);
  static const Square b1 = Square(1);
  static const Square c1 = Square(2);
  static const Square d1 = Square(3);
  static const Square e1 = Square(4);
  static const Square f1 = Square(5);
  static const Square g1 = Square(6);
  static const Square h1 = Square(7);

  static const Square a2 = Square(8);
  static const Square c2 = Square(10);
  static const Square e2 = Square(12);
  static const Square f2 = Square(13);

  static const Square e3 = Square(20);
  static const Square f3 = Square(21);

  static const Square e4 = Square(28);
  static const Square d4 = Square(27);

  static const Square a5 = Square(32);
  static const Square d5 = Square(35);
  static const Square e5 = Square(36);
  static const Square f5 = Square(37);

  static const Square f6 = Square(45);

  static const Square a7 = Square(48);

  static const Square a8 = Square(56);
  static const Square b8 = Square(57);
  static const Square c8 = Square(58);
  static const Square d8 = Square(59);
  static const Square e8 = Square(60);
  static const Square f8 = Square(61);
  static const Square g8 = Square(62);
  static const Square h8 = Square(63);

  /// Helper to get square from standard name with assertion
  static Square named(String name) => fromName(name)!;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Square && runtimeType == other.runtimeType && index == other.index;

  @override
  int get hashCode => index.hashCode;

  @override
  String toString() => name;
}
