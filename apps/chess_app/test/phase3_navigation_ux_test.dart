import 'dart:io';
import 'package:chess_app/main.dart';
import 'package:chess_app/src/screens/analysis_screen.dart';
import 'package:chess_app/src/screens/certification_screen.dart';
import 'package:chess_app/src/screens/curriculum_screen.dart';
import 'package:chess_app/src/screens/daily_journey_screen.dart';
import 'package:chess_app/src/screens/endgame_workspace_screen.dart';
import 'package:chess_app/src/screens/labs_screen.dart';
import 'package:chess_app/src/screens/model_games_screen.dart';
import 'package:chess_app/src/screens/opening_explorer_screen.dart';
import 'package:chess_app/src/screens/play_screen.dart';
import 'package:chess_app/src/screens/settings_storage_screen.dart';
import 'package:chess_app/src/screens/video_studio_screen.dart';
import 'package:chess_app/src/screens/weakness_analytics_screen.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 3 Navigation Consolidation & UX Test Suite', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('phase3_test_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('Desktop NavigationRail renders 8 consolidated destinations and navigates', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ChessMasterApp(
          repository: repo,
          engine: EmbeddedHeuristicEngine(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(DailyJourneyScreen), findsOneWidget);

      // Verify destinations in NavigationRail
      expect(find.text('Daily Journey'), findsOneWidget);
      expect(find.text('Curriculum'), findsOneWidget);
      expect(find.text('Labs'), findsOneWidget);
      expect(find.text('Play / Tourney'), findsOneWidget);
      expect(find.text('Analysis'), findsOneWidget);
      expect(find.text('Video Studio'), findsOneWidget);
      expect(find.text('Mastery Report'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Navigate to Curriculum
      await tester.tap(find.text('Curriculum'));
      await tester.pumpAndSettle();
      expect(find.byType(CurriculumScreen), findsOneWidget);

      // Navigate to Labs
      await tester.tap(find.text('Labs'));
      await tester.pumpAndSettle();
      expect(find.byType(LabsScreen), findsOneWidget);

      // Navigate to Play / Tourney
      await tester.tap(find.text('Play / Tourney'));
      await tester.pumpAndSettle();
      expect(find.byType(PlayScreen), findsOneWidget);

      // Navigate to Analysis (Study Hub)
      await tester.tap(find.text('Analysis'));
      await tester.pumpAndSettle();
      expect(find.byType(AnalysisScreen), findsOneWidget);

      // Verify Study Hub Sub-Tabs
      expect(find.text('Openings'), findsOneWidget);
      expect(find.text('Endgame'), findsOneWidget);
      expect(find.text('Model Games'), findsOneWidget);

      // Switch to Openings sub-tab
      await tester.tap(find.text('Openings'));
      await tester.pumpAndSettle();
      expect(find.byType(OpeningExplorerScreen), findsOneWidget);

      // Switch to Endgame sub-tab
      await tester.tap(find.text('Endgame'));
      await tester.pumpAndSettle();
      expect(find.byType(EndgameWorkspaceScreen), findsOneWidget);

      // Switch to Model Games sub-tab
      await tester.tap(find.text('Model Games'));
      await tester.pumpAndSettle();
      expect(find.byType(ModelGamesScreen), findsOneWidget);

      // Switch back to Analysis sub-tab
      await tester.tap(find.widgetWithText(InkWell, 'Analysis'));
      await tester.pumpAndSettle();
      expect(find.byType(AnalysisScreen), findsOneWidget);

      // Navigate to Video Studio
      await tester.tap(find.text('Video Studio'));
      await tester.pumpAndSettle();
      expect(find.byType(VideoStudioScreen), findsOneWidget);

      // Navigate to Mastery Report (Analytics Hub)
      await tester.tap(find.text('Mastery Report'));
      await tester.pumpAndSettle();
      expect(find.byType(CertificationScreen), findsOneWidget);

      // Verify Analytics Hub Sub-Tabs
      expect(find.text('Weakness Radar'), findsOneWidget);

      // Switch to Weakness Radar
      await tester.tap(find.text('Weakness Radar'));
      await tester.pumpAndSettle();
      expect(find.byType(WeaknessAnalyticsScreen), findsOneWidget);

      // Switch back to Mastery Report
      await tester.tap(find.widgetWithText(InkWell, 'Mastery Report'));
      await tester.pumpAndSettle();
      expect(find.byType(CertificationScreen), findsOneWidget);

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsStorageScreen), findsOneWidget);
    });

    testWidgets('Mobile BottomBar and More Sheet opens deep tools', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ChessMasterApp(
          repository: repo,
          engine: EmbeddedHeuristicEngine(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('More'), findsOneWidget);

      // Tap More button
      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();

      // Verify More modal sheet content
      expect(find.text('All Learning & Analysis Hubs'), findsOneWidget);
      expect(find.text('Video Studio'), findsOneWidget);
      expect(find.text('Mastery Report & Certification'), findsOneWidget);
      expect(find.text('Weakness Radar'), findsOneWidget);
      expect(find.text('Opening Explorer'), findsOneWidget);
      expect(find.text('Endgame Workspace'), findsOneWidget);
      expect(find.text('Model Games'), findsOneWidget);
      expect(find.text('Settings & Storage'), findsOneWidget);

      // Tap Weakness Radar from sheet
      await tester.tap(find.text('Weakness Radar'));
      await tester.pumpAndSettle();

      expect(find.byType(WeaknessAnalyticsScreen), findsOneWidget);
    });

    testWidgets('DailyJourneyScreen displays unfinished game banner and discards it', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      repo.saveUnfinishedGame(UnfinishedGame(
        id: 'active_session_123',
        currentFen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        moveSanList: const ['e4'],
        timeControl: 'Classical 45+15',
        whiteRemainingSeconds: 2700,
        blackRemainingSeconds: 2695,
        startedAt: DateTime.now(),
        lastMoveAt: DateTime.now(),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyJourneyScreen(
              repository: repo,
              onNavigate: (_, {args}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Match in Progress (CLASSICAL 45+15)'), findsOneWidget);
      expect(find.text('Resume Game'), findsOneWidget);
      expect(find.text('Discard'), findsOneWidget);

      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Match in Progress'), findsNothing);
      expect(repo.getUnfinishedGame(), isNull);
    });

    testWidgets('DailyJourneyScreen resumes unfinished game via onNavigate', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      repo.saveUnfinishedGame(UnfinishedGame(
        id: 'active_session_456',
        currentFen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        moveSanList: const ['e4'],
        timeControl: 'Rapid 15+10',
        whiteRemainingSeconds: 900,
        blackRemainingSeconds: 900,
        startedAt: DateTime.now(),
        lastMoveAt: DateTime.now(),
      ));

      String? navigatedTo;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DailyJourneyScreen(
              repository: repo,
              onNavigate: (key, {args}) {
                navigatedTo = key;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Resume Game'), findsOneWidget);
      await tester.tap(find.text('Resume Game'));
      await tester.pumpAndSettle();

      expect(navigatedTo, 'play');
    });

    testWidgets('PlayScreen instant O(1) takeback reverts plies and unmake moves cleanly', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              onNavigate: (_, {args}) {},
              initialArgs: const {'isVsEngine': false, 'isRated': false},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

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

      expect(find.text('e4'), findsOneWidget);

      // Perform Takeback directly in practice mode
      final takebackButton = find.byTooltip('Takeback');
      expect(takebackButton, findsOneWidget);
      await tester.tap(takebackButton);
      await tester.pumpAndSettle();

      // 'e4' should no longer be in the move list
      expect(find.text('e4'), findsNothing);
      // White pawn should be back on e2
      expect(find.bySemanticsLabel('White pawn on e2'), findsOneWidget);
    });
  });
}
