import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:test/test.dart';

void main() {
  group('Comprehensive 16 Interactive Labs Test Suite', () {
    test('1. Tactical Lab: Solution and Hints', () {
      final lab = TacticalLab(
        id: 'tac_1',
        title: 'Fork on c7',
        initialFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
        solutionSan: ['Qxf7#'],
        hints: ['Look at f7', 'Queen and Bishop battery'],
        explanation: 'Queen delivers checkmate guarded by the Bishop on c4.',
        motif: 'Scholar mate attack',
      );
      expect(lab.hintsRevealed, equals(0));
      lab.requestHint();
      expect(lab.hintsRevealed, equals(1));
      expect(lab.score, equals(80.0));
      expect(lab.playMove(Move(from: Square.named('f3'), to: Square.named('f7'), isCapture: true)), equals(LabStepResult.completed));
      expect(lab.isSuccess, isTrue);
    });

    test('2. Candidate Selection Lab', () {
      final lab = CandidateSelectionLab(
        id: 'cand_1',
        title: 'Candidate Moves Discovery',
        initialFen: FenParser.initialFen,
        solutionSan: ['e4'],
        viableCandidates: ['e4', 'd4', 'Nf3'],
        explanation: 'Top classical central candidates.',
      );
      expect(lab.isViableCandidate(Move(from: Square.named('e2'), to: Square.named('e4'))), isTrue);
      expect(lab.isViableCandidate(Move(from: Square.named('a2'), to: Square.named('a4'))), isFalse);
    });

    test('3. Blind Calculation Lab', () {
      final lab = BlindCalculationLab(
        id: 'blind_1',
        title: 'Three-Ply Blind Calculation',
        initialFen: FenParser.initialFen,
        blindMoves: ['e4', 'e5'],
        solutionSan: ['Nf3'],
        explanation: 'Verify visual coordinate tracking.',
      );
      expect(lab.blindMoves.length, equals(2));
      expect(lab.visualizedBoard.pieceAt(Square.named('e4')), isNotNull);
    });

    test('4. Endgame Win Defend Lab', () {
      final lab = EndgameWinDefendLab(
        id: 'endgame_1',
        title: 'Lucena Bridge Building',
        initialFen: '1K1k4/1P6/8/8/8/8/8/2R5 w - - 0 1',
        isMustWin: true,
        objective: 'Rook cuts off king and builds bridge.',
        engine: EmbeddedHeuristicEngine(),
      );
      expect(lab.isMustWin, isTrue);
    });

    test('5. Board Memory Lab', () {
      final lab = BoardMemoryLab(
        id: 'mem_1',
        title: 'Memory Reconstruction',
        initialFen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        solutionSan: ['e5'],
        previewDurationSeconds: 5,
        explanation: 'Reconstruct King Pawn opening.',
      );
      final perfectBoard = Board.fromFen('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1');
      final accuracy = lab.evaluatePlacement(perfectBoard);
      expect(accuracy, equals(1.0));
      expect(lab.isSuccess, isTrue);
    });

    test('6. Visualization Lab', () {
      final lab = VisualizationLab(
        id: 'vis_1',
        title: 'Mental Board Tracking',
        initialFen: FenParser.initialFen,
        solutionSan: ['e4'],
        mentalMoveSequence: ['1. e4 e5', '2. Nf3 Nc6'],
        question: 'Which square does White Knight attack?',
        expectedAnswer: 'e5',
        explanation: 'Knight on f3 attacks e5 and d4.',
      );
      expect(lab.verifyAnswer('e5'), isTrue);
      expect(lab.verifyAnswer('a1'), isFalse);
    });

    test('7. Find The Plan Lab', () {
      final lab = FindThePlanLab(
        id: 'plan_1',
        title: 'Carlsbad Minority Attack',
        initialFen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
        solutionSan: ['b4'],
        candidatePlans: [
          'Plan A: Minority attack with b4-b5 to create weakness on c6',
          'Plan B: Premature f3-e4 pawn break',
          'Plan C: Passive king safety shuffle Kh1',
        ],
        correctPlanIndex: 0,
        planRationale: 'Minority attack on queenside creates isolated or backward pawn.',
        explanation: 'b4 begins minority attack.',
      );
      expect(lab.selectPlan(0), isTrue);
      expect(lab.selectPlan(1), isFalse);
    });

    test('8. Positional Evaluation Lab', () {
      final lab = PositionalEvaluationLab(
        id: 'eval_1',
        title: 'IQP Evaluation',
        initialFen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
        solutionSan: ['Ne5'],
        staticFactors: 'Isolated Queen Pawn on d4; open c and e files.',
        dynamicFactors: 'White has active piece play; Black has blockading square d5.',
        expectedEvaluationBucket: 1, // Slight advantage for White with dynamic piece activity
        explanation: 'Dynamic piece activity outweighs static weakness in early middlegame.',
      );
      expect(lab.submitEvaluation(1), isTrue);
      expect(lab.submitEvaluation(-2), isFalse);
    });

    test('9. Improve Worst Piece Lab', () {
      final lab = ImproveWorstPieceLab(
        id: 'worst_1',
        title: 'Repositioning the Passive Knight',
        initialFen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
        solutionSan: ['Nb5'],
        worstPieceSquare: Square.named('c3'),
        targetOptimalSquare: Square.named('b5'),
        explanation: 'Knight invades towards c7 outpost.',
      );
      expect(lab.worstPieceSquare, equals(Square.named('c3')));
      expect(lab.targetOptimalSquare, equals(Square.named('b5')));
    });

    test('10. Pawn Break Discovery Lab', () {
      final lab = PawnBreakDiscoveryLab(
        id: 'break_1',
        title: 'French Defense Central Pawn Break',
        initialFen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
        solutionSan: ['c5'],
        thematicBreak: 'c5',
        strategicImpact: 'Undermines White central chain at the base on d4.',
        explanation: 'Black must challenge White pawn chain with c5 immediately.',
      );
      expect(lab.thematicBreak, equals('c5'));
    });

    test('11. Pawn Structure Lab', () {
      final lab = PawnStructureLab(
        id: 'struct_1',
        title: 'The Carlsbad Pawn Structure',
        initialFen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
        solutionSan: ['b4'],
        structureName: 'Carlsbad',
        typicalWhitePlan: 'Minority attack on the queenside (b4-b5).',
        typicalBlackPlan: 'Kingside piece attack with Ne4 and f5.',
        explanation: 'Structure dictates planning.',
      );
      expect(lab.structureName, equals('Carlsbad'));
    });

    test('12. Opening Plan Lab', () {
      final lab = OpeningPlanLab(
        id: 'open_1',
        title: 'Sicilian Najdorf Foundations',
        initialFen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/2N5/PPP2PPP/R1BQKB1R b KQkq - 0 5',
        solutionSan: ['a6'],
        openingName: 'Sicilian Defense: Najdorf Variation',
        ecoCode: 'B90',
        typicalPawnStructure: 'Asymmetric center: d6 vs e4, c-file open.',
        strategicPlans: [
          'Prevent Nb5/Bb5 with a6',
          'Expand on queenside with b5',
          'Target backward pawn on d6 or attack on f7',
        ],
        explanation: '5... a6 prevents annoying minor piece checks and prepares b5.',
      );
      expect(lab.ecoCode, equals('B90'));
    });

    test('13. Guess The Move Lab', () {
      final lab = GuessTheMoveLab(
        id: 'gtm_1',
        title: 'Opera Game: Morphy vs Allies',
        initialFen: 'r3kb1r/p2nqppp/5n2/1B2p1B1/4P3/1Q6/PPP2PPP/R3K2R w KQkq - 0 10',
        solutionSan: ['O-O-O'],
        event: 'Paris Opera, 1858',
        whitePlayer: 'Paul Morphy',
        blackPlayer: 'Duke of Brunswick & Count Isouard',
        targetPly: 19,
        explanation: 'Morphy castles queenside bringing the final piece with tempo to d1.',
      );
      expect(lab.whitePlayer, equals('Paul Morphy'));
      expect(lab.targetPly, equals(19));
    });

    test('14. Defensive Resource Lab', () {
      final lab = DefensiveResourceLab(
        id: 'def_1',
        title: 'Perpetual Check Swindle',
        initialFen: '6k1/5ppp/8/8/8/8/5qPP/7K w - - 0 1',
        solutionSan: ['Qe8+'],
        threatDescription: 'Black is threatening mate in 1 on f1.',
        defensiveResourceTheme: 'Perpetual Check on back rank.',
        explanation: 'White saves the half-point by relentless checking.',
      );
      expect(lab.defensiveResourceTheme, contains('Perpetual Check'));
    });

    test('15. Conversion Challenge Lab', () {
      final lab = ConversionChallengeLab(
        id: 'conv_1',
        title: 'Converting the Outside Passed Pawn',
        initialFen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
        solutionSan: ['a6'],
        advantageType: 'Outside Passed Pawn',
        conversionTechnique: 'Push passer to deflect enemy king, then invade with friendly king.',
        explanation: 'Pawn march guarantees promotion.',
      );
      expect(lab.advantageType, contains('Passed Pawn'));
    });

    test('16. Time Management Lab', () {
      final lab = TimeManagementLab(
        id: 'time_1',
        title: 'Time Pressure Accuracy Drill',
        initialFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
        solutionSan: ['Qxf7#'],
        timeLimitPerMove: const Duration(seconds: 15),
        practicalAdvice: 'Under time pressure, prioritize forcing moves (checks, captures, threats).',
        explanation: 'Spot immediate mate without hesitating.',
      );
      expect(lab.timeLimitPerMove.inSeconds, equals(15));
    });
  });
}
