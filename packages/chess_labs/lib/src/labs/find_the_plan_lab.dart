import '../lab_session.dart';

/// Positional planning and strategy lab.
/// Requires the user to analyze strategic imbalances and choose the correct Grandmaster plan.
class FindThePlanLab extends LabSession {
  final List<String> candidatePlans;
  final int correctPlanIndex;
  final String planRationale;

  FindThePlanLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.candidatePlans,
    required this.correctPlanIndex,
    required this.planRationale,
    required super.explanation,
    super.hints,
  }) : super(labType: 'find_the_plan');

  bool selectPlan(int index) {
    if (index == correctPlanIndex) {
      isSuccess = true;
      return true;
    } else {
      score = (score - 25.0).clamp(0.0, 100.0);
      return false;
    }
  }
}
