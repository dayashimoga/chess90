import 'dart:io';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:test/test.dart';

void main() {
  group('Deep Storage & Repository Coverage Suite', () {
    test('StorageRepository path resolution and static security utilities', () {
      final defaultPath = StorageRepository.resolveDefaultDatabasePath();
      if (Platform.isWindows) {
        expect(defaultPath, isNotNull);
        expect(defaultPath, contains('ChessMaster'));
      }

      // Path safety tests
      expect(StorageRepository.isPathSafe(''), isFalse);
      expect(StorageRepository.isPathSafe('valid_file.db'), isTrue);
      expect(StorageRepository.isPathSafe('folder/sub/valid.db'), isTrue);
      expect(StorageRepository.isPathSafe('../escape.db'), isFalse);
      expect(StorageRepository.isPathSafe('folder/../../escape.db'), isFalse);
      expect(StorageRepository.isPathSafe('/etc/passwd'), isFalse);
      expect(StorageRepository.isPathSafe('C:\\Windows\\system.ini'), isFalse);
      expect(StorageRepository.isPathSafe('\\\\server\\share'), isFalse);
      expect(StorageRepository.isPathSafe('file:///etc/shadow'), isFalse);
      expect(StorageRepository.isPathSafe('null\x00byte.db'), isFalse);

      // File name sanitization
      expect(StorageRepository.sanitizeFileName('normal_file.json'), 'normal_file.json');
      expect(StorageRepository.sanitizeFileName('file/with:bad*chars?.txt'), 'file_with_bad_chars_.txt');
      expect(StorageRepository.sanitizeFileName('../../evil.txt'), '____evil.txt');
    });

    test('StorageRepository inMemory and database instance access', () {
      final repo = StorageRepository.inMemory();
      expect(repo.database, isNotNull);

      // Unfinished game management
      expect(repo.getUnfinishedGame(), isNull);

      final game = UnfinishedGame(
        id: 'unf_1',
        currentFen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
        moveSanList: ['e4'],
        timeControl: '15+10',
        whiteRemainingSeconds: 300,
        blackRemainingSeconds: 300,
        startedAt: DateTime.now(),
        lastMoveAt: DateTime.now(),
      );
      repo.saveUnfinishedGame(game);
      expect(repo.getUnfinishedGame(), isNotNull);
      expect(repo.getUnfinishedGame()!.moveSanList, equals(['e4']));

      repo.clearUnfinishedGame();
      expect(repo.getUnfinishedGame(), isNull);

      // Skill node management
      final initialNodes = repo.getSkillNodes();
      expect(initialNodes.isNotEmpty, isTrue);

      final updatedNode = SkillNode(
        id: initialNodes.first.id,
        name: initialNodes.first.name,
        axis: initialNodes.first.axis,
        knowledgeScore: 0.99,
      );
      repo.saveSkillNode(updatedNode);
      final fetched = repo.getSkillNodes().firstWhere((n) => n.id == updatedNode.id);
      expect(fetched.knowledgeScore, equals(0.99));

      // Review item management
      final reviewItem = ReviewItem(
        id: 'rev_test_1',
        fen: '8/8/8/8/8/8/8/8 w - - 0 1',
        solutionSan: ['Ke2'],
        skillNodeId: 'tactics',
        motif: 'King Walk',
        explanation: 'Deep test',
      );
      repo.saveReviewItem(reviewItem);
      expect(repo.getReviewItems().any((r) => r.id == 'rev_test_1'), isTrue);

      // Profile management
      final profile = repo.getProfile();
      expect(profile.username, equals('Candidate Master'));
      profile.username = 'SuperGM';
      profile.dailyTimeBudgetMinutes = 45;
      repo.saveProfile(profile);
      expect(repo.getProfile().username, equals('SuperGM'));
      expect(repo.getProfile().dailyTimeBudgetMinutes, equals(45));

      // GameRecord management
      final gameRecord = GameRecord(
        id: 'rec_1',
        pgn: '1. e4 e5 2. Nf3 *',
        playedDate: DateTime.now(),
        whitePlayer: 'SuperGM',
        blackPlayer: 'Stockfish',
        result: '*',
        timeControl: '10+0',
      );
      repo.saveGame(gameRecord);
      expect(repo.getGames().length, equals(1));
      expect(repo.getGames().first.id, equals('rec_1'));

      // Active GameSession management
      expect(repo.getActiveGameSession(), isNull);
      final session = GameSession(
        id: 'sess_1',
        timeControl: '15+10',
        moveSanList: ['e4', 'c5', 'Nf3'],
        opponentName: 'Stockfish',
      );
      repo.saveActiveGameSession(session);
      expect(repo.getActiveGameSession(), isNotNull);
      expect(repo.getActiveGameSession()!.id, equals('sess_1'));
      expect(repo.getActiveGameSession()!.moveSanList, equals(['e4', 'c5', 'Nf3']));

      repo.clearActiveGameSession();
      expect(repo.getActiveGameSession(), isNull);

      // Completed Game management and history
      expect(repo.getLastCompletedGame(), isNull);
      expect(repo.getGameHistory(), isEmpty);

      session.isCompleted = true;
      session.result = '1-0';
      repo.saveCompletedGame(session);
      expect(repo.getLastCompletedGame(), isNotNull);
      expect(repo.getLastCompletedGame()!.id, equals('sess_1'));
      expect(repo.getGameHistory().length, equals(1));

      // Backup export and restore roundtrip
      final backupJson = repo.exportFullBackupJson();
      expect(backupJson, contains('sess_1'));
      expect(backupJson, contains('SuperGM'));

      final repo2 = StorageRepository.inMemory();
      repo2.importFullBackupJson(backupJson);
      expect(repo2.getProfile().username, equals('SuperGM'));
      expect(repo2.getLastCompletedGame()?.id, equals('sess_1'));
      expect(repo2.getGames().first.id, equals('rec_1'));
    });

    test('Models serialization and edge cases', () {
      final now = DateTime.now();
      final p = UserProfile(
        id: 'user_1',
        username: 'Magnus',
        currentDay: 42,
        soundEnabled: false,
        boardThemeName: 'wood',
        pieceThemeName: 'cburnett',
        dailyTimeBudgetMinutes: 60,
        createdDate: now,
        lastActiveDate: now,
      );
      final pJson = p.toJson();
      final p2 = UserProfile.fromJson(pJson);
      expect(p2.username, equals('Magnus'));
      expect(p2.soundEnabled, isFalse);

      final rec = GameRecord(
        id: 'rec_2',
        pgn: '1. d4 d5 2. c4 *',
        playedDate: now,
        whitePlayer: 'White',
        blackPlayer: 'Black',
        result: '1/2-1/2',
        timeControl: '5+3',
      );
      final recJson = rec.toJson();
      final rec2 = GameRecord.fromJson(recJson);
      expect(rec2.id, equals('rec_2'));
      expect(rec2.result, equals('1/2-1/2'));

      final unf = UnfinishedGame(
        id: 'unf_2',
        currentFen: '8/8/8/8/8/8/8/8 w - - 0 1',
        moveSanList: ['e4'],
        timeControl: '3+2',
        whiteRemainingSeconds: 150,
        blackRemainingSeconds: 120,
        startedAt: now,
        lastMoveAt: now,
      );
      final unfJson = unf.toJson();
      final unf2 = UnfinishedGame.fromJson(unfJson);
      expect(unf2.id, equals('unf_2'));
      expect(unf2.whiteRemainingSeconds, equals(150));
    });
  });
}
