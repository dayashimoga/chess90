import 'dart:math';
import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Configuration chosen in the Play vs Computer pre-game setup modal.
class PlaySetupConfig {
  final PieceColor playerColor;
  final String strengthPreset;
  final int eloRating;
  final String gameType;
  final String timeControlName;
  final int initialMinutes;
  final int incrementSeconds;

  const PlaySetupConfig({
    required this.playerColor,
    required this.strengthPreset,
    required this.eloRating,
    required this.gameType,
    required this.timeControlName,
    required this.initialMinutes,
    required this.incrementSeconds,
  });

  /// Map Elo to Stockfish UCI skill level (0 to 20).
  int get stockfishSkillLevel => ((eloRating - 600) / 90).clamp(0, 20).round();

  /// Map Elo to search depth.
  int get searchDepth {
    if (eloRating <= 900) return 2;
    if (eloRating <= 1200) return 3;
    if (eloRating <= 1500) return 5;
    if (eloRating <= 1800) return 7;
    if (eloRating <= 2100) return 10;
    return 14;
  }

  bool get isCasualOrTraining => gameType == 'Casual' || gameType == 'Training';
}

/// Modal dialog allowing complete game setup before playing against the computer.
class PlaySetupDialog extends StatefulWidget {
  final PlaySetupConfig? initialConfig;

  const PlaySetupDialog({super.key, this.initialConfig});

  @override
  State<PlaySetupDialog> createState() => _PlaySetupDialogState();
}

class _PlaySetupDialogState extends State<PlaySetupDialog> {
  String _selectedColor = 'white'; // 'white', 'black', 'random'
  String _selectedStrength = 'Medium';
  int _customElo = 1400;
  String _selectedGameType = 'Casual';
  String _selectedTimeControl = '15+10 Rapid';

  static const Map<String, int> strengthElos = {
    'Beginner': 800,
    'Easy': 1100,
    'Medium': 1400,
    'Hard': 1700,
    'Expert': 2000,
    'Master': 2400,
    'Custom': 1400,
  };

  static const List<({String name, int mins, int inc})> timeControls = [
    (name: 'Untimed', mins: 0, inc: 0),
    (name: '1+0 Bullet', mins: 1, inc: 0),
    (name: '3+2 Blitz', mins: 3, inc: 2),
    (name: '5+0 Blitz', mins: 5, inc: 0),
    (name: '10+0 Rapid', mins: 10, inc: 0),
    (name: '15+10 Rapid', mins: 15, inc: 10),
    (name: '30+0 Classical', mins: 30, inc: 0),
    (name: '30+20 Classical', mins: 30, inc: 20),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialConfig != null) {
      final c = widget.initialConfig!;
      _selectedColor = c.playerColor == PieceColor.white ? 'white' : 'black';
      _selectedStrength = c.strengthPreset;
      _customElo = c.eloRating;
      _selectedGameType = c.gameType;
      _selectedTimeControl = c.timeControlName;
    }
  }

  int get _effectiveElo => _selectedStrength == 'Custom' ? _customElo : (strengthElos[_selectedStrength] ?? 1400);

  PieceColor _resolveColor() {
    if (_selectedColor == 'white') return PieceColor.white;
    if (_selectedColor == 'black') return PieceColor.black;
    return Random().nextBool() ? PieceColor.white : PieceColor.black;
  }

  @override
  Widget build(BuildContext context) {
    final tc = timeControls.firstWhere(
      (t) => t.name == _selectedTimeControl,
      orElse: () => timeControls[5],
    );

    return Dialog(
      backgroundColor: context.surf,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.brd),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.smart_toy, color: ChessTheme.primary, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'Play vs Computer Setup',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.txt),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 1. PLAY AS
                Text('PLAY AS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txtMut)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildSideOption('white', 'White', Icons.circle_outlined)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSideOption('random', 'Random', Icons.shuffle)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSideOption('black', 'Black', Icons.circle)),
                  ],
                ),

                const SizedBox(height: 18),

                // 2. OPPONENT STRENGTH
                Text('OPPONENT STRENGTH', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txtMut)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: strengthElos.keys.map((preset) {
                    final isSelected = _selectedStrength == preset;
                    final elo = preset == 'Custom' ? _customElo : strengthElos[preset]!;
                    return ChoiceChip(
                      label: Text('$preset ($elo Elo)'),
                      selected: isSelected,
                      selectedColor: ChessTheme.primary,
                      backgroundColor: context.surfLight,
                      labelStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : context.txt,
                      ),
                      onSelected: (_) => setState(() => _selectedStrength = preset),
                    );
                  }).toList(),
                ),

                if (_selectedStrength == 'Custom') ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Elo: $_customElo', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txt)),
                      Expanded(
                        child: Slider(
                          value: _customElo.toDouble(),
                          min: 400,
                          max: 2800,
                          divisions: 48,
                          activeColor: ChessTheme.primary,
                          onChanged: (val) => setState(() => _customElo = (val / 50).round() * 50),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 18),

                // 3. GAME TYPE
                Text('GAME TYPE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txtMut)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildGameTypeOption('Casual', 'Casual', Icons.coffee)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildGameTypeOption('Training', 'Training', Icons.fitness_center)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildGameTypeOption('Serious Game', 'Serious', Icons.military_tech)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildGameTypeOption('Rated Simulation', 'Rated', Icons.emoji_events)),
                  ],
                ),

                const SizedBox(height: 18),

                // 4. TIME CONTROL
                Text('TIME CONTROL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txtMut)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedTimeControl,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    filled: true,
                    fillColor: context.surfLight,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.brd)),
                  ),
                  dropdownColor: context.surf,
                  items: timeControls.map((t) => DropdownMenuItem(value: t.name, child: Text(t.name))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedTimeControl = val);
                  },
                ),

                const SizedBox(height: 20),

                // 5. SUMMARY CARD
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.surfLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.brd),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedColor == 'white' ? Icons.circle_outlined : (_selectedColor == 'black' ? Icons.circle : Icons.shuffle),
                        color: ChessTheme.primaryLight,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You: ${_selectedColor.toUpperCase()} vs Engine ($_selectedStrength · $_effectiveElo Elo) · $_selectedGameType · $_selectedTimeControl',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.txt),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel', style: TextStyle(color: context.txtSec)),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('START GAME'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChessTheme.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        final config = PlaySetupConfig(
                          playerColor: _resolveColor(),
                          strengthPreset: _selectedStrength,
                          eloRating: _effectiveElo,
                          gameType: _selectedGameType,
                          timeControlName: tc.name,
                          initialMinutes: tc.mins,
                          incrementSeconds: tc.inc,
                        );
                        Navigator.of(context).pop(config);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideOption(String key, String title, IconData icon) {
    final isSelected = _selectedColor == key;
    return InkWell(
      onTap: () => setState(() => _selectedColor = key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? ChessTheme.primary.withAlpha(35) : context.surfLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ChessTheme.primary : context.brd,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: isSelected ? ChessTheme.primary : context.txtSec),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: context.txt)),
          ],
        ),
      ),
    );
  }

  Widget _buildGameTypeOption(String key, String title, IconData icon) {
    final isSelected = _selectedGameType == key;
    return InkWell(
      onTap: () => setState(() => _selectedGameType = key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ChessTheme.primary.withAlpha(35) : context.surfLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ChessTheme.primary : context.brd,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: isSelected ? ChessTheme.primary : context.txtSec),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: context.txt)),
          ],
        ),
      ),
    );
  }
}
