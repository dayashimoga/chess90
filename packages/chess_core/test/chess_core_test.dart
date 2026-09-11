import 'package:chess_core/chess_core.dart';
import 'package:test/test.dart';

void main() {
  group('Chess Core Rules & Board Tests', () {
    test('Initial board setup and fen roundtrip', () {
      final board = Board.initial();
      expect(board.activeColor, equals(PieceColor.white));
      expect(board.pieceAt(Square.e1)?.type, equals(PieceType.king));
      expect(board.pieceAt(Square.e8)?.type, equals(PieceType.king));
      expect(board.toFen(), equals(FenParser.initialFen));
    });

    test('Legal moves generation from start position', () {
      final board = Board.initial();
      final moves = MoveGenerator.generateLegalMoves(board);
      expect(moves.length, equals(20)); // 16 pawn pushes + 4 knight moves
    });

    test('Fool\'s Mate detection', () {
      // 1. f3 e5 2. g4 Qh4#
      final board = Board.initial();

      final m1 = MoveGenerator.sanToMove(board, 'f3')!;
      board.makeMove(m1);
      final m2 = MoveGenerator.sanToMove(board, 'e5')!;
      board.makeMove(m2);
      final m3 = MoveGenerator.sanToMove(board, 'g4')!;
      board.makeMove(m3);
      final m4 = MoveGenerator.sanToMove(board, 'Qh4+')!;
      expect(m4, isNotNull);
      board.makeMove(m4);

      expect(MoveGenerator.isInCheck(board), isTrue);
      expect(MoveGenerator.generateLegalMoves(board).isEmpty, isTrue);
      expect(MoveGenerator.getGameStatus(board), equals(GameStatus.checkmate));
    });

    test('Scholar\'s Mate SAN generation', () {
      // 1. e4 e5 2. Bc4 Nc6 3. Qh5 Nf6 4. Qxf7#
      final board = Board.initial();

      final moves = ['e4', 'e5', 'Bc4', 'Nc6', 'Qh5', 'Nf6', 'Qxf7#'];
      for (final san in moves) {
        final move = MoveGenerator.sanToMove(board, san);
        expect(move, isNotNull, reason: 'Failed to parse SAN: $san in FEN: ${board.toFen()}');
        final genSan = MoveGenerator.moveToSan(board, move!);
        expect(genSan, equals(san));
        board.makeMove(move);
      }
      expect(MoveGenerator.getGameStatus(board), equals(GameStatus.checkmate));
    });

    test('Stalemate detection', () {
      // White king on a8, black queen on b6, black king on c7 (Black just moved)
      const stalemateFen = 'k7/2K5/1Q6/8/8/8/8/8 b - - 0 1';
      final board = Board.fromFen(stalemateFen);

      expect(MoveGenerator.isInCheck(board), isFalse);
      expect(MoveGenerator.generateLegalMoves(board).isEmpty, isTrue);
      expect(MoveGenerator.getGameStatus(board), equals(GameStatus.stalemate));
    });

    test('Threefold repetition detection via Zobrist', () {
      final board = Board.initial();
      // 1. Nf3 Nf6 2. Ng1 Ng8 3. Nf3 Nf6 4. Ng1 Ng8
      final seq = ['Nf3', 'Nf6', 'Ng1', 'Ng8', 'Nf3', 'Nf6', 'Ng1', 'Ng8'];
      for (final san in seq) {
        final move = MoveGenerator.sanToMove(board, san)!;
        board.makeMove(move);
      }
      expect(board.currentPositionOccurrences, equals(3));
      expect(MoveGenerator.getGameStatus(board), equals(GameStatus.threefoldRepetition));
    });

    test('Fifty-move rule detection', () {
      const fiftyMoveFen = '8/8/8/8/k7/8/8/K7 w - - 100 75';
      final board = Board.fromFen(fiftyMoveFen);
      expect(MoveGenerator.getGameStatus(board), equals(GameStatus.fiftyMoveRule));
    });

    test('Insufficient material scenarios', () {
      // King vs King
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('8/8/8/8/k7/8/8/K7 w - - 0 1')), isTrue);
      // King + Bishop vs King
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('8/8/8/8/k7/8/2B5/K7 w - - 0 1')), isTrue);
      // King + Knight vs King
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('8/8/8/8/k7/8/2N5/K7 w - - 0 1')), isTrue);
      // King + Bishop vs King + Bishop (same color square)
      // c1 is dark, f8 is dark
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('5b2/8/8/8/k7/8/8/K1B5 w - - 0 1')), isTrue);
      // King + Pawn vs King (sufficient)
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('8/8/8/8/k7/8/2P5/K7 w - - 0 1')), isFalse);
    });

    test('En passant capture execution and undo', () {
      // e4, c5, e5, d5, exd6 e.p.
      final board = Board.initial();
      board.makeMove(MoveGenerator.sanToMove(board, 'e4')!);
      board.makeMove(MoveGenerator.sanToMove(board, 'c5')!);
      board.makeMove(MoveGenerator.sanToMove(board, 'e5')!);
      board.makeMove(MoveGenerator.sanToMove(board, 'd5')!);

      expect(board.enPassantSquare, equals(Square.fromName('d6')));
      final epMove = MoveGenerator.sanToMove(board, 'exd6')!;
      expect(epMove.flag, equals(MoveFlag.enPassant));
      board.makeMove(epMove);

      expect(board.pieceAt(Square.fromName('d5')!), isNull); // Captured black pawn removed
      expect(board.pieceAt(Square.fromName('d6')!)?.type, equals(PieceType.pawn));

      // Test undo
      board.unmakeMove();
      expect(board.pieceAt(Square.fromName('d5')!)?.type, equals(PieceType.pawn));
      expect(board.pieceAt(Square.fromName('e5')!)?.type, equals(PieceType.pawn));
      expect(board.enPassantSquare, equals(Square.fromName('d6')));
    });

    test('PGN parser and roundtrip with comments and clock', () {
      const samplePgn = '''
[Event "FIDE Candidates 2024"]
[Site "Toronto CAN"]
[Date "2024.04.14"]
[Round "10"]
[White "Caruana, Fabiano"]
[Black "Firouzja, Alireza"]
[Result "1-0"]

1. e4 {Best opening} 1... c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6 1-0
''';

      final game = PgnParser.parse(samplePgn);
      expect(game, isNotNull);
      expect(game!.white, equals('Caruana, Fabiano'));
      expect(game.black, equals('Firouzja, Alireza'));
      expect(game.result, equals('1-0'));
      expect(game.moves.length, equals(10));
      expect(game.moves.first.comment, equals('Best opening'));

      final serialized = game.toPgnString();
      expect(serialized, contains('[White "Caruana, Fabiano"]'));
      expect(serialized, contains('1. e4 {Best opening}'));
    });

    test('Chess Clock operations and flags', () {
      final clock = ChessClock.classical90Plus30();
      expect(clock.whiteRemaining.inMinutes, equals(90));
      expect(clock.blackRemaining.inMinutes, equals(90));
      expect(clock.hasFlagFallen(PieceColor.white), isFalse);

      clock.start();
      expect(clock.isRunning, isTrue);

      clock.onMovePlayed(recordedDuration: const Duration(seconds: 5));
      // White gets +30s increment
      expect(clock.whiteRemaining.inSeconds, greaterThanOrEqualTo(90 * 60));
      expect(clock.activeColor, equals(PieceColor.black));

      clock.pause();
      expect(clock.isRunning, isFalse);
    });
  });
}
