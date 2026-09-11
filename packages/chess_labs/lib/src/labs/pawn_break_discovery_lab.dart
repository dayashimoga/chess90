import '../lab_session.dart';

/// Pawn play mastery lab: calculate and execute the correct pawn break (e.g. c5, f4, e5, b5).
class PawnBreakDiscoveryLab extends LabSession {
  final String thematicBreak;
  final String strategicImpact;

  PawnBreakDiscoveryLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.thematicBreak,
    required this.strategicImpact,
    required super.explanation,
    super.hints,
  }) : super(labType: 'pawn_break');
}
