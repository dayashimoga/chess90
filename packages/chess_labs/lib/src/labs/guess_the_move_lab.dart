import '../lab_session.dart';

/// Model game guess-the-move lab.
/// Plays through historic master games; at critical turns, user must guess the GM move.
class GuessTheMoveLab extends LabSession {
  final String event;
  final String whitePlayer;
  final String blackPlayer;
  final int targetPly;

  GuessTheMoveLab({
    required super.id,
    required super.title,
    required super.initialFen,
    required super.solutionSan,
    required this.event,
    required this.whitePlayer,
    required this.blackPlayer,
    required this.targetPly,
    required super.explanation,
    super.hints,
  }) : super(labType: 'guess_the_move');
}
