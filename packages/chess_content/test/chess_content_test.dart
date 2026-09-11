import 'package:chess_content/chess_content.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Model Games Database Tests', () {
    test('Curated games database has valid PGNs', () {
      const games = ModelGamesDatabase.curatedGames;
      expect(games.length, greaterThanOrEqualTo(4));

      for (final game in games) {
        final pgn = game.toPgnGame();
        expect(pgn.moves.isNotEmpty, isTrue);
        expect(game.whitePlayer.isNotEmpty, isTrue);
        expect(game.educationalSummary.isNotEmpty, isTrue);
      }
    });

    test('Search by player and tag', () {
      final morphyGames = ModelGamesDatabase.search(query: 'Morphy');
      expect(morphyGames.length, equals(1));
      expect(morphyGames.first.id, equals('morphy_opera_1858'));

      final sacGames = ModelGamesDatabase.search(tag: 'Queen Sacrifice');
      expect(sacGames.length, greaterThanOrEqualTo(2));
    });

    test('ECO opening matching', () {
      final eco = EcoBook.matchByMoves(['e4', 'c5', 'Nf3', 'd6', 'd4', 'cxd4', 'Nxd4', 'Nf6', 'Nc3', 'a6']);
      expect(eco, isNotNull);
      expect(eco!.code, equals('B90'));
      expect(eco.name, contains('Najdorf'));
    });

    test('Puzzle miner extracts puzzles from PGN', () async {
      final engine = EmbeddedHeuristicEngine();
      await engine.initialize();
      final miner = PuzzleMiner(engine: engine);

      const pgn = '''
[Event "Miniature"]
[White "Player1"]
[Black "Player2"]
[Result "1-0"]

1. e4 e5 2. Bc4 Nc6 3. Qh5 d6 4. Qxf7# 1-0
''';

      final puzzles = await miner.minePuzzlesFromPgn(pgn, minCentipawnSwing: 100);
      expect(puzzles.isNotEmpty, isTrue);
      expect(puzzles.first.solutionSan.isNotEmpty, isTrue);
      await engine.dispose();
    });
  });
}
