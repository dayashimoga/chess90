import 'package:chess_core/chess_core.dart';
import '../engine_interface.dart';
import 'move_classification.dart';

/// The 14 hierarchical root-cause categories defined in the ChessMaster mastery engine.
enum RootCauseCategory {
  // --- 14 Canonical Hierarchical Root-Causes ---
  tacticsMotif(
    'Tactical Motif Missed',
    'Failed to calculate or recognize a fundamental tactical motif (pin, fork, skewer, deflection).',
    'tactical_recognition',
    4,
  ),
  candidateGeneration(
    'Candidate Move Generation Flaw',
    'Failed to brainstorm alternative candidate moves before diving into calculation.',
    'candidate_selection',
    15,
  ),
  opponentForcingMoveBlindness(
    'Opponent Forcing Move Blindness',
    'Failed to spot opponent\'s forcing counter-threat (checks, captures, immediate threats).',
    'tactical_recognition',
    8,
  ),
  visualization(
    'Visualization & Mental Simulation Gap',
    'Board geometry or piece locations blurred in deep mental calculation.',
    'blind_calculation',
    18,
  ),
  horizon(
    'Calculation Horizon Cutoff',
    'Stopped calculating 1-2 plies too early before the position became quiet.',
    'blind_calculation',
    22,
  ),
  quietMoveBlindness(
    'Quiet Move Blindness',
    'Missed a decisive intermediate or quiet non-forcing defensive/offensive move.',
    'candidate_selection',
    25,
  ),
  finalEvaluation(
    'Faulty Static Evaluation',
    'Reached the terminal node in calculation but misjudged the resulting imbalance.',
    'positional_evaluation',
    29,
  ),
  pawnStructureStrategy(
    'Pawn-Structure & Strategic Error',
    'Created structural weakness, doubled pawns, backward pawn, or conceded key outpost.',
    'pawn_break',
    32,
  ),
  openingUnderstandingMemory(
    'Opening Understanding & Memory',
    'Deviated from sound opening principles or theoretical plans.',
    'opening_plans',
    57,
  ),
  endgameTheory(
    'Endgame Theoretical Gap',
    'Misplayed theoretical endgame principles (Lucena, Philidor, opposition, key squares).',
    'endgame_win_defend',
    43,
  ),
  conversion(
    'Conversion Inefficiency',
    'Failed to cleanly convert a winning material or positional advantage.',
    'conversion_defense',
    71,
  ),
  defense(
    'Defensive Resource Blindness',
    'Collapsed under opponent\'s attack or missed resilient tenacious defensive resources.',
    'defensive_resource',
    74,
  ),
  timeManagement(
    'Time Pressure Breakdown',
    'Rushed decision or clock scramble leading to blunder with low time.',
    'time_management',
    78,
  ),
  blunderCheckOmission(
    'Blunder Check Omission',
    'Left a piece undefended or missed 1-move tactic due to skipping final blunder check.',
    'tactical_recognition',
    3,
  ),

  // --- Legacy Aliases for Full Backwards Compatibility ---
  missedTacticOpponentForcingMove(
    'Missed Tactic / Opponent Forcing Move',
    'Failed to spot a tactical motif or opponent\'s forcing reply (check, capture, threat).',
    'tactical_recognition',
    2,
  ),
  badCandidateGeneration(
    'Inadequate Candidate Move Generation',
    'Failed to consider viable candidate moves before diving into calculation.',
    'candidate_selection',
    15,
  ),
  visualizationCalculationHorizon(
    'Calculation Horizon / Visualization Error',
    'Calculated the line but misjudged or cut off calculation 1-2 moves too early.',
    'blind_calculation',
    18,
  ),
  wrongEvaluation(
    'Faulty Static Evaluation',
    'Reached the correct end position in thought, but misjudged who stood better.',
    'positional_evaluation',
    29,
  ),
  positionalPawnStructureMisunderstanding(
    'Positional / Pawn-Structure Error',
    'Compromised pawn structure, gave up key outpost, or traded the wrong minor piece.',
    'pawn_break',
    32,
  ),
  openingMemoryPlan(
    'Opening Memory / Plan Deviation',
    'Played an inaccurate move in a known opening, losing tempo or pawn control.',
    'opening_plans',
    57,
  ),
  endgameGap(
    'Endgame Technical Gap',
    'Misplayed a theoretical endgame (opposition, Lucena, Philidor, active rook).',
    'endgame_win_defend',
    43,
  ),
  conversionDefenseFailure(
    'Advantage Conversion / Defensive Breakdown',
    'Failed to convert a winning position or collapsed under defensive pressure.',
    'conversion_defense',
    71,
  ),
  timePressure(
    'Time Pressure Panic',
    'Blundered with under 30 seconds remaining on the clock.',
    'time_management',
    78,
  ),
  impulsiveMove(
    'Impulsive / Rushed Move',
    'Blundered in a complex position after spending less than 3 seconds thinking.',
    'candidate_selection',
    16,
  ),
  failedBlunderCheck(
    'Blunder Check Omission',
    'Left a piece hanging or missed a 1-move tactic by failing to ask "What is opponent\'s threat?".',
    'tactical_recognition',
    3,
  );

  final String title;
  final String description;
  final String prescribedLabType;
  final int defaultCurriculumDay;

  const RootCauseCategory(
    this.title,
    this.description,
    this.prescribedLabType,
    this.defaultCurriculumDay,
  );
}

/// Hierarchical cognitive domains for master-level diagnosis.
enum CognitiveDomain {
  calculation('Calculation & Candidate Search'),
  tactics('Tactical Vision & Blunder Safety'),
  positional('Positional & Strategic Understanding'),
  endgame('Endgame Technique & Precision'),
  psychological('Psychology & Time Discipline');

  final String title;
  const CognitiveDomain(this.title);
}

/// Detailed diagnosis of an inaccurate move with hierarchical root-cause and retraining prescription.
class RootCauseDiagnosis {
  final RootCauseCategory category;
  final CognitiveDomain primaryDomain;
  final String subCause;
  final MoveQuality quality;
  final Move playedMove;
  final Move? engineBestMove;
  final int centipawnLoss;
  final String explanation;
  final String prescribedLab;
  final int prescribedCurriculumDay;
  final String? evidenceFen;
  final int recurrenceCount;
  final double confidence;
  final String evidence;
  final String trainingPrescription;

  const RootCauseDiagnosis({
    required this.category,
    required this.primaryDomain,
    required this.subCause,
    required this.quality,
    required this.playedMove,
    this.engineBestMove,
    required this.centipawnLoss,
    required this.explanation,
    required this.prescribedLab,
    required this.prescribedCurriculumDay,
    this.evidenceFen,
    this.recurrenceCount = 1,
    this.confidence = 0.90,
    String? evidence,
    String? trainingPrescription,
  })  : evidence = evidence ?? explanation,
        trainingPrescription = trainingPrescription ??
            'Complete prescribed lab "$prescribedLab" exercises and review Day $prescribedCurriculumDay curriculum theory.';

  int get recurrence => recurrenceCount;

  Map<String, dynamic> toJson() => {
        'category': category.name,
        'primaryDomain': primaryDomain.name,
        'subCause': subCause,
        'quality': quality.name,
        'playedMove': playedMove.uci,
        'engineBestMove': engineBestMove?.uci,
        'centipawnLoss': centipawnLoss,
        'explanation': explanation,
        'prescribedLab': prescribedLab,
        'prescribedCurriculumDay': prescribedCurriculumDay,
        'evidenceFen': evidenceFen,
        'recurrenceCount': recurrenceCount,
        'recurrence': recurrenceCount,
        'confidence': confidence,
        'evidence': evidence,
        'trainingPrescription': trainingPrescription,
      };

  @override
  String toString() => '[${primaryDomain.name.toUpperCase()}/$subCause] ${category.title} (-${centipawnLoss}cp): $explanation';
}

/// Diagnostic engine that analyzes erroneous moves and identifies the underlying cognitive root-cause.
class RootCauseClassifier {
  /// Diagnoses the cognitive root cause of a suboptimal chess move.
  static RootCauseDiagnosis diagnose({
    required Board boardBeforeMove,
    required Move playedMove,
    required EngineEvaluation evaluationBefore,
    required EngineEvaluation evaluationAfter,
    Duration? moveDuration,
    Duration? clockRemaining,
    String? userSelfAnalysisNote,
  }) {
    int evalBefore = evaluationBefore.scoreCentipawns ?? 0;
    if (evaluationBefore.mateInMoves != null) {
      evalBefore = evaluationBefore.mateInMoves! > 0 ? 30000 : -30000;
    }

    int evalAfterOpp = evaluationAfter.scoreCentipawns ?? 0;
    if (evaluationAfter.mateInMoves != null) {
      evalAfterOpp = evaluationAfter.mateInMoves! > 0 ? 30000 : -30000;
    }

    final evalAfterPlayer = -evalAfterOpp;
    final cpLoss = (evalBefore - evalAfterPlayer).clamp(0, 5000);

    final quality = MoveQuality.classify(
      evalBefore: evalBefore,
      evalAfter: evalAfterOpp,
    );

    // 1. Time Pressure Panic: clock remaining < 30 seconds
    if (clockRemaining != null && clockRemaining < const Duration(seconds: 30) && quality.isNegative) {
      return RootCauseDiagnosis(
        category: RootCauseCategory.timePressure,
        primaryDomain: CognitiveDomain.psychological,
        subCause: 'time-pressure',
        quality: quality,
        playedMove: playedMove,
        engineBestMove: evaluationBefore.bestMove,
        centipawnLoss: cpLoss,
        explanation: 'Blundered under extreme time pressure (${clockRemaining.inSeconds}s remaining). Practical clock management needed.',
        prescribedLab: RootCauseCategory.timePressure.prescribedLabType,
        prescribedCurriculumDay: RootCauseCategory.timePressure.defaultCurriculumDay,
        evidenceFen: boardBeforeMove.toFen(),
      );
    }

    // 2. Impulsive / Rushed Move: move made in < 3 seconds in non-trivial position
    if (moveDuration != null && moveDuration < const Duration(seconds: 3) && quality.isNegative && boardBeforeMove.fullmoveNumber > 5) {
      return RootCauseDiagnosis(
        category: RootCauseCategory.impulsiveMove,
        primaryDomain: CognitiveDomain.psychological,
        subCause: 'impulsive-move',
        quality: quality,
        playedMove: playedMove,
        engineBestMove: evaluationBefore.bestMove,
        centipawnLoss: cpLoss,
        explanation: 'Rushed move (${moveDuration.inSeconds}s). Failed to sit on hands and perform a disciplined safety verification.',
        prescribedLab: RootCauseCategory.impulsiveMove.prescribedLabType,
        prescribedCurriculumDay: RootCauseCategory.impulsiveMove.defaultCurriculumDay,
        evidenceFen: boardBeforeMove.toFen(),
      );
    }

    // 3. Endgame Technical Gap: 6 or fewer pieces on the board
    int pieceCount = 0;
    for (int i = 0; i < 64; i++) {
      if (boardBeforeMove.pieceAtIndex(i) != null) pieceCount++;
    }
    if (pieceCount <= 6 && quality.isNegative) {
      return RootCauseDiagnosis(
        category: RootCauseCategory.endgameGap,
        primaryDomain: CognitiveDomain.endgame,
        subCause: 'theoretical-gap',
        quality: quality,
        playedMove: playedMove,
        engineBestMove: evaluationBefore.bestMove,
        centipawnLoss: cpLoss,
        explanation: 'Endgame precision failure with $pieceCount pieces remaining. Technical theoretical endgame knowledge required.',
        prescribedLab: RootCauseCategory.endgameGap.prescribedLabType,
        prescribedCurriculumDay: RootCauseCategory.endgameGap.defaultCurriculumDay,
        evidenceFen: boardBeforeMove.toFen(),
      );
    }

    // 3. Tactical Blunder Check Omission: immediate checkmate or hanging piece allowed
    final testBoard = boardBeforeMove.clone();
    testBoard.makeMove(playedMove);
    final opponentReplies = MoveGenerator.generateLegalMoves(testBoard);

    bool hasImmediateMate = false;
    for (final reply in opponentReplies) {
      final b = testBoard.clone();
      b.makeMove(reply);
      if (MoveGenerator.getGameStatus(b) == GameStatus.checkmate) {
        hasImmediateMate = true;
        break;
      }
    }

    final bigCapture = opponentReplies.any((m) {
      if (!m.isCapture) return false;
      final target = testBoard.pieceAt(m.to);
      return target != null && target.type.baseValue >= 300;
    });

    if ((hasImmediateMate || bigCapture) && cpLoss >= 250) {
      return RootCauseDiagnosis(
        category: hasImmediateMate
            ? RootCauseCategory.missedTacticOpponentForcingMove
            : RootCauseCategory.failedBlunderCheck,
        primaryDomain: CognitiveDomain.tactics,
        subCause: hasImmediateMate ? 'mating-net' : 'failed-blunder-check',
        quality: quality,
        playedMove: playedMove,
        engineBestMove: evaluationBefore.bestMove,
        centipawnLoss: cpLoss,
        explanation: hasImmediateMate
            ? 'Allowed immediate mating net on the board. Calculation of opponent forcing checks was omitted.'
            : 'Left material undefended or walked into immediate tactical reply. Forgot fundamental check: "What can opponent capture?"',
        prescribedLab: RootCauseCategory.missedTacticOpponentForcingMove.prescribedLabType,
        prescribedCurriculumDay: RootCauseCategory.missedTacticOpponentForcingMove.defaultCurriculumDay,
        evidenceFen: boardBeforeMove.toFen(),
      );
    }

    // 4. Opening Deviation: fullmove <= 10
    if (boardBeforeMove.fullmoveNumber <= 10 && cpLoss >= 100) {
      return RootCauseDiagnosis(
        category: RootCauseCategory.openingMemoryPlan,
        primaryDomain: CognitiveDomain.positional,
        subCause: 'opening-plan-deviation',
        quality: quality,
        playedMove: playedMove,
        engineBestMove: evaluationBefore.bestMove,
        centipawnLoss: cpLoss,
        explanation: 'Deviated from sound opening principles or repertoire on move ${boardBeforeMove.fullmoveNumber}.',
        prescribedLab: RootCauseCategory.openingMemoryPlan.prescribedLabType,
        prescribedCurriculumDay: RootCauseCategory.openingMemoryPlan.defaultCurriculumDay,
        evidenceFen: boardBeforeMove.toFen(),
      );
    }

    // 6. Missed Tactic / Opponent Forcing Move
    if (cpLoss >= 150) {
      return RootCauseDiagnosis(
        category: RootCauseCategory.missedTacticOpponentForcingMove,
        primaryDomain: CognitiveDomain.tactics,
        subCause: 'missed-forcing-tactic',
        quality: quality,
        playedMove: playedMove,
        engineBestMove: evaluationBefore.bestMove,
        centipawnLoss: cpLoss,
        explanation: 'Tactical oversight. A concrete forcing combination was overlooked.',
        prescribedLab: RootCauseCategory.missedTacticOpponentForcingMove.prescribedLabType,
        prescribedCurriculumDay: RootCauseCategory.missedTacticOpponentForcingMove.defaultCurriculumDay,
        evidenceFen: boardBeforeMove.toFen(),
      );
    }

    // 7. Positional / Pawn Structure Misunderstanding
    return RootCauseDiagnosis(
      category: RootCauseCategory.positionalPawnStructureMisunderstanding,
      primaryDomain: CognitiveDomain.positional,
      subCause: 'pawn-structure-misjudgment',
      quality: quality,
      playedMove: playedMove,
      engineBestMove: evaluationBefore.bestMove,
      centipawnLoss: cpLoss,
      explanation: 'Positional slip. Strategic piece activity, square control, or pawn structure was compromised.',
      prescribedLab: RootCauseCategory.positionalPawnStructureMisunderstanding.prescribedLabType,
      prescribedCurriculumDay: RootCauseCategory.positionalPawnStructureMisunderstanding.defaultCurriculumDay,
      evidenceFen: boardBeforeMove.toFen(),
    );
  }
}
