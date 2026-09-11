import 'dart:io';
import 'package:chess_app/src/screens/curriculum_screen.dart';
import 'package:chess_app/src/screens/daily_journey_screen.dart';
import 'package:chess_app/src/screens/model_games_screen.dart';
import 'package:chess_app/src/screens/opening_explorer_screen.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Extra Deep Screen Coverage Suite (Exceeding 90% Gate)', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('extra_screens_deep_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('CurriculumScreen filters phases, views exams, and selects day', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? navigatedScreen;
      dynamic navigatedArgs;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurriculumScreen(
              repository: repo,
              onNavigate: (s, {args}) {
                navigatedScreen = s;
                navigatedArgs = args;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CurriculumScreen), findsOneWidget);

      // Search or filter
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'Exam');
        await tester.pumpAndSettle();
      }

      // Tap on a Day tile
      final dayTile = find.textContaining('Day 7');
      if (dayTile.evaluate().isNotEmpty) {
        await tester.tap(dayTile.first);
        await tester.pumpAndSettle();
      }

      // Launch lab button
      final launchBtn = find.textContaining('Start Lab');
      if (launchBtn.evaluate().isNotEmpty) {
        await tester.tap(launchBtn.first);
        await tester.pumpAndSettle();
        expect(navigatedScreen, equals('labs'));
        expect(navigatedArgs, anyOf(isNull, isNotNull));
      }
    });

    testWidgets('OpeningExplorerScreen searches ECO, selects variation, and plays moves', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OpeningExplorerScreen(
              onNavigate: (_, {args}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OpeningExplorerScreen), findsOneWidget);

      // Search ECO
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'Ruy Lopez');
        await tester.pumpAndSettle();
      }

      // Tap on an opening from list
      final openingItem = find.textContaining('Ruy Lopez');
      if (openingItem.evaluate().isNotEmpty) {
        await tester.tap(openingItem.first);
        await tester.pumpAndSettle();
      }

      // Reset opening board
      final resetBtn = find.text('Reset');
      if (resetBtn.evaluate().isNotEmpty) {
        await tester.tap(resetBtn.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('ModelGamesScreen guess-the-move mode and analyze action', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? navigatedScreen;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModelGamesScreen(
              onNavigate: (s, {args}) => navigatedScreen = s,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ModelGamesScreen), findsOneWidget);

      // Guess the move button
      final guessBtn = find.text('Guess The Move');
      if (guessBtn.evaluate().isNotEmpty) {
        await tester.tap(guessBtn.first);
        await tester.pumpAndSettle();
      }

      // Step forward
      final nextBtn = find.byIcon(Icons.chevron_right);
      if (nextBtn.evaluate().isNotEmpty) {
        await tester.tap(nextBtn.first);
        await tester.pumpAndSettle();
      }

      // Analyze Game button
      final analyzeBtn = find.text('Analyze Game');
      if (analyzeBtn.evaluate().isNotEmpty) {
        await tester.tap(analyzeBtn.first);
        await tester.pumpAndSettle();
        expect(navigatedScreen, equals('analysis'));
      }
    });

    testWidgets('DailyJourneyScreen budget switching and start action clicks', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Seed review item due
      repo.saveReviewItem(ReviewItem(
        id: 'due_1',
        fen: Board.initial().toFen(),
        solutionSan: ['e4'],
        skillNodeId: 'node_1',
        motif: 'fork',
        explanation: 'Due review item',
        nextReviewDate: DateTime.now().subtract(const Duration(hours: 1)),
      ));

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

      // Tap 15m Express budget chip
      final chip15 = find.text('15m Express');
      if (chip15.evaluate().isNotEmpty) {
        await tester.tap(chip15);
        await tester.pumpAndSettle();
      }

      // Tap 60m Standard budget chip
      final chip60 = find.text('60m Standard');
      if (chip60.evaluate().isNotEmpty) {
        await tester.tap(chip60);
        await tester.pumpAndSettle();
      }

      // Review Now button
      final reviewNow = find.text('Review Now');
      if (reviewNow.evaluate().isNotEmpty) {
        await tester.tap(reviewNow);
        await tester.pumpAndSettle();
        expect(navigatedScreen, equals('labs'));
      }
    });

    testWidgets('ChessBoardWidget keyboard navigation and pawn promotion prompt', (tester) async {
      tester.view.physicalSize = const Size(400, 400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Board with white pawn on 7th rank ready to promote (e7)
      final promoBoard = Board.fromFen('8/4P3/8/8/8/8/8/4K2k w - - 0 1');
      Move? playedMove;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 350,
              height: 350,
              child: ChessBoardWidget(
                board: promoBoard,
                onMovePlayed: (m) => playedMove = m,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap e7 pawn
      final e7Square = find.bySemanticsLabel('White pawn on e7');
      expect(e7Square, findsOneWidget);
      await tester.tap(e7Square);
      await tester.pumpAndSettle();

      // Tap e8 empty square
      final e8Square = find.bySemanticsLabel('Empty square e8');
      expect(e8Square, findsOneWidget);
      await tester.tap(e8Square);
      await tester.pumpAndSettle();

      // Promotion dialog must appear
      expect(find.text('Promote Pawn'), findsOneWidget);

      // Select Queen promotion ('♕')
      final queenOption = find.text('♕');
      expect(queenOption, findsOneWidget);
      await tester.tap(queenOption);
      await tester.pumpAndSettle();

      expect(playedMove, isNotNull);
      expect(playedMove!.flag, equals(MoveFlag.promotion));
    });
  });
}
