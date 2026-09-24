import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:test/test.dart';

void main() {
  group('90-Day Curriculum Catalog Tests', () {
    test('Exactly 90 days exist with no gaps', () {
      final days = CurriculumCatalog.allDays;
      expect(days.length, equals(90));

      for (int i = 0; i < 90; i++) {
        expect(days[i].dayNumber, equals(i + 1));
        expect(days[i].title.isNotEmpty, isTrue);
        expect(days[i].learningObjectives.isNotEmpty, isTrue);
        expect(days[i].theoryMarkdown.isNotEmpty, isTrue);
        expect(days[i].exercises.isNotEmpty, isTrue);
      }
    });

    test('Weekly exams are scheduled on required milestone days', () {
      final expectedExamDays = [7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90];
      final exams = CurriculumCatalog.weeklyExams;

      expect(exams.length, equals(expectedExamDays.length));
      for (final dayNum in expectedExamDays) {
        final day = CurriculumCatalog.getDay(dayNum);
        expect(day.isWeeklyExam, isTrue, reason: 'Day $dayNum should be weekly exam');
        expect(day.examPassThreshold, equals(0.85));
      }
    });

    test('All exercise FENs parse cleanly into valid Boards', () {
      final days = CurriculumCatalog.allDays;
      for (final day in days) {
        for (final ex in day.exercises) {
          expect(FenParser.isValidFen(ex.fen), isTrue,
              reason: 'Day ${day.dayNumber} exercise ${ex.id} has invalid FEN: ${ex.fen}');
          final board = Board.fromFen(ex.fen);
          expect(board.activeColor, equals(ex.sideToPlay));
        }
      }
    });

    test('Day 1 and Day 90 integrity', () {
      final day1 = CurriculumCatalog.getDay(1);
      expect(day1.title, contains('Diagnostic'));
      expect(day1.exercises.length, greaterThanOrEqualTo(1));

      final day90 = CurriculumCatalog.getDay(90);
      expect(day90.title, contains('Certification'));
      expect(day90.isWeeklyExam, isTrue);
    });
  });
}
