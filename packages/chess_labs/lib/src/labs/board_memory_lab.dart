import 'package:chess_core/chess_core.dart';
import '../lab_session.dart';

/// Interactive board memory and visualization lab.
/// Tests Grandmaster-style visual chunking and board memory.
/// Position is shown for previewDurationSeconds, then hidden;
/// the user reconstructs the piece placements on a blank canvas.
class BoardMemoryLab extends LabSession {
  final int previewDurationSeconds;

  BoardMemoryLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    this.previewDurationSeconds = 8,
    required super.explanation,
    super.hints,
  }) : super(labType: 'board_memory');

  /// Compares user's reconstructed board against the target FEN and returns accuracy (0.0 to 1.0).
  double evaluatePlacement(Board reconstructedBoard) {
    final target = Board.fromFen(initialFen);
    int correctSquares = 0;

    for (int i = 0; i < 64; i++) {
      final targetPiece = target.pieceAtIndex(i);
      final placedPiece = reconstructedBoard.pieceAtIndex(i);

      if (targetPiece == null && placedPiece == null) {
        correctSquares++;
      } else if (targetPiece != null && placedPiece != null &&
          targetPiece.type == placedPiece.type &&
          targetPiece.color == placedPiece.color) {
        correctSquares++;
      }
    }

    final accuracy = correctSquares / 64.0;
    score = (accuracy * 100.0).clamp(0.0, 100.0);
    isCompleted = true;
    isSuccess = accuracy >= 0.85; // 85% threshold for passing
    return accuracy;
  }
}
