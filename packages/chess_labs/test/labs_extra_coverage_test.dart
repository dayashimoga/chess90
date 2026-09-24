import 'package:chess_core/chess_core.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:test/test.dart';

void main() {
  group('Extra Labs & PlayableMiniGames Deep Coverage Suite', () {
    test('PlayableMiniGame lifecycle, multi-level progression, and hints', () {
      final game = PlayableMiniGame.create(MiniGameType.forkHunter);
      expect(game.type, equals(MiniGameType.forkHunter));
      expect(game.totalLevels, greaterThanOrEqualTo(2));
      expect(game.currentLevelIndex, equals(0));
      expect(game.progressFraction, equals(0.0));

      // Request all hints
      final hint1 = game.requestHint();
      expect(hint1, isNotNull);
      final hint2 = game.requestHint();
      expect(hint2, isNotNull);
      // Beyond available hints
      final hint3 = game.requestHint();
      expect(hint3, isNull);

      // Play illegal move
      final illegalMove = Move(from: Square.named('a1'), to: Square.named('a8'));
      final illegalResult = game.playMove(illegalMove);
      expect(illegalResult, isFalse);
      expect(game.feedbackMessage, contains('Illegal move'));

      // Play wrong legal move
      final wrongMove = Move(from: Square.named('h2'), to: Square.named('h3'));
      final wrongResult = game.playMove(wrongMove);
      expect(wrongResult, isFalse);
      expect(game.feedbackMessage, contains('Incorrect move'));

      // Play correct move: Qe2+
      final qe2Move = MoveGenerator.sanToMove(game.currentBoard, 'Qe2+')!;
      final correct1 = game.playMove(qe2Move);
      expect(correct1, isTrue);
      // Opponent automatically played Kd8!
      expect(game.moveHistory.length, equals(2));

      // Play second correct move: Nc6+ to complete level 1
      final nc6Move = MoveGenerator.sanToMove(game.currentBoard, 'Nc6+')!;
      final correct2 = game.playMove(nc6Move);
      expect(correct2, isTrue);
      expect(game.isLevelCompleted, isTrue);
      expect(game.roundsCompleted, equals(1));
      expect(game.progressFraction, greaterThan(0.0));

      // Advance to next level
      game.nextLevel();
      expect(game.currentLevelIndex, equals(1));
      expect(game.currentLevel.levelNumber, equals(2));

      // Reset level
      game.resetCurrentLevel();
      expect(game.currentMoveIndex, equals(0));
      expect(game.moveHistory, isEmpty);

      // Skip to game over
      while (game.currentLevelIndex < game.totalLevels - 1) {
        game.nextLevel();
      }
      game.nextLevel();
      expect(game.isGameOver, isTrue);
      expect(game.feedbackMessage, contains('mastered all levels'));

      game.dispose();
    });

    test('LabSession modes, candidate squares, and tiered hint progression', () {
      final session = LabSession(
        id: 'test_lab_session',
        title: 'Tactical Double Attack',
        labType: 'tactical_lab',
        initialFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
        solutionSan: ['Qxf7#'],
        explanation: 'Checkmate on f7',
        hintConcept: 'King safety on f7',
        hintPiece: 'Queen',
        hintForcing: 'Qxf7#',
        refutationAnalysis: 'Qxe4 is refuted by d5',
        isNoTacticPosition: false,
      );

      expect(session.isNoTacticActionVisible, isFalse);
      expect(session.nextSolutionMove, isNotNull);
      expect(session.candidatePieceSquare, equals(Square.named('f3')));
      expect(session.candidateTargetSquare, equals(Square.named('f7')));

      // Test all modes
      session.setMode(LabMode.demo);
      expect(session.mode, equals(LabMode.demo));
      expect(session.feedbackMessage, contains('Demo Mode'));

      session.setMode(LabMode.guided);
      expect(session.mode, equals(LabMode.guided));
      expect(session.feedbackMessage, contains('Guided Mode'));

      session.setMode(LabMode.challenge);
      expect(session.mode, equals(LabMode.challenge));
      expect(session.feedbackMessage, contains('Challenge Mode'));

      session.setMode(LabMode.review);
      expect(session.mode, equals(LabMode.review));
      expect(session.feedbackMessage, contains('Review Mode'));
    });

    test('Every playable mini-game instantiates and verifies title & description', () {
      for (final type in MiniGameType.values) {
        final game = PlayableMiniGame.create(type);
        expect(game.type.title, isNotEmpty);
        expect(game.type.description, isNotEmpty);
        expect(game.levels, isNotEmpty);
        for (final lvl in game.levels) {
          expect(lvl.levelNumber, greaterThanOrEqualTo(1));
          expect(lvl.title, isNotEmpty);
          expect(lvl.initialFen, isNotEmpty);
          expect(lvl.expectedMovesSan, isNotEmpty);
          expect(lvl.hints, isNotEmpty);
          expect(lvl.explanation, isNotEmpty);
        }
        game.dispose();
      }
    });
  });
}
