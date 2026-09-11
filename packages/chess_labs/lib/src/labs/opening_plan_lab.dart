import '../lab_session.dart';

/// Opening repertoire and plans lab: White system, Black vs e4, Black vs d4/c4/Nf3.
class OpeningPlanLab extends LabSession {
  final String openingName;
  final String ecoCode;
  final String typicalPawnStructure;
  final List<String> strategicPlans;

  OpeningPlanLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.openingName,
    required this.ecoCode,
    required this.typicalPawnStructure,
    required this.strategicPlans,
    required super.explanation,
    super.hints,
  }) : super(labType: 'opening_plans');
}
