/// ECO (Encyclopaedia of Chess Openings) code and opening dictionary.
class EcoEntry {
  final String code;
  final String name;
  final List<String> movesSan;

  const EcoEntry({
    required this.code,
    required this.name,
    required this.movesSan,
  });
}

class EcoBook {
  static const List<EcoEntry> entries = [
    EcoEntry(code: 'C50', name: 'Giuoco Piano (Italian Game)', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Bc5']),
    EcoEntry(code: 'C53', name: 'Giuoco Pianissimo', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Bc5', 'c3', 'Nf6', 'd3']),
    EcoEntry(code: 'C60', name: 'Ruy Lopez (Spanish Opening)', movesSan: ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5']),
    EcoEntry(code: 'B20', name: 'Sicilian Defense', movesSan: ['e4', 'c5']),
    EcoEntry(code: 'B90', name: 'Sicilian Defense: Najdorf', movesSan: ['e4', 'c5', 'Nf3', 'd6', 'd4', 'cxd4', 'Nxd4', 'Nf6', 'Nc3', 'a6']),
    EcoEntry(code: 'B12', name: 'Caro-Kann Defense: Advance Variation', movesSan: ['e4', 'c6', 'd4', 'd5', 'e5']),
    EcoEntry(code: 'C00', name: 'French Defense', movesSan: ['e4', 'e6']),
    EcoEntry(code: 'D30', name: 'Queen\'s Gambit Declined', movesSan: ['d4', 'd5', 'c4', 'e6']),
    EcoEntry(code: 'D35', name: 'Queen\'s Gambit Declined: Exchange (Carlsbad)', movesSan: ['d4', 'd5', 'c4', 'e6', 'Nc3', 'Nf6', 'cxd5', 'exd5']),
    EcoEntry(code: 'E60', name: 'King\'s Indian Defense', movesSan: ['d4', 'Nf6', 'c4', 'g6']),
    EcoEntry(code: 'E20', name: 'Nimzo-Indian Defense', movesSan: ['d4', 'Nf6', 'c4', 'e6', 'Nc3', 'Bb4']),
    EcoEntry(code: 'A10', name: 'English Opening', movesSan: ['c4']),
    EcoEntry(code: 'A04', name: 'Reti Opening', movesSan: ['Nf3']),
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
}
