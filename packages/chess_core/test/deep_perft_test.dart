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
  group('Deep Multi-Depth Perft Suites', () {
    test('Initial Standard Position: Depths 1 to 4', () {
      final board = Board.initial();
      expect(perft(board, 1), equals(20));
      expect(perft(board, 2), equals(400));
      expect(perft(board, 3), equals(8902));
      expect(perft(board, 4), equals(197281));
    });

    test('Kiwipete Position: Depths 1 to 3', () {
      // Kiwipete tests complex pins, castling, and en-passant variations
      final board = Board.fromFen('r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1');
      expect(perft(board, 1), equals(48));
      expect(perft(board, 2), equals(2039));
      expect(perft(board, 3), equals(97862));
    });

    test('Position 3 (Discovered Check & En Passant Pin): Depths 1 to 3', () {
      final board = Board.fromFen('8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 1');
      expect(perft(board, 1), equals(14));
      expect(perft(board, 2), equals(191));
      expect(perft(board, 3), equals(2812));
    });

    test('Position 4 (Promotions & Underpromotions with Checks): Depths 1 to 2', () {
      final board = Board.fromFen('r3k2r/Pppp1ppp/1b3nbN/nP6/BBP1P3/q4N2/Pp1P2PP/R2Q1RK1 w kq - 0 1');
      expect(perft(board, 1), equals(6));
      expect(perft(board, 2), equals(264));
    });

    test('Position 5 (Tactical Pin on Queen & King): Depths 1 to 2', () {
      final board = Board.fromFen('rnbq1k1r/pp1Pbppp/2p5/8/2B5/8/PPP1NnPP/RNBQK2R w KQ - 1 8');
      expect(perft(board, 1), equals(44));
      expect(perft(board, 2), equals(1486));
    });
  });
}
