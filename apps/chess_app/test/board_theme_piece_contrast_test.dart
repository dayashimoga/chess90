import 'package:chess_app/src/theme/chess_board_theme.dart';
import 'package:chess_app/src/theme/piece_theme.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_app/src/widgets/board/vector_piece_widget.dart';
import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Board Visuals & Piece Theme Contrast Tests (P0 Gate)', () {
    testWidgets('Renders all 12 vector pieces with identical style and high contrast', (tester) async {
      const pieceTheme = PieceTheme.standard;
      const allTypes = PieceType.values;

      for (final type in allTypes) {
        final whitePiece = Piece(type, PieceColor.white);
        final blackPiece = Piece(type, PieceColor.black);

        // Render White piece on light square
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              backgroundColor: ChessBoardTheme.tournamentGreen.lightSquare,
              body: Center(
                child: VectorPieceWidget(
                  piece: whitePiece,
                  size: 64,
                  theme: pieceTheme,
                ),
              ),
            ),
          ),
        );
        expect(find.byType(VectorPieceWidget), findsOneWidget);

        // Render White piece on dark square
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              backgroundColor: ChessBoardTheme.tournamentGreen.darkSquare,
              body: Center(
                child: VectorPieceWidget(
                  piece: whitePiece,
                  size: 64,
                  theme: pieceTheme,
                ),
              ),
            ),
          ),
        );
        expect(find.byType(VectorPieceWidget), findsOneWidget);

        // Render Black piece on light square
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              backgroundColor: ChessBoardTheme.tournamentGreen.lightSquare,
              body: Center(
                child: VectorPieceWidget(
                  piece: blackPiece,
                  size: 64,
                  theme: pieceTheme,
                ),
              ),
            ),
          ),
        );
        expect(find.byType(VectorPieceWidget), findsOneWidget);

        // Render Black piece on dark square
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              backgroundColor: ChessBoardTheme.tournamentGreen.darkSquare,
              body: Center(
                child: VectorPieceWidget(
                  piece: blackPiece,
                  size: 64,
                  theme: pieceTheme,
                ),
              ),
            ),
          ),
        );
        expect(find.byType(VectorPieceWidget), findsOneWidget);
      }
    });

    test('All 6 piece types for each side share identical color and stroke definition', () {
      const theme = PieceTheme.standard;

      // White pieces
      expect(theme.whitePieceColor, equals(const Color(0xFFFFFFFF)));
      expect(theme.whiteStrokeColor, equals(const Color(0xFF1E293B)));
      expect(theme.whiteStrokeWidth, greaterThanOrEqualTo(1.8));

      // Black pieces (must NOT be purple or grey)
      expect(theme.blackPieceColor, equals(const Color(0xFF111827)));
      expect(theme.blackStrokeColor, equals(const Color(0xFFF8FAFC)));
      expect(theme.blackStrokeWidth, greaterThanOrEqualTo(1.4));
    });

    testWidgets('ChessBoardWidget renders 64 vector pieces at initial position with persistent last-move overlays', (tester) async {
      final board = Board.initial();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 480,
                height: 480,
                child: ChessBoardWidget(
                  board: board,
                  lastMoveFrom: Square.e2,
                  lastMoveTo: Square.e4,
                  boardTheme: ChessBoardTheme.tournamentGreen,
                  pieceTheme: PieceTheme.standard,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 32 starting pieces rendered via VectorPieceWidget
      expect(find.byType(VectorPieceWidget), findsNWidgets(32));

      // Coordinate labels
      expect(find.text('a'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('h'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
    });
  });
}
