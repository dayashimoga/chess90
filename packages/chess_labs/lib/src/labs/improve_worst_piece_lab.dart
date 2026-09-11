import 'package:chess_core/chess_core.dart';
import '../lab_session.dart';

/// Positional mastery lab: identify and maneuver the least active piece to an optimal outpost.
class ImproveWorstPieceLab extends LabSession {
  final Square worstPieceSquare;
  final Square targetOptimalSquare;

  ImproveWorstPieceLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.worstPieceSquare,
    required this.targetOptimalSquare,
    required super.explanation,
    super.hints,
  }) : super(labType: 'improve_worst_piece');
}
