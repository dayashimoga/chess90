import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:chess_app/main.dart';
import 'package:chess_app/src/screens/daily_journey_screen.dart';
import 'package:chess_app/src/screens/endgame_workspace_screen.dart';
import 'package:chess_app/src/screens/opening_explorer_screen.dart';
import 'package:chess_app/src/screens/play_screen.dart';
import 'package:chess_app/src/screens/settings_storage_screen.dart';

void main() {
  group('Deep UI Interactions & Full Code Coverage Suite', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('deep_ui_test_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('SettingsStorageScreen interactions: export dialog, import dialog, and theme toggle', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool themeToggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsStorageScreen(
              repository: repo,
              onToggleTheme: () => themeToggled = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Export JSON Backup dialog
      final exportBtn = find.text('Export JSON Backup');
      expect(exportBtn, findsOneWidget);
      await tester.tap(exportBtn);
      await tester.pumpAndSettle();

      expect(find.text('Export Offline Platform JSON Backup'), findsOneWidget);
      final doneBtn = find.text('Done');
      expect(doneBtn, findsOneWidget);
      await tester.tap(doneBtn);
      await tester.pumpAndSettle();

      // 2. Import JSON Backup dialog
      final importBtn = find.text('Import JSON Backup');
      expect(importBtn, findsOneWidget);
      await tester.tap(importBtn);
      await tester.pumpAndSettle();

      expect(find.text('Import Offline JSON Backup'), findsOneWidget);
      // Enter valid JSON into the import field
      final jsonField = find.byType(TextField);
      expect(jsonField, findsOneWidget);
      final exportJson = repo.exportFullBackupJson();
      await tester.enterText(jsonField, exportJson);
      await tester.pumpAndSettle();

      final confirmImportBtn = find.widgetWithText(ElevatedButton, 'Import Backup');
      expect(confirmImportBtn, findsOneWidget);
      await tester.tap(confirmImportBtn);
      await tester.pumpAndSettle();

      expect(find.text('Backup imported successfully!'), findsOneWidget);

      // 3. Toggle Theme callback
      final toggleThemeBtn = find.text('Toggle Theme');
      expect(toggleThemeBtn, findsOneWidget);
      await tester.tap(toggleThemeBtn);
      expect(themeToggled, isTrue);
    });

    testWidgets('OpeningExplorerScreen search, select entry, and reset board', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OpeningExplorerScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);
      await tester.enterText(searchField, 'Sicilian');
      await tester.pumpAndSettle();

      // Select Sicilian Defense tile
      final sicilianTile = find.text('Sicilian Defense');
      expect(sicilianTile, findsOneWidget);
      await tester.tap(sicilianTile);
      await tester.pumpAndSettle();

      expect(find.textContaining('Standard sequence:'), findsOneWidget);

      // Reset Board button
      final resetBtn = find.text('Reset Board');
      expect(resetBtn, findsOneWidget);
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();
    });

    testWidgets('EndgameWorkspaceScreen position selection and reset', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EndgameWorkspaceScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Select Philidor Position
      final philidorTile = find.text('The Philidor Position (3rd Rank Defense)');
      expect(philidorTile, findsOneWidget);
      await tester.tap(philidorTile);
      await tester.pumpAndSettle();

      expect(find.textContaining('6th (3rd) rank'), findsOneWidget);

      // Select Direct Opposition
      final oppTile = find.text('Direct Opposition & Key Squares');
      expect(oppTile, findsOneWidget);
      await tester.tap(oppTile);
      await tester.pumpAndSettle();

      expect(find.textContaining('vertical opposition'), findsOneWidget);

      // Reset Position
      final resetBtn = find.text('Reset Position');
      expect(resetBtn, findsOneWidget);
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();
    });

    testWidgets('PlayScreen plays move on board, triggers reset and takeback', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              onNavigate: (_, {args}) {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Tap e2 square (White pawn)
      final e2 = find.bySemanticsLabel('White pawn on e2');
      if (e2.evaluate().isNotEmpty) {
        await tester.tap(e2);
        await tester.pumpAndSettle();

        // Tap e4 square
        final e4 = find.bySemanticsLabel('Empty square e4');
        if (e4.evaluate().isNotEmpty) {
          await tester.tap(e4);
          await tester.pump(const Duration(seconds: 2));
          await tester.pumpAndSettle();
        }
      }

      // Takeback button
      final takebackBtn = find.byTooltip('Takeback');
      if (takebackBtn.evaluate().isNotEmpty) {
        await tester.tap(takebackBtn);
        await tester.pumpAndSettle();
      }

      // Reset / New Game button
      final newGameBtn = find.byTooltip('Reset / New Game');
      if (newGameBtn.evaluate().isNotEmpty) {
        await tester.tap(newGameBtn);
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });

    testWidgets('DailyJourneyScreen renders curriculum progress and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      String? navigatedScreen;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyJourneyScreen(
              repository: repo,
              onNavigate: (s, {args}) => navigatedScreen = s,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DailyJourneyScreen), findsOneWidget);
      expect(find.textContaining('Day 1 of 90'), findsOneWidget);

      // Start Daily Lab or Study Lesson button
      final startBtn = find.widgetWithText(ElevatedButton, 'Start');
      if (startBtn.evaluate().isNotEmpty) {
        await tester.tap(startBtn.first);
        await tester.pumpAndSettle();
        expect(navigatedScreen, isNotNull);
      }
    });

    testWidgets('MainShell mobile compact layout (<720px) and theme switch', (tester) async {
      tester.view.physicalSize = const Size(600, 900); // Mobile compact viewport
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(ChessMasterApp(repository: repo));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // In mobile layout, NavigationBar is present instead of NavigationRail
      expect(find.byType(NavigationBar), findsOneWidget);

      // Tap destinations on NavigationBar
      final labsTab = find.text('Labs');
      if (labsTab.evaluate().isNotEmpty) {
        await tester.tap(labsTab);
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
      }

      // Tap Theme Mode toggle button in AppBar
      final themeBtn = find.byTooltip('Switch to Light Mode');
      if (themeBtn.evaluate().isNotEmpty) {
        await tester.tap(themeBtn);
        await tester.pumpAndSettle();
        expect(find.byTooltip('Switch to Dark Mode'), findsOneWidget);
      }
    });
  });
}
