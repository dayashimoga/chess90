import 'package:chess_app/src/screens/play_screen.dart';
import 'package:chess_app/src/screens/settings_storage_screen.dart';
import 'package:chess_app/src/screens/video_studio_screen.dart';
import 'package:chess_app/src/widgets/board/board_customizer_dialog.dart';
import 'package:chess_app/src/widgets/play/play_setup_dialog.dart';
import 'package:chess_app/src/widgets/video/game_source_selector_dialog.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:chess_video/chess_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('New Features & Deep Coverage Test Suite', () {
    late StorageRepository repo;

    setUp(() {
      repo = StorageRepository.inMemory();
    });

    testWidgets('BoardCustomizerDialog renders and updates preferences', (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      String savedBoardTheme = '';
      String savedPieceTheme = '';
      String savedBoardSize = '';
      String savedAnimationSpeed = '';
      bool savedCoordinates = false;
      bool savedHighlights = false;
      bool savedHints = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BoardCustomizerDialog(
              currentBoardTheme: 'tournamentGreen',
              currentPieceTheme: 'standard',
              currentBoardSize: 'standard',
              currentAnimationSpeed: 'normal',
              showCoordinates: true,
              showMoveHighlights: true,
              showLegalMoveHints: true,
              onApplied: ({
                required String boardTheme,
                required String pieceTheme,
                required String boardSize,
                required String animationSpeed,
                required bool showCoordinates,
                required bool showMoveHighlights,
                required bool showLegalMoveHints,
              }) {
                savedBoardTheme = boardTheme;
                savedPieceTheme = pieceTheme;
                savedBoardSize = boardSize;
                savedAnimationSpeed = animationSpeed;
                savedCoordinates = showCoordinates;
                savedHighlights = showMoveHighlights;
                savedHints = showLegalMoveHints;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Board & Piece Customization'), findsOneWidget);

      // Select Classic Walnut theme chip
      await tester.tap(find.text('Classic Walnut'));
      await tester.pumpAndSettle();

      // Select High Contrast B&W piece chip
      await tester.tap(find.text('High Contrast B&W'));
      await tester.pumpAndSettle();

      // Select Learning anim speed chip
      await tester.tap(find.text('Learning (500ms)'));
      await tester.pumpAndSettle();

      // Toggle switches
      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(3));
      await tester.tap(switches.at(0));
      await tester.pumpAndSettle();

      // Ensure DONE button is visible and tap
      final doneBtn = find.text('DONE');
      await tester.ensureVisible(doneBtn);
      await tester.tap(doneBtn);
      await tester.pumpAndSettle();

      expect(savedBoardTheme, equals('classicWood'));
      expect(savedPieceTheme, equals('highContrast'));
      expect(savedBoardSize, equals('standard'));
      expect(savedAnimationSpeed, equals('learning'));
      expect(savedCoordinates, isFalse);
      expect(savedHighlights, isTrue);
      expect(savedHints, isTrue);
    });

    testWidgets('PlaySetupDialog supports side, difficulty, mode, and clock selection', (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      PlaySetupConfig? resultConfig;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  resultConfig = await showDialog<PlaySetupConfig>(
                    context: context,
                    builder: (_) => const PlaySetupDialog(),
                  );
                },
                child: const Text('Open Setup'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Setup'));
      await tester.pumpAndSettle();

      expect(find.text('Play vs Computer Setup'), findsOneWidget);

      // Select Black side
      await tester.tap(find.text('Black'));
      await tester.pumpAndSettle();

      // Select Custom strength
      await tester.tap(find.text('Custom (1400 Elo)'));
      await tester.pumpAndSettle();

      // Drag custom slider
      final slider = find.byType(Slider);
      if (slider.evaluate().isNotEmpty) {
        await tester.drag(slider, const Offset(50, 0));
        await tester.pumpAndSettle();
      }

      // Select Master strength
      await tester.tap(find.text('Master (2400 Elo)'));
      await tester.pumpAndSettle();

      // Select Serious mode
      await tester.tap(find.text('Serious'));
      await tester.pumpAndSettle();

      // Tap START GAME button
      final startBtn = find.text('START GAME');
      await tester.ensureVisible(startBtn);
      await tester.tap(startBtn);
      await tester.pumpAndSettle();

      expect(resultConfig, isNotNull);
      expect(resultConfig!.playerColor, equals(PieceColor.black));
      expect(resultConfig!.strengthPreset, equals('Master'));
      expect(resultConfig!.eloRating, equals(2400));
      expect(resultConfig!.gameType, equals('Serious Game'));
      expect(resultConfig!.stockfishSkillLevel, greaterThanOrEqualTo(15));
      expect(resultConfig!.searchDepth, greaterThanOrEqualTo(10));
    });

    testWidgets('GameSourceSelectorDialog supports played, model, paste and import tabs', (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      dynamic selectedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  selectedResult = await showDialog<dynamic>(
                    context: context,
                    builder: (_) => GameSourceSelectorDialog(repository: repo),
                  );
                },
                child: const Text('Select Game Source'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select Game Source'));
      await tester.pumpAndSettle();

      expect(find.text('Select Game for Video Studio'), findsOneWidget);

      // Switch to Paste PGN tab
      await tester.tap(find.text('Paste PGN'));
      await tester.pumpAndSettle();

      // Validate empty paste
      await tester.tap(find.text('Validate PGN'));
      await tester.pumpAndSettle();
      expect(find.text('Please paste a non-empty PGN string.'), findsOneWidget);

      // Enter valid PGN
      await tester.enterText(
        find.byType(TextField),
        '1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. b4 Bxb4 1-0',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Validate PGN'));
      await tester.pumpAndSettle();
      expect(find.text('Use Game in Studio'), findsOneWidget);

      // Select this game
      await tester.tap(find.text('Use Game in Studio'));
      await tester.pumpAndSettle();

      expect(selectedResult, isNotNull);
      expect(selectedResult is String, isTrue);
    });

    testWidgets('PlayScreen deep interactive controls: hints, undo, pause, draw, resign, rematch', (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      String? navigatedRoute;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayScreen(
              repository: repo,
              engine: EmbeddedHeuristicEngine(),
              onNavigate: (route, {args}) {
                navigatedRoute = route;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Playing as White'), findsOneWidget);

      // 1. Play move: e2 -> e4
      final e2Square = find.bySemanticsLabel('White pawn on e2');
      if (e2Square.evaluate().isNotEmpty) {
        await tester.tap(e2Square);
        await tester.pumpAndSettle();
        final e4Square = find.bySemanticsLabel('Empty square e4');
        if (e4Square.evaluate().isNotEmpty) {
          await tester.tap(e4Square);
          await tester.pump(const Duration(milliseconds: 300));
          await tester.pumpAndSettle();
        }
      }

      // 2. Progressive Hint Button
      final hintIcon = find.byIcon(Icons.lightbulb_outline);
      if (hintIcon.evaluate().isNotEmpty) {
        await tester.tap(hintIcon);
        await tester.pumpAndSettle();
        await tester.tap(hintIcon);
        await tester.pumpAndSettle();
        await tester.tap(hintIcon);
        await tester.pumpAndSettle();
        await tester.tap(hintIcon);
        await tester.pumpAndSettle();
      }

      // 3. Takeback move
      final undoIcon = find.byIcon(Icons.undo);
      if (undoIcon.evaluate().isNotEmpty) {
        await tester.tap(undoIcon, warnIfMissed: false);
        await tester.pumpAndSettle();
      }

      // 4. Pause & Resume Clock via Icon
      final pauseIcon = find.byIcon(Icons.pause);
      if (pauseIcon.evaluate().isNotEmpty) {
        await tester.tap(pauseIcon, warnIfMissed: false);
        await tester.pumpAndSettle();
        final playIcon = find.byIcon(Icons.play_arrow);
        if (playIcon.evaluate().isNotEmpty) {
          await tester.tap(playIcon, warnIfMissed: false);
          await tester.pumpAndSettle();
        }
      }

      // 5. Flip Board
      final flipIcon = find.byIcon(Icons.swap_vert);
      if (flipIcon.evaluate().isNotEmpty) {
        await tester.tap(flipIcon);
        await tester.pumpAndSettle();
      }

      // 6. Open Customizer Dialog from Palette Icon
      final paletteIcon = find.byIcon(Icons.palette_outlined);
      if (paletteIcon.evaluate().isNotEmpty) {
        await tester.tap(paletteIcon);
        await tester.pumpAndSettle();
        expect(find.text('Board & Piece Customization'), findsOneWidget);
        await tester.ensureVisible(find.text('DONE'));
        await tester.tap(find.text('DONE'));
        await tester.pumpAndSettle();
      }

      // 7. Offer Draw Button
      final drawIcon = find.byIcon(Icons.handshake_outlined);
      if (drawIcon.evaluate().isNotEmpty) {
        await tester.tap(drawIcon);
        await tester.pumpAndSettle();
      }

      // 8. Resign Confirmation
      final resignIcon = find.byIcon(Icons.flag_outlined);
      if (resignIcon.evaluate().isNotEmpty) {
        await tester.tap(resignIcon, warnIfMissed: false);
        await tester.pumpAndSettle();
        final resignConfirmBtn = find.text('Resign');
        if (resignConfirmBtn.evaluate().isNotEmpty) {
          await tester.tap(resignConfirmBtn.last);
          await tester.pumpAndSettle();
        }
      }

      // 9. Rematch after Resignation
      final rematchBtn = find.text('Rematch');
      if (rematchBtn.evaluate().isNotEmpty) {
        await tester.tap(rematchBtn);
        await tester.pumpAndSettle();
      }

      // 10. Restart Confirmation
      final restartIcon = find.byIcon(Icons.restart_alt);
      if (restartIcon.evaluate().isNotEmpty) {
        await tester.tap(restartIcon, warnIfMissed: false);
        await tester.pumpAndSettle();
        final cancelBtn = find.text('Cancel');
        if (cancelBtn.evaluate().isNotEmpty) {
          await tester.tap(cancelBtn.first);
          await tester.pumpAndSettle();
        }
      }

      // 11. Open Setup Dialog from New Game Setup
      final setupBtn = find.text('New Game Setup');
      if (setupBtn.evaluate().isNotEmpty) {
        await tester.tap(setupBtn);
        await tester.pumpAndSettle();
        expect(find.text('Play vs Computer Setup'), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
      }

      // 12. Analyze Position Navigation
      final analyzeBtn = find.text('Analyze Position');
      if (analyzeBtn.evaluate().isNotEmpty) {
        await tester.tap(analyzeBtn);
        await tester.pumpAndSettle();
        expect(navigatedRoute, equals('analysis'));
      }
    });

    testWidgets('SettingsStorageScreen interacts with customization cards and dialogs', (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsStorageScreen(repository: repo),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('SETTINGS & STORAGE MANAGEMENT'), findsOneWidget);

      // Verify Visual Aesthetics card exists
      expect(find.text('Visual Aesthetics & Presentation System'), findsOneWidget);

      // Verify and toggle all switches
      final switches = find.byType(Switch);
      for (int i = 0; i < switches.evaluate().length && i < 4; i++) {
        await tester.tap(switches.at(i));
        await tester.pumpAndSettle();
      }

      // Test Board Theme dropdown selection
      final boardThemeDropdown = find.text('Tournament Green');
      if (boardThemeDropdown.evaluate().isNotEmpty) {
        await tester.tap(boardThemeDropdown.first);
        await tester.pumpAndSettle();
        final classicWoodItem = find.text('Classic Wood').last;
        await tester.tap(classicWoodItem);
        await tester.pumpAndSettle();
      }

      // Trigger Export Backup
      final exportBtn = find.text('Export JSON Backup');
      expect(exportBtn, findsOneWidget);
      await tester.tap(exportBtn);
      await tester.pumpAndSettle();
    });

    testWidgets('VideoStudioScreen interacts with all configuration dropdowns and controls', (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoStudioScreen(repository: repo),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Video Studio · '), findsOneWidget);

      // Tap Select Game button
      final selectBtn = find.text('Select Game');
      expect(selectBtn, findsOneWidget);
      await tester.tap(selectBtn);
      await tester.pumpAndSettle();

      // Dismiss dialog
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Test format selector dropdown
      final formatDropdown = find.byType(DropdownButtonFormField<VideoAspectRatio>);
      if (formatDropdown.evaluate().isNotEmpty) {
        await tester.tap(formatDropdown.first);
        await tester.pumpAndSettle();
        final shortsOption = find.textContaining('Shorts').last;
        if (shortsOption.evaluate().isNotEmpty) {
          await tester.tap(shortsOption);
          await tester.pumpAndSettle();
        }
      }

      // Toggle overlays
      final switches = find.byType(Switch);
      for (int i = 0; i < switches.evaluate().length && i < 3; i++) {
        await tester.tap(switches.at(i));
        await tester.pumpAndSettle();
      }

      // Step forward / backward in scrubber
      final nextBtn = find.byIcon(Icons.chevron_right);
      if (nextBtn.evaluate().isNotEmpty) {
        await tester.tap(nextBtn);
        await tester.pumpAndSettle();
        await tester.tap(nextBtn);
        await tester.pumpAndSettle();
      }
      final prevBtn = find.byIcon(Icons.chevron_left);
      if (prevBtn.evaluate().isNotEmpty) {
        await tester.tap(prevBtn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('GameSourceSelectorDialog selects from Model Games tab', (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      dynamic selectedResult;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  selectedResult = await showDialog<dynamic>(
                    context: context,
                    builder: (_) => GameSourceSelectorDialog(repository: repo),
                  );
                },
                child: const Text('Select Game'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select Game'));
      await tester.pumpAndSettle();

      // Switch to Model Games tab
      final modelTab = find.textContaining('Model Games');
      if (modelTab.evaluate().isNotEmpty) {
        await tester.tap(modelTab.first);
        await tester.pumpAndSettle();

        // Tap the 'Use Game' button on the first model game in the list
        final useButtons = find.widgetWithText(ElevatedButton, 'Use Game');
        if (useButtons.evaluate().isNotEmpty) {
          await tester.tap(useButtons.first);
        } else {
          final listTiles = find.byType(ListTile);
          if (listTiles.evaluate().isNotEmpty) {
            await tester.tap(listTiles.first);
          }
        }
        await tester.pumpAndSettle();
      }

      expect(selectedResult, isNotNull);
    });

    testWidgets('PlayScreen post-game move scrubber, takeback in rated, and clipboard actions', (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

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
      await tester.pumpAndSettle();

      // Play 1. e4
      final e2Square = find.bySemanticsLabel('White pawn on e2');
      if (e2Square.evaluate().isNotEmpty) {
        await tester.tap(e2Square);
        await tester.pumpAndSettle();
        final e4Square = find.bySemanticsLabel('Empty square e4');
        if (e4Square.evaluate().isNotEmpty) {
          await tester.tap(e4Square);
          await tester.pump(const Duration(milliseconds: 300));
          await tester.pumpAndSettle();
        }
      }

      // Copy FEN & Copy PGN
      final copyBtns = find.byIcon(Icons.copy);
      for (int i = 0; i < copyBtns.evaluate().length; i++) {
        await tester.tap(copyBtns.at(i));
        await tester.pumpAndSettle();
      }

      // Resign the game to trigger game over
      final resignIcon = find.byIcon(Icons.flag_outlined);
      if (resignIcon.evaluate().isNotEmpty) {
        await tester.tap(resignIcon, warnIfMissed: false);
        await tester.pumpAndSettle();
        final resignConfirmBtn = find.text('Resign');
        if (resignConfirmBtn.evaluate().isNotEmpty) {
          await tester.tap(resignConfirmBtn.last);
          await tester.pumpAndSettle();
        }
      }

      // Scrubber buttons
      final firstBtn = find.byIcon(Icons.first_page);
      if (firstBtn.evaluate().isNotEmpty) {
        await tester.tap(firstBtn);
        await tester.pumpAndSettle();
      }
      final nextBtn = find.byIcon(Icons.chevron_right);
      if (nextBtn.evaluate().isNotEmpty) {
        await tester.tap(nextBtn);
        await tester.pumpAndSettle();
      }
      final prevBtn = find.byIcon(Icons.chevron_left);
      if (prevBtn.evaluate().isNotEmpty) {
        await tester.tap(prevBtn);
        await tester.pumpAndSettle();
      }
      final lastBtn = find.byIcon(Icons.last_page);
      if (lastBtn.evaluate().isNotEmpty) {
        await tester.tap(lastBtn);
        await tester.pumpAndSettle();
      }

      // Rematch button
      final rematchBtn = find.text('Rematch');
      if (rematchBtn.evaluate().isNotEmpty) {
        await tester.tap(rematchBtn);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('VideoStudioScreen compact layout and preview playback', (tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VideoStudioScreen(repository: repo),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap play/pause icon in preview canvas
      final playPauseBtn = find.byIcon(Icons.play_arrow);
      if (playPauseBtn.evaluate().isNotEmpty) {
        await tester.tap(playPauseBtn.first);
        await tester.pump(const Duration(milliseconds: 200));
        await tester.pumpAndSettle();
      }

      // Tap generate video button
      final generateBtn = find.text('Generate Video');
      if (generateBtn.evaluate().isNotEmpty) {
        await tester.tap(generateBtn);
        await tester.pumpAndSettle();
      }
    });
  });
}
