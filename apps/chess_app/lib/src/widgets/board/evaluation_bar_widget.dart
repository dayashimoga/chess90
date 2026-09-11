import 'package:chess_engine/chess_engine.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Live evaluation bar widget displaying engine advantage in centipawns or mate distance.
class EvaluationBarWidget extends StatelessWidget {
  final EngineEvaluation? evaluation;
  final bool isVertical;

  const EvaluationBarWidget({
    super.key,
    this.evaluation,
    this.isVertical = true,
  });

  @override
  Widget build(BuildContext context) {
    // Win probability from White's perspective (0.0 to 1.0)
    final double whiteRatio;
    if (evaluation == null) {
      whiteRatio = 0.5;
    } else if (evaluation!.mateInMoves != null) {
      whiteRatio = evaluation!.mateInMoves! > 0 ? 1.0 : 0.0;
    } else {
      final cp = evaluation!.scoreFromWhitePerspective;
      // Clamp between -1000 and +1000 cp
      final clamped = cp.clamp(-1000, 1000);
      whiteRatio = 0.5 + (clamped / 2000.0);
    }

    final scoreStr = evaluation?.formattedScore ?? '0.00';

    return Container(
      width: isVertical ? 28 : double.infinity,
      height: isVertical ? double.infinity : 28,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark for black advantage
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ChessTheme.border, width: 1),
      ),
      child: Stack(
        children: [
          // White advantage bar
          Align(
            alignment: isVertical ? Alignment.bottomCenter : Alignment.centerLeft,
            child: AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              widthFactor: isVertical ? 1.0 : whiteRatio,
              heightFactor: isVertical ? whiteRatio : 1.0,
              child: Container(
                color: Colors.white,
              ),
            ),
          ),

          // Score text overlay
          Center(
            child: Text(
              scoreStr,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: whiteRatio > 0.5 ? Colors.black87 : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
