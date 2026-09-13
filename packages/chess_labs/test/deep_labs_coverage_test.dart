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

    test('Learning-first features: tiered hints, show best move, show line, and explain why', () {
      final session = LabSession(
        id: 'pedagogical_test',
        title: 'Fork Tactics',
        labType: 'tactical_lab',
        initialFen: 'r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQkq - 0 5',
        solutionSan: const ['Bxf7+', 'Kxf7', 'Ng5+'],
        hints: const ['Look for forcing checks on f7.'],
        explanation: 'Bxf7+ destroys king safety followed by Ng5+ fork.',
        hintConcept: 'King safety destruction',
        hintPiece: 'Light-squared bishop on c4',
        hintForcing: 'Play Bxf7+',
        refutationAnalysis: 'Playing quiet moves cedes initiative.',
      );

      expect(session.isNoTacticActionVisible, isFalse);
      expect(session.tieredHints.length, 3);
      expect(session.tieredHints[0], contains('King safety destruction'));
      expect(session.tieredHints[1], contains('Light-squared bishop'));
      expect(session.tieredHints[2], contains('Bxf7+'));

      // 1. Tiered Hint without penalty
      final h1 = session.requestTieredHint(penalize: false);
      expect(h1, contains('King safety destruction'));
      expect(session.score, 100.0);
      expect(session.hintsRevealed, 1);

      final h2 = session.requestTieredHint(penalize: false);
      expect(h2, contains('Light-squared bishop'));
      expect(session.score, 100.0);

      final h3 = session.requestTieredHint(penalize: false);
      expect(h3, contains('Bxf7+'));
      expect(session.score, 100.0);

      // Exhausted hints
      final h4 = session.requestTieredHint(penalize: false);
      expect(h4, isNull);

      // 2. Explain Why
      final explanation = session.explainWhy();
      expect(explanation, contains('Bxf7+'));
      expect(explanation, contains('Refutation:'));

      // 3. Show Move (plays Bxf7+ and auto-replies Kxf7)
      final bestMove = session.showBestMove();
      expect(bestMove, 'Bxf7+');
      expect(session.currentSolutionIndex, 2);

      // 4. Show Line (plays remaining verified line: Ng5+)
      final line = session.showLine();
      expect(line, equals(const ['Ng5+']));
      expect(session.isCompleted, isTrue);

      session.dispose();
    });
  });
}
