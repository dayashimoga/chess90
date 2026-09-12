import 'package:flutter/material.dart';

/// Defines visual styling for the 64-square chessboard across all screens.
class ChessBoardTheme {
  final String name;
  final Color lightSquare;
  final Color darkSquare;
  final Color coordinateLightSquare;
  final Color coordinateDarkSquare;
  final Color selectedSquareOverlay;
  final Color lastMoveSourceOverlay;
  final Color lastMoveDestinationOverlay;
  final Color legalMoveDotColor;
  final Color legalMoveCaptureRingColor;
  final Color checkGlowColor;
  final Color hintSquareOverlay;
  final Color boardBorderColor;
  final double borderRadius;

  const ChessBoardTheme({
    required this.name,
    required this.lightSquare,
    required this.darkSquare,
    required this.coordinateLightSquare,
    required this.coordinateDarkSquare,
    this.selectedSquareOverlay = const Color(0x66F59E0B), // Warm amber overlay
    this.lastMoveSourceOverlay = const Color(0x4DCEDC00), // Distinct soft lime/yellow
    this.lastMoveDestinationOverlay = const Color(0x66CEDC00),
    this.legalMoveDotColor = const Color(0x6610B981),
    this.legalMoveCaptureRingColor = const Color(0x8810B981),
    this.checkGlowColor = const Color(0xCCEF4444),
    this.hintSquareOverlay = const Color(0x663B82F6),
    this.boardBorderColor = const Color(0xFF1E293B),
    this.borderRadius = 8.0,
  });

  /// Standard Tournament Green (Lichess/Chess.com classic standard)
  static const ChessBoardTheme tournamentGreen = ChessBoardTheme(
    name: 'Tournament Green',
    lightSquare: Color(0xFFEEEED2),
    darkSquare: Color(0xFF769656),
    coordinateLightSquare: Color(0xFF769656),
    coordinateDarkSquare: Color(0xFFEEEED2),
  );

  /// Classic Warm Walnut Wood
  static const ChessBoardTheme classicWood = ChessBoardTheme(
    name: 'Classic Wood',
    lightSquare: Color(0xFFF0D9B5),
    darkSquare: Color(0xFFB58863),
    coordinateLightSquare: Color(0xFFB58863),
    coordinateDarkSquare: Color(0xFFF0D9B5),
    boardBorderColor: Color(0xFF4A3525),
  );

  /// Sleek Slate Blue (Modern dark mode harmonious default)
  static const ChessBoardTheme slateBlue = ChessBoardTheme(
    name: 'Slate Blue',
    lightSquare: Color(0xFFDEE3E6),
    darkSquare: Color(0xFF8CA2AD),
    coordinateLightSquare: Color(0xFF8CA2AD),
    coordinateDarkSquare: Color(0xFFDEE3E6),
    boardBorderColor: Color(0xFF1E293B),
  );

  /// High Contrast Black & White (Accessibility certified)
  static const ChessBoardTheme highContrast = ChessBoardTheme(
    name: 'High Contrast',
    lightSquare: Color(0xFFFFFFFF),
    darkSquare: Color(0xFF262626),
    coordinateLightSquare: Color(0xFF000000),
    coordinateDarkSquare: Color(0xFFFFFFFF),
    selectedSquareOverlay: Color(0x88F59E0B),
    lastMoveSourceOverlay: Color(0x7700FFFF),
    lastMoveDestinationOverlay: Color(0x9900FFFF),
    legalMoveDotColor: Color(0xAA00FF00),
    legalMoveCaptureRingColor: Color(0xDD00FF00),
    boardBorderColor: Color(0xFF000000),
  );
}
