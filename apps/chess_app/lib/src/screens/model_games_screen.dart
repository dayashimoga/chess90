import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import '../theme/board_size_policy.dart';
import '../theme/chess_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/move_list_widget.dart';

/// Historical model games browser and Guess-the-Move training center.
class ModelGamesScreen extends StatefulWidget {
  final Function(String screenKey, {dynamic args}) onNavigate;

  const ModelGamesScreen({super.key, required this.onNavigate});

  @override
  State<ModelGamesScreen> createState() => _ModelGamesScreenState();
}

class _ModelGamesScreenState extends State<ModelGamesScreen> {
  List<ModelGame> _games = [];
  ModelGame? _selectedGame;
  late PgnGame _pgnGame;
  late Board _board;
  int _currentPly = 0;
  final List<Board> _boardHistory = [];

  bool _isGuessTheMoveActive = false;
  String _guessFeedback = 'Guess the master\'s move!';

  @override
  void initState() {
    super.initState();
    _games = ModelGamesDatabase.curatedGames;
    _selectGame(_games.first);
  }

  void _selectGame(ModelGame game) {
    setState(() {
      _selectedGame = game;
      _pgnGame = game.toPgnGame();
      _board = _pgnGame.setupFen != null ? Board.fromFen(_pgnGame.setupFen!) : Board.initial();

      _boardHistory.clear();
      _boardHistory.add(_board.clone());
      for (final node in _pgnGame.moves) {
        if (node.move != null) {
          _board.makeMove(node.move!);
          _boardHistory.add(_board.clone());
        }
      }
      _currentPly = 0;
      _board = _boardHistory.first.clone();
      _guessFeedback = 'Guess the master\'s move!';
    });
  }

  void _goToPly(int ply) {
    setState(() {
      _currentPly = ply.clamp(0, _boardHistory.length - 1);
      _board = _boardHistory[_currentPly].clone();
    });
  }

  void _onUserGuess(Move move) {
    if (_currentPly >= _pgnGame.moves.length) return;

    final expectedNode = _pgnGame.moves[_currentPly];
    final playedSan = MoveGenerator.moveToSan(_board, move);

    if (playedSan == expectedNode.san) {
      setState(() {
        _guessFeedback = 'Brilliant! You found the GM move: $playedSan!';
        _goToPly(_currentPly + 1);
      });
    } else {
      setState(() {
        _guessFeedback = '$playedSan is a playable idea, but the GM chose a different plan. Try again!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedGame == null) return const SizedBox();

    return Scaffold(
      backgroundColor: context.bg,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            // Left: Games List Directory
            SizedBox(
              width: 320,
              child: Container(
                decoration: BoxDecoration(
                  color: context.surf,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.brd),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: context.brd)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.auto_stories, color: ChessTheme.primaryLight, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Master Model Games',
                            style: TextStyle(fontWeight: FontWeight.bold, color: context.txt),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _games.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final game = _games[i];
                          final isSelected = game.id == _selectedGame!.id;

                          return Material(
                            color: Colors.transparent,
                            child: ListTile(
                              selected: isSelected,
                              selectedTileColor: context.surfLight,
                              onTap: () => _selectGame(game),
                              title: Text(
                                '${game.whitePlayer} vs ${game.blackPlayer}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: context.txt,
                                ),
                              ),
                              subtitle: Text(
                                '${game.year} • ${game.eco} ${game.openingName}',
                                style: TextStyle(fontSize: 11, color: context.txtMut),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 24),

            // Middle: Interactive Board + Stepper
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  // Guess-the-move Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: _isGuessTheMoveActive ? context.surfLight : context.surf,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _isGuessTheMoveActive ? ChessTheme.primary : context.brd),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isGuessTheMoveActive ? Icons.psychology : Icons.info_outline,
                          color: _isGuessTheMoveActive ? ChessTheme.primaryLight : context.txtSec,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isGuessTheMoveActive ? _guessFeedback : _selectedGame!.educationalSummary,
                            style: TextStyle(fontSize: 13, color: context.txt),
                          ),
                        ),
                        Switch(
                          value: _isGuessTheMoveActive,
                          activeColor: ChessTheme.primary,
                          onChanged: (val) {
                            setState(() {
                              _isGuessTheMoveActive = val;
                              _guessFeedback = 'Guess the master\'s move!';
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final boardSize = BoardSizePolicy.calculateBoardSize(
                            constraints: constraints,
                            mode: BoardSizeMode.standard,
                          );
                          return SizedBox(
                            width: boardSize,
                            height: boardSize,
                            child: ChessBoardWidget(
                              board: _board,
                              isInteractive: _isGuessTheMoveActive,
                              onMovePlayed: _isGuessTheMoveActive ? _onUserGuess : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Stepper controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.first_page),
                        onPressed: _currentPly > 0 ? () => _goToPly(0) : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _currentPly > 0 ? () => _goToPly(_currentPly - 1) : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Ply $_currentPly / ${_boardHistory.length - 1}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: context.txt),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _currentPly < _boardHistory.length - 1 ? () => _goToPly(_currentPly + 1) : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.last_page),
                        onPressed: _currentPly < _boardHistory.length - 1 ? () => _goToPly(_boardHistory.length - 1) : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // Right: Move Tree & Send to Video Studio Button
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.video_library),
                      label: const Text('Export in Video Studio', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChessTheme.secondary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        widget.onNavigate('video', args: {
                          'pgn': _selectedGame!.pgn,
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: MoveListWidget(
                      moves: _pgnGame.moves,
                      currentPlyIndex: _currentPly,
                      onMoveSelected: _goToPly,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
