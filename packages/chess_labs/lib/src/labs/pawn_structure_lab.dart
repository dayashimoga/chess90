import '../lab_session.dart';

/// Deep pawn structure lab: IQP, Carlsbad, Hedgehog, Maroczy Bind, hanging pawns.
class PawnStructureLab extends LabSession {
  final String structureName;
  final String typicalWhitePlan;
  final String typicalBlackPlan;

  PawnStructureLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.structureName,
    required this.typicalWhitePlan,
    required this.typicalBlackPlan,
    required super.explanation,
    super.hints,
  }) : super(labType: 'pawn_structure');
}
