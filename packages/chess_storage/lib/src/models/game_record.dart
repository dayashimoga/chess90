/// Record of a played game with self-analysis and diagnosed mistakes.
class GameRecord {
  final String id;
  final String pgn;
  final DateTime playedDate;
  final String whitePlayer;
  final String blackPlayer;
  final String result;
  final String timeControl;
  final Map<int, String> selfAnalysisNotes; // ply -> note
  final List<Map<String, dynamic>> diagnosedErrors;

  const GameRecord({
    required this.id,
    required this.pgn,
    required this.playedDate,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.result,
    required this.timeControl,
    this.selfAnalysisNotes = const {},
    this.diagnosedErrors = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'pgn': pgn,
        'playedDate': playedDate.toIso8601String(),
        'whitePlayer': whitePlayer,
        'blackPlayer': blackPlayer,
        'result': result,
        'timeControl': timeControl,
        'selfAnalysisNotes': selfAnalysisNotes.map((k, v) => MapEntry(k.toString(), v)),
        'diagnosedErrors': diagnosedErrors,
      };

  factory GameRecord.fromJson(Map<String, dynamic> json) {
    final rawNotes = json['selfAnalysisNotes'] as Map<String, dynamic>? ?? {};
    final notes = rawNotes.map((k, v) => MapEntry(int.parse(k), v as String));

    return GameRecord(
      id: json['id'] as String,
      pgn: json['pgn'] as String,
      playedDate: DateTime.tryParse(json['playedDate'] as String? ?? '') ?? DateTime.now(),
      whitePlayer: json['whitePlayer'] as String? ?? 'White',
      blackPlayer: json['blackPlayer'] as String? ?? 'Black',
      result: json['result'] as String? ?? '*',
      timeControl: json['timeControl'] as String? ?? 'Classical',
      selfAnalysisNotes: notes,
      diagnosedErrors: (json['diagnosedErrors'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [],
    );
  }
}
