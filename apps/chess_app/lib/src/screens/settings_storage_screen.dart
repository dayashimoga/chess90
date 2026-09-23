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

            const SizedBox(height: 24),

            // Visual Aesthetics & Theme Preferences Card
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
                  Text('Visual Aesthetics & Presentation System', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: context.txt)),
                  const SizedBox(height: 4),
                  Text('Unified board, piece styles, sizing policies, and animation speeds applied across all modules and Video Studio.', style: TextStyle(fontSize: 12, color: context.txtSec)),
                  const SizedBox(height: 16),

                  // Dark / Light Mode Toggle
                  Row(
                    children: [
                      Icon(context.isDark ? Icons.dark_mode : Icons.light_mode, color: ChessTheme.accentGold, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.isDark ? 'Dark Theme (Active)' : 'Light Theme (Active)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: context.txt)),
                            Text(context.isDark ? 'Sleek luxury dark palette with emerald accents' : 'Crisp high-contrast slate light palette with amber accents', style: TextStyle(fontSize: 11, color: context.txtMut)),
                          ],
                        ),
                      ),
                      Switch(
                        value: context.isDark,
                        activeColor: ChessTheme.primaryLight,
                        onChanged: (val) {
                          final profile = widget.repository.getProfile();
                          profile.isDarkMode = val;
                          widget.repository.saveProfile(profile);
                          widget.onToggleTheme?.call();
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 28),

                  // Board Theme & Piece Theme Selectors
                  Builder(
                    builder: (context) {
                      final profile = widget.repository.getProfile();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Board Theme
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Board Theme', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txtSec)),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<String>(
                                      value: profile.boardThemeName,
                                      isExpanded: true,
                                      dropdownColor: context.surfLight,
                                      decoration: InputDecoration(
                                        fillColor: context.bg,
                                        filled: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'tournamentGreen', child: Text('Tournament Green')),
                                        DropdownMenuItem(value: 'classicWood', child: Text('Classic Wood')),
                                        DropdownMenuItem(value: 'slateBlue', child: Text('Slate Blue')),
                                        DropdownMenuItem(value: 'highContrast', child: Text('High Contrast')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          profile.boardThemeName = val;
                                          widget.repository.saveProfile(profile);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Piece Theme
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Piece Theme', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txtSec)),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<String>(
                                      value: profile.pieceThemeName,
                                      isExpanded: true,
                                      dropdownColor: context.surfLight,
                                      decoration: InputDecoration(
                                        fillColor: context.bg,
                                        filled: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'standard', child: Text('Standard Staunton Vector')),
                                        DropdownMenuItem(value: 'highContrast', child: Text('High Contrast Master')),
                                        DropdownMenuItem(value: 'classicWood', child: Text('Classic Wood Engraved')),
                                        DropdownMenuItem(value: 'minimalNotation', child: Text('Minimal Notation')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          profile.pieceThemeName = val;
                                          widget.repository.saveProfile(profile);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              // Board Sizing Policy
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Board Sizing Policy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txtSec)),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<String>(
                                      value: profile.boardSizeMode,
                                      isExpanded: true,
                                      dropdownColor: context.surfLight,
                                      decoration: InputDecoration(
                                        fillColor: context.bg,
                                        filled: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'auto', child: Text('Auto Responsive (Optimal Viewport)')),
                                        DropdownMenuItem(value: 'small', child: Text('Small (Compact 320px)')),
                                        DropdownMenuItem(value: 'medium', child: Text('Medium (Balanced 420px)')),
                                        DropdownMenuItem(value: 'large', child: Text('Large (Spacious 540px)')),
                                        DropdownMenuItem(value: 'extraLarge', child: Text('Extra Large (Max Focus 640px)')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          profile.boardSizeMode = val;
                                          widget.repository.saveProfile(profile);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Animation Speed
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Move Animation Speed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txtSec)),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<String>(
                                      value: profile.animationSpeed,
                                      isExpanded: true,
                                      dropdownColor: context.surfLight,
                                      decoration: InputDecoration(
                                        fillColor: context.bg,
                                        filled: true,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'off', child: Text('Off (Instant Teleport)')),
                                        DropdownMenuItem(value: 'fast', child: Text('Fast (150ms Precision)')),
                                        DropdownMenuItem(value: 'normal', child: Text('Normal (280ms Standard)')),
                                        DropdownMenuItem(value: 'learning', child: Text('Learning (450ms + Arrow Trajectory)')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) {
                                          profile.animationSpeed = val;
                                          widget.repository.saveProfile(profile);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Display Switches
                          Wrap(
                            spacing: 24,
                            runSpacing: 12,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: profile.showCoordinates,
                                    activeColor: ChessTheme.primaryLight,
                                    onChanged: (val) {
                                      profile.showCoordinates = val;
                                      widget.repository.saveProfile(profile);
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  Text('Algebraic Coordinates', style: TextStyle(fontSize: 12, color: context.txt)),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: profile.showMoveHighlights,
                                    activeColor: ChessTheme.primaryLight,
                                    onChanged: (val) {
                                      profile.showMoveHighlights = val;
                                      widget.repository.saveProfile(profile);
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  Text('Last Move Highlights', style: TextStyle(fontSize: 12, color: context.txt)),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: profile.showLegalMoveHints,
                                    activeColor: ChessTheme.primaryLight,
                                    onChanged: (val) {
                                      profile.showLegalMoveHints = val;
                                      widget.repository.saveProfile(profile);
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  Text('Legal Move Dots / Target Rings', style: TextStyle(fontSize: 12, color: context.txt)),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: profile.showMovementArrows,
                                    activeColor: ChessTheme.primaryLight,
                                    onChanged: (val) {
                                      profile.showMovementArrows = val;
                                      widget.repository.saveProfile(profile);
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(width: 6),
                                  Text('Tactical & Threat Arrows', style: TextStyle(fontSize: 12, color: context.txt)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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
