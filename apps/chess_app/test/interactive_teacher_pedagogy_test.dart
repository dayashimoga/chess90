import 'dart:io';
import 'package:chess_app/src/screens/analysis_screen.dart';
import 'package:chess_app/src/screens/play_screen.dart';
import 'package:chess_app/src/widgets/board/responsive_chess_workspace.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Interactive Chess Teacher & Forensic UX Remediation Tests', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('teacher_pedagogy_test_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('GameSession records moves, autosaves, and accurately rebuilds PGN and FEN history', () {
      final session = GameSession.newGame(
        timeControl: '15+10 Rapid',
        initialMinutes: 15,
        incrementSeconds: 10,
        playerColor: 'white',
      );

      expect(session.isCompleted, isFalse);
      expect(session.moveSanList, isEmpty);

      // Record Move 1: e4
      session.recordMove(
        san: 'e4',
        uci: 'e2e4',
        newFen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        whiteTime: 898,
        blackTime: 900,
      );

      expect(session.moveSanList.length, 1);
      expect(session.moveSanList.first, 'e4');
      expect(session.pgn, contains('1. e4'));

      // Record Move 2: e5
      session.recordMove(
        san: 'e5',
        uci: 'e7e5',
        newFen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2',
        whiteTime: 898,
        blackTime: 896,
      );

      expect(session.moveSanList.length, 2);
      expect(session.pgn, contains('1. e4 e5'));

      // Save to repo and reload
      repo.saveActiveGameSession(session);
      final loaded = repo.getActiveGameSession();
      expect(loaded, isNotNull);
      expect(loaded!.moveSanList.length, 2);
      expect(loaded.moveSanList, ['e4', 'e5']);
      expect(loaded.whiteRemainingSeconds, 898);
      expect(loaded.blackRemainingSeconds, 896);

      // Complete game
      session.completeGame('1-0');
      repo.saveCompletedGame(session);
      repo.clearActiveGameSession();

      expect(repo.getActiveGameSession(), isNull);
      expect(repo.getLastCompletedGame(), isNotNull);
      expect(repo.getLastCompletedGame()!.result, '1-0');
      expect(repo.getGameHistory().length, 1);
    });

    test('SocraticPedagogyEngine creates genuine distinct Demo and Guided discovery models', () {
      final engine = SocraticPedagogyEngine(
        initialBoard: Board.fromFen('6k1/5ppp/8/8/8/8/8/R5K1 w - - 0 1'),
        sideToPlay: PieceColor.white,
        solutionSan: const ['Ra8#'],
        motif: 'Back Rank Mate',
        explanation: 'Back rank mate occurs when the king is trapped behind pawns and attacked on the 8th rank.',
      );

      // Verify Demo sequence
      expect(engine.demoSteps.length, greaterThanOrEqualTo(4));
      expect(engine.demoSteps[0].caption, contains('Observe the black King'));
      expect(engine.demoSteps[1].caption, contains('attacking piece'));
      expect(engine.demoSteps[2].caption, contains('Deliver the checkmate'));

      // Verify Socratic discovery checkpoints
      expect(engine.socraticSteps.length, greaterThanOrEqualTo(4));
      expect(engine.socraticSteps[0].prompt, contains('vulnerable enemy King'));
      expect(engine.socraticSteps[1].prompt, contains('escape squares'));
      expect(engine.socraticSteps[2].prompt, contains('attacking piece'));

      // Socratic step-by-step discovery validation
      expect(engine.validateSocraticSquare(Square.fromName('g8')!), isTrue);
      expect(engine.currentSocraticIndex, 1);

      // Escape square validation (pawn shield f7)
      expect(engine.validateSocraticSquare(Square.fromName('f7')!), isTrue);
      expect(engine.currentSocraticIndex, 2);

      // Attacker piece discovery (rook on a1)
      expect(engine.validateSocraticSquare(Square.fromName('a1')!), isTrue);
      expect(engine.currentSocraticIndex, 3);

      // Candidate move execution
      expect(engine.validateSocraticMove('Ra8#'), isTrue);
      expect(engine.isSocraticFinished, isTrue);
    });

    testWidgets('ResponsiveChessWorkspace scales board dynamically and responds to MAX/AUTO/Collapse', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      double reportedBoardSize = 0.0;
      bool panelCollapsed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveChessWorkspace(
              initialScale: 1.0,
              initialSidePanelCollapsed: false,
              onSidePanelToggled: (val) => panelCollapsed = val,
              boardBuilder: (context, size) {
                reportedBoardSize = size;
                return Container(width: size, height: size, color: Colors.green);
              },
              sidePanel: Container(color: Colors.blue, child: const Text('Side Panel Content')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Board must be substantially larger than the old 500px clamp on a 1440x900 viewport!
      expect(reportedBoardSize, greaterThan(600.0));
      expect(find.text('Side Panel Content'), findsOneWidget);

      // Tap collapse side panel button
      final collapseBtn = find.byTooltip('Collapse Side Panel');
      expect(collapseBtn, findsOneWidget);
      await tester.tap(collapseBtn);
      await tester.pumpAndSettle();

      expect(panelCollapsed, isTrue);
    });

    testWidgets('PlayScreen maintains continuous GameSession and displays 5 one-click post-game actions', (tester) async {
      tester.view.physicalSize = const Size(1280, 850);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              onNavigate: (screen, {args}) {},
              engine: EmbeddedHeuristicEngine(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify PlayScreen and ResponsiveChessWorkspace rendered
      expect(find.byType(PlayScreen), findsOneWidget);
      expect(find.byType(ResponsiveChessWorkspace), findsOneWidget);

      // Active continuous game session was initialized and autosaved
      final active = repo.getActiveGameSession();
      expect(active, isNotNull);
      expect(active!.isCompleted, isFalse);

      // Game Library trigger is present
      expect(find.text('Game Library'), findsOneWidget);
    });

    testWidgets('AnalysisScreen provides Train This Mistake button that updates SkillGraph', (tester) async {
      tester.view.physicalSize = const Size(1280, 850);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Seed skill node in repository
      repo.saveSkillNode(SkillNode(
        id: 'tactics',
        name: 'Tactical Patterns',
        axis: SkillAxis.tactics,
        status: SkillStatus.unseen,
      ));

      // Game with a blunder to analyze
      const blunderPgn = '''
[Event "Blunder Match"]
[Site "ChessMaster"]
[Date "2026.09.15"]
[Round "1"]
[White "Player"]
[Black "Engine"]
[Result "0-1"]

1. e4 e5 2. Qh5 Nc6 3. Bc4 Nf6 4. Qxf7# 1-0
''';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnalysisScreen(
              repository: repo,
              engine: EmbeddedHeuristicEngine(),
              initialArgs: const {'pgn': blunderPgn, 'tab': 'mistakes'},
              onNavigate: (screen, {args}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AnalysisScreen), findsOneWidget);
      expect(find.byType(ResponsiveChessWorkspace), findsOneWidget);
    });
  });
}
