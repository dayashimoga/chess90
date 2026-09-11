import 'package:chess_core/chess_core.dart';
import '../lab_session.dart';

/// Calculation lab requiring candidate move identification before execution.
class CandidateSelectionLab extends LabSession {
  final List<String> viableCandidates;

  CandidateSelectionLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.viableCandidates,
    super.hints,
    required super.explanation,
  }) : super(
          labType: 'candidate_selection',
        );

  bool isViableCandidate(Move move) {
    final san = MoveGenerator.moveToSan(currentBoard, move);
    return viableCandidates.any((c) => c.replaceAll(RegExp(r'[+#?!]'), '') == san.replaceAll(RegExp(r'[+#?!]'), ''));
  }
}
