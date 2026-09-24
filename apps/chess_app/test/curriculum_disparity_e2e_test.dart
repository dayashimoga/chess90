import 'package:chess_app/src/widgets/curriculum/lesson_player_widget.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('P0 Forensic Audit — Curriculum Disparity & Semantic Integrity E2E', () {
    test('Proves Day 5 != Day 6 != Day 9 in Catalog & Scenarios', () {
      final day5 = CurriculumCatalog.getDay(5);
      final day6 = CurriculumCatalog.getDay(6);
      final day9 = CurriculumCatalog.getDay(9);

      // Verify Concepts
      expect(day5.scenario?.concept, contains('Knight Fork'));
      expect(day6.scenario?.concept, contains('Double Attack'));
      expect(day9.scenario?.concept, contains('Deflection'));

      // Verify FENs are strictly different
      final fen5 = day5.scenario!.fen;
      final fen6 = day6.scenario!.fen;
      final fen9 = day9.scenario!.fen;

      expect(fen5, isNot(equals(fen6)), reason: 'Day 5 and Day 6 FENs must NOT be identical');
      expect(fen5, isNot(equals(fen9)), reason: 'Day 5 and Day 9 FENs must NOT be identical');
      expect(fen6, isNot(equals(fen9)), reason: 'Day 6 and Day 9 FENs must NOT be identical');

      // Verify neither is the old fallback back-rank FEN
      const oldFallbackFen = '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1';
      expect(fen5, isNot(equals(oldFallbackFen)), reason: 'Day 5 must not use fallback FEN');
      expect(fen6, isNot(equals(oldFallbackFen)), reason: 'Day 6 must not use fallback FEN');
      expect(fen9, isNot(equals(oldFallbackFen)), reason: 'Day 9 must not use fallback FEN');

      // Verify Day 5 solution is a knight fork
      expect(day5.scenario!.expectedMoves.first, contains('N'), reason: 'Day 5 solution move must be a Knight move');
      expect(day5.scenario!.expectedMoves.first, equals('Nc7+'));

      // Verify Day 6 solution is a center fork trick / double attack
      expect(day6.scenario!.expectedMoves.first, equals('Nxe4'));

      // Verify Day 9 solution is a deflection queen sacrifice
      expect(day9.scenario!.expectedMoves.first, equals('Qe8!'));
    });

    testWidgets('Proves Day 5 vs Day 6 vs Day 9 render genuinely distinct boards in LessonPlayerWidget',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = StorageRepository.inMemory();

      // Test Day 5 rendering
      final day5 = CurriculumCatalog.getDay(5);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonPlayerWidget(
              key: const ValueKey('day_5_player'),
              day: day5,
              repository: repo,
              onLessonCompleted: () {},
              onCancel: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Advance to Understand stage
      await tester.tap(find.text('Next: 2. See'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next: 3. Understand'));
      await tester.pumpAndSettle();

      // Solve Socratic active check to unlock Guided stage
      await tester.tap(find.textContaining('Scanning CCT'));
      await tester.pumpAndSettle();

      // Advance to Guided stage
      await tester.tap(find.text('Next: 4. Guided'));
      await tester.pumpAndSettle();

      // Ensure Day 5 Guided instruction matches Knight Fork and NOT Fried Liver
      expect(find.textContaining('Fried Liver battery against f7'), findsNothing,
          reason: 'Day 5 Guided must NEVER display the erroneous Fried Liver battery string');
      expect(find.textContaining('royal knight fork'), findsWidgets,
          reason: 'Day 5 Guided must reference knight forks and target king+rook');

      // Now pump Day 6
      final day6 = CurriculumCatalog.getDay(6);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonPlayerWidget(
              key: const ValueKey('day_6_player'),
              day: day6,
              repository: repo,
              onLessonCompleted: () {},
              onCancel: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

        // Advance to See stage (Stage 1)
        await tester.tap(find.text('Next: 2. See'));
        await tester.pumpAndSettle();

        // Ensure Day 6 visual pattern matches Double Attack
        expect(find.textContaining('Double Attacks'), findsWidgets);
        expect(find.textContaining('Capture the e4 pawn to prepare a simultaneous double attack'), findsOneWidget);

        // Now pump Day 9
        final day9 = CurriculumCatalog.getDay(9);
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LessonPlayerWidget(
                key: const ValueKey('day_9_player'),
                day: day9,
                repository: repo,
                onLessonCompleted: () {},
                onCancel: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Advance to See stage
        await tester.tap(find.text('Next: 2. See'));
        await tester.pumpAndSettle();

        // Ensure Day 9 visual pattern matches Deflection
        expect(find.textContaining('Deflection'), findsWidgets);
        expect(find.textContaining('Offer your queen on the 8th rank to deflect'), findsOneWidget);
      });

    test('Offline Deterministic Audit of All 90 Days: Zero Fallback Positions & 100% Legal', () {
      const oldFallbackFen = '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1';
      final seenFens = <String, int>{};

      for (int i = 1; i <= 90; i++) {
        final day = CurriculumCatalog.getDay(i);
        expect(day.scenario, isNotNull, reason: 'Day $i must have an authoritative scenario');
        final s = day.scenario!;

        // 1. Not fallback
        expect(s.fen, isNot(equals(oldFallbackFen)), reason: 'Day $i must not use fallback FEN');

        // 2. Valid FEN
        expect(FenParser.isValidFen(s.fen), isTrue, reason: 'Day $i valid FEN');

        // 3. Legal move
        final board = Board.fromFen(s.fen);
        expect(board.activeColor, equals(s.sideToMove), reason: 'Day $i active color matches sideToMove');

        final cleanSan = s.expectedMoves.first.replaceAll('!', '').replaceAll('?', '');
        final move = MoveGenerator.sanToMove(board, cleanSan);
        expect(move, isNotNull, reason: 'Day $i expected move ${s.expectedMoves.first} must be strictly legal in position');

        // Track FEN diversity
        seenFens[s.fen] = (seenFens[s.fen] ?? 0) + 1;
      }

      // Assert high diversity across curriculum (all 90 scenarios are distinct)
      expect(seenFens.length, equals(90), reason: 'All 90 curriculum days must have unique authoritative scenarios');
    });
  });
}
