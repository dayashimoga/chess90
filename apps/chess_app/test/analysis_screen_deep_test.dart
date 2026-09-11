import 'dart:io';
import 'package:chess_app/src/screens/analysis_screen.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalysisScreen Deep Interactive Testing Suite', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('analysis_screen_deep_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('AnalysisScreen loads game, navigates plies, enters note, and locks for audit', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const pgn = '''[Event "Test Match"]
[Site "ChessMaster"]
[Date "2026.09.10"]
[Round "1"]
[White "Player"]
[Black "Opponent"]
[Result "1-0"]

1. e4 e5 2. Bc4 Nc6 3. Qh5 Nf6 4. Qxf7# 1-0
''';

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

      expect(find.byType(AnalysisScreen), findsOneWidget);
      expect(find.byType(ChessBoardWidget), findsOneWidget);

      // Step forward: tap next move icon (Icons.chevron_right)
      final nextBtn = find.byIcon(Icons.chevron_right);
      expect(nextBtn, findsOneWidget);
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();

      // Step to last page (Icons.last_page)
      final lastPageBtn = find.byIcon(Icons.last_page);
      if (lastPageBtn.evaluate().isNotEmpty) {
        await tester.tap(lastPageBtn);
        await tester.pumpAndSettle();
      }

      // Step to first page (Icons.first_page)
      final firstPageBtn = find.byIcon(Icons.first_page);
      if (firstPageBtn.evaluate().isNotEmpty) {
        await tester.tap(firstPageBtn);
        await tester.pumpAndSettle();
      }

      // Enter self-analysis note
      final noteField = find.byType(TextField);
      if (noteField.evaluate().isNotEmpty) {
        await tester.enterText(noteField.first, 'Stake claim in the center with 1.e4.');
        await tester.pumpAndSettle();
      }

      // Lock self-analysis and run engine audit
      final auditBtn = find.text('Lock Self-Analysis & Run Engine Audit');
      expect(auditBtn, findsOneWidget);
      await tester.tap(auditBtn);

      // Pump through async engine evaluation
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
