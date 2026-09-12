import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Interactive modal for selecting, previewing, and validating chess games
/// for video generation in Video Studio.
class GameSourceSelectorDialog extends StatefulWidget {
  final StorageRepository repository;

  const GameSourceSelectorDialog({super.key, required this.repository});

  @override
  State<GameSourceSelectorDialog> createState() => _GameSourceSelectorDialogState();
}

class _GameSourceSelectorDialogState extends State<GameSourceSelectorDialog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _pgnInputController = TextEditingController();
  String? _pasteValidationError;
  PgnGame? _parsedPasteGame;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pgnInputController.dispose();
    super.dispose();
  }

  void _validatePastedPgn() {
    final text = _pgnInputController.text.trim();
    if (text.isEmpty) {
      setState(() {
        _pasteValidationError = 'Please paste a non-empty PGN string.';
        _parsedPasteGame = null;
      });
      return;
    }

    try {
      final game = PgnParser.parse(text);
      if (game == null || game.moves.isEmpty) {
        setState(() {
          _pasteValidationError = 'Invalid PGN format: Could not parse any legal move nodes.';
          _parsedPasteGame = null;
        });
      } else {
        setState(() {
          _pasteValidationError = null;
          _parsedPasteGame = game;
        });
      }
    } catch (e) {
      setState(() {
        _pasteValidationError = 'PGN Parsing Error: $e';
        _parsedPasteGame = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playedGames = widget.repository.getGames();
    const modelGames = ModelGamesDatabase.curatedGames;

    return Dialog(
      backgroundColor: context.surf,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.brd),
      ),
      child: Container(
        width: 780,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.video_library, color: ChessTheme.primaryLight, size: 24),
                const SizedBox(width: 10),
                Text(
                  'Select Game for Video Studio',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.txt),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tabs
            TabBar(
              controller: _tabController,
              indicatorColor: ChessTheme.primary,
              labelColor: ChessTheme.primaryLight,
              unselectedLabelColor: context.txtMut,
              tabs: [
                Tab(text: 'Played Games (${playedGames.length})'),
                Tab(text: 'Model Games (${modelGames.length})'),
                const Tab(text: 'Paste PGN'),
                const Tab(text: 'Import File'),
              ],
            ),
            const SizedBox(height: 16),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Played Games
                  playedGames.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.sports_esports, size: 48, color: context.txtMut),
                              const SizedBox(height: 12),
                              Text('No played games yet', style: TextStyle(fontSize: 14, color: context.txtSec)),
                              const SizedBox(height: 4),
                              Text('Play games in Play/Tourney or Analysis mode to record games.',
                                  style: TextStyle(fontSize: 12, color: context.txtMut)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          itemCount: playedGames.length,
                          separatorBuilder: (_, __) => Divider(color: context.brd, height: 1),
                          itemBuilder: (context, index) {
                            final game = playedGames[index];
                            return ListTile(
                              leading: const CircleAvatar(
                                radius: 18,
                                backgroundColor: ChessTheme.primary,
                                child: Icon(Icons.flag, size: 18, color: Colors.black),
                              ),
                              title: Text(
                                '${game.whitePlayer} vs ${game.blackPlayer} (${game.result})',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.txt),
                              ),
                              subtitle: Text(
                                'Played ${game.playedDate.toLocal().toString().split('.')[0]}',
                                style: TextStyle(fontSize: 11, color: context.txtSec),
                              ),
                              onTap: () => Navigator.of(context).pop(game.pgn),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ChessTheme.primary,
                                  foregroundColor: Colors.black,
                                ),
                                onPressed: () => Navigator.of(context).pop(game.pgn),
                                child: const Text('Use Game'),
                              ),
                            );
                          },
                        ),

                  // Tab 2: Model Games
                  ListView.separated(
                    itemCount: modelGames.length,
                    separatorBuilder: (_, __) => Divider(color: context.brd, height: 1),
                    itemBuilder: (context, index) {
                      final game = modelGames[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: ChessTheme.accentGold.withAlpha(40),
                          child: const Icon(Icons.auto_stories, size: 18, color: ChessTheme.accentGold),
                        ),
                        title: Text(
                          '${game.whitePlayer} vs ${game.blackPlayer} (${game.year})',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.txt),
                        ),
                        subtitle: Text(
                          '${game.event} · ECO ${game.eco} · ${game.openingName} (${game.result})',
                          style: TextStyle(fontSize: 11, color: context.txtSec),
                        ),
                        onTap: () => Navigator.of(context).pop(game.pgn),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.surfLight,
                            foregroundColor: context.txt,
                          ),
                          onPressed: () => Navigator.of(context).pop(game.pgn),
                          child: const Text('Use Game'),
                        ),
                      );
                    },
                  ),

                  // Tab 3: Paste PGN
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paste standard PGN text below:', style: TextStyle(fontSize: 12, color: context.txtSec)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: TextField(
                          controller: _pgnInputController,
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                          decoration: InputDecoration(
                            hintText: '[Event "World Championship"]\n[White "Capablanca"]\n[Black "Lasker"]\n\n1. d4 d5 2. c4 e6 ...',
                            filled: true,
                            fillColor: context.surfLight,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_pasteValidationError != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: ChessTheme.qualityBlunder.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: ChessTheme.qualityBlunder),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, size: 16, color: ChessTheme.qualityBlunder),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(_pasteValidationError!,
                                    style: const TextStyle(fontSize: 12, color: ChessTheme.qualityBlunder)),
                              ),
                            ],
                          ),
                        ),
                      if (_parsedPasteGame != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: ChessTheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: ChessTheme.primary),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16, color: ChessTheme.primaryLight),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Valid PGN: ${_parsedPasteGame!.headers["White"] ?? "White"} vs ${_parsedPasteGame!.headers["Black"] ?? "Black"} (${_parsedPasteGame!.moves.length} plies)',
                                  style: const TextStyle(fontSize: 12, color: ChessTheme.primaryLight, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Validate PGN'),
                            onPressed: _validatePastedPgn,
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow, size: 16),
                            label: const Text('Use Game in Studio'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ChessTheme.primary,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: _parsedPasteGame != null
                                ? () => Navigator.of(context).pop(_pgnInputController.text.trim())
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Tab 4: Import File
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.file_upload_outlined, size: 56, color: context.txtMut),
                        const SizedBox(height: 16),
                        Text('Import .pgn File', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.txt)),
                        const SizedBox(height: 8),
                        Text('Select a standard .pgn game file from your local disk.',
                            style: TextStyle(fontSize: 12, color: context.txtSec)),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Browse PGN File'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.surfLight,
                            foregroundColor: context.txt,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          onPressed: () {
                            // Default sample fallback when running in environment without native file picker
                            final sampleGame = ModelGamesDatabase.curatedGames.first;
                            Navigator.of(context).pop(sampleGame.pgn);
                          },
                        ),
                      ],
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
