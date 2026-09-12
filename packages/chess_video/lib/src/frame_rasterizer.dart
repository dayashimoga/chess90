import 'dart:math';
import 'package:chess_core/chess_core.dart';
import 'package:image/image.dart' as img;
import 'models/video_frame.dart';
import 'models/video_profile.dart';

/// Rasterizes discrete VideoFrames into high-resolution bitmap images using package:image.
/// Implements authentic Staunton vector chess piece drawing, full board & piece theme support,
/// coordinates, dynamic move arrows, evaluation bar, and notation banners.
class FrameRasterizer {
  static final img.ColorRgb8 bgDark = img.ColorRgb8(15, 17, 23);
  static final img.ColorRgb8 boardBorder = img.ColorRgb8(30, 41, 59);
  static final img.ColorRgb8 highlightSquare = img.ColorRgb8(246, 246, 105);
  static final img.ColorRgb8 bannerBg = img.ColorRgb8(24, 27, 36);
  static final img.ColorRgb8 textWhite = img.ColorRgb8(255, 255, 255);
  static final img.ColorRgb8 textMuted = img.ColorRgb8(156, 163, 175);
  static final img.ColorRgb8 shadowColor = img.ColorRgb8(10, 10, 15);

  /// Resolves board square colors based on the selected theme.
  static ({img.ColorRgb8 light, img.ColorRgb8 dark, img.ColorRgb8 border, img.ColorRgb8 coord})
      _resolveBoardTheme(String theme) {
    switch (theme) {
      case 'classicWood':
        return (
          light: img.ColorRgb8(240, 217, 181),
          dark: img.ColorRgb8(181, 136, 99),
          border: img.ColorRgb8(74, 53, 37),
          coord: img.ColorRgb8(200, 180, 160),
        );
      case 'slateBlue':
        return (
          light: img.ColorRgb8(222, 227, 230),
          dark: img.ColorRgb8(140, 162, 173),
          border: img.ColorRgb8(30, 41, 59),
          coord: img.ColorRgb8(160, 175, 190),
        );
      case 'highContrast':
        return (
          light: img.ColorRgb8(255, 255, 255),
          dark: img.ColorRgb8(35, 35, 35),
          border: img.ColorRgb8(0, 0, 0),
          coord: img.ColorRgb8(200, 200, 200),
        );
      case 'tournamentGreen':
      default:
        return (
          light: img.ColorRgb8(238, 238, 210),
          dark: img.ColorRgb8(118, 150, 86),
          border: img.ColorRgb8(30, 41, 59),
          coord: img.ColorRgb8(160, 175, 160),
        );
    }
  }

  /// Resolves piece fill and stroke colors based on the selected theme and piece color.
  static ({img.ColorRgb8 fill, img.ColorRgb8 stroke, int strokeWidth}) _resolvePieceColors(
      String theme, bool isWhite) {
    switch (theme) {
      case 'highContrast':
        return isWhite
            ? (fill: img.ColorRgb8(255, 255, 255), stroke: img.ColorRgb8(0, 0, 0), strokeWidth: 3)
            : (fill: img.ColorRgb8(0, 0, 0), stroke: img.ColorRgb8(255, 255, 255), strokeWidth: 3);
      case 'classicWood':
        return isWhite
            ? (fill: img.ColorRgb8(251, 247, 238), stroke: img.ColorRgb8(51, 42, 30), strokeWidth: 2)
            : (fill: img.ColorRgb8(45, 35, 26), stroke: img.ColorRgb8(232, 220, 200), strokeWidth: 2);
      case 'standard':
      default:
        return isWhite
            ? (fill: img.ColorRgb8(255, 255, 255), stroke: img.ColorRgb8(30, 41, 59), strokeWidth: 2)
            : (fill: img.ColorRgb8(20, 20, 24), stroke: img.ColorRgb8(241, 245, 249), strokeWidth: 2);
    }
  }

  /// Rasterizes a single VideoFrame into a high-resolution Image.
  static img.Image rasterize(VideoFrame frame, VideoProfile profile) {
    final width = profile.width;
    final height = profile.height;
    final canvas = img.Image(width: width, height: height);

    // 1. Background fill
    img.fill(canvas, color: bgDark);

    // 2. Compute board layout geometry
    final margin = min(width, height) * 0.08;
    final availableSize = min(width, height) - (margin * 2);
    final boardSize = (availableSize ~/ 8) * 8; // ensure divisible by 8
    final sqSize = boardSize ~/ 8;

    final boardX = (width - boardSize) ~/ 2;
    final boardY = (height - boardSize) ~/ 2 + (height > width ? -sqSize ~/ 2 : 0);

    final boardColors = _resolveBoardTheme(profile.boardThemeName);

    // Outer border
    img.drawRect(
      canvas,
      x1: boardX - 3,
      y1: boardY - 3,
      x2: boardX + boardSize + 3,
      y2: boardY + boardSize + 3,
      color: boardColors.border,
    );

    // 3. Squares & Highlights
    final board = Board.fromFen(frame.fen);
    final inMotionFrom = frame.movingFrom;
    final inMotionTo = frame.movingTo;
    final isFlipped = profile.isBoardFlipped;

    for (int r = 0; r < 8; r++) {
      for (int f = 0; f < 8; f++) {
        final rank = isFlipped ? r : 7 - r;
        final file = isFlipped ? 7 - f : f;
        final squareIndex = rank * 8 + file;
        final square = Square(squareIndex);
        final isLight = (rank + file) % 2 != 0;

        final sx1 = boardX + (f * sqSize);
        final sy1 = boardY + (r * sqSize);
        final sx2 = sx1 + sqSize;
        final sy2 = sy1 + sqSize;

        // Base square color
        img.ColorRgb8 sqColor = isLight ? boardColors.light : boardColors.dark;

        // Check if square is highlighted
        if (frame.highlightedSquares.contains(square) ||
            (profile.showLastMoveHighlight && (square == inMotionFrom || square == inMotionTo))) {
          sqColor = highlightSquare;
        }

        img.fillRect(canvas, x1: sx1, y1: sy1, x2: sx2, y2: sy2, color: sqColor);

        // Optional coordinates on perimeter squares
        if (profile.showCoordinates) {
          if (f == 0) {
            final rankLabel = (rank + 1).toString();
            img.drawString(
              canvas,
              rankLabel,
              font: img.arial14,
              x: sx1 + 4,
              y: sy1 + 4,
              color: isLight ? boardColors.dark : boardColors.light,
            );
          }
          if (r == 7) {
            final fileLabel = String.fromCharCode('a'.codeUnitAt(0) + file);
            img.drawString(
              canvas,
              fileLabel,
              font: img.arial14,
              x: sx2 - 12,
              y: sy2 - 16,
              color: isLight ? boardColors.dark : boardColors.light,
            );
          }
        }

        // 4. Static pieces
        final piece = board.pieceAt(square);
        if (piece != null) {
          // If this piece is currently in motion, skip drawing at movingFrom square
          if (frame.isPieceInMotion && square == inMotionFrom) {
            continue;
          }

          final centerX = sx1 + (sqSize ~/ 2);
          final centerY = sy1 + (sqSize ~/ 2);
          _drawPiece(canvas, piece, centerX, centerY, sqSize, profile.pieceThemeName);
        }
      }
    }

    // 5. Piece in motion (interpolated trajectory)
    if (frame.isPieceInMotion && frame.movingPiece != null && inMotionFrom != null && inMotionTo != null) {
      final fromCenter = _squareCenter(inMotionFrom, boardX, boardY, sqSize, isFlipped);
      final toCenter = _squareCenter(inMotionTo, boardX, boardY, sqSize, isFlipped);

      final frac = frame.interpolationFraction.clamp(0.0, 1.0);
      final currentX = (fromCenter.x + (toCenter.x - fromCenter.x) * frac).round();
      final currentY = (fromCenter.y + (toCenter.y - fromCenter.y) * frac).round();

      // Drop shadow for moving piece
      img.fillCircle(canvas, x: currentX + 4, y: currentY + 6, radius: sqSize ~/ 3, color: shadowColor);

      // Moving piece
      _drawPiece(canvas, frame.movingPiece!, currentX, currentY, sqSize, profile.pieceThemeName);
    }

    // 6. Arrows
    if (profile.showArrows) {
      for (final arrow in frame.arrows) {
        final fromSq = Square.fromName(arrow.fromSquare);
        final toSq = Square.fromName(arrow.toSquare);
        if (fromSq != null && toSq != null) {
          final c1 = _squareCenter(fromSq, boardX, boardY, sqSize, isFlipped);
          final c2 = _squareCenter(toSq, boardX, boardY, sqSize, isFlipped);
          final arrowColor = _parseColorHex(arrow.colorHex);
          img.drawLine(canvas, x1: c1.x, y1: c1.y, x2: c2.x, y2: c2.y, color: arrowColor, thickness: 3);
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
        img.fillRect(canvas, x1: barX, y1: barY, x2: barX + barWidth, y2: barY + barHeight, color: img.ColorRgb8(35, 39, 47));

        final cp = frame.evaluationCentipawns ?? 0;
        final clampedCp = cp.clamp(-1000, 1000);
        final whiteFraction = (clampedCp + 1000) / 2000.0;
        final whiteHeight = (barHeight * whiteFraction).round();

        img.fillRect(
          canvas,
          x1: barX,
          y1: barY + barHeight - whiteHeight,
          x2: barX + barWidth,
          y2: barY + barHeight,
          color: textWhite,
        );
        img.drawRect(canvas, x1: barX, y1: barY, x2: barX + barWidth, y2: barY + barHeight, color: boardColors.border);
      }
    }

    // 8. Player header card (if enabled)
    if (profile.showPlayerCards && (profile.whitePlayerName != null || profile.blackPlayerName != null)) {
      final headerY = max(8, boardY - 45);
      final white = profile.whitePlayerName ?? 'White';
      final black = profile.blackPlayerName ?? 'Black';
      img.drawString(
        canvas,
        '$white vs $black',
        font: img.arial14,
        x: boardX,
        y: headerY,
        color: textWhite,
      );
    }

    // 9. Move notation & subtitles banner
    final bannerY = min(height - 60, boardY + boardSize + 20);
    img.fillRect(canvas, x1: 20, y1: bannerY, x2: width - 20, y2: bannerY + 50, color: bannerBg);
    img.drawRect(canvas, x1: 20, y1: bannerY, x2: width - 20, y2: bannerY + 50, color: boardColors.border);

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

  static Point<int> _squareCenter(Square sq, int bx, int by, int sqSize, bool isFlipped) {
    final file = sq.file;
    final rank = sq.rank;
    final r = isFlipped ? rank : 7 - rank;
    final f = isFlipped ? 7 - file : file;
    return Point<int>(
      bx + (f * sqSize) + (sqSize ~/ 2),
      by + (r * sqSize) + (sqSize ~/ 2),
    );
  }

  /// Draws an authentic chess piece on the canvas.
  /// When pieceTheme is 'minimalNotation', falls back to circular badge with letter.
  /// Otherwise, draws true vector Staunton silhouettes for all 12 piece types.
  static void _drawPiece(
      img.Image canvas, Piece piece, int cx, int cy, int sqSize, String pieceTheme) {
    if (pieceTheme == 'minimalNotation') {
      _drawPieceBadge(canvas, piece, cx, cy, sqSize ~/ 2 - 4);
      return;
    }

    final isWhite = piece.color == PieceColor.white;
    final colors = _resolvePieceColors(pieceTheme, isWhite);
    final fill = colors.fill;
    final stroke = colors.stroke;

    // Scale factors
    final s = sqSize / 100.0;
    final baseY = (cy + 38 * s).round();

    // Base drop shadow
    img.fillCircle(canvas, x: cx, y: (baseY + 2 * s).round(), radius: (24 * s).round(), color: shadowColor);

    switch (piece.type) {
      case PieceType.pawn:
        _drawPawn(canvas, cx, cy, s, baseY, fill, stroke);
        break;
      case PieceType.knight:
        _drawKnight(canvas, cx, cy, s, baseY, fill, stroke);
        break;
      case PieceType.bishop:
        _drawBishop(canvas, cx, cy, s, baseY, fill, stroke);
        break;
      case PieceType.rook:
        _drawRook(canvas, cx, cy, s, baseY, fill, stroke);
        break;
      case PieceType.queen:
        _drawQueen(canvas, cx, cy, s, baseY, fill, stroke);
        break;
      case PieceType.king:
        _drawKing(canvas, cx, cy, s, baseY, fill, stroke);
        break;
    }
  }

  // --- TRUE VECTOR PIECE DRAWERS ---

  static void _drawPawn(img.Image canvas, int cx, int cy, double s, int baseY,
      img.ColorRgb8 fill, img.ColorRgb8 stroke) {
    // 1. Base pedestal
    final basePts = [
      img.Point((cx - 24 * s).round(), baseY),
      img.Point((cx + 24 * s).round(), baseY),
      img.Point((cx + 20 * s).round(), (baseY - 7 * s).round()),
      img.Point((cx - 20 * s).round(), (baseY - 7 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: basePts, color: fill);
    img.drawPolygon(canvas, vertices: basePts, color: stroke);

    // 2. Tapered body
    final bodyPts = [
      img.Point((cx - 18 * s).round(), (baseY - 7 * s).round()),
      img.Point((cx + 18 * s).round(), (baseY - 7 * s).round()),
      img.Point((cx + 9 * s).round(), (cy - 4 * s).round()),
      img.Point((cx - 9 * s).round(), (cy - 4 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: bodyPts, color: fill);
    img.drawPolygon(canvas, vertices: bodyPts, color: stroke);

    // 3. Collar ring
    final collarPts = [
      img.Point((cx - 15 * s).round(), (cy - 4 * s).round()),
      img.Point((cx + 15 * s).round(), (cy - 4 * s).round()),
      img.Point((cx + 13 * s).round(), (cy - 10 * s).round()),
      img.Point((cx - 13 * s).round(), (cy - 10 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: collarPts, color: fill);
    img.drawPolygon(canvas, vertices: collarPts, color: stroke);

    // 4. Spherical head
    final headY = (cy - 22 * s).round();
    final headR = (13 * s).round();
    img.fillCircle(canvas, x: cx, y: headY, radius: headR, color: fill);
    img.drawCircle(canvas, x: cx, y: headY, radius: headR, color: stroke);
  }

  static void _drawRook(img.Image canvas, int cx, int cy, double s, int baseY,
      img.ColorRgb8 fill, img.ColorRgb8 stroke) {
    // 1. Base pedestal
    final basePts = [
      img.Point((cx - 26 * s).round(), baseY),
      img.Point((cx + 26 * s).round(), baseY),
      img.Point((cx + 22 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx - 22 * s).round(), (baseY - 8 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: basePts, color: fill);
    img.drawPolygon(canvas, vertices: basePts, color: stroke);

    // 2. Tower trunk
    final trunkPts = [
      img.Point((cx - 18 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 18 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 15 * s).round(), (cy - 8 * s).round()),
      img.Point((cx - 15 * s).round(), (cy - 8 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: trunkPts, color: fill);
    img.drawPolygon(canvas, vertices: trunkPts, color: stroke);

    // 3. Parapet cornice
    final cornicePts = [
      img.Point((cx - 22 * s).round(), (cy - 8 * s).round()),
      img.Point((cx + 22 * s).round(), (cy - 8 * s).round()),
      img.Point((cx + 22 * s).round(), (cy - 14 * s).round()),
      img.Point((cx - 22 * s).round(), (cy - 14 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: cornicePts, color: fill);
    img.drawPolygon(canvas, vertices: cornicePts, color: stroke);

    // 4. Crenellated battlements (3 merlons, 2 embrasures)
    final battlementsPts = [
      img.Point((cx - 22 * s).round(), (cy - 14 * s).round()),
      img.Point((cx - 22 * s).round(), (cy - 30 * s).round()), // left top
      img.Point((cx - 14 * s).round(), (cy - 30 * s).round()),
      img.Point((cx - 14 * s).round(), (cy - 21 * s).round()), // notch 1
      img.Point((cx - 6 * s).round(), (cy - 21 * s).round()),
      img.Point((cx - 6 * s).round(), (cy - 30 * s).round()), // center top
      img.Point((cx + 6 * s).round(), (cy - 30 * s).round()),
      img.Point((cx + 6 * s).round(), (cy - 21 * s).round()), // notch 2
      img.Point((cx + 14 * s).round(), (cy - 21 * s).round()),
      img.Point((cx + 14 * s).round(), (cy - 30 * s).round()), // right top
      img.Point((cx + 22 * s).round(), (cy - 30 * s).round()),
      img.Point((cx + 22 * s).round(), (cy - 14 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: battlementsPts, color: fill);
    img.drawPolygon(canvas, vertices: battlementsPts, color: stroke);
  }

  static void _drawKnight(img.Image canvas, int cx, int cy, double s, int baseY,
      img.ColorRgb8 fill, img.ColorRgb8 stroke) {
    // 1. Base pedestal
    final basePts = [
      img.Point((cx - 25 * s).round(), baseY),
      img.Point((cx + 25 * s).round(), baseY),
      img.Point((cx + 21 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx - 21 * s).round(), (baseY - 8 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: basePts, color: fill);
    img.drawPolygon(canvas, vertices: basePts, color: stroke);

    // 2. Horse profile polygon (facing left)
    final horsePts = [
      img.Point((cx - 18 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 18 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 16 * s).round(), (cy + 12 * s).round()),
      img.Point((cx + 12 * s).round(), (cy - 10 * s).round()),
      img.Point((cx + 8 * s).round(), (cy - 28 * s).round()), // rear ear
      img.Point((cx + 2 * s).round(), (cy - 20 * s).round()), // ear notch
      img.Point((cx - 2 * s).round(), (cy - 28 * s).round()), // front ear
      img.Point((cx - 14 * s).round(), (cy - 15 * s).round()), // forehead
      img.Point((cx - 24 * s).round(), (cy - 4 * s).round()), // muzzle
      img.Point((cx - 22 * s).round(), (cy + 6 * s).round()), // mouth/chin
      img.Point((cx - 10 * s).round(), (cy + 10 * s).round()), // jaw
      img.Point((cx - 8 * s).round(), (cy + 22 * s).round()), // chest
    ];
    img.fillPolygon(canvas, vertices: horsePts, color: fill);
    img.drawPolygon(canvas, vertices: horsePts, color: stroke);

    // Eye accent
    img.fillCircle(canvas, x: (cx - 10 * s).round(), y: (cy - 10 * s).round(), radius: max(1, (2 * s).round()), color: stroke);
    // Mane accent lines
    img.drawLine(canvas, x1: (cx + 6 * s).round(), y1: (cy - 8 * s).round(), x2: (cx + 14 * s).round(), y2: (cy - 2 * s).round(), color: stroke);
  }

  static void _drawBishop(img.Image canvas, int cx, int cy, double s, int baseY,
      img.ColorRgb8 fill, img.ColorRgb8 stroke) {
    // 1. Base pedestal
    final basePts = [
      img.Point((cx - 24 * s).round(), baseY),
      img.Point((cx + 24 * s).round(), baseY),
      img.Point((cx + 20 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx - 20 * s).round(), (baseY - 8 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: basePts, color: fill);
    img.drawPolygon(canvas, vertices: basePts, color: stroke);

    // 2. Body column
    final bodyPts = [
      img.Point((cx - 17 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 17 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 10 * s).round(), (cy + 4 * s).round()),
      img.Point((cx - 10 * s).round(), (cy + 4 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: bodyPts, color: fill);
    img.drawPolygon(canvas, vertices: bodyPts, color: stroke);

    // 3. Collar ring
    final collarPts = [
      img.Point((cx - 15 * s).round(), (cy + 4 * s).round()),
      img.Point((cx + 15 * s).round(), (cy + 4 * s).round()),
      img.Point((cx + 13 * s).round(), (cy - 2 * s).round()),
      img.Point((cx - 13 * s).round(), (cy - 2 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: collarPts, color: fill);
    img.drawPolygon(canvas, vertices: collarPts, color: stroke);

    // 4. Mitre (pointed teardrop/oval head)
    final mitrePts = [
      img.Point(cx, (cy - 2 * s).round()),
      img.Point((cx - 16 * s).round(), (cy - 14 * s).round()),
      img.Point((cx - 12 * s).round(), (cy - 28 * s).round()),
      img.Point(cx, (cy - 34 * s).round()), // tip
      img.Point((cx + 12 * s).round(), (cy - 28 * s).round()),
      img.Point((cx + 16 * s).round(), (cy - 14 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: mitrePts, color: fill);
    img.drawPolygon(canvas, vertices: mitrePts, color: stroke);

    // Top finial ball
    img.fillCircle(canvas, x: cx, y: (cy - 36 * s).round(), radius: (3 * s).round(), color: fill);
    img.drawCircle(canvas, x: cx, y: (cy - 36 * s).round(), radius: (3 * s).round(), color: stroke);

    // Mitre slash/cut
    img.drawLine(canvas,
        x1: (cx - 7 * s).round(),
        y1: (cy - 22 * s).round(),
        x2: (cx + 5 * s).round(),
        y2: (cy - 12 * s).round(),
        color: stroke);
  }

  static void _drawQueen(img.Image canvas, int cx, int cy, double s, int baseY,
      img.ColorRgb8 fill, img.ColorRgb8 stroke) {
    // 1. Base pedestal
    final basePts = [
      img.Point((cx - 26 * s).round(), baseY),
      img.Point((cx + 26 * s).round(), baseY),
      img.Point((cx + 22 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx - 22 * s).round(), (baseY - 8 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: basePts, color: fill);
    img.drawPolygon(canvas, vertices: basePts, color: stroke);

    // 2. Gown waist
    final waistPts = [
      img.Point((cx - 18 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 18 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 11 * s).round(), (cy + 6 * s).round()),
      img.Point((cx - 11 * s).round(), (cy + 6 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: waistPts, color: fill);
    img.drawPolygon(canvas, vertices: waistPts, color: stroke);

    // 3. Flared 5-point coronet
    final crownPts = [
      img.Point((cx - 13 * s).round(), (cy + 6 * s).round()),
      img.Point((cx - 24 * s).round(), (cy - 18 * s).round()), // p1
      img.Point((cx - 16 * s).round(), (cy - 8 * s).round()),
      img.Point((cx - 12 * s).round(), (cy - 24 * s).round()), // p2
      img.Point((cx - 5 * s).round(), (cy - 8 * s).round()),
      img.Point(cx, (cy - 28 * s).round()), // p3 center high
      img.Point((cx + 5 * s).round(), (cy - 8 * s).round()),
      img.Point((cx + 12 * s).round(), (cy - 24 * s).round()), // p4
      img.Point((cx + 16 * s).round(), (cy - 8 * s).round()),
      img.Point((cx + 24 * s).round(), (cy - 18 * s).round()), // p5
      img.Point((cx + 13 * s).round(), (cy + 6 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: crownPts, color: fill);
    img.drawPolygon(canvas, vertices: crownPts, color: stroke);

    // Jewels on coronet tips
    for (final pt in [
      img.Point((cx - 24 * s).round(), (cy - 18 * s).round()),
      img.Point((cx - 12 * s).round(), (cy - 24 * s).round()),
      img.Point(cx, (cy - 28 * s).round()),
      img.Point((cx + 12 * s).round(), (cy - 24 * s).round()),
      img.Point((cx + 24 * s).round(), (cy - 18 * s).round()),
    ]) {
      img.fillCircle(canvas, x: pt.x.toInt(), y: pt.y.toInt(), radius: (3 * s).round(), color: fill);
      img.drawCircle(canvas, x: pt.x.toInt(), y: pt.y.toInt(), radius: (3 * s).round(), color: stroke);
    }
  }

  static void _drawKing(img.Image canvas, int cx, int cy, double s, int baseY,
      img.ColorRgb8 fill, img.ColorRgb8 stroke) {
    // 1. Base pedestal
    final basePts = [
      img.Point((cx - 26 * s).round(), baseY),
      img.Point((cx + 26 * s).round(), baseY),
      img.Point((cx + 22 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx - 22 * s).round(), (baseY - 8 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: basePts, color: fill);
    img.drawPolygon(canvas, vertices: basePts, color: stroke);

    // 2. Royal mantle
    final mantlePts = [
      img.Point((cx - 19 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 19 * s).round(), (baseY - 8 * s).round()),
      img.Point((cx + 14 * s).round(), (cy + 4 * s).round()),
      img.Point((cx - 14 * s).round(), (cy + 4 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: mantlePts, color: fill);
    img.drawPolygon(canvas, vertices: mantlePts, color: stroke);

    // 3. Royal crown dome
    final crownPts = [
      img.Point((cx - 15 * s).round(), (cy + 4 * s).round()),
      img.Point((cx - 22 * s).round(), (cy - 12 * s).round()),
      img.Point((cx - 16 * s).round(), (cy - 24 * s).round()),
      img.Point(cx, (cy - 22 * s).round()),
      img.Point((cx + 16 * s).round(), (cy - 24 * s).round()),
      img.Point((cx + 22 * s).round(), (cy - 12 * s).round()),
      img.Point((cx + 15 * s).round(), (cy + 4 * s).round()),
    ];
    img.fillPolygon(canvas, vertices: crownPts, color: fill);
    img.drawPolygon(canvas, vertices: crownPts, color: stroke);

    // 4. Christian Cross (+) finial
    final crossTop = (cy - 36 * s).round();
    final crossBottom = (cy - 23 * s).round();
    final crossMidY = (cy - 30 * s).round();
    final crossLeft = (cx - 7 * s).round();
    final crossRight = (cx + 7 * s).round();

    img.drawLine(canvas, x1: cx, y1: crossBottom, x2: cx, y2: crossTop, color: stroke, thickness: 2);
    img.drawLine(canvas, x1: crossLeft, y1: crossMidY, x2: crossRight, y2: crossMidY, color: stroke, thickness: 2);
  }

  /// Minimal notation fallback badge (only if user explicitly selected minimal notation)
  static void _drawPieceBadge(img.Image canvas, Piece piece, int cx, int cy, int radius) {
    final isWhite = piece.color == PieceColor.white;
    final bg = isWhite ? img.ColorRgb8(250, 250, 250) : img.ColorRgb8(30, 30, 40);
    final border = isWhite ? img.ColorRgb8(40, 40, 50) : img.ColorRgb8(200, 200, 215);
    final textCol = isWhite ? img.ColorRgb8(20, 20, 30) : img.ColorRgb8(240, 240, 250);

    img.fillCircle(canvas, x: cx, y: cy, radius: radius, color: bg);
    img.drawCircle(canvas, x: cx, y: cy, radius: radius, color: border);

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
