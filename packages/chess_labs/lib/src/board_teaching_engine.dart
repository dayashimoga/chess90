import 'dart:async';
import 'package:chess_core/chess_core.dart';

/// Semantic overlay classification for active board teaching.
enum TeachingOverlayType {
  attackVector,
  defendedPiece,
  loosePiece,
  escapeSquare,
  candidateMove,
  refutationTarget,
  weakSquare,
}

/// Highlight overlay on an individual square.
class TeachingHighlight {
  final Square square;
  final String colorHex;
  final String? label;
  final TeachingOverlayType type;

  const TeachingHighlight({
    required this.square,
    required this.colorHex,
    this.label,
    this.type = TeachingOverlayType.candidateMove,
  });
}

/// Dynamic graphical arrow vector across squares.
class TeachingArrow {
  final Square from;
  final Square to;
  final String colorHex;

  const TeachingArrow({
    required this.from,
    required this.to,
    this.colorHex = '#22C55E', // Green default
  });
}

/// Candidate move comparative evaluation.
class CandidateEvaluation {
  final String san;
  final Move move;
  final bool isBest;
  final int scoreCentipawns;
  final String? refutationSan;
  final String explanation;

  const CandidateEvaluation({
    required this.san,
    required this.move,
    required this.isBest,
    this.scoreCentipawns = 0,
    this.refutationSan,
    required this.explanation,
  });
}

/// The 11 active teaching phases of the Grandmaster soco-pedagogical loop:
/// EXPLAIN → SHOW → INTERACT → PREDICT → TRY → FEEDBACK → RETRY → PRACTICE → APPLY → REVIEW → RETENTION.
enum TeachingPhase {
  explain('Explain Concept', 'The Socratic coach introduces the key imbalance and geometric pattern.'),
  show('Show Demonstration', 'Observe the master execution with animated arrows and piece trajectories.'),
  interact('Interact with Board', 'Tap attacked squares, identify targets, or highlight loose pieces.'),
  predict('Predict Opponent Reply', 'Anticipate the opponent\'s most stubborn defensive attempt.'),
  tryMove('Try Candidate Move', 'Choose and play the decisive candidate move on the live board.'),
  feedback('Pedagogical Feedback', 'Detailed cognitive breakdown of why the move succeeds or fails.'),
  retry('Refutation & Retry', 'Observe the opponent\'s refutation, rewind, and re-attempt.'),
  practice('Independent Practice', 'Solve a related master position with zero visual assistance.'),
  apply('Apply in Mini-Game', 'Test skills in an interactive multi-round thematic mini-game.'),
  review('Spaced Review', 'Cognitive takeaways, common amateur blunders, and memory rules.'),
  retention('Retention Certification', 'Execute the canonical move from memory on a fresh board.');

  final String title;
  final String description;
  const TeachingPhase(this.title, this.description);
}

/// Professional teaching engine driving Socratic board interactions, visual overlays,
/// candidate comparison, and automated refutation playback.
class BoardTeachingEngine {
  final Board initialBoard;
  late Board currentBoard;
  final PieceColor sideToPlay;
  final String conceptTitle;
  final String coreExplanation;
  final List<String> solutionSan;
  final List<CandidateEvaluation> candidates;

  TeachingPhase currentPhase = TeachingPhase.explain;
  final List<TeachingHighlight> highlights = [];
  final List<TeachingArrow> arrows = [];
  final Map<Square, Piece> ghostPieces = {};
  final List<Move> moveHistory = [];

  String feedbackText = '';
  bool isWrongMoveShowingRefutation = false;
  Move? pendingRefutationMove;

  final _updateController = StreamController<BoardTeachingEngine>.broadcast();

  BoardTeachingEngine({
    required this.initialBoard,
    required this.sideToPlay,
    required this.conceptTitle,
    required this.coreExplanation,
    required this.solutionSan,
    this.candidates = const [],
  }) {
    reset();
  }

  Stream<BoardTeachingEngine> get onUpdate => _updateController.stream;

  void reset() {
    currentBoard = initialBoard.clone();
    highlights.clear();
    arrows.clear();
    ghostPieces.clear();
    moveHistory.clear();
    currentPhase = TeachingPhase.explain;
    feedbackText = '$conceptTitle: $coreExplanation';
    isWrongMoveShowingRefutation = false;
    pendingRefutationMove = null;
    _buildInitialOverlays();
    _notify();
  }

  void _buildInitialOverlays() {
    if (solutionSan.isNotEmpty) {
      final bestMove = MoveGenerator.sanToMove(currentBoard, solutionSan.first);
      if (bestMove != null) {
        arrows.add(TeachingArrow(from: bestMove.from, to: bestMove.to, colorHex: '#22C55E'));
        highlights.add(TeachingHighlight(
          square: bestMove.from,
          colorHex: '#3B82F6',
          type: TeachingOverlayType.candidateMove,
        ));
      }
    }
  }

  /// Sets the active pedagogical phase.
  void setPhase(TeachingPhase phase) {
    currentPhase = phase;
    highlights.clear();
    arrows.clear();
    ghostPieces.clear();

    switch (phase) {
      case TeachingPhase.explain:
        _buildInitialOverlays();
        feedbackText = '$conceptTitle: $coreExplanation';
        break;
      case TeachingPhase.show:
        _animateDemo();
        break;
      case TeachingPhase.interact:
        _setupInteractiveDiscovery();
        break;
      case TeachingPhase.predict:
        feedbackText = 'Predict Opponent: What is Black/White\'s most dangerous defensive resource?';
        break;
      case TeachingPhase.tryMove:
        feedbackText = 'Your Turn: Play the winning move on the board.';
        break;
      case TeachingPhase.feedback:
        break;
      case TeachingPhase.retry:
        feedbackText = 'Refutation visualized. Rewinding board... Find the better candidate!';
        break;
      case TeachingPhase.practice:
        feedbackText = 'Practice Mode: Find the decisive move independently.';
        break;
      case TeachingPhase.apply:
        feedbackText = 'Mini-Game: Complete the thematic drill to solidify your pattern recognition.';
        break;
      case TeachingPhase.review:
        feedbackText = 'Review: Remember CCT (Checks, Captures, Threats) on every ply.';
        break;
      case TeachingPhase.retention:
        feedbackText = 'Retention: Play the winning move from memory.';
        break;
    }
    _notify();
  }

  void _animateDemo() {
    if (solutionSan.isNotEmpty) {
      final m = MoveGenerator.sanToMove(initialBoard, solutionSan.first);
      if (m != null) {
        arrows.add(TeachingArrow(from: m.from, to: m.to, colorHex: '#EAB308'));
        final piece = initialBoard.pieceAt(m.from);
        if (piece != null) {
          ghostPieces[m.to] = piece;
        }
        feedbackText = 'Grandmaster Model: $conceptTitle execution via ${solutionSan.first}.';
      }
    }
  }

  void _setupInteractiveDiscovery() {
    // Highlight LPDO (loose pieces) or target king
    final enemyColor = sideToPlay == PieceColor.white ? PieceColor.black : PieceColor.white;
    for (int i = 0; i < 64; i++) {
      final sq = Square(i);
      final p = currentBoard.pieceAt(sq);
      if (p != null && p.color == enemyColor) {
        if (p.type == PieceType.king) {
          highlights.add(TeachingHighlight(square: sq, colorHex: '#EF4444', type: TeachingOverlayType.attackVector));
        } else if (p.type == PieceType.queen) {
          highlights.add(TeachingHighlight(square: sq, colorHex: '#F59E0B', type: TeachingOverlayType.loosePiece));
        }
      }
    }
    feedbackText = 'Tap the identified weakness on the board to confirm your tactical vision.';
  }

  /// Highlight square with specific semantic coloring.
  void highlightSquare(Square square, {String colorHex = '#3B82F6', String? label}) {
    highlights.add(TeachingHighlight(square: square, colorHex: colorHex, label: label));
    _notify();
  }

  /// Display attack and defense rays from a piece.
  void showRaysFrom(Square square) {
    arrows.clear();
    final legals = MoveGenerator.generateLegalMoves(currentBoard).where((m) => m.from == square);
    for (final m in legals) {
      arrows.add(TeachingArrow(from: m.from, to: m.to, colorHex: '#3B82F6'));
    }
    _notify();
  }

  /// Calculates king escape squares when in check.
  void showEscapeSquares(PieceColor kingColor) {
    Square? kingSq;
    for (int i = 0; i < 64; i++) {
      final sq = Square(i);
      final p = currentBoard.pieceAt(sq);
      if (p != null && p.type == PieceType.king && p.color == kingColor) {
        kingSq = sq;
        break;
      }
    }
    if (kingSq == null) return;

    final legals = MoveGenerator.generateLegalMoves(currentBoard).where((m) => m.from == kingSq);
    for (final m in legals) {
      highlights.add(TeachingHighlight(
        square: m.to,
        colorHex: '#10B981',
        type: TeachingOverlayType.escapeSquare,
        label: 'Escape',
      ));
    }
    _notify();
  }

  /// Handles a user-played move.
  /// If correct: advances and provides pedagogical praise.
  /// If incorrect: visualizes refutation, explains why, rewinds, and guides to retry.
  bool submitMove(Move move) {
    final legals = MoveGenerator.generateLegalMoves(currentBoard);
    if (!legals.contains(move)) {
      feedbackText = 'Illegal move: ${move.uci}. Try a valid candidate.';
      _notify();
      return false;
    }

    final playedSan = MoveGenerator.moveToSan(currentBoard, move);

    // Check if matches solution
    if (solutionSan.isNotEmpty && _compareSan(playedSan, solutionSan.first)) {
      currentBoard.makeMove(move);
      moveHistory.add(move);
      highlights.clear();
      arrows.clear();
      ghostPieces.clear();
      feedbackText = 'Brilliant! $playedSan is correct! $coreExplanation';
      currentPhase = TeachingPhase.feedback;
      _notify();
      return true;
    }

    // Move is incorrect: find matching candidate refutation
    CandidateEvaluation? eval;
    for (final c in candidates) {
      if (_compareSan(c.san, playedSan)) {
        eval = c;
        break;
      }
    }

    // Execute refutation loop
    currentBoard.makeMove(move);
    moveHistory.add(move);
    isWrongMoveShowingRefutation = true;

    highlights.clear();
    arrows.clear();
    highlights.add(TeachingHighlight(square: move.to, colorHex: '#EF4444', label: 'Flawed'));

    final refutation = eval?.refutationSan;
    if (refutation != null) {
      final refMove = MoveGenerator.sanToMove(currentBoard, refutation);
      if (refMove != null) {
        arrows.add(TeachingArrow(from: refMove.from, to: refMove.to, colorHex: '#EF4444'));
        feedbackText = 'Move $playedSan fails! Opponent refutes with $refutation. ${eval?.explanation ?? ""}';
      } else {
        feedbackText = 'Move $playedSan is not best. ${eval?.explanation ?? "Opponent neutralizes your threat."}';
      }
    } else {
      feedbackText = 'Move $playedSan fails to exploit the core motif. Re-evaluate CCT (Checks, Captures, Threats).';
    }

    _notify();

    // Auto-rewind after 2.5 seconds to enforce retry
    Timer(const Duration(milliseconds: 2500), () {
      rewind();
    });

    return false;
  }

  /// Rewinds the board to the start position for a clean retry.
  void rewind() {
    currentBoard = initialBoard.clone();
    moveHistory.clear();
    isWrongMoveShowingRefutation = false;
    highlights.clear();
    arrows.clear();
    ghostPieces.clear();
    feedbackText = 'Board rewound. Consider: What was the primary piece defending the target? Try again!';
    currentPhase = TeachingPhase.tryMove;
    _notify();
  }

  bool _compareSan(String a, String b) {
    final cleanA = a.replaceAll(RegExp(r'[+#?!]'), '');
    final cleanB = b.replaceAll(RegExp(r'[+#?!]'), '');
    return cleanA == cleanB;
  }

  void _notify() {
    if (!_updateController.isClosed) {
      _updateController.add(this);
    }
  }

  void dispose() {
    _updateController.close();
  }
}
