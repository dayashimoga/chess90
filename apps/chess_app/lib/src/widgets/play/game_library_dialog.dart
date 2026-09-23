import 'package:chess_content/chess_content.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/chess_theme.dart';

/// Searchable local offline game library providing 1-click actions:
/// Review, Analyze, Train Mistakes, Create Video, and Export PGN.
class GameLibraryDialog extends StatefulWidget {
  final StorageRepository repository;
  final Function(String screenKey, {dynamic args}) onNavigate;

  const GameLibraryDialog({
    super.key,
    required this.repository,
    required this.onNavigate,
  });

  static Future<void> show(
    BuildContext context, {
    required StorageRepository repository,
    required Function(String screenKey, {dynamic args}) onNavigate,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => GameLibraryDialog(
        repository: repository,
        onNavigate: onNavigate,
      ),
    );
  }

  @override
  State<GameLibraryDialog> createState() => _GameLibraryDialogState();
}

class _GameLibraryDialogState extends State<GameLibraryDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _copyPgn(BuildContext context, String pgn) {
    Clipboard.setData(ClipboardData(text: pgn));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PGN copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final playedGames = widget.repository.getGameHistory();
    const modelGames = ModelGamesDatabase.curatedGames;

    return Dialog(
      backgroundColor: context.surf,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.brd),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 680),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.video_library_outlined, color: ChessTheme.primaryLight, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Offline Game Library',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: context.txt,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Search bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by opponent, opening, ECO, or result...',
                  hintStyle: TextStyle(fontSize: 12, color: context.txtMut),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  isDense: true,
                  filled: true,
                  fillColor: context.surfLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: context.brd),
                  ),
                ),
                onChanged: (val) => setState(() => _filterQuery = val.toLowerCase()),
              ),
              const SizedBox(height: 12),

              // Tabs
              TabBar(
                controller: _tabController,
                indicatorColor: ChessTheme.primaryLight,
                labelColor: ChessTheme.primaryLight,
                unselectedLabelColor: context.txtSec,
                tabs: [
                  Tab(text: 'My Played Games (${playedGames.length})'),
                  Tab(text: 'Model Master Games (${modelGames.length})'),
                ],
              ),
              const SizedBox(height: 12),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPlayedGamesList(playedGames),
                    _buildModelGamesList(modelGames),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayedGamesList(List<GameSession> games) {
    final filtered = games.where((g) {
      if (_filterQuery.isEmpty) return true;
      final matchOpp = g.opponentName.toLowerCase().contains(_filterQuery);
      final matchEco = g.openingEco.toLowerCase().contains(_filterQuery);
      final matchOpening = g.openingName.toLowerCase().contains(_filterQuery);
      final matchResult = g.result.toLowerCase().contains(_filterQuery);
      return matchOpp || matchEco || matchOpening || matchResult;
    }).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          games.isEmpty
              ? 'No games played yet. Play a game vs Stockfish to build your library!'
              : 'No games match your search query.',
          style: TextStyle(color: context.txtSec, fontSize: 13),
        ),
      );
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final g = filtered[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: g.result == '1-0'
                  ? const Color(0xFF10B981).withAlpha(30)
                  : (g.result == '0-1' ? Colors.red.withAlpha(30) : Colors.amber.withAlpha(30)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              g.result,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: g.result == '1-0'
                    ? const Color(0xFF10B981)
                    : (g.result == '0-1' ? Colors.red : Colors.amber),
              ),
            ),
          ),
          title: Text(
            'vs ${g.opponentName} • ${g.timeControl}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          subtitle: Text(
            '${g.openingEco} ${g.openingName} • ${g.moveSanList.length} plies • ${g.startedAt.toIso8601String().substring(0, 10)}',
            style: TextStyle(fontSize: 11, color: context.txtSec),
          ),
          trailing: Wrap(
            spacing: 6,
            children: [
              // Analyze
              ElevatedButton.icon(
                icon: const Icon(Icons.analytics_outlined, size: 13),
                label: const Text('Analyze'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChessTheme.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onNavigate('analysis', args: {'gameSession': g, 'pgn': g.pgn});
                },
              ),
              // Create Video
              OutlinedButton.icon(
                icon: const Icon(Icons.movie_outlined, size: 13),
                label: const Text('Video'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ChessTheme.primaryLight,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  textStyle: const TextStyle(fontSize: 11),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onNavigate('video', args: {'gameSession': g, 'pgn': g.pgn});
                },
              ),
              // Copy PGN
              IconButton(
                icon: const Icon(Icons.copy, size: 15),
                tooltip: 'Copy PGN',
                onPressed: () => _copyPgn(context, g.pgn),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModelGamesList(List<ModelGame> games) {
    final filtered = games.where((g) {
      if (_filterQuery.isEmpty) return true;
      final matchWhite = g.whitePlayer.toLowerCase().contains(_filterQuery);
      final matchBlack = g.blackPlayer.toLowerCase().contains(_filterQuery);
      final matchEco = g.eco.toLowerCase().contains(_filterQuery);
      final matchEvent = g.event.toLowerCase().contains(_filterQuery);
      return matchWhite || matchBlack || matchEco || matchEvent;
    }).toList();

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final g = filtered[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          leading: const Icon(Icons.auto_stories, color: ChessTheme.accentGold, size: 22),
          title: Text(
            '${g.whitePlayer} vs ${g.blackPlayer} (${g.year})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          subtitle: Text(
            '${g.event} • ECO ${g.eco} ${g.openingName}',
            style: TextStyle(fontSize: 11, color: context.txtSec),
          ),
          trailing: Wrap(
            spacing: 6,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.analytics_outlined, size: 13),
                label: const Text('Analyze'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChessTheme.primary,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onNavigate('analysis', args: {'pgn': g.pgn});
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.movie_outlined, size: 13),
                label: const Text('Video'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ChessTheme.primaryLight,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  textStyle: const TextStyle(fontSize: 11),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onNavigate('video', args: {'pgn': g.pgn});
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 15),
                tooltip: 'Copy PGN',
                onPressed: () => _copyPgn(context, g.pgn),
              ),
            ],
          ),
        );
      },
    );
  }
}
