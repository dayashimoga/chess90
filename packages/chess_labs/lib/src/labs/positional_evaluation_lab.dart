import '../lab_session.dart';

/// Positional evaluation and strategic imbalance judgment lab.
/// Teaches calculating material, space, king safety, piece activity, and pawn structure.
class PositionalEvaluationLab extends LabSession {
  final String staticFactors;
  final String dynamicFactors;
  final int expectedEvaluationBucket; // -2 (decisive black), -1 (slight black), 0 (equal), 1 (slight white), 2 (decisive white)

  PositionalEvaluationLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.staticFactors,
    required this.dynamicFactors,
    required this.expectedEvaluationBucket,
    required super.explanation,
    super.hints,
  }) : super(labType: 'positional_evaluation');

  bool submitEvaluation(int bucket) {
    if (bucket == expectedEvaluationBucket) {
      isSuccess = true;
      return true;
    } else {
      score = (score - 25.0).clamp(0.0, 100.0);
      return false;
    }
  }
}
