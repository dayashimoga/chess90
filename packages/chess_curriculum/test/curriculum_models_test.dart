import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:test/test.dart';

void main() {
  group('Curriculum Models Serialization & Phase Tests', () {
    test('CurriculumPhase mapping for all 90 days', () {
      for (int day = 1; day <= 90; day++) {
        final phase = CurriculumPhase.forDay(day);
        expect(phase, isNotNull);
        expect(phase.title, isNotEmpty);
      }
    });

    test('CurriculumDay and CurriculumExercise JSON serialization roundtrip', () {
      const exercise = CurriculumExercise(
        id: 'ex_1',
        fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        sideToPlay: PieceColor.white,
        instruction: 'Find the best opening move.',
        solutionSan: ['e4'],
        explanation: 'Control the center.',
        hints: ['Advance king pawn.'],
        motif: 'Central Control',
        isNoTacticPosition: false,
      );

      final exJson = exercise.toJson();
      final exRestored = CurriculumExercise.fromJson(exJson);
      expect(exRestored.id, exercise.id);
      expect(exRestored.fen, exercise.fen);
      expect(exRestored.sideToPlay, exercise.sideToPlay);
      expect(exRestored.solutionSan, exercise.solutionSan);

      final day = CurriculumDay(
        dayNumber: 1,
        title: 'Day 1: Diagnostic',
        phase: CurriculumPhase.phase1Diagnostic,
        theme: 'Baseline Diagnostic',
        learningObjectives: ['Determine starting rating', 'Find tactical gaps'],
        theoryMarkdown: '# Day 1 Theory',
        exercises: [exercise],
        primarySkillAxis: SkillAxis.tactics,
        referencedLabId: 'tactical_lab',
        difficultyRating: 1400,
        prerequisites: [],
      );

      final dayJson = day.toJson();
      final dayRestored = CurriculumDay.fromJson(dayJson);
      expect(dayRestored.dayNumber, day.dayNumber);
      expect(dayRestored.title, day.title);
      expect(dayRestored.phase, day.phase);
      expect(dayRestored.exercises.length, 1);
      expect(dayRestored.referencedLabId, 'tactical_lab');
    });
  });
}
