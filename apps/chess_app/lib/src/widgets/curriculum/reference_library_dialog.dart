import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Modal dialog providing permanent, searchable grandmaster cheat sheets and reference guides.
class ReferenceLibraryDialog extends StatefulWidget {
  const ReferenceLibraryDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => const ReferenceLibraryDialog(),
    );
  }

  @override
  State<ReferenceLibraryDialog> createState() => _ReferenceLibraryDialogState();
}

class _ReferenceLibraryDialogState extends State<ReferenceLibraryDialog> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

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
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        width: 900,
        height: 700,
        decoration: BoxDecoration(
          color: context.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.brd),
        ),
        child: Column(
          children: [
            // Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: context.surf,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                border: Border(bottom: BorderSide(color: context.brd)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: ChessTheme.primaryLight, size: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mastery Reference Library & Cheat Sheets',
                          style: TextStyle(
                            color: context.txt,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Permanent grandmaster protocols, calculation trees, pawn skeletons, and endgame rules',
                          style: TextStyle(color: context.txtMut, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: context.txtSec,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Search and Category Filter Toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: context.surfLight.withAlpha(50),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    style: TextStyle(color: context.txt, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Search rules, motifs, checklists, or structures...',
                      hintStyle: TextStyle(color: context.txtMut, fontSize: 12),
                      prefixIcon: Icon(Icons.search, size: 18, color: context.txtSec),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: context.surf,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: context.brd),
                      ),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: categories.map((cat) {
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat, style: const TextStyle(fontSize: 11)),
                            selected: isSelected,
                            selectedColor: ChessTheme.primary.withAlpha(40),
                            checkmarkColor: ChessTheme.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? ChessTheme.primaryLight : context.txtSec,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            backgroundColor: context.surf,
                            side: BorderSide(
                              color: isSelected ? ChessTheme.primary : context.brd,
                            ),
                            onSelected: (_) => setState(() => _selectedCategory = cat),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Content List
            Expanded(
              child: filteredEntries.isEmpty
                  ? Center(
                      child: Text(
                        'No cheat sheets match "$_searchQuery".',
                        style: TextStyle(color: context.txtSec, fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = filteredEntries[index];
                        return _buildCheatSheetCard(context, entry);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheatSheetCard(BuildContext context, CheatSheetEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.brd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ChessTheme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: ChessTheme.primary.withAlpha(80)),
                  ),
                  child: Text(
                    entry.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ChessTheme.primaryLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.title,
                    style: TextStyle(
                      color: context.txt,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.summary,
              style: TextStyle(color: context.txtSec, fontSize: 13),
            ),
            if (entry.keyQuote != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(40),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(left: BorderSide(color: ChessTheme.accentGold, width: 3)),
                ),
                child: Text(
                  entry.keyQuote!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: ChessTheme.accentGold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entry.bulletPoints.map((point) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '▸ ',
                        style: TextStyle(color: ChessTheme.primaryLight, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: TextStyle(color: context.txt, fontSize: 13, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
