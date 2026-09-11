import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Embedded Heuristic Chess Engine Tests', () {
    test('Embedded engine evaluates starting position', () async {
      final engine = EmbeddedHeuristicEngine();
      await engine.initialize();
      await engine.setPosition(FenParser.initialFen);

      final eval = await engine.evaluate(depth: 2);
      expect(eval.depth, equals(2));
      expect(eval.bestMove, isNotNull);
      expect(eval.pvLine.isNotEmpty, isTrue);
      await engine.dispose();
    });

    test('Embedded engine finds mate in 1', () async {
      // White to move: Qh7#
      const mateIn1Fen = 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1';
      final engine = EmbeddedHeuristicEngine();
      await engine.initialize();
      await engine.setPosition(mateIn1Fen);

      final eval = await engine.evaluate(depth: 2);
      expect(eval.bestMove, isNotNull);
      // Best move should be Qxf7#
      expect(eval.bestMove?.to, equals(Square.fromName('f7')));
      await engine.dispose();
    });
  });

  group('Move Quality & Classification Tests', () {
    test('Move classification buckets', () {
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: -95), equals(MoveQuality.best));
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: -50), equals(MoveQuality.good));
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: 50), equals(MoveQuality.inaccuracy));
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: 150), equals(MoveQuality.mistake));
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: 350), equals(MoveQuality.blunder));
      // Missed win: was +400, dropped to 0
      expect(MoveQuality.classify(evalBefore: 400, evalAfter: 0), equals(MoveQuality.missedWin));
    });
  });

  group('Root Cause Classifier Tests', () {
    test('Diagnoses time pressure blunder', () {
      final board = Board.initial();
      final move = MoveGenerator.sanToMove(board, 'f3')!;

      final diagnosis = RootCauseClassifier.diagnose(
        boardBeforeMove: board,
        playedMove: move,
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 30, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 250, depth: 10, sideToMove: PieceColor.black),
        clockRemaining: const Duration(seconds: 18),
      );

      expect(diagnosis.category, equals(RootCauseCategory.timePressure));
      expect(diagnosis.prescribedLab, equals('time_management'));
    });

    test('Diagnoses impulsive move', () {
      final board = Board.initial();
      board.fullmoveNumber = 8;
      final move = MoveGenerator.sanToMove(board, 'a3')!;

      final diagnosis = RootCauseClassifier.diagnose(
        boardBeforeMove: board,
        playedMove: move,
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 50, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 200, depth: 10, sideToMove: PieceColor.black),
        moveDuration: const Duration(seconds: 1),
      );

      expect(diagnosis.category, equals(RootCauseCategory.impulsiveMove));
    });

    test('Diagnoses endgame technical gap', () {
      // 4 pieces left on board: K+P vs K+P
      const endgameFen = '8/5k2/8/4P3/8/8/4K3/8 w - - 0 45';
      final board = Board.fromFen(endgameFen);
      final move = Move(from: Square.fromName('e2')!, to: Square.fromName('d3')!);

      final diagnosis = RootCauseClassifier.diagnose(
        boardBeforeMove: board,
        playedMove: move,
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 250, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 0, depth: 10, sideToMove: PieceColor.black),
      );

      expect(diagnosis.category, equals(RootCauseCategory.endgameGap));
      expect(diagnosis.prescribedLab, equals('endgame_win_defend'));
      expect(diagnosis.prescribedCurriculumDay, equals(43));
    });
  });
}
