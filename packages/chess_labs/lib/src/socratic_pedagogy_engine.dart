import 'package:chess_core/chess_core.dart';

/// Lightweight data model for board arrows without UI framework dependencies.
class BoardArrowData {
  final Square from;
  final Square to;
  final String colorHex;

  const BoardArrowData({
    required this.from,
    required this.to,
    this.colorHex = '#22C55E', // primary green default
  });
}

/// The 9 cognitive stages of Grandmaster thinking taught to the learner.
enum CognitiveStage {
  whatChanged(
    'What Changed?',
    'Identify what squares or diagonals the opponent just opened, weakened, or vacated.',
    'Look at the piece that just moved and what it left behind undefended.',
  ),
  opponentThreat(
    'Opponent Threat',
    'Assess what the opponent wants to do next if White/Black passes a turn.',
    'Do they threaten an immediate check, fork, skewer, or mate?',
  ),
  cctScanning(
    'Checks, Captures, Threats (CCT)',
    'Scan all forcing candidate moves before evaluating quiet positional moves.',
    'Forcing moves limit opponent choices and make calculation precise.',
  ),
  lpdoAnalysis(
    'Loose Pieces & Weaknesses (LPDO)',
    'Locate Loose Pieces and Defended Opportunities for both sides.',
    'Undefended pieces are tactical targets waiting to be exploited.',
  ),
  candidateSelection(
    'Select Candidate Moves',
    'Shortlist 2 to 3 candidate moves that directly target identified weaknesses.',
    'Never look at only one move; compare at least two distinct candidates.',
  ),
  calculateStrongestReply(
    'Calculate Strongest Reply',
    'For your favorite candidate, look for the opponent\'s most stubborn defensive reply.',
    'Do not assume the opponent will cooperate or blunder.',
  ),
  compareOutcomes(
    'Compare Outcomes',
    'Weigh the resulting positions: material balance, king safety, and initiative.',
    'Choose the branch with clean conversion or permanent positional advantage.',
  ),
  blunderCheck(
    'Blunder Check',
    'Sanity check your chosen move: does it walk into a counter-tactic or undefended square?',
    'Take 3 seconds before executing to confirm piece safety.',
  ),
  executeMove(
    'Execute & Learn',
    'Commit to the decision with confidence and observe how the game structure responds.',
    'Trust your calculation and learn from every outcome.',
  );

  final String title;
  final String description;
  final String gmTip;

  const CognitiveStage(this.title, this.description, this.gmTip);
}

/// A concrete cognitive thinking checklist item for an exercise.
class CognitiveDecisionStep {
  final CognitiveStage stage;
  final String specificPrompt;
  final String observation;
  bool isCompleted;

  CognitiveDecisionStep({
    required this.stage,
    required this.specificPrompt,
    required this.observation,
    this.isCompleted = false,
  });
}

/// Socratic interaction validation modes.
enum SocraticValidationType {
  clickTargetSquare,
  selectCandidateMove,
  confirmUnderstanding,
}

/// An interactive Socratic discovery checkpoint where the learner is guided
/// to recognize the key weakness rather than simply told the answer.
class SocraticStep {
  final String id;
  final String conceptTitle;
  final String prompt;
  final String hint;
  final String successFeedback;
  final SocraticValidationType validationType;
  final List<Square> expectedSquares;
  final List<Square> highlightedSquares;
  final List<BoardArrowData> arrows;
  final List<String> candidateMovesSan;
  bool isCompleted;

  SocraticStep({
    required this.id,
    required this.conceptTitle,
    required this.prompt,
    required this.hint,
    required this.successFeedback,
    required this.validationType,
    this.expectedSquares = const [],
    this.highlightedSquares = const [],
    this.arrows = const [],
    this.candidateMovesSan = const [],
    this.isCompleted = false,
  });
}

/// An autonomous teaching step for cinematic DEMO mode where the board teaches itself.
class DemoStep {
  final int stepIndex;
  final String title;
  final String caption;
  final List<Square> highlightedSquares;
  final List<BoardArrowData> arrows;
  final Move? animatedMove;
  final String? moveSan;
  final String explanationWhy;

  const DemoStep({
    required this.stepIndex,
    required this.title,
    required this.caption,
    this.highlightedSquares = const [],
    this.arrows = const [],
    this.animatedMove,
    this.moveSan,
    required this.explanationWhy,
  });
}

/// Engine that constructs autonomous demos, Socratic discovery pathways,
/// and Grandmaster cognitive decision trees for any position and motif.
class SocraticPedagogyEngine {
  final Board initialBoard;
  final PieceColor sideToPlay;
  final List<String> solutionSan;
  final String motif;
  final String explanation;
  final List<String> hints;

  final List<DemoStep> demoSteps = [];
  final List<SocraticStep> socraticSteps = [];
  final List<CognitiveDecisionStep> cognitiveChecklist = [];

  int currentDemoIndex = 0;
  int currentSocraticIndex = 0;

  SocraticPedagogyEngine({
    required this.initialBoard,
    required this.sideToPlay,
    required this.solutionSan,
    required this.motif,
    required this.explanation,
    this.hints = const [],
  }) {
    _buildPedagogy();
  }

  DemoStep? get currentDemoStep =>
      (currentDemoIndex >= 0 && currentDemoIndex < demoSteps.length) ? demoSteps[currentDemoIndex] : null;

  SocraticStep? get currentSocraticStep =>
      (currentSocraticIndex >= 0 && currentSocraticIndex < socraticSteps.length)
          ? socraticSteps[currentSocraticIndex]
          : null;

  bool get isDemoFinished => currentDemoIndex >= demoSteps.length - 1;
  bool get isSocraticFinished => currentSocraticIndex >= socraticSteps.length;

  void nextDemoStep() {
    if (currentDemoIndex < demoSteps.length - 1) {
      currentDemoIndex++;
    }
  }

  void prevDemoStep() {
    if (currentDemoIndex > 0) {
      currentDemoIndex--;
    }
  }

  void resetDemo() {
    currentDemoIndex = 0;
  }

  bool validateSocraticSquare(Square square) {
    final step = currentSocraticStep;
    if (step == null) return false;

    if (step.expectedSquares.contains(square)) {
      step.isCompleted = true;
      currentSocraticIndex++;
      return true;
    }
    return false;
  }

  bool validateSocraticMove(String san) {
    final step = currentSocraticStep;
    if (step == null) return false;

    if (step.candidateMovesSan.contains(san) || (solutionSan.isNotEmpty && solutionSan.first == san)) {
      step.isCompleted = true;
      currentSocraticIndex++;
      return true;
    }
    return false;
  }

  void advanceSocratic() {
    final step = currentSocraticStep;
    if (step != null) {
      step.isCompleted = true;
      currentSocraticIndex++;
    }
  }

  void resetSocratic() {
    currentSocraticIndex = 0;
    for (final s in socraticSteps) {
      s.isCompleted = false;
    }
  }

  // --- Internal Builder ---
  void _buildPedagogy() {
    final enemyColor = sideToPlay == PieceColor.white ? PieceColor.black : PieceColor.white;
    final enemyKingSquare = _findKing(enemyColor) ?? (enemyColor == PieceColor.black ? Square.g8 : Square.g1);

    Move? firstMove;
    if (solutionSan.isNotEmpty) {
      firstMove = MoveGenerator.sanToMove(initialBoard, solutionSan.first);
    }

    final fromSq = firstMove?.from;
    final toSq = firstMove?.to;

    // Detect escaping pawns or blocking pawns for king
    final blockingPawns = _findShieldingPawns(enemyColor, enemyKingSquare);

    final normalizedMotif = motif.toLowerCase();

    // 1. BUILD AUTONOMOUS DEMO SCENES
    if (normalizedMotif.contains('back rank') || normalizedMotif.contains('corridor') || normalizedMotif.contains('mate')) {
      demoSteps.addAll([
        DemoStep(
          stepIndex: 1,
          title: '1. Recognize Vulnerability',
          caption: 'Observe the ${enemyColor.name} King on ${enemyKingSquare.name}. Its own pawn shield locks it on the back rank.',
          highlightedSquares: [enemyKingSquare, ...blockingPawns],
          arrows: blockingPawns.map((p) => BoardArrowData(from: enemyKingSquare, to: p, colorHex: '#EF4444')).toList(),
          explanationWhy: 'When a castled king has made no luft (escape square), any rook or queen check on the back rank is immediately fatal.',
        ),
        DemoStep(
          stepIndex: 2,
          title: '2. Spot the Infiltration Ray',
          caption: 'Look at the attacking piece${fromSq != null ? " on ${fromSq.name}" : ""}. It controls the open pathway to the 8th rank.',
          highlightedSquares: fromSq != null ? [fromSq, toSq ?? Square.e8] : [Square.e1, Square.e8],
          arrows: (fromSq != null && toSq != null)
              ? [BoardArrowData(from: fromSq, to: toSq, colorHex: '#10B981')]
              : [],
          explanationWhy: 'The defender has failed to contest the open file, permitting a decisive breakthrough.',
        ),
        DemoStep(
          stepIndex: 3,
          title: '3. Animate Candidate Execution',
          caption: 'Deliver the checkmate: ${solutionSan.isNotEmpty ? solutionSan.first : "Re8#"}!',
          highlightedSquares: toSq != null ? [toSq, enemyKingSquare] : [enemyKingSquare],
          arrows: (fromSq != null && toSq != null)
              ? [BoardArrowData(from: fromSq, to: toSq, colorHex: '#F59E0B')]
              : [],
          animatedMove: firstMove,
          moveSan: solutionSan.isNotEmpty ? solutionSan.first : null,
          explanationWhy: 'Checkmate! The king is under direct attack, cannot capture the attacker, cannot interpose, and has zero legal flight squares.',
        ),
        DemoStep(
          stepIndex: 4,
          title: '4. The Grandmaster Rule',
          caption: 'Always look for back-rank corridors when enemy pawns have not pushed h6 or g6.',
          highlightedSquares: [enemyKingSquare],
          explanationWhy: explanation.isNotEmpty ? explanation : 'Corridor mates punish lack of luft. In defense, always create an escape hatch.',
        ),
      ]);
    } else if (normalizedMotif.contains('fork')) {
      demoSteps.addAll([
        DemoStep(
          stepIndex: 1,
          title: '1. Spot Double Alignment',
          caption: 'Notice two high-value enemy pieces aligned on squares vulnerable to a simultaneous geometric attack.',
          highlightedSquares: toSq != null ? [enemyKingSquare, toSq] : [enemyKingSquare],
          arrows: (fromSq != null && toSq != null)
              ? [BoardArrowData(from: toSq, to: enemyKingSquare, colorHex: '#EF4444')]
              : [],
          explanationWhy: 'A fork succeeds when one piece attacks two targets at once, forcing the opponent to save only one.',
        ),
        DemoStep(
          stepIndex: 2,
          title: '2. The Geometric Pivot',
          caption: 'The piece on ${fromSq?.name ?? "source"} can leap to ${toSq?.name ?? "destination"} creating two threats in one move.',
          highlightedSquares: fromSq != null && toSq != null ? [fromSq, toSq] : [],
          arrows: fromSq != null && toSq != null ? [BoardArrowData(from: fromSq, to: toSq, colorHex: '#10B981')] : [],
          animatedMove: firstMove,
          moveSan: solutionSan.isNotEmpty ? solutionSan.first : null,
          explanationWhy: 'By targeting the king with check or attacking two major pieces, defense is impossible.',
        ),
        DemoStep(
          stepIndex: 3,
          title: '3. Net Advantage',
          caption: 'Play ${solutionSan.isNotEmpty ? solutionSan.first : "Fork"}. Material gain or decisive victory follows.',
          highlightedSquares: toSq != null ? [toSq] : [],
          explanationWhy: explanation.isNotEmpty ? explanation : 'Forks exploit loose and undefended alignments.',
        ),
      ]);
    } else {
      // General tactical or strategic demo
      demoSteps.addAll([
        DemoStep(
          stepIndex: 1,
          title: '1. Position Evaluation',
          caption: 'Observe the imbalances: piece activity, king safety, and open files.',
          highlightedSquares: [enemyKingSquare],
          explanationWhy: 'Grandmaster thinking begins with static evaluation before concrete calculation.',
        ),
        DemoStep(
          stepIndex: 2,
          title: '2. Candidate Move Generation',
          caption: 'Generate the most forcing candidate move: ${solutionSan.isNotEmpty ? solutionSan.first : "Candidate"}.',
          highlightedSquares: fromSq != null && toSq != null ? [fromSq, toSq] : [],
          arrows: fromSq != null && toSq != null ? [BoardArrowData(from: fromSq, to: toSq, colorHex: '#10B981')] : [],
          animatedMove: firstMove,
          moveSan: solutionSan.isNotEmpty ? solutionSan.first : null,
          explanationWhy: 'Forcing moves dictate the pace and prevent opponent counterplay.',
        ),
        DemoStep(
          stepIndex: 3,
          title: '3. Master Rationale',
          caption: explanation.isNotEmpty ? explanation : 'The chosen move capitalizes on the key positional imbalance.',
          highlightedSquares: toSq != null ? [toSq] : [],
          explanationWhy: explanation,
        ),
      ]);
    }

    // 2. BUILD SOCRATIC GUIDED DISCOVERY STEPS
    socraticSteps.addAll([
      SocraticStep(
        id: 'soc_1_target',
        conceptTitle: 'Target Identification',
        prompt: 'Tap the vulnerable enemy King on the board.',
        hint: 'Look for the ${enemyColor.name} King.',
        successFeedback: 'Excellent! The king on ${enemyKingSquare.name} is the primary tactical objective.',
        validationType: SocraticValidationType.clickTargetSquare,
        expectedSquares: [enemyKingSquare],
        highlightedSquares: [enemyKingSquare],
      ),
      SocraticStep(
        id: 'soc_2_escapes',
        conceptTitle: 'Escape Squares & Flight Check',
        prompt: blockingPawns.isNotEmpty
            ? 'Observe the escape squares. Tap any friendly pawn blocking the king\'s escape.'
            : 'Can the enemy king easily escape? Tap the king to verify its trapped status.',
        hint: blockingPawns.isNotEmpty
            ? 'The pawns in front of the king (${blockingPawns.map((p) => p.name).join(", ")}) take away flight squares.'
            : 'Check surrounding squares.',
        successFeedback: 'Spot on! The king has zero legal escape squares forward.',
        validationType: SocraticValidationType.clickTargetSquare,
        expectedSquares: blockingPawns.isNotEmpty ? blockingPawns : [enemyKingSquare],
        highlightedSquares: blockingPawns,
      ),
      if (fromSq != null)
        SocraticStep(
          id: 'soc_3_attacker',
          conceptTitle: 'Candidate Piece Discovery',
          prompt: 'Which piece in your army can deliver the decisive blow? Tap your attacking piece on ${fromSq.name}.',
          hint: 'Select the piece located on ${fromSq.name}.',
          successFeedback: 'Correct! This piece is primed to strike along the critical vector.',
          validationType: SocraticValidationType.clickTargetSquare,
          expectedSquares: [fromSq],
          highlightedSquares: [fromSq],
          arrows: toSq != null ? [BoardArrowData(from: fromSq, to: toSq, colorHex: '#10B981')] : [],
        ),
      SocraticStep(
        id: 'soc_4_play',
        conceptTitle: 'Decisive Execution',
        prompt: 'Now play the winning move (${solutionSan.isNotEmpty ? solutionSan.first : "best move"}) on the board!',
        hint: solutionSan.isNotEmpty ? 'Play ${solutionSan.first} to conclude the combination.' : 'Execute your candidate.',
        successFeedback: 'Masterful! You discovered the solution through structured reasoning, not guessing.',
        validationType: SocraticValidationType.selectCandidateMove,
        candidateMovesSan: solutionSan.isNotEmpty ? [solutionSan.first] : [],
        highlightedSquares: toSq != null ? [toSq] : [],
      ),
    ]);

    // 3. BUILD COGNITIVE DECISION TREE
    cognitiveChecklist.addAll([
      CognitiveDecisionStep(
        stage: CognitiveStage.whatChanged,
        specificPrompt: 'What changed in the position?',
        observation: 'The opponent has left their king restricted and undefended on ${enemyKingSquare.name}.',
      ),
      CognitiveDecisionStep(
        stage: CognitiveStage.opponentThreat,
        specificPrompt: 'Is there an immediate threat to counter?',
        observation: 'Our initiative is decisive; no immediate defensive counter-threat prevents our attack.',
      ),
      CognitiveDecisionStep(
        stage: CognitiveStage.cctScanning,
        specificPrompt: 'Scan Checks, Captures, and Threats.',
        observation: solutionSan.isNotEmpty ? 'Candidate check ${solutionSan.first} is direct and forcing.' : 'Scan forcing lines.',
      ),
      CognitiveDecisionStep(
        stage: CognitiveStage.candidateSelection,
        specificPrompt: 'Compare 2 candidate moves.',
        observation: 'Candidate A (${solutionSan.isNotEmpty ? solutionSan.first : "Best"}) immediately wins; quiet moves allow defense.',
      ),
      CognitiveDecisionStep(
        stage: CognitiveStage.blunderCheck,
        specificPrompt: 'Blunder Check before execution.',
        observation: 'The target square ${toSq?.name ?? ""} is fully supported; no counter-check exists.',
      ),
      CognitiveDecisionStep(
        stage: CognitiveStage.executeMove,
        specificPrompt: 'Execute with certainty.',
        observation: 'Play ${solutionSan.isNotEmpty ? solutionSan.first : "move"} and convert the advantage.',
      ),
    ]);
  }

  Square? _findKing(PieceColor color) {
    for (int i = 0; i < 64; i++) {
      final sq = Square(i);
      final p = initialBoard.pieceAt(sq);
      if (p != null && p.type == PieceType.king && p.color == color) {
        return sq;
      }
    }
    return null;
  }

  List<Square> _findShieldingPawns(PieceColor kingColor, Square kingSq) {
    final list = <Square>[];
    final pawnRank = kingColor == PieceColor.black ? 6 : 1; // 7th rank for black, 2nd for white
    final kingRank = kingSq.rank;

    if ((kingColor == PieceColor.black && kingRank == 7) || (kingColor == PieceColor.white && kingRank == 0)) {
      for (int i = 0; i < 64; i++) {
        final sq = Square(i);
        if (sq.rank == pawnRank && (sq.file - kingSq.file).abs() <= 1) {
          final p = initialBoard.pieceAt(sq);
          if (p != null && p.type == PieceType.pawn && p.color == kingColor) {
            list.add(sq);
          }
        }
      }
    }
    return list;
  }
}
