import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_board_theme.dart';
import '../theme/chess_theme.dart';
import '../theme/piece_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/evaluation_bar_widget.dart';
import '../widgets/board/move_list_widget.dart';
import '../widgets/board/responsive_chess_workspace.dart';

/// Complete post-game analysis workspace implementing human self-analysis
/// followed by engine audit, root-cause diagnosis, spaced-review generation,
/// and 1-click targeted mistake retraining.
class AnalysisScreen extends StatefulWidget {
  final StorageRepository repository;
  final dynamic initialArgs;
  final ChessEngine? engine;
  final Function(String screenKey, {dynamic args})? onNavigate;

  const AnalysisScreen({
    super.key,
    required this.repository,
    this.initialArgs,
    this.engine,
    this.onNavigate,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late PgnGame _game;
  late Board _board;
  int _currentPly = 0;
  final List<Board> _boardHistory = [];

  final Map<int, String> _selfAnalysisNotes = {};
  final TextEditingController _noteController = TextEditingController();

  bool _isEngineAnalysisComplete = false;
  bool _isAnalyzing = false;
  final Map<int, EngineEvaluation> _evaluations = {};
  final Map<int, RootCauseDiagnosis> _diagnoses = {};

  late ChessEngine _engine;

  @override
  void initState() {
    super.initState();
    _engine = widget.engine ??
        (NativeStockfishEngine.isSupported
            ? NativeStockfishEngine()
            : EmbeddedHeuristicEngine());
    _engine.initialize();
    _loadGame();
  }

  void _loadGame() {
    String pgnContent = '''
[Event "Model Match"]
[Site "ChessMaster"]
[Date "2026.09.10"]
[Round "1"]
[White "Player"]
[Black "Engine"]
[Result "1-0"]

1. e4 e5 2. Bc4 Nc6 3. Qh5 Nf6 4. Qxf7# 1-0
''';

    if (widget.initialArgs is Map) {
      final args = widget.initialArgs as Map;
      if (args['gameSession'] is GameSession) {
        final session = args['gameSession'] as GameSession;
        pgnContent = session.pgn.isNotEmpty ? session.pgn : session.toPgnGame().toPgnString();
      } else if (args['pgn'] != null) {
        pgnContent = args['pgn'] as String;
      }
    } else if (widget.repository.getLastCompletedGame() != null) {
      final lastGame = widget.repository.getLastCompletedGame()!;
      pgnContent = lastGame.pgn.isNotEmpty ? lastGame.pgn : lastGame.toPgnGame().toPgnString();
    } else if (widget.repository.getGames().isNotEmpty) {
      pgnContent = widget.repository.getGames().last.pgn;
    }

    _game = PgnParser.parse(pgnContent) ?? PgnParser.parse(pgnContent)!;

    // Build board history
    _board = _game.setupFen != null ? Board.fromFen(_game.setupFen!) : Board.initial();
    _boardHistory.clear();
    _boardHistory.add(_board.clone());

    for (final node in _game.moves) {
      if (node.move != null) {
        _board.makeMove(node.move!);
        _boardHistory.add(_board.clone());
      }
    }

    _goToPly(0);

    // If navigated with direct request for mistakes, auto-run engine audit
    if (widget.initialArgs is Map && widget.initialArgs['tab'] == 'mistakes') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _runEngineAudit();
      });
    }
  }

  void _goToPly(int ply) {
    setState(() {
      _currentPly = ply.clamp(0, _boardHistory.length - 1);
      _board = _boardHistory[_currentPly].clone();
      _noteController.text = _selfAnalysisNotes[_currentPly] ?? '';
    });
  }

  void _saveSelfAnalysisNote() {
    setState(() {
      _selfAnalysisNotes[_currentPly] = _noteController.text;
    });
  }

  Future<void> _runEngineAudit() async {
    if (_isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
    });

    for (int i = 0; i < _boardHistory.length; i++) {
      final b = _boardHistory[i];
      await _engine.setPosition(b.toFen());
      final eval = await _engine.evaluate(depth: 3);
      _evaluations[i] = eval;
    }

    // Run root cause classifier for each played move
    int? firstBlunderPly;
    for (int i = 1; i < _boardHistory.length; i++) {
      final prevBoard = _boardHistory[i - 1];
      final node = _game.moves[i - 1];
      if (node.move == null) continue;

      final evalBefore = _evaluations[i - 1]!;
      final evalAfter = _evaluations[i]!;

      final diagnosis = RootCauseClassifier.diagnose(
        boardBeforeMove: prevBoard,
        playedMove: node.move!,
        evaluationBefore: evalBefore,
        evaluationAfter: evalAfter,
        userSelfAnalysisNote: _selfAnalysisNotes[i],
      );

      _diagnoses[i] = diagnosis;

      if (diagnosis.quality.isNegative) {
        firstBlunderPly ??= i;
        widget.repository.saveReviewItem(ReviewItem(
          id: 'blunder_review_${DateTime.now().millisecondsSinceEpoch}_ply_$i',
          fen: prevBoard.toFen(),
          solutionSan: [MoveGenerator.moveToSan(prevBoard, evalBefore.bestMove ?? node.move!)],
          skillNodeId: 'tactics',
          motif: diagnosis.category.title,
          explanation: diagnosis.explanation,
        ));
      }
    }

    setState(() {
      _isAnalyzing = false;
      _isEngineAnalysisComplete = true;
      if (firstBlunderPly != null) {
        _goToPly(firstBlunderPly);
      }
    });
  }

  void _trainMistake(RootCauseDiagnosis diagnosis) {
    // 1. Update skill graph node in persistent repository
    final nodes = widget.repository.getSkillNodes();
    final matched = nodes.where((n) => n.id.toLowerCase().contains(diagnosis.category.name.toLowerCase())).firstOrNull;
    if (matched != null) {
      matched.status = SkillStatus.learning;
      widget.repository.saveSkillNode(matched);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Targeting skill: ${diagnosis.category.title}. Opening ${diagnosis.prescribedLab}...'),
        backgroundColor: ChessTheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );

    // 2. 1-Click navigate to targeted lab
    widget.onNavigate?.call('labs', args: {
      'labType': diagnosis.prescribedLab,
      'dayNumber': diagnosis.prescribedCurriculumDay,
      'concept': diagnosis.category.title,
    });
  }

  @override
  void dispose() {
    _engine.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.repository.getProfile();
    final boardTheme = ChessBoardTheme.fromName(profile.boardThemeName);
    final pieceTheme = PieceTheme.fromName(profile.pieceThemeName);
    final currentEval = _evaluations[_currentPly];
    final currentDiagnosis = _diagnoses[_currentPly];

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
        header: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: context.surf,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.brd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.sports_score, size: 16, color: ChessTheme.primaryLight),
                  const SizedBox(width: 8),
                  Text(
                    '${_game.headers["White"] ?? "White"} vs ${_game.headers["Black"] ?? "Black"} (${_game.headers["Result"] ?? "*"})',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txt),
                  ),
                ],
              ),
              Text(
                'Ply $_currentPly of ${_boardHistory.length - 1}',
                style: TextStyle(fontSize: 11, color: context.txtSec),
              ),
            ],
          ),
        ),
        evalBar: EvaluationBarWidget(
          evaluation: currentEval,
          isVertical: true,
        ),
        evalBarWidth: 32.0,
        boardBuilder: (context, boardSize) {
          return SizedBox(
            width: boardSize,
            height: boardSize,
            child: ChessBoardWidget(
              board: _board,
              isInteractive: false,
              boardTheme: boardTheme,
              pieceTheme: pieceTheme,
              showCoordinates: profile.showCoordinates,
              showMoveHighlights: profile.showMoveHighlights,
              lastMoveFrom: _currentPly > 0 && _game.moves.isNotEmpty ? _game.moves[_currentPly - 1].move?.from : null,
              lastMoveTo: _currentPly > 0 && _game.moves.isNotEmpty ? _game.moves[_currentPly - 1].move?.to : null,
            ),
          );
        },
        footer: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.surf,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.brd),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.first_page, size: 18),
                tooltip: 'First Move',
                onPressed: _currentPly > 0 ? () => _goToPly(0) : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 18),
                tooltip: 'Previous Move',
                onPressed: _currentPly > 0 ? () => _goToPly(_currentPly - 1) : null,
              ),
              Text(
                'Ply $_currentPly / ${_boardHistory.length - 1}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txt),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 18),
                tooltip: 'Next Move',
                onPressed: _currentPly < _boardHistory.length - 1 ? () => _goToPly(_currentPly + 1) : null,
              ),
              IconButton(
                icon: const Icon(Icons.last_page, size: 18),
                tooltip: 'Final Move',
                onPressed: _currentPly < _boardHistory.length - 1 ? () => _goToPly(_boardHistory.length - 1) : null,
              ),
            ],
          ),
        ),
        sidePanel: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Engine indicator badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: _engine.isFallback
                      ? Colors.amber.withOpacity(0.12)
                      : const Color(0xFF10B981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _engine.isFallback ? Colors.amber : const Color(0xFF10B981),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _engine.isFallback ? Icons.memory : Icons.bolt,
                      size: 16,
                      color: _engine.isFallback ? Colors.amber : const Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Active Engine: ${_engine.engineName}',
                        style: TextStyle(
                          color: _engine.isFallback ? Colors.amber : const Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _engine.isFallback ? 'Fallback' : 'Native UCI',
                      style: TextStyle(
                        fontSize: 11,
                        color: _engine.isFallback ? Colors.amber.withOpacity(0.8) : const Color(0xFF10B981).withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              // Step 1: Self-Analysis Box
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: context.surf,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.brd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_note, color: ChessTheme.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Step 1: Human Self-Analysis',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.txt),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Record your original thoughts, candidate moves, and plan for this position before revealing engine truth:',
                      style: TextStyle(fontSize: 11, color: context.txtSec),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      maxLines: 2,
                      onChanged: (_) => _saveSelfAnalysisNote(),
                      decoration: InputDecoration(
                        hintText: 'e.g. "I considered 12...Be6 and 12...c6. I chose c6 to stop Nd5..."',
                        hintStyle: TextStyle(color: context.txtMut, fontSize: 11),
                        filled: true,
                        fillColor: context.surfLight,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!_isEngineAnalysisComplete)
                      ElevatedButton.icon(
                        icon: _isAnalyzing
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.psychology, size: 16),
                        label: Text(_isAnalyzing ? 'Auditing with Engine...' : 'Lock Self-Analysis & Run Engine Audit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ChessTheme.primary,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 36),
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _isAnalyzing ? null : _runEngineAudit,
                      ),
                  ],
                ),
              ),

              // Step 2 & 3: Engine Diagnosis & Root Cause with "Train This Mistake"
              if (_isEngineAnalysisComplete && currentDiagnosis != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: context.surf,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: currentDiagnosis.quality.isNegative ? ChessTheme.qualityBlunder : ChessTheme.primary,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: currentDiagnosis.quality.isNegative
                                      ? ChessTheme.qualityBlunder.withAlpha(40)
                                      : ChessTheme.primary.withAlpha(40),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${currentDiagnosis.quality.glyph} ${currentDiagnosis.quality.label.toUpperCase()}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: currentDiagnosis.quality.isNegative
                                        ? ChessTheme.qualityBlunder
                                        : ChessTheme.primaryLight,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '-${currentDiagnosis.centipawnLoss} cp',
                                style: TextStyle(fontSize: 12, color: context.txtMut),
                              ),
                            ],
                          ),
                          if (currentDiagnosis.engineBestMove != null)
                            Text(
                              'Best: ${currentDiagnosis.engineBestMove!.uci}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: ChessTheme.primaryLight),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Root Cause: ${currentDiagnosis.category.title}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: context.txt),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentDiagnosis.explanation,
                        style: TextStyle(fontSize: 12, color: context.txtSec),
                      ),
                      const SizedBox(height: 10),

                      // Prescribed Retraining & Train Mistake Button
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: context.surfLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.school, size: 16, color: ChessTheme.accentGold),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Prescribed Retraining: Day ${currentDiagnosis.prescribedCurriculumDay} • ${currentDiagnosis.prescribedLab}',
                                    style: TextStyle(fontSize: 11, color: context.txt, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.fitness_center, size: 14),
                                label: const Text('Train This Mistake'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ChessTheme.primary,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () => _trainMistake(currentDiagnosis),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // Move List
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: context.surf,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: context.brd),
                ),
                child: MoveListWidget(
                  moves: _game.moves,
                  currentPlyIndex: _currentPly,
                  onMoveSelected: _goToPly,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
