import 'dart:async';
import 'dart:math' as math;
import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/board_size_policy.dart';
import '../theme/chess_board_theme.dart';
import '../theme/chess_theme.dart';
import '../theme/piece_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/move_list_widget.dart';

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
    }
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

    return Scaffold(
      backgroundColor: context.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 900;
          final evalBarSpacing = isCompact ? 8.0 : 12.0;
          const evalBarWidth = 28.0;
          final boardSize = BoardSizePolicy.calculateBoardSize(
            constraints: constraints,
            mode: isCompact ? BoardSizeMode.compact : BoardSizeMode.standard,
            hasEvaluationBar: true,
            evalBarWidth: evalBarWidth + evalBarSpacing,
            verticalPadding: 260.0,
          );

          // Top Header Bar with Category, Day/Sprint & Live Performance
          final headerBar = Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: context.surf,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.brd),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                // Category Picker
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 160,
                    maxWidth: isCompact ? math.max(160, constraints.maxWidth - 48) : 220,
                  ),
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
                                  style: TextStyle(
                                    color: context.txt,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
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

                // Curriculum Day selector OR Sprint Length & Index selector
                if (_selectedCategory == LabCategory.curriculum)
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 160,
                      maxWidth: isCompact ? math.max(160, constraints.maxWidth - 48) : 260,
                    ),
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
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      // Sprint Length
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
                                child: Text(
                                  sl.label,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: context.txt, fontSize: 13),
                                ),
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
                      // Sprint index selector
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
                                child: Text(
                                  'Sprint ${idx + 1} ($start–$end)',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: context.txt, fontSize: 13),
                                ),
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

                // Live Sprint Stats Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: context.surfLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars, size: 14, color: ChessTheme.accentGold),
                          const SizedBox(width: 4),
                          Text(
                            'Solved: ${_exerciseScores.length}/${_sprintExercises.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: context.txt,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Score: ${_session.score.round()}%',
                        style: TextStyle(
                          fontSize: 12,
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

          // Instruction / Feedback Banner
          final instructionBanner = Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: context.surf,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _session.isCompleted
                    ? (_session.isSuccess ? ChessTheme.primary : ChessTheme.qualityBlunder)
                    : context.brd,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _session.isCompleted
                      ? (_session.isSuccess ? Icons.check_circle : Icons.cancel)
                      : Icons.help_outline,
                  color: _session.isCompleted
                      ? (_session.isSuccess ? ChessTheme.primary : ChessTheme.qualityBlunder)
                      : context.txtSec,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _session.feedbackMessage ?? currentEx.instruction,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _session.isSuccess ? ChessTheme.primaryLight : context.txt,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.surfLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Score: ${_session.score.round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _session.score >= 80 ? ChessTheme.primaryLight : ChessTheme.accentGold,
                    ),
                  ),
                ),
              ],
            ),
          );

          // Interactive Chess Board Area (Clean, board-first layout)
          final boardArea = FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: boardSize,
              height: boardSize,
              child: ChessBoardWidget(
                board: _session.currentBoard,
                isFlipped: currentEx.sideToPlay == PieceColor.black,
                onMovePlayed: _onMovePlayed,
                isInteractive: !_session.isCompleted,
                lastMoveFrom: _lastMoveFrom,
                lastMoveTo: _lastMoveTo,
                boardTheme: ChessBoardTheme.fromName(profile.boardThemeName),
                pieceTheme: PieceTheme.fromName(profile.pieceThemeName),
                animationDurationMs: _getAnimationDurationMs(profile.animationSpeed),
                showCoordinates: profile.showCoordinates,
                showMoveHighlights: profile.showMoveHighlights,
                showLegalMoveHints: profile.showLegalMoveHints,
              ),
            ),
          );

          // Interactive Action Buttons (Learning-first pedagogical workflow)
          final actionButtons = Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // Tiered Hint (H1 Concept -> H2 Candidate Piece -> H3 Forcing Clue)
              ElevatedButton.icon(
                icon: const Icon(Icons.lightbulb_outline, size: 16),
                label: Text(
                  _session.hintsRevealed == 0
                      ? 'Hint (H1/H2/H3)'
                      : 'Next Hint (${_session.hintsRevealed}/${currentEx.tieredHints.length})',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.surf,
                  foregroundColor: ChessTheme.accentGold,
                  side: const BorderSide(color: ChessTheme.accentGold),
                ),
                onPressed: _session.hintsRevealed < currentEx.tieredHints.length
                    ? () => _session.requestTieredHint(penalize: false)
                    : null,
              ),

              // Show Move
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow_outlined, size: 16),
                label: const Text('Show Move'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.surf,
                  foregroundColor: ChessTheme.primaryLight,
                  side: const BorderSide(color: ChessTheme.primaryLight),
                ),
                onPressed: !_session.isCompleted ? _onShowBestMove : null,
              ),

              // Show Solution Line
              ElevatedButton.icon(
                icon: const Icon(Icons.fast_forward_outlined, size: 16),
                label: const Text('Show Line'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.surf,
                  foregroundColor: const Color(0xFF60A5FA),
                  side: const BorderSide(color: Color(0xFF60A5FA)),
                ),
                onPressed: !_session.isCompleted ? _onShowLine : null,
              ),

              // Grandmaster Explain Why
              ElevatedButton.icon(
                icon: const Icon(Icons.psychology_outlined, size: 16),
                label: const Text('Explain Why'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.surf,
                  foregroundColor: const Color(0xFFA78BFA),
                  side: const BorderSide(color: Color(0xFFA78BFA)),
                ),
                onPressed: _onExplainWhy,
              ),

              // Replay
              if (_session.userMoveHistory.isNotEmpty)
                ElevatedButton.icon(
                  icon: const Icon(Icons.replay, size: 16),
                  label: const Text('Replay'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.surfLight,
                    foregroundColor: context.txt,
                  ),
                  onPressed: _onReplay,
                ),

              // Contextual "No Tactic" - ONLY visible when current exercise is actually a "No Tactic" position!
              if (currentEx.isNoTacticPosition)
                ElevatedButton.icon(
                  icon: const Icon(Icons.shield_outlined, size: 16),
                  label: const Text('Declare "No Tactic"'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.surf,
                    foregroundColor: ChessTheme.secondary,
                    side: const BorderSide(color: ChessTheme.secondary),
                  ),
                  onPressed: !_session.isCompleted ? () => _session.declareNoTactic() : null,
                ),

              // Reset / Retry
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.surfLight,
                  foregroundColor: context.txt,
                ),
                onPressed: () {
                  _session.reset();
                  _playedMoveNodes.clear();
                  _lastMoveFrom = null;
                  _lastMoveTo = null;
                  setState(() {});
                },
              ),

              if (_currentExerciseIndex > 0)
                OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back, size: 16),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.txt,
                    side: BorderSide(color: context.brd),
                  ),
                  onPressed: _prevExercise,
                ),

              if (_currentExerciseIndex < _sprintExercises.length - 1)
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Next Exercise'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _session.isCompleted ? ChessTheme.primary : context.surfLight,
                    foregroundColor: _session.isCompleted ? Colors.black : context.txt,
                  ),
                  onPressed: _nextExercise,
                ),

              if (_session.isCompleted && _currentExerciseIndex == _sprintExercises.length - 1)
                ElevatedButton.icon(
                  icon: const Icon(Icons.emoji_events, size: 16),
                  label: const Text('View Summary'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ChessTheme.accentGold,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _showSprintSummaryDialog,
                ),
            ],
          );

          // Sprint Step Navigator & Meta Panel
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
                  bgColor = ChessTheme.primary.withValues(alpha: 0.2);
                  fgColor = ChessTheme.primaryLight;
                } else if (isSolved) {
                  bgColor = ChessTheme.accentGold.withValues(alpha: 0.2);
                  fgColor = ChessTheme.accentGold;
                } else if (isCurrent) {
                  bgColor = ChessTheme.primary;
                  fgColor = Colors.black;
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() {
                        _currentExerciseIndex = i;
                        _initSessionForCurrentExercise();
                      });
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isCurrent ? ChessTheme.primary : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: fgColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );

          final metaPanel = Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surf,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.brd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Exercise ${_currentExerciseIndex + 1} of ${_sprintExercises.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: ChessTheme.primaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: currentEx.sideToPlay == PieceColor.white ? Colors.white : Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: context.brd),
                      ),
                      child: Text(
                        currentEx.sideToPlay == PieceColor.white ? 'White to move' : 'Black to move',
                        style: TextStyle(
                          fontSize: 11,
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.txt),
                ),
                const SizedBox(height: 6),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  children: [
                    Icon(Icons.category, size: 14, color: context.txtSec),
                    Text(
                      'Theme: ${currentEx.motif}',
                      style: TextStyle(fontSize: 12, color: context.txtSec),
                    ),
                  ],
                ),
                if (_session.isCompleted && _session.isSuccess) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ChessTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ChessTheme.primary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            const Icon(Icons.check_circle, size: 16, color: ChessTheme.primary),
                            Text(
                              'Master Solution: ${currentEx.solutionSan.join(" ")}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: ChessTheme.primaryLight,
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
              ],
            ),
          );

          if (isCompact) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  headerBar,
                  instructionBanner,
                  boardArea,
                  const SizedBox(height: 16),
                  actionButtons,
                  const SizedBox(height: 16),
                  metaPanel,
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: MoveListWidget(
                      moves: _playedMoveNodes,
                      currentPlyIndex: _playedMoveNodes.length,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                headerBar,
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            instructionBanner,
                            Expanded(child: Center(child: boardArea)),
                            const SizedBox(height: 16),
                            actionButtons,
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            metaPanel,
                            const SizedBox(height: 16),
                            Expanded(
                              child: MoveListWidget(
                                moves: _playedMoveNodes,
                                currentPlyIndex: _playedMoveNodes.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
