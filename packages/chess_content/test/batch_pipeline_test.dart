import 'dart:io';
import 'package:chess_content/chess_content.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Batch PGN Content Factory Tests', () {
    late Directory tempPgnDir;
    late Directory tempOutDir;
    late ChessEngine engine;

    setUp(() async {
      tempPgnDir = Directory.systemTemp.createTempSync('chess_batch_pgn_in_');
      tempOutDir = Directory.systemTemp.createTempSync('chess_batch_pgn_out_');

      engine = EmbeddedHeuristicEngine();
      await engine.initialize();

      // Write sample PGN 1
      final pgn1 = File('${tempPgnDir.path}${Platform.pathSeparator}opera.pgn');
      pgn1.writeAsStringSync('''
[Event "Paris Opera House"]
[Site "Paris FRA"]
[Date "1858.11.02"]
[Round "1"]
[White "Morphy, Paul"]
[Black "Duke of Brunswick and Count Isouard"]
[Result "1-0"]
[ECO "C41"]

1. e4 e5 2. Nf3 d6 3. d4 Bg4 4. dxe5 Bxf3 5. Qxf3 dxe5 6. Bc4 Nf6 7. Qb3 Qe7 8. Nc3 c6 9. Bg5 b5 10. Nxb5 cxb5 11. Bxb5+ Nbd7 12. O-O-O Rd8 13. Rxd7 Rxd7 14. Rd1 Qe6 15. Bxd7+ Nxd7 16. Qb8+ Nxb8 17. Rd8# 1-0
''');

      // Write sample PGN 2
      final pgn2 = File('${tempPgnDir.path}${Platform.pathSeparator}miniature.pgn');
      pgn2.writeAsStringSync('''
[Event "Quick Win"]
[Site "Club"]
[Date "2024.01.01"]
[White "Tactician"]
[Black "Defender"]
[Result "1-0"]

1. e4 e5 2. Bc4 Nc6 3. Qh5 Nf6 4. Qxf7# 1-0
''');
    });

    tearDown(() async {
      await engine.dispose();
      try {
        if (tempPgnDir.existsSync()) tempPgnDir.deleteSync(recursive: true);
        if (tempOutDir.existsSync()) tempOutDir.deleteSync(recursive: true);
      } catch (_) {}
    });

    test('Batch pipeline processes PGN folder, extracts puzzles, and outputs catalog JSON', () async {
      final pipeline = BatchPgnPipeline(engine: engine);

      const provenance = ContentProvenance(
        source: 'Historical Chess Archives & Public PGN Collections',
        license: 'Public Domain / CC0',
        attribution: 'Open Chess Heritage Project',
        isPublicDomain: true,
      );

      final result = await pipeline.processDirectory(
        pgnDirectoryPath: tempPgnDir.path,
        outputDirectoryPath: tempOutDir.path,
        defaultProvenance: provenance,
      );

      expect(result.totalGamesProcessed, equals(2));
      expect(result.totalLessonsGenerated, equals(2));
      expect(result.analyzedGames.length, equals(2));

      // Verify catalog JSON
      final catalogFile = File(result.catalogJsonPath);
      expect(catalogFile.existsSync(), isTrue);
      expect(catalogFile.lengthSync(), greaterThan(200));

      // Verify pipeline report JSON
      final reportFile = File(result.reportJsonPath);
      expect(reportFile.existsSync(), isTrue);
      expect(reportFile.lengthSync(), greaterThan(200));

      // Verify Morphy Opera game properties
      final morphyGame = result.analyzedGames.firstWhere((g) => g.white.contains('Morphy'));
      expect(morphyGame.provenance.isPublicDomain, isTrue);
      expect(morphyGame.provenance.license, equals('Public Domain / CC0'));
      expect(morphyGame.pawnStructure.isNotEmpty, isTrue);
      expect(morphyGame.tags, contains('Historical Significance'));
      expect(morphyGame.tags, contains('White Victory'));
      expect(morphyGame.educationalTakeaways.isNotEmpty, isTrue);
    });
  });
}
