/// ECO (Encyclopaedia of Chess Openings) code, opening dictionary, and strategic plan guide.
class EcoEntry {
  final String code;
  final String name;
  final List<String> movesSan;
  final String whyMovesWork;
  final List<String> keyPlans;
  final String typicalPawnStructures;
  final List<String> criticalPawnBreaks;
  final String tacticsAndTraps;
  final String repertoireCategory;

  const EcoEntry({
    required this.code,
    required this.name,
    required this.movesSan,
    this.whyMovesWork = 'Establishes central pawn control, rapid knight/bishop development, and king safety.',
    this.keyPlans = const [
      'Contest key central outposts',
      'Harmonize rook placement on open files',
      'Execute central pawn levers at the optimal moment',
    ],
    this.typicalPawnStructures = 'Central pawn tension with symmetric or asymmetric dynamic breaks.',
    this.criticalPawnBreaks = const ['d4 / d5', 'e4 / e5', 'c4 / c5', 'f4 / f5'],
    this.tacticsAndTraps = 'Watch for f7/f2 pressure, relative pins on the d-file, and queenside counter-levers.',
    this.repertoireCategory = 'General',
  });
}

class EcoBook {
  static const List<EcoEntry> entries = [
    EcoEntry(code: 'C50', name: 'Giuoco Piano (Italian Game)', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Bc5']),
    EcoEntry(code: 'C53', name: 'Giuoco Pianissimo', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Bc5', 'c3', 'Nf6', 'd3']),
    EcoEntry(code: 'C51', name: 'Evans Gambit', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Bc5', 'b4']),
    EcoEntry(code: 'C55', name: 'Two Knights Defense', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Nf6']),
    EcoEntry(code: 'C57', name: 'Two Knights: Fried Liver Attack', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Nf6', 'Ng5', 'd5', 'exd5', 'Nxd5']),
    EcoEntry(code: 'C60', name: 'Ruy Lopez (Spanish Opening)', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5']),
    EcoEntry(code: 'C65', name: 'Ruy Lopez: Berlin Defense', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'Nf6']),
    EcoEntry(code: 'C68', name: 'Ruy Lopez: Exchange Variation', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6', 'Bxc6', 'dxc6']),
    EcoEntry(code: 'C78', name: 'Ruy Lopez: Archangelsk Variation', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6', 'Ba4', 'Nf6', 'O-O', 'b5', 'Bb3', 'Bb7']),
    EcoEntry(code: 'C88', name: 'Ruy Lopez: Closed (Anti-Marshall)', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6', 'Ba4', 'Nf6', 'O-O', 'Be7', 'Re1', 'b5', 'Bb3', 'O-O', 'h3']),
    EcoEntry(code: 'C89', name: 'Ruy Lopez: Marshall Attack', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5', 'a6', 'Ba4', 'Nf6', 'O-O', 'Be7', 'Re1', 'b5', 'Bb3', 'O-O', 'c3', 'd5']),
    EcoEntry(code: 'C45', name: 'Scotch Game', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'd4', 'exd4', 'Nxd4']),
    EcoEntry(code: 'C42', name: 'Petrov Defense (Russian Game)', movesSan: ['e4', 'e5', 'Nf3', 'Nf6']),
    EcoEntry(code: 'C41', name: 'Philidor Defense', movesSan: ['e4', 'e5', 'Nf3', 'd6']),
    EcoEntry(code: 'C30', name: 'King\'s Gambit', movesSan: ['e4', 'e5', 'f4']),
    EcoEntry(code: 'C33', name: 'King\'s Gambit Accepted', movesSan: ['e4', 'e5', 'f4', 'exf4']),
    EcoEntry(code: 'C20', name: 'King\'s Pawn Game', movesSan: ['e4', 'e5']),
    EcoEntry(code: 'B20', name: 'Sicilian Defense', movesSan: ['e4', 'c5']),
    EcoEntry(code: 'B22', name: 'Sicilian Defense: Alapin Variation', movesSan: ['e4', 'c5', 'c3']),
    EcoEntry(code: 'B23', name: 'Sicilian Defense: Closed', movesSan: ['e4', 'c5', 'Nc3']),
    EcoEntry(code: 'B33', name: 'Sicilian Defense: Sveshnikov', movesSan: ['e4', 'c5', 'Nf3', 'Nc6', 'd4', 'cxd4', 'Nxd4', 'Nf6', 'Nc3', 'e5']),
    EcoEntry(code: 'B70', name: 'Sicilian Defense: Dragon', movesSan: ['e4', 'c5', 'Nf3', 'd6', 'd4', 'cxd4', 'Nxd4', 'Nf6', 'Nc3', 'g6']),
    EcoEntry(code: 'B90', name: 'Sicilian Defense: Najdorf', movesSan: ['e4', 'c5', 'Nf3', 'd6', 'd4', 'cxd4', 'Nxd4', 'Nf6', 'Nc3', 'a6']),
    EcoEntry(code: 'B50', name: 'Sicilian Defense: Classical', movesSan: ['e4', 'c5', 'Nf3', 'd6', 'd4', 'cxd4', 'Nxd4', 'Nf6', 'Nc3', 'Nc6']),
    EcoEntry(code: 'B40', name: 'Sicilian Defense: Paulsen / Kan', movesSan: ['e4', 'c5', 'Nf3', 'e6', 'd4', 'cxd4', 'Nxd4', 'a6']),
    EcoEntry(code: 'B10', name: 'Caro-Kann Defense', movesSan: ['e4', 'c6']),
    EcoEntry(code: 'B12', name: 'Caro-Kann Defense: Advance Variation', movesSan: ['e4', 'c6', 'd4', 'd5', 'e5']),
    EcoEntry(code: 'B13', name: 'Caro-Kann Defense: Exchange Variation', movesSan: ['e4', 'c6', 'd4', 'd5', 'exd5', 'cxd5']),
    EcoEntry(code: 'B14', name: 'Caro-Kann Defense: Panov-Botvinnik Attack', movesSan: ['e4', 'c6', 'd4', 'd5', 'exd5', 'cxd5', 'c4']),
    EcoEntry(code: 'B18', name: 'Caro-Kann Defense: Classical (Capablanca)', movesSan: ['e4', 'c6', 'd4', 'd5', 'Nc3', 'dxe4', 'Nxe4', 'Bf5']),
    EcoEntry(code: 'C00', name: 'French Defense', movesSan: ['e4', 'e6']),
    EcoEntry(code: 'C02', name: 'French Defense: Advance Variation', movesSan: ['e4', 'e6', 'd4', 'd5', 'e5']),
    EcoEntry(code: 'C05', name: 'French Defense: Tarrasch Variation', movesSan: ['e4', 'e6', 'd4', 'd5', 'Nd2']),
    EcoEntry(code: 'C10', name: 'French Defense: Classical (Paulsen)', movesSan: ['e4', 'e6', 'd4', 'd5', 'Nc3', 'Nf6']),
    EcoEntry(code: 'C15', name: 'French Defense: Winawer Variation', movesSan: ['e4', 'e6', 'd4', 'd5', 'Nc3', 'Bb4']),
    EcoEntry(code: 'B01', name: 'Scandinavian Defense', movesSan: ['e4', 'd5']),
    EcoEntry(code: 'B02', name: 'Alekhine Defense', movesSan: ['e4', 'Nf6']),
    EcoEntry(code: 'B06', name: 'Robatsch / Modern Defense', movesSan: ['e4', 'g6']),
    EcoEntry(code: 'B07', name: 'Pirc Defense', movesSan: ['e4', 'd6', 'd4', 'Nf6', 'Nc3', 'g6']),
    EcoEntry(code: 'D00', name: 'Queen\'s Pawn Game', movesSan: ['d4', 'd5']),
    EcoEntry(code: 'D02', name: 'London System', movesSan: ['d4', 'd5', 'Nf3', 'Nf6', 'Bf4']),
    EcoEntry(code: 'D06', name: 'Queen\'s Gambit', movesSan: ['d4', 'd5', 'c4']),
    EcoEntry(code: 'D20', name: 'Queen\'s Gambit Accepted', movesSan: ['d4', 'd5', 'c4', 'dxc4']),
    EcoEntry(code: 'D30', name: 'Queen\'s Gambit Declined', movesSan: ['d4', 'd5', 'c4', 'e6']),
    EcoEntry(code: 'D35', name: 'Queen\'s Gambit Declined: Exchange (Carlsbad)', movesSan: ['d4', 'd5', 'c4', 'e6', 'Nc3', 'Nf6', 'cxd5', 'exd5']),
    EcoEntry(code: 'D38', name: 'Queen\'s Gambit Declined: Ragozin Defense', movesSan: ['d4', 'd5', 'c4', 'e6', 'Nc3', 'Nf6', 'Nf3', 'Bb4']),
    EcoEntry(code: 'D40', name: 'Queen\'s Gambit Declined: Semi-Tarrasch', movesSan: ['d4', 'd5', 'c4', 'e6', 'Nc3', 'Nf6', 'Nf3', 'c5']),
    EcoEntry(code: 'D45', name: 'Semi-Slav Defense', movesSan: ['d4', 'd5', 'c4', 'c6', 'Nc3', 'Nf6', 'e3', 'e6']),
    EcoEntry(code: 'D47', name: 'Semi-Slav Defense: Meran Variation', movesSan: ['d4', 'd5', 'c4', 'c6', 'Nc3', 'Nf6', 'Nf3', 'e6', 'e3', 'Nbd7', 'Bd3', 'dxc4', 'Bxc4', 'b5']),
    EcoEntry(code: 'D10', name: 'Slav Defense', movesSan: ['d4', 'd5', 'c4', 'c6']),
    EcoEntry(code: 'D15', name: 'Slav Defense: Chebanenko Variation', movesSan: ['d4', 'd5', 'c4', 'c6', 'Nf3', 'Nf6', 'Nc3', 'a6']),
    EcoEntry(code: 'D55', name: 'Queen\'s Gambit Declined: Classical Main Line', movesSan: ['d4', 'd5', 'c4', 'e6', 'Nc3', 'Nf6', 'Bg5', 'Be7', 'e3', 'O-O', 'Nf3', 'h6', 'Bh4']),
    EcoEntry(code: 'E60', name: 'King\'s Indian Defense', movesSan: ['d4', 'Nf6', 'c4', 'g6']),
    EcoEntry(code: 'E66', name: 'King\'s Indian Defense: Classical Fianchetto', movesSan: ['d4', 'Nf6', 'c4', 'g6', 'g3', 'Bg7', 'Bg2', 'O-O', 'Nf3', 'd6', 'O-O', 'c5', 'd5']),
    EcoEntry(code: 'E97', name: 'King\'s Indian Defense: Mar del Plata Variation', movesSan: ['d4', 'Nf6', 'c4', 'g6', 'Nc3', 'Bg7', 'e4', 'd6', 'Nf3', 'O-O', 'Be2', 'e5', 'O-O', 'Nc6', 'd5', 'Ne7']),
    EcoEntry(code: 'E20', name: 'Nimzo-Indian Defense', movesSan: ['d4', 'Nf6', 'c4', 'e6', 'Nc3', 'Bb4']),
    EcoEntry(code: 'E49', name: 'Nimzo-Indian Defense: Botvinnik System', movesSan: ['d4', 'Nf6', 'c4', 'e6', 'Nc3', 'Bb4', 'e3', 'd5', 'a3', 'Bxc3+', 'bxc3']),
    EcoEntry(code: 'E32', name: 'Nimzo-Indian Defense: Classical (Capablanca)', movesSan: ['d4', 'Nf6', 'c4', 'e6', 'Nc3', 'Bb4', 'Qc2']),
    EcoEntry(code: 'E00', name: 'Catalan Opening', movesSan: ['d4', 'Nf6', 'c4', 'e6', 'g3']),
    EcoEntry(code: 'E06', name: 'Catalan Opening: Closed', movesSan: ['d4', 'Nf6', 'c4', 'e6', 'g3', 'd5', 'Bg2', 'Be7', 'Nf3', 'O-O', 'O-O']),
    EcoEntry(code: 'E12', name: 'Queen\'s Indian Defense', movesSan: ['d4', 'Nf6', 'c4', 'e6', 'Nf3', 'b6']),
    EcoEntry(code: 'D90', name: 'Grunfeld Defense', movesSan: ['d4', 'Nf6', 'c4', 'g6', 'Nc3', 'd5']),
    EcoEntry(code: 'D85', name: 'Grunfeld Defense: Exchange Variation', movesSan: ['d4', 'Nf6', 'c4', 'g6', 'Nc3', 'd5', 'cxd5', 'Nxd5', 'e4', 'Nxc3', 'bxc3']),
    EcoEntry(code: 'A56', name: 'Benoni Defense', movesSan: ['d4', 'Nf6', 'c4', 'c5', 'd5']),
    EcoEntry(code: 'A57', name: 'Benko Gambit', movesSan: ['d4', 'Nf6', 'c4', 'c5', 'd5', 'b5']),
    EcoEntry(code: 'A80', name: 'Dutch Defense', movesSan: ['d4', 'f5']),
    EcoEntry(code: 'A10', name: 'English Opening', movesSan: ['c4']),
    EcoEntry(code: 'A20', name: 'English Opening: King\'s English', movesSan: ['c4', 'e5']),
    EcoEntry(code: 'A30', name: 'English Opening: Symmetrical Variation', movesSan: ['c4', 'c5']),
    EcoEntry(code: 'A04', name: 'Reti Opening', movesSan: ['Nf3']),
    EcoEntry(code: 'A07', name: 'King\'s Indian Attack', movesSan: ['Nf3', 'd5', 'g3', 'Nf6', 'Bg2', 'e6', 'O-O']),
    EcoEntry(code: 'A01', name: 'Nimzowitsch-Larsen Attack', movesSan: ['b3']),
  ];

  static EcoEntry? matchByMoves(List<String> playedSan) {
    EcoEntry? bestMatch;
    int maxLen = 0;

    for (final entry in entries) {
      if (playedSan.length >= entry.movesSan.length) {
        bool matches = true;
        for (int i = 0; i < entry.movesSan.length; i++) {
          if (playedSan[i].replaceAll(RegExp(r'[+#?!]'), '') != entry.movesSan[i].replaceAll(RegExp(r'[+#?!]'), '')) {
            matches = false;
            break;
          }
        }
        if (matches && entry.movesSan.length > maxLen) {
          bestMatch = entry;
          maxLen = entry.movesSan.length;
        }
      }
    }

    return bestMatch;
  }

  /// Evaluates game move history to detect the exact departure from theory,
  /// identifying the last recognized ECO code, the deviating move, and strategic implications.
  static OpeningDepartureReport analyzeDeparture(List<String> playedSan) {
    if (playedSan.isEmpty) {
      return const OpeningDepartureReport(
        lastBookEntry: null,
        departureMoveIndex: -1,
        departureMoveNumber: 0,
        departureColor: '',
        playedMove: '',
        standardTheoryMoves: ['e4', 'd4', 'Nf3', 'c4'],
        strategicConsequence: 'Game ready to begin.',
        recommendedPlan: 'Occupy or contest the center with 1. e4 or 1. d4.',
      );
    }

    final cleaned = playedSan.map((m) => m.replaceAll(RegExp(r'[+#?!]'), '')).toList();

    EcoEntry? deepestMatch;
    int deepestMatchedLength = 0;

    for (final entry in entries) {
      final entryCleaned = entry.movesSan.map((m) => m.replaceAll(RegExp(r'[+#?!]'), '')).toList();
      int matchCount = 0;
      final checkLen = cleaned.length < entryCleaned.length ? cleaned.length : entryCleaned.length;
      for (int i = 0; i < checkLen; i++) {
        if (cleaned[i] == entryCleaned[i]) {
          matchCount++;
        } else {
          break;
        }
      }
      if (matchCount > deepestMatchedLength) {
        deepestMatchedLength = matchCount;
        deepestMatch = entry;
      }
    }

    if (deepestMatchedLength == cleaned.length) {
      final nextBookCandidates = <String>{};
      for (final entry in entries) {
        final entryCleaned = entry.movesSan.map((m) => m.replaceAll(RegExp(r'[+#?!]'), '')).toList();
        if (entryCleaned.length > cleaned.length) {
          bool prefixMatches = true;
          for (int i = 0; i < cleaned.length; i++) {
            if (cleaned[i] != entryCleaned[i]) {
              prefixMatches = false;
              break;
            }
          }
          if (prefixMatches) {
            nextBookCandidates.add(entry.movesSan[cleaned.length]);
          }
        }
      }

      return OpeningDepartureReport(
        lastBookEntry: deepestMatch ?? matchByMoves(playedSan),
        departureMoveIndex: -1,
        departureMoveNumber: (cleaned.length ~/ 2) + 1,
        departureColor: cleaned.length.isOdd ? 'Black' : 'White',
        playedMove: '',
        standardTheoryMoves: nextBookCandidates.toList(),
        strategicConsequence: 'Moves conform to standard master opening theory.',
        recommendedPlan: deepestMatch?.keyPlans.join(' · ') ?? 'Maintain active piece development and king safety.',
      );
    }

    final depIdx = deepestMatchedLength;
    final moveNum = (depIdx ~/ 2) + 1;
    final depColor = depIdx.isEven ? 'White' : 'Black';
    final playedMove = playedSan[depIdx];

    final bookMovesAtDeviation = <String>{};
    for (final entry in entries) {
      final entryCleaned = entry.movesSan.map((m) => m.replaceAll(RegExp(r'[+#?!]'), '')).toList();
      if (entryCleaned.length > depIdx) {
        bool prefixMatches = true;
        for (int i = 0; i < depIdx; i++) {
          if (cleaned[i] != entryCleaned[i]) {
            prefixMatches = false;
            break;
          }
        }
        if (prefixMatches) {
          bookMovesAtDeviation.add(entry.movesSan[depIdx]);
        }
      }
    }

    final lastEntry = matchByMoves(playedSan.sublist(0, depIdx));

    return OpeningDepartureReport(
      lastBookEntry: lastEntry,
      departureMoveIndex: depIdx,
      departureMoveNumber: moveNum,
      departureColor: depColor,
      playedMove: playedMove,
      standardTheoryMoves: bookMovesAtDeviation.toList(),
      strategicConsequence: '$depColor departed from standard theory with $moveNum.${depColor == "Black" ? "..." : ""} $playedMove (book alternatives: ${bookMovesAtDeviation.take(3).join(", ")}). The game transitions from memorized book lines to concrete middlegame planning.',
      recommendedPlan: lastEntry != null && lastEntry.keyPlans.isNotEmpty
          ? 'Exploit departure by executing thematic plans: ${lastEntry.keyPlans.join("; ")}.'
          : 'Contest the center, solidify king safety, and seek candidate moves against unprotected enemy pieces.',
    );
  }

  /// White 1. e4 repertoire lines
  static List<EcoEntry> get repertoireWhiteE4 =>
      entries.where((e) => e.movesSan.isNotEmpty && e.movesSan.first == 'e4').toList();

  /// White 1. d4 repertoire lines
  static List<EcoEntry> get repertoireWhiteD4 =>
      entries.where((e) => e.movesSan.isNotEmpty && e.movesSan.first == 'd4').toList();

  /// Black defenses vs 1. e4 (Sicilian, French, Caro-Kann, e5)
  static List<EcoEntry> get repertoireBlackVsE4 =>
      entries.where((e) => e.movesSan.length >= 2 && e.movesSan.first == 'e4').toList();

  /// Black defenses vs 1. d4 (Nimzo, King's Indian, Grunfeld, Slav, QGD)
  static List<EcoEntry> get repertoireBlackVsD4 =>
      entries.where((e) => e.movesSan.length >= 2 && e.movesSan.first == 'd4').toList();

  /// Black defenses vs 1. c4 (English)
  static List<EcoEntry> get repertoireBlackVsC4 =>
      entries.where((e) => e.movesSan.isNotEmpty && e.movesSan.first == 'c4').toList();
}

/// Diagnostic report generated when a played game deviates from established book opening theory.
class OpeningDepartureReport {
  final EcoEntry? lastBookEntry;
  final int departureMoveIndex;
  final int departureMoveNumber;
  final String departureColor;
  final String playedMove;
  final List<String> standardTheoryMoves;
  final String strategicConsequence;
  final String recommendedPlan;

  const OpeningDepartureReport({
    this.lastBookEntry,
    required this.departureMoveIndex,
    required this.departureMoveNumber,
    required this.departureColor,
    required this.playedMove,
    required this.standardTheoryMoves,
    required this.strategicConsequence,
    required this.recommendedPlan,
  });

  bool get isTheoryFollowedThrough => departureMoveIndex == -1;
}

