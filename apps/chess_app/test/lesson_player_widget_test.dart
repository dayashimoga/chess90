import 'package:chess_app/src/widgets/curriculum/lesson_player_widget.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LessonPlayerWidget renders stages and allows stage navigation',
      (WidgetTester tester) async {
    final repo = StorageRepository.inMemory();
    final day1 = CurriculumCatalog.getDay(1);
    bool completed = false;
    bool cancelled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LessonPlayerWidget(
            day: day1,
            repository: repo,
            onLessonCompleted: () => completed = true,
            onCancel: () => cancelled = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Stage 0: LEARN
    expect(find.text('DAY 1'), findsOneWidget);
    expect(find.text('CORE CONCEPT (60-SECOND BRIEF)'), findsOneWidget);

    // Advance to Stage 1: SEE
    await tester.tap(find.text('Next: 2. See'));
    await tester.pumpAndSettle();
    expect(find.text('VISUAL PATTERN RECOGNITION'), findsOneWidget);

    // Advance to Stage 2: UNDERSTAND
    await tester.tap(find.text('Next: 3. Understand'));
    await tester.pumpAndSettle();
    expect(find.text('COMMON AMATEUR MISTAKES & REFUTATIONS'), findsOneWidget);

    // Back to Stage 1: SEE
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('VISUAL PATTERN RECOGNITION'), findsOneWidget);

    // Back to Stage 0: LEARN
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('CORE CONCEPT (60-SECOND BRIEF)'), findsOneWidget);

    // Cancel / Close dialog
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(cancelled, isTrue);
    expect(completed, isFalse);
  });
}
