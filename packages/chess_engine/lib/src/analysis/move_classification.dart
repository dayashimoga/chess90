/// Classification of move quality based on engine evaluation swing and tactical significance.
enum MoveQuality {
  brilliant('!!', 'Brilliant', 'A stunning move, often involving a sound sacrifice that turns the game.'),
  best('*', 'Best', 'The engine\'s top-recommended move.'),
  great('!', 'Great', 'An excellent practical and strategic move.'),
  good('', 'Good', 'A natural, sound move.'),
  inaccuracy('?!', 'Inaccuracy', 'A slight slip that hands over the initiative (loss: 30-90 cp).'),
  mistake('?', 'Mistake', 'A noticeable error damaging the position (loss: 90-200 cp).'),
  blunder('??', 'Blunder', 'A catastrophic error that ruins the position (loss: >200 cp).'),
  missedWin('?!#', 'Missed Win', 'Missed an immediate forced win or checkmate.');

  final String glyph;
  final String label;
  final String description;

  const MoveQuality(this.glyph, this.label, this.description);

  bool get isNegative =>
      this == MoveQuality.inaccuracy ||
      this == MoveQuality.mistake ||
      this == MoveQuality.blunder ||
      this == MoveQuality.missedWin;

  /// Classifies a move based on centipawn loss and prior evaluation.
  /// evalBefore: score before move from player's perspective (positive = good for player)
  /// evalAfter: score after move from opponent's perspective -> invert to get player's resulting eval
  static MoveQuality classify({
    required int evalBefore,
    required int evalAfter,
    bool wasOnlyWinningMove = false,
    bool isPieceSacrifice = false,
  }) {
    final playerResultingEval = -evalAfter;
    final centipawnLoss = evalBefore - playerResultingEval;

    // Missed win: player was winning by > +300 cp, but resulting eval dropped below +100 cp
    if (evalBefore >= 300 && playerResultingEval <= 100) {
      return MoveQuality.missedWin;
    }

    // Brilliant move: sacrifice that retains or increases winning advantage
    if (isPieceSacrifice && centipawnLoss <= 20 && playerResultingEval >= 150) {
      return MoveQuality.brilliant;
    }

    if (centipawnLoss <= 10) {
      return MoveQuality.best;
    } else if (centipawnLoss <= 30) {
      return MoveQuality.great;
    } else if (centipawnLoss <= 90) {
      return MoveQuality.good;
    } else if (centipawnLoss <= 180) {
      return MoveQuality.inaccuracy;
    } else if (centipawnLoss <= 300) {
      return MoveQuality.mistake;
    } else {
      return MoveQuality.blunder;
    }
  }
}
