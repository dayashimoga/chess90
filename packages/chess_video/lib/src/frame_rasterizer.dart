import 'dart:math';
import 'package:chess_core/chess_core.dart';
import 'package:image/image.dart' as img;
import 'models/video_frame.dart';
import 'models/video_profile.dart';

/// Rasterizes discrete VideoFrames into high-resolution bitmap images using package:image.
class FrameRasterizer {
  static final img.ColorRgb8 bgDark = img.ColorRgb8(18, 18, 20);
  static final img.ColorRgb8 boardBorder = img.ColorRgb8(38, 38, 44);
  static final img.ColorRgb8 lightSquare = img.ColorRgb8(238, 238, 210);
  static final img.ColorRgb8 darkSquare = img.ColorRgb8(118, 150, 86);
  static final img.ColorRgb8 highlightSquare = img.ColorRgb8(246, 246, 105);
  static final img.ColorRgb8 bannerBg = img.ColorRgb8(28, 28, 34);
  static final img.ColorRgb8 textWhite = img.ColorRgb8(255, 255, 255);
  static final img.ColorRgb8 textMuted = img.ColorRgb8(160, 160, 170);

  // Pieces colors
  static final img.ColorRgb8 whitePieceBg = img.ColorRgb8(250, 250, 250);
  static final img.ColorRgb8 whitePieceBorder = img.ColorRgb8(40, 40, 50);
  static final img.ColorRgb8 whitePieceText = img.ColorRgb8(20, 20, 30);

  static final img.ColorRgb8 blackPieceBg = img.ColorRgb8(30, 30, 40);
  static final img.ColorRgb8 blackPieceBorder = img.ColorRgb8(200, 200, 215);
  static final img.ColorRgb8 blackPieceText = img.ColorRgb8(240, 240, 250);

  /// Rasterizes a single VideoFrame into an Image.
  static img.Image rasterize(VideoFrame frame, VideoProfile profile) {
    final width = profile.width;
    final height = profile.height;
    final canvas = img.Image(width: width, height: height);

    // 1. Background
    img.fill(canvas, color: bgDark);

    // 2. Compute board layout geometry
    final margin = min(width, height) * 0.08;
    final availableSize = min(width, height) - (margin * 2);
    final boardSize = (availableSize ~/ 8) * 8; // ensure divisible by 8
    final sqSize = boardSize ~/ 8;

    final boardX = (width - boardSize) ~/ 2;
    final boardY = (height - boardSize) ~/ 2 + (height > width ? -sqSize ~/ 2 : 0);

    // Outer border
    img.drawRect(
      canvas,
      x1: boardX - 3,
      y1: boardY - 3,
      x2: boardX + boardSize + 3,
      y2: boardY + boardSize + 3,
      color: boardBorder,
    );

    // 3. Squares & Highlights
    final board = Board.fromFen(frame.fen);
    final inMotionFrom = frame.movingFrom;
    final inMotionTo = frame.movingTo;

    for (int r = 0; r < 8; r++) {
      for (int f = 0; f < 8; f++) {
        final squareIndex = (7 - r) * 8 + f; // rank 8 at top
        final square = Square(squareIndex);
        final isLight = (r + f) % 2 == 0;

        final sx1 = boardX + (f * sqSize);
        final sy1 = boardY + (r * sqSize);
        final sx2 = sx1 + sqSize;
        final sy2 = sy1 + sqSize;

        // Base square color
        img.ColorRgb8 sqColor = isLight ? lightSquare : darkSquare;

        // Check if square is highlighted
        if (frame.highlightedSquares.contains(square) ||
            square == inMotionFrom ||
            square == inMotionTo) {
          sqColor = highlightSquare;
        }

        img.fillRect(canvas, x1: sx1, y1: sy1, x2: sx2, y2: sy2, color: sqColor);

        // 4. Static pieces
        final piece = board.pieceAt(square);
        if (piece != null) {
          // If this piece is currently in motion, skip drawing at movingFrom square
          if (frame.isPieceInMotion && square == inMotionFrom) {
            continue;
          }

          final centerX = sx1 + (sqSize ~/ 2);
          final centerY = sy1 + (sqSize ~/ 2);
          _drawPieceBadge(canvas, piece, centerX, centerY, sqSize ~/ 2 - 4);
        }
      }
    }

    // 5. Piece in motion (interpolated trajectory)
    if (frame.isPieceInMotion && frame.movingPiece != null && inMotionFrom != null && inMotionTo != null) {
      final fromCenter = _squareCenter(inMotionFrom, boardX, boardY, sqSize);
      final toCenter = _squareCenter(inMotionTo, boardX, boardY, sqSize);

      final frac = frame.interpolationFraction.clamp(0.0, 1.0);
      final currentX = (fromCenter.x + (toCenter.x - fromCenter.x) * frac).round();
      final currentY = (fromCenter.y + (toCenter.y - fromCenter.y) * frac).round();

      // Shadow
      img.fillCircle(canvas, x: currentX + 3, y: currentY + 4, radius: sqSize ~/ 2 - 4, color: img.ColorRgb8(10, 10, 10));
      // Moving piece badge
      _drawPieceBadge(canvas, frame.movingPiece!, currentX, currentY, sqSize ~/ 2 - 4);
    }

    // 6. Arrows
    if (profile.showArrows) {
      for (final arrow in frame.arrows) {
        final fromSq = Square.fromName(arrow.fromSquare);
        final toSq = Square.fromName(arrow.toSquare);
        if (fromSq != null && toSq != null) {
          final c1 = _squareCenter(fromSq, boardX, boardY, sqSize);
          final c2 = _squareCenter(toSq, boardX, boardY, sqSize);
          final arrowColor = _parseColorHex(arrow.colorHex);
          img.drawLine(canvas, x1: c1.x, y1: c1.y, x2: c2.x, y2: c2.y, color: arrowColor, thickness: 3);
          // Arrowhead
          img.fillCircle(canvas, x: c2.x, y: c2.y, radius: 6, color: arrowColor);
        }
      }
    }

    // 7. Evaluation Bar
    if (profile.showEvaluationBar) {
      final barWidth = max(8, sqSize ~/ 4);
      final barX = boardX - barWidth - 12;
      final barY = boardY;
      final barHeight = boardSize;

      if (barX >= 4) {
        // Draw background
        img.fillRect(canvas, x1: barX, y1: barY, x2: barX + barWidth, y2: barY + barHeight, color: img.ColorRgb8(40, 40, 48));

        // Compute white portion
        final cp = frame.evaluationCentipawns ?? 0;
        final clampedCp = cp.clamp(-1000, 1000);
        final whiteFraction = (clampedCp + 1000) / 2000.0;
        final whiteHeight = (barHeight * whiteFraction).round();

        // White fill on bottom
        img.fillRect(
          canvas,
          x1: barX,
          y1: barY + barHeight - whiteHeight,
          x2: barX + barWidth,
          y2: barY + barHeight,
          color: textWhite,
        );
        img.drawRect(canvas, x1: barX, y1: barY, x2: barX + barWidth, y2: barY + barHeight, color: boardBorder);
      }
    }

    // 8. Move notation & subtitles banner
    final bannerY = min(height - 60, boardY + boardSize + 20);
    img.fillRect(canvas, x1: 20, y1: bannerY, x2: width - 20, y2: bannerY + 50, color: bannerBg);
    img.drawString(
      canvas,
      frame.moveNotation,
      font: img.arial24,
      x: 35,
      y: bannerY + 12,
      color: textWhite,
    );

    if (frame.subtitleText != null && frame.subtitleText!.isNotEmpty) {
      img.drawString(
        canvas,
        frame.subtitleText!,
        font: img.arial14,
        x: width - (frame.subtitleText!.length * 8) - 40,
        y: bannerY + 18,
        color: textMuted,
      );
    }

    return canvas;
  }

  static Point<int> _squareCenter(Square sq, int bx, int by, int sqSize) {
    final file = sq.file;
    final rank = sq.rank;
    final r = 7 - rank;
    final f = file;
    return Point<int>(
      bx + (f * sqSize) + (sqSize ~/ 2),
      by + (r * sqSize) + (sqSize ~/ 2),
    );
  }

  static void _drawPieceBadge(img.Image canvas, Piece piece, int cx, int cy, int radius) {
    final isWhite = piece.color == PieceColor.white;
    final bg = isWhite ? whitePieceBg : blackPieceBg;
    final border = isWhite ? whitePieceBorder : blackPieceBorder;
    final textCol = isWhite ? whitePieceText : blackPieceText;

    // Outer circular badge
    img.fillCircle(canvas, x: cx, y: cy, radius: radius, color: bg);
    img.drawCircle(canvas, x: cx, y: cy, radius: radius, color: border);

    // Piece letter
    final letter = piece.type.fenChar.toUpperCase();
    img.drawString(
      canvas,
      letter,
      font: img.arial14,
      x: cx - 4,
      y: cy - 7,
      color: textCol,
    );
  }

  static img.ColorRgb8 _parseColorHex(String hex) {
    final clean = hex.replaceAll('#', '');
    if (clean.length == 6) {
      final r = int.tryParse(clean.substring(0, 2), radix: 16) ?? 34;
      final g = int.tryParse(clean.substring(2, 4), radix: 16) ?? 197;
      final b = int.tryParse(clean.substring(4, 6), radix: 16) ?? 94;
      return img.ColorRgb8(r, g, b);
    }
    return img.ColorRgb8(34, 197, 94);
  }
}
