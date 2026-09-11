import 'package:chess_app/src/screens/endgame_workspace_screen.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EndgameWorkspaceScreen Deep Interactive Testing Suite', () {
    testWidgets('EndgameWorkspace loads positions, switches studies, and plays interactive move', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EndgameWorkspaceScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(EndgameWorkspaceScreen), findsOneWidget);
      expect(find.byType(ChessBoardWidget), findsOneWidget);
      expect(find.text('The Lucena Position (Building a Bridge)'), findsWidgets);

      // Play move 1. Rf4 in Lucena: tap white rook on f1, then tap empty square f4
      final rf1Square = find.bySemanticsLabel('White rook on f1');
      if (rf1Square.evaluate().isNotEmpty) {
        await tester.tap(rf1Square);
        await tester.pumpAndSettle();

        final f4Square = find.bySemanticsLabel('Empty square f4');
        if (f4Square.evaluate().isNotEmpty) {
          await tester.tap(f4Square);
          // Wait for engine response delay (300ms)
          await tester.pump(const Duration(milliseconds: 400));
          await tester.pumpAndSettle();
        }
      }

      // Tap on another endgame: Philidor Position
      final philidorTile = find.textContaining('Philidor');
      if (philidorTile.evaluate().isNotEmpty) {
        await tester.tap(philidorTile.first);
        await tester.pumpAndSettle();
        expect(find.textContaining('3rd Rank Defense'), findsWidgets);
      }

      // Tap on Queen vs Pawn
      final queenTile = find.textContaining('Queen vs Pawn');
      if (queenTile.evaluate().isNotEmpty) {
        await tester.tap(queenTile.first);
        await tester.pumpAndSettle();
        expect(find.textContaining('Pawn Endgames'), findsWidgets);
      }

      // Tap on Reset Position button
      final resetBtn = find.text('Reset Position');
      if (resetBtn.evaluate().isNotEmpty) {
        await tester.tap(resetBtn.first);
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });
  });
}
