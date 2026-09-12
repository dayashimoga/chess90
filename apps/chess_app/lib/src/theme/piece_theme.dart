import 'package:flutter/material.dart';

/// Defines visual styling for chess pieces to ensure 100% consistent colors,
/// strong contrast on both light and dark squares, and crisp vector rendering.
class PieceTheme {
  final Color whitePieceColor;
  final Color whiteStrokeColor;
  final double whiteStrokeWidth;
  final Color whiteShadowColor;

  final Color blackPieceColor;
  final Color blackStrokeColor;
  final double blackStrokeWidth;
  final Color blackShadowColor;

  final double shadowBlurRadius;
  final Offset shadowOffset;

  const PieceTheme({
    this.whitePieceColor = const Color(0xFFFFFFFF),
    this.whiteStrokeColor = const Color(0xFF1E293B),
    this.whiteStrokeWidth = 2.0,
    this.whiteShadowColor = const Color(0x40000000),
    this.blackPieceColor = const Color(0xFF111827),
    this.blackStrokeColor = const Color(0xFFF8FAFC),
    this.blackStrokeWidth = 1.6,
    this.blackShadowColor = const Color(0x55000000),
    this.shadowBlurRadius = 3.0,
    this.shadowOffset = const Offset(1.0, 1.5),
  });

  /// Standard tournament Staunton piece theme with optimal contrast.
  static const PieceTheme standard = PieceTheme();

  /// High contrast accessibility piece theme.
  static const PieceTheme highContrast = PieceTheme(
    whitePieceColor: Color(0xFFFFFFFF),
    whiteStrokeColor: Color(0xFF000000),
    whiteStrokeWidth: 3.0,
    blackPieceColor: Color(0xFF000000),
    blackStrokeColor: Color(0xFFFFFFFF),
    blackStrokeWidth: 2.5,
    shadowBlurRadius: 4.0,
    shadowOffset: Offset(1.5, 2.0),
  );

  /// Warm wood/ivory piece theme.
  static const PieceTheme classicWood = PieceTheme(
    whitePieceColor: Color(0xFFFBF7EE),
    whiteStrokeColor: Color(0xFF332A1E),
    whiteStrokeWidth: 2.0,
    blackPieceColor: Color(0xFF261E16),
    blackStrokeColor: Color(0xFFE8DCC8),
    blackStrokeWidth: 1.6,
  );
}
