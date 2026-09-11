import '../lab_session.dart';

/// Advantage conversion lab.
/// Requires converting a material or positional advantage (extra pawn, exchange up, passed pawn)
/// into a technical win against an active defensive engine.
class ConversionChallengeLab extends LabSession {
  final String advantageType;
  final String conversionTechnique;

  ConversionChallengeLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.advantageType,
    required this.conversionTechnique,
    required super.explanation,
    super.hints,
  }) : super(labType: 'conversion_defense');
}
