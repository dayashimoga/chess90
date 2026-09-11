import '../lab_session.dart';

/// Defensive resource and swindle lab.
/// Teaches finding stalemates, perpetual checks, counter-sacrifices, and king escapes under heavy attack.
class DefensiveResourceLab extends LabSession {
  final String threatDescription;
  final String defensiveResourceTheme;

  DefensiveResourceLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.threatDescription,
    required this.defensiveResourceTheme,
    required super.explanation,
    super.hints,
  }) : super(labType: 'defensive_resource');
}
