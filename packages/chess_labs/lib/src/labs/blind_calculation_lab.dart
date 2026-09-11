import 'package:chess_core/chess_core.dart';
import '../lab_session.dart';

/// Blind calculation lab: moves are fed in text notation without updating the board visual.
/// The user must visualize the resulting position and enter the final winning move or static evaluation.
class BlindCalculationLab extends LabSession {
  final List<String> blindMoves;
  late Board visualizedBoard;

  BlindCalculationLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required this.blindMoves,
    required super.solutionSan,
    super.hints,
    required super.explanation,
  }) : super(
          labType: 'blind_calculation',
        ) {
    visualizedBoard = Board.fromFen(initialFen);
    // Apply blind moves to internal board state
    for (final san in blindMoves) {
      final move = MoveGenerator.sanToMove(visualizedBoard, san);
      if (move != null) visualizedBoard.makeMove(move);
    }
  }
}
