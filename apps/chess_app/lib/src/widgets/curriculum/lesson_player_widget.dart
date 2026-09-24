import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';
import '../board/chess_board_widget.dart';

/// The 8 Stages of the Redesigned Pedagogical Mastery Spiral:
/// LEARN -> SEE -> UNDERSTAND -> GUIDED PRACTICE -> INDEPENDENT PRACTICE -> MINI-GAME -> REVIEW -> RETENTION TEST.
/// Strictly prevents reading-only completion.
class LessonPlayerWidget extends StatefulWidget {
  final CurriculumDay day;
  final StorageRepository repository;
  final VoidCallback onLessonCompleted;
  final VoidCallback onCancel;

  const LessonPlayerWidget({
    super.key,
    required this.day,
    required this.repository,
    required this.onLessonCompleted,
    required this.onCancel,
  });

  @override
  State<LessonPlayerWidget> createState() => _LessonPlayerWidgetState();
}

class _LessonPlayerWidgetState extends State<LessonPlayerWidget> {
  int _currentStage = 0; // 0: Learn, 1: See, 2: Understand, 3: Guided, 4: Independent, 5: Mini-Game, 6: Review, 7: Retention

  // Interactive board states
  late Board _guidedBoard;
  late Board _independentBoard;
  late Board _retentionBoard;
  late PlayableMiniGame _miniGameController;

  int _guidedHintLevel = 0;
  String? _guidedFeedback;
  bool _guidedCompleted = false;

  String? _independentFeedback;
  bool _independentCompleted = false;

  bool _understandCompleted = false;
  int? _selectedConceptOption;
  String? _understandFeedback;

  bool _miniGameCompleted = false;

  bool _retentionCompleted = false;
  String? _retentionFeedback;

  static const List<String> _stageLabels = [
    '1. Learn',
    '2. See',
    '3. Understand',
    '4. Guided',
    '5. Practice',
    '6. Mini-Game',
    '7. Review',
    '8. Retention',
  ];

  @override
  void initState() {
    super.initState();
    _initBoards();
  }

  @override
  void dispose() {
    _miniGameController.dispose();
    super.dispose();
  }

  static MiniGameType _resolveMiniGameType(CurriculumDay day) {
    final text = '${day.title} ${day.theme} ${day.topic}'.toLowerCase();
    if (text.contains('fork')) return MiniGameType.forkHunter;
    if (text.contains('pin')) return MiniGameType.pinBuilder;
    if (text.contains('skewer')) return MiniGameType.skewerHunt;
    if (text.contains('mate') || text.contains('king') || text.contains('attack')) return MiniGameType.kingHunt;
    if (text.contains('defen') || text.contains('prophylaxis')) return MiniGameType.defender;
    if (text.contains('pawn') || text.contains('chain')) return MiniGameType.pawnBattle;
    if (text.contains('break')) return MiniGameType.findTheBreak;
    if (text.contains('opening')) return MiniGameType.openingSurvival;
    if (text.contains('calculat') || text.contains('tree')) return MiniGameType.calculationTree;
    if (text.contains('convers')) return MiniGameType.conversionChallenge;
    if (text.contains('endgame') || text.contains('rook')) return MiniGameType.endgameWinHold;
    if (text.contains('piece') || text.contains('worst')) return MiniGameType.worstPieceImprovement;
    return MiniGameType.forkHunter;
  }

  void _initBoards() {
    final exercises = widget.day.exercises;
    final defaultFen = exercises.isNotEmpty ? exercises.first.fen : FenParser.initialFen;

    _guidedBoard = Board.fromFen(widget.day.visualBoardFen ?? defaultFen);
    _independentBoard = Board.fromFen(defaultFen);
    _retentionBoard = Board.fromFen(widget.day.visualBoardFen ?? defaultFen);

    _miniGameController = PlayableMiniGame.create(_resolveMiniGameType(widget.day));
    _miniGameController.onUpdate.listen((_) {
      if (mounted) setState(() {});
    });
  }

  void _handleGuidedMove(Move move) {
    final exercises = widget.day.exercises;
    if (exercises.isEmpty) return;

    final targetEx = exercises.first;
    final san = MoveGenerator.moveToSan(_guidedBoard, move);

    if (targetEx.solutionSan.contains(san)) {
      setState(() {
        _guidedBoard = _guidedBoard.clone()..makeMove(move);
        _guidedFeedback = 'Correct! $san. ${targetEx.explanation}';
        _guidedCompleted = true;
      });
    } else {
      setState(() {
        _guidedFeedback = 'Move $san was played. Try using a hint or find the forcing candidate move.';
      });
    }
  }

  void _handleIndependentMove(Move move) {
    final exercises = widget.day.exercises;
    if (exercises.isEmpty) return;

    final targetEx = exercises.first;
    final san = MoveGenerator.moveToSan(_independentBoard, move);

    if (targetEx.solutionSan.contains(san)) {
      setState(() {
        _independentBoard = _independentBoard.clone()..makeMove(move);
        _independentFeedback = 'Excellent! $san successfully executed.';
        _independentCompleted = true;
      });
    } else {
      setState(() {
        _independentFeedback = 'Incorrect move: $san. Recall the core candidate heuristic and try again.';
      });
    }
  }

  void _handleRetentionMove(Move move) {
    final exercises = widget.day.exercises;
    if (exercises.isEmpty) return;

    final targetEx = exercises.first;
    final san = MoveGenerator.moveToSan(_retentionBoard, move);

    if (targetEx.solutionSan.contains(san)) {
      setState(() {
        _retentionBoard = _retentionBoard.clone()..makeMove(move);
        _retentionFeedback = 'Retention certified! $san is the master move.';
        _retentionCompleted = true;
      });
    } else {
      setState(() {
        _retentionFeedback = 'Review the lesson motif before completing retention.';
      });
    }
  }

  void _nextStage() {
    if (_currentStage < 7) {
      setState(() => _currentStage++);
    }
  }

  void _prevStage() {
    if (_currentStage > 0) {
      setState(() => _currentStage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = widget.day;

    return Dialog(
      backgroundColor: context.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        width: 1040,
        height: 780,
        decoration: BoxDecoration(
          color: context.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.brd),
        ),
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: context.surf,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(bottom: BorderSide(color: context.brd)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ChessTheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ChessTheme.primaryLight),
                    ),
                    child: Text(
                      'DAY ${day.dayNumber}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      day.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.txt),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onCancel,
                  ),
                ],
              ),
            ),

            // 8-Stage Progress Tracker Ribbon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.black.withAlpha(context.isDark ? 80 : 15),
              child: Row(
                children: [
                  for (int i = 0; i < 8; i++) ...[
                    Expanded(
                      child: InkWell(
                        onTap: i <= _maxUnlockedStage() ? () => setState(() => _currentStage = i) : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: _currentStage == i
                                ? ChessTheme.primaryLight
                                : (i < _currentStage
                                    ? Colors.green.withAlpha(40)
                                    : context.surf.withAlpha(80)),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _currentStage == i
                                  ? ChessTheme.primaryLight
                                  : (i < _currentStage ? Colors.green : context.brd),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _stageLabels[i],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _currentStage == i
                                    ? Colors.white
                                    : (_currentStage > i ? Colors.green : context.txtMut),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (i < 7) const SizedBox(width: 4),
                  ],
                ],
              ),
            ),

            // Main Active Stage Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: _buildStageContent(),
              ),
            ),

            // Bottom Navigation Footer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: context.surf,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border(top: BorderSide(color: context.brd)),
              ),
              child: Row(
                children: [
                  if (_currentStage > 0)
                    OutlinedButton.icon(
                      onPressed: _prevStage,
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Back'),
                    ),
                  const Spacer(),
                  if (_currentStage < 7)
                    FilledButton.icon(
                      onPressed: _canAdvanceStage() ? _nextStage : null,
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text('Next: ${_stageLabels[_currentStage + 1]}'),
                      style: FilledButton.styleFrom(backgroundColor: ChessTheme.primaryLight),
                    )
                  else
                    FilledButton.icon(
                      onPressed: _retentionCompleted ? widget.onLessonCompleted : null,
                      icon: const Icon(Icons.check_circle, size: 18),
                      label: const Text('Complete Day & Update Skill Mastery'),
                      style: FilledButton.styleFrom(backgroundColor: Colors.green),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _maxUnlockedStage() {
    int maxStage = 1; // can see
    maxStage = 2; // can understand
    if (_understandCompleted) maxStage = 3; // can do guided
    if (_guidedCompleted) maxStage = 4;
    if (_independentCompleted) maxStage = 5;
    if (_miniGameCompleted) maxStage = 6;
    if (_miniGameCompleted) maxStage = 7;
    return maxStage;
  }

  bool _canAdvanceStage() {
    switch (_currentStage) {
      case 0: // Learn
      case 1: // See
        return true;
      case 2: // Understand
        return _understandCompleted;
      case 3: // Guided
        return _guidedCompleted;
      case 4: // Independent
        return _independentCompleted;
      case 5: // Mini-Game
        return _miniGameCompleted;
      case 6: // Review
        return true;
      case 7: // Retention
        return _retentionCompleted;
      default:
        return false;
    }
  }

  Widget _buildStageContent() {
    switch (_currentStage) {
      case 0:
        return _buildLearnStage();
      case 1:
        return _buildSeeStage();
      case 2:
        return _buildUnderstandStage();
      case 3:
        return _buildGuidedStage();
      case 4:
        return _buildPracticeStage();
      case 5:
        return _buildMiniGameStage();
      case 6:
        return _buildReviewStage();
      case 7:
        return _buildRetentionStage();
      default:
        return const SizedBox();
    }
  }

  // Stage 1: LEARN (30-90 sec explanation + Why It Matters)
  Widget _buildLearnStage() {
    final day = widget.day;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: ChessTheme.accentGold, size: 28),
              const SizedBox(width: 10),
              Text(
                'CORE CONCEPT (60-SECOND BRIEF)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: context.txt),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surf,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.brd),
            ),
            child: Text(
              day.shortExplanation,
              style: TextStyle(fontSize: 15, height: 1.5, color: context.txt),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.star_outline, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 10),
              Text(
                'WHY IT MATTERS IN PRACTICAL PLAY',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: context.txt),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blueAccent.withAlpha(50)),
            ),
            child: Text(
              day.whyItMatters ?? 'Applying this pattern gives you an immediate positional or tactical advantage in real games.',
              style: TextStyle(fontSize: 14, height: 1.4, color: context.txt),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'LEARNING OBJECTIVES',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: context.txtMut),
          ),
          const SizedBox(height: 8),
          for (final obj in day.learningObjectives)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(obj, style: TextStyle(fontSize: 13, color: context.txt))),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Stage 2: SEE (Animated Board Visual Model)
  Widget _buildSeeStage() {
    final day = widget.day;
    final visualFen = day.visualBoardFen ?? (day.exercises.isNotEmpty ? day.exercises.first.fen : FenParser.initialFen);
    final board = Board.fromFen(visualFen);

    return Row(
      children: [
        SizedBox(
          width: 380,
          height: 380,
          child: ChessBoardWidget(
            board: board,
            isInteractive: false,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'VISUAL PATTERN RECOGNITION',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: ChessTheme.primaryLight),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.surf,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.brd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Core Rule / Heuristic:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txtMut),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      day.patternRule ?? 'Notice the piece alignment and coordination across critical squares.',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.txt),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              if (day.modelGameClip != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withAlpha(70)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.history_edu, color: Colors.amber, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Model Game: ${day.modelGameClip}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txt),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Take 15 seconds to visualize this geometry in your mind before moving to the rule breakdown.',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: context.txtMut),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Stage 3: UNDERSTAND (Pattern Rule + Common Mistakes + Socratic Comprehension Check)
  Widget _buildUnderstandStage() {
    final day = widget.day;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMMON AMATEUR MISTAKES & REFUTATIONS',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.redAccent),
          ),
          const SizedBox(height: 10),
          for (final cm in (day.commonMistakesList.isEmpty ? const ['Rushing calculation', 'Overlooking counterplay'] : day.commonMistakesList))
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent.withAlpha(40)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(cm, style: TextStyle(fontSize: 13, color: context.txt)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'SOCRATIC ACTIVE CHECK: IDENTIFY THE THEMATIC TRIGGER',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.amber),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.withAlpha(60)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is the fundamental tactical/strategic trigger for ${day.topic}?',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Scanning CCT: Checks, Captures, Threats & LPDO'),
                      selected: _selectedConceptOption == 0,
                      onSelected: (val) {
                        setState(() {
                          _selectedConceptOption = 0;
                          _understandCompleted = true;
                          _understandFeedback = 'Correct! Grandmasters prioritize scanning forcing moves and loose pieces first.';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Playing fast intuitive pawn moves'),
                      selected: _selectedConceptOption == 1,
                      onSelected: (val) {
                        setState(() {
                          _selectedConceptOption = 1;
                          _understandFeedback = 'Incorrect: Passive/rushed moves forfeit the initiative. Focus on CCT!';
                        });
                      },
                    ),
                  ],
                ),
                if (_understandFeedback != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _understandFeedback!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _understandCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'KEY TAKEAWAY CHEAT SHEET',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: ChessTheme.primaryLight),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.surf,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.brd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.cheatSheetText,
                  style: TextStyle(fontSize: 14, height: 1.4, color: context.txt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stage 4: GUIDED PRACTICE (Free Step-by-Step Hints)
  Widget _buildGuidedStage() {
    final exercises = widget.day.exercises;
    final ex = exercises.isNotEmpty ? exercises.first : null;

    return Row(
      children: [
        SizedBox(
          width: 380,
          height: 380,
          child: ChessBoardWidget(
            board: _guidedBoard,
            isInteractive: !_guidedCompleted,
            onMovePlayed: _handleGuidedMove,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GUIDED BOARD PRACTICE (UNLIMITED HINTS)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.teal),
              ),
              const SizedBox(height: 10),
              Text(
                ex?.instruction ?? 'Find the model move on the board.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.txt),
              ),
              const SizedBox(height: 16),

              // Hint Cascade Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _guidedHintLevel = 1);
                    },
                    icon: const Icon(Icons.help_outline, size: 14),
                    label: const Text('Hint 1: Concept'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _guidedHintLevel = 2);
                    },
                    icon: const Icon(Icons.lightbulb_outline, size: 14),
                    label: const Text('Hint 2: Piece'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _guidedHintLevel = 3);
                    },
                    icon: const Icon(Icons.visibility, size: 14),
                    label: const Text('Hint 3: Show Move'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Hint Text Display
              if (_guidedHintLevel >= 1 && ex != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withAlpha(60)),
                  ),
                  child: Text(
                    _guidedHintLevel == 1
                        ? (ex.hints.isNotEmpty ? ex.hints[0] : ex.concept)
                        : (_guidedHintLevel == 2
                            ? 'Focus on the ${ex.targetPiece}. ${ex.hints.length > 1 ? ex.hints[1] : ""}'
                            : 'Solution move is: ${ex.solutionSan.firstOrNull}'),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber),
                  ),
                ),

              const Spacer(),
              if (_guidedFeedback != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _guidedCompleted ? Colors.green.withAlpha(25) : Colors.orange.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _guidedCompleted ? Colors.green : Colors.orange),
                  ),
                  child: Text(
                    _guidedFeedback!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _guidedCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Stage 5: INDEPENDENT PRACTICE (Verified Solution, No Assistance)
  Widget _buildPracticeStage() {
    final exercises = widget.day.exercises;
    final ex = exercises.isNotEmpty ? exercises.first : null;

    return Row(
      children: [
        SizedBox(
          width: 380,
          height: 380,
          child: ChessBoardWidget(
            board: _independentBoard,
            isInteractive: !_independentCompleted,
            onMovePlayed: _handleIndependentMove,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'INDEPENDENT PRACTICE',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.purpleAccent),
              ),
              const SizedBox(height: 10),
              Text(
                ex?.instruction ?? 'Find the winning continuation on your own.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.txt),
              ),
              const SizedBox(height: 12),
              Text(
                'Think through CCT: Checks, Captures, Threats. Verify your candidate move before touching the board.',
                style: TextStyle(fontSize: 12, color: context.txtMut),
              ),
              const Spacer(),
              if (_independentFeedback != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _independentCompleted ? Colors.green.withAlpha(25) : Colors.red.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _independentCompleted ? Colors.green : Colors.red),
                  ),
                  child: Text(
                    _independentFeedback!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _independentCompleted ? Colors.green : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Stage 6: MINI-GAME APPLICATION (Real Playable Chessboard)
  Widget _buildMiniGameStage() {
    final lvl = _miniGameController.currentLevel;

    return Row(
      children: [
        SizedBox(
          width: 380,
          height: 380,
          child: ChessBoardWidget(
            board: _miniGameController.currentBoard,
            isInteractive: !_miniGameController.isLevelCompleted && !_miniGameController.isGameOver,
            onMovePlayed: (move) {
              final ok = _miniGameController.playMove(move);
              if (_miniGameController.roundsCompleted >= 1 || _miniGameController.isGameOver) {
                setState(() => _miniGameCompleted = true);
              }
            },
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.sports_esports, color: ChessTheme.primaryLight, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'PLAYABLE MINI-GAME: ${_miniGameController.type.title.toUpperCase()}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: ChessTheme.primaryLight),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                lvl.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.txt),
              ),
              const SizedBox(height: 6),
              Text(
                lvl.objective,
                style: TextStyle(fontSize: 13, color: context.txtSec),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ChessTheme.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ChessTheme.primaryLight),
                    ),
                    child: Text(
                      'Level ${_miniGameController.currentLevelIndex + 1} / ${_miniGameController.totalLevels}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (_miniGameCompleted)
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 18),
                        SizedBox(width: 4),
                        Text('Goal Achieved', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      _miniGameController.requestHint();
                    },
                    icon: const Icon(Icons.help_outline, size: 14),
                    label: const Text('Hint'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _miniGameController.resetCurrentLevel();
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 14),
                    label: const Text('Reset'),
                  ),
                  if (_miniGameController.isLevelCompleted && !_miniGameController.isGameOver)
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _miniGameController.nextLevel();
                        });
                      },
                      icon: const Icon(Icons.arrow_forward, size: 14),
                      label: const Text('Next Level'),
                      style: FilledButton.styleFrom(backgroundColor: Colors.green),
                    ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _miniGameCompleted ? Colors.green.withAlpha(25) : context.surf,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _miniGameCompleted ? Colors.green : context.brd),
                ),
                child: Text(
                  _miniGameController.feedbackMessage,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _miniGameCompleted ? Colors.green : context.txt,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Stage 7: REVIEW (Spaced Repetition Takeaways)
  Widget _buildReviewStage() {
    final day = widget.day;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sync, color: Colors.blueAccent, size: 24),
              const SizedBox(width: 10),
              Text(
                'SPACED RETENTION & REFLECTION',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: context.txt),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surf,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.brd),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Cognitive Heuristic:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txtMut),
                ),
                const SizedBox(height: 6),
                Text(
                  day.cheatSheetText,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.txt),
                ),
                const SizedBox(height: 14),
                Text(
                  'Spaced Repetition Schedule:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txtMut),
                ),
                const SizedBox(height: 6),
                Text(
                  'This concept will be reintroduced on Day ${day.dayNumber + 3} and Day ${day.dayNumber + 7} in mixed-motif challenge labs.',
                  style: TextStyle(fontSize: 13, color: context.txt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Stage 8: RETENTION TEST (Final 1-Move Verification)
  Widget _buildRetentionStage() {
    final exercises = widget.day.exercises;
    final ex = exercises.isNotEmpty ? exercises.first : null;

    return Row(
      children: [
        SizedBox(
          width: 380,
          height: 380,
          child: ChessBoardWidget(
            board: _retentionBoard,
            isInteractive: !_retentionCompleted,
            onMovePlayed: _handleRetentionMove,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RETENTION CERTIFICATION TEST',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: Colors.green),
              ),
              const SizedBox(height: 10),
              Text(
                'Execute the master move from memory to certify Day ${widget.day.dayNumber}.',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.txt),
              ),
              const SizedBox(height: 12),
              Text(
                ex?.instruction ?? 'Deliver the decisive tactical continuation.',
                style: TextStyle(fontSize: 13, color: context.txtMut),
              ),
              const Spacer(),
              if (_retentionFeedback != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _retentionCompleted ? Colors.green.withAlpha(25) : Colors.orange.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _retentionCompleted ? Colors.green : Colors.orange),
                  ),
                  child: Text(
                    _retentionFeedback!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _retentionCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
