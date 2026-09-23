import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Quick customization dialog accessible from any chessboard in the app.
class BoardCustomizerDialog extends StatefulWidget {
  final String currentBoardTheme;
  final String currentPieceTheme;
  final String currentBoardSize;
  final String currentAnimationSpeed;
  final bool showCoordinates;
  final bool showMoveHighlights;
  final bool showLegalMoveHints;
  final void Function({
    required String boardTheme,
    required String pieceTheme,
    required String boardSize,
    required String animationSpeed,
    required bool showCoordinates,
    required bool showMoveHighlights,
    required bool showLegalMoveHints,
  }) onApplied;

  const BoardCustomizerDialog({
    super.key,
    required this.currentBoardTheme,
    required this.currentPieceTheme,
    required this.currentBoardSize,
    required this.currentAnimationSpeed,
    required this.showCoordinates,
    required this.showMoveHighlights,
    required this.showLegalMoveHints,
    required this.onApplied,
  });

  @override
  State<BoardCustomizerDialog> createState() => _BoardCustomizerDialogState();
}

class _BoardCustomizerDialogState extends State<BoardCustomizerDialog> {
  late String _boardTheme;
  late String _pieceTheme;
  late String _boardSize;
  late String _animationSpeed;
  late bool _showCoordinates;
  late bool _showMoveHighlights;
  late bool _showLegalMoveHints;

  @override
  void initState() {
    super.initState();
    _boardTheme = widget.currentBoardTheme;
    _pieceTheme = widget.currentPieceTheme;
    _boardSize = widget.currentBoardSize;
    _animationSpeed = widget.currentAnimationSpeed;
    _showCoordinates = widget.showCoordinates;
    _showMoveHighlights = widget.showMoveHighlights;
    _showLegalMoveHints = widget.showLegalMoveHints;
  }

  void _apply() {
    widget.onApplied(
      boardTheme: _boardTheme,
      pieceTheme: _pieceTheme,
      boardSize: _boardSize,
      animationSpeed: _animationSpeed,
      showCoordinates: _showCoordinates,
      showMoveHighlights: _showMoveHighlights,
      showLegalMoveHints: _showLegalMoveHints,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.surf,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.brd),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.palette, color: ChessTheme.primary, size: 22),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('Board & Piece Customization', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.txt)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 1. Board Theme
                Text('BOARD THEME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.txtMut)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildThemeChip('tournamentGreen', 'Tournament Green', const Color(0xFF769656)),
                    _buildThemeChip('classicWood', 'Classic Walnut', const Color(0xFFB58863)),
                    _buildThemeChip('slateBlue', 'Slate Blue', const Color(0xFF8CA2AD)),
                    _buildThemeChip('highContrast', 'High Contrast', const Color(0xFF262626)),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. Piece Theme
                Text('PIECE THEME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.txtMut)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildPieceChip('standard', 'Staunton Vector'),
                    _buildPieceChip('highContrast', 'High Contrast B&W'),
                    _buildPieceChip('classicWood', 'Classic Wood/Ivory'),
                    _buildPieceChip('minimalNotation', 'Minimal Notation'),
                  ],
                ),

                const SizedBox(height: 16),

                // 3. Animation Speed
                Text('MOVE ANIMATION SPEED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.txtMut)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildAnimChip('off', 'Instant (0ms)'),
                    _buildAnimChip('fast', 'Fast (150ms)'),
                    _buildAnimChip('normal', 'Normal (280ms)'),
                    _buildAnimChip('learning', 'Learning (500ms)'),
                  ],
                ),

                const Divider(height: 24),

                // 4. Overlays & Coordinates
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Board Coordinates (1-8, a-h)', style: TextStyle(fontSize: 12, color: context.txt)),
                  value: _showCoordinates,
                  activeColor: ChessTheme.primary,
                  onChanged: (val) {
                    setState(() => _showCoordinates = val);
                    _apply();
                  },
                ),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Last Move Highlights', style: TextStyle(fontSize: 12, color: context.txt)),
                  value: _showMoveHighlights,
                  activeColor: ChessTheme.primary,
                  onChanged: (val) {
                    setState(() => _showMoveHighlights = val);
                    _apply();
                  },
                ),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Legal Move Indicators (Dots/Rings)', style: TextStyle(fontSize: 12, color: context.txt)),
                  value: _showLegalMoveHints,
                  activeColor: ChessTheme.primary,
                  onChanged: (val) {
                    setState(() => _showLegalMoveHints = val);
                    _apply();
                  },
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      _apply();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ChessTheme.primary,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('DONE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeChip(String key, String label, Color previewColor) {
    final isSelected = _boardTheme == key;
    return ChoiceChip(
      avatar: CircleAvatar(backgroundColor: previewColor, radius: 6),
      label: Text(label),
      selected: isSelected,
      selectedColor: ChessTheme.primary,
      backgroundColor: context.surfLight,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.black : context.txt,
      ),
      onSelected: (_) {
        setState(() => _boardTheme = key);
        _apply();
      },
    );
  }

  Widget _buildPieceChip(String key, String label) {
    final isSelected = _pieceTheme == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: ChessTheme.primary,
      backgroundColor: context.surfLight,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.black : context.txt,
      ),
      onSelected: (_) {
        setState(() => _pieceTheme = key);
        _apply();
      },
    );
  }

  Widget _buildAnimChip(String key, String label) {
    final isSelected = _animationSpeed == key;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: ChessTheme.primary,
      backgroundColor: context.surfLight,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: isSelected ? Colors.black : context.txt,
      ),
      onSelected: (_) {
        setState(() => _animationSpeed = key);
        _apply();
      },
    );
  }
}
