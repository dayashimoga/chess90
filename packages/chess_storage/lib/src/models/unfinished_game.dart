/// Model for persisting an active, in-progress serious game for crash-safe recovery.
class UnfinishedGame {
  final String id;
  final String currentFen;
  final List<String> moveSanList;
  final String timeControl;
  final int whiteRemainingSeconds;
  final int blackRemainingSeconds;
  final bool isVsEngine;
  final int engineLevel;
  final bool isTournamentMode;
  final DateTime startedAt;
  final DateTime lastMoveAt;
  final Map<int, String> thoughtNotes; // ply -> thought note

  const UnfinishedGame({
    required this.id,
    required this.currentFen,
    required this.moveSanList,
    required this.timeControl,
    required this.whiteRemainingSeconds,
    required this.blackRemainingSeconds,
    this.isVsEngine = true,
    this.engineLevel = 5,
    this.isTournamentMode = false,
    required this.startedAt,
    required this.lastMoveAt,
    this.thoughtNotes = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'currentFen': currentFen,
        'moveSanList': moveSanList,
        'timeControl': timeControl,
        'whiteRemainingSeconds': whiteRemainingSeconds,
        'blackRemainingSeconds': blackRemainingSeconds,
        'isVsEngine': isVsEngine,
        'engineLevel': engineLevel,
        'isTournamentMode': isTournamentMode,
        'startedAt': startedAt.toIso8601String(),
        'lastMoveAt': lastMoveAt.toIso8601String(),
        'thoughtNotes': thoughtNotes.map((k, v) => MapEntry(k.toString(), v)),
      };

  factory UnfinishedGame.fromJson(Map<String, dynamic> json) {
    final rawNotes = json['thoughtNotes'] as Map<String, dynamic>? ?? {};
    final notes = rawNotes.map((k, v) => MapEntry(int.parse(k), v as String));

    return UnfinishedGame(
      id: json['id'] as String,
      currentFen: json['currentFen'] as String,
      moveSanList: (json['moveSanList'] as List<dynamic>?)?.cast<String>() ?? [],
      timeControl: json['timeControl'] as String? ?? 'Classical 45+15',
      whiteRemainingSeconds: json['whiteRemainingSeconds'] as int? ?? 2700,
      blackRemainingSeconds: json['blackRemainingSeconds'] as int? ?? 2700,
      isVsEngine: json['isVsEngine'] as bool? ?? true,
      engineLevel: json['engineLevel'] as int? ?? 5,
      isTournamentMode: json['isTournamentMode'] as bool? ?? false,
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ?? DateTime.now(),
      lastMoveAt: DateTime.tryParse(json['lastMoveAt'] as String? ?? '') ?? DateTime.now(),
      thoughtNotes: notes,
    );
  }
}
