import 'package:chess_content/chess_content.dart';
import 'package:test/test.dart';

void main() {
  group('Opening Intelligence & ECO Recognition Tests', () {
    test('Identifies Italian Game accurately from initial moves', () {
      final italianMoves = ['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Bc5'];
      final match = EcoBook.matchByMoves(italianMoves);
      expect(match, isNotNull);
      expect(match!.code, equals('C50'));
      expect(match.name, contains('Giuoco Piano'));
      expect(match.keyPlans, isNotEmpty);
      expect(match.whyMovesWork, isNotEmpty);
    });

    test('Identifies Sicilian Najdorf from 5-ply moves', () {
      final najdorfMoves = ['e4', 'c5', 'Nf3', 'd6', 'd4', 'cxd4', 'Nxd4', 'Nf6', 'Nc3', 'a6'];
      final match = EcoBook.matchByMoves(najdorfMoves);
      expect(match, isNotNull);
      expect(match!.code, equals('B90'));
      expect(match.name, contains('Najdorf'));
    });

    test('Detects Queen\'s Gambit Declined Carlsbad structure', () {
      final qgdCarlsbad = ['d4', 'd5', 'c4', 'e6', 'Nc3', 'Nf6', 'cxd5', 'exd5'];
      final match = EcoBook.matchByMoves(qgdCarlsbad);
      expect(match, isNotNull);
      expect(match!.code, equals('D35'));
      expect(match.name, contains('Carlsbad'));
    });

    test('Diagnoses theory departure correctly when player leaves book', () {
      // White plays 1. e4, Black plays 1... e5, White plays 2. Nf3, Black deviates with 2... f6 (Damiano Defense)
      final moves = ['e4', 'e5', 'Nf3', 'f6'];
      final report = EcoBook.analyzeDeparture(moves);

      expect(report.isTheoryFollowedThrough, isFalse);
      expect(report.departureColor, equals('Black'));
      expect(report.playedMove, equals('f6'));
      expect(report.departureMoveNumber, equals(2));
      expect(report.standardTheoryMoves, contains('Nc6'));
      expect(report.strategicConsequence, contains('departed from standard theory'));
    });

    test('Confirms theory followed through when all moves are in book', () {
      final bookMoves = ['e4', 'e5', 'Nf3', 'Nc6', 'Bb5'];
      final report = EcoBook.analyzeDeparture(bookMoves);

      expect(report.isTheoryFollowedThrough, isTrue);
      expect(report.lastBookEntry, isNotNull);
      expect(report.lastBookEntry!.code, equals('C60'));
      expect(report.strategicConsequence, contains('Moves conform to standard master opening theory'));
    });

    test('Provides curated White and Black repertoires', () {
      expect(EcoBook.repertoireWhiteE4, isNotEmpty);
      expect(EcoBook.repertoireWhiteD4, isNotEmpty);
      expect(EcoBook.repertoireBlackVsE4, isNotEmpty);
      expect(EcoBook.repertoireBlackVsD4, isNotEmpty);
      expect(EcoBook.repertoireBlackVsC4, isNotEmpty);

      // Verify every repertoire entry has valid metadata
      for (final entry in EcoBook.repertoireWhiteE4) {
        expect(entry.whyMovesWork, isNotEmpty);
        expect(entry.criticalPawnBreaks, isNotEmpty);
        expect(entry.keyPlans, isNotEmpty);
      }
    });
  });
}
