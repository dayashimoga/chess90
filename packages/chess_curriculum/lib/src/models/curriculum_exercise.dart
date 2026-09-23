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
  final String? hintConcept; // H1: General concept / board region
  final String? hintPiece;   // H2: Candidate piece or active tactical idea
  final String? hintForcing; // H3: Forcing tactical clue or square
  final String? refutationAnalysis; // Explanation of why tempting candidate alternatives fail

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
    this.hintConcept,
    this.hintPiece,
    this.hintForcing,
    this.refutationAnalysis,
  });

  String get concept => hintConcept ?? (hints.isNotEmpty ? hints[0] : 'Tactical Calculation');
  String get targetPiece => hintPiece ?? 'active piece';

  /// Resolves the 3 tiered hints (H1 concept, H2 piece, H3 forcing).
  List<String> get tieredHints {
    final list = <String>[];
    if (hintConcept != null && hintConcept!.isNotEmpty) {
      list.add(hintConcept!);
    } else if (hints.isNotEmpty) {
      list.add(hints[0]);
    } else {
      list.add('Observe the active imbalances, piece alignments, and king safety.');
    }

    if (hintPiece != null && hintPiece!.isNotEmpty) {
      list.add(hintPiece!);
    } else if (hints.length > 1) {
      list.add(hints[1]);
    } else {
      list.add('Identify which piece can initiate a forcing check, capture, or threat.');
    }

    if (hintForcing != null && hintForcing!.isNotEmpty) {
      list.add(hintForcing!);
    } else if (hints.length > 2) {
      list.add(hints[2]);
    } else if (solutionSan.isNotEmpty) {
      list.add('Focus on the forcing continuation beginning with ${solutionSan.first.substring(0, 1)}...');
    }

    return list;
  }

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
        'hintConcept': hintConcept,
        'hintPiece': hintPiece,
        'hintForcing': hintForcing,
        'refutationAnalysis': refutationAnalysis,
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
      hintConcept: json['hintConcept'] as String?,
      hintPiece: json['hintPiece'] as String?,
      hintForcing: json['hintForcing'] as String?,
      refutationAnalysis: json['refutationAnalysis'] as String?,
    );
  }
}

