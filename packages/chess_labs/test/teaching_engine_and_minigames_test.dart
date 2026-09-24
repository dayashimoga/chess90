import 'package:chess_core/chess_core.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:test/test.dart';

void main() {
  group('BoardTeachingEngine Tests', () {
    test('Initializes with overlays and explain phase', () {
      final board = Board.fromFen('r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1');
      final engine = BoardTeachingEngine(
        initialBoard: board,
        sideToPlay: PieceColor.white,
        conceptTitle: 'Scholar Mate Attack',
        coreExplanation: 'Target f7 with queen and bishop.',
        solutionSan: ['Qxf7#'],
      );

      expect(engine.currentPhase, equals(TeachingPhase.explain));
      expect(engine.arrows, isNotEmpty);
      expect(engine.highlights, isNotEmpty);

      // Transition to show demo
      engine.setPhase(TeachingPhase.show);
      expect(engine.currentPhase, equals(TeachingPhase.show));
      expect(engine.ghostPieces, isNotEmpty);

      // Transition to interactive
      engine.setPhase(TeachingPhase.interact);
      expect(engine.currentPhase, equals(TeachingPhase.interact));
      expect(engine.highlights, isNotEmpty);

      // Correct move execution
      final qxf7 = MoveGenerator.sanToMove(engine.currentBoard, 'Qxf7#')!;
      final success = engine.submitMove(qxf7);
      expect(success, isTrue);
      expect(engine.currentPhase, equals(TeachingPhase.feedback));
    });

    test('Wrong move triggers refutation visualizer and rewind', () {
      final board = Board.fromFen('r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1');
      final qe4Move = MoveGenerator.sanToMove(board, 'Qxe4')!;
      final engine = BoardTeachingEngine(
        initialBoard: board,
        sideToPlay: PieceColor.white,
        conceptTitle: 'Scholar Mate Attack',
        coreExplanation: 'Target f7 directly.',
        solutionSan: ['Qxf7#'],
        candidates: [
          CandidateEvaluation(
            san: 'Qxe4',
            move: qe4Move,
            isBest: false,
            refutationSan: 'd5',
            explanation: 'Black strikes in the center with d5 and regains piece.',
          ),
        ],
      );

      final result = engine.submitMove(qe4Move);
      expect(result, isFalse);
      expect(engine.isWrongMoveShowingRefutation, isTrue);
      expect(engine.feedbackText, contains('refutes'));

      // Rewind to start
      engine.rewind();
      expect(engine.isWrongMoveShowingRefutation, isFalse);
      expect(engine.currentBoard.toFen(), equals(board.toFen()));
    });
  });

  group('PlayableMiniGame Tests (All 12 Real Mini-Games)', () {
    for (final type in MiniGameType.values) {
      test('Creates and plays Level 1 of ${type.title}', () {
        final game = PlayableMiniGame.create(type);
        expect(game.levels, isNotEmpty);
        expect(game.currentLevel.levelNumber, equals(1));
        expect(game.currentBoard, isNotNull);

        // Verify hints can be requested
        final hint = game.requestHint();
        expect(hint, isNotNull);

        // Verify valid first move executes
        final expectedSan = game.currentLevel.expectedMovesSan.first;
        final move = MoveGenerator.sanToMove(game.currentBoard, expectedSan);
        expect(move, isNotNull, reason: 'Failed to parse $expectedSan on ${game.currentBoard.toFen()} for ${type.title}');

        final played = game.playMove(move!);
        expect(played, isTrue);
      });
    }
  });
}
