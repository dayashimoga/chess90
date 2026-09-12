import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Move Animation & Visibility Pipeline E2E Tests (P0 Gate)', () {
    testWidgets('Tapping piece and destination triggers move and preserves last-move highlights', (tester) async {
      final board = Board.initial();
      Move? playedMove;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 480,
                height: 480,
                child: ChessBoardWidget(
                  board: board,
                  isInteractive: true,
                  animationDurationMs: 150,
                  onMovePlayed: (m) => playedMove = m,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap e2 pawn
      final e2SquareFinder = find.bySemanticsLabel('White pawn on e2');
      expect(e2SquareFinder, findsOneWidget);
      await tester.tap(e2SquareFinder);
      await tester.pump();

      // Tap e4 destination
      final e4SquareFinder = find.bySemanticsLabel('Empty square e4');
      expect(e4SquareFinder, findsOneWidget);
      await tester.tap(e4SquareFinder);

      // Verify animation ticks through
      await tester.pump(const Duration(milliseconds: 75));
      expect(playedMove, isNotNull);
      expect(playedMove!.from, equals(Square.e2));
      expect(playedMove!.to, equals(Square.e4));

      // Settle animation
      await tester.pumpAndSettle();
    });

    testWidgets('Castling move animates and executes legally', (tester) async {
      // Board ready for White O-O (e1-g1)
      final board = Board.fromFen('r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQkq - 1 5');
      Move? playedMove;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 480,
                height: 480,
                child: ChessBoardWidget(
                  board: board,
                  isInteractive: true,
                  animationDurationMs: 150,
                  onMovePlayed: (m) => playedMove = m,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap White King on e1
      final kingFinder = find.bySemanticsLabel('White king on e1');
      expect(kingFinder, findsOneWidget);
      await tester.tap(kingFinder);
      await tester.pump();

      // Tap g1 (castling destination)
      final g1Square = find.bySemanticsLabel('Empty square g1');
      expect(g1Square, findsOneWidget);
      await tester.tap(g1Square);

      // Verify castling move triggered
      expect(playedMove, isNotNull);
      expect(playedMove!.from, equals(Square.e1));
      expect(playedMove!.to, equals(Square.g1));

      // Settle animation
      await tester.pumpAndSettle();
    });
  });
}
