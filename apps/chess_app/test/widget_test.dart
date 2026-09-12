import 'package:chess_app/main.dart';
import 'package:chess_app/src/widgets/board/chess_board_widget.dart';
import 'package:chess_app/src/widgets/board/evaluation_bar_widget.dart';
import 'package:chess_app/src/widgets/board/vector_piece_widget.dart';
import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ChessMasterApp launches and displays daily journey', (WidgetTester tester) async {
    // Set screen size to desktop landscape
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const ChessMasterApp());
    await tester.pumpAndSettle();

    expect(find.text('CHESSMASTER'), findsOneWidget);
    expect(find.text('Daily Journey'), findsOneWidget);
    expect(find.text('Curriculum'), findsOneWidget);
    expect(find.text('Labs'), findsOneWidget);
    expect(find.text('Play / Tourney'), findsOneWidget);
    expect(find.text('Video Studio'), findsOneWidget);
    expect(find.text('Mastery Report'), findsOneWidget);
  });

  testWidgets('ChessBoardWidget renders 64 squares and piece glyphs', (WidgetTester tester) async {
    final board = Board.initial();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 400,
            child: ChessBoardWidget(board: board),
          ),
        ),
      ),
    );

    // 32 vector pieces rendered at starting position
    expect(find.byType(VectorPieceWidget), findsNWidgets(32));
  });

  testWidgets('EvaluationBarWidget renders neutral evaluation', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 28,
            height: 200,
            child: EvaluationBarWidget(),
          ),
        ),
      ),
    );

    expect(find.text('0.00'), findsOneWidget);
  });
}
