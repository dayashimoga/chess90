import 'dart:math';
import 'package:flutter/material.dart';

/// Board sizing modes for different application contexts.
enum BoardSizeMode {
  /// Compact mode for mobile split-view, bottom sheets, or narrow sidebars.
  compact,

  /// Standard mode for primary workflow screens (Play, Curriculum, Labs,
  /// Analysis, Openings, Endgame, Model Games).
  standard,

  /// Full-focus mode for serious game play and tournament sparring.
  focus,

  /// Editor preview mode specifically for Video Studio canvas.
  editorPreview,
}

/// User preference scaling for chessboard display.
enum BoardScalePreference {
  auto(0.0),
  small(0.85),
  medium(1.00),
  large(1.20),
  max(1.45);

  final double multiplier;
  const BoardScalePreference(this.multiplier);
}

/// Centralized responsive board sizing policy ensuring visually consistent,
/// non-arbitrary, and non-overflowing 1:1 chessboard rendering across all screens.
class BoardSizePolicy {
  /// Computes the exact 1:1 square board dimension based on available BoxConstraints,
  /// screen mode, viewport, and user scaling preference.
  static double calculateBoardSize({
    required BoxConstraints constraints,
    BoardSizeMode mode = BoardSizeMode.standard,
    BoardScalePreference scale = BoardScalePreference.medium,
    double? customScaleMultiplier,
    double horizontalPadding = 32.0,
    double verticalPadding = 32.0,
    bool hasEvaluationBar = false,
    double evalBarWidth = 36.0,
  }) {
    final availableWidth = max(0.0, constraints.maxWidth - horizontalPadding - (hasEvaluationBar ? evalBarWidth : 0.0));
    final availableHeight = max(0.0, constraints.maxHeight - verticalPadding);
    final maxSquare = min(availableWidth, availableHeight);

    if (maxSquare <= 0) return 280.0;

    final effectiveMultiplier = customScaleMultiplier ?? scale.multiplier;

    double targetSize;
    switch (mode) {
      case BoardSizeMode.compact:
        // Clamped between 260 and 380
        targetSize = maxSquare.clamp(260.0, 380.0);
        break;

      case BoardSizeMode.standard:
        // Standard desktop/tablet workflow sizing:
        if (scale == BoardScalePreference.auto) {
          targetSize = maxSquare * 0.96;
        } else if (effectiveMultiplier > 1.0) {
          // Large or Max desktop scaling: dynamically expand up to 860px
          targetSize = min(maxSquare * 0.96, 500.0 * effectiveMultiplier);
        } else if (maxSquare >= 560.0) {
          targetSize = 500.0 * effectiveMultiplier;
        } else {
          targetSize = (maxSquare * 0.92) * effectiveMultiplier;
        }
        final maxClamp = (scale == BoardScalePreference.auto || effectiveMultiplier > 1.0) ? 860.0 : 560.0;
        targetSize = targetSize.clamp(280.0, maxClamp);
        break;

      case BoardSizeMode.focus:
        // Maximizes viewport for serious tournament focus, up to 880px
        if (scale == BoardScalePreference.auto) {
          targetSize = maxSquare * 0.98;
        } else {
          targetSize = (maxSquare * 0.96) * (effectiveMultiplier > 0 ? effectiveMultiplier : 1.0);
        }
        targetSize = targetSize.clamp(320.0, 880.0);
        break;

      case BoardSizeMode.editorPreview:
        // Video Studio canvas preview: maximizes available bounding box
        targetSize = maxSquare * 0.94;
        targetSize = targetSize.clamp(240.0, 720.0);
        break;
    }

    // Strict constraint: boardSize can never exceed available width or height
    return min(targetSize, maxSquare);
  }
}

