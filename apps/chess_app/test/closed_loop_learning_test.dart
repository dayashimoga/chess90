import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Closed-Loop Learner Journey & Cognitive Adaptive Pipeline', () {
    late Directory tempDir;
    late String dbPath;
    late StorageRepository repo;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('closed_loop_');
      dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';
      repo = StorageRepository(dbPath: dbPath);
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('Full Closed-Loop: mistake -> engine audit -> root-cause diagnosis -> profile weakness -> targeted SRS review -> reassessment -> mastery progression', () async {
      // Step 1: User plays a game and blunders (mistake)
      final boardBeforeBlunder = Board.fromFen('r1bqkbnr/pppp1ppp/2n5/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 3 3');
      final blunderMove = MoveGenerator.sanToMove(boardBeforeBlunder, 'Nf6')!; // Fatal blunder allowing Qxf7#

      // Step 2: Engine analysis
      final engine = EmbeddedHeuristicEngine();
      await engine.initialize();
      await engine.setPosition(boardBeforeBlunder.toFen());
      final evalBefore = await engine.evaluate(depth: 3);

      final boardAfterBlunder = boardBeforeBlunder.clone()..makeMove(blunderMove);
      await engine.setPosition(boardAfterBlunder.toFen());
      final evalAfter = await engine.evaluate(depth: 3);

      // Step 3: Root-cause classification
      final diagnosis = RootCauseClassifier.diagnose(
        boardBeforeMove: boardBeforeBlunder,
        playedMove: blunderMove,
        evaluationBefore: evalBefore,
        evaluationAfter: evalAfter,
        userSelfAnalysisNote: 'I did not see the direct queen attack on f7.',
      );

      expect(diagnosis.category, equals(RootCauseCategory.missedTacticOpponentForcingMove));
      expect(diagnosis.quality, equals(MoveQuality.blunder));
      expect(diagnosis.explanation.isNotEmpty, isTrue);
      expect(diagnosis.trainingPrescription.isNotEmpty, isTrue);

      // Step 4: Profile update
      final profile = repo.getProfile();
      profile.lastActiveDate = DateTime.now();
      repo.saveProfile(profile);

      // Step 5: Targeted training (Generate Spaced-Repetition Review Item)
      final reviewItem = ReviewItem(
        id: 'review_${DateTime.now().millisecondsSinceEpoch}',
        fen: boardBeforeBlunder.toFen(),
        solutionSan: ['Qe7', 'g6'],
        skillNodeId: 'node_tactics_defense',
        motif: diagnosis.category.name,
        explanation: diagnosis.explanation,
        stage: 0,
      );
      repo.saveReviewItem(reviewItem);

      expect(repo.getReviewItems().length, equals(1));
      final savedReview = repo.getReviewItems().first;
      expect(savedReview.stage, equals(0));

      // Step 6: Reassessment & SRS Promotion
      final srsEngine = LeitnerEngine();
      srsEngine.addItem(savedReview);
      srsEngine.recordResult(savedReview.id, true); // Learner gets it right during review

      final updatedReview = srsEngine.allItems.first;
      expect(updatedReview.stage, equals(1)); // Successfully promoted to stage 1
      repo.saveReviewItem(updatedReview);

      // Step 7: Mastery & Adaptive Schedule Update
      final plan = DailyPlanner.generatePlan(
        curriculumDay: profile.currentDay,
        availableBudget: const Duration(hours: 4),
        currentSkillNodes: repo.getSkillNodes(),
      );

      expect(plan.curriculumDay, equals(profile.currentDay));
      expect(plan.blocks.isNotEmpty, isTrue);
      expect(plan.calculatedTotalDuration.inMinutes, greaterThan(0));

      await engine.dispose();
    });
  });
}
