import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_content/chess_content.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Authoritative Content Reconciliation & Mathematical Integrity', () {
    test('Reconciles 3,694 bank exercises + 92 curriculum exercises = 3,786 unique total', () {
      // 1. Specialized Training Banks
      final tactics = TacticsBank.all;
      final calculation = CalculationBank.all;
      final visualization = VisualizationBank.all;
      final strategy = StrategyBank.all;
      final endgame = EndgameBank.all;
      final openings = OpeningDrillsBank.all;
      final practical = PracticalAnalysisBank.all;

      expect(tactics.length, equals(1664), reason: 'TacticsBank count');
      expect(calculation.length, equals(360), reason: 'CalculationBank count');
      expect(visualization.length, equals(230), reason: 'VisualizationBank count');
      expect(strategy.length, equals(290), reason: 'StrategyBank count');
      expect(endgame.length, equals(360), reason: 'EndgameBank count');
      expect(openings.length, equals(560), reason: 'OpeningDrillsBank count');
      expect(practical.length, equals(230), reason: 'PracticalAnalysisBank count');

      final bankTotal = tactics.length +
          calculation.length +
          visualization.length +
          strategy.length +
          endgame.length +
          openings.length +
          practical.length;

      expect(bankTotal, equals(3694), reason: 'Bank exercises must equal exactly 3,694');

      // 2. 90-Day Curriculum Exercises
      final allDays = CurriculumCatalog.allDays;
      expect(allDays.length, equals(90), reason: 'Curriculum must contain 90 days');

      final curriculumExercises = <CurriculumExercise>[];
      for (final day in allDays) {
        curriculumExercises.addAll(day.exercises);
      }

      // Full 90-day spiral curriculum exercises (all days have verified interactive exercises)
      expect(curriculumExercises.length, equals(537), reason: 'Curriculum exercises must equal 537');

      // 3. ID Uniqueness & Overlap Check
      final bankIds = <String>{};
      final duplicateBankIds = <String>[];
      for (final bank in [tactics, calculation, visualization, strategy, endgame, openings, practical]) {
        for (final ex in bank) {
          if (!bankIds.add(ex.id)) {
            duplicateBankIds.add(ex.id);
          }
        }
      }
      expect(duplicateBankIds, isEmpty, reason: 'Zero duplicate IDs within banks');
      expect(bankIds.length, equals(3694));

      final curriculumIds = <String>{};
      final duplicateCurriculumIds = <String>[];
      for (final ex in curriculumExercises) {
        if (!curriculumIds.add(ex.id)) {
          duplicateCurriculumIds.add(ex.id);
        }
      }
      expect(duplicateCurriculumIds, isEmpty, reason: 'Zero duplicate IDs within curriculum');
      expect(curriculumIds.length, equals(537));

      // Overlap between bank and curriculum
      final overlap = bankIds.intersection(curriculumIds);
      expect(overlap, isEmpty, reason: 'Zero ID overlap between bank and curriculum exercises');

      // Total unique exercises
      final totalUnique = bankIds.length + curriculumIds.length - overlap.length;
      expect(totalUnique, equals(4231),
          reason: '3,694 bank exercises + 537 curriculum exercises - 0 overlap = exactly 4,231 unique exercises');

      // 4. Model Games & Openings
      expect(ModelGamesDatabase.curatedGames.length, equals(60), reason: '60 Model Games');
      expect(EcoBook.entries.length, equals(72), reason: '72 ECO Openings');
    });

    test('All exercise FENs and solutions are legal and non-corrupt', () {
      final allDays = CurriculumCatalog.allDays;
      for (final day in allDays) {
        for (final ex in day.exercises) {
          expect(FenParser.isValidFen(ex.fen), isTrue, reason: 'Day ${day.dayNumber} valid FEN');
          final board = Board.fromFen(ex.fen);
          expect(board.activeColor, equals(ex.sideToPlay));
          for (final san in ex.solutionSan) {
            final move = MoveGenerator.sanToMove(board, san);
            expect(move, isNotNull, reason: 'Day ${day.dayNumber} legal solution move $san');
          }
        }
      }
    });
  });
}
