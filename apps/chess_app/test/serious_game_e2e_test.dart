import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Serious Game & Tournament Mode E2E Cognitive Loop Test', () {
    late Directory tempDir;
    late String dbFilePath;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('tournament_e2e_test_');
      dbFilePath = '${tempDir.path}${Platform.pathSeparator}tournament.db';
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('Complete E2E: new game -> play -> save -> reopen -> self-analyze -> engine audit -> root cause -> skill update -> retraining generated', () async {
      // 1. Initial Storage Session
      final repo1 = StorageRepository(dbPath: dbFilePath);
      expect(repo1.getGames(), isEmpty);

      // 2. Play a Tournament Simulation game (45+15)
      // Scholar's Mate trap game
      const pgnMoves = '1. e4 e5 2. Bc4 Nc6 3. Qh5 Nf6 4. Qxf7# 1-0';
      final thoughtNotes = {
        1: 'Stake claim in the center with 1.e4.',
        2: 'Develop bishop to active diagonal targeting f7.',
        3: 'Create direct double-attack threat on e5 and f7.',
        4: 'Deliver checkmate on f7 square.',
      };

      final gameId = 'tournament_game_${DateTime.now().millisecondsSinceEpoch}';
      final playedGame = GameRecord(
        id: gameId,
        pgn: '''[Event "Tournament Mode 45+15"]
[Site "ChessMaster Local"]
[Date "2026.09.10"]
[Round "1"]
[White "Candidate Master"]
[Black "Engine Opponent"]
[Result "1-0"]
[TimeControl "45+15"]

$pgnMoves
''',
        playedDate: DateTime.now(),
        whitePlayer: 'Candidate Master',
        blackPlayer: 'Engine Opponent',
        result: '1-0',
        timeControl: 'Classical 45+15',
        selfAnalysisNotes: thoughtNotes,
      );

      // Save game
      repo1.saveGame(playedGame);
      expect(repo1.getGames().length, equals(1));

      // 3. Reopen from disk (Simulating app restart / crash recovery)
      final repo2 = StorageRepository(dbPath: dbFilePath);
      final reopenedGames = repo2.getGames();
      expect(reopenedGames.length, equals(1));
      final recoveredGame = reopenedGames.first;
      expect(recoveredGame.id, equals(gameId));
      expect(recoveredGame.selfAnalysisNotes[3], contains('double-attack threat'));

      // 4. Human Self-Analysis
      // Player annotates move 3 (...Nf6?? was the fatal opponent blunder)
      final pgnParsed = PgnParser.parse(recoveredGame.pgn)!;
      expect(pgnParsed.moves.length, equals(7)); // 7 plies total

      // 5. Engine Analysis
      final engine = NativeStockfishEngine.isSupported
          ? NativeStockfishEngine()
          : EmbeddedHeuristicEngine();
      await engine.initialize();

      // Analyze ply 5 (position before 3...Nf6)
      final boardBeforeBlunder = Board.fromFen('r1bqkbnr/pppp1ppp/2n5/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR b KQkq - 3 3');
      await engine.setPosition(boardBeforeBlunder.toFen());
      final evalBefore = await engine.evaluate(depth: 3);

      // Analyze position after 3...Nf6??
      final boardAfterBlunder = Board.fromFen('r1bqkb1r/pppp1ppp/2n2n2/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 4 4');
      await engine.setPosition(boardAfterBlunder.toFen());
      final evalAfter = await engine.evaluate(depth: 3);

      // 6. Hierarchical Root-Cause Diagnosis
      final diagnosis = RootCauseClassifier.diagnose(
        boardBeforeMove: boardBeforeBlunder,
        playedMove: MoveGenerator.sanToMove(boardBeforeBlunder, 'Nf6')!,
        evaluationBefore: evalBefore,
        evaluationAfter: evalAfter,
        userSelfAnalysisNote: 'I thought developing knight to f6 was natural.',
      );

      expect(diagnosis.quality, equals(MoveQuality.blunder));
      expect(diagnosis.primaryDomain, equals(CognitiveDomain.tactics));
      expect(diagnosis.subCause, isNotNull);
      expect(diagnosis.evidenceFen, isNotEmpty);

      // 7. Skill Update (Decaying the blundered skill node)
      final nodes = repo2.getSkillNodes();
      final tacticsNode = nodes.firstWhere((n) => n.axis == SkillAxis.tactics);
      final originalAccuracy = tacticsNode.isolatedAccuracy;

      final updatedTacticsNode = tacticsNode.copyWith(
        isolatedAccuracy: (originalAccuracy - 0.15).clamp(0.0, 1.0),
        recurrenceCount: tacticsNode.recurrenceCount + 1,
        status: SkillStatus.weak,
      );
      repo2.saveSkillNode(updatedTacticsNode);

      // Verify node was updated and marked weak
      final refreshedNodes = repo2.getSkillNodes();
      final refreshedTactics = refreshedNodes.firstWhere((n) => n.axis == SkillAxis.tactics);
      expect(refreshedTactics.status, equals(SkillStatus.weak));
      expect(refreshedTactics.recurrenceCount, equals(1));

      // 8. Adaptive Retraining Plan Generated
      final plan = DailyPlanner.generatePlan(
        curriculumDay: 15,
        availableBudget: const Duration(hours: 8),
        currentSkillNodes: refreshedNodes,
      );

      // Retraining block must prioritize the weak tactics node
      expect(plan.blocks.any((b) => b.labType == 'weakness_retraining'), isTrue);
      final retrainingBlock = plan.blocks.firstWhere((b) => b.labType == 'weakness_retraining');
      expect(retrainingBlock.primaryAxis, equals(SkillAxis.tactics));
      expect(retrainingBlock.objective, contains('blundered patterns'));

      await engine.dispose();
    });
  });
}
