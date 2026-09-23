import 'package:chess_core/chess_core.dart';

/// Complete, continuous game session serving as the single source of truth across
/// Play, Post-Game Analysis, Mistake Retraining, Video Studio, and Game Library.
class GameSession {
  static const String standardStartFen = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

  final String id;
  String pgn;
  String initialFen;
  String currentFen;
  final List<String> moveSanList;
  final List<String> moveUciList;
  final List<int> moveTimesMs;
  int whiteRemainingSeconds;
  int blackRemainingSeconds;
  String timeControl;
  String openingName;
  String openingEco;
  String playerColor;
  String opponentName;
  bool isVsEngine;
  int engineElo;
  String result;
  final Map<int, String> thoughtNotes; // ply -> note
  final Map<int, double> engineEvaluations; // ply -> eval
  final List<Map<String, dynamic>> diagnosedErrors;
  final DateTime startedAt;
  DateTime updatedAt;
  bool isCompleted;

  GameSession({
    required this.id,
    this.pgn = '',
    this.initialFen = standardStartFen,
    this.currentFen = standardStartFen,
    List<String>? moveSanList,
    List<String>? moveUciList,
    List<int>? moveTimesMs,
    this.whiteRemainingSeconds = 900,
    this.blackRemainingSeconds = 900,
    this.timeControl = '15+10 Rapid',
    this.openingName = 'Starting Position',
    this.openingEco = 'A00',
    this.playerColor = 'white',
    this.opponentName = 'Stockfish Engine',
    this.isVsEngine = true,
    this.engineElo = 1500,
    this.result = '*',
    Map<int, String>? thoughtNotes,
    Map<int, double>? engineEvaluations,
    List<Map<String, dynamic>>? diagnosedErrors,
    DateTime? startedAt,
    DateTime? updatedAt,
    this.isCompleted = false,
  })  : moveSanList = moveSanList ?? [],
        moveUciList = moveUciList ?? [],
        moveTimesMs = moveTimesMs ?? [],
        thoughtNotes = thoughtNotes ?? {},
        engineEvaluations = engineEvaluations ?? {},
        diagnosedErrors = diagnosedErrors ?? [],
        startedAt = startedAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Creates a fresh new game session.
  factory GameSession.newGame({
    String? id,
    String initialFen = standardStartFen,
    String timeControl = '15+10 Rapid',
    int initialMinutes = 15,
    int incrementSeconds = 10,
    String playerColor = 'white',
    String opponentName = 'Stockfish Engine',
    bool isVsEngine = true,
    int engineElo = 1500,
  }) {
    final now = DateTime.now();
    final gameId = id ?? 'game_${now.millisecondsSinceEpoch}';
    final initialSeconds = initialMinutes * 60;
    return GameSession(
      id: gameId,
      initialFen: initialFen,
      currentFen: initialFen,
      timeControl: timeControl,
      whiteRemainingSeconds: initialSeconds,
      blackRemainingSeconds: initialSeconds,
      playerColor: playerColor,
      opponentName: opponentName,
      isVsEngine: isVsEngine,
      engineElo: engineElo,
      startedAt: now,
      updatedAt: now,
      isCompleted: false,
    );
  }

  /// Appends a move to this continuous game session and updates current FEN and timestamp.
  void recordMove({
    required String san,
    required String uci,
    required String newFen,
    int elapsedMs = 0,
    int? whiteTime,
    int? blackTime,
  }) {
    moveSanList.add(san);
    moveUciList.add(uci);
    moveTimesMs.add(elapsedMs);
    currentFen = newFen;
    if (whiteTime != null) whiteRemainingSeconds = whiteTime;
    if (blackTime != null) blackRemainingSeconds = blackTime;
    updatedAt = DateTime.now();
    rebuildPgn();
  }

  /// Marks game complete with result and updates final PGN string.
  void completeGame(String gameResult) {
    result = gameResult;
    isCompleted = true;
    updatedAt = DateTime.now();
    rebuildPgn();
  }

  /// Rebuilds the standard PGN representation from the current move list and metadata.
  void rebuildPgn() {
    final buffer = StringBuffer();
    buffer.writeln('[Event "${isVsEngine ? 'Engine Match' : 'Casual Game'}"]');
    buffer.writeln('[Site "ChessMaster Offline"]');
    buffer.writeln('[Date "${startedAt.toIso8601String().substring(0, 10).replaceAll('-', '.')}"]');
    buffer.writeln('[Round "1"]');
    buffer.writeln('[White "${playerColor == 'white' ? 'User' : opponentName}"]');
    buffer.writeln('[Black "${playerColor == 'black' ? 'User' : opponentName}"]');
    buffer.writeln('[Result "$result"]');
    buffer.writeln('[TimeControl "$timeControl"]');
    if (openingEco.isNotEmpty) buffer.writeln('[ECO "$openingEco"]');
    if (openingName.isNotEmpty) buffer.writeln('[Opening "$openingName"]');
    if (initialFen != standardStartFen) {
      buffer.writeln('[SetUp "1"]');
      buffer.writeln('[FEN "$initialFen"]');
    }
    buffer.writeln();

    for (int i = 0; i < moveSanList.length; i++) {
      if (i % 2 == 0) {
        buffer.write('${(i ~/ 2) + 1}. ');
      }
      buffer.write('${moveSanList[i]} ');
    }
    if (result != '*') {
      buffer.write(result);
    }
    pgn = buffer.toString().trim();
  }

  /// Reconstructs a PgnGame object from the active session.
  PgnGame toPgnGame() {
    if (pgn.isEmpty) rebuildPgn();
    final parsed = PgnParser.parse(pgn);
    if (parsed != null) return parsed;

    return PgnGame(
      headers: {
        'Event': isVsEngine ? 'Engine Match' : 'Casual Game',
        'Site': 'ChessMaster Offline',
        'Date': startedAt.toIso8601String().substring(0, 10),
        'Round': '1',
        'White': playerColor == 'white' ? 'User' : opponentName,
        'Black': playerColor == 'black' ? 'User' : opponentName,
        'Result': result,
        'TimeControl': timeControl,
      },
      moves: const [],
    );
  }

  GameSession clone() {
    return GameSession(
      id: id,
      pgn: pgn,
      initialFen: initialFen,
      currentFen: currentFen,
      moveSanList: List<String>.from(moveSanList),
      moveUciList: List<String>.from(moveUciList),
      moveTimesMs: List<int>.from(moveTimesMs),
      whiteRemainingSeconds: whiteRemainingSeconds,
      blackRemainingSeconds: blackRemainingSeconds,
      timeControl: timeControl,
      openingName: openingName,
      openingEco: openingEco,
      playerColor: playerColor,
      opponentName: opponentName,
      isVsEngine: isVsEngine,
      engineElo: engineElo,
      result: result,
      thoughtNotes: Map<int, String>.from(thoughtNotes),
      engineEvaluations: Map<int, double>.from(engineEvaluations),
      diagnosedErrors: List<Map<String, dynamic>>.from(diagnosedErrors.map((e) => Map<String, dynamic>.from(e))),
      startedAt: startedAt,
      updatedAt: updatedAt,
      isCompleted: isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pgn': pgn,
        'initialFen': initialFen,
        'currentFen': currentFen,
        'moveSanList': moveSanList,
        'moveUciList': moveUciList,
        'moveTimesMs': moveTimesMs,
        'whiteRemainingSeconds': whiteRemainingSeconds,
        'blackRemainingSeconds': blackRemainingSeconds,
        'timeControl': timeControl,
        'openingName': openingName,
        'openingEco': openingEco,
        'playerColor': playerColor,
        'opponentName': opponentName,
        'isVsEngine': isVsEngine,
        'engineElo': engineElo,
        'result': result,
        'thoughtNotes': thoughtNotes.map((k, v) => MapEntry(k.toString(), v)),
        'engineEvaluations': engineEvaluations.map((k, v) => MapEntry(k.toString(), v)),
        'diagnosedErrors': diagnosedErrors,
        'startedAt': startedAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'isCompleted': isCompleted,
      };

  factory GameSession.fromJson(Map<String, dynamic> json) {
    final rawNotes = json['thoughtNotes'] as Map<String, dynamic>? ?? {};
    final notes = rawNotes.map((k, v) => MapEntry(int.parse(k), v as String));

    final rawEvals = json['engineEvaluations'] as Map<String, dynamic>? ?? {};
    final evals = rawEvals.map((k, v) => MapEntry(int.parse(k), (v as num).toDouble()));

    return GameSession(
      id: json['id'] as String,
      pgn: json['pgn'] as String? ?? '',
      initialFen: json['initialFen'] as String? ?? standardStartFen,
      currentFen: json['currentFen'] as String? ?? standardStartFen,
      moveSanList: (json['moveSanList'] as List<dynamic>?)?.cast<String>() ?? [],
      moveUciList: (json['moveUciList'] as List<dynamic>?)?.cast<String>() ?? [],
      moveTimesMs: (json['moveTimesMs'] as List<dynamic>?)?.cast<int>() ?? [],
      whiteRemainingSeconds: json['whiteRemainingSeconds'] as int? ?? 900,
      blackRemainingSeconds: json['blackRemainingSeconds'] as int? ?? 900,
      timeControl: json['timeControl'] as String? ?? '15+10 Rapid',
      openingName: json['openingName'] as String? ?? 'Starting Position',
      openingEco: json['openingEco'] as String? ?? 'A00',
      playerColor: json['playerColor'] as String? ?? 'white',
      opponentName: json['opponentName'] as String? ?? 'Stockfish Engine',
      isVsEngine: json['isVsEngine'] as bool? ?? true,
      engineElo: json['engineElo'] as int? ?? 1500,
      result: json['result'] as String? ?? '*',
      thoughtNotes: notes,
      engineEvaluations: evals,
      diagnosedErrors: (json['diagnosedErrors'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [],
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
