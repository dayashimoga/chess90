import 'package:chess_core/chess_core.dart';

/// Represents a historical master model game for educational study.
class ModelGame {
  final String id;
  final String whitePlayer;
  final String blackPlayer;
  final String event;
  final String site;
  final String year;
  final String eco;
  final String openingName;
  final String result;
  final String pgn;
  final List<String> tags;
  final String educationalSummary;
  final List<int> criticalPlies;

  const ModelGame({
    required this.id,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.event,
    required this.site,
    required this.year,
    required this.eco,
    required this.openingName,
    required this.result,
    required this.pgn,
    required this.tags,
    required this.educationalSummary,
    required this.criticalPlies,
  });

  PgnGame toPgnGame() => PgnParser.parse(pgn)!;

  Map<String, dynamic> toJson() => {
        'id': id,
        'whitePlayer': whitePlayer,
        'blackPlayer': blackPlayer,
        'event': event,
        'site': site,
        'year': year,
        'eco': eco,
        'openingName': openingName,
        'result': result,
        'pgn': pgn,
        'tags': tags,
        'educationalSummary': educationalSummary,
        'criticalPlies': criticalPlies,
      };

  factory ModelGame.fromJson(Map<String, dynamic> json) {
    return ModelGame(
      id: json['id'] as String,
      whitePlayer: json['whitePlayer'] as String,
      blackPlayer: json['blackPlayer'] as String,
      event: json['event'] as String,
      site: json['site'] as String,
      year: json['year'] as String,
      eco: json['eco'] as String,
      openingName: json['openingName'] as String,
      result: json['result'] as String,
      pgn: json['pgn'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      educationalSummary: json['educationalSummary'] as String,
      criticalPlies: (json['criticalPlies'] as List<dynamic>).cast<int>(),
    );
  }
}
