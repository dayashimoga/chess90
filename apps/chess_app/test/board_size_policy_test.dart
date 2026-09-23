import 'package:chess_app/src/theme/board_size_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoardSizePolicy Tests (P0 Gate)', () {
    test('Standard mode sizes deterministically and never overflows available bounds', () {
      // Desktop full screen 1920x1080
      const desktopConstraints = BoxConstraints(maxWidth: 1200, maxHeight: 800);
      final sizeDesktop = BoardSizePolicy.calculateBoardSize(
        constraints: desktopConstraints,
        mode: BoardSizeMode.standard,
      );
      expect(sizeDesktop, greaterThanOrEqualTo(450.0));
      expect(sizeDesktop, lessThanOrEqualTo(desktopConstraints.maxHeight));

      // Tablet 800x600
      const tabletConstraints = BoxConstraints(maxWidth: 500, maxHeight: 500);
      final sizeTablet = BoardSizePolicy.calculateBoardSize(
        constraints: tabletConstraints,
        mode: BoardSizeMode.standard,
      );
      expect(sizeTablet, lessThanOrEqualTo(500.0 - 32.0));
      expect(sizeTablet, greaterThanOrEqualTo(280.0));

      // Mobile narrow 360x640
      const mobileConstraints = BoxConstraints(maxWidth: 360, maxHeight: 400);
      final sizeMobile = BoardSizePolicy.calculateBoardSize(
        constraints: mobileConstraints,
        mode: BoardSizeMode.compact,
      );
      expect(sizeMobile, lessThanOrEqualTo(360.0 - 32.0));
    });

    test('Focus mode expands larger for tournament play', () {
      const constraints = BoxConstraints(maxWidth: 1000, maxHeight: 900);
      final standard = BoardSizePolicy.calculateBoardSize(
        constraints: constraints,
        mode: BoardSizeMode.standard,
      );
      final focus = BoardSizePolicy.calculateBoardSize(
        constraints: constraints,
        mode: BoardSizeMode.focus,
      );
      expect(focus, greaterThanOrEqualTo(standard));
    });

    test('Account for evaluation bar width without clipping', () {
      const constraints = BoxConstraints(maxWidth: 600, maxHeight: 600);
      final withoutEval = BoardSizePolicy.calculateBoardSize(
        constraints: constraints,
        hasEvaluationBar: false,
      );
      final withEval = BoardSizePolicy.calculateBoardSize(
        constraints: constraints,
        hasEvaluationBar: true,
        evalBarWidth: 36.0,
      );
      expect(withEval, lessThanOrEqualTo(withoutEval));
    });
  });
}
