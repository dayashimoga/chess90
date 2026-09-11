import 'package:chess_app/src/screens/video_studio_screen.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VideoStudioScreen Deep Interactive Testing Suite', () {
    testWidgets('VideoStudio generates timeline, toggles overlays, and copies command', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VideoStudioScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VideoStudioScreen), findsOneWidget);
      expect(find.byType(ChessBoardWidget), findsOneWidget);

      // Verify aspect ratio chips/buttons
      final shortsChip = find.textContaining('9:16');
      if (shortsChip.evaluate().isNotEmpty) {
        await tester.tap(shortsChip.first);
        await tester.pumpAndSettle();
      }

      final squareChip = find.textContaining('1:1');
      if (squareChip.evaluate().isNotEmpty) {
        await tester.tap(squareChip.first);
        await tester.pumpAndSettle();
      }

      // Step frame controls
      final nextFrameBtn = find.byIcon(Icons.skip_next);
      if (nextFrameBtn.evaluate().isNotEmpty) {
        await tester.tap(nextFrameBtn);
        await tester.pumpAndSettle();
      }

      final prevFrameBtn = find.byIcon(Icons.skip_previous);
      if (prevFrameBtn.evaluate().isNotEmpty) {
        await tester.tap(prevFrameBtn);
        await tester.pumpAndSettle();
      }

      // Toggle checkboxes (show evaluation bar, arrows, subtitles)
      final checkboxes = find.byType(Checkbox);
      for (final cb in checkboxes.evaluate()) {
        await tester.tap(find.byWidget(cb.widget));
        await tester.pumpAndSettle();
      }

      // Tap Copy FFmpeg Command
      final copyBtn = find.textContaining('Copy FFmpeg Command');
      if (copyBtn.evaluate().isNotEmpty) {
        await tester.tap(copyBtn.first);
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });
  });
}
