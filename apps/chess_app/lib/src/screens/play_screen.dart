import 'dart:async';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/chess_board_theme.dart';
import '../theme/chess_theme.dart';
import '../theme/piece_theme.dart';
import '../widgets/board/board_customizer_dialog.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/move_list_widget.dart';
import '../widgets/board/responsive_chess_workspace.dart';
import '../widgets/play/game_library_dialog.dart';
import '../widgets/play/play_setup_dialog.dart';

/// Play screen supporting Human vs Engine, complete game setup, full game controls,
/// progressive hints, board customization, and seamless transitions to self-analysis.
class PlayScreen extends StatefulWidget {
  final StorageRepository repository;
  final Function(String screenKey, {dynamic args}) onNavigate;
  final dynamic initialArgs;
  final ChessEngine? engine;

  const PlayScreen({
    super.key,
    required this.repository,
    required this.onNavigate,
    this.initialArgs,
    this.engine,
  });

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late Board _board;
  late ChessClock _clock;
  late ChessEngine _engine;
  late GameSession _activeSession;
  Timer? _timer;

  // Game Configuration
  late PlaySetupConfig _setupConfig;
  bool _isTournamentMode = false;
  bool _playVsEngine = true;
  PieceColor _playerColor = PieceColor.white;
  bool _isFlipped = false;
  bool _isPaused = false;
  bool _isEngineThinking = false;
  bool _isRated = true;

  // Moves & State
  final List<PgnMoveNode> _moves = [];
  final Map<int, String> _thoughtNotes = {};
  bool _isGameOver = false;
  String _gameStatusMessage = 'Game in progress';
  UnfinishedGame? _pendingUnfinishedGame;

  // Post-Game Replay
  int? _replayPlyIndex;

  // Progressive Hints & Highlights
  int _hintLevel = 0; // 0 to 4
  String? _hintExplanation;
  Move? _hintBestMove;
  List<Square> _highlightedSquares = [];
  List<BoardArrow> _boardArrows = [];

  @override
  void initState() {
    super.initState();
    _pendingUnfinishedGame = widget.repository.getUnfinishedGame();

    if (widget.initialArgs is Map && widget.initialArgs['isTournament'] == true) {
      _isTournamentMode = true;
      _setupConfig = const PlaySetupConfig(
        playerColor: PieceColor.white,
        strengthPreset: 'Master',
        eloRating: 2400,
        gameType: 'Tournament Simulation',
        timeControlName: '45+15 Classical',
        initialMinutes: 45,
        incrementSeconds: 15,
      );
      _clock = ChessClock.classical45Plus15();
    } else {
      _setupConfig = const PlaySetupConfig(
        playerColor: PieceColor.white,
        strengthPreset: 'Medium',
        eloRating: 1400,
        gameType: 'Serious Game',
        timeControlName: '15+10 Rapid',
        initialMinutes: 15,
        incrementSeconds: 10,
      );
      _clock = ChessClock.rapid15Plus10();
    }

    _playerColor = _setupConfig.playerColor;
    _isFlipped = _playerColor == PieceColor.black;
    _isRated = !_setupConfig.isCasualOrTraining;

    if (widget.initialArgs is Map) {
      final args = widget.initialArgs as Map;
      if (args['isVsEngine'] != null) {
        _playVsEngine = args['isVsEngine'] as bool;
      }
      if (args['isRated'] != null) {
        _isRated = args['isRated'] as bool;
      }
      if (args['gameSession'] is GameSession) {
        _restoreFromGameSession(args['gameSession'] as GameSession);
      }
    }

    // Check if an active continuous game session exists in the repository
    final existingSession = widget.repository.getActiveGameSession();
    if (existingSession != null && !existingSession.isCompleted && existingSession.moveSanList.isNotEmpty) {
      _restoreFromGameSession(existingSession);
    } else {
      _initNewActiveSession();
    }

    _engine = widget.engine ??
        (NativeStockfishEngine.isSupported
            ? NativeStockfishEngine()
            : EmbeddedHeuristicEngine());
    _engine.initialize();

    _startClockTimer();
    if (_moves.isNotEmpty) {
      _clock.start();
    }

    // If player plays Black vs Engine, engine makes the opening move
    if (_playVsEngine && _playerColor == PieceColor.black && _moves.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _playEngineMove());
    }
  }

  void _initNewActiveSession() {
    _board = Board.initial();
    _activeSession = GameSession.newGame(
      timeControl: _setupConfig.timeControlName,
      initialMinutes: _setupConfig.initialMinutes,
      incrementSeconds: _setupConfig.incrementSeconds,
      playerColor: _playerColor == PieceColor.white ? 'white' : 'black',
      opponentName: _playVsEngine ? 'Stockfish ${_setupConfig.strengthPreset}' : 'Human Opponent',
      isVsEngine: _playVsEngine,
      engineElo: _setupConfig.eloRating,
    );
    widget.repository.saveActiveGameSession(_activeSession);
  }

  void _restoreFromGameSession(GameSession session) {
    _activeSession = session;
    _board = Board.fromFen(session.currentFen);
    _playVsEngine = session.isVsEngine;
    _playerColor = session.playerColor == 'black' ? PieceColor.black : PieceColor.white;
    _isFlipped = _playerColor == PieceColor.black;

    _clock.whiteRemaining = Duration(seconds: session.whiteRemainingSeconds);
    _clock.blackRemaining = Duration(seconds: session.blackRemainingSeconds);

    _moves.clear();
    // Replay moves into _moves list
    final tempBoard = Board.fromFen(session.initialFen);
    for (int i = 0; i < session.moveUciList.length; i++) {
      final uci = session.moveUciList[i];
      final san = i < session.moveSanList.length ? session.moveSanList[i] : uci;
      final parsedMove = MoveGenerator.generateLegalMoves(tempBoard).where((m) => m.uci == uci).firstOrNull;
      _moves.add(PgnMoveNode(
        ply: i + 1,
        moveNumber: (i ~/ 2) + 1,
        isWhite: tempBoard.activeColor == PieceColor.white,
        san: san,
        move: parsedMove,
      ));
      if (parsedMove != null) {
        tempBoard.makeMove(parsedMove);
      }
    }

    if (session.isCompleted) {
      _isGameOver = true;
      _gameStatusMessage = 'Game completed: ${session.result}';
    }
  }

  void _startClockTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted && _clock.isRunning && !_isPaused && !_isGameOver) {
        setState(() {
          _clock.tick();
          if (_clock.hasFlagFallen(PieceColor.white)) {
            _onGameOver('White flagged! Black wins on time.');
          } else if (_clock.hasFlagFallen(PieceColor.black)) {
            _onGameOver('Black flagged! White wins on time.');
          }
        });
      }
    });
  }

  void _onMovePlayed(Move move) {
    if (_isGameOver || _isPaused) return;

    final prevBoard = _board.clone();
    final san = MoveGenerator.moveToSan(prevBoard, move);

    _board = _board.clone()..makeMove(move);
    if (!_clock.isRunning && !_isGameOver) {
      _clock.start();
    }
    _clock.onMovePlayed();

    _moves.add(PgnMoveNode(
      ply: _moves.length + 1,
      moveNumber: (_moves.length ~/ 2) + 1,
      isWhite: prevBoard.activeColor == PieceColor.white,
      san: san,
      move: move,
    ));

    // Reset hints on move
    _clearHints();

    // Autosave after EVERY move into persistent continuous GameSession!
    _activeSession.recordMove(
      san: san,
      uci: move.uci,
      newFen: _board.toFen(),
      whiteTime: _clock.whiteRemaining.inSeconds,
      blackTime: _clock.blackRemaining.inSeconds,
    );
    widget.repository.saveActiveGameSession(_activeSession);

    // Also update legacy unfinished game for crash-safe recovery
    widget.repository.saveUnfinishedGame(UnfinishedGame(
      id: _activeSession.id,
      currentFen: _board.toFen(),
      moveSanList: _moves.map((m) => m.san).toList(),
      timeControl: _setupConfig.timeControlName,
      whiteRemainingSeconds: _clock.whiteRemaining.inSeconds,
      blackRemainingSeconds: _clock.blackRemaining.inSeconds,
      isVsEngine: _playVsEngine,
      isTournamentMode: _isTournamentMode,
      startedAt: _activeSession.startedAt,
      lastMoveAt: DateTime.now(),
      thoughtNotes: _thoughtNotes,
    ));

    // Check game outcome
    final status = MoveGenerator.getGameStatus(_board);
    if (status.isGameOver) {
      _onGameOver('Game ended: ${status.name}');
      return;
    }

    setState(() {});

    // If opponent is engine and it's engine's turn
    if (_playVsEngine && _board.activeColor != _playerColor && !_isGameOver) {
      _playEngineMove();
    }
  }

  void _clearHints() {
    _hintLevel = 0;
    _hintExplanation = null;
    _hintBestMove = null;
    _highlightedSquares.clear();
    _boardArrows.clear();
  }

  Future<void> _playEngineMove() async {
    if (_isGameOver || _isEngineThinking) return;

    setState(() {
      _isEngineThinking = true;
    });

    try {
      final searchDepth = _setupConfig.searchDepth.clamp(2, 4);
      await Future.delayed(const Duration(milliseconds: 100));
      await _engine.setPosition(_board.toFen());
      final eval = await _engine.evaluate(depth: searchDepth);

      if (eval.bestMove != null && !_isGameOver && mounted) {
        _onMovePlayed(eval.bestMove!);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isEngineThinking = false;
        });
      }
    }
  }

  void _onGameOver(String message) {
    _isGameOver = true;
    _clock.pause();
    _gameStatusMessage = message;
    _clearHints();

    // Clear active unfinished game on completion
    widget.repository.clearUnfinishedGame();

    // Determine result string
    final resultStr = _board.activeColor == PieceColor.black ? '1-0' : '0-1';

    // Complete continuous GameSession & save to history
    _activeSession.completeGame(resultStr);
    widget.repository.saveCompletedGame(_activeSession);
    widget.repository.clearActiveGameSession();

    // Save game record to legacy game table
    final pgn = _buildPgn();
    final record = GameRecord(
      id: _activeSession.id,
      pgn: pgn,
      playedDate: DateTime.now(),
      whitePlayer: _playerColor == PieceColor.white ? 'User' : 'Engine (${_setupConfig.strengthPreset})',
      blackPlayer: _playerColor == PieceColor.black ? 'User' : 'Engine (${_setupConfig.strengthPreset})',
      result: resultStr,
      timeControl: _setupConfig.timeControlName,
    );
    widget.repository.saveGame(record);

    setState(() {});
  }

  void _startNewGameWithConfig(PlaySetupConfig config) {
    _setupConfig = config;
    _playerColor = config.playerColor;
    _isFlipped = _playerColor == PieceColor.black;
    _isRated = !config.isCasualOrTraining;
    _isTournamentMode = config.gameType.contains('Tournament');
    _isGameOver = false;
    _isPaused = false;
    _isEngineThinking = false;
    _gameStatusMessage = 'Game in progress';
    _replayPlyIndex = null;
    _moves.clear();
    _thoughtNotes.clear();
    _clearHints();
    _board = Board.initial();

    if (config.initialMinutes == 0) {
      _clock = ChessClock(
        initialTime: const Duration(hours: 99),
        increment: Duration.zero,
      );
    } else {
      _clock = ChessClock(
        initialTime: Duration(minutes: config.initialMinutes),
        increment: Duration(seconds: config.incrementSeconds),
      );
    }

    _startClockTimer();
    _initNewActiveSession();

    widget.repository.clearUnfinishedGame();
    setState(() {});

    if (_playVsEngine && _playerColor == PieceColor.black) {
      _playEngineMove();
    }
  }

  // --- In-Game Control Actions ---

  Future<void> _openPlaySetupDialog() async {
    final newConfig = await showDialog<PlaySetupConfig>(
      context: context,
      builder: (ctx) => PlaySetupDialog(initialConfig: _setupConfig),
    );
    if (newConfig != null) {
      _startNewGameWithConfig(newConfig);
    }
  }

  void _openGameLibrary() {
    GameLibraryDialog.show(
      context,
      repository: widget.repository,
      onNavigate: widget.onNavigate,
    );
  }

  void _confirmRestart() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surf,
        title: Text('Restart Game?', style: TextStyle(color: ctx.txt)),
        content: Text(
          'All current game moves will be cleared and a fresh board will be started.',
          style: TextStyle(color: ctx.txtSec, fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ChessTheme.qualityBlunder),
            onPressed: () {
              Navigator.of(ctx).pop();
              _startNewGameWithConfig(_setupConfig);
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void _confirmResign() {
    if (_isGameOver) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surf,
        title: Text('Resign Game?', style: TextStyle(color: ctx.txt)),
        content: Text(
          'Are you sure you want to forfeit this game? The win will be awarded to your opponent.',
          style: TextStyle(color: ctx.txtSec, fontSize: 13),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ChessTheme.qualityBlunder),
            onPressed: () {
              Navigator.of(ctx).pop();
              final winner = _playerColor == PieceColor.white ? 'Black' : 'White';
              _onGameOver('${_playerColor == PieceColor.white ? "White" : "Black"} resigns. $winner wins.');
            },
            child: const Text('Resign'),
          ),
        ],
      ),
    );
  }

  Future<void> _offerDraw() async {
    if (_isGameOver || _isEngineThinking) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Evaluating draw offer with Stockfish...'),
        duration: Duration(seconds: 1),
      ),
    );

    await _engine.setPosition(_board.toFen());
    final eval = await _engine.evaluate(depth: 4);

    final cp = eval.scoreCentipawns ?? 0;
    if (cp.abs() <= 35 || _board.halfmoveClock >= 40) {
      _onGameOver('Draw agreed by mutual consent (Evaluation balanced at ${(cp / 100).toStringAsFixed(2)}).');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Stockfish: 'Draw offer declined (${cp > 0 ? "Advantage White" : "Advantage Black"}). The game continues.'"),
            backgroundColor: Colors.blueGrey,
          ),
        );
      }
    }
  }

  void _handleUndo() {
    if (_isGameOver || _isEngineThinking || _moves.isEmpty) return;

    if (_isRated) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: ctx.surf,
          title: Text('Takeback in Serious/Rated Mode', style: TextStyle(color: ctx.txt)),
          content: Text(
            'Undoing moves in a Serious/Rated game will mark this match as Unrated Practice.\n\nDo you want to proceed with the takeback?',
            style: TextStyle(color: ctx.txtSec, fontSize: 13),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() => _isRated = false);
                _executeTakeback();
              },
              child: const Text('Convert to Practice & Undo'),
            ),
          ],
        ),
      );
    } else {
      _executeTakeback();
    }
  }

  void _executeTakeback() {
    if (_moves.isEmpty) return;

    int pliesToRevert = 1;
    if (_playVsEngine) {
      if (_board.activeColor == _playerColor) {
        // Opponent engine moved, player also moved -> revert 2 plies
        pliesToRevert = _moves.length >= 2 ? 2 : 1;
      } else {
        // Player just moved and engine hasn't moved yet -> revert 1 ply
        pliesToRevert = 1;
      }
    }

    for (int i = 0; i < pliesToRevert && _moves.isNotEmpty; i++) {
      _moves.removeLast();
      if (_board.history.isNotEmpty) {
        _board.unmakeMove();
      }
      if (_activeSession.moveSanList.isNotEmpty) {
        _activeSession.moveSanList.removeLast();
      }
      if (_activeSession.moveUciList.isNotEmpty) {
        _activeSession.moveUciList.removeLast();
      }
      if (_activeSession.moveTimesMs.isNotEmpty) {
        _activeSession.moveTimesMs.removeLast();
      }
    }

    _activeSession.currentFen = _board.toFen();
    _activeSession.rebuildPgn();
    widget.repository.saveActiveGameSession(_activeSession);

    if (_moves.isEmpty) {
      _clock.pause();
    }

    _clearHints();
    setState(() {});
  }

  void _togglePause() {
    if (_isGameOver) return;
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _clock.pause();
      } else {
        _clock.start();
      }
    });
  }

  Future<void> _requestProgressiveHint() async {
    if (_isGameOver || _isEngineThinking || _board.activeColor != _playerColor) return;

    if (_hintLevel == 0 || _hintBestMove == null) {
      await _engine.setPosition(_board.toFen());
      final eval = await _engine.evaluate(depth: 4);
      _hintBestMove = eval.bestMove;
      if (_hintBestMove == null) return;
    }

    final bestMove = _hintBestMove!;
    final piece = _board.pieceAt(bestMove.from);
    final san = MoveGenerator.moveToSan(_board, bestMove);

    setState(() {
      if (_hintLevel == 0) {
        _hintLevel = 1;
        _hintExplanation = 'Hint 1/4 (Candidate Area): Focus on your ${piece?.type.name.toUpperCase() ?? "piece"} around ${bestMove.from.name} and the ${bestMove.to.file <= 3 ? "queenside" : "kingside"} center.';
      } else if (_hintLevel == 1) {
        _hintLevel = 2;
        _highlightedSquares = [bestMove.from];
        _hintExplanation = 'Hint 2/4 (Source Square): Look at the square ${bestMove.from.name}. Can you visualize its best active destination?';
      } else if (_hintLevel == 2) {
        _hintLevel = 3;
        _highlightedSquares = [bestMove.from, bestMove.to];
        _boardArrows = [BoardArrow(from: bestMove.from, to: bestMove.to, color: const Color(0xFFF59E0B))];
        _hintExplanation = 'Hint 3/4 (Target Trajectory): Move along ${bestMove.from.name} -> ${bestMove.to.name}.';
      } else {
        _hintLevel = 4;
        _hintExplanation = 'Hint 4/4 (Full Solution): Play $san! This secures active piece coordination and maintains initiative.';
      }
    });
  }

  void _openQuickCustomizer(BuildContext context) {
    final profile = widget.repository.getProfile();
    showDialog(
      context: context,
      builder: (ctx) => BoardCustomizerDialog(
        currentBoardTheme: profile.boardThemeName,
        currentPieceTheme: profile.pieceThemeName,
        currentBoardSize: profile.boardSizeMode,
        currentAnimationSpeed: profile.animationSpeed,
        showCoordinates: profile.showCoordinates,
        showMoveHighlights: profile.showMoveHighlights,
        showLegalMoveHints: profile.showLegalMoveHints,
        onApplied: ({
          required String boardTheme,
          required String pieceTheme,
          required String boardSize,
          required String animationSpeed,
          required bool showCoordinates,
          required bool showMoveHighlights,
          required bool showLegalMoveHints,
        }) {
          profile.boardThemeName = boardTheme;
          profile.pieceThemeName = pieceTheme;
          profile.boardSizeMode = boardSize;
          profile.animationSpeed = animationSpeed;
          profile.showCoordinates = showCoordinates;
          profile.showMoveHighlights = showMoveHighlights;
          profile.showLegalMoveHints = showLegalMoveHints;
          widget.repository.saveProfile(profile);
          setState(() {});
        },
      ),
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

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied to clipboard!'), duration: const Duration(seconds: 2)),
    );
  }

  void _resumeUnfinishedGame() {
    if (_pendingUnfinishedGame == null) return;
    final saved = _pendingUnfinishedGame!;
    setState(() {
      _board = Board.fromFen(saved.currentFen);
      _isTournamentMode = saved.isTournamentMode;
      _playVsEngine = saved.isVsEngine;
      _thoughtNotes.addAll(saved.thoughtNotes);
      _pendingUnfinishedGame = null;
    });
  }

  void _discardUnfinishedGame() {
    widget.repository.clearUnfinishedGame();
    setState(() {
      _pendingUnfinishedGame = null;
    });
  }

  Board _getDisplayBoard() {
    if (_replayPlyIndex == null || _replayPlyIndex! >= _moves.length) {
      return _board;
    }
    final replayBoard = Board.initial();
    for (int i = 0; i <= _replayPlyIndex!; i++) {
      if (i < _moves.length && _moves[i].move != null) {
        replayBoard.makeMove(_moves[i].move!);
      }
    }
    return replayBoard;
  }

  String _buildPgn() {
    final game = PgnGame(
      headers: {
        'Event': _setupConfig.gameType,
        'Site': 'ChessMaster Offline',
        'Date': DateTime.now().toIso8601String().substring(0, 10),
        'Round': '1',
        'White': _playerColor == PieceColor.white ? 'User' : 'Engine (${_setupConfig.strengthPreset})',
        'Black': _playerColor == PieceColor.black ? 'User' : 'Engine (${_setupConfig.strengthPreset})',
        'Result': _isGameOver ? (_board.activeColor == PieceColor.black ? '1-0' : '0-1') : '*',
        'TimeControl': _setupConfig.timeControlName,
      },
      moves: _moves,
    );
    return game.toPgnString();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _engine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.repository.getProfile();
    final boardTheme = ChessBoardTheme.fromName(profile.boardThemeName);
    final pieceTheme = PieceTheme.fromName(profile.pieceThemeName);
    final displayBoard = _getDisplayBoard();

    return Scaffold(
      backgroundColor: context.bg,
      body: Column(
        children: [
          // Unfinished game recovery banner
          if (_pendingUnfinishedGame != null)
            Container(
              width: double.infinity,
              color: Colors.amber.withAlpha(35),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.restore, color: Colors.amber, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Unfinished game detected (${_pendingUnfinishedGame!.moveSanList.length} plies, ${_pendingUnfinishedGame!.timeControl}).',
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _resumeUnfinishedGame,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    child: const Text('Resume Game'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _discardUnfinishedGame,
                    child: Text('Discard', style: TextStyle(color: context.txtSec)),
                  ),
                ],
              ),
            ),

          // Match Setup Summary Header with Game Library Trigger
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.surf,
              border: Border(bottom: BorderSide(color: context.brd)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Icon(
                    _playerColor == PieceColor.white ? Icons.circle_outlined : Icons.circle,
                    size: 16,
                    color: ChessTheme.primaryLight,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Playing as ${_playerColor == PieceColor.white ? "White" : "Black"}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: ChessTheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${_setupConfig.strengthPreset} (Est. ${_setupConfig.eloRating})',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _isRated ? const Color(0xFF10B981).withAlpha(25) : Colors.amber.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _isRated ? _setupConfig.gameType : 'Unrated Practice',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _isRated ? const Color(0xFF10B981) : Colors.amber,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '•  ${_setupConfig.timeControlName}',
                    style: TextStyle(fontSize: 11, color: context.txtSec),
                  ),
                  const SizedBox(width: 20),

                  // Engine Thinking Indicator
                  if (_isEngineThinking && !_isTournamentMode)
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: ChessTheme.accentGold.withAlpha(20),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: ChessTheme.accentGold,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Thinking',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: ChessTheme.accentGold),
                          ),
                        ],
                      ),
                    ),

                  // Game Library Trigger
                  OutlinedButton.icon(
                    icon: const Icon(Icons.library_books, size: 14),
                    label: const Text('Game Library'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.txt,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _openGameLibrary,
                  ),
                  const SizedBox(width: 8),

                  // Quick Setup Modal Trigger
                  ElevatedButton.icon(
                    icon: const Icon(Icons.tune, size: 14),
                    label: const Text('New Game Setup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ChessTheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _openPlaySetupDialog,
                  ),
                ],
              ),
            ),
          ),

          // Main Gameplay Workspace wrapped in ResponsiveChessWorkspace
          Expanded(
            child: ResponsiveChessWorkspace(
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildClockBar(
                    context,
                    name: _playVsEngine
                        ? 'Engine (${_engine.engineName} - Est. ${_setupConfig.eloRating})'
                        : (_playerColor == PieceColor.white ? 'Black Player' : 'White Player'),
                    timeString: _setupConfig.initialMinutes == 0
                        ? 'Untimed'
                        : (_playerColor == PieceColor.white ? _clock.blackDisplayString : _clock.whiteDisplayString),
                    isActive: _clock.activeColor != _playerColor,
                    isEngine: _playVsEngine,
                  ),
                  if (_hintExplanation != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 600),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: ChessTheme.accentGold.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: ChessTheme.accentGold),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.lightbulb, color: ChessTheme.accentGold, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _hintExplanation!,
                              style: const TextStyle(fontSize: 12, color: ChessTheme.accentGold, fontWeight: FontWeight.w600),
                            ),
                          ),
                          if (_hintLevel < 4)
                            TextButton(
                              onPressed: _requestProgressiveHint,
                              child: const Text('Next Hint', style: TextStyle(fontSize: 11, color: ChessTheme.accentGold)),
                            ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16, color: ChessTheme.accentGold),
                            onPressed: () => setState(_clearHints),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              boardBuilder: (context, boardSize) {
                return SizedBox(
                  width: boardSize,
                  height: boardSize,
                  child: ChessBoardWidget(
                    board: displayBoard,
                    isFlipped: _isFlipped,
                    onMovePlayed: _onMovePlayed,
                    isInteractive: !_isGameOver &&
                        !_isPaused &&
                        _replayPlyIndex == null &&
                        (_playVsEngine ? _board.activeColor == _playerColor : true),
                    lastMoveFrom: _moves.isNotEmpty ? _moves.last.move?.from : null,
                    lastMoveTo: _moves.isNotEmpty ? _moves.last.move?.to : null,
                    boardTheme: boardTheme,
                    pieceTheme: pieceTheme,
                    animationDurationMs: _getAnimationDurationMs(profile.animationSpeed),
                    showCoordinates: profile.showCoordinates,
                    showMoveHighlights: profile.showMoveHighlights,
                    showLegalMoveHints: profile.showLegalMoveHints,
                    highlightedSquares: _highlightedSquares,
                    arrows: _boardArrows,
                  ),
                );
              },
              footer: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildClockBar(
                    context,
                    name: 'Player (You)',
                    timeString: _setupConfig.initialMinutes == 0
                        ? 'Untimed'
                        : (_playerColor == PieceColor.white ? _clock.whiteDisplayString : _clock.blackDisplayString),
                    isActive: _clock.activeColor == _playerColor,
                    isEngine: false,
                  ),
                  const SizedBox(height: 8),
                  _buildControlsToolbar(context),
                ],
              ),
              sidePanel: _buildSidePanel(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidePanel(BuildContext context) {
    return Column(
      children: [
        // Game Status Card & Post-Game 5 One-Click Actions
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _setupConfig.gameType.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ChessTheme.primaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _clock.isRunning ? 'RUNNING' : (_isPaused ? 'PAUSED' : 'STOPPED'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _clock.isRunning ? const Color(0xFF10B981) : Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _gameStatusMessage,
                style: TextStyle(fontSize: 13, color: context.txt),
              ),

              // Post-Game Action Buttons: 5 Key Actions
              if (_isGameOver) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // 1. ANALYZE GAME
                    ElevatedButton.icon(
                      icon: const Icon(Icons.analytics_outlined, size: 15),
                      label: const Text('ANALYZE GAME'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChessTheme.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        widget.onNavigate('analysis', args: {
                          'gameSession': _activeSession,
                          'pgn': _buildPgn(),
                          'fen': _board.toFen(),
                        });
                      },
                    ),

                    // 2. REVIEW MISTAKES
                    ElevatedButton.icon(
                      icon: const Icon(Icons.psychology, size: 15),
                      label: const Text('REVIEW MISTAKES'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.surfLight,
                        foregroundColor: context.txt,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        widget.onNavigate('analysis', args: {
                          'gameSession': _activeSession,
                          'tab': 'mistakes',
                          'pgn': _buildPgn(),
                        });
                      },
                    ),

                    // 2b. TRAIN MISTAKES (1-Click direct retraining)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.model_training, size: 15),
                      label: const Text('TRAIN MISTAKES'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChessTheme.accentGold.withAlpha(30),
                        foregroundColor: ChessTheme.accentGold,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        widget.onNavigate('analysis', args: {
                          'gameSession': _activeSession,
                          'tab': 'mistakes',
                          'autoTrain': true,
                          'pgn': _buildPgn(),
                        });
                      },
                    ),

                    // 3. CREATE VIDEO
                    ElevatedButton.icon(
                      icon: const Icon(Icons.movie_creation_outlined, size: 15),
                      label: const Text('CREATE VIDEO'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.surfLight,
                        foregroundColor: context.txt,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        widget.onNavigate('video', args: {
                          'gameSession': _activeSession,
                          'pgn': _buildPgn(),
                        });
                      },
                    ),

                    // 4. REMATCH
                    OutlinedButton.icon(
                      icon: const Icon(Icons.refresh, size: 15),
                      label: const Text('REMATCH'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.txt,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        final newSide = _playerColor == PieceColor.white ? PieceColor.black : PieceColor.white;
                        final rematchConfig = PlaySetupConfig(
                          playerColor: newSide,
                          strengthPreset: _setupConfig.strengthPreset,
                          eloRating: _setupConfig.eloRating,
                          gameType: _setupConfig.gameType,
                          timeControlName: _setupConfig.timeControlName,
                          initialMinutes: _setupConfig.initialMinutes,
                          incrementSeconds: _setupConfig.incrementSeconds,
                        );
                        _startNewGameWithConfig(rematchConfig);
                      },
                    ),

                    // 5. EXPORT PGN
                    IconButton(
                      icon: const Icon(Icons.download_outlined, size: 18),
                      tooltip: 'SAVE / EXPORT PGN',
                      onPressed: () => _copyToClipboard(_buildPgn(), 'PGN'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // Move Notation Tree
        Expanded(
          child: MoveListWidget(
            moves: _moves,
            currentPlyIndex: _replayPlyIndex ?? _moves.length,
          ),
        ),

        // Replay Navigation Toolbar after game over
        if (_isGameOver && _moves.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            margin: const EdgeInsets.only(top: 8),
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
                  onPressed: () => setState(() => _replayPlyIndex = 0),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 18),
                  tooltip: 'Previous Move',
                  onPressed: () {
                    final cur = _replayPlyIndex ?? _moves.length;
                    if (cur > 0) setState(() => _replayPlyIndex = cur - 1);
                  },
                ),
                Text(
                  _replayPlyIndex != null
                      ? 'Ply ${_replayPlyIndex! + 1}/${_moves.length}'
                      : 'Final Position',
                  style: TextStyle(fontSize: 11, color: context.txtSec),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 18),
                  tooltip: 'Next Move',
                  onPressed: () {
                    final cur = _replayPlyIndex ?? _moves.length;
                    if (cur < _moves.length) setState(() => _replayPlyIndex = cur + 1);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.last_page, size: 18),
                  tooltip: 'Live/Final Position',
                  onPressed: () => setState(() => _replayPlyIndex = null),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildClockBar(
    BuildContext context, {
    required String name,
    required String timeString,
    required bool isActive,
    required bool isEngine,
  }) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? context.surfLight : context.surf,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? ChessTheme.primary : context.brd,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(
                  isEngine ? Icons.memory : Icons.person,
                  size: 16,
                  color: isActive ? ChessTheme.primaryLight : context.txtMut,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: context.txt,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: context.isDark ? Colors.black45 : context.surfLight,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: context.brd),
            ),
            child: Text(
              timeString,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isActive ? ChessTheme.primaryLight : context.txt,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsToolbar(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.brd),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Undo / Takeback
            IconButton(
              icon: const Icon(Icons.undo, size: 18),
              tooltip: 'Takeback',
              color: _moves.isNotEmpty && !_isGameOver ? context.txt : context.txtMut,
              onPressed: _moves.isNotEmpty && !_isGameOver ? _handleUndo : null,
            ),

            // Progressive Hint
            IconButton(
              icon: const Icon(Icons.lightbulb_outline, size: 18),
              tooltip: 'Progressive Hint (1 to 4)',
              color: !_isGameOver && _board.activeColor == _playerColor ? ChessTheme.accentGold : context.txtMut,
              onPressed: !_isGameOver && _board.activeColor == _playerColor ? _requestProgressiveHint : null,
            ),

            // Pause / Resume
            IconButton(
              icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause, size: 18),
              tooltip: _isPaused ? 'Resume Clock' : 'Pause Game',
              color: !_isGameOver ? context.txt : context.txtMut,
              onPressed: !_isGameOver ? _togglePause : null,
            ),

            // Flip Board
            IconButton(
              icon: const Icon(Icons.swap_vert, size: 18),
              tooltip: 'Flip Board',
              color: context.txt,
              onPressed: () => setState(() => _isFlipped = !_isFlipped),
            ),

            // Offer Draw
            IconButton(
              icon: const Icon(Icons.handshake_outlined, size: 18),
              tooltip: 'Offer Draw',
              color: !_isGameOver ? context.txt : context.txtMut,
              onPressed: !_isGameOver ? _offerDraw : null,
            ),

            // Resign
            IconButton(
              icon: const Icon(Icons.flag_outlined, size: 18),
              tooltip: 'Resign Game',
              color: !_isGameOver ? ChessTheme.qualityBlunder : context.txtMut,
              onPressed: !_isGameOver ? _confirmResign : null,
            ),

            // Restart / New Game
            IconButton(
              icon: const Icon(Icons.restart_alt, size: 18),
              tooltip: 'Reset / New Game',
              color: context.txt,
              onPressed: _confirmRestart,
            ),

            // Board & Piece Customizer
            IconButton(
              icon: const Icon(Icons.palette_outlined, size: 18),
              tooltip: 'Customize Board & Pieces',
              color: ChessTheme.primaryLight,
              onPressed: () => _openQuickCustomizer(context),
            ),

            // Copy PGN
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              tooltip: 'Copy PGN',
              color: context.txtSec,
              onPressed: () => _copyToClipboard(_buildPgn(), 'PGN'),
            ),

            // Copy FEN
            IconButton(
              icon: const Icon(Icons.code, size: 18),
              tooltip: 'Copy FEN',
              color: context.txtSec,
              onPressed: () => _copyToClipboard(_board.toFen(), 'FEN'),
            ),
          ],
        ),
      ),
    );
  }
}
