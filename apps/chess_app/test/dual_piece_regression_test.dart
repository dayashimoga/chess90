import 'package:chess_app/src/theme/chess_board_theme.dart';
import 'package:chess_app/src/theme/piece_theme.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_app/src/widgets/board/vector_piece_widget.dart';
import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('P0 Regression Tests: Ghost/Dual-Piece Elimination & Engine Move Animation', () {
    testWidgets('Normal move: no duplicate piece at destination during animation', (tester) async {
      Board board = Board.initial();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: SizedBox(
                    width: 480,
                    height: 480,
                    child: ChessBoardWidget(
                      board: board,
                      isInteractive: true,
                      animationDurationMs: 200,
                      lastMoveFrom: board.history.isNotEmpty ? board.history.last.move.from : null,
                      lastMoveTo: board.history.isNotEmpty ? board.history.last.move.to : null,
                      onMovePlayed: (m) {
                        setState(() {
                          board = board.clone()..makeMove(m);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap e2
      await tester.tap(find.bySemanticsLabel('White pawn on e2'));
      await tester.pump();

      // Tap e4
      await tester.tap(find.bySemanticsLabel('Empty square e4'));
      // Advance by half the animation duration (100ms)
      await tester.pump(const Duration(milliseconds: 100));

      // In flight:
      // 1. Board has 16 pawns initially.
      // During flight, exactly 16 total VectorPieceWidget widgets for pawns must exist
      // (15 static pawns + 1 in-flight pawn = 16 total pawns on screen, NOT 17).
      final pawnWidgets = tester.widgetList<VectorPieceWidget>(find.byType(VectorPieceWidget))
          .where((w) => w.piece.type == PieceType.pawn && w.piece.color == PieceColor.white)
          .toList();
      expect(pawnWidgets.length, equals(8), reason: 'Must have exactly 8 white pawns on screen (no dual piece at e4)');

      // Complete animation
      await tester.pumpAndSettle();

      final settledPawns = tester.widgetList<VectorPieceWidget>(find.byType(VectorPieceWidget))
          .where((w) => w.piece.type == PieceType.pawn && w.piece.color == PieceColor.white)
          .toList();
      expect(settledPawns.length, equals(8));
      expect(find.bySemanticsLabel('White pawn on e4'), findsOneWidget);
      expect(find.bySemanticsLabel('Empty square e2'), findsOneWidget);
    });

    testWidgets('Capture move: destination square preserves captured piece during flight', (tester) async {
      // White pawn on e4, Black pawn on d5
      Board board = Board.fromFen('rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 2');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: SizedBox(
                    width: 480,
                    height: 480,
                    child: ChessBoardWidget(
                      board: board,
                      isInteractive: true,
                      animationDurationMs: 200,
                      lastMoveFrom: board.history.isNotEmpty ? board.history.last.move.from : null,
                      lastMoveTo: board.history.isNotEmpty ? board.history.last.move.to : null,
                      onMovePlayed: (m) {
                        setState(() {
                          board = board.clone()..makeMove(m);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap e4 White pawn
      await tester.tap(find.bySemanticsLabel('White pawn on e4'));
      await tester.pump();

      // Tap d5 Black pawn to capture
      await tester.tap(find.bySemanticsLabel('Black pawn on d5'));
      await tester.pump(const Duration(milliseconds: 100));

      // In flight:
      // Destination d5 still displays Black pawn during flight
      // White pawn is in-flight layer
      // Total white pawns = 8, Total black pawns = 8 during flight
      final whitePawns = tester.widgetList<VectorPieceWidget>(find.byType(VectorPieceWidget))
          .where((w) => w.piece.type == PieceType.pawn && w.piece.color == PieceColor.white)
          .toList();
      expect(whitePawns.length, equals(8), reason: 'No duplicate White pawn at d5 during capture flight');

      await tester.pumpAndSettle();

      // After settlement:
      // White pawn on d5, Black pawn gone
      expect(find.bySemanticsLabel('White pawn on d5'), findsOneWidget);
      expect(find.bySemanticsLabel('Empty square e4'), findsOneWidget);
    });

    testWidgets('Castling (O-O): no duplicate King or Rook during animation', (tester) async {
      Board board = Board.fromFen('r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQkq - 1 5');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: SizedBox(
                    width: 480,
                    height: 480,
                    child: ChessBoardWidget(
                      board: board,
                      isInteractive: true,
                      animationDurationMs: 200,
                      lastMoveFrom: board.history.isNotEmpty ? board.history.last.move.from : null,
                      lastMoveTo: board.history.isNotEmpty ? board.history.last.move.to : null,
                      onMovePlayed: (m) {
                        setState(() {
                          board = board.clone()..makeMove(m);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap White King on e1
      await tester.tap(find.bySemanticsLabel('White king on e1'));
      await tester.pump();

      // Tap g1 (castling destination)
      await tester.tap(find.bySemanticsLabel('Empty square g1'));
      await tester.pump(const Duration(milliseconds: 100));

      // In flight:
      // Exactly 1 White King on screen
      final kings = tester.widgetList<VectorPieceWidget>(find.byType(VectorPieceWidget))
          .where((w) => w.piece.type == PieceType.king && w.piece.color == PieceColor.white)
          .toList();
      expect(kings.length, equals(1), reason: 'Exactly 1 White King during castling animation');

      // Exactly 2 White Rooks on screen (a1 and in-flight h1->f1)
      final rooks = tester.widgetList<VectorPieceWidget>(find.byType(VectorPieceWidget))
          .where((w) => w.piece.type == PieceType.rook && w.piece.color == PieceColor.white)
          .toList();
      expect(rooks.length, equals(2), reason: 'Exactly 2 White Rooks during castling animation');

      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('White king on g1'), findsOneWidget);
      expect(find.bySemanticsLabel('White rook on f1'), findsOneWidget);
    });

    testWidgets('Engine / external move animates smoothly without teleportation', (tester) async {
      Board board = Board.initial();
      Square? lastFrom;
      Square? lastTo;

      late StateSetter parentSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                parentSetState = setState;
                return Center(
                  child: SizedBox(
                    width: 480,
                    height: 480,
                    child: ChessBoardWidget(
                      board: board,
                      isInteractive: true,
                      animationDurationMs: 200,
                      lastMoveFrom: lastFrom,
                      lastMoveTo: lastTo,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Simulate external engine playing e2 -> e4
      final engineMove = Move(from: Square.e2, to: Square.e4);
      parentSetState(() {
        board = board.clone()..makeMove(engineMove);
        lastFrom = engineMove.from;
        lastTo = engineMove.to;
      });
      await tester.pump();

      // Advance halfway through external animation
      await tester.pump(const Duration(milliseconds: 100));

      // Verify no dual pawn at e4 during engine move flight
      final whitePawns = tester.widgetList<VectorPieceWidget>(find.byType(VectorPieceWidget))
          .where((w) => w.piece.type == PieceType.pawn && w.piece.color == PieceColor.white)
          .toList();
      expect(whitePawns.length, equals(8), reason: 'External engine move must have exactly 8 white pawns during animation');

      // Settle animation
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('White pawn on e4'), findsOneWidget);
      expect(find.bySemanticsLabel('Empty square e2'), findsOneWidget);
    });

    testWidgets('Rapid moves interrupt cleanly without crash or state corruption', (tester) async {
      Board board = Board.initial();
      Square? lastFrom;
      Square? lastTo;
      late StateSetter parentSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                parentSetState = setState;
                return Center(
                  child: SizedBox(
                    width: 480,
                    height: 480,
                    child: ChessBoardWidget(
                      board: board,
                      isInteractive: true,
                      animationDurationMs: 200,
                      lastMoveFrom: lastFrom,
                      lastMoveTo: lastTo,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Move 1
      parentSetState(() {
        final m1 = Move(from: Square.e2, to: Square.e4);
        board = board.clone()..makeMove(m1);
        lastFrom = m1.from;
        lastTo = m1.to;
      });
      await tester.pump(const Duration(milliseconds: 30));

      // Move 2 interrupts Move 1 mid-flight
      parentSetState(() {
        final m2 = Move(from: Square.named('e7'), to: Square.e5);
        board = board.clone()..makeMove(m2);
        lastFrom = m2.from;
        lastTo = m2.to;
      });
      await tester.pump(const Duration(milliseconds: 30));

      // Move 3 interrupts Move 2 mid-flight
      parentSetState(() {
        final m3 = Move(from: Square.g1, to: Square.f3);
        board = board.clone()..makeMove(m3);
        lastFrom = m3.from;
        lastTo = m3.to;
      });
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('White knight on f3'), findsOneWidget);
      expect(find.bySemanticsLabel('Black pawn on e5'), findsOneWidget);
      expect(find.bySemanticsLabel('White pawn on e4'), findsOneWidget);
    });

    testWidgets('Backward navigation / undo does not animate forward', (tester) async {
      Board board = Board.initial();
      final m1 = Move(from: Square.e2, to: Square.e4);
      board.makeMove(m1);
      final m2 = Move(from: Square.named('e7'), to: Square.e5);
      board.makeMove(m2);

      Square? lastFrom = m2.from;
      Square? lastTo = m2.to;
      late StateSetter parentSetState;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                parentSetState = setState;
                return Center(
                  child: SizedBox(
                    width: 480,
                    height: 480,
                    child: ChessBoardWidget(
                      board: board,
                      isInteractive: true,
                      animationDurationMs: 200,
                      lastMoveFrom: lastFrom,
                      lastMoveTo: lastTo,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Undo m2: board history shrinks
      parentSetState(() {
        board = board.clone()..unmakeMove();
        lastFrom = m1.from;
        lastTo = m1.to;
      });
      await tester.pump();

      // Should immediately show Black pawn back at e7, no in-flight animation
      expect(find.bySemanticsLabel('Black pawn on e7'), findsOneWidget);
      expect(find.bySemanticsLabel('Empty square e5'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Black pawn on e7'), findsOneWidget);
    });

    testWidgets('Pawn promotion: promotes to Queen without duplicate pieces', (tester) async {
      Board board = Board.fromFen('8/4P3/8/8/8/8/8/4K2k w - - 0 1');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Center(
                  child: SizedBox(
                    width: 480,
                    height: 480,
                    child: ChessBoardWidget(
                      board: board,
                      isInteractive: true,
                      animationDurationMs: 200,
                      onMovePlayed: (m) {
                        setState(() {
                          board = board.clone()..makeMove(m);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap e7 pawn
      await tester.tap(find.bySemanticsLabel('White pawn on e7'));
      await tester.pump();

      // Tap e8 square to prompt promotion
      await tester.tap(find.bySemanticsLabel('Empty square e8'));
      await tester.pumpAndSettle();

      // Promotion dialog should be open
      expect(find.text('Promote Pawn'), findsOneWidget);

      // Tap Queen option (first option in dialog)
      final queenOptions = find.byType(InkWell);
      expect(queenOptions, findsWidgets);
      await tester.tap(queenOptions.first);

      // Advance by half the animation
      await tester.pump(const Duration(milliseconds: 100));

      // Settle animation
      await tester.pumpAndSettle();

      // Verified: Queen on e8, e7 is empty, exactly 1 white queen exists
      expect(find.bySemanticsLabel('White queen on e8'), findsOneWidget);
      expect(find.bySemanticsLabel('Empty square e7'), findsOneWidget);
    });
  });
}

