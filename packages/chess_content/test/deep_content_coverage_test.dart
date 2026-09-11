import 'dart:io';
import 'package:chess_content/chess_content.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Deep Chess Content Coverage & Model Games Tests', () {
    test('ModelGame serialization and PGN parsing', () {
      final game = ModelGamesDatabase.curatedGames.first;
      final json = game.toJson();
      final restored = ModelGame.fromJson(json);

      expect(restored.id, game.id);
      expect(restored.whitePlayer, game.whitePlayer);
      expect(restored.blackPlayer, game.blackPlayer);
      expect(restored.event, game.event);
      expect(restored.eco, game.eco);
      expect(restored.tags, game.tags);

      final pgn = restored.toPgnGame();
      expect(pgn.moves.length, greaterThan(0));
    });

    test('ModelGamesDatabase search and filtering', () {
      expect(ModelGamesDatabase.search().length, ModelGamesDatabase.curatedGames.length);

      final morphyGames = ModelGamesDatabase.search(query: 'Morphy');
      expect(morphyGames.length, 1);
      expect(morphyGames.first.whitePlayer, contains('Morphy'));

      final endgameGames = ModelGamesDatabase.search(tag: 'Endgame Technique');
      expect(endgameGames.length, 1);
      expect(endgameGames.first.whitePlayer, contains('Capablanca'));

      final c41Games = ModelGamesDatabase.search(eco: 'C41');
      expect(c41Games.length, 1);

      final byId = ModelGamesDatabase.getById('morphy_opera_1858');
      expect(byId, isNotNull);

      final missing = ModelGamesDatabase.getById('non_existent');
      expect(missing, isNull);
    });

    test('EcoBook matching and dictionary coverage', () {
      expect(EcoBook.entries.length, greaterThan(10));

      final italian = EcoBook.matchByMoves(['e4', 'e5', 'Nf3', 'Nc6', 'Bc4', 'Bc5']);
      expect(italian, isNotNull);
      expect(italian!.code, 'C50');

      final sicilian = EcoBook.matchByMoves(['e4', 'c5', 'Nf3']);
      expect(sicilian, isNotNull);
      expect(sicilian!.code, 'B20');

      final unknown = EcoBook.matchByMoves(['h4', 'h5']);
      expect(unknown, isNull);
    });

    test('ContentProvenance and BatchPgnPipeline coverage', () async {
      const prov = ContentProvenance(
        source: 'Test Tournament',
        license: 'CC0',
        attribution: 'Test Author',
        isPublicDomain: true,
      );
      final provJson = prov.toJson();
      final restoredProv = ContentProvenance.fromJson(provJson);
      expect(restoredProv.source, 'Test Tournament');
      expect(restoredProv.license, 'CC0');

      final tempDir = Directory.systemTemp.createTempSync('batch_pipeline_test_');
      final pgnFile = File('${tempDir.path}/opera.pgn');
      pgnFile.writeAsStringSync('''
[Event "Paris Opera"]
[Site "Paris"]
[Date "1858.11.02"]
[Round "1"]
[White "Morphy"]
[Black "Duke Karl"]
[Result "1-0"]

1. e4 e5 2. Nf3 d6 3. d4 Bg4 4. dxe5 Bxf3 5. Qxf3 dxe5 6. Bc4 Nf6 7. Qb3 1-0
''');

      final outDir = '${tempDir.path}/out';
      final engine = EmbeddedHeuristicEngine();
      await engine.initialize();

      final pipeline = BatchPgnPipeline(engine: engine);
      final result = await pipeline.processDirectory(
        pgnDirectoryPath: tempDir.path,
        outputDirectoryPath: outDir,
        onProgress: (_) {},
      );

      expect(result.totalGamesProcessed, 1);
      expect(result.analyzedGames.length, 1);
      expect(result.toJson()['totalGamesProcessed'], 1);

      await engine.dispose();
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    });
  });
}
