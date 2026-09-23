import 'package:chess_app/src/screens/curriculum_screen.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CurriculumScreen renders search, display labels, and pedagogical details',
      (WidgetTester tester) async {
    final repo = StorageRepository.inMemory();
    repo.saveProfile(UserProfile(
      id: 'test_user',
      username: 'Grandmaster in Training',
      currentDay: 2,
      passedExams: [7],
    ));

    await tester.pumpWidget(
      MaterialApp(
        home: CurriculumScreen(
          repository: repo,
          onNavigate: (screen, {args}) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify search input is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify day 1 and day 2 display labels are visible in the timeline
    expect(find.textContaining('Day 1 ·'), findsWidgets);
    expect(find.textContaining('Day 2 ·'), findsWidgets);

    // Verify status badges: Day 2 is CURRENT, Day 1 is DONE
    expect(find.text('CURRENT'), findsOneWidget);
    expect(find.text('DONE'), findsWidgets);

    // Verify pedagogical cards in right pane for Day 1
    expect(find.text('Core Learning Objectives'), findsOneWidget);
    expect(find.text('Educational Material & Grandmaster Principles'), findsOneWidget);
    expect(find.text('Worked Master Models'), findsOneWidget);
    expect(find.text('Historic Model Game Study'), findsOneWidget);
    expect(find.text('Interactive Lab Exercises'), findsOneWidget);

    // Test Search Functionality
    await tester.enterText(find.byType(TextField), 'Pins');
    await tester.pumpAndSettle();

    // Day 3 tile is present in search results
    expect(find.byKey(const Key('curriculum_day_tile_3')), findsOneWidget);
    // Day 1 tile is NOT present in search results
    expect(find.byKey(const Key('curriculum_day_tile_1')), findsNothing);

    // Tap on Day 3 tile to view its curriculum details
    await tester.tap(find.byKey(const Key('curriculum_day_tile_3')));
    await tester.pumpAndSettle();

    // Right pane now displays Day 3
    expect(find.textContaining('Day 3 ·'), findsWidgets);
  });
}
