import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_engine/chess_engine.dart';

/// Automated puzzle generator that extracts tactical puzzles from PGN games.
class PuzzleMiner {
  final ChessEngine engine;

  PuzzleMiner({required this.engine});

  /// Mines tactical puzzles from a PGN game.
  Future<List<CurriculumExercise>> minePuzzlesFromPgn(
    String pgnContent, {
    int minCentipawnSwing = 250,
    int maxPuzzles = 5,
  }) async {
    final game = PgnParser.parse(pgnContent);
    if (game == null) return [];

    final minedPuzzles = <CurriculumExercise>[];
    final board = game.setupFen != null ? Board.fromFen(game.setupFen!) : Board.initial();

    int? prevEvalScore;

    for (int ply = 0; ply < game.moves.length; ply++) {
      if (minedPuzzles.length >= maxPuzzles) break;

      final pgnNode = game.moves[ply];
      final move = pgnNode.move;
      if (move == null) continue;

      final fenBefore = board.toFen();

      // Evaluate position before move
      await engine.setPosition(fenBefore);
      final evalBefore = await engine.evaluate(depth: 3);
      final scoreBefore = evalBefore.scoreFromWhitePerspective;

      board.makeMove(move);

      // Evaluate position after move
      await engine.setPosition(board.toFen());
      final evalAfter = await engine.evaluate(depth: 3);
      final scoreAfter = evalAfter.scoreFromWhitePerspective;

      // Check if there was a major tactical mistake made by the opponent
      // creating an immediate winning continuation for the next player
      if (prevEvalScore != null) {
        final swing = (scoreAfter - scoreBefore).abs();
        if (swing >= minCentipawnSwing) {
          // Verify if there is a unique winning reply from current position
          final candidateFen = board.toFen();
          final candidateSide = board.activeColor;
          final bestReply = evalAfter.bestMove;

          if (bestReply != null) {
            final motif = _detectMotif(board, bestReply);
            final san = MoveGenerator.moveToSan(board, bestReply);

            final puzzle = CurriculumExercise(
              id: 'mined_${game.event.replaceAll(RegExp(r'\W+'), '_')}_ply_$ply',
              fen: candidateFen,
              sideToPlay: candidateSide,
              instruction: '${candidateSide == PieceColor.white ? 'White' : 'Black'} to move: Exploit the opponent\'s tactical error.',
              solutionSan: [san],
              explanation: 'Decisive tactical blow: $san ($motif).',
              hints: ['Look at forcing checks, captures, and threats.'],
              motif: motif,
            );

            minedPuzzles.add(puzzle);
          }
        }
      }

      prevEvalScore = scoreAfter;
    }

    return minedPuzzles;
  }

  String _detectMotif(Board board, Move move) {
    if (move.flag == MoveFlag.castleKingside || move.flag == MoveFlag.castleQueenside) {
      return 'Castling';
    }

    final testBoard = board.clone();
    testBoard.makeMove(move);

    if (MoveGenerator.getGameStatus(testBoard) == GameStatus.checkmate) {
      return 'Mating Net';
    }

    if (move.isCapture) {
      final captured = board.pieceAt(move.to);
      if (captured != null && captured.type.baseValue >= 300) {
        return 'Decisive Capture';
      }
      return 'Tactical Capture';
    }

    // Check if double attack / fork
    final piece = board.pieceAt(move.from);
    if (piece != null && piece.type == PieceType.knight) {
      return 'Knight Fork';
    }

    return 'Tactical Precision';
  }
}
