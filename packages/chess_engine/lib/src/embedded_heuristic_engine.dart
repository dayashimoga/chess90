import 'dart:async';
import 'package:chess_core/chess_core.dart';
import 'engine_interface.dart';

/// Deterministic pure-Dart heuristic chess engine using Minimax with Alpha-Beta pruning,
/// Quiescence search, piece-square tables, and mobility evaluation.
/// Guarantees 100% offline analysis on any platform without external dependencies.
class EmbeddedHeuristicEngine implements ChessEngine {
  Board _board = Board.initial();
  final _controller = StreamController<EngineEvaluation>.broadcast();
  bool _stopped = false;

  @override
  String get engineName => 'Embedded Heuristic Engine';

  @override
  bool get isFallback => false;

  // Piece-Square Tables (Midgame) from White's perspective (rank 0 to 7)
  static const List<int> _pawnTable = [
    0,  0,  0,  0,  0,  0,  0,  0,
    50, 50, 50, 50, 50, 50, 50, 50,
    10, 10, 20, 30, 30, 20, 10, 10,
     5,  5, 10, 25, 25, 10,  5,  5,
     0,  0,  0, 20, 20,  0,  0,  0,
     5, -5,-10,  0,  0,-10, -5,  5,
     5, 10, 10,-20,-20, 10, 10,  5,
     0,  0,  0,  0,  0,  0,  0,  0
  ];

  static const List<int> _knightTable = [
    -50,-40,-30,-30,-30,-30,-40,-50,
    -40,-20,  0,  0,  0,  0,-20,-40,
    -30,  0, 10, 15, 15, 10,  0,-30,
    -30,  5, 15, 20, 20, 15,  5,-30,
    -30,  0, 15, 20, 20, 15,  0,-30,
    -30,  5, 10, 15, 15, 10,  5,-30,
    -40,-20,  0,  5,  5,  0,-20,-40,
    -50,-40,-30,-30,-30,-30,-40,-50,
  ];

  static const List<int> _bishopTable = [
    -20,-10,-10,-10,-10,-10,-10,-20,
    -10,  0,  0,  0,  0,  0,  0,-10,
    -10,  0,  5, 10, 10,  5,  0,-10,
    -10,  5,  5, 10, 10,  5,  5,-10,
    -10,  0, 10, 10, 10, 10,  0,-10,
    -10, 10, 10, 10, 10, 10, 10,-10,
    -10,  5,  0,  0,  0,  0,  5,-10,
    -20,-10,-10,-10,-10,-10,-10,-20,
  ];

  static const List<int> _rookTable = [
     0,  0,  0,  0,  0,  0,  0,  0,
     5, 10, 10, 10, 10, 10, 10,  5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
     0,  0,  0,  5,  5,  0,  0,  0
  ];

  static const List<int> _queenTable = [
    -20,-10,-10, -5, -5,-10,-10,-20,
    -10,  0,  0,  0,  0,  0,  0,-10,
    -10,  0,  5,  5,  5,  5,  0,-10,
     -5,  0,  5,  5,  5,  5,  0, -5,
      0,  0,  5,  5,  5,  5,  0, -5,
    -10,  5,  5,  5,  5,  5,  0,-10,
    -10,  0,  5,  0,  0,  0,  0,-10,
    -20,-10,-10, -5, -5,-10,-10,-20
  ];

  static const List<int> _kingTableMidgame = [
    -30,-40,-40,-50,-50,-40,-40,-30,
    -30,-40,-40,-50,-50,-40,-40,-30,
    -30,-40,-40,-50,-50,-40,-40,-30,
    -30,-40,-40,-50,-50,-40,-40,-30,
    -20,-30,-30,-40,-40,-30,-30,-20,
    -10,-20,-20,-20,-20,-20,-20,-10,
     20, 20,  0,  0,  0,  0, 20, 20,
     20, 30, 10,  0,  0, 10, 30, 20
  ];

  @override
  Stream<EngineEvaluation> get searchStream => _controller.stream;

  @override
  Future<void> initialize() async {
    _stopped = false;
  }

  @override
  Future<void> setPosition(String fen, [List<Move> moves = const []]) async {
    _board = Board.fromFen(fen);
    for (final move in moves) {
      _board.makeMove(move);
    }
  }

  @override
  Future<void> stop() async {
    _stopped = true;
  }

  @override
  Future<void> dispose() async {
    _stopped = true;
    await _controller.close();
  }

  @override
  Future<EngineEvaluation> evaluate({int depth = 4, Duration? timeLimit}) async {
    _stopped = false;
    final stopwatch = Stopwatch()..start();
    final effectiveDepth = depth.clamp(1, 6);

    int totalNodes = 0;
    Move? overallBestMove;
    int bestScore = -999999;
    final pv = <Move>[];

    final legalMoves = MoveGenerator.generateLegalMoves(_board);
    if (legalMoves.isEmpty) {
      final isMate = MoveGenerator.isInCheck(_board);
      return EngineEvaluation(
        scoreCentipawns: isMate ? -30000 : 0,
        mateInMoves: isMate ? -1 : null,
        depth: 0,
        nodes: 1,
        bestMove: null,
        pvLine: const [],
        sideToMove: _board.activeColor,
      );
    }

    // Iterative deepening up to effectiveDepth
    for (int currentDepth = 1; currentDepth <= effectiveDepth; currentDepth++) {
      if (_stopped) break;
      if (timeLimit != null && stopwatch.elapsed >= timeLimit) break;

      int alpha = -999999;
      int beta = 999999;
      Move? depthBestMove;
      int depthBestScore = -999999;

      // Sort moves: put previously found best move first, followed by captures
      final sortedMoves = List<Move>.from(legalMoves);
      _sortMoves(sortedMoves, overallBestMove);

      for (final move in sortedMoves) {
        if (_stopped) break;

        _board.makeMove(move);
        totalNodes++;
        final score = -_alphaBeta(currentDepth - 1, -beta, -alpha, 1);
        _board.unmakeMove();

        if (score > depthBestScore) {
          depthBestScore = score;
          depthBestMove = move;
        }

        if (score > alpha) {
          alpha = score;
        }
      }

      if (!_stopped && depthBestMove != null) {
        overallBestMove = depthBestMove;
        bestScore = depthBestScore;
        pv.clear();
        pv.add(depthBestMove);

        final eval = EngineEvaluation(
          scoreCentipawns: bestScore.abs() > 25000 ? null : bestScore,
          mateInMoves: bestScore > 25000 ? (30000 - bestScore + 1) ~/ 2 : (bestScore < -25000 ? (-30000 - bestScore) ~/ 2 : null),
          depth: currentDepth,
          nodes: totalNodes,
          bestMove: overallBestMove,
          pvLine: List.unmodifiable(pv),
          sideToMove: _board.activeColor,
        );
        _controller.add(eval);
      }
    }

    return EngineEvaluation(
      scoreCentipawns: bestScore.abs() > 25000 ? null : bestScore,
      mateInMoves: bestScore > 25000 ? (30000 - bestScore + 1) ~/ 2 : (bestScore < -25000 ? (-30000 - bestScore) ~/ 2 : null),
      depth: effectiveDepth,
      nodes: totalNodes,
      bestMove: overallBestMove ?? legalMoves.first,
      pvLine: List.unmodifiable(pv),
      sideToMove: _board.activeColor,
    );
  }

  int _alphaBeta(int depth, int alpha, int beta, int ply) {
    if (_stopped) return 0;

    if (depth <= 0) {
      return _quiescence(alpha, beta);
    }

    final legalMoves = MoveGenerator.generateLegalMoves(_board);
    if (legalMoves.isEmpty) {
      if (MoveGenerator.isInCheck(_board)) {
        return -30000 + ply; // Checkmate penalty adjusted by distance
      }
      return 0; // Stalemate
    }

    _sortMoves(legalMoves, null);

    for (final move in legalMoves) {
      _board.makeMove(move);
      final score = -_alphaBeta(depth - 1, -beta, -alpha, ply + 1);
      _board.unmakeMove();

      if (score >= beta) {
        return beta; // Beta cutoff
      }
      if (score > alpha) {
        alpha = score;
      }
    }

    return alpha;
  }

  int _quiescence(int alpha, int beta) {
    final standPat = _evaluateStaticPosition();
    if (standPat >= beta) {
      return beta;
    }
    if (alpha < standPat) {
      alpha = standPat;
    }

    // Only search captures in quiescence
    final pseudoMoves = MoveGenerator.generatePseudoLegalMoves(_board);
    final captures = pseudoMoves.where((m) => m.isCapture).toList();
    _sortMoves(captures, null);

    for (final move in captures) {
      _board.makeMove(move);
      // Ensure legality
      if (MoveGenerator.isInCheck(_board, _board.activeColor.opponent)) {
        _board.unmakeMove();
        continue;
      }

      final score = -_quiescence(-beta, -alpha);
      _board.unmakeMove();

      if (score >= beta) {
        return beta;
      }
      if (score > alpha) {
        alpha = score;
      }
    }

    return alpha;
  }

  int _evaluateStaticPosition() {
    int whiteScore = 0;
    int blackScore = 0;

    for (int i = 0; i < 64; i++) {
      final piece = _board.pieceAtIndex(i);
      if (piece == null) continue;

      final sq = Square(i);
      final val = piece.type.baseValue;
      final pst = _getPstValue(piece.type, piece.color, sq);

      if (piece.color == PieceColor.white) {
        whiteScore += val + pst;
      } else {
        blackScore += val + pst;
      }
    }

    // Mobility bonus
    final currentMoves = MoveGenerator.generatePseudoLegalMoves(_board).length;
    final total = (whiteScore - blackScore);
    final sideSign = _board.activeColor == PieceColor.white ? 1 : -1;
    return (total * sideSign) + (currentMoves * 2);
  }

  int _getPstValue(PieceType type, PieceColor color, Square square) {
    // Piece-Square table mapping: invert rank for Black
    final index = color == PieceColor.white ? (7 - square.rank) * 8 + square.file : square.rank * 8 + square.file;

    switch (type) {
      case PieceType.pawn:
        return _pawnTable[index];
      case PieceType.knight:
        return _knightTable[index];
      case PieceType.bishop:
        return _bishopTable[index];
      case PieceType.rook:
        return _rookTable[index];
      case PieceType.queen:
        return _queenTable[index];
      case PieceType.king:
        return _kingTableMidgame[index];
    }
  }

  void _sortMoves(List<Move> moves, Move? priorityMove) {
    moves.sort((a, b) {
      if (a == priorityMove) return -1;
      if (b == priorityMove) return 1;

      // Prioritize captures (MVV-LVA)
      if (a.isCapture && !b.isCapture) return -1;
      if (!a.isCapture && b.isCapture) return 1;

      // Promotions
      if (a.isPromotion && !b.isPromotion) return -1;
      if (!a.isPromotion && b.isPromotion) return 1;

      return 0;
    });
  }
}
