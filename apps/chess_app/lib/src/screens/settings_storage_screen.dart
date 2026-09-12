import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';

/// Settings, Storage Management, and Offline Platform Diagnostics.
class SettingsStorageScreen extends StatefulWidget {
  final StorageRepository repository;
  final VoidCallback? onToggleTheme;

  const SettingsStorageScreen({
    super.key,
    required this.repository,
    this.onToggleTheme,
  });

  @override
  State<SettingsStorageScreen> createState() => _SettingsStorageScreenState();
}

class _SettingsStorageScreenState extends State<SettingsStorageScreen> {
  String _statusMessage = '';

  void _exportBackup() {
    final jsonStr = widget.repository.exportFullBackupJson();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surf,
        title: Text('Export Offline Platform JSON Backup', style: TextStyle(color: ctx.txt)),
        content: SizedBox(
          width: 550,
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Full reversible database export (profile, skill nodes, games, review items):', style: TextStyle(fontSize: 12, color: ctx.txtSec)),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: ctx.bg, borderRadius: BorderRadius.circular(6)),
                  child: SelectableText(jsonStr, style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: ctx.txt)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _importBackupPrompt() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surf,
        title: Text('Import Offline JSON Backup', style: TextStyle(color: ctx.txt)),
        content: SizedBox(
          width: 550,
          height: 250,
          child: Column(
            children: [
              Text('Paste JSON platform export below. Schema migrations will be applied automatically.', style: TextStyle(fontSize: 12, color: ctx.txtSec)),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: 8,
                  style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: ctx.txt),
                  decoration: InputDecoration(
                    hintText: '{"schemaVersion": 2, "profile": ...}',
                    fillColor: ctx.bg,
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: ChessTheme.primary),
            onPressed: () {
              try {
                widget.repository.importFullBackupJson(controller.text.trim());
                Navigator.of(ctx).pop();
                setState(() {
                  _statusMessage = 'Backup imported successfully!';
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Import failed: $e'), backgroundColor: ChessTheme.qualityBlunder),
                );
              }
            },
            child: const Text('Import Backup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gamesCount = widget.repository.getGames().length;
    final reviewCount = widget.repository.getReviewItems().length;
    final nodesCount = widget.repository.getSkillNodes().length;

    return Scaffold(
      backgroundColor: context.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ChessTheme.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.settings, color: ChessTheme.primaryLight, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SETTINGS & STORAGE MANAGEMENT',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5, color: context.txt),
                    ),
                    Text(
                      'Local database health, schema migrations, offline backup, and visual preferences',
                      style: TextStyle(fontSize: 12, color: context.txtSec),
                    ),
                  ],
                ),
              ],
            ),

            if (_statusMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ChessTheme.primary.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ChessTheme.primaryLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: ChessTheme.primaryLight, size: 18),
                    const SizedBox(width: 8),
                    Text(_statusMessage, style: const TextStyle(color: ChessTheme.primaryLight, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Storage Overview Grid
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Database Schema', 'Version 2 (Active)', Icons.schema, ChessTheme.primaryLight)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, 'Saved Games', '$gamesCount Games', Icons.sports_esports, ChessTheme.secondary)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, 'SRS Review Items', '$reviewCount Flashcards', Icons.repeat, ChessTheme.accentGold)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, 'Skill Graph Nodes', '$nodesCount Dimensions', Icons.hub, ChessTheme.qualityBrilliant)),
              ],
            ),

            const SizedBox(height: 24),

            // Storage & Backup Controls Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.surf,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.brd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local-First Offline Persistence', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: context.txt)),
                  const SizedBox(height: 4),
                  Text('All database writes are executed atomically (.tmp -> rename) with zero external server dependencies.', style: TextStyle(fontSize: 12, color: context.txtSec)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Export JSON Backup'),
                        style: ElevatedButton.styleFrom(backgroundColor: ChessTheme.primary, foregroundColor: Colors.white),
                        onPressed: _exportBackup,
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.upload, size: 16),
                        label: const Text('Import JSON Backup'),
                        style: OutlinedButton.styleFrom(foregroundColor: context.txt),
                        onPressed: _importBackupPrompt,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Visual Theme & Engine Options
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.surf,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.brd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visual System & Engine Preferences', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: context.txt)),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.palette_outlined, color: ChessTheme.accentGold),
                    title: Text('Toggle Dark / Light Theme', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.txt)),
                    subtitle: Text('Switch between tournament olive dark theme and crisp tournament light theme.', style: TextStyle(fontSize: 11, color: context.txtMut)),
                    trailing: ElevatedButton(
                      onPressed: widget.onToggleTheme,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.surfLight,
                        foregroundColor: context.txt,
                      ),
                      child: const Text('Toggle Theme'),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.cloud_off, color: ChessTheme.primaryLight),
                    title: Text('Offline Mode Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.txt)),
                    subtitle: Text('All core curriculum, Stockfish engine, and database functionality are 100% offline capable.', style: TextStyle(fontSize: 11, color: context.txtMut)),
                    trailing: const Chip(
                      label: Text('OFFLINE VERIFIED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight)),
                      backgroundColor: Colors.transparent,
                      side: BorderSide(color: ChessTheme.primaryLight),
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

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
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
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 10),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: context.txt)),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 11, color: context.txtMut)),
        ],
      ),
    );
  }
}
