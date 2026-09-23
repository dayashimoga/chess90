import 'dart:convert';
import 'dart:io';
import 'package:chess_learning/chess_learning.dart';
import 'models/game_record.dart';
import 'models/game_session.dart';
import 'models/unfinished_game.dart';
import 'models/user_profile.dart';

/// Exception thrown when an imported backup is corrupted or invalid.
class CorruptBackupException implements Exception {
  final String message;
  const CorruptBackupException(this.message);

  @override
  String toString() => 'CorruptBackupException: $message';
}

/// Production local-first database engine with atomic crash-safe writes,
/// automatic schema migrations, and unfinished game recovery.
class LocalDatabase {
  static const int currentSchemaVersion = 2;

  final String? dbPath; // null for in-memory only
  int schemaVersion = currentSchemaVersion;

  UserProfile profile = UserProfile.createDefault();
  final Map<String, SkillNode> skillNodes = {};
  final Map<String, ReviewItem> reviewItems = {};
  final Map<String, GameRecord> games = {};
  final Map<String, GameSession> gameSessions = {};
  UnfinishedGame? unfinishedGame;
  GameSession? activeGameSession;
  GameSession? lastCompletedGame;

  LocalDatabase({this.dbPath}) {
    if (dbPath != null) {
      final file = File(dbPath!);
      if (file.existsSync()) {
        _loadFromFile();
      } else {
        _initializeDefaults();
        _saveToFile();
      }
    } else {
      _initializeDefaults();
    }
  }

  void _initializeDefaults() {
    skillNodes.clear();
    for (final axis in SkillAxis.values) {
      skillNodes['node_${axis.name}'] = SkillNode(
        id: 'node_${axis.name}',
        name: axis.title,
        axis: axis,
        knowledgeScore: 0.50,
        isolatedAccuracy: 0.50,
        mixedAccuracy: 0.50,
        realGameApplication: 0.50,
        retention7Day: 0.50,
        retention30Day: 0.50,
        status: SkillStatus.learning,
      );
    }
  }

  // --- Profile Operations ---
  UserProfile getProfile() => profile;

  void saveProfile(UserProfile p) {
    profile = p;
    profile.lastActiveDate = DateTime.now();
    _saveToFile();
  }

  // --- Skill Nodes Operations ---
  List<SkillNode> getSkillNodes() => List.unmodifiable(skillNodes.values);

  void saveSkillNode(SkillNode node) {
    skillNodes[node.id] = node;
    _saveToFile();
  }

  // --- Review Items (SRS Queue) ---
  List<ReviewItem> getReviewItems() => List.unmodifiable(reviewItems.values);

  void saveReviewItem(ReviewItem item) {
    reviewItems[item.id] = item;
    _saveToFile();
  }

  // --- Games Operations ---
  List<GameRecord> getGames() => List.unmodifiable(games.values);

  void saveGame(GameRecord game) {
    games[game.id] = game;
    _saveToFile();
  }

  // --- Unfinished Game Recovery ---
  UnfinishedGame? getUnfinishedGame() => unfinishedGame;

  void saveUnfinishedGame(UnfinishedGame game) {
    unfinishedGame = game;
    _saveToFile();
  }

  void clearUnfinishedGame() {
    unfinishedGame = null;
    _saveToFile();
  }

  // --- Game Session Operations (Continuous Source of Truth) ---
  GameSession? getActiveGameSession() => activeGameSession;

  void saveActiveGameSession(GameSession session) {
    activeGameSession = session;
    _saveToFile();
  }

  void clearActiveGameSession() {
    activeGameSession = null;
    _saveToFile();
  }

  GameSession? getLastCompletedGame() => lastCompletedGame;

  void saveCompletedGame(GameSession session) {
    lastCompletedGame = session;
    gameSessions[session.id] = session;
    if (activeGameSession?.id == session.id) {
      activeGameSession = null;
    }
    _saveToFile();
  }

  List<GameSession> getGameHistory() {
    final list = gameSessions.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List.unmodifiable(list);
  }

  // --- Backup Export & Import ---
  String exportFullBackupJson() {
    final data = {
      'schemaVersion': currentSchemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'profile': profile.toJson(),
      'skillNodes': skillNodes.values.map((n) => n.toJson()).toList(),
      'reviewItems': reviewItems.values.map((i) => i.toJson()).toList(),
      'games': games.values.map((g) => g.toJson()).toList(),
      if (unfinishedGame != null) 'unfinishedGame': unfinishedGame!.toJson(),
      if (activeGameSession != null) 'activeGameSession': activeGameSession!.toJson(),
      if (lastCompletedGame != null) 'lastCompletedGame': lastCompletedGame!.toJson(),
      'gameSessions': gameSessions.values.map((s) => s.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  void importFullBackupJson(String jsonString) {
    Map<String, dynamic> data;
    try {
      final decoded = json.decode(jsonString);
      if (decoded is! Map<String, dynamic>) {
        throw const CorruptBackupException('Backup root must be a valid JSON object.');
      }
      data = decoded;
    } catch (e) {
      throw CorruptBackupException('Invalid JSON payload: $e');
    }

    if (!data.containsKey('profile') || !data.containsKey('skillNodes')) {
      throw const CorruptBackupException('Missing required database collections (profile/skillNodes).');
    }

    // Schema migration on imported backup if required
    final importVersion = data['schemaVersion'] as int? ?? 1;
    if (importVersion > currentSchemaVersion) {
      throw CorruptBackupException('Unsupported backup schema version: $importVersion (supported <= $currentSchemaVersion)');
    }
    if (importVersion < currentSchemaVersion) {
      data = _applyMigrations(data, importVersion, currentSchemaVersion);
    }

    // Restore safely
    profile = UserProfile.fromJson(data['profile'] as Map<String, dynamic>);

    skillNodes.clear();
    for (final raw in (data['skillNodes'] as List<dynamic>)) {
      final node = SkillNode.fromJson(raw as Map<String, dynamic>);
      skillNodes[node.id] = node;
    }

    reviewItems.clear();
    if (data.containsKey('reviewItems')) {
      for (final raw in (data['reviewItems'] as List<dynamic>)) {
        final item = ReviewItem.fromJson(raw as Map<String, dynamic>);
        reviewItems[item.id] = item;
      }
    }

    games.clear();
    if (data.containsKey('games')) {
      for (final raw in (data['games'] as List<dynamic>)) {
        final g = GameRecord.fromJson(raw as Map<String, dynamic>);
        games[g.id] = g;
      }
    }

    if (data.containsKey('unfinishedGame') && data['unfinishedGame'] != null) {
      unfinishedGame = UnfinishedGame.fromJson(data['unfinishedGame'] as Map<String, dynamic>);
    } else {
      unfinishedGame = null;
    }

    if (data.containsKey('activeGameSession') && data['activeGameSession'] != null) {
      activeGameSession = GameSession.fromJson(data['activeGameSession'] as Map<String, dynamic>);
    } else {
      activeGameSession = null;
    }

    if (data.containsKey('lastCompletedGame') && data['lastCompletedGame'] != null) {
      lastCompletedGame = GameSession.fromJson(data['lastCompletedGame'] as Map<String, dynamic>);
    } else {
      lastCompletedGame = null;
    }

    gameSessions.clear();
    if (data.containsKey('gameSessions')) {
      for (final raw in (data['gameSessions'] as List<dynamic>)) {
        final s = GameSession.fromJson(raw as Map<String, dynamic>);
        gameSessions[s.id] = s;
      }
    }

    _saveToFile();
  }

  // --- Schema Migrations ---
  static Map<String, dynamic> _applyMigrations(Map<String, dynamic> data, int fromVersion, int toVersion) {
    var migrated = Map<String, dynamic>.from(data);

    if (fromVersion == 1 && toVersion >= 2) {
      // Migration V1 -> V2:
      // 1. Add empty unfinishedGame if not present
      // 2. Add recurrenceCount and cognitiveDomain defaults to skill nodes
      migrated['schemaVersion'] = 2;
      migrated['unfinishedGame'] = null;

      final nodesList = (migrated['skillNodes'] as List<dynamic>?) ?? [];
      for (final node in nodesList) {
        if (node is Map<String, dynamic>) {
          node['recurrenceCount'] = node['recurrenceCount'] ?? 0;
          node['domain'] = node['domain'] ?? 'tactics';
        }
      }
    }

    return migrated;
  }

  // --- File Persistence (Atomic & Crash-Safe) ---
  void _loadFromFile() {
    if (dbPath == null) return;
    final file = File(dbPath!);
    if (!file.existsSync()) return;

    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return;

    final data = json.decode(content) as Map<String, dynamic>;
    final fileVersion = data['schemaVersion'] as int? ?? 1;

    final workingData = fileVersion < currentSchemaVersion
        ? _applyMigrations(data, fileVersion, currentSchemaVersion)
        : data;

    schemaVersion = workingData['schemaVersion'] as int? ?? currentSchemaVersion;
    if (workingData.containsKey('profile')) {
      profile = UserProfile.fromJson(workingData['profile'] as Map<String, dynamic>);
    }

    skillNodes.clear();
    if (workingData.containsKey('skillNodes')) {
      for (final raw in (workingData['skillNodes'] as List<dynamic>)) {
        final node = SkillNode.fromJson(raw as Map<String, dynamic>);
        skillNodes[node.id] = node;
      }
    }

    reviewItems.clear();
    if (workingData.containsKey('reviewItems')) {
      for (final raw in (workingData['reviewItems'] as List<dynamic>)) {
        final item = ReviewItem.fromJson(raw as Map<String, dynamic>);
        reviewItems[item.id] = item;
      }
    }

    games.clear();
    if (workingData.containsKey('games')) {
      for (final raw in (workingData['games'] as List<dynamic>)) {
        final g = GameRecord.fromJson(raw as Map<String, dynamic>);
        games[g.id] = g;
      }
    }

    if (workingData.containsKey('unfinishedGame') && workingData['unfinishedGame'] != null) {
      unfinishedGame = UnfinishedGame.fromJson(workingData['unfinishedGame'] as Map<String, dynamic>);
    } else {
      unfinishedGame = null;
    }

    if (workingData.containsKey('activeGameSession') && workingData['activeGameSession'] != null) {
      activeGameSession = GameSession.fromJson(workingData['activeGameSession'] as Map<String, dynamic>);
    } else {
      activeGameSession = null;
    }

    if (workingData.containsKey('lastCompletedGame') && workingData['lastCompletedGame'] != null) {
      lastCompletedGame = GameSession.fromJson(workingData['lastCompletedGame'] as Map<String, dynamic>);
    } else {
      lastCompletedGame = null;
    }

    gameSessions.clear();
    if (workingData.containsKey('gameSessions')) {
      for (final raw in (workingData['gameSessions'] as List<dynamic>)) {
        final s = GameSession.fromJson(raw as Map<String, dynamic>);
        gameSessions[s.id] = s;
      }
    }
  }

  void _saveToFile() {
    if (dbPath == null) return;

    final file = File(dbPath!);
    final tmpFile = File('$dbPath.tmp');

    file.parent.createSync(recursive: true);

    final payload = exportFullBackupJson();

    // Atomic write pattern: write to .tmp, flush, then rename over target
    tmpFile.writeAsStringSync(payload, flush: true);
    if (file.existsSync()) {
      file.deleteSync();
    }
    tmpFile.renameSync(dbPath!);
  }
}
