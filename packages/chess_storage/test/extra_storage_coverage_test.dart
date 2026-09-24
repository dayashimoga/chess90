import 'dart:convert';
import 'dart:io';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:test/test.dart';

void main() {
  group('Extra Storage & Serialization Deep Coverage', () {
    test('GameSession full lifecycle and serialization', () {
      final session = GameSession.newGame(
        id: 'sess_1',
        timeControl: '10+0',
        playerColor: 'white',
        opponentName: 'Stockfish 19',
        isVsEngine: true,
        engineElo: 1800,
      );

      expect(session.id, equals('sess_1'));
      expect(session.moveSanList, isEmpty);

      // Record moves
      session.recordMove(
        san: 'e4',
        uci: 'e2e4',
        newFen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
        elapsedMs: 1200,
        whiteTime: 598,
        blackTime: 600,
      );
      session.thoughtNotes[1] = 'First move';
      session.engineEvaluations[1] = 0.3;

      session.recordMove(
        san: 'e5',
        uci: 'e7e5',
        newFen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
        elapsedMs: 800,
        whiteTime: 598,
        blackTime: 599,
      );
      session.engineEvaluations[2] = 0.2;

      session.diagnosedErrors.add({
        'ply': 2,
        'fen': session.currentFen,
        'playedMove': 'e5',
        'bestMove': 'c5',
        'evaluationLoss': 0.4,
        'concept': 'Opening Principle',
        'explanation': 'Sicilian Defense allows fighting for center',
      });

      session.completeGame('1-0');
      expect(session.isCompleted, isTrue);
      expect(session.result, equals('1-0'));
      expect(session.pgn, contains('1. e4 e5'));

      final pgnGame = session.toPgnGame();
      expect(pgnGame.headers['White'], equals('User'));

      final cloned = session.clone();
      expect(cloned.id, equals(session.id));
      expect(cloned.moveSanList.length, equals(2));
      expect(cloned.diagnosedErrors.length, equals(1));
      expect(cloned.engineEvaluations[1], equals(0.3));

      final json = session.toJson();
      final restored = GameSession.fromJson(json);
      expect(restored.id, equals('sess_1'));
      expect(restored.moveSanList, equals(['e4', 'e5']));
      expect(restored.moveUciList, equals(['e2e4', 'e7e5']));
      expect(restored.moveTimesMs, equals([1200, 800]));
      expect(restored.engineEvaluations[1], equals(0.3));
      expect(restored.thoughtNotes[1], equals('First move'));
      expect(restored.diagnosedErrors.length, equals(1));
    });

    test('LocalDatabase full backup export, import, and error handling', () {
      final db = LocalDatabase(); // in-memory

      final profile = db.getProfile();
      profile.username = 'GrandmasterTester';
      profile.boardScaleMultiplier = 0.95;
      profile.sidePanelCollapsed = true;
      db.saveProfile(profile);

      final session = GameSession.newGame(id: 'completed_game_1');
      session.recordMove(
        san: 'd4',
        uci: 'd2d4',
        newFen: 'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 0 1',
        elapsedMs: 1500,
        whiteTime: 900,
        blackTime: 900,
      );
      session.completeGame('1-0');
      db.saveActiveGameSession(session);
      expect(db.getActiveGameSession(), isNotNull);

      db.saveCompletedGame(session);
      expect(db.getGameHistory().length, equals(1));
      expect(db.getGameHistory().first.id, equals('completed_game_1'));

      db.clearActiveGameSession();
      expect(db.getActiveGameSession(), isNull);

      // Export full backup
      final backupJson = db.exportFullBackupJson();
      expect(backupJson, contains('GrandmasterTester'));

      // Create new db and import
      final newDb = LocalDatabase();
      newDb.importFullBackupJson(backupJson);
      expect(newDb.getProfile().username, equals('GrandmasterTester'));
      expect(newDb.getGameHistory().length, equals(1));

      // Test CorruptBackupException on invalid JSON
      expect(
        () => newDb.importFullBackupJson('invalid json string {['),
        throwsA(isA<CorruptBackupException>()),
      );

      // Test CorruptBackupException on non-map JSON
      expect(
        () => newDb.importFullBackupJson(jsonEncode(['not', 'a', 'map'])),
        throwsA(isA<CorruptBackupException>()),
      );

      // Test CorruptBackupException on missing checksum/schema
      expect(
        () => newDb.importFullBackupJson(jsonEncode({'schemaVersion': 999})),
        throwsA(isA<CorruptBackupException>()),
      );
    });

    test('GameRecord, UnfinishedGame, and UserProfile serialization edge cases', () {
      final record = GameRecord(
        id: 'rec_1',
        pgn: '1. e4 e5',
        playedDate: DateTime.now(),
        whitePlayer: 'User',
        blackPlayer: 'Stockfish',
        result: '1-0',
        timeControl: '15+10',
        selfAnalysisNotes: {1: 'Good start'},
        diagnosedErrors: [{'ply': 1, 'evalLoss': 0.1}],
      );
      final recJson = record.toJson();
      final recRestored = GameRecord.fromJson(recJson);
      expect(recRestored.id, equals('rec_1'));
      expect(recRestored.result, equals('1-0'));
      expect(recRestored.selfAnalysisNotes[1], equals('Good start'));
      expect(recRestored.diagnosedErrors.length, equals(1));

      final unf = UnfinishedGame(
        id: 'unf_test',
        currentFen: '8/8/8/8/8/8/8/8 w - - 0 1',
        moveSanList: ['Nf3', 'd5'],
        timeControl: '5+3 Blitz',
        whiteRemainingSeconds: 290,
        blackRemainingSeconds: 295,
        startedAt: DateTime.now(),
        lastMoveAt: DateTime.now(),
      );
      final unfJson = unf.toJson();
      final unfRestored = UnfinishedGame.fromJson(unfJson);
      expect(unfRestored.id, equals('unf_test'));
      expect(unfRestored.moveSanList, equals(['Nf3', 'd5']));

      final prof = UserProfile(
        id: 'u1',
        username: 'TestUser',
        currentDay: 42,
        dailyTimeBudgetMinutes: 300,
        sidePanelCollapsed: true,
        boardScaleMultiplier: 0.92,
        passedExams: [7, 14, 21],
      );
      final profJson = prof.toJson();
      final profRestored = UserProfile.fromJson(profJson);
      expect(profRestored.username, equals('TestUser'));
      expect(profRestored.currentDay, equals(42));
      expect(profRestored.dailyTimeBudgetMinutes, equals(300));
      expect(profRestored.sidePanelCollapsed, isTrue);
      expect(profRestored.boardScaleMultiplier, equals(0.92));
      expect(profRestored.passedExams, equals([7, 14, 21]));
    });
  });
}
