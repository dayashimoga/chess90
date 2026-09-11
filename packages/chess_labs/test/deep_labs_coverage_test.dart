import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:test/test.dart';

void main() {
  group('Deep Chess Labs Coverage & Interactive Mechanics', () {
    test('EndgameWinDefendLab winning, drawing, and defending branches', () async {
      final engine = EmbeddedHeuristicEngine();
      await engine.initialize();

      // 1. Must Win: King + Queen vs King (Scholar's Mate / immediate mate position)
      final winLab = EndgameWinDefendLab(
        id: 'endgame_mate_1',
        title: 'Mate in 1',
        initialFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
        isMustWin: true,
        objective: 'Deliver checkmate on f7',
        engine: engine,
      );

      expect(winLab.isCompleted, isFalse);
      // Play illegal move
      await winLab.playUserMove(const Move(from: Square.a1, to: Square.a8));
      expect(winLab.isCompleted, isFalse);
      expect(winLab.feedback, contains('Illegal move'));

      // Play winning mate move Qf7#
      final mateMove = MoveGenerator.sanToMove(winLab.currentBoard, 'Qxf7#')!;
      await winLab.playUserMove(mateMove);
      expect(winLab.isCompleted, isTrue);
      expect(winLab.isSuccess, isTrue);
      expect(winLab.feedback, contains('Victory'));

      // 2. Must Defend: Hold draw in stalemate or theoretical drawn position
      final defendLab = EndgameWinDefendLab(
        id: 'endgame_stalemate',
        title: 'Hold Stalemate Draw',
        initialFen: 'k7/2K5/8/8/8/8/8/1Q6 w - - 0 1',
        isMustWin: false,
        objective: 'Hold draw',
        engine: engine,
      );

      // White plays blunder stalemate move Qb6
      final staleMove = MoveGenerator.sanToMove(defendLab.currentBoard, 'Qb6')!;
      await defendLab.playUserMove(staleMove);
      expect(defendLab.isCompleted, isTrue);
      expect(defendLab.isSuccess, isTrue);
      expect(defendLab.feedback, contains('Successfully defended'));

      // Subsequent moves ignored after completion
      await defendLab.playUserMove(staleMove);

      // 3. Must Win but results in draw
      final drawFailedLab = EndgameWinDefendLab(
        id: 'endgame_draw_failed',
        title: 'Win required but draws',
        initialFen: 'k7/2K5/8/8/8/8/8/1Q6 w - - 0 1',
        isMustWin: true,
        objective: 'Deliver checkmate',
        engine: engine,
      );
      await drawFailedLab.playUserMove(staleMove);
      expect(drawFailedLab.isCompleted, isTrue);
      expect(drawFailedLab.isSuccess, isFalse);
      expect(drawFailedLab.feedback, contains('Failed: Position resulted in a draw'));

      // 4. Must Defend but engine checkmates
      final defendFailedLab = EndgameWinDefendLab(
        id: 'endgame_defend_failed',
        title: 'Defend but mated',
        initialFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
        isMustWin: false,
        objective: 'Hold draw against White',
        engine: engine,
      );
      await defendFailedLab.playUserMove(mateMove);
      expect(defendFailedLab.isCompleted, isTrue);
      expect(defendFailedLab.isSuccess, isFalse);
      expect(defendFailedLab.feedback, contains('Defeat'));

      await engine.dispose();
    });

    test('LabSession complete mechanics: hints, multi-move, no-tactic, and stream', () async {
      final lab = LabSession(
        id: 'multi_move_lab',
        title: 'Two-Move Fork Combo',
        labType: 'tactical_recognition',
        initialFen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 1',
        solutionSan: ['Nxe5', 'Qe7', 'Nf3'],
        hints: ['Capture central pawn', 'Retreat knight safely'],
        explanation: 'Pawn capture into knight retreat.',
      );

      // Stream subscription
      bool streamFired = false;
      final sub = lab.onUpdate.listen((_) => streamFired = true);

      // Hint requests
      final h1 = lab.requestHint();
      expect(h1, contains('Capture'));
      expect(lab.score, 80.0);

      final h2 = lab.requestHint();
      expect(h2, contains('Retreat'));
      expect(lab.score, 60.0);

      final h3 = lab.requestHint();
      expect(h3, isNull);

      // Incorrect move attempt
      final badMove = MoveGenerator.sanToMove(lab.currentBoard, 'Bc4')!;
      final badRes = lab.playMove(badMove);
      expect(badRes, LabStepResult.incorrect);
      expect(lab.score, 35.0);

      // False "No Tactic" declaration
      final noTacRes = lab.declareNoTactic();
      expect(noTacRes, LabStepResult.noTacticIncorrect);
      expect(lab.score, 5.0);

      // Play step 1: White Nxe5 -> engine replies Black Qe7
      final m1 = MoveGenerator.sanToMove(lab.currentBoard, 'Nxe5')!;
      final res1 = lab.playMove(m1);
      expect(res1, LabStepResult.opponentPlayed);
      expect(lab.currentSolutionIndex, 2);

      // Play step 2: White Nf3 -> completion
      final m2 = MoveGenerator.sanToMove(lab.currentBoard, 'Nf3')!;
      final res2 = lab.playMove(m2);
      expect(res2, LabStepResult.completed);
      expect(lab.isCompleted, isTrue);
      expect(lab.isSuccess, isTrue);

      // Test Reset
      lab.reset();
      expect(lab.isCompleted, isFalse);
      expect(lab.score, 100.0);
      expect(lab.hintsRevealed, 0);

      // Test true No-Tactic position
      final trueNoTacLab = LabSession(
        id: 'peaceful',
        title: 'Quiet Position',
        labType: 'candidate_selection',
        initialFen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        solutionSan: const [],
        explanation: 'Standard start position without immediate tactical combo.',
        isNoTacticPosition: true,
      );

      final quietRes = trueNoTacLab.declareNoTactic();
      expect(quietRes, LabStepResult.noTacticCorrect);
      expect(trueNoTacLab.isSuccess, isTrue);

      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      lab.dispose();
      trueNoTacLab.dispose();
      expect(streamFired, isTrue);
    });
  });
}
