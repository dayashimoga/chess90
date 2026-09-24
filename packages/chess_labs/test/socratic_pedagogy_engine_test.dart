import 'package:chess_core/chess_core.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:test/test.dart';

void main() {
  group('SocraticPedagogyEngine Tests', () {
    test('Constructs demo steps, socratic steps, and cognitive checklist', () {
      final board = Board.fromFen('r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1');
      final engine = SocraticPedagogyEngine(
        initialBoard: board,
        sideToPlay: PieceColor.white,
        solutionSan: ['Qxf7#'],
        motif: 'Scholar Mate Attack',
        explanation: 'Direct checkmate on the weak f7 square.',
        hints: ['Aim for f7', 'Deliver checkmate with queen'],
      );

      expect(engine.demoSteps, isNotEmpty);
      expect(engine.socraticSteps, isNotEmpty);
      expect(engine.cognitiveChecklist.length, equals(6));

      // Test Demo stepping
      expect(engine.currentDemoIndex, equals(0));
      expect(engine.currentDemoStep, isNotNull);
      expect(engine.isDemoFinished, isFalse);

      engine.nextDemoStep();
      expect(engine.currentDemoIndex, greaterThan(0));

      engine.prevDemoStep();
      expect(engine.currentDemoIndex, equals(0));

      engine.resetDemo();
      expect(engine.currentDemoIndex, equals(0));

      // Test Socratic discovery interactions
      final socratic = engine.currentSocraticStep;
      expect(socratic, isNotNull);

      if (socratic!.validationType == SocraticValidationType.clickTargetSquare) {
        if (socratic.expectedSquares.isNotEmpty) {
          final target = socratic.expectedSquares.first;
          final passed = engine.validateSocraticSquare(target);
          expect(passed, isTrue);
        }
      } else if (socratic.validationType == SocraticValidationType.selectCandidateMove) {
        final passed = engine.validateSocraticMove('Qxf7#');
        expect(passed, isTrue);
      } else {
        engine.advanceSocratic();
        expect(engine.currentSocraticIndex, greaterThan(0));
      }

      // Reset socratic
      engine.resetSocratic();
      expect(engine.currentSocraticIndex, equals(0));
    });

    test('Candidate and cognitive checklist verification', () {
      final board = Board.fromFen('r3k2r/ppp2ppp/8/3q4/3N4/8/PPP2PPP/R1BQKB1R w KQkq - 0 1');
      final engine = SocraticPedagogyEngine(
        initialBoard: board,
        sideToPlay: PieceColor.white,
        solutionSan: ['Qe2+'],
        motif: 'Knight Fork',
        explanation: 'Force the king with Qe2+.',
      );

      for (final step in engine.cognitiveChecklist) {
        expect(step.stage.title.isNotEmpty, isTrue);
        expect(step.stage.description.isNotEmpty, isTrue);
        expect(step.stage.gmTip.isNotEmpty, isTrue);
        step.isCompleted = true;
        expect(step.isCompleted, isTrue);
      }
    });
  });

  group('PlayableMiniGame Multi-Level Progression Tests', () {
    test('All 12 mini-games advance through levels and reset', () {
      for (final type in MiniGameType.values) {
        final game = PlayableMiniGame.create(type);
        expect(game.levels.length, greaterThanOrEqualTo(1));
        expect(game.currentLevelIndex, equals(0));
        expect(game.progressFraction, greaterThanOrEqualTo(0.0));

        // Wrong move handling
        final illegalMove = Move(from: Square.a1, to: Square.h8);
        final invalidPlay = game.playMove(illegalMove);
        expect(invalidPlay, isFalse);

        // Reset level
        game.resetCurrentLevel();
        expect(game.currentMoveIndex, equals(0));
        expect(game.hintsRevealed, equals(0));

        // Request hints up to limit
        final h1 = game.requestHint();
        final h2 = game.requestHint();
        expect(h1, isNotNull);
        expect(game.hintsRevealed, greaterThan(0));

        // Advance level if available
        if (game.levels.length > 1) {
          game.nextLevel();
          expect(game.currentLevelIndex, equals(1));
        }
      }
    });
  });
}
