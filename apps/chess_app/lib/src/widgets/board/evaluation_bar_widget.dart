import 'package:chess_engine/chess_engine.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Live evaluation bar widget displaying engine advantage in centipawns or mate distance.
class EvaluationBarWidget extends StatelessWidget {
  final EngineEvaluation? evaluation;
  final bool isVertical;
  final bool hideWhenEmpty;

  const EvaluationBarWidget({
    super.key,
    this.evaluation,
    this.isVertical = true,
    this.hideWhenEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    if (evaluation == null && hideWhenEmpty) {
      return const SizedBox.shrink();
    }

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
      width: isVertical ? 24 : double.infinity,
      height: isVertical ? double.infinity : 24,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark for black advantage
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.brd, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            // White advantage bar
            Align(
              alignment: isVertical ? Alignment.bottomCenter : Alignment.centerLeft,
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutCubic,
                widthFactor: isVertical ? 1.0 : whiteRatio,
                heightFactor: isVertical ? whiteRatio : 1.0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                  ),
                ),
              ),
            ),

            // Score text pill
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(160),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  scoreStr,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
