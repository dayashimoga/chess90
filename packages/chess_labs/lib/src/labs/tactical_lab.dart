import '../lab_session.dart';

/// Tactical recognition and execution lab.
class TacticalLab extends LabSession {
  final String motif;

  TacticalLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    super.hints,
    required super.explanation,
    required this.motif,
    super.isNoTacticPosition,
  }) : super(
          labType: 'tactical_recognition',
        );
}
