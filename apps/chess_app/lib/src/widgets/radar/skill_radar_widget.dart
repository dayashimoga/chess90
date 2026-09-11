import 'dart:math';
import 'package:chess_learning/chess_learning.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';

/// Interactive 12-axis radar polygon comparing user skill mastery against GM baseline.
class SkillRadarWidget extends StatelessWidget {
  final Map<SkillAxis, double> currentScores;
  final Map<SkillAxis, double>? baselineScores;

  const SkillRadarWidget({
    super.key,
    required this.currentScores,
    this.baselineScores,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);
        return Center(
          child: CustomPaint(
            size: Size(size, size),
            painter: _RadarPainter(
              currentScores: currentScores,
              baselineScores: baselineScores,
            ),
          ),
        );
      },
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Map<SkillAxis, double> currentScores;
  final Map<SkillAxis, double>? baselineScores;

  _RadarPainter({
    required this.currentScores,
    this.baselineScores,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * 0.75;
    const axes = SkillAxis.values;
    final count = axes.length;
    final angleStep = (2 * pi) / count;

    final gridPaint = Paint()
      ..color = ChessTheme.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw 5 concentric web rings (20%, 40%, 60%, 80%, 100%)
    for (int ring = 1; ring <= 5; ring++) {
      final ringRadius = (radius / 5) * ring;
      final path = Path();
      for (int i = 0; i < count; i++) {
        final angle = i * angleStep - (pi / 2);
        final x = center.dx + ringRadius * cos(angle);
        final y = center.dy + ringRadius * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw 12 radial spokes and axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < count; i++) {
      final angle = i * angleStep - (pi / 2);
      final spokeEnd = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, spokeEnd, gridPaint);

      // Label
      final labelRadius = radius + 22;
      final labelPos = Offset(
        center.dx + labelRadius * cos(angle),
        center.dy + labelRadius * sin(angle),
      );

      textPainter.text = TextSpan(
        text: axes[i].name.toUpperCase(),
        style: const TextStyle(
          color: ChessTheme.textSecondary,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(labelPos.dx - (textPainter.width / 2), labelPos.dy - (textPainter.height / 2)),
      );
    }

    // Draw baseline polygon (if provided)
    if (baselineScores != null) {
      final baselinePath = Path();
      for (int i = 0; i < count; i++) {
        final score = (baselineScores![axes[i]] ?? 0.0).clamp(0.0, 1.0);
        final angle = i * angleStep - (pi / 2);
        final r = radius * score;
        final point = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
        if (i == 0) {
          baselinePath.moveTo(point.dx, point.dy);
        } else {
          baselinePath.lineTo(point.dx, point.dy);
        }
      }
      baselinePath.close();

      final baselinePaint = Paint()
        ..color = ChessTheme.accentGold.withAlpha(50)
        ..style = PaintingStyle.fill;
      final baselineStroke = Paint()
        ..color = ChessTheme.accentGold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawPath(baselinePath, baselinePaint);
      canvas.drawPath(baselinePath, baselineStroke);
    }

    // Draw current score polygon
    final currentPath = Path();
    for (int i = 0; i < count; i++) {
      final score = (currentScores[axes[i]] ?? 0.0).clamp(0.0, 1.0);
      final angle = i * angleStep - (pi / 2);
      final r = radius * score;
      final point = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
      if (i == 0) {
        currentPath.moveTo(point.dx, point.dy);
      } else {
        currentPath.lineTo(point.dx, point.dy);
      }
    }
    currentPath.close();

    final currentFill = Paint()
      ..color = ChessTheme.primary.withAlpha(70)
      ..style = PaintingStyle.fill;
    final currentStroke = Paint()
      ..color = ChessTheme.primaryLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawPath(currentPath, currentFill);
    canvas.drawPath(currentPath, currentStroke);

    // Draw vertex dots
    final dotPaint = Paint()..color = ChessTheme.primaryLight;
    for (int i = 0; i < count; i++) {
      final score = (currentScores[axes[i]] ?? 0.0).clamp(0.0, 1.0);
      final angle = i * angleStep - (pi / 2);
      final r = radius * score;
      final point = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
      canvas.drawCircle(point, 3.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}
