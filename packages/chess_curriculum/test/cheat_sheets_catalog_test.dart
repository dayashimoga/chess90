import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:test/test.dart';

void main() {
  group('CheatSheetsCatalog Tests', () {
    test('Catalog contains 16 comprehensive entries', () {
      expect(CheatSheetsCatalog.entries.length, equals(16));
      for (final entry in CheatSheetsCatalog.entries) {
        expect(entry.id, isNotEmpty);
        expect(entry.category, isNotEmpty);
        expect(entry.title, isNotEmpty);
        expect(entry.summary, isNotEmpty);
        expect(entry.bulletPoints, isNotEmpty);
      }
    });

    test('Entry fields and optional properties are valid', () {
      for (final entry in CheatSheetsCatalog.entries) {
        if (entry.keyQuote != null) {
          expect(entry.keyQuote, isNotEmpty);
        }
        if (entry.decisionFlowchart != null) {
          expect(entry.decisionFlowchart, isNotEmpty);
        }
        if (entry.diagramFen != null) {
          expect(entry.diagramFen, isNotEmpty);
        }
      }
    });
  });
}
