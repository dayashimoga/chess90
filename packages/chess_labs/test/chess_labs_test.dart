import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:test/test.dart';

void main() {
  group('Interactive Lab Session Tests', () {
    test('Tactical lab full flow with opponent auto-reply', () {
      // White: Qxf7+ Kd8, Qf8#
      const fen = 'r1b1k2r/pppp1ppp/2n5/2b1p3/2B1n2q/2N2Q2/PPPP1PPP/R1B1K2R w KQkq - 0 8';
      final lab = TacticalLab(
        id: 'test_lab_1',
        title: 'Mating Attack',
        initialFen: fen,
        solutionSan: ['Qxf7+', 'Kd8', 'Qf8#'],
        hints: ['Check f7', 'Coordinate queen and bishop'],
        explanation: 'Direct queen invasion on weak f7.',
        motif: 'Mating Net',
      );

      expect(lab.isCompleted, isFalse);
      expect(lab.score, equals(100.0));

      // Hint usage
      final hint1 = lab.requestHint();
      expect(hint1, equals('Check f7'));
      expect(lab.score, equals(80.0));

      // User plays first move: Qxf7+
      final move1 = MoveGenerator.sanToMove(lab.currentBoard, 'Qxf7+')!;
      final result1 = lab.playMove(move1);

      // Opponent automatically replied with Kd8
      expect(result1, equals(LabStepResult.opponentPlayed));
      expect(lab.currentSolutionIndex, equals(2));

      // User plays final checkmate: Qf8#
      final move2 = MoveGenerator.sanToMove(lab.currentBoard, 'Qf8#')!;
      final result2 = lab.playMove(move2);

      expect(result2, equals(LabStepResult.completed));
      expect(lab.isCompleted, isTrue);
      expect(lab.isSuccess, isTrue);
      expect(lab.score, equals(80.0));
      lab.dispose();
    });

    test('No tactic position handling', () {
      const fen = 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1';
      final lab = TacticalLab(
        id: 'no_tac_1',
        title: 'Opening Balance',
        initialFen: fen,
        solutionSan: ['c5'],
        explanation: 'Solid play needed.',
        motif: 'No Tactic Exists',
        isNoTacticPosition: true,
      );

      final result = lab.declareNoTactic();
      expect(result, equals(LabStepResult.noTacticCorrect));
      expect(lab.isSuccess, isTrue);
      lab.dispose();
    });

    test('Endgame Win Defend Lab vs Engine', () async {
      final engine = EmbeddedHeuristicEngine();
      await engine.initialize();

      // Checkmate in 1: White to move and win
      const fen = 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1';
      final lab = EndgameWinDefendLab(
        id: 'endgame_1',
        title: 'Deliver Mate',
        initialFen: fen,
        isMustWin: true,
        objective: 'Deliver checkmate against engine.',
        engine: engine,
      );

      final mateMove = MoveGenerator.sanToMove(lab.currentBoard, 'Qxf7#')!;
      await lab.playUserMove(mateMove);

      expect(lab.isCompleted, isTrue);
      expect(lab.isSuccess, isTrue);
      await engine.dispose();
    });
  });
}
