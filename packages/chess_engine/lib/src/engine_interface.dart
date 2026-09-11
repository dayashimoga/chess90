import 'dart:math' as math;
import 'package:chess_core/chess_core.dart';

/// Calibrated Win-Draw-Loss statistics from Stockfish evaluation.
class EngineWdl {
  final int winPerMille;
  final int drawPerMille;
  final int lossPerMille;

  const EngineWdl({
    required this.winPerMille,
    required this.drawPerMille,
    required this.lossPerMille,
  });

  double get winProbability => winPerMille / 1000.0;
  double get drawProbability => drawPerMille / 1000.0;
  double get lossProbability => lossPerMille / 1000.0;

  Map<String, dynamic> toJson() => {
        'win': winPerMille,
        'draw': drawPerMille,
        'loss': lossPerMille,
      };

  @override
  String toString() => 'WDL($winPerMille/$drawPerMille/$lossPerMille)';
}

/// Represents an evaluation snapshot from an engine search.
class EngineEvaluation {
  final int? scoreCentipawns;
  final int? mateInMoves;
  final int depth;
  final int nodes;
  final Move? bestMove;
  final List<Move> pvLine;
  final PieceColor sideToMove;
  final EngineWdl? wdl;

  const EngineEvaluation({
    this.scoreCentipawns,
    this.mateInMoves,
    required this.depth,
    this.nodes = 0,
    this.bestMove,
    this.pvLine = const [],
    required this.sideToMove,
    this.wdl,
  });

  /// Evaluates relative to White (positive is good for White, negative for Black)
  int get scoreFromWhitePerspective {
    if (mateInMoves != null) {
      return (mateInMoves! > 0 ? 30000 : -30000) * (sideToMove == PieceColor.white ? 1 : -1);
    }
    final cp = scoreCentipawns ?? 0;
    return sideToMove == PieceColor.white ? cp : -cp;
  }

  /// Formatted score string (e.g. "+1.45", "-0.80", "#2", "#-1")
  String get formattedScore {
    if (mateInMoves != null) {
      return mateInMoves! > 0 ? '#+$mateInMoves' : '#$mateInMoves';
    }
    final cp = scoreCentipawns ?? 0;
    final pawns = (cp / 100.0).toStringAsFixed(2);
    return cp > 0 ? '+$pawns' : pawns;
  }

  /// Winning probability according to standard calibrated Elo logistic model or Stockfish WDL
  double get whiteWinProbability {
    if (wdl != null) {
      final p = sideToMove == PieceColor.white ? wdl!.winProbability : wdl!.lossProbability;
      final draw = wdl!.drawProbability;
      return (p + 0.5 * draw).clamp(0.0, 1.0);
    }
    if (mateInMoves != null) {
      return (mateInMoves! > 0 ? (sideToMove == PieceColor.white ? 1.0 : 0.0) : (sideToMove == PieceColor.white ? 0.0 : 1.0));
    }
    final cp = scoreFromWhitePerspective;
    return 1.0 / (1.0 + math.pow(10.0, -cp / 400.0));
  }

  /// Explicit label describing whether the probability is calibrated WDL or heuristic Elo
  String get probabilityModelLabel => wdl != null ? 'Stockfish Calibrated WDL' : 'Calibrated Logistic Elo (Heuristic)';

  @override
  String toString() => 'Evaluation(depth: $depth, score: $formattedScore, best: $bestMove)';
}

/// Abstract interface for chess engines (native Stockfish, WASM Stockfish, or built-in engine).
abstract class ChessEngine {
  /// User-facing display name of the engine (e.g. 'Stockfish 19' or 'Embedded Heuristic Engine').
  String get engineName;

  /// True if currently operating under a fallback mode.
  bool get isFallback;

  /// Initializes the engine.
  Future<void> initialize();

  /// Sets position from FEN and optional move history.
  Future<void> setPosition(String fen, [List<Move> moves = const []]);

  /// Analyzes the current position up to given depth or time limit.
  Future<EngineEvaluation> evaluate({int depth = 10, Duration? timeLimit});

  /// Returns stream of progressive evaluations during search.
  Stream<EngineEvaluation> get searchStream;

  /// Stops ongoing calculation.
  Future<void> stop();

  /// Disposes of engine resources.
  Future<void> dispose();
}
