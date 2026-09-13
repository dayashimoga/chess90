import 'dart:io';
import 'package:chess_app/src/screens/labs_screen.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
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
      final hintBtn = find.textContaining('Hint');
      expect(hintBtn, findsOneWidget);
      await tester.tap(hintBtn);
      await tester.pumpAndSettle();

      // Contextual "No Tactic" (only present on genuine no-tactic exercises)
      final noTacBtn = find.text('Declare "No Tactic"');
      if (noTacBtn.evaluate().isNotEmpty) {
        await tester.tap(noTacBtn);
        await tester.pumpAndSettle();
      }

      // Learning Controls: Show Move & Show Line
      final showMoveBtn = find.text('Show Move');
      expect(showMoveBtn, findsOneWidget);
      await tester.tap(showMoveBtn);
      await tester.pumpAndSettle();

      // Reset Exercise
      final resetBtn = find.text('Reset');
      expect(resetBtn, findsOneWidget);
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();

      // Next Exercise button
      final nextBtn = find.text('Next Exercise');
      if (nextBtn.evaluate().isNotEmpty) {
        await tester.tap(nextBtn.first);
        await tester.pumpAndSettle();
      }

      // Previous Exercise button
      final prevBtn = find.text('Previous');
      if (prevBtn.evaluate().isNotEmpty) {
        await tester.tap(prevBtn.first);
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('LabsScreen supports switching categories and sprint lengths', (tester) async {
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

      // Find Category Dropdown
      final categoryDropdown = find.byWidgetPredicate(
        (w) => w is DropdownButton<LabCategory>,
      );
      expect(categoryDropdown, findsOneWidget);

      // Switch category to Tactics Bank
      await tester.tap(categoryDropdown);
      await tester.pumpAndSettle();

      final tacticsItem = find.text('Tactics Bank').last;
      await tester.tap(tacticsItem);
      await tester.pumpAndSettle();

      expect(find.textContaining('10 Puzzles'), findsOneWidget);

      // Switch sprint length
      final sprintLengthDropdown = find.byWidgetPredicate(
        (w) => w is DropdownButton<SprintLength>,
      );
      expect(sprintLengthDropdown, findsOneWidget);

      await tester.tap(sprintLengthDropdown);
      await tester.pumpAndSettle();

      final fivePuzzles = find.text('5 Puzzles').last;
      await tester.tap(fivePuzzles);
      await tester.pumpAndSettle();

      // Verify sprint length updated to 5
      expect(find.text('Exercise 1 of 5'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('LabsScreen parses labType and exerciseId from initialArgs', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabsScreen(
              repository: repo,
              initialArgs: const {'labType': 'endgame_win_defend'},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Endgame Mastery'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('LabsScreen handles move solving, auto-reply, and completion', (tester) async {
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

      final day1 = CurriculumCatalog.getDay(1);
      final ex1 = day1.exercises.first;
      final boardWidget = tester.widget<ChessBoardWidget>(find.byType(ChessBoardWidget));

      // Play the correct move
      final solutionSan = ex1.solutionSan.first;
      final move = MoveGenerator.sanToMove(boardWidget.board, solutionSan);
      expect(move, isNotNull);

      boardWidget.onMovePlayed?.call(move!);
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();

      // Verify exercise completed feedback appears
      expect(find.textContaining('Master Solution:'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('LabsScreen compact layout renders smoothly without overflow', (tester) async {
      tester.view.physicalSize = const Size(420, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabsScreen(
              repository: repo,
              initialArgs: const {'dayNumber': 2},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LabsScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
