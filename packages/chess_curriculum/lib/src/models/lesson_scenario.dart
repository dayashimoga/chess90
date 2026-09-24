import 'package:chess_core/chess_core.dart';
import 'curriculum_day.dart';
import 'curriculum_exercise.dart';

/// A single interactive action required from the user during continuous learning.
enum ActionType {
  observe,
  tapTargetSquares,
  freePieceMove,
  predictTarget,
  executeMove,
  refuteCandidate,
}

class InteractiveAction {
  final ActionType type;
  final String instruction;
  final List<String> targetSquares;
  final String? expectedMoveSan;
  final String? feedbackOnSuccess;
  final String? feedbackOnFailure;

  const InteractiveAction({
    required this.type,
    required this.instruction,
    this.targetSquares = const [],
    this.expectedMoveSan,
    this.feedbackOnSuccess,
    this.feedbackOnFailure,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'instruction': instruction,
        'targetSquares': targetSquares,
        'expectedMoveSan': expectedMoveSan,
        'feedbackOnSuccess': feedbackOnSuccess,
        'feedbackOnFailure': feedbackOnFailure,
      };

  factory InteractiveAction.fromJson(Map<String, dynamic> json) =>
      InteractiveAction(
        type: ActionType.values.firstWhere(
          (t) => t.name == json['type'],
          orElse: () => ActionType.executeMove,
        ),
        instruction: json['instruction'] as String? ?? '',
        targetSquares: (json['targetSquares'] as List<dynamic>?)?.cast<String>() ?? const [],
        expectedMoveSan: json['expectedMoveSan'] as String?,
        feedbackOnSuccess: json['feedbackOnSuccess'] as String?,
        feedbackOnFailure: json['feedbackOnFailure'] as String?,
      );
}

/// A structured step in the continuous interactive teaching sequence.
class TeachingStep {
  final int stepIndex;
  final String text;
  final String? boardFen;
  final List<String> highlightSquares;
  final List<String> arrows; // format: "e2e4" or "e2e4:#10B981"
  final String? autoPlayMoveSan;
  final InteractiveAction? interactiveAction;

  const TeachingStep({
    required this.stepIndex,
    required this.text,
    this.boardFen,
    this.highlightSquares = const [],
    this.arrows = const [],
    this.autoPlayMoveSan,
    this.interactiveAction,
  });

  Map<String, dynamic> toJson() => {
        'stepIndex': stepIndex,
        'text': text,
        'boardFen': boardFen,
        'highlightSquares': highlightSquares,
        'arrows': arrows,
        'autoPlayMoveSan': autoPlayMoveSan,
        'interactiveAction': interactiveAction?.toJson(),
      };

  factory TeachingStep.fromJson(Map<String, dynamic> json) => TeachingStep(
        stepIndex: json['stepIndex'] as int? ?? 0,
        text: json['text'] as String? ?? '',
        boardFen: json['boardFen'] as String?,
        highlightSquares: (json['highlightSquares'] as List<dynamic>?)?.cast<String>() ?? const [],
        arrows: (json['arrows'] as List<dynamic>?)?.cast<String>() ?? const [],
        autoPlayMoveSan: json['autoPlayMoveSan'] as String?,
        interactiveAction: json['interactiveAction'] != null
            ? InteractiveAction.fromJson(json['interactiveAction'] as Map<String, dynamic>)
            : null,
      );
}

/// A secondary position for guided or independent practice within a lesson scenario.
class PracticePosition {
  final String id;
  final String fen;
  final PieceColor sideToMove;
  final String instruction;
  final List<String> expectedMoves;
  final String explanation;
  final String hintConcept;
  final String hintPieceOrSquare;
  final String hintMove;
  final Map<String, String> refutations;

  const PracticePosition({
    required this.id,
    required this.fen,
    required this.sideToMove,
    required this.instruction,
    required this.expectedMoves,
    required this.explanation,
    required this.hintConcept,
    required this.hintPieceOrSquare,
    required this.hintMove,
    this.refutations = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fen': fen,
        'sideToMove': sideToMove.name,
        'instruction': instruction,
        'expectedMoves': expectedMoves,
        'explanation': explanation,
        'hintConcept': hintConcept,
        'hintPieceOrSquare': hintPieceOrSquare,
        'hintMove': hintMove,
        'refutations': refutations,
      };

  factory PracticePosition.fromJson(Map<String, dynamic> json) => PracticePosition(
        id: json['id'] as String,
        fen: json['fen'] as String,
        sideToMove: PieceColor.values.firstWhere(
          (c) => c.name == json['sideToMove'],
          orElse: () => PieceColor.white,
        ),
        instruction: json['instruction'] as String,
        expectedMoves: (json['expectedMoves'] as List<dynamic>).cast<String>(),
        explanation: json['explanation'] as String,
        hintConcept: json['hintConcept'] as String,
        hintPieceOrSquare: json['hintPieceOrSquare'] as String,
        hintMove: json['hintMove'] as String,
        refutations: (json['refutations'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, v.toString()),
            ) ??
            const {},
      );

  CurriculumExercise toExercise() => CurriculumExercise(
        id: id,
        fen: fen,
        sideToPlay: sideToMove,
        instruction: instruction,
        solutionSan: expectedMoves,
        explanation: explanation,
        hints: [hintConcept, hintPieceOrSquare, hintMove],
        motif: hintConcept,
        hintConcept: hintConcept,
        hintPiece: hintPieceOrSquare,
        hintForcing: hintMove,
        refutationAnalysis: refutations.values.isNotEmpty ? refutations.values.first : null,
      );
}

/// A spaced-repetition retention position testing the same concept in a new geometry.
class RetentionPosition {
  final String id;
  final String fen;
  final PieceColor sideToMove;
  final String instruction;
  final List<String> expectedMoves;
  final String explanation;
  final int daysInterval;

  const RetentionPosition({
    required this.id,
    required this.fen,
    required this.sideToMove,
    required this.instruction,
    required this.expectedMoves,
    required this.explanation,
    this.daysInterval = 3,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fen': fen,
        'sideToMove': sideToMove.name,
        'instruction': instruction,
        'expectedMoves': expectedMoves,
        'explanation': explanation,
        'daysInterval': daysInterval,
      };

  factory RetentionPosition.fromJson(Map<String, dynamic> json) => RetentionPosition(
        id: json['id'] as String,
        fen: json['fen'] as String,
        sideToMove: PieceColor.values.firstWhere(
          (c) => c.name == json['sideToMove'],
          orElse: () => PieceColor.white,
        ),
        instruction: json['instruction'] as String,
        expectedMoves: (json['expectedMoves'] as List<dynamic>).cast<String>(),
        explanation: json['explanation'] as String,
        daysInterval: json['daysInterval'] as int? ?? 3,
      );
}

/// Engine verification stamp documenting Stockfish 19 / UCI validation.
class EngineVerification {
  final bool verified;
  final String engine;
  final int depth;
  final double evalCentipawns;
  final String? bestMoveSan;
  final String timestamp;

  const EngineVerification({
    required this.verified,
    required this.engine,
    required this.depth,
    required this.evalCentipawns,
    this.bestMoveSan,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'verified': verified,
        'engine': engine,
        'depth': depth,
        'evalCentipawns': evalCentipawns,
        'bestMoveSan': bestMoveSan,
        'timestamp': timestamp,
      };

  factory EngineVerification.fromJson(Map<String, dynamic> json) => EngineVerification(
        verified: json['verified'] as bool? ?? false,
        engine: json['engine'] as String? ?? 'Stockfish 19',
        depth: json['depth'] as int? ?? 12,
        evalCentipawns: (json['evalCentipawns'] as num?)?.toDouble() ?? 0.0,
        bestMoveSan: json['bestMoveSan'] as String?,
        timestamp: json['timestamp'] as String? ?? '',
      );
}

/// The ONE Authoritative LessonScenario schema required for all 90 days.
/// Eliminates generic/fallback puzzle reuse and guarantees semantic correctness.
class LessonScenario {
  final String id;
  final int day;
  final CurriculumPhase phase;
  final String concept;
  final String subconcept;
  final int difficulty;
  final String learningObjective;
  final List<int> prerequisites;
  final String fen;
  final PieceColor sideToMove;
  final List<String> conceptMarkers;
  final List<TeachingStep> teachingSequence;
  final List<InteractiveAction> interactiveActions;
  final List<String> expectedMoves;
  final List<String> acceptableAlternatives;
  final List<String> opponentReplies;
  final Map<String, String> refutations;
  final String hint1Concept;
  final String hint2PieceOrSquare;
  final String hint3Move;
  final List<String> fullLine;
  final String explanation;
  final List<String> commonMistakes;
  final Map<String, dynamic> miniGameConfig;
  final List<PracticePosition> practicePositions;
  final List<RetentionPosition> retentionPositions;
  final String source;
  final EngineVerification? engineVerification;

  const LessonScenario({
    required this.id,
    required this.day,
    required this.phase,
    required this.concept,
    required this.subconcept,
    required this.difficulty,
    required this.learningObjective,
    this.prerequisites = const [],
    required this.fen,
    required this.sideToMove,
    this.conceptMarkers = const [],
    this.teachingSequence = const [],
    this.interactiveActions = const [],
    required this.expectedMoves,
    this.acceptableAlternatives = const [],
    this.opponentReplies = const [],
    this.refutations = const {},
    required this.hint1Concept,
    required this.hint2PieceOrSquare,
    required this.hint3Move,
    this.fullLine = const [],
    required this.explanation,
    this.commonMistakes = const [],
    this.miniGameConfig = const {},
    this.practicePositions = const [],
    this.retentionPositions = const [],
    required this.source,
    this.engineVerification,
  });

  /// Deterministic unique identifier for telemetry, logging, and E2E verification.
  String get deterministicKey => '${day}_${concept.replaceAll(' ', '_')}_$id';

  /// Primary winning move SAN.
  String get primaryMoveSan => expectedMoves.isNotEmpty ? expectedMoves.first : '';

  /// Converts this authoritative scenario into a standard CurriculumExercise for backward compatibility.
  CurriculumExercise toPrimaryExercise() {
    return CurriculumExercise(
      id: id,
      fen: fen,
      sideToPlay: sideToMove,
      instruction: learningObjective,
      solutionSan: expectedMoves,
      explanation: explanation,
      hints: [hint1Concept, hint2PieceOrSquare, hint3Move],
      penaltyPerHint: 0.20,
      motif: concept,
      hintConcept: hint1Concept,
      hintPiece: hint2PieceOrSquare,
      hintForcing: hint3Move,
      refutationAnalysis: refutations.values.isNotEmpty ? refutations.values.first : null,
    );
  }

  /// Converts all practice positions into CurriculumExercises.
  List<CurriculumExercise> toAllExercises() {
    return [
      toPrimaryExercise(),
      ...practicePositions.map((p) => p.toExercise()),
    ];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'day': day,
        'phase': phase.name,
        'concept': concept,
        'subconcept': subconcept,
        'difficulty': difficulty,
        'learningObjective': learningObjective,
        'prerequisites': prerequisites,
        'fen': fen,
        'sideToMove': sideToMove.name,
        'conceptMarkers': conceptMarkers,
        'teachingSequence': teachingSequence.map((s) => s.toJson()).toList(),
        'interactiveActions': interactiveActions.map((a) => a.toJson()).toList(),
        'expectedMoves': expectedMoves,
        'acceptableAlternatives': acceptableAlternatives,
        'opponentReplies': opponentReplies,
        'refutations': refutations,
        'hint1Concept': hint1Concept,
        'hint2PieceOrSquare': hint2PieceOrSquare,
        'hint3Move': hint3Move,
        'fullLine': fullLine,
        'explanation': explanation,
        'commonMistakes': commonMistakes,
        'miniGameConfig': miniGameConfig,
        'practicePositions': practicePositions.map((p) => p.toJson()).toList(),
        'retentionPositions': retentionPositions.map((r) => r.toJson()).toList(),
        'source': source,
        'engineVerification': engineVerification?.toJson(),
      };

  factory LessonScenario.fromJson(Map<String, dynamic> json) {
    final dayNum = json['day'] as int;
    final phaseName = json['phase'] as String?;
    final phase = CurriculumPhase.values.firstWhere(
      (p) => p.name == phaseName,
      orElse: () => CurriculumPhase.forDay(dayNum),
    );

    return LessonScenario(
      id: json['id'] as String,
      day: dayNum,
      phase: phase,
      concept: json['concept'] as String,
      subconcept: json['subconcept'] as String? ?? '',
      difficulty: json['difficulty'] as int? ?? 1200,
      learningObjective: json['learningObjective'] as String,
      prerequisites: (json['prerequisites'] as List<dynamic>?)?.cast<int>() ?? const [],
      fen: json['fen'] as String,
      sideToMove: PieceColor.values.firstWhere(
        (c) => c.name == json['sideToMove'],
        orElse: () => PieceColor.white,
      ),
      conceptMarkers: (json['conceptMarkers'] as List<dynamic>?)?.cast<String>() ?? const [],
      teachingSequence: (json['teachingSequence'] as List<dynamic>?)
              ?.map((s) => TeachingStep.fromJson(s as Map<String, dynamic>))
              .toList() ??
          const [],
      interactiveActions: (json['interactiveActions'] as List<dynamic>?)
              ?.map((a) => InteractiveAction.fromJson(a as Map<String, dynamic>))
              .toList() ??
          const [],
      expectedMoves: (json['expectedMoves'] as List<dynamic>).cast<String>(),
      acceptableAlternatives:
          (json['acceptableAlternatives'] as List<dynamic>?)?.cast<String>() ?? const [],
      opponentReplies: (json['opponentReplies'] as List<dynamic>?)?.cast<String>() ?? const [],
      refutations: (json['refutations'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          const {},
      hint1Concept: json['hint1Concept'] as String,
      hint2PieceOrSquare: json['hint2PieceOrSquare'] as String,
      hint3Move: json['hint3Move'] as String,
      fullLine: (json['fullLine'] as List<dynamic>?)?.cast<String>() ?? const [],
      explanation: json['explanation'] as String,
      commonMistakes: (json['commonMistakes'] as List<dynamic>?)?.cast<String>() ?? const [],
      miniGameConfig: json['miniGameConfig'] as Map<String, dynamic>? ?? const {},
      practicePositions: (json['practicePositions'] as List<dynamic>?)
              ?.map((p) => PracticePosition.fromJson(p as Map<String, dynamic>))
              .toList() ??
          const [],
      retentionPositions: (json['retentionPositions'] as List<dynamic>?)
              ?.map((r) => RetentionPosition.fromJson(r as Map<String, dynamic>))
              .toList() ??
          const [],
      source: json['source'] as String? ?? 'Curated Canonical Chess Library',
      engineVerification: json['engineVerification'] != null
          ? EngineVerification.fromJson(json['engineVerification'] as Map<String, dynamic>)
          : null,
    );
  }
}
