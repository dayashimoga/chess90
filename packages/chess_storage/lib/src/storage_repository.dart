import 'dart:io';
import 'package:chess_learning/chess_learning.dart';
import 'local_database.dart';
import 'models/game_record.dart';
import 'models/unfinished_game.dart';
import 'models/user_profile.dart';

/// Local-first repository that manages complete platform state
/// with full JSON export, import, schema migration, and crash recovery.
class StorageRepository {
  final LocalDatabase _db;

  StorageRepository({String? dbPath, LocalDatabase? database, bool inMemory = false})
      : _db = database ?? LocalDatabase(dbPath: inMemory ? null : (dbPath ?? resolveDefaultDatabasePath()));

  /// Creates a hermetic, in-memory repository for deterministic testing.
  factory StorageRepository.inMemory() => StorageRepository(inMemory: true);

  /// Resolves the default operating system path for the offline database file.
  static String? resolveDefaultDatabasePath() {
    try {
      if (Platform.isWindows) {
        final appData = Platform.environment['APPDATA'];
        if (appData != null && appData.isNotEmpty) {
          return '$appData\\ChessMaster\\chessmaster.db';
        }
      } else if (Platform.isLinux || Platform.isMacOS || Platform.isAndroid) {
        final home = Platform.environment['HOME'];
        if (home != null && home.isNotEmpty) {
          return '$home/.chessmaster/chessmaster.db';
        }
      }
    } catch (_) {}
    return null;
  }

  LocalDatabase get database => _db;

  UserProfile getProfile() => _db.getProfile();

  void saveProfile(UserProfile profile) => _db.saveProfile(profile);

  List<SkillNode> getSkillNodes() => _db.getSkillNodes();

  void saveSkillNode(SkillNode node) => _db.saveSkillNode(node);

  List<ReviewItem> getReviewItems() => _db.getReviewItems();

  void saveReviewItem(ReviewItem item) => _db.saveReviewItem(item);

  List<GameRecord> getGames() => _db.getGames();

  void saveGame(GameRecord game) => _db.saveGame(game);

  UnfinishedGame? getUnfinishedGame() => _db.getUnfinishedGame();

  void saveUnfinishedGame(UnfinishedGame game) => _db.saveUnfinishedGame(game);

  void clearUnfinishedGame() => _db.clearUnfinishedGame();

  /// Exports complete platform database into a single JSON backup.
  String exportFullBackupJson() => _db.exportFullBackupJson();

  /// Restores complete platform database from a JSON backup with schema migration support.
  void importFullBackupJson(String jsonString) => _db.importFullBackupJson(jsonString);

  /// Validates whether a file path is safe from directory traversal, UNC injection, or illegal URI schemes.
  static bool isPathSafe(String path) {
    if (path.isEmpty) return false;
    final normalized = path.replaceAll('\\', '/');
    if (normalized.contains('..') ||
        normalized.startsWith('/') ||
        path.contains(':\\') ||
        path.startsWith('\\\\') ||
        path.contains('://') ||
        path.contains('\x00')) {
      return false;
    }
    return true;
  }

  /// Sanitizes a user-provided file name to prevent directory escape.
  static String sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[\\/:*?"<>|\x00]'), '_')
        .replaceAll('..', '_');
  }
}
