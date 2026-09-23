import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/chess_theme.dart';
import '../board/chess_board_widget.dart';

/// Universal Chess Companion & GM Thinking Reference Dialog.
/// Accessible from anywhere in the application via AppBar action.
/// Covers all 16 canonical reference sheets including the Before-Move Thinking Algorithm.
class ChessCompanionDialog extends StatefulWidget {
  final String? initialCategory;
  final String? initialSheetId;

  const ChessCompanionDialog({
    super.key,
    this.initialCategory,
    this.initialSheetId,
  });

  static Future<void> show(BuildContext context, {String? category, String? sheetId}) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => ChessCompanionDialog(
        initialCategory: category,
        initialSheetId: sheetId,
      ),
    );
  }

  @override
  State<ChessCompanionDialog> createState() => _ChessCompanionDialogState();
}

class _ChessCompanionDialogState extends State<ChessCompanionDialog> {
  late String _selectedCategory;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  CheatSheetEntry? _selectedEntry;

  // The 11-step Before-Move Thinking Algorithm
  static const List<String> _thinkingProcessSteps = [
    '1. What changed?',
    '2. Opponent threat',
    '3. Checks',
    '4. Captures',
    '5. Threats (CCT)',
    '6. Tactical scan',
    '7. Evaluate',
    '8. Candidates',
    '9. Calculate reply',
    '10. Compare',
    '11. Blunder check',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? 'All';
    const entries = CheatSheetsCatalog.entries;
    if (widget.initialSheetId != null) {
      _selectedEntry = entries.where((e) => e.id == widget.initialSheetId).firstOrNull;
    }
    _selectedEntry ??= entries.firstOrNull;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const allEntries = CheatSheetsCatalog.entries;
    final categories = ['All', ...allEntries.map((e) => e.category).toSet()];

    final filteredEntries = allEntries.where((e) {
      if (_selectedCategory != 'All' && e.category != _selectedCategory) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchTitle = e.title.toLowerCase().contains(query);
        final matchSummary = e.summary.toLowerCase().contains(query);
        final matchBullets = e.bulletPoints.any((b) => b.toLowerCase().contains(query));
        return matchTitle || matchSummary || matchBullets;
      }
      return true;
    }).toList();

    return Dialog(
      backgroundColor: context.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        width: 1060,
        height: 760,
        decoration: BoxDecoration(
          color: context.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.brd),
        ),
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: context.surf,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                border: Border(bottom: BorderSide(color: context.brd)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_stories, color: ChessTheme.primaryLight, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    'CHESS COMPANION & THINKING PROCESS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      color: context.txt,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: ChessTheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: ChessTheme.primaryLight.withAlpha(80)),
                    ),
                    child: const Text(
                      '16 CHEAT SHEETS',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Thinking Process Horizontal Ribbon
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black.withAlpha(context.isDark ? 80 : 15),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(Icons.psychology, size: 16, color: ChessTheme.accentGold),
                    const SizedBox(width: 6),
                    const Text(
                      'BEFORE-MOVE ALGORITHM:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: ChessTheme.accentGold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    for (int i = 0; i < _thinkingProcessSteps.length; i++) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: context.surf,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: context.brd),
                        ),
                        child: Text(
                          _thinkingProcessSteps[i],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: context.txt,
                          ),
                        ),
                      ),
                      if (i < _thinkingProcessSteps.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(Icons.arrow_forward_ios, size: 10, color: context.txtMut),
                        ),
                    ],
                  ],
                ),
              ),
            ),

            // Filter & Search Toolbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search checklists, motifs, pawn structures, rules...',
                        hintStyle: TextStyle(fontSize: 12, color: context.txtMut),
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (val) {
                        setState(() => _searchQuery = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(cat, style: const TextStyle(fontSize: 11)),
                            selected: isSelected,
                            onSelected: (sel) {
                              if (sel) setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content: Left List + Right Detail View
            Expanded(
              child: Row(
                children: [
                  // Left Sheets List
                  SizedBox(
                    width: 320,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      itemCount: filteredEntries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 6),
                      itemBuilder: (context, idx) {
                        final entry = filteredEntries[idx];
                        final isSelected = _selectedEntry?.id == entry.id;

                        return InkWell(
                          onTap: () {
                            setState(() => _selectedEntry = entry);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected ? ChessTheme.primary.withAlpha(30) : context.surf,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? ChessTheme.primaryLight : context.brd,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(entry.category),
                                  size: 18,
                                  color: isSelected ? ChessTheme.primaryLight : context.txtMut,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          color: isSelected ? ChessTheme.primaryLight : context.txt,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        entry.category,
                                        style: TextStyle(fontSize: 10, color: context.txtMut),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  VerticalDivider(width: 1, thickness: 1, color: context.brd),

                  // Right Sheet Detail
                  Expanded(
                    child: _selectedEntry == null
                        ? Center(child: Text('Select a cheat sheet to view details', style: TextStyle(color: context.txtMut)))
                        : _buildSheetDetail(_selectedEntry!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetDetail(CheatSheetEntry entry) {
    final hasFen = entry.diagramFen != null && entry.diagramFen!.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: context.txt,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.summary,
                      style: TextStyle(fontSize: 13, color: context.txtMut),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copy checklist text to clipboard',
                onPressed: () {
                  final text = '${entry.title}\n\n${entry.bulletPoints.map((b) => "• $b").join("\n")}';
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied reference to clipboard!'), duration: Duration(seconds: 1)),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bullet Points / Checklist Items
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KEY PRINCIPLES & ACTION STEPS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        color: ChessTheme.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (int i = 0; i < entry.bulletPoints.length; i++) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.surf,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: context.brd),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ChessTheme.primary.withAlpha(25),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.bulletPoints[i],
                                style: TextStyle(fontSize: 13, height: 1.4, color: context.txt),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Optional Diagram Board
              if (hasFen) ...[
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'MODEL BOARD POSITION',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: context.txtMut,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: context.brd),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: ChessBoardWidget(
                            board: Board.fromFen(entry.diagramFen!),
                            isInteractive: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'FEN: ${entry.diagramFen}',
                        style: TextStyle(fontSize: 9, fontFamily: 'monospace', color: context.txtMut),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'calculation':
        return Icons.calculate_outlined;
      case 'tactics':
        return Icons.bolt;
      case 'positional strategy':
      case 'strategy':
        return Icons.map_outlined;
      case 'endgames':
        return Icons.flag_outlined;
      case 'openings':
        return Icons.door_front_door_outlined;
      case 'attack':
        return Icons.local_fire_department_outlined;
      case 'defense':
        return Icons.security;
      case 'pawn structures':
        return Icons.grid_view;
      case 'practical play':
      case 'time':
        return Icons.timer_outlined;
      default:
        return Icons.menu_book;
    }
  }
}
