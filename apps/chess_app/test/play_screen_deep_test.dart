import 'dart:io';
import 'package:chess_app/src/screens/play_screen.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayScreen Deep Interactive Testing Suite', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('play_screen_deep_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('PlayScreen initializes in Rapid mode and plays user move', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              onNavigate: (_, {args}) {},
              engine: EmbeddedHeuristicEngine(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PlayScreen), findsOneWidget);
      expect(find.byType(ChessBoardWidget), findsOneWidget);
      expect(find.text('15:00'), findsWidgets);

      // Play 1. e4: tap e2, then tap e4
      final e2Square = find.bySemanticsLabel('White pawn on e2');
      expect(e2Square, findsOneWidget);
      await tester.tap(e2Square);
      await tester.pumpAndSettle();

      final e4Square = find.bySemanticsLabel('Empty square e4');
      expect(e4Square, findsOneWidget);
      await tester.tap(e4Square);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Check move recorded
      expect(find.text('e4'), findsOneWidget);
    });

    testWidgets('PlayScreen tournament mode initialization with 45+15 clocks', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              onNavigate: (_, {args}) {},
              initialArgs: const {'isTournament': true},
              engine: EmbeddedHeuristicEngine(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('45:00'), findsWidgets);
    });

    testWidgets('PlayScreen detects and resumes unfinished game banner', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Seed an unfinished game
      repo.saveUnfinishedGame(UnfinishedGame(
        id: 'active_game',
        currentFen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2',
        moveSanList: ['e4', 'e5'],
        timeControl: 'Rapid 15+10',
        whiteRemainingSeconds: 890,
        blackRemainingSeconds: 885,
        isVsEngine: true,
        isTournamentMode: false,
        startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        lastMoveAt: DateTime.now(),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              onNavigate: (_, {args}) {},
              engine: EmbeddedHeuristicEngine(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Unfinished game banner must be visible
      expect(find.textContaining('Unfinished game detected'), findsOneWidget);
      expect(find.text('Resume Game'), findsOneWidget);
      expect(find.text('Discard'), findsOneWidget);

      // Tap Resume Game
      await tester.tap(find.text('Resume Game'));
      await tester.pumpAndSettle();

      // Banner should disappear after resume
      expect(find.textContaining('Unfinished game detected'), findsNothing);
    });

    testWidgets('PlayScreen detects and discards unfinished game banner', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Seed an unfinished game
      repo.saveUnfinishedGame(UnfinishedGame(
        id: 'active_game',
        currentFen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2',
        moveSanList: ['e4', 'e5'],
        timeControl: 'Rapid 15+10',
        whiteRemainingSeconds: 890,
        blackRemainingSeconds: 885,
        isVsEngine: true,
        isTournamentMode: false,
        startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        lastMoveAt: DateTime.now(),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              onNavigate: (_, {args}) {},
              engine: EmbeddedHeuristicEngine(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Discard'), findsOneWidget);
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Unfinished game detected'), findsNothing);
      expect(repo.getUnfinishedGame(), isNull);
    });
  });
}
