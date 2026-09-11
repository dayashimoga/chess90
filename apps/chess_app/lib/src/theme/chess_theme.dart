import 'package:flutter/material.dart';

/// Luxury dark theme design system for ChessMaster.
class ChessTheme {
  // Color palette
  static const Color background = Color(0xFF0B0F19);
  static const Color surface = Color(0xFF151D2E);
  static const Color surfaceLight = Color(0xFF1F293D);
  static const Color border = Color(0xFF2E3A52);

  static const Color primary = Color(0xFF10B981); // Emerald
  static const Color primaryLight = Color(0xFF34D399);
  static const Color secondary = Color(0xFF3B82F6); // Royal Blue
  static const Color accentGold = Color(0xFFF59E0B); // Amber / Master Gold

  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Chess board colors (Tournament Olive/Cream)
  static const Color boardDark = Color(0xFF739552);
  static const Color boardLight = Color(0xFFEBECD0);
  static const Color boardHighlight = Color(0x88F6E05E);
  static const Color legalMoveDot = Color(0xAA10B981);
  static const Color checkGlow = Color(0xCCEF4444);

  // Move Quality Colors
  static const Color qualityBrilliant = Color(0xFF06B6D4);
  static const Color qualityBest = Color(0xFF10B981);
  static const Color qualityGreat = Color(0xFF3B82F6);
  static const Color qualityGood = Color(0xFF6B7280);
  static const Color qualityInaccuracy = Color(0xFFFBBF24);
  static const Color qualityMistake = Color(0xFFF97316);
  static const Color qualityBlunder = Color(0xFFEF4444);
  static const Color qualityMissedWin = Color(0xFFEC4899);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: qualityBlunder,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: border, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: border,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, letterSpacing: -0.3),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 15),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 13),
        labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, letterSpacing: 0.2),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Light Theme Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLightCard = Color(0xFFFFFFFF);
  static const Color borderLightGray = Color(0xFFE2E8F0);
  static const Color textPrimaryDark = Color(0xFF0F172A);
  static const Color textSecondaryDark = Color(0xFF475569);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: surfaceLightCard,
        error: qualityBlunder,
      ),
      cardTheme: CardThemeData(
        color: surfaceLightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: borderLightGray, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderLightGray,
        thickness: 1,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        headlineMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold, letterSpacing: -0.3),
        titleLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimaryDark, fontSize: 15),
        bodyMedium: TextStyle(color: textSecondaryDark, fontSize: 13),
        labelLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600, letterSpacing: 0.2),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceLightCard,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(color: textPrimaryDark, fontSize: 18, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: textPrimaryDark),
      ),
    );
  }
}
