import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Interactive move list widget displaying SAN moves, variations, and active ply.
class MoveListWidget extends StatelessWidget {
  final List<PgnMoveNode> moves;
  final int currentPlyIndex;
  final Function(int plyIndex)? onMoveSelected;

  const MoveListWidget({
    super.key,
    required this.moves,
    this.currentPlyIndex = 0,
    this.onMoveSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Group moves into turns (White move + optional Black move)
    final turnRows = <Widget>[];
    for (int i = 0; i < moves.length; i += 2) {
      final whiteNode = moves[i];
      final blackNode = (i + 1 < moves.length) ? moves[i + 1] : null;

      final isWhiteActive = currentPlyIndex == i + 1;
      final isBlackActive = currentPlyIndex == i + 2;

      turnRows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
          child: Row(
            children: [
              // Move number
              SizedBox(
                width: 32,
                child: Text(
                  '${whiteNode.moveNumber}.',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ChessTheme.textMuted,
                  ),
                ),
              ),

              // White Move
              Expanded(
                child: InkWell(
                  onTap: () => onMoveSelected?.call(i + 1),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isWhiteActive ? ChessTheme.surfaceLight : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: isWhiteActive ? Border.all(color: ChessTheme.primary, width: 1) : null,
                    ),
                    child: Text(
                      whiteNode.san,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isWhiteActive ? FontWeight.bold : FontWeight.normal,
                        color: isWhiteActive ? ChessTheme.primaryLight : ChessTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 4),

              // Black Move
              Expanded(
                child: blackNode == null
                    ? const SizedBox()
                    : InkWell(
                        onTap: () => onMoveSelected?.call(i + 2),
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          decoration: BoxDecoration(
                            color: isBlackActive ? ChessTheme.surfaceLight : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: isBlackActive ? Border.all(color: ChessTheme.primary, width: 1) : null,
                          ),
                          child: Text(
                            blackNode.san,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isBlackActive ? FontWeight.bold : FontWeight.normal,
                              color: isBlackActive ? ChessTheme.primaryLight : ChessTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: ChessTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ChessTheme.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: ChessTheme.border)),
            ),
            child: const Row(
              children: [
                Icon(Icons.list_alt, size: 16, color: ChessTheme.textSecondary),
                SizedBox(width: 8),
                Text(
                  'Move Notation Tree',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ChessTheme.textSecondary),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(6),
              children: turnRows.isEmpty
                  ? [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No moves yet', style: TextStyle(color: ChessTheme.textMuted)),
                        ),
                      )
                    ]
                  : turnRows,
            ),
          ),
        ],
      ),
    );
  }
}
