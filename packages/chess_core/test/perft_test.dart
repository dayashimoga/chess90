import 'package:chess_core/chess_core.dart';
import 'package:test/test.dart';

int perft(Board board, int depth) {
  if (depth == 0) return 1;
  final moves = MoveGenerator.generateLegalMoves(board);
  if (depth == 1) return moves.length;

  int nodes = 0;
  for (final move in moves) {
    board.makeMove(move);
    nodes += perft(board, depth - 1);
    board.unmakeMove();
  }
  return nodes;
}

void main() {
  group('Perft Correctness Tests', () {
    test('Initial position perft depths 1 to 3', () {
      final board = Board.initial();

      expect(perft(board, 1), equals(20));
      expect(perft(board, 2), equals(400));
      expect(perft(board, 3), equals(8902));
    });

    test('Initial position perft depth 4', () {
      final board = Board.initial();
      expect(perft(board, 4), equals(197281));
    });

    test('Kiwipete position perft depth 1 and 2', () {
      // Kiwipete position contains complex pins, castling, en passant
      const kiwipeteFen = 'r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1';
      final board = Board.fromFen(kiwipeteFen);

      expect(perft(board, 1), equals(48));
      expect(perft(board, 2), equals(2039));
    });

    test('Position 3 perft depth 1 and 2', () {
      // 8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - -
      const fen = '8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1';
      final board = Board.fromFen(fen);

      expect(perft(board, 1), equals(14));
      expect(perft(board, 2), equals(191));
    });
  });
}
