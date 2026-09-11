import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:test/test.dart';

void main() {
  group('Adaptive Learning End-to-End Feedback Loop Tests', () {
    test('Game error translates to root-cause diagnosis, skill decay, and planner time reallocation', () {
      // 1. Initial Skill Graph: All 12 axes start in learning status
      final nodes = SkillAxis.values.map((axis) {
        return SkillNode(
          id: 'node_${axis.name}',
          name: axis.title,
          axis: axis,
          knowledgeScore: 0.70,
          isolatedAccuracy: 0.70,
          mixedAccuracy: 0.70,
          realGameApplication: 0.70,
          retention7Day: 0.70,
          retention30Day: 0.70,
          status: SkillStatus.learning,
        );
      }).toList();

      // Verify initial baseline plan on Day 10 (Tactics Phase)
      final initialPlan = DailyPlanner.generatePlan(
        curriculumDay: 10,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: nodes,
      );
      expect(initialPlan.blocks.isNotEmpty, isTrue);

      // 2. User plays a game and blunders under time pressure:
      // Board state before move
      final board = Board.fromFen('r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1');
      final playedBlunder = Move(from: Square.named('c4'), to: Square.named('e2')); // ignores mate in 1
      final engineBest = Move(from: Square.named('f3'), to: Square.named('f7'));

      final evalBefore = EngineEvaluation(
        depth: 8,
        scoreCentipawns: 3000,
        bestMove: engineBest,
        sideToMove: PieceColor.white,
      );
      final evalAfter = EngineEvaluation(
        depth: 8,
        scoreCentipawns: -200,
        bestMove: Move(from: Square.named('e4'), to: Square.named('f2')),
        sideToMove: PieceColor.black,
      );

      // Diagnose blunder using RootCauseClassifier
      final diagnosis = RootCauseClassifier.diagnose(
        boardBeforeMove: board,
        playedMove: playedBlunder,
        evaluationBefore: evalBefore,
        evaluationAfter: evalAfter,
        clockRemaining: const Duration(seconds: 18), // Extreme time pressure!
      );

      expect(diagnosis.category, equals(RootCauseCategory.timePressure));
      expect(diagnosis.primaryDomain, equals(CognitiveDomain.psychological));
      expect(diagnosis.subCause, equals('time-pressure'));
      expect(diagnosis.prescribedLab, equals('time_management'));

      // 3. Update Skill Graph: Penalize time management node
      final timeNodeIndex = nodes.indexWhere((n) => n.axis == SkillAxis.timeManagement);
      final oldTimeNode = nodes[timeNodeIndex];
      final penalizedTimeNode = oldTimeNode.copyWith(
        realGameApplication: 0.40,
        recurrenceCount: oldTimeNode.recurrenceCount + 1,
        status: SkillStatus.weak,
      );
      nodes[timeNodeIndex] = penalizedTimeNode;

      // 4. Enlist in Leitner Spaced Repetition (Stage 0/1)
      final leitner = LeitnerEngine();
      final reviewItem = ReviewItem(
        id: 'error_time_mgmt_1',
        skillNodeId: 'node_${SkillAxis.timeManagement.name}',
        fen: diagnosis.evidenceFen ?? board.toFen(),
        solutionSan: [engineBest.uci],
        motif: diagnosis.subCause,
        explanation: diagnosis.explanation,
        stage: 0,
        nextReviewDate: DateTime.now().subtract(const Duration(minutes: 5)),
      );
      leitner.addItem(reviewItem);
      expect(leitner.dueItems.length, equals(1));

      // 5. Daily Planner automatically reallocates schedule time to the diagnosed weakness
      final adaptivePlan = DailyPlanner.generatePlan(
        curriculumDay: 11,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: nodes,
      );

      // Must have scheduled priority time for the weak timeManagement axis
      final weakAxisBlock = adaptivePlan.blocks.where((b) => b.primaryAxis == SkillAxis.timeManagement).toList();
      expect(weakAxisBlock.isNotEmpty, isTrue);

      // 6. User Retests and Retains: Advance in Leitner queue
      leitner.recordResult(reviewItem.id, true);
      expect(reviewItem.stage, equals(1)); // Promoted from 0 to 1!

      // 7. Retest failure shrinks back
      leitner.recordResult(reviewItem.id, false);
      expect(reviewItem.stage, equals(0)); // Demoted back to 0!
    });
  });
}
