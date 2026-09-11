import 'package:chess_learning/chess_learning.dart';
import 'package:test/test.dart';

void main() {
  group('Deep Chess Learning Coverage & Engine Verification', () {
    test('SkillAxis and SkillStatus complete coverage', () {
      for (final axis in SkillAxis.values) {
        expect(axis.title, isNotEmpty);
        expect(axis.description, isNotEmpty);
      }

      for (final status in SkillStatus.values) {
        expect(status.label, isNotEmpty);
      }
    });

    test('SkillNode serialization, compositeScore and copyWith', () {
      final node = SkillNode(
        id: 'tactics_forks',
        name: 'Knight Forks',
        axis: SkillAxis.tactics,
        parentId: 'tactics_root',
        childIds: ['royal_fork'],
        knowledgeScore: 0.90,
        isolatedAccuracy: 0.85,
        mixedAccuracy: 0.80,
        realGameApplication: 0.75,
        retention7Day: 0.80,
        retention30Day: 0.70,
        responseTimeMs: 2500,
        recurrenceCount: 1,
        confidenceScore: 0.85,
        status: SkillStatus.practicing,
        lastPracticed: DateTime(2026, 1, 1),
      );

      expect(node.compositeScore, closeTo(0.80, 0.05));

      final json = node.toJson();
      final restored = SkillNode.fromJson(json);

      expect(restored.id, node.id);
      expect(restored.name, node.name);
      expect(restored.axis, node.axis);
      expect(restored.parentId, node.parentId);
      expect(restored.childIds, node.childIds);
      expect(restored.knowledgeScore, node.knowledgeScore);
      expect(restored.status, node.status);

      final modified = node.copyWith(
        knowledgeScore: 0.95,
        status: SkillStatus.mastered,
      );
      expect(modified.knowledgeScore, 0.95);
      expect(modified.status, SkillStatus.mastered);
      expect(modified.id, node.id);
    });

    test('MasteryGates threshold checks and status transitions', () {
      final passingNode = SkillNode(
        id: 'test_pass',
        name: 'Passing',
        axis: SkillAxis.tactics,
        knowledgeScore: 0.90,
        isolatedAccuracy: 0.90,
        mixedAccuracy: 0.85,
        realGameApplication: 0.80,
        retention7Day: 0.85,
        retention30Day: 0.80,
      );
      expect(MasteryGates.hasMastered(passingNode), isTrue);

      // Boundary fails on each dimension
      expect(MasteryGates.hasMastered(passingNode.copyWith(knowledgeScore: 0.89)), isFalse);
      expect(MasteryGates.hasMastered(passingNode.copyWith(isolatedAccuracy: 0.89)), isFalse);
      expect(MasteryGates.hasMastered(passingNode.copyWith(mixedAccuracy: 0.84)), isFalse);
      expect(MasteryGates.hasMastered(passingNode.copyWith(realGameApplication: 0.79)), isFalse);
      expect(MasteryGates.hasMastered(passingNode.copyWith(retention7Day: 0.84)), isFalse);
      expect(MasteryGates.hasMastered(passingNode.copyWith(retention30Day: 0.79)), isFalse);

      // Status transitions
      final node = passingNode.copyWith(
        lastPracticed: DateTime.now().subtract(const Duration(days: 20)),
      );
      MasteryGates.updateNodeStatus(node);
      expect(node.status, SkillStatus.decaying);

      final freshMastered = passingNode.copyWith(lastPracticed: DateTime.now());
      MasteryGates.updateNodeStatus(freshMastered);
      expect(freshMastered.status, SkillStatus.mastered);

      final weakNode1 = SkillNode(id: 'w1', name: 'Weak1', axis: SkillAxis.tactics, recurrenceCount: 3);
      MasteryGates.updateNodeStatus(weakNode1);
      expect(weakNode1.status, SkillStatus.weak);

      final weakNode2 = SkillNode(id: 'w2', name: 'Weak2', axis: SkillAxis.tactics, realGameApplication: 0.4);
      MasteryGates.updateNodeStatus(weakNode2);
      expect(weakNode2.status, SkillStatus.weak);

      final practicingNode = SkillNode(id: 'p', name: 'Practicing', axis: SkillAxis.tactics, isolatedAccuracy: 0.80);
      MasteryGates.updateNodeStatus(practicingNode);
      expect(practicingNode.status, SkillStatus.practicing);

      final learningNode = SkillNode(id: 'l', name: 'Learning', axis: SkillAxis.tactics, knowledgeScore: 0.50);
      MasteryGates.updateNodeStatus(learningNode);
      expect(learningNode.status, SkillStatus.learning);

      final unseenNode = SkillNode(id: 'u', name: 'Unseen', axis: SkillAxis.tactics);
      MasteryGates.updateNodeStatus(unseenNode);
      expect(unseenNode.status, SkillStatus.unseen);

      // Radar and overall computation
      expect(MasteryGates.computeOverallMasteryPercentage([]), 0.0);
      expect(MasteryGates.computeOverallMasteryPercentage([freshMastered, unseenNode]), 50.0);

      final radar = MasteryGates.computeRadarValues([freshMastered]);
      expect(radar[SkillAxis.tactics], greaterThan(0.8));
      expect(radar[SkillAxis.openings], 0.0);
    });

    test('ReviewItem and LeitnerEngine spaced repetition progression', () {
      final item = ReviewItem(
        id: 'rev_1',
        fen: '8/8/8/8/8/4k3/8/4K3 w - - 0 1',
        solutionSan: ['Kd1'],
        skillNodeId: 'tactics_forks',
        motif: 'Opposition',
        explanation: 'Take direct opposition.',
      );

      expect(item.stage, 0);
      expect(item.successStreak, 0);
      expect(item.failureCount, 0);

      // Success steps through all stages (0 -> 1 -> 2 -> 3 -> 4 -> 5)
      for (int i = 0; i < 6; i++) {
        item.recordAttempt(isCorrect: true);
      }
      expect(item.stage, 5);
      expect(item.successStreak, 6);

      // Failure shrinks stage back
      item.recordAttempt(isCorrect: false);
      expect(item.stage, 1);
      expect(item.successStreak, 0);
      expect(item.failureCount, 1);

      // Stage 1 failure shrinks to 0
      item.recordAttempt(isCorrect: false);
      expect(item.stage, 0);

      // JSON roundtrip
      final json = item.toJson();
      final restored = ReviewItem.fromJson(json);
      expect(restored.id, item.id);
      expect(restored.fen, item.fen);
      expect(restored.solutionSan, item.solutionSan);

      // LeitnerEngine management
      final engine = LeitnerEngine();
      expect(engine.overallRetentionRate, 1.0);

      engine.addItem(item);
      expect(engine.allItems.length, 1);

      // Duplicate replacement
      engine.addItem(item);
      expect(engine.allItems.length, 1);

      engine.recordResult('rev_1', true);
      expect(engine.overallRetentionRate, greaterThan(0.0));

      expect(() => engine.recordResult('missing', true), throwsStateError);
    });

    test('DailyPlanner schedule generation across budgets and curriculum days', () {
      final nodes = [
        SkillNode(id: 'n1', name: 'Forks', axis: SkillAxis.tactics, status: SkillStatus.weak, recurrenceCount: 2),
        SkillNode(id: 'n2', name: 'Opposition', axis: SkillAxis.endgames, status: SkillStatus.decaying),
      ];

      // 1. Express budget (<= 15 min)
      final plan15 = DailyPlanner.generatePlan(
        curriculumDay: 1,
        availableBudget: const Duration(minutes: 15),
        currentSkillNodes: nodes,
      );
      expect(plan15.blocks.length, 2);
      expect(plan15.calculatedTotalDuration.inMinutes, 15);

      // 2. Standard budget (<= 60 min)
      final plan45 = DailyPlanner.generatePlan(
        curriculumDay: 20,
        availableBudget: const Duration(minutes: 45),
        currentSkillNodes: nodes,
      );
      expect(plan45.blocks.length, 3);
      expect(plan45.blocks.first.toJson()['title'], isNotEmpty);

      // 3. Full intensive budget (> 60 min)
      final planFull = DailyPlanner.generatePlan(
        curriculumDay: 50,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: nodes,
      );
      expect(planFull.blocks.length, 8);
      expect(planFull.primaryFocus, contains('Endgame'));

      // Verify day-to-axis and day-to-lab mapping
      final testDays = [1, 10, 20, 35, 50, 60, 68, 75, 82, 90];
      for (final day in testDays) {
        final axis = DailyPlanner.axisForDay(day);
        final lab = DailyPlanner.labForDay(day);
        expect(axis, isNotNull);
        expect(lab, isNotEmpty);
      }
    });
  });
}
