import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:chess_app/src/screens/analysis_screen.dart';
import 'package:chess_app/src/screens/play_screen.dart';
import 'package:chess_app/src/screens/curriculum_screen.dart';
import 'package:chess_app/src/screens/labs_screen.dart';
import 'package:chess_app/src/screens/model_games_screen.dart';
import 'package:chess_app/src/screens/video_studio_screen.dart';
import 'package:chess_app/src/screens/opening_explorer_screen.dart';
import 'package:chess_app/src/screens/endgame_workspace_screen.dart';
import 'package:chess_app/src/screens/weakness_analytics_screen.dart';
import 'package:chess_app/src/screens/settings_storage_screen.dart';
import 'package:chess_app/src/widgets/board/move_list_widget.dart';

void main() {
  group('Comprehensive All-Screens UI Widget Suite', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('screens_test_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    testWidgets('AnalysisScreen pumps, renders controls, and accepts notes', (tester) async {
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

      expect(tester.takeException(), isNull);
      expect(find.byType(AnalysisScreen), findsOneWidget);
      expect(find.textContaining('Active Engine:'), findsOneWidget);
    });

    testWidgets('PlayScreen pumps, renders board and game controls', (tester) async {
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

      expect(tester.takeException(), isNull);
      expect(find.byType(PlayScreen), findsOneWidget);
      expect(find.textContaining('SERIOUS GAME'), findsOneWidget);
    });

    testWidgets('CurriculumScreen pumps, renders phase items and theory', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurriculumScreen(
              repository: repo,
              onNavigate: (_, {args}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CurriculumScreen), findsOneWidget);
      expect(find.textContaining('Phase'), findsWidgets);
    });

    testWidgets('LabsScreen pumps, renders interactive lab and controls', (tester) async {
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

      expect(tester.takeException(), isNull);
      expect(find.byType(LabsScreen), findsOneWidget);
    });

    testWidgets('ModelGamesScreen pumps and renders model game viewer', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ModelGamesScreen(
              onNavigate: (_, {args}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ModelGamesScreen), findsOneWidget);
    });

    testWidgets('VideoStudioScreen pumps and renders video export options', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoStudioScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(VideoStudioScreen), findsOneWidget);
      expect(find.textContaining('Video Studio'), findsWidgets);
    });

    testWidgets('MoveListWidget renders turns and triggers callbacks', (tester) async {
      const pgn = '1. e4 e5 2. Nf3 Nc6 3. Bb5 a6';
      final game = PgnParser.parse(pgn)!;

      int? selectedPly;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoveListWidget(
              moves: game.moves,
              currentPlyIndex: 3,
              onMoveSelected: (ply) => selectedPly = ply,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('e4'), findsOneWidget);
      expect(find.text('e5'), findsOneWidget);
      expect(find.text('Nf3'), findsOneWidget);

      await tester.tap(find.text('e4'));
      expect(selectedPly, 1);
    });

    testWidgets('OpeningExplorerScreen pumps and renders tree and moves', (tester) async {
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

      expect(tester.takeException(), isNull);
      expect(find.byType(OpeningExplorerScreen), findsOneWidget);
      expect(find.textContaining('OPENING EXPLORER'), findsWidgets);
    });

    testWidgets('EndgameWorkspaceScreen pumps and renders positions and engine practice', (tester) async {
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

      expect(tester.takeException(), isNull);
      expect(find.byType(EndgameWorkspaceScreen), findsOneWidget);
      expect(find.textContaining('ENDGAME WORKSPACE'), findsWidgets);
    });

    testWidgets('WeaknessAnalyticsScreen pumps and renders radar and prescriptions', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WeaknessAnalyticsScreen(repository: repo),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(WeaknessAnalyticsScreen), findsOneWidget);
      expect(find.textContaining('COGNITIVE ROOT-CAUSE'), findsWidgets);
    });

    testWidgets('SettingsStorageScreen pumps and renders database health metrics', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsStorageScreen(repository: repo),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(SettingsStorageScreen), findsOneWidget);
      expect(find.textContaining('SETTINGS & STORAGE'), findsWidgets);
    });
  });
}
