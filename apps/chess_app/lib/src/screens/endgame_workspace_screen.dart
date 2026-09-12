import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:flutter/material.dart';
import '../theme/board_size_policy.dart';
import '../theme/chess_theme.dart';
import '../widgets/board/chess_board_widget.dart';

class EndgamePositionModel {
  final String id;
  final String title;
  final String category;
  final String fen;
  final String objective;
  final String keyPrinciples;
  final List<String> bestSequence;

  const EndgamePositionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.fen,
    required this.objective,
    required this.keyPrinciples,
    required this.bestSequence,
  });
}

/// Dedicated Endgame Workspace for mastering essential theoretical and practical endgames.
class EndgameWorkspaceScreen extends StatefulWidget {
  const EndgameWorkspaceScreen({super.key});

  @override
  State<EndgameWorkspaceScreen> createState() => _EndgameWorkspaceScreenState();
}

class _EndgameWorkspaceScreenState extends State<EndgameWorkspaceScreen> {
  static const List<EndgamePositionModel> curatedEndgames = [
    EndgamePositionModel(
      id: 'lucena',
      title: 'The Lucena Position (Building a Bridge)',
      category: 'Rook Endgames',
      fen: '1K1k4/1P6/8/8/8/8/r7/5R2 w - - 0 1',
      objective: 'White to move and win by "building a bridge" with Rf4 and Rd4+.',
      keyPrinciples: '1. Cut off the enemy king. 2. Place rook on 4th rank (Rf4!). 3. King steps out, rook shields against checks.',
      bestSequence: ['Rf4', 'Rd2', 'Ke8'],
    ),
    EndgamePositionModel(
      id: 'philidor',
      title: 'The Philidor Position (3rd Rank Defense)',
      category: 'Rook Endgames',
      fen: '4k3/R7/8/4P3/8/8/8/4K2r b - - 0 1',
      objective: 'Black to move and hold a draw by 6th/3rd rank defense, checking from behind.',
      keyPrinciples: '1. Keep rook on 6th (3rd) rank to prevent king advance. 2. When pawn advances to 6th rank, check relentlessly from behind.',
      bestSequence: ['Rh6', 'Ra8+', 'Kf7'],
    ),
    EndgamePositionModel(
      id: 'queen_vs_pawn_c7',
      title: 'Queen vs Pawn on 7th (Bishop/Rook Pawn Draw)',
      category: 'Pawn Endgames',
      fen: '8/2P5/8/8/8/k7/8/2K1Q3 w - - 0 1',
      objective: 'Winning or drawing mechanics with queen vs advanced pawn.',
      keyPrinciples: 'Centralize the queen, force enemy king in front of the pawn to win tempi for own king approach.',
      bestSequence: ['Qc3+', 'Kb1', 'Qd3+'],
    ),
    EndgamePositionModel(
      id: 'direct_opposition',
      title: 'Direct Opposition & Key Squares',
      category: 'King & Pawn',
      fen: '8/8/4k3/8/4K3/8/4P3/8 w - - 0 1',
      objective: 'White to move and maintain direct opposition to promote the pawn.',
      keyPrinciples: 'Take vertical opposition! King must lead the pawn to seize key squares.',
      bestSequence: ['Kd4', 'Kd6', 'e4'],
    ),
  ];

  late EndgamePositionModel _activePosition;
  late Board _board;
  final List<String> _playedMoves = [];
  Square? _lastMoveFrom;
  Square? _lastMoveTo;
  bool _isSuccess = false;
  String _statusFeedback = '';
  late final ChessEngine _engine;

  @override
  void initState() {
    super.initState();
    _activePosition = curatedEndgames.first;
    _engine = EmbeddedHeuristicEngine();
    _engine.initialize();
    _loadPosition(_activePosition);
  }

  void _loadPosition(EndgamePositionModel pos) {
    setState(() {
      _activePosition = pos;
      _board = Board.fromFen(pos.fen);
      _playedMoves.clear();
      _lastMoveFrom = null;
      _lastMoveTo = null;
      _isSuccess = false;
      _statusFeedback = pos.objective;
    });
  }

  void _onMovePlayed(Move move) async {
    final san = MoveGenerator.moveToSan(_board, move);
    _board.makeMove(move);
    _playedMoves.add(san);
    _lastMoveFrom = move.from;
    _lastMoveTo = move.to;

    setState(() {
      _statusFeedback = 'Played $san. Analyzing response...';
    });

    final status = MoveGenerator.getGameStatus(_board);
    if (status == GameStatus.checkmate) {
      setState(() {
        _isSuccess = true;
        _statusFeedback = 'Victory! Checkmate achieved.';
      });
      return;
    }

    if (status == GameStatus.stalemate || status.isDraw) {
      setState(() {
        _statusFeedback = 'Position drawn.';
      });
      return;
    }

    // Engine responds automatically
    await Future.delayed(const Duration(milliseconds: 300));
    await _engine.setPosition(_board.toFen());
    final eval = await _engine.evaluate(depth: 3);

    if (eval.bestMove != null && mounted) {
      final replySan = MoveGenerator.moveToSan(_board, eval.bestMove!);
      _board.makeMove(eval.bestMove!);
      _playedMoves.add(replySan);

      setState(() {
        _statusFeedback = 'Opponent replied $replySan. Find the next precise continuation!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 900;

          if (isCompact) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  Builder(builder: (ctx) {
                    final boardSize = BoardSizePolicy.calculateBoardSize(
                      constraints: constraints,
                      mode: BoardSizeMode.compact,
                    );
                    return SizedBox(
                      width: boardSize,
                      height: boardSize,
                      child: ChessBoardWidget(
                        board: _board,
                        onMovePlayed: _onMovePlayed,
                        lastMoveFrom: _lastMoveFrom,
                        lastMoveTo: _lastMoveTo,
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  _buildPositionDetails(),
                  const SizedBox(height: 16),
                  _buildCuratedList(curatedEndgames, height: 260),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Center(
                          child: ChessBoardWidget(
                            board: _board,
                            onMovePlayed: _onMovePlayed,
                            lastMoveFrom: _lastMoveFrom,
                            lastMoveTo: _lastMoveTo,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildStatusCard(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _buildPositionDetails(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildCuratedList(curatedEndgames),
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

  Widget _buildHeader() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ChessTheme.accentGold.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shield, color: ChessTheme.accentGold, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ENDGAME WORKSPACE',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5, color: context.txt),
                ),
                Text(
                  'Theoretical accuracy and technique mastery',
                  style: TextStyle(fontSize: 12, color: context.txtSec),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.replay, size: 16),
          label: const Text('Reset Position'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.surfLight,
            foregroundColor: context.txt,
          ),
          onPressed: () => _loadPosition(_activePosition),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _isSuccess ? ChessTheme.primary.withAlpha(20) : context.surf,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _isSuccess ? ChessTheme.primaryLight : context.brd),
      ),
      child: Row(
        children: [
          Icon(
            _isSuccess ? Icons.check_circle : Icons.info_outline,
            color: _isSuccess ? ChessTheme.primaryLight : ChessTheme.secondary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _statusFeedback,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _isSuccess ? ChessTheme.primaryLight : context.txt,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.brd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ChessTheme.accentGold.withAlpha(40),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _activePosition.category.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: ChessTheme.accentGold, fontSize: 11),
                ),
              ),
              Text('Master Practice Mode', style: TextStyle(fontSize: 11, color: context.txtMut)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _activePosition.title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.txt),
          ),
          const SizedBox(height: 8),
          Text(_activePosition.objective, style: TextStyle(fontSize: 13, color: context.txtSec)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.surfLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Key GM Principles:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txt)),
                const SizedBox(height: 4),
                Text(_activePosition.keyPrinciples, style: TextStyle(fontSize: 12, color: context.txtSec)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCuratedList(List<EndgamePositionModel> positions, {double? height}) {
    final listWidget = Container(
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.brd),
      ),
      child: ListView.separated(
        itemCount: positions.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, idx) {
          final pos = positions[idx];
          final isSelected = _activePosition.id == pos.id;
          return Material(
            type: MaterialType.transparency,
            child: ListTile(
              dense: true,
              selected: isSelected,
              selectedTileColor: ChessTheme.accentGold.withAlpha(20),
              title: Text(pos.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.txt)),
              subtitle: Text(pos.category, style: TextStyle(fontSize: 11, color: context.txtMut)),
              trailing: Icon(Icons.arrow_forward_ios, size: 14, color: context.txtMut),
              onTap: () => _loadPosition(pos),
            ),
          );
        },
      ),
    );

    if (height != null) {
      return SizedBox(height: height, child: listWidget);
    }
    return listWidget;
  }
}
