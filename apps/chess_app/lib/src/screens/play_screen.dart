import 'dart:async';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/move_list_widget.dart';

/// Play screen supporting Human vs Engine, Pass & Play, and Tournament Mode with classical clocks.
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
  Timer? _timer;

  bool _isTournamentMode = false;
  bool _playVsEngine = true;
  final PieceColor _playerColor = PieceColor.white;
  final List<PgnMoveNode> _moves = [];
  final Map<int, String> _thoughtNotes = {};
  bool _isGameOver = false;
  String _gameStatusMessage = 'Game in progress';
  UnfinishedGame? _pendingUnfinishedGame;

  @override
  void initState() {
    super.initState();
    _pendingUnfinishedGame = widget.repository.getUnfinishedGame();

    if (widget.initialArgs is Map && widget.initialArgs['isTournament'] == true) {
      _isTournamentMode = true;
      _clock = ChessClock.classical45Plus15();
    } else {
      _clock = ChessClock.rapid15Plus10();
    }

    if (_pendingUnfinishedGame != null) {
      _clock.whiteRemaining = Duration(seconds: _pendingUnfinishedGame!.whiteRemainingSeconds);
      _clock.blackRemaining = Duration(seconds: _pendingUnfinishedGame!.blackRemainingSeconds);
    }

    _board = Board.initial();
    _engine = widget.engine ??
        (NativeStockfishEngine.isSupported
            ? NativeStockfishEngine()
            : EmbeddedHeuristicEngine());
    _engine.initialize();

    _startClockTimer();
    _clock.start();
  }

  void _startClockTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (mounted && _clock.isRunning) {
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
    if (_isGameOver) return;

    final prevBoard = _board.clone();
    final san = MoveGenerator.moveToSan(prevBoard, move);

    _board.makeMove(move);
    _clock.onMovePlayed();

    _moves.add(PgnMoveNode(
      ply: _moves.length + 1,
      moveNumber: (_moves.length ~/ 2) + 1,
      isWhite: prevBoard.activeColor == PieceColor.white,
      san: san,
      move: move,
    ));

    // Save unfinished game for crash-safe recovery
    widget.repository.saveUnfinishedGame(UnfinishedGame(
      id: 'active_game',
      currentFen: _board.toFen(),
      moveSanList: _moves.map((m) => m.san).toList(),
      timeControl: _isTournamentMode ? 'Classical 45+15' : 'Rapid 15+10',
      whiteRemainingSeconds: _clock.whiteRemaining.inSeconds,
      blackRemainingSeconds: _clock.blackRemaining.inSeconds,
      isVsEngine: _playVsEngine,
      isTournamentMode: _isTournamentMode,
      startedAt: DateTime.now(),
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

  Future<void> _playEngineMove() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _engine.setPosition(_board.toFen());
    final eval = await _engine.evaluate(depth: 3);

    if (eval.bestMove != null && !_isGameOver) {
      _onMovePlayed(eval.bestMove!);
    }
  }

  void _onGameOver(String message) {
    _isGameOver = true;
    _clock.pause();
    _gameStatusMessage = message;

    // Clear active unfinished game on completion
    widget.repository.clearUnfinishedGame();

    // Save game record to repository
    final pgn = _buildPgn();
    final record = GameRecord(
      id: 'game_${DateTime.now().millisecondsSinceEpoch}',
      pgn: pgn,
      playedDate: DateTime.now(),
      whitePlayer: _playerColor == PieceColor.white ? 'Player' : 'Engine',
      blackPlayer: _playerColor == PieceColor.black ? 'Player' : 'Engine',
      result: _board.activeColor == PieceColor.black ? '1-0' : '0-1',
      timeControl: _isTournamentMode ? 'Classical 45+15' : 'Rapid 15+10',
    );
    widget.repository.saveGame(record);

    setState(() {});
  }

  String _buildPgn() {
    final game = PgnGame(
      headers: {
        'Event': _isTournamentMode ? 'ChessMaster Tournament Simulation' : 'Serious Game',
        'Site': 'ChessMaster Offline',
        'Date': DateTime.now().toIso8601String().substring(0, 10),
        'Round': '1',
        'White': _playerColor == PieceColor.white ? 'User' : 'Engine',
        'Black': _playerColor == PieceColor.black ? 'User' : 'Engine',
        'Result': _isGameOver ? '*' : '*',
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
    return Scaffold(
      backgroundColor: context.bg,
      body: Column(
        children: [
          if (_pendingUnfinishedGame != null)
            Container(
              width: double.infinity,
              color: Colors.amber.withValues(alpha: 0.15),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                    child: const Text('Discard', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  // Left: Clocks + Chess Board
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        // Opponent Clock Bar
                        _buildClockBar(
                          context,
                          name: _playVsEngine ? 'Engine (${_engine.engineName})' : 'Black Player',
                    timeString: _clock.blackDisplayString,
                    isActive: _clock.activeColor == PieceColor.black,
                  ),

                  const SizedBox(height: 12),

                  // Chess Board
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 480,
                        height: 480,
                        child: ChessBoardWidget(
                          board: _board,
                          isFlipped: _playerColor == PieceColor.black,
                          onMovePlayed: _onMovePlayed,
                          isInteractive: !_isGameOver && (_playVsEngine ? _board.activeColor == _playerColor : true),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Player Clock Bar
                  _buildClockBar(
                    context,
                    name: 'Player (You)',
                    timeString: _clock.whiteDisplayString,
                    isActive: _clock.activeColor == PieceColor.white,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // Right: Game Details, Mode Toggles, Move List
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
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
                            Text(
                              _isTournamentMode ? 'TOURNAMENT MODE' : 'SERIOUS GAME',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: ChessTheme.primaryLight,
                              ),
                            ),
                            if (_isTournamentMode)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: ChessTheme.accentGold.withAlpha(30),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'NO HINTS • NO ENGINE',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ChessTheme.accentGold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Engine Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _engine.isFallback
                                ? Colors.amber.withValues(alpha: 0.12)
                                : const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _engine.isFallback ? Colors.amber : const Color(0xFF10B981),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _engine.isFallback ? Icons.memory : Icons.bolt,
                                size: 12,
                                color: _engine.isFallback ? Colors.amber : const Color(0xFF10B981),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _engine.engineName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: _engine.isFallback ? Colors.amber : const Color(0xFF10B981),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          _gameStatusMessage,
                          style: TextStyle(fontSize: 14, color: context.txtSec),
                        ),
                        if (_isGameOver) ...[
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.analytics_outlined),
                            label: const Text('Go to Self-Analysis Workspace'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ChessTheme.primary,
                              foregroundColor: Colors.black,
                              minimumSize: const Size(double.infinity, 38),
                            ),
                            onPressed: () {
                              widget.onNavigate('analysis', args: {
                                'pgn': _buildPgn(),
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),

                  Expanded(
                    child: MoveListWidget(
                      moves: _moves,
                      currentPlyIndex: _moves.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
);
  }

  Widget _buildClockBar(BuildContext context, {required String name, required String timeString, required bool isActive}) {
    return Container(
      width: 480,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                Icon(Icons.person, size: 18, color: isActive ? ChessTheme.primaryLight : context.txtMut),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
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
              color: context.isDark ? Colors.black45 : const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              timeString,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isActive ? ChessTheme.primaryLight : const Color(0xFFCBD5E1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
