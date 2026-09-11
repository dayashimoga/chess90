import '../lab_session.dart';

/// Time management and practical tournament decision simulator.
/// Tests making accurate moves with limited clock budgets (e.g. 15-30s per move).
class TimeManagementLab extends LabSession {
  final Duration timeLimitPerMove;
  final String practicalAdvice;

  TimeManagementLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    this.timeLimitPerMove = const Duration(seconds: 20),
    required this.practicalAdvice,
    required super.explanation,
    super.hints,
  }) : super(labType: 'time_management');
}
