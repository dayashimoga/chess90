import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/board_size_policy.dart';
import '../theme/chess_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/evaluation_bar_widget.dart';
import '../widgets/board/move_list_widget.dart';

/// Interactive learn-by-doing laboratory screen supporting all 12 specialized lab modes.
class LabsScreen extends StatefulWidget {
  final StorageRepository repository;
  final dynamic initialArgs;

  const LabsScreen({
    super.key,
    required this.repository,
    this.initialArgs,
  });

  @override
  State<LabsScreen> createState() => _LabsScreenState();
}

class _LabsScreenState extends State<LabsScreen> {
  late LabSession _session;
  int _currentExerciseIndex = 0;
  List<CurriculumExercise> _exercises = [];
  final List<PgnMoveNode> _playedMoveNodes = [];

  int _currentDayNumber = 1;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    int dayNum = 1;
    if (widget.initialArgs is Map && widget.initialArgs['dayNumber'] != null) {
      dayNum = widget.initialArgs['dayNumber'] as int;
    }
    _currentDayNumber = dayNum;

    final day = CurriculumCatalog.getDay(dayNum);
    _exercises = day.exercises;

    if (widget.initialArgs is Map && widget.initialArgs['exerciseId'] != null) {
      final idx = _exercises.indexWhere((e) => e.id == widget.initialArgs['exerciseId']);
      if (idx != -1) _currentExerciseIndex = idx;
    }

    _initSessionForCurrentExercise();
  }

  void _initSessionForCurrentExercise() {
    final ex = _exercises[_currentExerciseIndex];
    final day = CurriculumCatalog.getDay(_currentDayNumber);
    _playedMoveNodes.clear();

    _session = LabSession(
      id: ex.id,
      title: ex.instruction,
      labType: day.referencedLabId,
      initialFen: ex.fen,
      solutionSan: ex.solutionSan,
      hints: ex.hints,
      explanation: ex.explanation,
      isNoTacticPosition: ex.isNoTacticPosition,
    );

    _session.onUpdate.listen((_) {
      if (mounted) setState(() {});
    });
  }

  void _onMovePlayed(Move move) {
    final prevBoard = _session.currentBoard.clone();
    final san = MoveGenerator.moveToSan(prevBoard, move);

    _session.playMove(move);

    _playedMoveNodes.add(PgnMoveNode(
      ply: _playedMoveNodes.length + 1,
      moveNumber: (_playedMoveNodes.length ~/ 2) + 1,
      isWhite: prevBoard.activeColor == PieceColor.white,
      san: san,
      move: move,
    ));

    setState(() {});
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _initSessionForCurrentExercise();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentEx = _exercises[_currentExerciseIndex];

    return Scaffold(
      backgroundColor: context.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 800;
          final evalBarSpacing = isCompact ? 8.0 : 12.0;
          const evalBarWidth = 28.0;
          final boardSize = BoardSizePolicy.calculateBoardSize(
            constraints: constraints,
            mode: isCompact ? BoardSizeMode.compact : BoardSizeMode.standard,
            hasEvaluationBar: true,
            evalBarWidth: evalBarWidth + evalBarSpacing,
            verticalPadding: 220.0,
          );

          final instructionBanner = Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: context.surf,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.brd),
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

          final boardArea = FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: boardSize,
                  child: const EvaluationBarWidget(isVertical: true),
                ),
                SizedBox(width: evalBarSpacing),
                SizedBox(
                  width: boardSize,
                  height: boardSize,
                  child: ChessBoardWidget(
                    board: _session.currentBoard,
                    isFlipped: currentEx.sideToPlay == PieceColor.black,
                    onMovePlayed: _onMovePlayed,
                    isInteractive: !_session.isCompleted,
                  ),
                ),
              ],
            ),
          );

          final actionButtons = Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.lightbulb_outline, size: 16),
                label: Text('Hint (${_session.hintsRevealed}/${currentEx.hints.length})'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.surf,
                  foregroundColor: ChessTheme.accentGold,
                  side: const BorderSide(color: ChessTheme.accentGold),
                ),
                onPressed: _session.hintsRevealed < currentEx.hints.length
                    ? () => _session.requestHint()
                    : null,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.shield_outlined, size: 16),
                label: const Text('Declare "No Tactic"'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.surf,
                  foregroundColor: ChessTheme.secondary,
                  side: const BorderSide(color: ChessTheme.secondary),
                ),
                onPressed: !_session.isCompleted
                    ? () => _session.declareNoTactic()
                    : null,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.surfLight,
                  foregroundColor: context.txt,
                ),
                onPressed: () => _session.reset(),
              ),
              if (_session.isCompleted && _currentExerciseIndex < _exercises.length - 1)
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Next Exercise'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ChessTheme.primary,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _nextExercise,
                ),
            ],
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
                Text(
                  'Exercise ${_currentExerciseIndex + 1} of ${_exercises.length}',
                  style: const TextStyle(fontSize: 12, color: ChessTheme.primaryLight, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  currentEx.instruction,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.txt),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tactical Motif: ${currentEx.motif}',
                  style: TextStyle(fontSize: 12, color: context.txtSec),
                ),
              ],
            ),
          );

          if (isCompact) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
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
          );
        },
      ),
    );
  }
}
