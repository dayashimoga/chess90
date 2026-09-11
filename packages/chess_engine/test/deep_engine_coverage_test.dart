import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Deep Chess Engine Coverage & Diagnosis Tests', () {
    test('RootCauseCategory and CognitiveDomain full property coverage', () {
      for (final cat in RootCauseCategory.values) {
        expect(cat.title, isNotEmpty);
        expect(cat.description, isNotEmpty);
        expect(cat.prescribedLabType, isNotEmpty);
        expect(cat.defaultCurriculumDay, inInclusiveRange(1, 90));
      }

      for (final domain in CognitiveDomain.values) {
        expect(domain.title, isNotEmpty);
      }
    });

    test('MoveQuality classification across all cp deltas', () {
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: -100), MoveQuality.best);
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: -80), MoveQuality.great);
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: -50), MoveQuality.good);
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: 0), MoveQuality.inaccuracy);
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: 150), MoveQuality.mistake);
      expect(MoveQuality.classify(evalBefore: 100, evalAfter: 350), MoveQuality.blunder);

      expect(MoveQuality.blunder.isNegative, isTrue);
      expect(MoveQuality.mistake.isNegative, isTrue);
      expect(MoveQuality.inaccuracy.isNegative, isTrue);
      expect(MoveQuality.best.isNegative, isFalse);
    });

    test('RootCauseClassifier comprehensive branch coverage', () {
      final board = Board.initial();
      board.fullmoveNumber = 12; // Out of opening

      // 1. Time Pressure Panic
      final diagTime = RootCauseClassifier.diagnose(
        boardBeforeMove: board,
        playedMove: Move(from: Square.e2, to: Square.fromName('e4')!),
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 50, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 350, depth: 10, sideToMove: PieceColor.black),
        clockRemaining: const Duration(seconds: 15),
      );
      expect(diagTime.category, RootCauseCategory.timePressure);
      expect(diagTime.primaryDomain, CognitiveDomain.psychological);
      expect(diagTime.toJson()['category'], 'timePressure');
      expect(diagTime.toString(), contains('time-pressure'));

      // 2. Impulsive Move
      final diagImpulsive = RootCauseClassifier.diagnose(
        boardBeforeMove: board,
        playedMove: Move(from: Square.e2, to: Square.fromName('e4')!),
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 50, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 350, depth: 10, sideToMove: PieceColor.black),
        moveDuration: const Duration(seconds: 1),
      );
      expect(diagImpulsive.category, RootCauseCategory.impulsiveMove);

      // 3. Endgame Technical Gap
      final endgameBoard = Board.fromFen('8/8/8/8/8/4k3/8/4K3 w - - 0 50');
      final diagEndgame = RootCauseClassifier.diagnose(
        boardBeforeMove: endgameBoard,
        playedMove: Move(from: Square.e1, to: Square.fromName('d1')!),
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 0, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 350, depth: 10, sideToMove: PieceColor.black),
      );
      expect(diagEndgame.category, RootCauseCategory.endgameGap);
      expect(diagEndgame.primaryDomain, CognitiveDomain.endgame);

      // 4. Immediate Checkmate Allowed
      final mateBoard = Board.fromFen('r1bqkbnr/pppp1ppp/2n5/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 3');
      final diagMate = RootCauseClassifier.diagnose(
        boardBeforeMove: mateBoard,
        playedMove: Move(from: Square.fromName('g8')!, to: Square.fromName('f6')!),
        evaluationBefore: const EngineEvaluation(scoreCentipawns: -50, depth: 10, sideToMove: PieceColor.black),
        evaluationAfter: const EngineEvaluation(mateInMoves: 1, depth: 10, sideToMove: PieceColor.white),
      );
      expect(diagMate.category, RootCauseCategory.missedTacticOpponentForcingMove);

      // 5. Hanging Piece / Blunder Check Omission
      final hangBoard = Board.fromFen('rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 15');
      final diagHang = RootCauseClassifier.diagnose(
        boardBeforeMove: hangBoard,
        playedMove: Move(from: Square.fromName('f3')!, to: Square.fromName('g5')!),
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 30, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 400, depth: 10, sideToMove: PieceColor.black),
      );
      expect(diagHang.category, RootCauseCategory.failedBlunderCheck);

      // 6. Opening Deviation (move <= 10)
      final openingBoard = Board.initial();
      openingBoard.fullmoveNumber = 3;
      final diagOpening = RootCauseClassifier.diagnose(
        boardBeforeMove: openingBoard,
        playedMove: Move(from: Square.fromName('h2')!, to: Square.fromName('h4')!),
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 30, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 120, depth: 10, sideToMove: PieceColor.black),
      );
      expect(diagOpening.category, RootCauseCategory.openingMemoryPlan);

      // 7. Tactical Oversight (move > 10, cpLoss >= 150)
      final tactBoard = Board.initial();
      tactBoard.fullmoveNumber = 15;
      final diagTactic = RootCauseClassifier.diagnose(
        boardBeforeMove: tactBoard,
        playedMove: Move(from: Square.fromName('g1')!, to: Square.fromName('f3')!),
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 50, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 220, depth: 10, sideToMove: PieceColor.black),
      );
      expect(diagTactic.category, RootCauseCategory.missedTacticOpponentForcingMove);

      // 8. Positional/Pawn Structure Misjudgment
      final posBoard = Board.initial();
      posBoard.fullmoveNumber = 15;
      final diagPos = RootCauseClassifier.diagnose(
        boardBeforeMove: posBoard,
        playedMove: Move(from: Square.fromName('g1')!, to: Square.fromName('f3')!),
        evaluationBefore: const EngineEvaluation(scoreCentipawns: 50, depth: 10, sideToMove: PieceColor.white),
        evaluationAfter: const EngineEvaluation(scoreCentipawns: 90, depth: 10, sideToMove: PieceColor.black),
      );
      expect(diagPos.category, RootCauseCategory.positionalPawnStructureMisunderstanding);
    });

    test('WebStockfishEngine fallback and disposal lifecycle', () async {
      final webEngine = WebStockfishEngine();
      expect(webEngine.engineName, 'Embedded Heuristic Engine');
      expect(webEngine.isFallback, isTrue);

      await webEngine.initialize();
      await webEngine.setPosition('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');

      final eval = await webEngine.evaluate(depth: 2);
      expect(eval.bestMove, isNotNull);

      await webEngine.stop();
      await webEngine.dispose();
    });

    test('EngineEvaluation complete perspective, score formatting, and win probabilities', () {
      // 1. Centipawns for White
      const evalWhiteCp = EngineEvaluation(
        scoreCentipawns: 150,
        depth: 12,
        sideToMove: PieceColor.white,
      );
      expect(evalWhiteCp.scoreFromWhitePerspective, 150);
      expect(evalWhiteCp.formattedScore, '+1.50');
      expect(evalWhiteCp.whiteWinProbability, greaterThan(0.5));
      expect(evalWhiteCp.toString(), contains('depth: 12'));

      // 2. Centipawns for Black
      const evalBlackCp = EngineEvaluation(
        scoreCentipawns: -80,
        depth: 10,
        sideToMove: PieceColor.black,
      );
      expect(evalBlackCp.scoreFromWhitePerspective, 80);
      expect(evalBlackCp.formattedScore, '-0.80');
      expect(evalBlackCp.whiteWinProbability, greaterThan(0.5));

      // 3. Mate in Moves for White (+3 and -2)
      const evalWhiteMate = EngineEvaluation(
        mateInMoves: 3,
        depth: 15,
        sideToMove: PieceColor.white,
      );
      expect(evalWhiteMate.scoreFromWhitePerspective, 30000);
      expect(evalWhiteMate.formattedScore, '#+3');
      expect(evalWhiteMate.whiteWinProbability, 1.0);

      const evalWhiteMated = EngineEvaluation(
        mateInMoves: -2,
        depth: 15,
        sideToMove: PieceColor.white,
      );
      expect(evalWhiteMated.scoreFromWhitePerspective, -30000);
      expect(evalWhiteMated.formattedScore, '#-2');
      expect(evalWhiteMated.whiteWinProbability, 0.0);

      // 4. Mate in Moves for Black (+2 and -4)
      const evalBlackMate = EngineEvaluation(
        mateInMoves: 2,
        depth: 15,
        sideToMove: PieceColor.black,
      );
      expect(evalBlackMate.scoreFromWhitePerspective, -30000);
      expect(evalBlackMate.whiteWinProbability, 0.0);

      const evalBlackMated = EngineEvaluation(
        mateInMoves: -4,
        depth: 15,
        sideToMove: PieceColor.black,
      );
      expect(evalBlackMated.scoreFromWhitePerspective, 30000);
      expect(evalBlackMated.whiteWinProbability, 1.0);
    });

    test('NativeStockfishEngine lifecycle and search stream', () async {
      expect(NativeStockfishEngine.isSupported, isTrue);

      final native = NativeStockfishEngine();
      await native.initialize();
      expect(native.engineName, isNotEmpty);
      expect(native.searchStream, isNotNull);

      await native.setPosition(FenParser.initialFen);
      final eval = await native.evaluate(depth: 2);
      expect(eval.bestMove, isNotNull);

      await native.stop();
      await native.dispose();

      // Test fallback path when native binary is missing
      final fallbackNative = NativeStockfishEngine(forceFallback: true);
      await fallbackNative.initialize();
      expect(fallbackNative.isFallback, isTrue);
      expect(fallbackNative.engineName, 'Embedded Heuristic Engine');
      expect(fallbackNative.searchStream, isNotNull);
      fallbackNative.setOption('Threads', 2);
      await fallbackNative.setPosition(FenParser.initialFen, [Move(from: Square.e2, to: Square.fromName('e4')!)]);
      final fbEval = await fallbackNative.evaluate(depth: 2, timeLimit: const Duration(seconds: 1));
      expect(fbEval.bestMove, isNotNull);
      await fallbackNative.stop();
      await fallbackNative.dispose();

      final heuristic = EmbeddedHeuristicEngine();
      await heuristic.initialize();
      await heuristic.setPosition(FenParser.initialFen);

      bool streamReceived = false;
      final sub = heuristic.searchStream.listen((_) => streamReceived = true);

      final evalH = await heuristic.evaluate(
        depth: 2,
        timeLimit: const Duration(seconds: 1),
      );
      expect(evalH.bestMove, isNotNull);
      expect(streamReceived, isTrue);

      await heuristic.stop();
      await heuristic.dispose();
      await sub.cancel();
    });

    test('EngineWdl and Calibrated Probability Model tests', () {
      const wdl = EngineWdl(winPerMille: 600, drawPerMille: 300, lossPerMille: 100);
      expect(wdl.winProbability, 0.60);
      expect(wdl.drawProbability, 0.30);
      expect(wdl.lossProbability, 0.10);
      expect(wdl.toString(), contains('WDL(600/300/100)'));
      expect(wdl.toJson()['win'], 600);

      const evalWithWdl = EngineEvaluation(
        depth: 18,
        scoreCentipawns: 210,
        sideToMove: PieceColor.white,
        wdl: wdl,
      );
      expect(evalWithWdl.probabilityModelLabel, 'Stockfish Calibrated WDL');
      expect(evalWithWdl.whiteWinProbability, closeTo(0.75, 0.01));

      const evalWithoutWdl = EngineEvaluation(
        depth: 10,
        scoreCentipawns: 0,
        sideToMove: PieceColor.white,
      );
      expect(evalWithoutWdl.probabilityModelLabel, contains('Heuristic'));
      expect(evalWithoutWdl.whiteWinProbability, 0.50);
    });

    test('14 Hierarchical Root Causes and Diagnosis Prescription', () {
      final diag = RootCauseDiagnosis(
        category: RootCauseCategory.tacticsMotif,
        primaryDomain: CognitiveDomain.tactics,
        subCause: 'pin-tactics',
        quality: MoveQuality.blunder,
        playedMove: Move(from: Square.e2, to: Square.e4),
        centipawnLoss: 320,
        explanation: 'Fell into an absolute pin on the queen.',
        prescribedLab: 'tactical_recognition',
        prescribedCurriculumDay: 4,
        confidence: 0.95,
        recurrenceCount: 2,
      );

      expect(diag.category, RootCauseCategory.tacticsMotif);
      expect(diag.recurrence, 2);
      expect(diag.confidence, 0.95);
      expect(diag.trainingPrescription, contains('tactical_recognition'));
      expect(diag.toJson()['confidence'], 0.95);
      expect(diag.toJson()['recurrence'], 2);
      expect(diag.toJson()['trainingPrescription'], isNotEmpty);

      // Verify all 14 canonical categories exist and are accessible
      final canonical14 = [
        RootCauseCategory.tacticsMotif,
        RootCauseCategory.candidateGeneration,
        RootCauseCategory.opponentForcingMoveBlindness,
        RootCauseCategory.visualization,
        RootCauseCategory.horizon,
        RootCauseCategory.quietMoveBlindness,
        RootCauseCategory.finalEvaluation,
        RootCauseCategory.pawnStructureStrategy,
        RootCauseCategory.openingUnderstandingMemory,
        RootCauseCategory.endgameTheory,
        RootCauseCategory.conversion,
        RootCauseCategory.defense,
        RootCauseCategory.timeManagement,
        RootCauseCategory.blunderCheckOmission,
      ];
      expect(canonical14.length, 14);
      for (final cat in canonical14) {
        expect(cat.title, isNotEmpty);
      }
    });
  });
}
