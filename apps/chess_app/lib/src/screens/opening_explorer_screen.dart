import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';
import '../widgets/board/chess_board_widget.dart';

/// Opening Explorer and Repertoire workspace.
class OpeningExplorerScreen extends StatefulWidget {
  final Function(String screenKey, {dynamic args})? onNavigate;

  const OpeningExplorerScreen({super.key, this.onNavigate});

  @override
  State<OpeningExplorerScreen> createState() => _OpeningExplorerScreenState();
}

class _OpeningExplorerScreenState extends State<OpeningExplorerScreen> {
  late Board _board;
  final List<String> _playedMoves = [];
  EcoEntry? _currentEco;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  void _resetBoard() {
    setState(() {
      _board = Board.initial();
      _playedMoves.clear();
      _currentEco = null;
    });
  }

  void _onMovePlayed(Move move) {
    final san = MoveGenerator.moveToSan(_board, move);
    setState(() {
      _board.makeMove(move);
      _playedMoves.add(san);
      _currentEco = EcoBook.matchByMoves(_playedMoves);
    });
  }

  void _selectEco(EcoEntry entry) {
    final b = Board.initial();
    final moves = <String>[];
    for (final san in entry.movesSan) {
      final m = MoveGenerator.sanToMove(b, san);
      if (m != null) {
        b.makeMove(m);
        moves.add(san);
      }
    }
    setState(() {
      _board = b;
      _playedMoves.clear();
      _playedMoves.addAll(moves);
      _currentEco = entry;
    });
  }

  @override
  Widget build(BuildContext context) {
    final matchingOpenings = EcoBook.entries.where((e) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return e.name.toLowerCase().contains(q) || e.code.toLowerCase().contains(q);
    }).toList();

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
                  SizedBox(
                    height: 380,
                    child: ChessBoardWidget(
                      board: _board,
                      onMovePlayed: _onMovePlayed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildOpeningDetails(),
                  const SizedBox(height: 16),
                  _buildOpeningList(matchingOpenings, height: 300),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Chess Board & Controls
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
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildMoveHistoryBar(),
                    ],
                  ),
                ),

                const SizedBox(width: 24),

                // Right: Opening Explorer & Theory
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      _buildOpeningDetails(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildOpeningList(matchingOpenings),
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
                color: ChessTheme.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.explore, color: ChessTheme.primaryLight, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'OPENING EXPLORER',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5, color: context.txt),
                ),
                Text(
                  'Master canonical lines and pawn formations',
                  style: TextStyle(fontSize: 12, color: context.txtSec),
                ),
              ],
            ),
          ],
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Reset Board'),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.surfLight,
            foregroundColor: context.txt,
          ),
          onPressed: _resetBoard,
        ),
      ],
    );
  }

  Widget _buildMoveHistoryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.brd),
      ),
      child: Row(
        children: [
          Text('Moves: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: context.txtMut)),
          Expanded(
            child: Text(
              _playedMoves.isEmpty ? 'Play moves on the board or select an opening below' : _playedMoves.join(' '),
              style: TextStyle(fontSize: 13, fontFamily: 'monospace', color: context.txt),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningDetails() {
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
                  color: ChessTheme.secondary.withAlpha(40),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _currentEco?.code ?? 'ECO Book',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: ChessTheme.secondary, fontSize: 12),
                ),
              ),
              Text(
                'Classical Master Repertoire',
                style: TextStyle(fontSize: 11, color: context.txtMut),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _currentEco?.name ?? 'Standard Starting Position',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.txt),
          ),
          const SizedBox(height: 6),
          Text(
            _currentEco != null
                ? 'Standard sequence: ${_currentEco!.movesSan.join(" ")}'
                : 'Move pieces to identify the ECO opening and study strategic pawn structures.',
            style: TextStyle(fontSize: 13, color: context.txtSec),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningList(List<EcoEntry> openings, {double? height}) {
    final listWidget = Container(
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.brd),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search openings by name or code (e.g. Sicilian, C41)...',
                hintStyle: TextStyle(fontSize: 12, color: context.txtMut),
                prefixIcon: Icon(Icons.search, size: 18, color: context.txtMut),
                filled: true,
                fillColor: context.surfLight,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: openings.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, idx) {
                final entry = openings[idx];
                final isSelected = _currentEco?.code == entry.code;
                return Material(
                  type: MaterialType.transparency,
                  child: ListTile(
                    dense: true,
                    selected: isSelected,
                    selectedTileColor: ChessTheme.primary.withAlpha(20),
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.surfLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.code,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: ChessTheme.primaryLight),
                      ),
                    ),
                    title: Text(entry.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.txt)),
                    subtitle: Text(
                      entry.movesSan.join(' '),
                      style: TextStyle(fontSize: 11, color: context.txtMut, fontFamily: 'monospace'),
                    ),
                    trailing: Icon(Icons.chevron_right, size: 16, color: context.txtMut),
                    onTap: () => _selectEco(entry),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    if (height != null) {
      return SizedBox(height: height, child: listWidget);
    }
    return listWidget;
  }
}
