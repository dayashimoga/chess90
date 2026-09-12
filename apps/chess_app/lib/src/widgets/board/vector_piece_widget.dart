import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import '../../theme/piece_theme.dart';

/// A resolution-independent, high-contrast vector chess piece widget.
/// Eliminates platform emoji/font fallback defects (e.g. purple/grey pawns)
/// and guarantees 100% consistent styling and contrast across all 12 pieces.
class VectorPieceWidget extends StatelessWidget {
  final Piece piece;
  final double size;
  final PieceTheme theme;

  const VectorPieceWidget({
    super.key,
    required this.piece,
    required this.size,
    this.theme = PieceTheme.standard,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _PiecePainter(
          piece: piece,
          theme: theme,
        ),
      ),
    );
  }
}

class _PiecePainter extends CustomPainter {
  final Piece piece;
  final PieceTheme theme;

  _PiecePainter({required this.piece, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    final isWhite = piece.color == PieceColor.white;
    final fillColor = isWhite ? theme.whitePieceColor : theme.blackPieceColor;
    final strokeColor = isWhite ? theme.whiteStrokeColor : theme.blackStrokeColor;
    final strokeWidth = (isWhite ? theme.whiteStrokeWidth : theme.blackStrokeWidth) * (w / 60.0);
    final shadowColor = isWhite ? theme.whiteShadowColor : theme.blackShadowColor;

    // Canvas scaling to standard 100x100 coordinate box
    canvas.save();
    canvas.scale(w / 100.0, h / 100.0);

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth.clamp(1.0, 4.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final detailPaint = Paint()
      ..color = strokeColor.withAlpha(isWhite ? 180 : 220)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (strokeWidth * 0.75).clamp(0.8, 2.8)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Drop shadow
    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, theme.shadowBlurRadius);

    switch (piece.type) {
      case PieceType.pawn:
        _drawPawn(canvas, fillPaint, strokePaint, detailPaint, shadowPaint);
        break;
      case PieceType.knight:
        _drawKnight(canvas, fillPaint, strokePaint, detailPaint, shadowPaint);
        break;
      case PieceType.bishop:
        _drawBishop(canvas, fillPaint, strokePaint, detailPaint, shadowPaint);
        break;
      case PieceType.rook:
        _drawRook(canvas, fillPaint, strokePaint, detailPaint, shadowPaint);
        break;
      case PieceType.queen:
        _drawQueen(canvas, fillPaint, strokePaint, detailPaint, shadowPaint);
        break;
      case PieceType.king:
        _drawKing(canvas, fillPaint, strokePaint, detailPaint, shadowPaint);
        break;
    }

    canvas.restore();
  }

  void _drawPawn(Canvas canvas, Paint fill, Paint stroke, Paint detail, Paint shadow) {
    // Shadow base
    canvas.drawOval(const Rect.fromLTWH(24, 85, 52, 10), shadow);

    final body = Path()
      ..moveTo(26, 88)
      ..lineTo(74, 88)
      ..quadraticBezierTo(74, 82, 68, 80)
      ..lineTo(60, 52)
      ..quadraticBezierTo(62, 46, 62, 42)
      ..lineTo(38, 42)
      ..quadraticBezierTo(38, 46, 40, 52)
      ..lineTo(32, 80)
      ..quadraticBezierTo(26, 82, 26, 88)
      ..close();

    canvas.drawPath(body, fill);
    canvas.drawPath(body, stroke);

    // Collar ring
    final collar = RRect.fromRectAndRadius(const Rect.fromLTWH(34, 40, 32, 7), const Radius.circular(3));
    canvas.drawRRect(collar, fill);
    canvas.drawRRect(collar, stroke);

    // Head
    canvas.drawCircle(const Offset(50, 26), 14, fill);
    canvas.drawCircle(const Offset(50, 26), 14, stroke);

    // Base contour accent
    canvas.drawLine(const Offset(28, 83), const Offset(72, 83), detail);
  }

  void _drawKnight(Canvas canvas, Paint fill, Paint stroke, Paint detail, Paint shadow) {
    canvas.drawOval(const Rect.fromLTWH(22, 85, 56, 10), shadow);

    // Base
    final base = RRect.fromRectAndRadius(const Rect.fromLTWH(24, 82, 52, 9), const Radius.circular(3));
    canvas.drawRRect(base, fill);
    canvas.drawRRect(base, stroke);

    // Horse Head & Mane contour
    final horse = Path()
      ..moveTo(26, 82)
      ..lineTo(74, 82)
      ..quadraticBezierTo(74, 75, 71, 62)
      ..quadraticBezierTo(74, 50, 71, 38)
      ..quadraticBezierTo(68, 25, 58, 16) // Ear back
      ..lineTo(54, 13) // Ear tip
      ..lineTo(50, 21) // Ear front
      ..quadraticBezierTo(44, 21, 38, 28) // Forehead
      ..lineTo(25, 42) // Muzzle top
      ..quadraticBezierTo(20, 48, 22, 54) // Nose tip
      ..lineTo(30, 58) // Mouth
      ..lineTo(28, 62) // Chin
      ..quadraticBezierTo(34, 64, 40, 59) // Jaw
      ..quadraticBezierTo(38, 70, 26, 82) // Chest down
      ..close();

    canvas.drawPath(horse, fill);
    canvas.drawPath(horse, stroke);

    // Eye dot
    canvas.drawCircle(const Offset(38, 33), 2.5, stroke);
    // Nostril
    canvas.drawCircle(const Offset(26, 50), 1.8, stroke);
    // Mane accents
    canvas.drawLine(const Offset(56, 30), const Offset(64, 38), detail);
    canvas.drawLine(const Offset(58, 44), const Offset(66, 52), detail);
    canvas.drawLine(const Offset(58, 58), const Offset(65, 66), detail);
  }

  void _drawBishop(Canvas canvas, Paint fill, Paint stroke, Paint detail, Paint shadow) {
    canvas.drawOval(const Rect.fromLTWH(22, 85, 56, 10), shadow);

    // Base
    final base = RRect.fromRectAndRadius(const Rect.fromLTWH(24, 80, 52, 10), const Radius.circular(4));
    canvas.drawRRect(base, fill);
    canvas.drawRRect(base, stroke);

    // Body
    final body = Path()
      ..moveTo(30, 80)
      ..lineTo(70, 80)
      ..quadraticBezierTo(64, 60, 59, 52)
      ..lineTo(41, 52)
      ..quadraticBezierTo(36, 60, 30, 80)
      ..close();
    canvas.drawPath(body, fill);
    canvas.drawPath(body, stroke);

    // Collar ring
    final collar = RRect.fromRectAndRadius(const Rect.fromLTWH(36, 48, 28, 6), const Radius.circular(2));
    canvas.drawRRect(collar, fill);
    canvas.drawRRect(collar, stroke);

    // Mitre Head (pointed oval)
    final mitre = Path()
      ..moveTo(50, 18)
      ..cubicTo(68, 24, 68, 48, 50, 48)
      ..cubicTo(32, 48, 32, 24, 50, 18)
      ..close();
    canvas.drawPath(mitre, fill);
    canvas.drawPath(mitre, stroke);

    // Top Cross / Finial
    canvas.drawCircle(const Offset(50, 15), 3.5, fill);
    canvas.drawCircle(const Offset(50, 15), 3.5, stroke);

    // Diagonal mitre cut slit
    canvas.drawLine(const Offset(47, 26), const Offset(57, 36), stroke);
  }

  void _drawRook(Canvas canvas, Paint fill, Paint stroke, Paint detail, Paint shadow) {
    canvas.drawOval(const Rect.fromLTWH(20, 85, 60, 10), shadow);

    // Base
    final base = RRect.fromRectAndRadius(const Rect.fromLTWH(22, 80, 56, 10), const Radius.circular(3));
    canvas.drawRRect(base, fill);
    canvas.drawRRect(base, stroke);

    // Tower Body (slight inward taper)
    final tower = Path()
      ..moveTo(28, 80)
      ..lineTo(72, 80)
      ..lineTo(68, 40)
      ..lineTo(32, 40)
      ..close();
    canvas.drawPath(tower, fill);
    canvas.drawPath(tower, stroke);

    // Cornice / Parapet band
    final band = RRect.fromRectAndRadius(const Rect.fromLTWH(26, 35, 48, 6), const Radius.circular(2));
    canvas.drawRRect(band, fill);
    canvas.drawRRect(band, stroke);

    // Castle crenels (3 battlements, 2 notches)
    final crenels = Path()
      ..moveTo(26, 35)
      ..lineTo(26, 22)
      ..lineTo(35, 22)
      ..lineTo(35, 28)
      ..lineTo(44, 28)
      ..lineTo(44, 22)
      ..lineTo(56, 22)
      ..lineTo(56, 28)
      ..lineTo(65, 28)
      ..lineTo(65, 22)
      ..lineTo(74, 22)
      ..lineTo(74, 35)
      ..close();
    canvas.drawPath(crenels, fill);
    canvas.drawPath(crenels, stroke);

    // Waist line
    canvas.drawLine(const Offset(31, 60), const Offset(69, 60), detail);
  }

  void _drawQueen(Canvas canvas, Paint fill, Paint stroke, Paint detail, Paint shadow) {
    canvas.drawOval(const Rect.fromLTWH(18, 85, 64, 10), shadow);

    // Base
    final base = RRect.fromRectAndRadius(const Rect.fromLTWH(20, 80, 60, 10), const Radius.circular(4));
    canvas.drawRRect(base, fill);
    canvas.drawRRect(base, stroke);

    // Gown stem
    final gown = Path()
      ..moveTo(26, 80)
      ..lineTo(74, 80)
      ..quadraticBezierTo(68, 56, 62, 46)
      ..lineTo(38, 46)
      ..quadraticBezierTo(32, 56, 26, 80)
      ..close();
    canvas.drawPath(gown, fill);
    canvas.drawPath(gown, stroke);

    // Coronet band
    final coronet = RRect.fromRectAndRadius(const Rect.fromLTWH(32, 43, 36, 6), const Radius.circular(2));
    canvas.drawRRect(coronet, fill);
    canvas.drawRRect(coronet, stroke);

    // Crown with 5 distinct spikes
    final crown = Path()
      ..moveTo(32, 43)
      ..lineTo(22, 25) // Spike 1
      ..lineTo(34, 34)
      ..lineTo(37, 20) // Spike 2
      ..lineTo(46, 33)
      ..lineTo(50, 18) // Center Spike 3 (tallest)
      ..lineTo(54, 33)
      ..lineTo(63, 20) // Spike 4
      ..lineTo(66, 34)
      ..lineTo(78, 25) // Spike 5
      ..lineTo(68, 43)
      ..close();
    canvas.drawPath(crown, fill);
    canvas.drawPath(crown, stroke);

    // 5 Pearls on spikes
    canvas.drawCircle(const Offset(22, 24), 2.5, fill);
    canvas.drawCircle(const Offset(22, 24), 2.5, stroke);

    canvas.drawCircle(const Offset(37, 19), 2.5, fill);
    canvas.drawCircle(const Offset(37, 19), 2.5, stroke);

    canvas.drawCircle(const Offset(50, 17), 3.0, fill);
    canvas.drawCircle(const Offset(50, 17), 3.0, stroke);

    canvas.drawCircle(const Offset(63, 19), 2.5, fill);
    canvas.drawCircle(const Offset(63, 19), 2.5, stroke);

    canvas.drawCircle(const Offset(78, 24), 2.5, fill);
    canvas.drawCircle(const Offset(78, 24), 2.5, stroke);
  }

  void _drawKing(Canvas canvas, Paint fill, Paint stroke, Paint detail, Paint shadow) {
    canvas.drawOval(const Rect.fromLTWH(18, 85, 64, 10), shadow);

    // Base
    final base = RRect.fromRectAndRadius(const Rect.fromLTWH(20, 80, 60, 10), const Radius.circular(4));
    canvas.drawRRect(base, fill);
    canvas.drawRRect(base, stroke);

    // Royal Robes stem
    final robes = Path()
      ..moveTo(26, 80)
      ..lineTo(74, 80)
      ..quadraticBezierTo(68, 56, 62, 48)
      ..lineTo(38, 48)
      ..quadraticBezierTo(32, 56, 26, 80)
      ..close();
    canvas.drawPath(robes, fill);
    canvas.drawPath(robes, stroke);

    // Collar
    final collar = RRect.fromRectAndRadius(const Rect.fromLTWH(30, 45, 40, 6), const Radius.circular(3));
    canvas.drawRRect(collar, fill);
    canvas.drawRRect(collar, stroke);

    // Imperial Crown Dome
    final crown = Path()
      ..moveTo(30, 45)
      ..cubicTo(20, 30, 40, 24, 50, 25)
      ..cubicTo(60, 24, 80, 30, 70, 45)
      ..close();
    canvas.drawPath(crown, fill);
    canvas.drawPath(crown, stroke);

    // Crown cross
    final cross = Path()
      // Vertical bar
      ..moveTo(48, 12)
      ..lineTo(52, 12)
      ..lineTo(52, 25)
      ..lineTo(48, 25)
      ..close()
      // Horizontal crosspiece
      ..moveTo(42, 16)
      ..lineTo(58, 16)
      ..lineTo(58, 20)
      ..lineTo(42, 20)
      ..close();
    canvas.drawPath(cross, fill);
    canvas.drawPath(cross, stroke);

    // Crown arch detail
    canvas.drawLine(const Offset(50, 25), const Offset(50, 45), detail);
  }

  @override
  bool shouldRepaint(covariant _PiecePainter oldDelegate) {
    return oldDelegate.piece != piece || oldDelegate.theme != theme;
  }
}
