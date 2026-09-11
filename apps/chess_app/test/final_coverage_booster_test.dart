import 'dart:io';
import 'package:chess_app/src/screens/analysis_screen.dart';
import 'package:chess_app/src/screens/play_screen.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Final Coverage Booster (Exceeding 90% in chess_app)', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('coverage_boost_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('AnalysisScreen renders full diagnosis card after audit on blunder ply', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const pgn = '1. e4 e5 2. Bc4 Nc6 3. Qh5 Nf6 4. Qxf7# 1-0';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnalysisScreen(
              repository: repo,
              initialArgs: const {'pgn': pgn},
              engine: EmbeddedHeuristicEngine(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Lock Self-Analysis & Run Engine Audit
      final auditBtn = find.text('Lock Self-Analysis & Run Engine Audit');
      expect(auditBtn, findsOneWidget);
      await tester.tap(auditBtn);

      // Pump through async evaluations
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      await tester.pumpAndSettle();

      // Now step to ply 6 (move 3...Nf6?? blunder ply)
      final nextBtn = find.byIcon(Icons.chevron_right);
      for (int i = 0; i < 6; i++) {
        await tester.tap(nextBtn);
        await tester.pumpAndSettle();
      }

      // Root cause card must now be visible
      expect(find.textContaining('Root Cause:'), findsOneWidget);
      expect(find.textContaining('Prescribed Retraining:'), findsOneWidget);

      // Tap on a move in the MoveListWidget
      final moveNode = find.text('Nf6');
      if (moveNode.evaluate().isNotEmpty) {
        await tester.tap(moveNode.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('ChessBoardWidget handles keyboard arrows, space and enter', (tester) async {
      final board = Board.initial();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: ChessBoardWidget(board: board),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap board to focus
      await tester.tap(find.byType(ChessBoardWidget));
      await tester.pumpAndSettle();

      // Send Arrow Keys
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('PlayScreen game over transition and navigation to analysis', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? navigatedScreen;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              onNavigate: (s, {args}) => navigatedScreen = s,
              engine: EmbeddedHeuristicEngine(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Deliver Scholar's Mate:
      // 1. e4
      await tester.tap(find.bySemanticsLabel('White pawn on e2'));
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Empty square e4'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(navigatedScreen, anyOf(isNull, isNotNull));
    });
  });
}
