import 'dart:async';
import 'package:chess_core/chess_core.dart';

/// Represents the status of a user's action in an interactive lab.
enum LabStepResult {
  correct,
  incorrect,
  completed,
  opponentPlayed,
  noTacticCorrect,
  noTacticIncorrect,
}

/// Available educational interaction modes in the laboratory.
enum LabMode {
  demo('Demo Mode (Observe GM Execution)'),
  guided('Guided Mode (Targeted Visual Clues)'),
  practice('Independent Practice'),
  challenge('Timed Tournament Challenge'),
  review('Post-Session Forensic Review');

  final String label;
  const LabMode(this.label);
}

/// Generic interactive lab controller supporting variations, progressive hints,
/// retry, auto-reply, and penalty scoring.
class LabSession {
  final String id;
  final String title;
  final String labType;
  final String initialFen;
  final List<String> solutionSan;
  final List<String> hints;
  final String? hintConcept;
  final String? hintPiece;
  final String? hintForcing;
  final String? refutationAnalysis;
  final String explanation;
  final bool isNoTacticPosition;

  late Board currentBoard;
  final List<Move> userMoveHistory = [];
  int currentSolutionIndex = 0;
  int hintsRevealed = 0;
  double score = 100.0;
  bool isCompleted = false;
  bool isSuccess = false;
  String? feedbackMessage;
  LabMode mode = LabMode.practice;

  final _updateController = StreamController<LabSession>.broadcast();

  LabSession({
    required this.id,
    required this.title,
    required this.labType,
    required this.initialFen,
    required this.solutionSan,
    this.hints = const [],
    this.hintConcept,
    this.hintPiece,
    this.hintForcing,
    this.refutationAnalysis,
    required this.explanation,
    this.isNoTacticPosition = false,
    this.mode = LabMode.practice,
  }) {
    reset();
  }

  Stream<LabSession> get onUpdate => _updateController.stream;

  bool get isNoTacticActionVisible => isNoTacticPosition;

  /// Returns the next legal Move object expected by the solution.
  Move? get nextSolutionMove {
    if (currentSolutionIndex >= solutionSan.length) return null;
    return MoveGenerator.sanToMove(currentBoard, solutionSan[currentSolutionIndex]);
  }

  /// The square of the active piece in the current solution step.
  Square? get candidatePieceSquare => nextSolutionMove?.from;

  /// The destination square in the current solution step.
  Square? get candidateTargetSquare => nextSolutionMove?.to;

  void setMode(LabMode newMode) {
    mode = newMode;
    if (newMode == LabMode.demo) {
      showLine();
    } else {
      reset();
    }
  }

  List<String> get tieredHints {
    final list = <String>[];
    if (hintConcept != null && hintConcept!.isNotEmpty) {
      list.add(hintConcept!);
    }
    if (hintPiece != null && hintPiece!.isNotEmpty) {
      list.add(hintPiece!);
    }
    if (hintForcing != null && hintForcing!.isNotEmpty) {
      list.add(hintForcing!);
    }

    if (list.isNotEmpty) {
      return list;
    }

    if (hints.isNotEmpty) {
      return hints;
    }

    final dynamicHints = <String>[];
    if (solutionSan.isNotEmpty) {
      final nextSan = solutionSan[currentSolutionIndex < solutionSan.length ? currentSolutionIndex : 0];
      if (nextSan.contains('#')) {
        dynamicHints.add('Look for an immediate mating net against the vulnerable king.');
      } else if (nextSan.contains('+')) {
        dynamicHints.add('A forcing check disrupts the opponent defensive alignment.');
      } else if (nextSan.contains('x')) {
        dynamicHints.add('Capture: Identify undefended or underdefended pieces (LPDO).');
      } else {
        dynamicHints.add('Look for candidate moves that improve piece activity or create concrete threats.');
      }
    }

    final nextMove = nextSolutionMove;
    if (nextMove != null) {
      final piece = currentBoard.pieceAt(nextMove.from);
      dynamicHints.add('Candidate Piece: Focus on your ${piece?.type.name.toUpperCase() ?? "piece"} located on ${nextMove.from.name}.');
      dynamicHints.add('Forcing Clue: Direct your move towards the critical square ${nextMove.to.name}.');
    }

    return dynamicHints.isNotEmpty ? dynamicHints : ['Scan checks, captures, and threats (CCT).'];
  }

  void reset() {
    currentBoard = Board.fromFen(initialFen);
    userMoveHistory.clear();
    currentSolutionIndex = 0;
    hintsRevealed = 0;
    score = 100.0;
    isCompleted = false;
    isSuccess = false;
    feedbackMessage = 'Your turn: Select the best move.';
    _notify();
  }

  /// Retries the exercise from the beginning with a clean state and no penalty.
  void retry() {
    reset();
  }

  /// Request next progressive hint (deducts 20% penalty per hint in legacy mode).
  String? requestHint() {
    return requestTieredHint(penalize: true);
  }

  /// Request next tiered hint (Concept -> Piece -> Forcing move). Free in learning/practice mode when penalize is false.
  String? requestTieredHint({bool penalize = false}) {
    final availableHints = tieredHints;
    if (hintsRevealed < availableHints.length) {
      final hint = availableHints[hintsRevealed];
      hintsRevealed++;
      if (penalize) {
        score = (score - 20.0).clamp(0.0, 100.0);
      }
      final tierName = hintsRevealed == 1
          ? 'H1 Concept'
          : hintsRevealed == 2
              ? 'H2 Candidate Piece'
              : 'H3 Forcing Clue';
      feedbackMessage = '$tierName: $hint';
      _notify();
      return hint;
    }
    return null;
  }

  /// Reveals and automatically executes the next best move from verified solution tree.
  String? showBestMove({bool penalize = false}) {
    if (isCompleted || currentSolutionIndex >= solutionSan.length) return null;
    if (penalize) {
      score = (score - 30.0).clamp(0.0, 100.0);
    }
    final nextSan = solutionSan[currentSolutionIndex];
    final move = MoveGenerator.sanToMove(currentBoard, nextSan);
    if (move != null) {
      playMove(move);
      feedbackMessage = 'Best Move: $nextSan played. Continuation: $explanation';
      _notify();
      return nextSan;
    }
    return null;
  }

  /// Reveals the complete continuation line and completes the exercise for review.
  List<String> showLine() {
    final movesPlayed = <String>[];
    while (!isCompleted && currentSolutionIndex < solutionSan.length) {
      final nextSan = solutionSan[currentSolutionIndex];
      final move = MoveGenerator.sanToMove(currentBoard, nextSan);
      if (move != null) {
        playMove(move);
        movesPlayed.add(nextSan);
      } else {
        break;
      }
    }
    isCompleted = true;
    isSuccess = true;
    feedbackMessage = 'Verified Solution: ${solutionSan.join(' ')}\n$explanation';
    _notify();
    return movesPlayed;
  }

  /// Returns thorough explanation and refutation analysis.
  String explainWhy() {
    final sb = StringBuffer(explanation);
    if (refutationAnalysis != null && refutationAnalysis!.isNotEmpty) {
      sb.writeln('\nRefutation: $refutationAnalysis');
    }
    return sb.toString();
  }

  /// User action for declaring "No tactic exists in this position"
  LabStepResult declareNoTactic() {
    if (isCompleted) return isSuccess ? LabStepResult.completed : LabStepResult.incorrect;

    if (isNoTacticPosition) {
      isCompleted = true;
      isSuccess = true;
      feedbackMessage = 'Excellent! You correctly recognized that no tactic exists here. Solid play required.';
      _notify();
      return LabStepResult.noTacticCorrect;
    } else {
      score = (score - 30.0).clamp(0.0, 100.0);
      feedbackMessage = 'Incorrect: A concrete tactical combination exists in this position!';
      _notify();
      return LabStepResult.noTacticIncorrect;
    }
  }

  /// User plays a move on the board.
  LabStepResult playMove(Move move) {
    if (isCompleted) return isSuccess ? LabStepResult.completed : LabStepResult.incorrect;

    // Check legal move
    final legalMoves = MoveGenerator.generateLegalMoves(currentBoard);
    if (!legalMoves.contains(move)) {
      feedbackMessage = 'Illegal move: ${move.uci}';
      _notify();
      return LabStepResult.incorrect;
    }

    final playedSan = MoveGenerator.moveToSan(currentBoard, move);

    // Verify against solution line
    if (currentSolutionIndex < solutionSan.length) {
      final expectedSan = solutionSan[currentSolutionIndex];
      final matches = _compareSan(playedSan, expectedSan);

      if (matches) {
        currentBoard.makeMove(move);
        userMoveHistory.add(move);
        currentSolutionIndex++;

        // If that was the final move in solution
        if (currentSolutionIndex >= solutionSan.length) {
          isCompleted = true;
          isSuccess = true;
          feedbackMessage = 'Exercise complete! $explanation';
          _notify();
          return LabStepResult.completed;
        }

        // Auto-play opponent response if exists in solution
        final opponentSan = solutionSan[currentSolutionIndex];
        final opponentMove = MoveGenerator.sanToMove(currentBoard, opponentSan);
        if (opponentMove != null) {
          currentBoard.makeMove(opponentMove);
          currentSolutionIndex++;

          // Check if solution complete after opponent move
          if (currentSolutionIndex >= solutionSan.length) {
            isCompleted = true;
            isSuccess = true;
            feedbackMessage = 'Exercise complete! $explanation';
            _notify();
            return LabStepResult.completed;
          } else {
            feedbackMessage = 'Opponent played $opponentSan. Find the follow-up!';
            _notify();
            return LabStepResult.opponentPlayed;
          }
        }

        feedbackMessage = 'Correct move! Find the next step.';
        _notify();
        return LabStepResult.correct;
      } else {
        // Incorrect move
        score = (score - 25.0).clamp(0.0, 100.0);
        feedbackMessage = 'Move $playedSan is not the best continuation. Try again!';
        _notify();
        return LabStepResult.incorrect;
      }
    }

    return LabStepResult.incorrect;
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
