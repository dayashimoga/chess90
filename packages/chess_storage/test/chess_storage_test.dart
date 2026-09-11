import 'dart:io';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:test/test.dart';

void main() {
  group('Local-First Storage & Persistence Tests', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('chess_storage_test_');
    });

    tearDown(() {
      try {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    });

    test('Initializes with default 12 skill nodes', () {
      final repo = StorageRepository();
      final nodes = repo.getSkillNodes();
      expect(nodes.length, equals(12));
      expect(nodes.any((n) => n.axis == SkillAxis.tactics), isTrue);
    });

    test('Full JSON backup export and import roundtrip', () {
      final repo1 = StorageRepository();
      final profile = repo1.getProfile();
      profile.currentDay = 14;
      profile.passedExams = [7, 14];
      repo1.saveProfile(profile);

      repo1.saveGame(GameRecord(
        id: 'game_1',
        pgn: '1. e4 e5 2. Nf3 Nc6 1-0',
        playedDate: DateTime.now(),
        whitePlayer: 'Candidate Master',
        blackPlayer: 'Stockfish Level 4',
        result: '1-0',
        timeControl: 'Classical 45+15',
        selfAnalysisNotes: {1: 'Classical opening move'},
      ));

      final jsonBackup = repo1.exportFullBackupJson();
      expect(jsonBackup, contains('"currentDay": 14'));
      expect(jsonBackup, contains('"passedExams": ['));
      expect(jsonBackup, contains('game_1'));

      final repo2 = StorageRepository();
      repo2.importFullBackupJson(jsonBackup);

      expect(repo2.getProfile().currentDay, equals(14));
      expect(repo2.getProfile().passedExams, equals([7, 14]));
      expect(repo2.getGames().length, equals(1));
      expect(repo2.getGames().first.whitePlayer, equals('Candidate Master'));
    });

    test('File-backed database preserves state across offline restart and uses atomic writes', () {
      final dbFilePath = '${tempDir.path}${Platform.pathSeparator}chessmaster.db';

      // 1. Session 1: Create, write data
      final db1 = LocalDatabase(dbPath: dbFilePath);
      final profile = db1.getProfile();
      profile.username = 'MasterGrandmaster';
      profile.currentDay = 42;
      profile.passedExams = [7, 14, 21, 28, 35, 42];
      db1.saveProfile(profile);

      // Verify file exists on disk and has content
      expect(File(dbFilePath).existsSync(), isTrue);
      expect(File(dbFilePath).lengthSync(), greaterThan(100));

      // 2. Session 2: Offline restart from same file
      final db2 = LocalDatabase(dbPath: dbFilePath);
      expect(db2.getProfile().username, equals('MasterGrandmaster'));
      expect(db2.getProfile().currentDay, equals(42));
      expect(db2.getProfile().passedExams, equals([7, 14, 21, 28, 35, 42]));
    });

    test('Unfinished game persistence and crash-recovery', () {
      final dbFilePath = '${tempDir.path}${Platform.pathSeparator}crash_recovery.db';
      final repo = StorageRepository(dbPath: dbFilePath);

      // Save an in-progress game
      final activeGame = UnfinishedGame(
        id: 'active_tournament_1',
        currentFen: 'r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQkq - 0 4',
        moveSanList: ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Bc5', 'd3', 'Nf6'],
        timeControl: '90+30 Classical',
        whiteRemainingSeconds: 4800,
        blackRemainingSeconds: 5120,
        isTournamentMode: true,
        startedAt: DateTime.now().subtract(const Duration(minutes: 20)),
        lastMoveAt: DateTime.now().subtract(const Duration(seconds: 45)),
        thoughtNotes: {
          4: 'Opponent played Italian game; I responded with solid Bc5.',
        },
      );

      repo.saveUnfinishedGame(activeGame);

      // Verify immediate persistence
      expect(repo.getUnfinishedGame(), isNotNull);
      expect(repo.getUnfinishedGame()!.id, equals('active_tournament_1'));
      expect(repo.getUnfinishedGame()!.whiteRemainingSeconds, equals(4800));

      // Simulate app restart
      final recoveredRepo = StorageRepository(dbPath: dbFilePath);
      final recoveredGame = recoveredRepo.getUnfinishedGame();
      expect(recoveredGame, isNotNull);
      expect(recoveredGame!.id, equals('active_tournament_1'));
      expect(recoveredGame.moveSanList.length, equals(8));
      expect(recoveredGame.isTournamentMode, isTrue);
      expect(recoveredGame.thoughtNotes[4], contains('Italian game'));

      // Clear after game completes
      recoveredRepo.clearUnfinishedGame();
      expect(recoveredRepo.getUnfinishedGame(), isNull);

      final restartedRepo2 = StorageRepository(dbPath: dbFilePath);
      expect(restartedRepo2.getUnfinishedGame(), isNull);
    });

    test('Schema migration from V1 to V2', () {
      const v1BackupJson = '''
{
  "schemaVersion": 1,
  "profile": {
    "username": "LegacyPlayer",
    "fideRating": 1800,
    "currentDay": 10,
    "ratingProgress": [1800],
    "passedExams": [7],
    "completedLabIds": ["tactical_lab"],
    "preferences": {}
  },
  "skillNodes": [
    {
      "id": "node_tactics",
      "name": "Tactics",
      "axis": "tactics",
      "childIds": [],
      "knowledgeScore": 0.8,
      "isolatedAccuracy": 0.8,
      "mixedAccuracy": 0.75,
      "realGameApplication": 0.7,
      "retention7Day": 0.8,
      "retention30Day": 0.7,
      "responseTimeMs": 1200,
      "status": "learning"
    }
  ]
}
''';

      final db = LocalDatabase();
      db.importFullBackupJson(v1BackupJson);

      expect(db.schemaVersion, equals(LocalDatabase.currentSchemaVersion));
      expect(db.getProfile().username, equals('LegacyPlayer'));
      expect(db.getSkillNodes().first.id, equals('node_tactics'));
      expect(db.getUnfinishedGame(), isNull);
    });

    test('Corrupt backup handling rejects malformed data without destroying database', () {
      final db = LocalDatabase();
      final originalUser = db.getProfile().username;

      expect(
        () => db.importFullBackupJson('{ "truncated_json": true '),
        throwsA(isA<CorruptBackupException>()),
      );

      expect(
        () => db.importFullBackupJson('{"randomField": 123}'),
        throwsA(isA<CorruptBackupException>()),
      );

      // Active state was untouched
      expect(db.getProfile().username, equals(originalUser));
    });
  });
}
