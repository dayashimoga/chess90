import 'package:chess_core/chess_core.dart';

/// A concrete interactive exercise inside a curriculum day.
class CurriculumExercise {
  final String id;
  final String fen;
  final PieceColor sideToPlay;
  final String instruction;
  final List<String> solutionSan;
  final String explanation;
  final List<String> hints;
  final double penaltyPerHint;
  final String motif;
  final bool isNoTacticPosition;

  const CurriculumExercise({
    required this.id,
    required this.fen,
    required this.sideToPlay,
    required this.instruction,
    required this.solutionSan,
    required this.explanation,
    this.hints = const [],
    this.penaltyPerHint = 0.20,
    required this.motif,
    this.isNoTacticPosition = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fen': fen,
        'sideToPlay': sideToPlay.name,
        'instruction': instruction,
        'solutionSan': solutionSan,
        'explanation': explanation,
        'hints': hints,
        'penaltyPerHint': penaltyPerHint,
        'motif': motif,
        'isNoTacticPosition': isNoTacticPosition,
      };

  factory CurriculumExercise.fromJson(Map<String, dynamic> json) {
    return CurriculumExercise(
      id: json['id'] as String,
      fen: json['fen'] as String,
      sideToPlay: PieceColor.values.firstWhere((c) => c.name == json['sideToPlay']),
      instruction: json['instruction'] as String,
      solutionSan: (json['solutionSan'] as List<dynamic>).cast<String>(),
      explanation: json['explanation'] as String,
      hints: (json['hints'] as List<dynamic>?)?.cast<String>() ?? [],
      penaltyPerHint: (json['penaltyPerHint'] as num?)?.toDouble() ?? 0.20,
      motif: json['motif'] as String,
      isNoTacticPosition: json['isNoTacticPosition'] as bool? ?? false,
    );
  }
}
