import '../lab_session.dart';

/// Deep calculation and visualization lab.
/// Requires user to calculate several plies mentally without touching the board,
/// then answers tactical or positional questions about the envisioned end state.
class VisualizationLab extends LabSession {
  final List<String> mentalMoveSequence;
  final String question;
  final String expectedAnswer;

  VisualizationLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.mentalMoveSequence,
    required this.question,
    required this.expectedAnswer,
    required super.explanation,
    super.hints,
  }) : super(labType: 'visualization');

  bool verifyAnswer(String answer) {
    final cleanedUser = answer.trim().toLowerCase();
    final cleanedExpected = expectedAnswer.trim().toLowerCase();
    final correct = cleanedUser == cleanedExpected;

    if (correct) {
      isCompleted = true;
      isSuccess = true;
      score = (score).clamp(0.0, 100.0);
    } else {
      score = (score - 25.0).clamp(0.0, 100.0);
    }
    return correct;
  }
}
