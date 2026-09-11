import '../models/piece.dart';

/// The status and outcome of a chess game.
enum GameStatus {
  inProgress,
  checkmate,
  stalemate,
  threefoldRepetition,
  fiftyMoveRule,
  seventyFiveMoveRule,
  insufficientMaterial,
  resignation,
  timeout,
  drawAgreed;

  bool get isGameOver => this != GameStatus.inProgress;

  bool get isDraw =>
      this == GameStatus.stalemate ||
      this == GameStatus.threefoldRepetition ||
      this == GameStatus.fiftyMoveRule ||
      this == GameStatus.seventyFiveMoveRule ||
      this == GameStatus.insufficientMaterial ||
      this == GameStatus.drawAgreed;
}

/// Details about the terminal condition of the game.
class GameResult {
  final GameStatus status;
  final PieceColor? winner;
  final String description;

  const GameResult({
    required this.status,
    this.winner,
    required this.description,
  });

  static const GameResult ongoing = GameResult(
    status: GameStatus.inProgress,
    description: 'Game in progress',
  );

  String get score {
    if (winner == PieceColor.white) return '1-0';
    if (winner == PieceColor.black) return '0-1';
    if (status.isDraw) return '1/2-1/2';
    return '*';
  }

  @override
  String toString() => '$description ($score)';
}
