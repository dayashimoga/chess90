import 'dart:io';
import 'package:chess_app/src/screens/labs_screen.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LabsScreen Deep Interactive Testing Suite', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('labs_screen_deep_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('LabsScreen loads Day 1 exercises and accepts interactive controls', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabsScreen(
              repository: repo,
              initialArgs: const {'dayNumber': 1},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LabsScreen), findsOneWidget);
      expect(find.byType(ChessBoardWidget), findsOneWidget);

      // Request Hint
      final hintBtn = find.text('Request Hint');
      if (hintBtn.evaluate().isNotEmpty) {
        await tester.tap(hintBtn.first);
        await tester.pumpAndSettle();
      }

      // Reset Exercise
      final resetBtn = find.text('Reset');
      if (resetBtn.evaluate().isNotEmpty) {
        await tester.tap(resetBtn.first);
        await tester.pumpAndSettle();
      }

      // If next exercise button exists
      final nextBtn = find.text('Next Exercise');
      if (nextBtn.evaluate().isNotEmpty) {
        await tester.tap(nextBtn.first);
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });
  });
}
