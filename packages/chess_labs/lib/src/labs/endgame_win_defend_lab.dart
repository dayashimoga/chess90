import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import '../lab_session.dart';

/// Interactive endgame lab where the user must win or defend against an active chess engine.
class EndgameWinDefendLab {
  final String id;
  final String title;
  final String initialFen;
  final bool isMustWin; // true = user must win, false = user must hold draw
  final String objective;
  final ChessEngine engine;

  late Board currentBoard;
  bool isCompleted = false;
  bool isSuccess = false;
  int moveCount = 0;
  String feedback = 'Play against the engine to achieve the theoretical outcome.';

  EndgameWinDefendLab({
    required this.id,
    required this.title,
    required this.initialFen,
    required this.isMustWin,
    required this.objective,
    required this.engine,
  }) {
    currentBoard = Board.fromFen(initialFen);
  }

  /// User plays a move against the engine.
  Future<void> playUserMove(Move move) async {
    if (isCompleted) return;

    final legal = MoveGenerator.generateLegalMoves(currentBoard);
    if (!legal.contains(move)) {
      feedback = 'Illegal move: ${move.uci}';
      return;
    }

    currentBoard.makeMove(move);
    moveCount++;

    // Check game termination
    final status = MoveGenerator.getGameStatus(currentBoard);
    if (status.isGameOver) {
      _evaluateOutcome(status);
      return;
    }

    // Engine reply
    feedback = 'Engine calculating reply...';
    await engine.setPosition(currentBoard.toFen());
    final eval = await engine.evaluate(depth: 3);
    final engineMove = eval.bestMove ?? legal.first;

    currentBoard.makeMove(engineMove);

    final statusAfterEngine = MoveGenerator.getGameStatus(currentBoard);
    if (statusAfterEngine.isGameOver) {
      _evaluateOutcome(statusAfterEngine);
    } else {
      feedback = 'Engine played ${MoveGenerator.moveToSan(currentBoard, engineMove)}. Your turn!';
    }
  }

  void _evaluateOutcome(GameStatus status) {
    isCompleted = true;
    if (isMustWin) {
      if (status == GameStatus.checkmate) {
        isSuccess = true;
        feedback = 'Victory! Checkmate delivered against engine in $moveCount moves.';
      } else {
        isSuccess = false;
        feedback = 'Failed: Position resulted in a draw (${status.name}). Theoretical win lost.';
      }
    } else {
      // Must hold draw
      if (status.isDraw) {
        isSuccess = true;
        feedback = 'Success! Successfully defended and held the draw against the engine (${status.name}).';
      } else {
        isSuccess = false;
        feedback = 'Defeat: Engine broke through.';
      }
    }
  }
}
