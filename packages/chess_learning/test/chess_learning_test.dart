import 'package:chess_learning/chess_learning.dart';
import 'package:test/test.dart';

void main() {
  group('Skill Node & Mastery Gates Tests', () {
    test('Mastery gate requires strict thresholds', () {
      final node = SkillNode(
        id: 'forks_1',
        name: 'Knight Forks',
        axis: SkillAxis.tactics,
        knowledgeScore: 0.92,
        isolatedAccuracy: 0.95,
        mixedAccuracy: 0.88,
        realGameApplication: 0.82,
        retention7Day: 0.90,
        retention30Day: 0.85,
      );

      expect(MasteryGates.hasMastered(node), isTrue);

      // Drops below retention threshold
      node.retention30Day = 0.75;
      expect(MasteryGates.hasMastered(node), isFalse);
    });

    test('Node status updates correctly for weak and mastered states', () {
      final node = SkillNode(
        id: 'pins_1',
        name: 'Absolute Pins',
        axis: SkillAxis.tactics,
        recurrenceCount: 3,
        realGameApplication: 0.50,
      );

      MasteryGates.updateNodeStatus(node);
      expect(node.status, equals(SkillStatus.weak));
    });

    test('Radar values computed across 12 axes', () {
      final nodes = SkillAxis.values.map((axis) {
        return SkillNode(
          id: 'root_${axis.name}',
          name: axis.title,
          axis: axis,
          knowledgeScore: 0.8,
          isolatedAccuracy: 0.8,
        );
      }).toList();

      final radar = MasteryGates.computeRadarValues(nodes);
      expect(radar.keys.length, equals(12));
      for (final axis in SkillAxis.values) {
        expect(radar[axis], greaterThan(0.0));
      }
    });
  });

  group('Leitner Spaced Repetition Tests', () {
    test('Item advances through stages on success', () {
      final engine = LeitnerEngine();
      final item = ReviewItem(
        id: 'rev_1',
        fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        solutionSan: ['e4'],
        skillNodeId: 'forks_1',
        motif: 'Pawn Fork',
        explanation: 'Pawn attacks both minor pieces.',
      );

      engine.addItem(item);
      expect(item.stage, equals(0));

      // Correct answer
      engine.recordResult('rev_1', true);
      expect(item.stage, equals(1));
      expect(item.successStreak, equals(1));

      // Second correct answer
      engine.recordResult('rev_1', true);
      expect(item.stage, equals(2));

      // Failed answer -> drops stage
      engine.recordResult('rev_1', false);
      expect(item.stage, equals(1));
      expect(item.successStreak, equals(0));
      expect(item.failureCount, equals(1));
    });
  });

  group('Daily Planner Tests', () {
    test('Generates intensive 8-hour plan with serious game and self analysis', () {
      final plan = DailyPlanner.generatePlan(
        curriculumDay: 14,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: [],
      );

      expect(plan.curriculumDay, equals(14));
      expect(plan.blocks.any((b) => b.labType == 'serious_game'), isTrue);
      expect(plan.blocks.any((b) => b.labType == 'self_analysis'), isTrue);
      expect(plan.blocks.any((b) => b.primaryAxis == SkillAxis.tactics), isTrue);
    });

    test('Generates 15-minute express plan', () {
      final plan = DailyPlanner.generatePlan(
        curriculumDay: 30,
        availableBudget: const Duration(minutes: 15),
        currentSkillNodes: [],
      );

      expect(plan.blocks.length, equals(2));
      expect(plan.blocks.first.labType, equals('tactical_recognition'));
    });
  });
}
