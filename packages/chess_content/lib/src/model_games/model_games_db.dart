import 'model_game.dart';

/// Database of public-domain historical master model games for deep instructional analysis.
class ModelGamesDatabase {
  static const List<ModelGame> curatedGames = [
    ModelGame(
      id: 'morphy_opera_1858',
      whitePlayer: 'Paul Morphy',
      blackPlayer: 'Duke of Brunswick & Count Isouard',
      event: 'Paris Opera House',
      site: 'Paris, France',
      year: '1858',
      eco: 'C41',
      openingName: 'Philidor Defense',
      result: '1-0',
      tags: ['Development', 'King Attack', 'Queen Sacrifice', 'Back-Rank Mate'],
      educationalSummary: 'The quintessential lesson on rapid development, opening lines against an uncastled king, and queen sacrifice into pin-mate.',
      criticalPlies: [15, 17, 23, 29, 31],
      pgn: '''[Event "Paris Opera House"]
[Site "Paris FRA"]
[Date "1858.11.02"]
[Round "1"]
[White "Morphy, Paul"]
[Black "Duke of Brunswick and Count Isouard"]
[Result "1-0"]
[ECO "C41"]

1. e4 e5 2. Nf3 d6 3. d4 Bg4 4. dxe5 Bxf3 5. Qxf3 dxe5 6. Bc4 Nf6 7. Qb3 Qe7 8. Nc3 c6 9. Bg5 b5 10. Nxb5 cxb5 11. Bxb5+ Nbd7 12. O-O-O Rd8 13. Rxd7 Rxd7 14. Rd1 Qe6 15. Bxd7+ Nxd7 16. Qb8+ Nxb8 17. Rd8# 1-0''',
    ),
    ModelGame(
      id: 'capablanca_tartakower_1924',
      whitePlayer: 'Jose Raul Capablanca',
      blackPlayer: 'Savielly Tartakower',
      event: 'New York International',
      site: 'New York, USA',
      year: '1924',
      eco: 'A80',
      openingName: 'Dutch Defense',
      result: '1-0',
      tags: ['Endgame Technique', 'King Infiltration', 'Rook on 7th', 'Pawn Majority'],
      educationalSummary: 'Capablanca\'s textbook demonstration of active rook placement, king march through the board, and converting an endgame advantage.',
      criticalPlies: [45, 53, 67, 73],
      pgn: '''[Event "New York International"]
[Site "New York, NY USA"]
[Date "1924.03.23"]
[Round "5"]
[White "Capablanca, Jose Raul"]
[Black "Tartakower, Savielly"]
[Result "1-0"]
[ECO "A80"]

1. d4 f5 2. Nf3 e6 3. c4 Nf6 4. Bg5 Be7 5. Nc3 O-O 6. e3 b6 7. Bd3 Bb7 8. O-O Ne4 9. Bxe7 Qxe7 10. Bxe4 fxe4 11. Nd2 d5 12. Qb3 c6 13. f3 exf3 14. Rxf3 Rxf3 15. Nxf3 Nd7 16. Re1 Qd6 17. e4 dxe4 18. Nxe4 Qf4 19. c5 Re8 20. Nd6 Re7 21. Nxb7 1-0''',
    ),
    ModelGame(
      id: 'byrne_fischer_1956',
      whitePlayer: 'Donald Byrne',
      blackPlayer: 'Bobby Fischer',
      event: 'Rosenwald Memorial',
      site: 'New York, USA',
      year: '1956',
      eco: 'D92',
      openingName: 'Gruenfeld Defense',
      result: '0-1',
      tags: ['Queen Sacrifice', 'Tactics', 'Piece Harmony', 'Windmill'],
      educationalSummary: 'Fischer\'s "Game of the Century" at age 13 featuring the legendary 17...Be6!! queen sacrifice exposing White\'s uncastled king.',
      criticalPlies: [33, 34, 35, 41],
      pgn: '''[Event "Third Rosenwald Trophy"]
[Site "New York, NY USA"]
[Date "1956.10.17"]
[Round "8"]
[White "Byrne, Donald"]
[Black "Fischer, Robert James"]
[Result "0-1"]
[ECO "D92"]

1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7 4. d4 O-O 5. Bf4 d5 6. Qb3 dxc4 7. Qxc4 c6 8. e4 Nbd7 9. Rd1 Nb6 10. Qc5 Bg4 11. Bg5 Na4 12. Qa3 Nxc3 13. bxc3 Nxe4 14. Bxe7 Qb6 15. Bc4 Nxc3 16. Bc5 Rfe8+ 17. Kf1 Be6 18. Bxb6 Bxc4+ 19. Kg1 Ne2+ 20. Kf1 Nxd4+ 21. Kg1 Ne2+ 22. Kf1 Nc3+ 23. Kg1 axb6 24. Qb4 Ra4 25. Qxb6 Nxd1 0-1''',
    ),
    ModelGame(
      id: 'rubinstein_rotlewi_1907',
      whitePlayer: 'Gersz Rotlewi',
      blackPlayer: 'Akiba Rubinstein',
      event: 'Lodz Championship',
      site: 'Lodz, Poland',
      year: '1907',
      eco: 'D40',
      openingName: 'Queen\'s Gambit Declined',
      result: '0-1',
      tags: ['Double Sacrifice', 'Queen Sacrifice', 'Piece Concentration', 'Deflection'],
      educationalSummary: 'Rubinstein\'s Immortal: a breathtaking coordination of rooks, bishops, and knight culminating in 22...Rxc3!! and 23...Rd2!!',
      criticalPlies: [43, 44, 45, 49],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1907.12.26"]
[Round "6"]
[White "Rotlewi, Gersz"]
[Black "Rubinstein, Akiba"]
[Result "0-1"]
[ECO "D40"]

1. d4 d5 2. Nf3 e6 3. e3 c5 4. c4 Nc6 5. Nc3 Nf6 6. dxc5 Bxc5 7. a3 a6 8. b4 Bd6 9. Bb2 O-O 10. Qd2 Qe7 11. Bd3 dxc4 12. Bxc4 b5 13. Bd3 Rd8 14. Qe2 Bb7 15. O-O Ne5 16. Nxe5 Bxe5 17. f4 Bc7 18. e4 Rac8 19. e5 Bb6+ 20. Kh1 Ng4 21. Be4 Qh4 22. g3 Rxc3 23. gxh4 Rd2 24. Qxd2 Bxe4+ 25. Qg2 Rh3 0-1''',
    ),
  ];

  static List<ModelGame> search({String? query, String? tag, String? eco}) {
    return curatedGames.where((game) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        final matchesQuery = game.whitePlayer.toLowerCase().contains(q) ||
            game.blackPlayer.toLowerCase().contains(q) ||
            game.event.toLowerCase().contains(q) ||
            game.openingName.toLowerCase().contains(q);
        if (!matchesQuery) return false;
      }
      if (tag != null && tag.isNotEmpty) {
        if (!game.tags.any((t) => t.toLowerCase() == tag.toLowerCase())) {
          return false;
        }
      }
      if (eco != null && eco.isNotEmpty) {
        if (!game.eco.toLowerCase().startsWith(eco.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  static ModelGame? getById(String id) {
    return curatedGames.where((g) => g.id == id).firstOrNull;
  }
}
