import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_app/src/screens/certification_screen.dart';

void main() {
  group('Accessibility and Responsive Viewport Tests', () {
    late Directory tempDir;
    late String dbFilePath;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('accessibility_test_');
      dbFilePath = '${tempDir.path}${Platform.pathSeparator}test.db';
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    final viewports = <String, Size>{
      'Small Phone (360x640)': const Size(360, 640),
      'Tablet (768x1024)': const Size(768, 1024),
      'Laptop (1366x768)': const Size(1366, 768),
      'Full HD Desktop (1920x1080)': const Size(1920, 1080),
    };

    for (final entry in viewports.entries) {
      final name = entry.key;
      final size = entry.value;

      testWidgets('Responsive rendering without overflow on $name', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final board = Board.initial();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: size.width < size.height ? size.width : size.height * 0.8,
                  height: size.width < size.height ? size.width : size.height * 0.8,
                  child: ChessBoardWidget(
                    board: board,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull, reason: 'No render overflow allowed on $name');
      });
    }

    testWidgets('Chess board accessibility semantics test', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      final board = Board.initial();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 400,
                child: ChessBoardWidget(board: board),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify semantics annotations exist for chess pieces and empty squares
      expect(
        find.bySemanticsLabel('White pawn on e2'),
        findsOneWidget,
        reason: 'Initial board must have White pawn on e2 with accessibility label',
      );
      expect(
        find.bySemanticsLabel('Empty square e4'),
        findsOneWidget,
        reason: 'Empty square e4 must have accessibility label',
      );
      expect(
        find.bySemanticsLabel('Black king on e8'),
        findsOneWidget,
        reason: 'Black king on e8 must have accessibility label',
      );

      handle.dispose();
    });

    testWidgets('Mastery Assessment screen renders cleanly across viewports without overflow', (tester) async {
      final repo = StorageRepository(dbPath: dbFilePath);

      for (final size in [const Size(360, 640), const Size(1366, 768)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MaterialApp(
            home: CertificationScreen(repository: repo),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.textContaining('MASTERY ASSESSMENT'), findsWidgets);
      }
    });
  });
}
