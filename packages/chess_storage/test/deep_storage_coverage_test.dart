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
    });
  });
}
