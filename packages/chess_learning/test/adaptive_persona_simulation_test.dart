import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:test/test.dart';

void main() {
  group('Adaptive Learning Personas & Closed-Loop Pipeline Tests', () {
    // Helper to generate a baseline skill graph for a persona
    List<SkillNode> createPersonaNodes(Map<SkillAxis, double> profile) {
      return SkillAxis.values.map((axis) {
        final score = profile[axis] ?? 0.50;
        final node = SkillNode(
          id: 'node_${axis.name}',
          name: axis.title,
          axis: axis,
          knowledgeScore: score,
          isolatedAccuracy: score,
          mixedAccuracy: score,
          realGameApplication: score,
          retention7Day: score,
          retention30Day: score,
        );
        MasteryGates.updateNodeStatus(node);
        return node;
      }).toList();
    }

    test('1. Four Personas Receive Materially Different Daily Plans', () {
      // Persona 1: Beginner (~1000 Elo) - Low across the board, basic tactics and board vision
      final beginnerProfile = {for (var a in SkillAxis.values) a: 0.30};
      beginnerProfile[SkillAxis.tactics] = 0.25;
      beginnerProfile[SkillAxis.visualization] = 0.20;

      // Persona 2: Intermediate (~1500 Elo) - Solid tactics, terrible endgame and pawn structures
      final intermediateProfile = {for (var a in SkillAxis.values) a: 0.65};
      intermediateProfile[SkillAxis.tactics] = 0.80;
      intermediateProfile[SkillAxis.endgames] = 0.35;
      intermediateProfile[SkillAxis.pawnStructures] = 0.40;

      // Persona 3: Advanced (~2000 Elo) - High mastery, collapses under time pressure
      final advancedProfile = {for (var a in SkillAxis.values) a: 0.88};
      advancedProfile[SkillAxis.timeManagement] = 0.45;

      // Persona 4: Asymmetric-Weakness (~1700 Elo) - Lethal attack (0.92), zero defense (0.28)
      final asymmetricProfile = {for (var a in SkillAxis.values) a: 0.70};
      asymmetricProfile[SkillAxis.attack] = 0.92;
      asymmetricProfile[SkillAxis.defense] = 0.28;

      final beginnerNodes = createPersonaNodes(beginnerProfile);
      final intermediateNodes = createPersonaNodes(intermediateProfile);
      final advancedNodes = createPersonaNodes(advancedProfile);
      final asymmetricNodes = createPersonaNodes(asymmetricProfile);

      // Generate Day 15 plans for all four
      final planBeginner = DailyPlanner.generatePlan(
        curriculumDay: 15,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: beginnerNodes,
      );

      final planIntermediate = DailyPlanner.generatePlan(
        curriculumDay: 15,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: intermediateNodes,
      );

      final planAdvanced = DailyPlanner.generatePlan(
        curriculumDay: 15,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: advancedNodes,
      );

      final planAsymmetric = DailyPlanner.generatePlan(
        curriculumDay: 15,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: asymmetricNodes,
      );

      // Verify that plans are materially distinct in focus and block compositions
      expect(planBeginner.blocks.isNotEmpty, isTrue);
      expect(planIntermediate.blocks.isNotEmpty, isTrue);
      expect(planAdvanced.blocks.isNotEmpty, isTrue);
      expect(planAsymmetric.blocks.isNotEmpty, isTrue);

      // Intermediate must prioritize endgames or pawn structures due to weakness
      final intermEndgameBlocks = planIntermediate.blocks.where(
        (b) => b.primaryAxis == SkillAxis.endgames || b.primaryAxis == SkillAxis.pawnStructures,
      );
      expect(intermEndgameBlocks.isNotEmpty, isTrue);

      // Advanced must schedule time pressure blitz training due to timeManagement weakness
      final advTimeBlocks = planAdvanced.blocks.where((b) => b.primaryAxis == SkillAxis.timeManagement);
      expect(advTimeBlocks.isNotEmpty, isTrue);

      // Asymmetric must schedule defensive tenacity drills
      final asymDefenseBlocks = planAsymmetric.blocks.where((b) => b.primaryAxis == SkillAxis.defense);
      expect(asymDefenseBlocks.isNotEmpty, isTrue);
    });

    test('2. Closed-Loop Blunder Diagnosis -> Decay -> Queue -> Reassessment -> Mastery', () {
      final nodes = SkillAxis.values.map((axis) {
        return SkillNode(
          id: 'node_${axis.name}',
          name: axis.title,
          axis: axis,
          knowledgeScore: 0.75,
          isolatedAccuracy: 0.75,
          mixedAccuracy: 0.75,
          realGameApplication: 0.75,
          retention7Day: 0.75,
          retention30Day: 0.75,
          status: SkillStatus.learning,
        );
      }).toList();

      final board = Board.fromFen('r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1');
      final blunderMove = Move(from: Square.named('c4'), to: Square.named('e2')); // Misses mate
      final bestMove = Move(from: Square.named('f3'), to: Square.named('f7'));

      final evalBefore = EngineEvaluation(
        depth: 10,
        scoreCentipawns: 3000,
        bestMove: bestMove,
        sideToMove: PieceColor.white,
      );
      final evalAfter = EngineEvaluation(
        depth: 10,
        scoreCentipawns: -250,
        bestMove: Move(from: Square.named('e4'), to: Square.named('f2')),
        sideToMove: PieceColor.black,
      );

      // 1. Root Cause Classification
      final diagnosis = RootCauseClassifier.diagnose(
        boardBeforeMove: board,
        playedMove: blunderMove,
        evaluationBefore: evalBefore,
        evaluationAfter: evalAfter,
        clockRemaining: const Duration(seconds: 15),
      );

      expect(diagnosis.category, equals(RootCauseCategory.timePressure));
      expect(diagnosis.subCause, equals('time-pressure'));

      // 2. Weakness score decay
      final idx = nodes.indexWhere((n) => n.axis == SkillAxis.timeManagement);
      final node = nodes[idx];
      final decayedNode = node.copyWith(
        realGameApplication: 0.35,
        recurrenceCount: node.recurrenceCount + 1,
        status: SkillStatus.weak,
      );
      nodes[idx] = decayedNode;
      expect(MasteryGates.hasMastered(decayedNode), isFalse);

      // 3. Queue into Leitner SRS
      final leitner = LeitnerEngine();
      final item = ReviewItem(
        id: 'rev_time_1',
        skillNodeId: decayedNode.id,
        fen: diagnosis.evidenceFen ?? board.toFen(),
        solutionSan: ['Qxf7#'],
        motif: diagnosis.subCause,
        explanation: diagnosis.explanation,
        stage: 0,
        nextReviewDate: DateTime.now().subtract(const Duration(minutes: 1)),
      );
      leitner.addItem(item);
      expect(leitner.dueItems.length, equals(1));

      // 4. Daily Planner updates schedule
      final adaptivePlan = DailyPlanner.generatePlan(
        curriculumDay: 20,
        currentSkillNodes: nodes,
      );
      expect(adaptivePlan.blocks.any((b) => b.primaryAxis == SkillAxis.timeManagement), isTrue);

      // 5. Remediation successful -> Retest and Mastery Promotion
      final retestedNode = decayedNode.copyWith(
        knowledgeScore: 0.95,
        isolatedAccuracy: 0.94,
        mixedAccuracy: 0.90,
        realGameApplication: 0.88,
        retention7Day: 0.90,
        retention30Day: 0.86,
        recurrenceCount: 0,
        status: SkillStatus.mastered,
      );
      expect(MasteryGates.hasMastered(retestedNode), isTrue);
    });

    test('3. Failed Mastery Blocks Progression and Triggers Remediation', () {
      final node = SkillNode(
        id: 'node_tactics',
        name: 'Tactics',
        axis: SkillAxis.tactics,
        knowledgeScore: 0.60,
        isolatedAccuracy: 0.55,
        mixedAccuracy: 0.50,
        realGameApplication: 0.40,
        retention7Day: 0.50,
        retention30Day: 0.45,
      );

      // Must not pass
      expect(MasteryGates.hasMastered(node), isFalse);
      MasteryGates.updateNodeStatus(node);
      expect(node.status, isNot(equals(SkillStatus.mastered)));
    });
  });
}
