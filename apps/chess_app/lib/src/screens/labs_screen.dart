import 'dart:async';
import 'dart:math' as math;
import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_board_theme.dart';
import '../theme/chess_theme.dart';
import '../theme/piece_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/move_list_widget.dart';
import '../widgets/board/responsive_chess_workspace.dart';

/// Available learning and training categories in the interactive laboratory.
enum LabCategory {
  curriculum(
    id: 'curriculum',
    label: '90-Day Curriculum',
    icon: Icons.calendar_today,
    description: 'Guided daily curriculum practice (Days 1–90)',
  ),
  tactics(
    id: 'tactics',
    label: 'Tactics Bank',
    icon: Icons.flash_on,
    description: '1,664 curated tactical motifs, skewers, forks, pins, and mates',
  ),
  calculation(
    id: 'calculation',
    label: 'Calculation & Combinations',
    icon: Icons.calculate,
    description: 'Deep forcing lines, candidate moves, and combination trees',
  ),
  visualization(
    id: 'visualization',
    label: 'Visualization & Blindfold',
    icon: Icons.visibility,
    description: 'Multi-ply lookahead and mental board tracking exercises',
  ),
  strategy(
    id: 'strategy',
    label: 'Strategy & Pawn Structures',
    icon: Icons.account_tree,
    description: 'Outposts, weak squares, pawn chains, minority attacks, and plans',
  ),
  endgame(
    id: 'endgame',
    label: 'Endgame Mastery',
    icon: Icons.flag,
    description: 'Theoretical rooks, opposition, pawn races, and technical conversions',
  ),
  opening(
    id: 'opening',
    label: 'Opening Traps & Repertoire',
    icon: Icons.book,
    description: 'Early tactical traps, development principles, and refutations',
  ),
  practical(
    id: 'practical',
    label: 'Practical Critical Moments',
    icon: Icons.psychology,
    description: 'Complex master game decisions, prophylaxis, and dynamic balance',
  ),
  minigames(
    id: 'minigames',
    label: 'Mini-Game Drills',
    icon: Icons.sports_esports,
    description: '12 interactive drills: Fork Hunter, Pin Builder, Skewer Hunt, King Hunt, Defender, Pawn Battle, Find the Break, Opening Survival, Calculation Tree, Conversion Challenge, Endgame Win/Hold, Worst Piece Improvement',
  );

  final String id;
  final String label;
  final IconData icon;
  final String description;

  const LabCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.description,
  });
}

/// Supported sprint lengths for training banks.
enum SprintLength {
  five(5, '5 Puzzles'),
  ten(10, '10 Puzzles'),
  twenty(20, '20 Puzzles'),
  all(99999, 'All');

  final int count;
  final String label;
  const SprintLength(this.count, this.label);
}

/// Interactive learn-by-doing laboratory screen supporting all training banks,
/// curriculum days, sprint lengths, live accuracy tracking, and summary certification.
class LabsScreen extends StatefulWidget {
  final StorageRepository repository;
  final dynamic initialArgs;
  final void Function(String route, {dynamic args})? onNavigate;

  const LabsScreen({
    super.key,
    required this.repository,
    this.initialArgs,
    this.onNavigate,
  });

  @override
  State<LabsScreen> createState() => _LabsScreenState();
}

class _LabsScreenState extends State<LabsScreen> {
  // Category & Sprint State
  LabCategory _selectedCategory = LabCategory.curriculum;
  int _selectedDayNumber = 1;
  SprintLength _selectedSprintLength = SprintLength.ten;
  int _currentSprintIndex = 0;

  // Exercise State
  List<CurriculumExercise> _bankExercises = [];
  List<CurriculumExercise> _sprintExercises = [];
  int _currentExerciseIndex = 0;

  // Active Session & Move History
  late LabSession _session;
  StreamSubscription<LabSession>? _sessionSubscription;
  final List<PgnMoveNode> _playedMoveNodes = [];
  Square? _lastMoveFrom;
  Square? _lastMoveTo;

  // Session Performance Tracking
  final Map<int, double> _exerciseScores = {};
  final Map<int, int> _exerciseHintsUsed = {};
  final Set<int> _cleanSolves = {};

  @override
  void initState() {
    super.initState();
    _parseInitialArgs();
    _reloadExercises();
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }

  void _parseInitialArgs() {
    if (widget.initialArgs is Map) {
      final args = widget.initialArgs as Map;
      if (args['category'] != null) {
        final catId = args['category'].toString();
        _selectedCategory = LabCategory.values.firstWhere(
          (c) => c.id == catId,
          orElse: () => LabCategory.tactics,
        );
      } else if (args['dayNumber'] != null) {
        _selectedCategory = LabCategory.curriculum;
        _selectedDayNumber = (args['dayNumber'] as int).clamp(1, 90);
      } else if (args['labType'] != null) {
        final lt = args['labType'].toString();
        _selectedCategory = _mapLabTypeToCategory(lt);
      }
    }
  }

  static LabCategory _mapLabTypeToCategory(String labType) {
    switch (labType) {
      case 'tactical_recognition':
      case 'missed_tactic':
      case 'failed_blunder_check':
      case 'tactical':
        return LabCategory.tactics;
      case 'candidate_selection':
      case 'blind_calculation':
      case 'time_management':
        return LabCategory.calculation;
      case 'visualization':
      case 'board_memory':
        return LabCategory.visualization;
      case 'positional_evaluation':
      case 'find_the_plan':
      case 'pawn_structure':
      case 'improve_worst_piece':
      case 'pawn_break':
        return LabCategory.strategy;
      case 'endgame_win_defend':
      case 'conversion_defense':
      case 'conversion_challenge':
        return LabCategory.endgame;
      case 'opening_plan':
        return LabCategory.opening;
      case 'practical_analysis':
        return LabCategory.practical;
      case 'pawn_battle':
      case 'fork_hunter':
      case 'king_hunt':
      case 'opening_challenge':
      case 'defender':
      case 'convert_it':
      case 'hold_the_draw':
      case 'minigames':
        return LabCategory.minigames;
      default:
        return LabCategory.tactics;
    }
  }

  void _reloadExercises() {
    _bankExercises = _loadBankExercises(_selectedCategory);

    // Compute sprint slices
    if (_selectedCategory == LabCategory.curriculum) {
      _sprintExercises = _bankExercises;
      _currentSprintIndex = 0;
    } else {
      final sprintSize = _selectedSprintLength.count;
      final maxSprintIndex = (_bankExercises.length / sprintSize).ceil() - 1;
      _currentSprintIndex = _currentSprintIndex.clamp(0, math.max(0, maxSprintIndex));

      final start = _currentSprintIndex * sprintSize;
      final end = math.min(start + sprintSize, _bankExercises.length);
      _sprintExercises = _bankExercises.sublist(start, end);
    }

    // Check if initialArgs requested a specific exercise
    if (widget.initialArgs is Map && widget.initialArgs['exerciseId'] != null) {
      final targetId = widget.initialArgs['exerciseId'];
      final idxInSprint = _sprintExercises.indexWhere((e) => e.id == targetId);
      if (idxInSprint != -1) {
        _currentExerciseIndex = idxInSprint;
      } else {
        final idxInBank = _bankExercises.indexWhere((e) => e.id == targetId);
        if (idxInBank != -1 && _selectedCategory != LabCategory.curriculum) {
          _currentSprintIndex = idxInBank ~/ _selectedSprintLength.count;
          final sprintSize = _selectedSprintLength.count;
          final start = _currentSprintIndex * sprintSize;
          final end = math.min(start + sprintSize, _bankExercises.length);
          _sprintExercises = _bankExercises.sublist(start, end);
          _currentExerciseIndex = idxInBank - start;
        } else {
          _currentExerciseIndex = 0;
        }
      }
    } else {
      _currentExerciseIndex = 0;
    }

    _exerciseScores.clear();
    _exerciseHintsUsed.clear();
    _cleanSolves.clear();

    if (_sprintExercises.isNotEmpty) {
      _initSessionForCurrentExercise();
    }
  }

  List<CurriculumExercise> _loadBankExercises(LabCategory category) {
    switch (category) {
      case LabCategory.curriculum:
        return CurriculumCatalog.getDay(_selectedDayNumber).exercises;
      case LabCategory.tactics:
        return TacticsBank.all;
      case LabCategory.calculation:
        return CalculationBank.all;
      case LabCategory.visualization:
        return VisualizationBank.all;
      case LabCategory.strategy:
        return StrategyBank.all;
      case LabCategory.endgame:
        return EndgameBank.all;
      case LabCategory.opening:
        return OpeningDrillsBank.all;
      case LabCategory.practical:
        return PracticalAnalysisBank.all;
      case LabCategory.minigames:
        return _getMiniGameExercises();
    }
  }

  static List<CurriculumExercise> _getMiniGameExercises() {
    return const [
      CurriculumExercise(
        id: 'mg_fork_hunter_1',
        fen: 'r3k2r/ppp2ppp/8/3q4/3N4/8/PPP2PPP/R1BQKB1R w KQkq - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Fork Hunter: Force the king with Qe2+ to set up the decisive knight fork.',
        solutionSan: ['Qe2+', 'Kd8', 'Nc6+'],
        explanation: 'Qe2+ forces the king onto the d-file, priming the royal fork on c6.',
        hints: ['Check the uncastled king.', 'Coordinate queen and centralized knight.', 'Play Qe2+.'],
        motif: 'Knight Fork',
      ),
      CurriculumExercise(
        id: 'mg_pin_builder_1',
        fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Pin Builder: Freeze the black knight against the uncastled king.',
        solutionSan: ['Qe2', 'd5', 'd3'],
        explanation: 'Qe2 creates an absolute pin along the e-file; d3 wins the immobilized piece.',
        hints: ['Line up on the open king file.', 'Pin the knight to the e8 king.', 'Qe2 establishes the pin.'],
        motif: 'Absolute Pin',
      ),
      CurriculumExercise(
        id: 'mg_skewer_hunt_1',
        fen: '4k3/8/8/8/8/8/4R3/4K2r w - - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Skewer Hunt: Escape check with discovered check to capture the trailing rook.',
        solutionSan: ['Kd2+', 'Kf7', 'Rxh1'],
        explanation: 'Kd2+ unmasks the e2 rook with check, securing the undefended h1 rook.',
        hints: ['Step the king forward with discovered check.', 'Win the exposed black rook.', 'Play Kd2+.'],
        motif: 'Discovered Skewer',
      ),
      CurriculumExercise(
        id: 'mg_king_hunt_1',
        fen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'King Hunt: Hunt down the uncastled monarch with a direct mating battery.',
        solutionSan: ['Qxf7#'],
        explanation: 'Qxf7# delivers Scholar\'s Mate guarded by the light-squared bishop on c4.',
        hints: ['Find the royal mating square.', 'Target the vulnerable f7 weakness.', 'Play Qxf7# checkmate.'],
        motif: 'Mating Attack',
      ),
      CurriculumExercise(
        id: 'mg_defender_1',
        fen: 'r1b1k2r/pppp1ppp/8/4q3/8/5Q2/PPP2PPP/RNB1KB1R w KQkq - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Defender: Black is delivering a dangerous center check. Shield your king.',
        solutionSan: ['Qe2', 'Qxe2+', 'Bxe2'],
        explanation: 'Offering queen trades diffuses the attacker\'s initiative and neutralizes threats.',
        hints: ['Parry the check by offering a queen trade.', 'Interpose with your queen.', 'Play Qe2.'],
        motif: 'Defensive Simplification',
      ),
      CurriculumExercise(
        id: 'mg_pawn_battle_1',
        fen: '8/5pk1/4p1p1/8/8/5PK1/4P1P1/8 w - - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Pawn Battle: Activate your kingside pawn majority to create an outside passer.',
        solutionSan: ['f4', 'Kf6', 'e4'],
        explanation: 'Advancing f4 and e4 establishes a pawn steamroller that stretches the defending king.',
        hints: ['Advance your majority.', 'The f-pawn leads the charge.', 'Play f4.'],
        motif: 'Pawn Breakthrough',
      ),
      CurriculumExercise(
        id: 'mg_find_the_break_1',
        fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
        sideToPlay: PieceColor.white,
        instruction: 'Find the Break: Blast open central files while Black lingers uncastled.',
        solutionSan: ['d4', 'exd4', 'e5'],
        explanation: 'd4 immediately challenges the center; e5 drives the f6 knight away.',
        hints: ['Strike with the d-pawn.', 'Open lines for your pieces.', 'Play d4.'],
        motif: 'Central Pawn Break',
      ),
      CurriculumExercise(
        id: 'mg_opening_survival_1',
        fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Opening Survival: Complete kingside development and secure king safety.',
        solutionSan: ['O-O', 'Nf6', 'd3'],
        explanation: 'Castling early fulfills the primary objective of the opening: king safety and rook activation.',
        hints: ['King safety first.', 'Castle two squares toward the corner.', 'Play O-O.'],
        motif: 'Opening Discipline',
      ),
      CurriculumExercise(
        id: 'mg_calculation_tree_1',
        fen: '3r2k1/5ppp/8/8/8/8/5PPP/3R2K1 w - - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Calculation Tree: Calculate candidate moves and eliminate the back-rank defender.',
        solutionSan: ['Rxd8#'],
        explanation: 'Rxd8# removes the only defender and delivers back-rank checkmate.',
        hints: ['Liquidate the enemy rook.', 'Exploit the back-rank corridor.', 'Play Rxd8#.'],
        motif: 'Candidate Elimination',
      ),
      CurriculumExercise(
        id: 'mg_conversion_challenge_1',
        fen: 'r4rk1/pp1b1ppp/8/3p4/8/1P1B4/P4PPP/R3R1K1 w - - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Conversion Challenge: Seize the open 7th rank with your rook to begin conversion.',
        solutionSan: ['Re7', 'Rad8', 'Rae1'],
        explanation: 'Placing a rook on the 7th rank paralyzes the opponent\'s minor pieces and targets pawns.',
        hints: ['Dominate the open file.', 'Infiltrate the 7th rank.', 'Play Re7.'],
        motif: 'Advantage Conversion',
      ),
      CurriculumExercise(
        id: 'mg_endgame_win_hold_1',
        fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Endgame Win/Hold: Seize direct vertical opposition to deny the enemy king entry.',
        solutionSan: ['Ke3', 'Kd5', 'Kd3'],
        explanation: 'Ke3 claims vertical opposition, forcing Black to step aside and concede ground.',
        hints: ['Stand on the same file with one square between.', 'Claim opposition.', 'Play Ke3.'],
        motif: 'Vertical Opposition',
      ),
      CurriculumExercise(
        id: 'mg_worst_piece_1',
        fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
        sideToPlay: PieceColor.white,
        instruction: 'Worst Piece Improvement: Develop your passive kingside knight toward the center.',
        solutionSan: ['Nf3', 'Nc6', 'Bc4'],
        explanation: 'Nf3 activates the kingside knight, pressure e5, and prepares kingside castling.',
        hints: ['Knights before bishops.', 'Attack the central e5 pawn.', 'Play Nf3.'],
        motif: 'Harmonious Piece Activation',
      ),
    ];
  }

  void _initSessionForCurrentExercise() {
    _sessionSubscription?.cancel();
    _playedMoveNodes.clear();
    _lastMoveFrom = null;
    _lastMoveTo = null;

    final ex = _sprintExercises[_currentExerciseIndex];

    _session = LabSession(
      id: ex.id,
      title: ex.instruction,
      labType: _selectedCategory.id,
      initialFen: ex.fen,
      solutionSan: ex.solutionSan,
      hints: ex.hints,
      hintConcept: ex.hintConcept,
      hintPiece: ex.hintPiece,
      hintForcing: ex.hintForcing,
      refutationAnalysis: ex.refutationAnalysis,
      explanation: ex.explanation,
      isNoTacticPosition: ex.isNoTacticPosition,
    );

    _sessionSubscription = _session.onUpdate.listen((_) {
      if (mounted) {
        setState(() {});
        if (_session.isCompleted && _session.isSuccess) {
          _recordExerciseCompletion();
        }
      }
    });
  }

  void _onShowBestMove() {
    if (_session.isCompleted || _session.currentSolutionIndex >= _session.solutionSan.length) return;
    final prevBoard = _session.currentBoard.clone();
    final moveSan = _session.showBestMove(penalize: false);
    if (moveSan != null) {
      if (_session.userMoveHistory.isNotEmpty) {
        final lastMove = _session.userMoveHistory.last;
        _lastMoveFrom = lastMove.from;
        _lastMoveTo = lastMove.to;
        _playedMoveNodes.add(PgnMoveNode(
          ply: _playedMoveNodes.length + 1,
          moveNumber: (_playedMoveNodes.length ~/ 2) + 1,
          isWhite: prevBoard.activeColor == PieceColor.white,
          san: moveSan,
          move: lastMove,
        ));
      }
      setState(() {});
    }
  }

  void _onShowLine() {
    if (_session.isCompleted) return;
    _session.showLine();
    _rebuildMoveHistoryFromBoard();
    setState(() {});
  }

  void _rebuildMoveHistoryFromBoard() {
    _playedMoveNodes.clear();
    final tempBoard = Board.fromFen(_session.initialFen);
    for (int i = 0; i < _session.userMoveHistory.length; i++) {
      final m = _session.userMoveHistory[i];
      final isWhite = tempBoard.activeColor == PieceColor.white;
      final san = MoveGenerator.moveToSan(tempBoard, m);
      tempBoard.makeMove(m);
      _playedMoveNodes.add(PgnMoveNode(
        ply: i + 1,
        moveNumber: (i ~/ 2) + 1,
        isWhite: isWhite,
        san: san,
        move: m,
      ));
    }
    if (_session.userMoveHistory.isNotEmpty) {
      _lastMoveFrom = _session.userMoveHistory.last.from;
      _lastMoveTo = _session.userMoveHistory.last.to;
    }
  }

  void _onExplainWhy() {
    final explanation = _session.explainWhy();
    final currentEx = _sprintExercises[_currentExerciseIndex];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.surf,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            const Icon(Icons.psychology, color: ChessTheme.primaryLight, size: 22),
            const SizedBox(width: 8),
            Text(
              'Grandmaster Explanation',
              style: TextStyle(color: context.txt, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ChessTheme.accentGold.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: ChessTheme.accentGold.withAlpha(80)),
                ),
                child: Text(
                  'Motif: ${currentEx.motif}',
                  style: const TextStyle(color: ChessTheme.accentGold, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                explanation,
                style: TextStyle(color: context.txt, fontSize: 13, height: 1.45),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got It', style: TextStyle(color: ChessTheme.primaryLight)),
          ),
        ],
      ),
    );
  }

  void _onReplay() {
    final moves = List<Move>.from(_session.userMoveHistory);
    if (moves.isEmpty) return;
    _session.reset();
    _playedMoveNodes.clear();
    _lastMoveFrom = null;
    _lastMoveTo = null;
    setState(() {});

    int step = 0;
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (!mounted || step >= moves.length) {
        timer.cancel();
        return;
      }
      final m = moves[step];
      final prevBoard = _session.currentBoard.clone();
      final san = MoveGenerator.moveToSan(prevBoard, m);
      _session.currentBoard.makeMove(m);
      _session.userMoveHistory.add(m);
      _lastMoveFrom = m.from;
      _lastMoveTo = m.to;
      _playedMoveNodes.add(PgnMoveNode(
        ply: step + 1,
        moveNumber: (step ~/ 2) + 1,
        isWhite: prevBoard.activeColor == PieceColor.white,
        san: san,
        move: m,
      ));
      step++;
      setState(() {});
    });
  }

  void _recordExerciseCompletion() {
    if (!_exerciseScores.containsKey(_currentExerciseIndex)) {
      _exerciseScores[_currentExerciseIndex] = _session.score;
      _exerciseHintsUsed[_currentExerciseIndex] = _session.hintsRevealed;
      if (_session.score >= 99.9 && _session.hintsRevealed == 0) {
        _cleanSolves.add(_currentExerciseIndex);
      }
    }

    // Check if entire sprint completed
    if (_currentExerciseIndex == _sprintExercises.length - 1) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _showSprintSummaryDialog();
      });
    }
  }

  void _onMovePlayed(Move move) {
    if (_session.isCompleted) return;

    final prevBoard = _session.currentBoard.clone();
    final userSan = MoveGenerator.moveToSan(prevBoard, move);

    final stepResult = _session.playMove(move);

    if (stepResult == LabStepResult.incorrect) {
      // Blunder/suboptimal move rejected; board remains intact
      setState(() {});
      return;
    }

    // User move was correct
    _lastMoveFrom = move.from;
    _lastMoveTo = move.to;

    _playedMoveNodes.add(PgnMoveNode(
      ply: _playedMoveNodes.length + 1,
      moveNumber: (_playedMoveNodes.length ~/ 2) + 1,
      isWhite: prevBoard.activeColor == PieceColor.white,
      san: userSan,
      move: move,
    ));

    // Handle opponent reply if auto-played by LabSession
    if (_session.currentBoard.history.length > prevBoard.history.length + 1) {
      final oppRecord = _session.currentBoard.history.last;
      final oppMove = oppRecord.move;
      final oppSan = _session.solutionSan[_session.currentSolutionIndex - 1];

      _lastMoveFrom = oppMove.from;
      _lastMoveTo = oppMove.to;

      _playedMoveNodes.add(PgnMoveNode(
        ply: _playedMoveNodes.length + 1,
        moveNumber: (_playedMoveNodes.length ~/ 2) + 1,
        isWhite: !(_playedMoveNodes.last.isWhite),
        san: oppSan,
        move: oppMove,
      ));
    }

    if (_session.isCompleted) {
      _recordExerciseCompletion();
    }

    setState(() {});
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _sprintExercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _initSessionForCurrentExercise();
      });
    }
  }

  void _prevExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
        _initSessionForCurrentExercise();
      });
    }
  }

  void _restartSprint() {
    setState(() {
      _currentExerciseIndex = 0;
      _exerciseScores.clear();
      _exerciseHintsUsed.clear();
      _cleanSolves.clear();
      _initSessionForCurrentExercise();
    });
  }

  void _nextSprint() {
    final sprintSize = _selectedSprintLength.count;
    final maxSprint = (_bankExercises.length / sprintSize).ceil() - 1;
    if (_currentSprintIndex < maxSprint) {
      setState(() {
        _currentSprintIndex++;
        final start = _currentSprintIndex * sprintSize;
        final end = math.min(start + sprintSize, _bankExercises.length);
        _sprintExercises = _bankExercises.sublist(start, end);
        _restartSprint();
      });
    }
  }

  void _showSprintSummaryDialog() {
    final total = _sprintExercises.length;
    final solvedCount = _exerciseScores.length;
    final cleanCount = _cleanSolves.length;
    final avgScore = solvedCount > 0
        ? _exerciseScores.values.reduce((a, b) => a + b) / solvedCount
        : 0.0;
    final totalHints = _exerciseHintsUsed.values.fold<int>(0, (a, b) => a + b);

    final maxSprint = _selectedCategory == LabCategory.curriculum
        ? 0
        : (_bankExercises.length / _selectedSprintLength.count).ceil() - 1;
    final hasNextSprint = _currentSprintIndex < maxSprint;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: context.surf,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: context.brd),
          ),
          title: Row(
            children: [
              const Icon(Icons.emoji_events, color: ChessTheme.accentGold, size: 28),
              const SizedBox(width: 10),
              Text(
                'Sprint Complete!',
                style: TextStyle(color: context.txt, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_selectedCategory.label} • ${_selectedCategory == LabCategory.curriculum ? "Day $_selectedDayNumber" : "Sprint ${_currentSprintIndex + 1}"}',
                style: TextStyle(color: context.txtSec, fontSize: 13),
              ),
              const SizedBox(height: 16),
              _buildStatRow(Icons.check_circle_outline, 'Overall Accuracy', '${avgScore.round()}%',
                  avgScore >= 80 ? ChessTheme.primaryLight : ChessTheme.accentGold),
              const SizedBox(height: 10),
              _buildStatRow(Icons.verified, 'Clean Solves (100%)', '$cleanCount / $total',
                  ChessTheme.primaryLight),
              const SizedBox(height: 10),
              _buildStatRow(Icons.lightbulb_outline, 'Hints Used', '$totalHints',
                  totalHints == 0 ? ChessTheme.primaryLight : context.txtSec),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                _restartSprint();
              },
              child: const Text('Practice Again'),
            ),
            if (hasNextSprint)
              ElevatedButton.icon(
                icon: const Icon(Icons.skip_next, size: 16),
                label: const Text('Next Sprint'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChessTheme.primary,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(dialogCtx);
                  _nextSprint();
                },
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChessTheme.primary,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(dialogCtx),
                child: const Text('Close'),
              ),
          ],
        );
      },
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color valColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: valColor),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: context.txtSec, fontSize: 13)),
        const Spacer(),
        Text(
          value,
          style: TextStyle(color: valColor, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  static int _getAnimationDurationMs(String speed) {
    switch (speed) {
      case 'instant':
        return 0;
      case 'fast':
        return 150;
      case 'learning':
        return 500;
      case 'normal':
      default:
        return 250;
    }
  }

  Board _getDisplayBoard() {
    if (_session.mode == LabMode.demo) {
      final step = _session.pedagogyEngine.currentDemoStep;
      if (step != null && step.animatedMove != null) {
        final demoBoard = Board.fromFen(_session.initialFen);
        demoBoard.makeMove(step.animatedMove!);
        return demoBoard;
      }
      return Board.fromFen(_session.initialFen);
    }
    return _session.currentBoard;
  }

  List<Square> _getDisplayHighlights() {
    if (_session.mode == LabMode.demo) {
      return _session.pedagogyEngine.currentDemoStep?.highlightedSquares ?? [];
    } else if (_session.mode == LabMode.guided) {
      return _session.pedagogyEngine.currentSocraticStep?.highlightedSquares ?? [];
    } else if (_session.mode == LabMode.practice) {
      if (_session.hintsRevealed >= 2 && _session.candidatePieceSquare != null) {
        return [_session.candidatePieceSquare!];
      }
    }
    return [];
  }

  List<BoardArrow> _getDisplayArrows() {
    if (_session.mode == LabMode.demo) {
      final arrows = _session.pedagogyEngine.currentDemoStep?.arrows ?? [];
      return arrows.map((a) {
        Color c = const Color(0xCC22C55E);
        if (a.colorHex.startsWith('#EF')) c = const Color(0xCCEF4444);
        if (a.colorHex.startsWith('#F5')) c = const Color(0xCCF59E0B);
        return BoardArrow(from: a.from, to: a.to, color: c);
      }).toList();
    } else if (_session.mode == LabMode.guided) {
      final arrows = _session.pedagogyEngine.currentSocraticStep?.arrows ?? [];
      return arrows.map((a) => BoardArrow(from: a.from, to: a.to, color: const Color(0xCC22C55E))).toList();
    } else if (_session.mode == LabMode.practice) {
      if (_session.hintsRevealed >= 3 && _session.candidatePieceSquare != null && _session.candidateTargetSquare != null) {
        return [BoardArrow(from: _session.candidatePieceSquare!, to: _session.candidateTargetSquare!, color: const Color(0xCC22C55E))];
      }
    }
    return [];
  }

  void _onSocraticCandidateSelected(String san) {
    if (_session.pedagogyEngine.validateSocraticMove(san)) {
      final move = MoveGenerator.sanToMove(_session.currentBoard, san);
      if (move != null) {
        _onMovePlayed(move);
      }
    }
    setState(() {});
  }

  void _showCognitiveDecisionTreeDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surf,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.psychology, color: ChessTheme.primaryLight, size: 22),
            SizedBox(width: 8),
            Text('Grandmaster Cognitive Thinking Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: CognitiveStage.values.map((stage) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: ChessTheme.primary.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${stage.index + 1}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(stage.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ctx.txt)),
                            const SizedBox(height: 2),
                            Text(stage.description, style: TextStyle(fontSize: 11, color: ctx.txtSec)),
                            const SizedBox(height: 2),
                            Text('💡 GM Tip: ${stage.gmTip}', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: ChessTheme.accentGold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Apply in Practice', style: TextStyle(color: ChessTheme.primaryLight)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sprintExercises.isEmpty) {
      return Scaffold(
        backgroundColor: context.bg,
        body: Center(
          child: Text('No exercises found in this category.', style: TextStyle(color: context.txtSec)),
        ),
      );
    }

    final currentEx = _sprintExercises[_currentExerciseIndex];
    final profile = widget.repository.getProfile();
    final boardTheme = ChessBoardTheme.fromName(profile.boardThemeName);
    final pieceTheme = PieceTheme.fromName(profile.pieceThemeName);
    final displayBoard = _getDisplayBoard();
    final displayHighlights = _getDisplayHighlights();
    final displayArrows = _getDisplayArrows();

    return Scaffold(
      backgroundColor: context.bg,
      body: ResponsiveChessWorkspace(
        initialScale: profile.boardScaleMultiplier,
        initialSidePanelCollapsed: profile.sidePanelCollapsed,
        onScaleChanged: (scale) {
          profile.boardScaleMultiplier = scale;
          widget.repository.saveProfile(profile);
        },
        onSidePanelToggled: (collapsed) {
          profile.sidePanelCollapsed = collapsed;
          widget.repository.saveProfile(profile);
        },
        header: Column(
          children: [
            _buildHeaderBar(context, currentEx),
            _buildModeSelectorBar(context),
            _buildInstructionBanner(context, currentEx),
          ],
        ),
        boardBuilder: (context, boardSize) {
          return ChessBoardWidget(
            board: displayBoard,
            isFlipped: currentEx.sideToPlay == PieceColor.black,
            onMovePlayed: (_session.mode == LabMode.demo) ? null : _onMovePlayed,
            isInteractive: _session.mode != LabMode.demo && !_session.isCompleted,
            lastMoveFrom: _lastMoveFrom,
            lastMoveTo: _lastMoveTo,
            boardTheme: boardTheme,
            pieceTheme: pieceTheme,
            animationDurationMs: _getAnimationDurationMs(profile.animationSpeed),
            showCoordinates: profile.showCoordinates,
            showMoveHighlights: profile.showMoveHighlights,
            showLegalMoveHints: profile.showLegalMoveHints,
            highlightedSquares: displayHighlights,
            arrows: displayArrows,
          );
        },
        footer: _buildPedagogicalFooter(context, currentEx),
        sidePanel: _buildPedagogicalSidePanel(context, currentEx),
      ),
    );
  }

  Widget _buildHeaderBar(BuildContext context, CurriculumExercise currentEx) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.brd),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          // Category Picker
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 160, maxWidth: 220),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<LabCategory>(
                isExpanded: true,
                value: _selectedCategory,
                dropdownColor: context.surf,
                icon: const Icon(Icons.arrow_drop_down, color: ChessTheme.primary),
                items: LabCategory.values.map((cat) {
                  return DropdownMenuItem<LabCategory>(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(cat.icon, size: 16, color: ChessTheme.primaryLight),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cat.label,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: context.txt, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (cat) {
                  if (cat != null && cat != _selectedCategory) {
                    setState(() {
                      _selectedCategory = cat;
                      _currentSprintIndex = 0;
                      _reloadExercises();
                    });
                  }
                },
              ),
            ),
          ),

          // Curriculum Day / Sprint Index
          if (_selectedCategory == LabCategory.curriculum)
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 160, maxWidth: 240),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _selectedDayNumber,
                  dropdownColor: context.surf,
                  icon: const Icon(Icons.arrow_drop_down, color: ChessTheme.primary),
                  items: List.generate(90, (i) => i + 1).map((day) {
                    return DropdownMenuItem<int>(
                      value: day,
                      child: Text(
                        'Day $day: ${CurriculumCatalog.getDay(day).title}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: context.txt, fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (day) {
                    if (day != null && day != _selectedDayNumber) {
                      setState(() {
                        _selectedDayNumber = day;
                        _reloadExercises();
                      });
                    }
                  },
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 110, maxWidth: 130),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<SprintLength>(
                      isExpanded: true,
                      value: _selectedSprintLength,
                      dropdownColor: context.surf,
                      icon: const Icon(Icons.tune, size: 14, color: ChessTheme.primary),
                      items: SprintLength.values.map((sl) {
                        return DropdownMenuItem<SprintLength>(
                          value: sl,
                          child: Text(sl.label, style: TextStyle(color: context.txt, fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (sl) {
                        if (sl != null && sl != _selectedSprintLength) {
                          setState(() {
                            _selectedSprintLength = sl;
                            _currentSprintIndex = 0;
                            _reloadExercises();
                          });
                        }
                      },
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 130, maxWidth: 160),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: _currentSprintIndex,
                      dropdownColor: context.surf,
                      icon: const Icon(Icons.arrow_drop_down, color: ChessTheme.primary),
                      items: List.generate(
                        (_bankExercises.length / _selectedSprintLength.count).ceil(),
                        (i) => i,
                      ).map((idx) {
                        final start = idx * _selectedSprintLength.count + 1;
                        final end = math.min((idx + 1) * _selectedSprintLength.count, _bankExercises.length);
                        return DropdownMenuItem<int>(
                          value: idx,
                          child: Text('Sprint ${idx + 1} ($start–$end)', style: TextStyle(color: context.txt, fontSize: 13)),
                        );
                      }).toList(),
                      onChanged: (idx) {
                        if (idx != null && idx != _currentSprintIndex) {
                          setState(() {
                            _currentSprintIndex = idx;
                            _reloadExercises();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

          // Live Performance Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: context.surfLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, size: 14, color: ChessTheme.accentGold),
                const SizedBox(width: 4),
                Text(
                  'Solved: ${_exerciseScores.length}/${_sprintExercises.length}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txt),
                ),
                const SizedBox(width: 8),
                Text(
                  'Score: ${_session.score.round()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _session.score >= 80 ? ChessTheme.primaryLight : ChessTheme.accentGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelectorBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.brd),
      ),
      child: Row(
        children: [
          const Icon(Icons.school, size: 16, color: ChessTheme.primaryLight),
          const SizedBox(width: 8),
          Text(
            'PEDAGOGY MODE:',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: context.txtMut),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: LabMode.values.map((m) {
                  final isSelected = _session.mode == m;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        m.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.black : context.txt,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: ChessTheme.primary,
                      backgroundColor: context.surfLight,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _session.setMode(m);
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionBanner(BuildContext context, CurriculumExercise currentEx) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _session.isCompleted
              ? (_session.isSuccess ? ChessTheme.primary : ChessTheme.qualityBlunder)
              : context.brd,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _session.mode == LabMode.demo
                ? Icons.smart_toy
                : (_session.mode == LabMode.guided ? Icons.contact_support : Icons.lightbulb_outline),
            size: 16,
            color: ChessTheme.primaryLight,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _session.feedbackMessage ?? currentEx.instruction,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _session.isSuccess ? ChessTheme.primaryLight : context.txt,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ChessTheme.accentGold.withAlpha(20),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: ChessTheme.accentGold.withAlpha(60)),
                  ),
                  child: Text(
                    currentEx.motif,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ChessTheme.accentGold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPedagogicalFooter(BuildContext context, CurriculumExercise currentEx) {
    switch (_session.mode) {
      case LabMode.demo:
        return _buildDemoTeacherControls(context);
      case LabMode.guided:
        return _buildGuidedSocraticControls(context);
      case LabMode.practice:
        return _buildPracticeControls(context, currentEx);
      case LabMode.challenge:
        return _buildChallengeControls(context, currentEx);
      case LabMode.review:
        return _buildReviewControls(context, currentEx);
    }
  }

  Widget _buildDemoTeacherControls(BuildContext context) {
    final engine = _session.pedagogyEngine;
    final step = engine.currentDemoStep;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ChessTheme.primaryLight.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.school, size: 18, color: ChessTheme.primaryLight),
              const SizedBox(width: 8),
              Text(
                step?.title ?? 'Autonomous Demonstration',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ChessTheme.primaryLight),
              ),
              const Spacer(),
              Text(
                'Step ${(step?.stepIndex ?? 1)} of ${engine.demoSteps.length}',
                style: TextStyle(fontSize: 11, color: context.txtSec, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            step?.caption ?? 'Observe the board structure and critical motifs.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.txt),
          ),
          const SizedBox(height: 4),
          Text(
            'Why this works: ${step?.explanationWhy ?? ""}',
            style: TextStyle(fontSize: 11, color: context.txtSec),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.replay, size: 14),
                label: const Text('Restart Demo'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                onPressed: () {
                  setState(() => engine.resetDemo());
                },
              ),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back, size: 14),
                    label: const Text('Prev'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                    onPressed: engine.currentDemoIndex > 0
                        ? () {
                            setState(() => engine.prevDemoStep());
                          }
                        : null,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward, size: 14),
                    label: Text(engine.isDemoFinished ? 'Switch to Guided' : 'Next Step'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ChessTheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    ),
                    onPressed: () {
                      if (engine.isDemoFinished) {
                        setState(() => _session.setMode(LabMode.guided));
                      } else {
                        setState(() => engine.nextDemoStep());
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuidedSocraticControls(BuildContext context) {
    final engine = _session.pedagogyEngine;
    final step = engine.currentSocraticStep;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ChessTheme.accentGold.withAlpha(80)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.help_center_outlined, size: 18, color: ChessTheme.accentGold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Socratic Discovery: ${step?.conceptTitle ?? "Finding the Weakness"}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ChessTheme.accentGold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Checkpoint ${(engine.currentSocraticIndex + 1)} of ${engine.socraticSteps.length}',
                style: TextStyle(fontSize: 11, color: context.txtSec, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            step?.prompt ?? 'Follow Socratic questions to discover the move independently.',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.txt),
          ),
          if (step != null && step.hint.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '💡 Hint: ${step.hint}',
              style: TextStyle(fontSize: 11, color: context.txtSec),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (step != null && step.candidateMovesSan.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: step.candidateMovesSan.map((san) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChessTheme.primaryLight.withAlpha(30),
                        foregroundColor: ChessTheme.primaryLight,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      ),
                      onPressed: () => _onSocraticCandidateSelected(san),
                      child: Text('Play $san'),
                    );
                  }).toList(),
                )
              else
                Text(
                  'Tap the target square or piece directly on the board.',
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: context.txtMut),
                ),
              ElevatedButton.icon(
                icon: const Icon(Icons.check, size: 14),
                label: Text(engine.isSocraticFinished ? 'Practice Now' : 'Advance Checkpoint'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChessTheme.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onPressed: () {
                  if (engine.isSocraticFinished) {
                    setState(() => _session.setMode(LabMode.practice));
                  } else {
                    setState(() => engine.advanceSocratic());
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeControls(BuildContext context, CurriculumExercise currentEx) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        // Progressive Hint (H1 Concept -> H2 Piece -> H3 Forcing Clue)
        ElevatedButton.icon(
          icon: const Icon(Icons.lightbulb_outline, size: 15),
          label: Text(
            _session.hintsRevealed == 0
                ? 'Hint (H1/H2/H3)'
                : 'Next Hint (${_session.hintsRevealed}/${currentEx.tieredHints.length})',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.surf,
            foregroundColor: ChessTheme.accentGold,
            side: const BorderSide(color: ChessTheme.accentGold),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: _session.hintsRevealed < currentEx.tieredHints.length
              ? () => _session.requestTieredHint(penalize: false)
              : null,
        ),

        // Cognitive Method Modal Trigger
        OutlinedButton.icon(
          icon: const Icon(Icons.psychology, size: 15),
          label: const Text('GM Thinking Method'),
          style: OutlinedButton.styleFrom(
            foregroundColor: ChessTheme.primaryLight,
            side: const BorderSide(color: ChessTheme.primaryLight),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: _showCognitiveDecisionTreeDialog,
        ),

        // Show Move
        ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow_outlined, size: 15),
          label: const Text('Show Move'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.surf,
            foregroundColor: ChessTheme.primaryLight,
            side: const BorderSide(color: ChessTheme.primaryLight),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: !_session.isCompleted ? _onShowBestMove : null,
        ),

        // Show Line
        ElevatedButton.icon(
          icon: const Icon(Icons.fast_forward_outlined, size: 15),
          label: const Text('Show Line'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.surf,
            foregroundColor: const Color(0xFF60A5FA),
            side: const BorderSide(color: Color(0xFF60A5FA)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: !_session.isCompleted ? _onShowLine : null,
        ),

        // Explain Why
        ElevatedButton.icon(
          icon: const Icon(Icons.psychology_outlined, size: 15),
          label: const Text('Explain Why'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.surf,
            foregroundColor: const Color(0xFFA78BFA),
            side: const BorderSide(color: Color(0xFFA78BFA)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: _onExplainWhy,
        ),

        // Reset
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh, size: 15),
          label: const Text('Reset'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.surfLight,
            foregroundColor: context.txt,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: () {
            _session.reset();
            _playedMoveNodes.clear();
            _lastMoveFrom = null;
            _lastMoveTo = null;
            setState(() {});
          },
        ),

        // Replay
        ElevatedButton.icon(
          icon: const Icon(Icons.replay, size: 15),
          label: const Text('Replay'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.surfLight,
            foregroundColor: context.txt,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          onPressed: _session.userMoveHistory.isNotEmpty ? _onReplay : null,
        ),

        // Navigation
        if (_currentExerciseIndex > 0)
          OutlinedButton(
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            onPressed: _prevExercise,
            child: const Text('Previous'),
          ),

        if (_currentExerciseIndex < _sprintExercises.length - 1)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _session.isCompleted ? ChessTheme.primary : context.surfLight,
              foregroundColor: _session.isCompleted ? Colors.black : context.txt,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: _nextExercise,
            child: const Text('Next Exercise'),
          ),
      ],
    );
  }

  Widget _buildChallengeControls(BuildContext context, CurriculumExercise currentEx) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.withAlpha(80)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.timer, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              Text('Scored Challenge Mode — No Hints', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: context.txt)),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (currentEx.isNoTacticPosition)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: ChessTheme.secondary, foregroundColor: Colors.black),
                  onPressed: !_session.isCompleted ? () => _session.declareNoTactic() : null,
                  child: const Text('Declare "No Tactic"'),
                ),
              OutlinedButton(
                onPressed: () {
                  setState(() => _session.setMode(LabMode.review));
                },
                child: const Text('Reveal & Review'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewControls(BuildContext context, CurriculumExercise currentEx) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA78BFA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.fact_check, color: Color(0xFFA78BFA), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Forensic Review: Solution is ${currentEx.solutionSan.join(" ")}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFA78BFA))),
                const SizedBox(height: 2),
                Text(currentEx.explanation, style: TextStyle(fontSize: 11, color: context.txtSec)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ChessTheme.primary, foregroundColor: Colors.black),
            onPressed: () {
              setState(() => _session.setMode(LabMode.practice));
            },
            child: const Text('Practice Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildPedagogicalSidePanel(BuildContext context, CurriculumExercise currentEx) {
    final sprintSteps = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_sprintExercises.length, (i) {
          final isCurrent = i == _currentExerciseIndex;
          final isSolved = _exerciseScores.containsKey(i);
          final isClean = _cleanSolves.contains(i);

          Color bgColor = context.surfLight;
          Color fgColor = context.txtSec;
          if (isClean) {
            bgColor = ChessTheme.primary.withAlpha(50);
            fgColor = ChessTheme.primaryLight;
          } else if (isSolved) {
            bgColor = ChessTheme.accentGold.withAlpha(50);
            fgColor = ChessTheme.accentGold;
          } else if (isCurrent) {
            bgColor = ChessTheme.primary;
            fgColor = Colors.black;
          }

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: () {
                setState(() {
                  _currentExerciseIndex = i;
                  _initSessionForCurrentExercise();
                });
              },
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isCurrent ? ChessTheme.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '${i + 1}',
                  style: TextStyle(color: fgColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                'Exercise ${_currentExerciseIndex + 1} of ${_sprintExercises.length}',
                style: const TextStyle(fontSize: 12, color: ChessTheme.primaryLight, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: currentEx.sideToPlay == PieceColor.white ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: context.brd),
                ),
                child: Text(
                  currentEx.sideToPlay == PieceColor.white ? 'White to move' : 'Black to move',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: currentEx.sideToPlay == PieceColor.white ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          sprintSteps,
          const SizedBox(height: 12),
          Text(
            currentEx.instruction,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.txt),
          ),
          const SizedBox(height: 4),
          Text('Theme: ${currentEx.motif}', style: TextStyle(fontSize: 11, color: context.txtSec)),
          if (_session.isCompleted && _session.isSuccess) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ChessTheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ChessTheme.primary.withAlpha(75)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, size: 16, color: ChessTheme.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Master Solution: ${currentEx.solutionSan.join(" ")}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ChessTheme.primaryLight,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentEx.explanation,
                    style: TextStyle(fontSize: 12, color: context.txt),
                  ),
                ],
              ),
            ),
          ],
          const Divider(height: 20),

          // Cognitive GM checklist
          const Text('Grandmaster Thinking Steps', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ChessTheme.accentGold)),
          const SizedBox(height: 6),
          ..._session.pedagogyEngine.cognitiveChecklist.map((step) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_box_outline_blank, size: 14, color: ChessTheme.primaryLight),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.stage.title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txt)),
                        Text(step.observation, style: TextStyle(fontSize: 10, color: context.txtSec)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const Divider(height: 20),
          const Text('Move Notation Tree', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 160,
            child: MoveListWidget(
              moves: _playedMoveNodes,
              currentPlyIndex: _playedMoveNodes.length,
            ),
          ),
        ],
      ),
    );
  }
}

