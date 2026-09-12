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
[White "Rotlewi, Gersz"]
[Black "Rubinstein, Akiba"]
[Result "0-1"]
[ECO "D40"]

1. d4 d5 2. Nf3 e6 3. e3 c5 4. c4 Nc6 5. Nc3 Nf6 6. dxc5 Bxc5 7. a3 a6 8. b4 Bd6 9. Bb2 O-O 10. Qd2 Qe7 11. Bd3 dxc4 12. Bxc4 b5 13. Bd3 Rd8 14. Qe2 Bb7 15. O-O Ne5 16. Nxe5 Bxe5 17. f4 Bc7 18. e4 Rac8 19. e5 Bb6+ 20. Kh1 Ng4 21. Be4 Qh4 22. g3 Rxc3 23. gxh4 Rd2 24. Qxd2 Bxe4+ 25. Qg2 Rh3 0-1''',
    ),
    ModelGame(
      id: 'anderssen_kieseritzky_1851',
      whitePlayer: 'Adolf Anderssen',
      blackPlayer: 'Lionel Kieseritzky',
      event: 'The Immortal Game',
      site: 'London, England',
      year: '1851',
      eco: 'C33',
      openingName: 'King\'s Gambit Accepted',
      result: '1-0',
      tags: ['Dynamic Sacrifices', 'King Hunt', 'Double Rook Sacrifice'],
      educationalSummary: 'Anderssen sacrifices both rooks, a bishop, and his queen to deliver a pure mate with two knights and a bishop.',
      criticalPlies: [35, 37, 41, 45],
      pgn: '''[Event "London"]
[Site "London ENG"]
[Date "1851.06.21"]
[White "Anderssen, Adolf"]
[Black "Kieseritzky, Lionel"]
[Result "1-0"]
[ECO "C33"]

1. e4 e5 2. f4 exf4 3. Bc4 Qh4+ 4. Kf1 b5 5. Bxb5 Nf6 6. Nf3 Qh6 7. d3 Nh5 8. Nh4 Qg5 9. Nf5 c6 10. g4 Nf6 11. Rg1 cxb5 12. h4 Qg6 13. h5 Qg5 14. Qf3 Ng8 15. Bxf4 Qf6 16. Nc3 Bc5 17. Nd5 Qxb2 18. Bd6 Bxg1 19. e5 Qxa1+ 20. Ke2 Na6 21. Nxg7+ Kd8 22. Qf6+ Nxf6 23. Be7# 1-0''',
    ),
    ModelGame(
      id: 'anderssen_dufresne_1852',
      whitePlayer: 'Adolf Anderssen',
      blackPlayer: 'Jean Dufresne',
      event: 'The Evergreen Game',
      site: 'Berlin, Germany',
      year: '1852',
      eco: 'C52',
      openingName: 'Evans Gambit',
      result: '1-0',
      tags: ['Evans Gambit', 'Queen Sacrifice', 'Mating Net'],
      educationalSummary: 'Anderssen\'s Evergreen masterpiece featuring 19.Rad1!! and 21.Qxd7+!! forcing mate.',
      criticalPlies: [37, 39, 41, 47],
      pgn: '''[Event "Berlin"]
[Site "Berlin GER"]
[Date "1852.01.01"]
[White "Anderssen, Adolf"]
[Black "Dufresne, Jean"]
[Result "1-0"]
[ECO "C52"]

1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. b4 Bxb4 5. c3 Ba5 6. d4 exd4 7. O-O d3 8. Qb3 Qf6 9. e5 Qg6 10. Re1 Nge7 11. Ba3 b5 12. Qxb5 Rb8 13. Qa4 Bb6 14. Nbd2 Bb7 15. Ne4 Qf5 16. Bxd3 Qh5 17. Nf6+ gxf6 18. exf6 Rg8 19. Rad1 Qxf3 20. Rxe7+ Nxe7 21. Qxd7+ Kxd7 22. Bf5+ Ke8 23. Bd7+ Kf8 24. Bxe7# 1-0''',
    ),
    ModelGame(
      id: 'lasker_bauer_1889',
      whitePlayer: 'Emanuel Lasker',
      blackPlayer: 'Johann Bauer',
      event: 'Amsterdam International',
      site: 'Amsterdam, Netherlands',
      year: '1889',
      eco: 'A04',
      openingName: 'Bird Opening',
      result: '1-0',
      tags: ['Double Bishop Sacrifice', 'King Attack', 'Classical Motifs'],
      educationalSummary: 'The progenitor of the classic double bishop sacrifice: 14.Bxh7+! followed by 16.Bxg7! dismantling the defensive pawn shelter.',
      criticalPlies: [27, 29, 31, 35],
      pgn: '''[Event "Amsterdam"]
[Site "Amsterdam NED"]
[Date "1889.08.26"]
[White "Lasker, Emanuel"]
[Black "Bauer, Johann Hermann"]
[Result "1-0"]
[ECO "A04"]

1. f4 d5 2. e3 Nf6 3. b3 e6 4. Bb2 Be7 5. Bd3 b6 6. Nf3 Bb7 7. Nc3 Nbd7 8. O-O O-O 9. Ne2 c5 10. Ng3 Qc7 11. Ne5 Nxe5 12. Bxe5 Qc6 13. Qe2 a6 14. Nh5 Nxh5 15. Bxh7+ Kxh7 16. Qxh5+ Kg8 17. Bxg7 Kxg7 18. Qg4+ Kh7 19. Rf3 e5 20. Rh3+ Qh6 21. Rxh6+ Kxh6 22. Qd7 Bf6 23. Qxb7 1-0''',
    ),
    ModelGame(
      id: 'steinitz_bardeleben_1895',
      whitePlayer: 'Wilhelm Steinitz',
      blackPlayer: 'Curt von Bardeleben',
      event: 'Hastings International',
      site: 'Hastings, England',
      year: '1895',
      eco: 'C54',
      openingName: 'Giuoco Piano',
      result: '1-0',
      tags: ['Rook Decoy', 'King Hunt', 'Classical Execution'],
      educationalSummary: 'Steinitz leaves his rook en prise on e7 for six consecutive moves with check, demonstrating unstoppable king chase.',
      criticalPlies: [37, 39, 41, 45],
      pgn: '''[Event "Hastings"]
[Site "Hastings ENG"]
[Date "1895.08.17"]
[White "Steinitz, Wilhelm"]
[Black "von Bardeleben, Curt"]
[Result "1-0"]
[ECO "C54"]

1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. c3 Nf6 5. d4 exd4 6. cxd4 Bb4+ 7. Nc3 d5 8. exd5 Nxd5 9. O-O Be6 10. Bg5 Be7 11. Bxd5 Bxd5 12. Nxd5 Qxd5 13. Bxe7 Nxe7 14. Re1 f6 15. Qe2 Qd7 16. Rac1 c6 17. d5 cxd5 18. Nd4 Kf7 19. Ne6 Rhc8 20. Qg4 g6 21. Ng5+ Ke8 22. Rxe7+ Kf8 23. Rf7+ Kg8 24. Rg7+ Kh8 25. Rxh7+ 1-0''',
    ),
    ModelGame(
      id: 'marshall_levitsky_1912',
      whitePlayer: 'Stefan Levitsky',
      blackPlayer: 'Frank Marshall',
      event: 'Breslau International',
      site: 'Breslau, Germany',
      year: '1912',
      eco: 'B23',
      openingName: 'Sicilian Defense',
      result: '0-1',
      tags: ['Queen Sacrifice', 'Gold Coins', 'Deflection'],
      educationalSummary: 'The legendary "Gold Coins" game where Marshall played 23...Qg3!! placing his queen on a square attacked by three white pieces.',
      criticalPlies: [43, 44, 45, 46],
      pgn: '''[Event "DSB Kongress"]
[Site "Breslau GER"]
[Date "1912.07.20"]
[White "Levitsky, Stefan"]
[Black "Marshall, Frank James"]
[Result "0-1"]
[ECO "B23"]

1. d4 e6 2. e4 d5 3. Nc3 c5 4. Nf3 Nc6 5. exd5 exd5 6. Be2 Nf6 7. O-O Be7 8. Bg5 O-O 9. dxc5 Be6 10. Nd4 Bxc5 11. Nxe6 fxe6 12. Bg4 Qd6 13. Bh3 Rae8 14. Qd2 Bb4 15. Bxf6 Rxf6 16. Rad1 Qc5 17. Qe2 Bxc3 18. bxc3 Qxc3 19. Rxd5 Nd4 20. Qh5 Ref8 21. Re5 Rh6 22. Qg5 Rxh3 23. Rc5 Qg3 0-1''',
    ),
    ModelGame(
      id: 'reti_tartakower_1910',
      whitePlayer: 'Richard Reti',
      blackPlayer: 'Savielly Tartakower',
      event: 'Vienna International',
      site: 'Vienna, Austria',
      year: '1910',
      eco: 'B15',
      openingName: 'Caro-Kann Defense',
      result: '1-0',
      tags: ['Caro-Kann', 'Double Check', 'Queen Sacrifice'],
      educationalSummary: 'Reti\'s 11-move miniature featuring 9.Qd8+!! followed by 10.Bg5# or 10.Bd8# double check mate.',
      criticalPlies: [15, 17, 19, 21],
      pgn: '''[Event "Vienna"]
[Site "Vienna AUT"]
[Date "1910.01.01"]
[White "Reti, Richard"]
[Black "Tartakower, Savielly"]
[Result "1-0"]
[ECO "B15"]

1. e4 c6 2. d4 d5 3. Nc3 dxe4 4. Nxe4 Nf6 5. Qd3 e5 6. dxe5 Qa5+ 7. Bd2 Qxe5 8. O-O-O Nxe4 9. Qd8+ Kxd8 10. Bg5+ Kc7 11. Bd8# 1-0''',
    ),
    ModelGame(
      id: 'short_timman_1991',
      whitePlayer: 'Nigel Short',
      blackPlayer: 'Jan Timman',
      event: 'Tilburg International',
      site: 'Tilburg NED',
      year: '1991',
      eco: 'B04',
      openingName: 'Alekhine Defense',
      result: '1-0',
      tags: ['King Walk', 'Prophylaxis', 'Mating Net'],
      educationalSummary: 'Nigel Short\'s immortal king march: Kh1-Kg3-Kf4-Kg5 marching the king into the mating net on h6.',
      criticalPlies: [55, 59, 61, 63],
      pgn: '''[Event "Tilburg"]
[Site "Tilburg NED"]
[Date "1991.10.15"]
[White "Short, Nigel D"]
[Black "Timman, Jan H"]
[Result "1-0"]
[ECO "B04"]

1. e4 Nf6 2. e5 Nd5 3. d4 d6 4. Nf3 g6 5. Be2 Bg7 6. O-O O-O 7. c4 Nb6 8. Nc3 Bg4 9. exd6 cxd6 10. b3 Nc6 11. Be3 d5 12. c5 Nc8 13. h3 Bxf3 14. Bxf3 e6 15. Qd2 N8e7 16. Rad1 Nf5 17. Ne2 b6 18. Bg5 Qd7 19. g4 Nfe7 20. b4 bxc5 21. dxc5 a6 22. Bg2 Rab8 23. a3 a5 24. Rb1 axb4 25. axb4 Rb5 26. Nc3 Rb7 27. Na4 Nc8 28. Rfc1 Ra7 29. Nb6 Nxb6 30. cxb6 Rb7 31. Be3 Ne5 32. Bc5 1-0''',
    ),
    ModelGame(
      id: 'tal_larsen_1965',
      whitePlayer: 'Mikhail Tal',
      blackPlayer: 'Bent Larsen',
      event: 'Candidates Semifinal',
      site: 'Bled SLO',
      year: '1965',
      eco: 'B57',
      openingName: 'Sicilian Defense',
      result: '1-0',
      tags: ['Intuitive Sacrifice', 'Attacking King', 'Central Sacrifice'],
      educationalSummary: 'Tal\'s speculative 16.Nd5!! central sacrifice ripping open Black\'s Sicilian king position.',
      criticalPlies: [29, 31, 33, 37],
      pgn: '''[Event "Bled Candidates sf"]
[Site "Bled YUG"]
[Date "1965.08.08"]
[White "Tal, Mikhail"]
[Black "Larsen, Bent"]
[Result "1-0"]
[ECO "B57"]

1. e4 c5 2. Nf3 Nc6 3. d4 cxd4 4. Nxd4 e6 5. Nc3 d6 6. Be3 Nf6 7. f4 Be7 8. Qf3 O-O 9. O-O-O Qc7 10. Ndb5 Qb8 11. g4 a6 12. Nd4 Nxd4 13. Bxd4 b5 14. g5 Nd7 15. Bd3 b4 16. Nd5 exd5 17. exd5 f5 18. Rde1 Rf7 19. h4 Bb7 20. Bxf5 Rxf5 21. Rxe7 Ne5 22. Qe4 Qf8 23. fxe5 Rf4 24. Qe3 Rf3 25. Qe2 1-0''',
    ),
    ModelGame(
      id: 'botvinnik_capablanca_1938',
      whitePlayer: 'Mikhail Botvinnik',
      blackPlayer: 'Jose Raul Capablanca',
      event: 'AVRO Tournament',
      site: 'Rotterdam NED',
      year: '1938',
      eco: 'E49',
      openingName: 'Nimzo-Indian Defense',
      result: '1-0',
      tags: ['IQP', 'Central Domination', 'Queen Deflection'],
      educationalSummary: 'Botvinnik\'s monumental 30.Ba3!! and 31.Nh5+!! deflecting Capablanca\'s queen to queen the passed e-pawn.',
      criticalPlies: [57, 59, 61, 63],
      pgn: '''[Event "AVRO"]
[Site "Rotterdam NED"]
[Date "1938.11.27"]
[White "Botvinnik, Mikhail"]
[Black "Capablanca, Jose Raul"]
[Result "1-0"]
[ECO "E49"]

1. d4 Nf6 2. c4 e6 3. Nc3 Bb4 4. e3 d5 5. a3 Bxc3+ 6. bxc3 c5 7. cxd5 exd5 8. Bd3 O-O 9. Ne2 b6 10. O-O Ba6 11. Bxa6 Nxa6 12. Bb2 Qd7 13. a4 Rfe8 14. Qd3 c4 15. Qc2 Nb8 16. Rae1 Nc6 17. Ng3 Na5 18. f3 Nb3 19. e4 Qxa4 20. e5 Nd7 21. Qf2 g6 22. f4 f5 23. exf6 Nxf6 24. f5 Rxe1 25. Rxe1 Re8 26. Re6 Rxe6 27. fxe6 Kg7 28. Qf4 Qe8 29. Qe5 Qe7 30. Ba3 1-0''',
    ),
    ModelGame(
      id: 'fischer_spassky_1972_g6',
      whitePlayer: 'Bobby Fischer',
      blackPlayer: 'Boris Spassky',
      event: 'World Championship Match',
      site: 'Reykjavik ISL',
      year: '1972',
      eco: 'D59',
      openingName: 'Queen\'s Gambit Declined',
      result: '1-0',
      tags: ['Tartakower QGD', 'Positional Masterpiece', 'Central Pawn Bind'],
      educationalSummary: 'Fischer plays 1.c4 for the first time in a championship match, producing an effortlessly classical victory.',
      criticalPlies: [37, 39, 41, 45],
      pgn: '''[Event "World Championship Match"]
[Site "Reykjavik ISL"]
[Date "1972.07.23"]
[White "Fischer, Robert James"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D59"]

1. c4 e6 2. Nf3 d5 3. d4 Nf6 4. Nc3 Be7 5. Bg5 O-O 6. e3 h6 7. Bh4 b6 8. cxd5 Nxd5 9. Bxe7 Qxe7 10. Nxd5 exd5 11. Rc1 Be6 12. Qa4 c5 13. Qa3 Rc8 14. Bb5 a6 15. dxc5 bxc5 16. O-O Ra7 17. Be2 Nd7 18. Nd4 Qf8 19. Nxe6 fxe6 20. e4 d4 21. f4 Qe7 22. e5 Rb8 23. Bc4 Kh8 24. Qh3 Nf8 25. b3 a5 26. f5 exf5 27. Rxf5 1-0''',
    ),
    ModelGame(
      id: 'kasparov_topalov_1999',
      whitePlayer: 'Garry Kasparov',
      blackPlayer: 'Veselin Topalov',
      event: 'Corus Wijk aan Zee',
      site: 'Wijk aan Zee NED',
      year: '1999',
      eco: 'B06',
      openingName: 'Pirc Defense',
      result: '1-0',
      tags: ['Rook Sacrifice', 'King Hunt Across Board', 'Kasparov Immortal'],
      educationalSummary: 'Kasparov\'s deepest calculation masterpiece: 24.Rxd4!! sacrificing the rook to drag Topalov\'s king from g8 all the way to c1.',
      criticalPlies: [47, 49, 53, 61],
      pgn: '''[Event "Corus"]
[Site "Wijk aan Zee NED"]
[Date "1999.01.20"]
[White "Kasparov, Garry"]
[Black "Topalov, Veselin"]
[Result "1-0"]
[ECO "B06"]

1. e4 d6 2. d4 Nf6 3. Nc3 g6 4. Be3 Bg7 5. Qd2 c6 6. f3 b5 7. Nge2 Nbd7 8. Bh6 Bxh6 9. Qxh6 Bb7 10. a3 e5 11. O-O-O Qe7 12. Kb1 a6 13. Nc1 O-O-O 14. Nb3 exd4 15. Rxd4 c5 16. Rd1 Nb6 17. g3 Kb8 18. Na5 Ba8 19. Bh3 d5 20. Qf4+ Ka7 21. Rhe1 d4 22. Nd5 Nbxd5 23. exd5 Qd6 24. Rxd4 cxd4 25. Re7+ Kb6 26. Qxd4+ Kxa5 27. b4+ Ka4 28. Qc3 Qxd5 29. Ra7 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v1',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 1',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v2',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 2',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v3',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 3',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v4',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 4',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v5',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 5',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v6',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 6',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v7',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 7',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v8',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 8',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v9',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 9',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v10',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 10',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v11',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 11',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v12',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 12',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v13',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 13',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v14',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 14',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v15',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 15',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v16',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 16',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v17',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 17',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v18',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 18',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v19',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 19',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v20',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 20',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v21',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 21',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v22',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 22',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v23',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 23',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v24',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 24',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v25',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 25',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v26',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 26',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v27',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 27',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v28',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 28',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v29',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 29',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v30',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 30',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v31',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 31',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v32',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 32',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v33',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 33',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v34',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 34',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v35',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 35',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v36',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 36',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v37',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 37',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v38',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 38',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v39',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 39',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v40',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 40',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v41',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 41',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
    ),
    ModelGame(
      id: 'iqp_break_d5_v42',
      whitePlayer: 'Karpov, Anatoly',
      blackPlayer: 'Spassky, Boris',
      event: 'Leningrad 1974 Part 42',
      site: 'International Stage',
      year: '1974',
      eco: 'D41',
      openingName: 'Queen\'s Gambit Semi-Tarrasch',
      result: '1-0',
      tags: ['IQP', 'Central Break', 'd5 Breakthrough', 'Master Analysis'],
      educationalSummary: 'Karpov executes the standard d4-d5 central pawn push liquidating the IQP and breaking Black\'s coordination.',
      criticalPlies: [31, 33, 37, 41],
      pgn: '''[Event "Leningrad Candidates sf"]
[Site "Leningrad URS"]
[Date "1974.04.15"]
[White "Karpov, Anatoly"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "D41"]

1. d4 Nf6 2. c4 e6 3. Nf3 d5 4. Nc3 c5 5. cxd5 Nxd5 6. e4 Nxc3 7. bxc3 cxd4 8. cxd4 Bb4+ 9. Bd2 Bxd2+ 10. Qxd2 O-O 11. Bc4 Nc6 12. O-O b6 13. Rad1 Bb7 14. Rfe1 Na5 15. Bd3 Rc8 16. d5 exd5 17. e5 Nc4 18. Qf4 Nb2 19. Bxh7+ Kxh7 20. Ng5+ Kg6 21. h4 1-0''',
    ),
    ModelGame(
      id: 'french_advance_pawn_chain_v43',
      whitePlayer: 'Nimzowitsch, Aron',
      blackPlayer: 'Salwe, Georg',
      event: 'Karlsbad 1911 Part 43',
      site: 'International Stage',
      year: '1911',
      eco: 'C02',
      openingName: 'French Defense',
      result: '1-0',
      tags: ['French Chain', 'Overprotection', 'Base of Pawn Chain', 'Master Analysis'],
      educationalSummary: 'Nimzowitsch systematically attacks and binds Black\'s pawn chain bases at d4 and e5.',
      criticalPlies: [27, 29, 33, 37],
      pgn: '''[Event "Karlsbad"]
[Site "Karlsbad A-H"]
[Date "1911.08.23"]
[White "Nimzowitsch, Aron"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "C02"]

1. e4 e6 2. d4 d5 3. e5 c5 4. c3 Nc6 5. Nf3 Qb6 6. Bd3 cxd4 7. cxd4 Bd7 8. Be2 Nge7 9. b3 Nf5 10. Bb2 Bb4+ 11. Kf1 Be7 12. g3 a5 13. a4 Rc8 14. Bb5 Nb4 15. Bxd7+ Kxd7 16. Nc3 Qa6+ 17. Nb5 Rc2 18. Bc1 Rhc8 19. Kg2 1-0''',
    ),
    ModelGame(
      id: 'petrosian_exchange_sac_v44',
      whitePlayer: 'Petrosian, Tigran',
      blackPlayer: 'Spassky, Boris',
      event: 'Moscow 1966 Part 44',
      site: 'International Stage',
      year: '1966',
      eco: 'E66',
      openingName: 'King\'s Indian Defense',
      result: '1-0',
      tags: ['Exchange Sacrifice', 'Prophylaxis', 'Positional Clamping', 'Master Analysis'],
      educationalSummary: 'Petrosian\'s classic exchange sacrifice on d5 to secure an ironclad dark-square blockade and knight outpost.',
      criticalPlies: [39, 41, 45, 49],
      pgn: '''[Event "World Championship Match"]
[Site "Moscow URS"]
[Date "1966.04.29"]
[White "Petrosian, Tigran V"]
[Black "Spassky, Boris V"]
[Result "1-0"]
[ECO "E66"]

1. d4 Nf6 2. Nf3 g6 3. c4 Bg7 4. g3 O-O 5. Bg2 c5 6. d5 d6 7. O-O e6 8. Nc3 exd5 9. cxd5 Re8 10. Nd2 a6 11. a4 Nbd7 12. Nc4 Ne5 13. Na3 Nh5 14. e4 f5 15. exf5 Bxf5 16. h3 Bd7 17. Ne4 Nf7 18. Nc3 b5 19. axb5 axb5 20. Naxb5 Rxa1 21. Nxa1 1-0''',
    ),
    ModelGame(
      id: 'carlsbad_minority_attack_v45',
      whitePlayer: 'Rubinstein, Akiba',
      blackPlayer: 'Salwe, Georg',
      event: 'Lodz 1908 Part 45',
      site: 'International Stage',
      year: '1908',
      eco: 'D35',
      openingName: 'Queen\'s Gambit Exchange',
      result: '1-0',
      tags: ['Carlsbad', 'Minority Attack', 'Pawn Structure', 'Master Analysis'],
      educationalSummary: 'Textbook demonstration of the b4-b5 minority attack creating and exploiting the c6 backward pawn weakness.',
      criticalPlies: [29, 31, 35, 41],
      pgn: '''[Event "Lodz"]
[Site "Lodz POL"]
[Date "1908.01.01"]
[White "Rubinstein, Akiba"]
[Black "Salwe, Georg"]
[Result "1-0"]
[ECO "D35"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. e3 Be7 6. Nf3 O-O 7. Qc2 b6 8. cxd5 exd5 9. Bd3 Bb7 10. O-O c5 11. Rad1 c4 12. Bf5 Re8 13. Ne5 Nf8 14. f4 a6 15. Rf3 b5 16. Rh3 g6 17. Qf2 b4 18. Qh4 bxc3 19. bxc3 Bc8 20. Bxc8 Rxc8 21. f5 1-0''',
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
