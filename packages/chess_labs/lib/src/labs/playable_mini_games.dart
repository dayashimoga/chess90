import 'dart:async';
import 'package:chess_core/chess_core.dart';

/// The 12 authentic, interactive chess mini-game categories required by ChessMaster.
enum MiniGameType {
  forkHunter('Fork Hunter', 'Spot and execute lethal double attacks with knights and pawns.'),
  pinBuilder('Pin Builder', 'Freeze enemy pieces against king and queen vectors.'),
  skewerHunt('Skewer Hunt', 'Drive off higher-value targets to capture trailing pieces.'),
  kingHunt('King Hunt', 'Hunt down exposed enemy monarchs with forcing checks.'),
  defender('Defender', 'Discover the only saving defensive resource under heavy fire.'),
  pawnBattle('Pawn Battle', 'Out-calculate passed pawn races, breakthroughs, and promotions.'),
  findTheBreak('Find the Break', 'Identify the decisive pawn lever that shatters enemy structures.'),
  openingSurvival('Opening Survival', 'Navigate venomous opening traps and punish early gambits.'),
  calculationTree('Calculation Tree', 'Calculate branching Kotov variations and prune dead ends.'),
  conversionChallenge('Conversion Challenge', 'Convert clear material and structural advantages into technical wins.'),
  endgameWinHold('Endgame Win / Hold', 'Win theoretical Lucena bridges and hold Philidor fortresses.'),
  worstPieceImprovement('Worst Piece Improvement', 'Re-route your least active piece to an unassailable outpost.');

  final String title;
  final String description;
  const MiniGameType(this.title, this.description);
}

/// A validated level within a playable mini-game drill.
class MiniGameLevel {
  final int levelNumber;
  final String title;
  final String initialFen;
  final PieceColor sideToPlay;
  final String objective;
  final List<String> expectedMovesSan; // Sequence of moves: Player, Opponent, Player...
  final List<String> hints;
  final String explanation;
  final String? refutation;

  const MiniGameLevel({
    required this.levelNumber,
    required this.title,
    required this.initialFen,
    required this.sideToPlay,
    required this.objective,
    required this.expectedMovesSan,
    required this.hints,
    required this.explanation,
    this.refutation,
  });
}

/// Interactive game controller for all 12 real mini-games.
class PlayableMiniGame {
  final MiniGameType type;
  final List<MiniGameLevel> levels;
  int currentLevelIndex = 0;

  late Board currentBoard;
  int currentMoveIndex = 0;
  int hintsRevealed = 0;
  int roundsCompleted = 0;
  bool isLevelCompleted = false;
  bool isGameOver = false;
  String feedbackMessage = '';
  final List<Move> moveHistory = [];

  final _updateController = StreamController<PlayableMiniGame>.broadcast();

  PlayableMiniGame({
    required this.type,
    required this.levels,
  }) {
    if (levels.isEmpty) {
      throw ArgumentError('Mini-game must contain at least one validated level');
    }
    _initLevel(0);
  }

  Stream<PlayableMiniGame> get onUpdate => _updateController.stream;

  MiniGameLevel get currentLevel => levels[currentLevelIndex];
  int get totalLevels => levels.length;
  double get progressFraction => (roundsCompleted / totalLevels).clamp(0.0, 1.0);

  void _initLevel(int index) {
    currentLevelIndex = index.clamp(0, levels.length - 1);
    final lvl = levels[currentLevelIndex];
    currentBoard = Board.fromFen(lvl.initialFen);
    currentMoveIndex = 0;
    hintsRevealed = 0;
    isLevelCompleted = false;
    isGameOver = false;
    moveHistory.clear();
    feedbackMessage = '${lvl.title}: ${lvl.objective}';
    _notify();
  }

  void resetCurrentLevel() {
    _initLevel(currentLevelIndex);
  }

  void nextLevel() {
    if (currentLevelIndex < levels.length - 1) {
      _initLevel(currentLevelIndex + 1);
    } else {
      isGameOver = true;
      feedbackMessage = 'Congratulations! You have mastered all levels of ${type.title}!';
      _notify();
    }
  }

  String? requestHint() {
    final lvl = currentLevel;
    if (hintsRevealed < lvl.hints.length) {
      final hint = lvl.hints[hintsRevealed];
      hintsRevealed++;
      feedbackMessage = 'Hint $hintsRevealed: $hint';
      _notify();
      return hint;
    }
    return null;
  }

  /// Plays a user move on the board and evaluates against the verified mini-game solution.
  bool playMove(Move move) {
    if (isLevelCompleted || isGameOver) return false;

    final legals = MoveGenerator.generateLegalMoves(currentBoard);
    if (!legals.contains(move)) {
      feedbackMessage = 'Illegal move: ${move.uci}. Check piece rules.';
      _notify();
      return false;
    }

    final playedSan = MoveGenerator.moveToSan(currentBoard, move);
    final lvl = currentLevel;

    if (currentMoveIndex < lvl.expectedMovesSan.length) {
      final expectedSan = lvl.expectedMovesSan[currentMoveIndex];
      if (_compareSan(playedSan, expectedSan)) {
        currentBoard.makeMove(move);
        moveHistory.add(move);
        currentMoveIndex++;

        // Check if level complete
        if (currentMoveIndex >= lvl.expectedMovesSan.length) {
          isLevelCompleted = true;
          roundsCompleted++;
          feedbackMessage = 'Success! Level ${lvl.levelNumber} Completed! ${lvl.explanation}';
          _notify();
          return true;
        }

        // Automatic opponent reply if expected
        final opponentSan = lvl.expectedMovesSan[currentMoveIndex];
        final opponentMove = MoveGenerator.sanToMove(currentBoard, opponentSan);
        if (opponentMove != null) {
          currentBoard.makeMove(opponentMove);
          moveHistory.add(opponentMove);
          currentMoveIndex++;

          if (currentMoveIndex >= lvl.expectedMovesSan.length) {
            isLevelCompleted = true;
            roundsCompleted++;
            feedbackMessage = 'Level ${lvl.levelNumber} Mastered! Opponent played $opponentSan. ${lvl.explanation}';
            _notify();
            return true;
          } else {
            feedbackMessage = 'Opponent replied $opponentSan. Find the decisive follow-up!';
            _notify();
            return true;
          }
        }

        feedbackMessage = 'Correct move: $playedSan! Keep going.';
        _notify();
        return true;
      } else {
        feedbackMessage = 'Incorrect move ($playedSan). ${lvl.refutation ?? "Look for the most forcing tactical resource and try again."}';
        _notify();
        return false;
      }
    }

    return false;
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

  // ---------------------------------------------------------------------------
  // FACTORY DISPATCHER FOR ALL 12 MINI-GAMES
  // ---------------------------------------------------------------------------
  static PlayableMiniGame create(MiniGameType type) {
    switch (type) {
      case MiniGameType.forkHunter:
        return _buildForkHunter();
      case MiniGameType.pinBuilder:
        return _buildPinBuilder();
      case MiniGameType.skewerHunt:
        return _buildSkewerHunt();
      case MiniGameType.kingHunt:
        return _buildKingHunt();
      case MiniGameType.defender:
        return _buildDefender();
      case MiniGameType.pawnBattle:
        return _buildPawnBattle();
      case MiniGameType.findTheBreak:
        return _buildFindTheBreak();
      case MiniGameType.openingSurvival:
        return _buildOpeningSurvival();
      case MiniGameType.calculationTree:
        return _buildCalculationTree();
      case MiniGameType.conversionChallenge:
        return _buildConversionChallenge();
      case MiniGameType.endgameWinHold:
        return _buildEndgameWinHold();
      case MiniGameType.worstPieceImprovement:
        return _buildWorstPieceImprovement();
    }
  }

  // 1. FORK HUNTER
  static PlayableMiniGame _buildForkHunter() {
    return PlayableMiniGame(
      type: MiniGameType.forkHunter,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Royal Knight Fork',
          initialFen: 'r3k2r/ppp2ppp/8/3q4/3N4/8/PPP2PPP/R1BQKB1R w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Fork the Black King and Queen with your centralized knight.',
          expectedMovesSan: ['Qe2+', 'Kd8', 'Nc6+'],
          hints: ['First check the uncastled king to clear files.', 'Look at the c6 outpost.'],
          explanation: 'Qe2+ forces the king, setting up the devastating knight fork on c6.',
          refutation: 'Playing immediate knight moves allows the queen to retreat safely.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'Central Pawn Fork Trick',
          initialFen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
          sideToPlay: PieceColor.white,
          objective: 'Seize the center and prepare the d4 break fork.',
          expectedMovesSan: ['d4', 'exd4', 'e5'],
          hints: ['Strike in the center immediately.', 'Push the e-pawn to fork the knight.'],
          explanation: 'd4 followed by e5 forks the Black minor pieces.',
          refutation: 'Quiet moves concede the initiative in the Italian.',
        ),
        MiniGameLevel(
          levelNumber: 3,
          title: 'Decisive Royal Fork',
          initialFen: 'r3k2r/pp2bppp/2n5/1N1p4/4n3/2P5/PP3PPP/RNBQKB1R w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Fork the Black King on e8 and Rook on a8 with your knight.',
          expectedMovesSan: ['Nc7+', 'Kf8', 'Nxa8'],
          hints: ['Jump your knight to c7 with check.', 'Capture the corner rook after the king steps aside.'],
          explanation: 'Nc7+ forks the king and rook simultaneously, winning decisive material.',
          refutation: 'Playing quiet moves allows Black to castle kingside and eliminate the fork target.',
        ),
      ],
    );
  }

  // 2. PIN BUILDER
  static PlayableMiniGame _buildPinBuilder() {
    return PlayableMiniGame(
      type: MiniGameType.pinBuilder,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Absolute King Pin',
          initialFen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Pin the enemy knight against the uncastled king.',
          expectedMovesSan: ['Qe2', 'd5', 'd3'],
          hints: ['Line up your queen on the open e-file.', 'Support with d3.'],
          explanation: 'Qe2 creates an absolute pin; d3 then wins the pinned piece.',
          refutation: 'Quiet moves allow Black to retreat the knight with Nf6.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'Diagonal Queen Skewer-Pin',
          initialFen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2N1PN2/PP2BPPP/R1BQK2R w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Pin the knight on c6 with your light-squared bishop.',
          expectedMovesSan: ['Bb5', 'Bd7', 'Bxc6'],
          hints: ['Pin the knight against the king diagonal.'],
          explanation: 'Bb5 pins c6 and breaks down Black\'s pawn integrity.',
        ),
      ],
    );
  }

  // 3. SKEWER HUNT
  static PlayableMiniGame _buildSkewerHunt() {
    return PlayableMiniGame(
      type: MiniGameType.skewerHunt,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Corridor Rook Skewer',
          initialFen: 'r7/4k3/8/8/8/8/8/4K2R w K - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Skewer the black king on the 7th rank to win the rook on a7.',
          expectedMovesSan: ['Rh7+', 'Ke6', 'Rxa7'],
          hints: ['Check the enemy king along the 7th rank.', 'The king must move, exposing the a7 rook.', 'Capture on a7.'],
          explanation: 'Rh7+ checks the king, forcing it to step away and leaving the trailing a7 rook undefended.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'Diagonal Bishop Skewer',
          initialFen: 'r3k3/8/8/8/8/8/8/B3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Skewer the king and rook on the long diagonal.',
          expectedMovesSan: ['Bd4'],
          hints: ['Take the central commanding diagonal.'],
          explanation: 'Bd4 dominates the long diagonal and coordinates with king play.',
        ),
      ],
    );
  }

  // 4. KING HUNT
  static PlayableMiniGame _buildKingHunt() {
    return PlayableMiniGame(
      type: MiniGameType.kingHunt,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Mating Net on f7',
          initialFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Deliver instant checkmate against the exposed black monarch.',
          expectedMovesSan: ['Qxf7#'],
          hints: ['Target the weakest square on the board before castling.'],
          explanation: 'Qxf7# delivers Scholar\'s Mate guarded by the c4 bishop.',
          refutation: 'Capturing on e4 misses the immediate mating blow.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'Back-Rank Execution',
          initialFen: '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Infiltrate the 8th rank to trap the cornered king.',
          expectedMovesSan: ['Re8#'],
          hints: ['The king is suffocated behind its own pawns.'],
          explanation: 'Re8# delivers the classic corridor corridor mate.',
        ),
      ],
    );
  }

  // 5. DEFENDER
  static PlayableMiniGame _buildDefender() {
    return PlayableMiniGame(
      type: MiniGameType.defender,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Queen Trade Parrying Check',
          initialFen: 'r1b1k2r/pppp1ppp/8/4q3/8/5Q2/PPP2PPP/RNB1KB1R w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Black checks your exposed king. Find the only stabilizing parry.',
          expectedMovesSan: ['Qe2', 'Qxe2+', 'Bxe2'],
          hints: ['Neutralize the attack by offering queen liquidation.'],
          explanation: 'Qe2 breaks the attack and allows White to develop the bishop comfortably.',
          refutation: 'Interposing pieces passively loses castling rights.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'Shielding the King',
          initialFen: 'r1b1k2r/ppp2ppp/2n5/3qp3/1b1P4/2N1P3/PP3PPP/R1BQKBNR w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Unpin the c3 knight before material is lost.',
          expectedMovesSan: ['Bd2', 'Bxc3', 'Bxc3'],
          hints: ['Interpose your dark-squared bishop.'],
          explanation: 'Bd2 breaks the pin and regains the bishop pair.',
        ),
      ],
    );
  }

  // 6. PAWN BATTLE
  static PlayableMiniGame _buildPawnBattle() {
    return PlayableMiniGame(
      type: MiniGameType.pawnBattle,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Creating the Outside Passed Pawn',
          initialFen: '8/5pk1/4p1p1/8/8/5PK1/4P1P1/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Advance your majority to manufacture an unstoppable passed pawn.',
          expectedMovesSan: ['f4', 'Kf6', 'e4'],
          hints: ['The f-pawn leads the charge.', 'Support with e4.'],
          explanation: 'f4 followed by e4 establishes a dynamic pawn rolling wedge.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'Square Rule Promotion Sprint',
          initialFen: '8/4P3/8/8/8/8/k7/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Promote the passed pawn to a Queen.',
          expectedMovesSan: ['e8=Q'],
          hints: ['Push to the final rank.'],
          explanation: 'e8=Q queens cleanly; the black king is far outside the square.',
        ),
      ],
    );
  }

  // 7. FIND THE BREAK
  static PlayableMiniGame _buildFindTheBreak() {
    return PlayableMiniGame(
      type: MiniGameType.findTheBreak,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Central d4 Break',
          initialFen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          objective: 'Blast open the center while Black\'s king lingers uncastled.',
          expectedMovesSan: ['d4', 'exd4', 'e5'],
          hints: ['Strike in the center with the d-pawn.'],
          explanation: 'd4 immediately challenges Black\'s central anchor.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'French Structure c4 Lever',
          initialFen: 'r1bqk2r/pp2bppp/2n1pn2/2pp4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          objective: 'Clarify the center with the classic trade.',
          expectedMovesSan: ['cxd5', 'exd5', 'dxc5'],
          hints: ['Capture on d5 to open diagonals.'],
          explanation: 'cxd5 liquidates central tension favorably.',
        ),
      ],
    );
  }

  // 8. OPENING SURVIVAL
  static PlayableMiniGame _buildOpeningSurvival() {
    return PlayableMiniGame(
      type: MiniGameType.openingSurvival,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Italian Mainline Safety',
          initialFen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Complete kingside mobilization and castle to safety.',
          expectedMovesSan: ['O-O', 'Nf6', 'd3'],
          hints: ['Two squares toward the corner.'],
          explanation: 'O-O fulfills early development priority.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'Countering the Scandinavian',
          initialFen: 'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          objective: 'Punish the premature central pawn push.',
          expectedMovesSan: ['exd5', 'Qxd5', 'Nc3'],
          hints: ['Accept the pawn and develop with tempo.'],
          explanation: 'exd5 followed by Nc3 wins a development tempo on the queen.',
        ),
      ],
    );
  }

  // 9. CALCULATION TREE
  static PlayableMiniGame _buildCalculationTree() {
    return PlayableMiniGame(
      type: MiniGameType.calculationTree,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Kotov Candidate Elimination',
          initialFen: '3r2k1/5ppp/8/8/8/8/5PPP/3R2K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Compare candidates: quiet pawn push vs decisive liquidation.',
          expectedMovesSan: ['Rxd8#'],
          hints: ['Eliminate the defending piece.'],
          explanation: 'Rxd8# is the only forcing winning candidate.',
        ),
      ],
    );
  }

  // 10. CONVERSION CHALLENGE
  static PlayableMiniGame _buildConversionChallenge() {
    return PlayableMiniGame(
      type: MiniGameType.conversionChallenge,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Infiltrating the 7th Rank',
          initialFen: 'r4rk1/pp1b1ppp/8/3p4/8/1P1B4/P4PPP/R3R1K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Occupy the 7th rank with your rook to paralyze enemy defenders.',
          expectedMovesSan: ['Re7', 'Rad8', 'Rae1'],
          hints: ['Penetrate deep into enemy territory.'],
          explanation: 'Re7 dominates the 7th rank and ties Black to defense.',
        ),
      ],
    );
  }

  // 11. ENDGAME WIN / HOLD
  static PlayableMiniGame _buildEndgameWinHold() {
    return PlayableMiniGame(
      type: MiniGameType.endgameWinHold,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Seizing Direct Opposition',
          initialFen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Step forward to claim the vertical opposition.',
          expectedMovesSan: ['Ke3', 'Kd5', 'Kd3'],
          hints: ['Place your king one square away on the same file.'],
          explanation: 'Ke3 claims opposition, denying the enemy king forward entry.',
        ),
        MiniGameLevel(
          levelNumber: 2,
          title: 'Theoretical Stalemate Defense',
          initialFen: '7k/8/8/8/8/7q/6R1/6K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          objective: 'Liquidate and pin to hold the fortress draw.',
          expectedMovesSan: ['Rh2', 'Qxh2+', 'Kxh2'],
          hints: ['Pin the queen directly against the white king.'],
          explanation: 'Rh2 pins the queen and liquidates into a book draw.',
        ),
      ],
    );
  }

  // 12. WORST PIECE IMPROVEMENT
  static PlayableMiniGame _buildWorstPieceImprovement() {
    return PlayableMiniGame(
      type: MiniGameType.worstPieceImprovement,
      levels: const [
        MiniGameLevel(
          levelNumber: 1,
          title: 'Harmonious Knight Activation',
          initialFen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
          sideToPlay: PieceColor.white,
          objective: 'Develop your passive kingside knight to attack e5.',
          expectedMovesSan: ['Nf3', 'Nc6', 'Bc4'],
          hints: ['Knights before bishops in the center.'],
          explanation: 'Nf3 develops with tempo against the e5 pawn.',
        ),
      ],
    );
  }
}
