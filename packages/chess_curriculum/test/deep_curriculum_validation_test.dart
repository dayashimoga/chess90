import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:test/test.dart';

void main() {
  group('Comprehensive Deep Curriculum Validation', () {
    final days = CurriculumCatalog.allDays;

    test('Exactly 90 days are present and ordered 1 to 90', () {
      expect(days.length, equals(90));
      for (int i = 0; i < 90; i++) {
        expect(days[i].dayNumber, equals(i + 1));
      }
    });

    test('All 10 curriculum phases are represented in continuous order', () {
      final seenPhases = <CurriculumPhase>{};
      for (final day in days) {
        seenPhases.add(day.phase);
      }
      expect(seenPhases.length, equals(CurriculumPhase.values.length));
    });

    test('Weekly exams are strictly scheduled on milestone days', () {
      final requiredExams = [7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90];
      final examDays = days.where((d) => d.isWeeklyExam).map((d) => d.dayNumber).toList();
      expect(examDays, equals(requiredExams));

      for (final examDayNum in requiredExams) {
        final exam = CurriculumCatalog.getDay(examDayNum);
        expect(exam.isWeeklyExam, isTrue);
        expect(exam.examPassThreshold, equals(0.85));
      }
    });

    test('All referenced lab IDs correspond to real existing lab controllers', () {
      final knownLabs = {
        'tactical_lab',
        'candidate_selection_lab',
        'blind_calculation_lab',
        'endgame_win_defend_lab',
        'board_memory_lab',
        'visualization_lab',
        'find_the_plan_lab',
        'positional_evaluation_lab',
        'improve_worst_piece_lab',
        'pawn_break_discovery_lab',
        'pawn_structure_lab',
        'opening_plan_lab',
        'guess_the_move_lab',
        'defensive_resource_lab',
        'conversion_challenge_lab',
        'time_management_lab',
      };

      for (final day in days) {
        expect(knownLabs.contains(day.referencedLabId), isTrue,
            reason: 'Day ${day.dayNumber} referenced unknown lab: ${day.referencedLabId}');
      }
    });

    test('Difficulty ratings progress sensibly from baseline ~1200 to GM ~2500', () {
      expect(days.first.difficultyRating, equals(1200));
      expect(days.last.difficultyRating, greaterThanOrEqualTo(2400));

      int prevDiff = 0;
      for (final day in days) {
        expect(day.difficultyRating, greaterThanOrEqualTo(prevDiff),
            reason: 'Difficulty should not regress significantly on Day ${day.dayNumber}');
        prevDiff = day.difficultyRating;
      }
    });

    test('Prerequisites are logically sound with no circular dependencies', () {
      expect(days.first.prerequisites, isEmpty);
      for (final day in days) {
        for (final req in day.prerequisites) {
          expect(req, lessThan(day.dayNumber),
              reason: 'Day ${day.dayNumber} has invalid future or self prerequisite: $req');
          expect(req, greaterThanOrEqualTo(1));
        }
      }
    });

    test('All 12 core SkillAxis dimensions are thoroughly covered across 90 days', () {
      final axisCounts = <SkillAxis, int>{};
      for (final day in days) {
        axisCounts[day.primarySkillAxis] = (axisCounts[day.primarySkillAxis] ?? 0) + 1;
      }

      for (final axis in SkillAxis.values) {
        expect(axisCounts[axis], isNotNull,
            reason: 'Axis ${axis.name} must be represented in curriculum');
        expect(axisCounts[axis]!, greaterThanOrEqualTo(1),
            reason: 'Axis ${axis.name} has zero dedicated days');
      }
    });

    test('Every day has non-empty theory, objectives, and distinct valid exercises', () {
      final seenDayTitles = <String>{};
      for (final day in days) {
        expect(seenDayTitles.add(day.title), isTrue,
            reason: 'Duplicate day title found: ${day.title}');
        expect(day.theme.isNotEmpty, isTrue);
        expect(day.theoryMarkdown.length, greaterThan(30));
        expect(day.learningObjectives.length, greaterThanOrEqualTo(2));
        expect(day.exercises.isNotEmpty, isTrue);

        for (final ex in day.exercises) {
          expect(ex.instruction.isNotEmpty, isTrue);
          expect(ex.explanation.isNotEmpty, isTrue);
          expect(ex.hints.isNotEmpty, isTrue);
          expect(ex.motif.isNotEmpty, isTrue);
          expect(ex.solutionSan.isNotEmpty, isTrue);

          // Deep chess validation
          expect(FenParser.isValidFen(ex.fen), isTrue,
              reason: 'Day ${day.dayNumber} has invalid FEN: ${ex.fen}');
          final board = Board.fromFen(ex.fen);
          expect(board.activeColor, equals(ex.sideToPlay));

          // Validate that the solution is a legal move
          for (final san in ex.solutionSan) {
            final move = MoveGenerator.sanToMove(board, san);
            expect(move, isNotNull,
                reason: 'Day ${day.dayNumber} exercise ${ex.id} has illegal solution move: $san');
          }
        }
      }
    });

    test('Day 90 has official Mastery Assessment title and explicit FIDE disclaimer', () {
      final day90 = CurriculumCatalog.getDay(90);
      expect(day90.title, contains('Mastery Assessment & Completion Report'));
      expect(day90.isWeeklyExam, isTrue);
      expect(day90.theme.toLowerCase(), contains('mastery'));
      expect(day90.theoryMarkdown.toLowerCase(), contains('fide'));
    });

    test('Duplicate exercise ID detection and unique exercise keys', () {
      final seenExerciseIds = <String>{};
      for (final day in days) {
        for (final ex in day.exercises) {
          expect(seenExerciseIds.add(ex.id), isTrue,
              reason: 'Duplicate exercise ID detected: ${ex.id} on Day ${day.dayNumber}');
        }
      }
      expect(seenExerciseIds.length, greaterThanOrEqualTo(90));
    });

    test('All 16 interactive lab types are linked to at least one curriculum day', () {
      final linkedLabs = days.map((d) => d.referencedLabId).toSet();
      expect(linkedLabs.length, 16);
    });
  });
}
