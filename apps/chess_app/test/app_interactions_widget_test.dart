import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:chess_app/main.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_app/src/screens/play_screen.dart';
import 'package:chess_app/src/screens/analysis_screen.dart';
import 'package:chess_app/src/screens/labs_screen.dart';

void main() {
  group('App Shell, Board Interactions & Navigation Widget Tests', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('app_interactions_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('ChessMasterApp navigates through all rail destinations and opens backup dialog', (tester) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(ChessMasterApp(repository: repo, engine: EmbeddedHeuristicEngine()));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      expect(find.byType(ChessMasterApp), findsOneWidget);
      expect(find.textContaining('DAY 1 / 90'), findsOneWidget);

      // Open Offline JSON Backup dialog
      final backupBtn = find.byTooltip('Export / Backup Offline Platform JSON');
      expect(backupBtn, findsOneWidget);
      await tester.tap(backupBtn);
      await tester.pumpAndSettle();

      expect(find.text('Offline JSON Backup'), findsOneWidget);
      final closeBtn = find.text('Close');
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();

      // Navigate through all Rail Destinations
      final rail = find.byType(NavigationRail);
      expect(rail, findsOneWidget);

      // 1. Curriculum
      await tester.tap(find.text('Curriculum'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Phase'), findsWidgets);

      // 2. Labs
      await tester.tap(find.text('Labs'));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // 3. Play / Tourney
      await tester.tap(find.text('Play / Tourney'));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(find.textContaining('SERIOUS GAME'), findsOneWidget);

      // 4. Analysis
      await tester.tap(find.text('Analysis'));
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      expect(find.textContaining('Active Engine:'), findsOneWidget);

      // 5. Model Games
      await tester.tap(find.text('Model Games'));
      await tester.pumpAndSettle();
      expect(find.textContaining('vs'), findsWidgets);

      // 6. Video Studio
      await tester.tap(find.text('Video Studio'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Video Studio'), findsWidgets);

      // 7. Mastery Report
      await tester.tap(find.text('Mastery Report'));
      await tester.pumpAndSettle();
      expect(find.textContaining('CHESSMASTER GM-STYLE MASTERY PROGRAM'), findsOneWidget);

      // Return to Daily Journey
      await tester.tap(find.text('Daily Journey'));
      await tester.pumpAndSettle();
      expect(find.textContaining('DAY 1 / 90'), findsOneWidget);
    });

    testWidgets('ChessBoardWidget square taps, legal dots, moves, flip, and promotion', (tester) async {
      final board = Board.initial();
      Move? playedMove;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChessBoardWidget(
              board: board,
              isFlipped: false,
              highlightedSquares: const [Square.e4, Square.e5],
              onMovePlayed: (m) => playedMove = m,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap e2 (white pawn) - Find Square e2 by Semantics
      final e2Finder = find.bySemanticsLabel('White pawn on e2');
      expect(e2Finder, findsOneWidget);
      await tester.tap(e2Finder);
      await tester.pumpAndSettle();

      // Tap e4 to play e2e4
      final e4Finder = find.bySemanticsLabel('Empty square e4');
      expect(e4Finder, findsOneWidget);
      await tester.tap(e4Finder);
      await tester.pumpAndSettle();

      expect(playedMove, isNotNull);
      expect(playedMove!.from, Square.e2);
      expect(playedMove!.to, Square.e4);

      // Test Pawn Promotion Dialog (White pawn on e7, empty e8 square, Black king on a8)
      final promoBoard = Board.fromFen('k7/4P3/8/8/8/8/8/4K3 w - - 0 1');
      Move? promoMove;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChessBoardWidget(
              board: promoBoard,
              onMovePlayed: (m) => promoMove = m,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final e7Finder = find.bySemanticsLabel('White pawn on e7');
      await tester.tap(e7Finder);
      await tester.pumpAndSettle();

      final e8Finder = find.bySemanticsLabel('Empty square e8');
      await tester.tap(e8Finder);
      await tester.pumpAndSettle();

      // Promotion dialog should open
      expect(find.text('Promote Pawn'), findsOneWidget);
      // Select Queen promotion (White Queen symbol ♕)
      await tester.tap(find.text('♕'));
      await tester.pumpAndSettle();

      expect(promoMove, isNotNull);
      expect(promoMove!.promotion, PieceType.queen);
    });

    testWidgets('PlayScreen buttons: flip board, reset/resign', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              engine: EmbeddedHeuristicEngine(),
              onNavigate: (_, {args}) {},
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Flip board
      final flipBtn = find.byTooltip('Flip Board');
      if (flipBtn.evaluate().isNotEmpty) {
        await tester.tap(flipBtn);
        await tester.pumpAndSettle();
      }

      // Resign button
      final resignBtn = find.byTooltip('Resign Game');
      if (resignBtn.evaluate().isNotEmpty) {
        await tester.tap(resignBtn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('AnalysisScreen enters thought notes and runs full engine audit', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnalysisScreen(
              repository: repo,
              engine: EmbeddedHeuristicEngine(),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Enter self analysis note
      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);
      await tester.enterText(textField, 'I considered castling or pushing d5.');
      await tester.pumpAndSettle();

      // Tap Run Engine Audit
      final auditBtn = find.text('Lock Self-Analysis & Run Engine Audit');
      expect(auditBtn, findsOneWidget);
      await tester.tap(auditBtn);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('LabsScreen triggers hint, declare no-tactic, and reset', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabsScreen(repository: repo),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Request Hint
      final hintBtn = find.textContaining('Hint');
      expect(hintBtn, findsOneWidget);
      await tester.tap(hintBtn);
      await tester.pumpAndSettle();

      // Declare No Tactic
      final noTacBtn = find.text('Declare "No Tactic"');
      expect(noTacBtn, findsOneWidget);
      await tester.tap(noTacBtn);
      await tester.pumpAndSettle();

      // Reset
      final resetBtn = find.text('Reset');
      expect(resetBtn, findsOneWidget);
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
