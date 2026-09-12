import 'package:chess_core/chess_core.dart';
import 'package:test/test.dart';

void main() {
  group('Deep Chess Core Coverage & Model Verification', () {
    test('Piece and PieceColor complete property coverage', () {
      expect(PieceColor.white.opponent, PieceColor.black);
      expect(PieceColor.black.opponent, PieceColor.white);
      expect(PieceColor.white.opposite, PieceColor.black);
      expect(PieceColor.black.opposite, PieceColor.white);
      expect(PieceColor.white.direction, 1);
      expect(PieceColor.black.direction, -1);
      expect(PieceColor.white.pawnStartRank, 1);
      expect(PieceColor.black.pawnStartRank, 6);
      expect(PieceColor.white.promotionRank, 7);
      expect(PieceColor.black.promotionRank, 0);

      const pieces = [
        Piece.whitePawn,
        Piece.whiteKnight,
        Piece.whiteBishop,
        Piece.whiteRook,
        Piece.whiteQueen,
        Piece.whiteKing,
        Piece.blackPawn,
        Piece.blackKnight,
        Piece.blackBishop,
        Piece.blackRook,
        Piece.blackQueen,
        Piece.blackKing,
      ];

      for (final p in pieces) {
        expect(p.type.baseValue, greaterThan(0));
        expect(p.fenChar, isNotEmpty);
        expect(p.unicodeSymbol, isNotEmpty);
        expect(p.toString(), p.fenChar);
        expect(Piece.fromFenChar(p.fenChar), p);
      }

      expect(Piece.fromFenChar(''), isNull);
      expect(Piece.fromFenChar('X'), isNull);
      expect(PieceType.fromFen('z'), isNull);
    });

    test('Square complete coordinate and naming coverage', () {
      for (int r = 0; r < 8; r++) {
        for (int f = 0; f < 8; f++) {
          final sq = Square.fromCoords(f, r);
          expect(sq.file, f);
          expect(sq.rank, r);
          expect(sq.mask, 1 << sq.index);
          expect(Square.fromName(sq.name), sq);
        }
      }

      expect(Square.fromName(''), isNull);
      expect(Square.fromName('a9'), isNull);
      expect(Square.fromName('i1'), isNull);
      expect(Square.fromName('e0'), isNull);

      expect(Square.a1.isLightSquare, isFalse);
      expect(Square.b1.isLightSquare, isTrue);
      expect(Square.a1.fileName, 'a');
      expect(Square.a1.rankName, '1');
      expect(Square.h8.name, 'h8');
    });

    test('Move flags, UCI serialization, equality and parsing', () {
      const m1 = Move(
        from: Square.e2,
        to: Square.e4,
        flag: MoveFlag.pawnDoublePush,
      );
      expect(m1.uci, 'e2e4');
      expect(m1.toString(), 'e2e4');
      expect(m1.isPromotion, isFalse);
      expect(m1.isCastling, isFalse);

      final promo = Move(
        from: Square.fromName('e7')!,
        to: Square.fromName('e8')!,
        promotion: PieceType.queen,
        flag: MoveFlag.promotion,
        isCapture: true,
      );
      expect(promo.uci, 'e7e8q');
      expect(promo.isPromotion, isTrue);

      const castle = Move(
        from: Square.e1,
        to: Square.g1,
        flag: MoveFlag.castleKingside,
      );
      expect(castle.isCastling, isTrue);

      final parsed = Move.fromUci('e7e8q');
      expect(parsed, promo);
      expect(parsed.hashCode, promo.hashCode);

      expect(Move.fromUci(''), isNull);
      expect(Move.fromUci('e2'), isNull);
      expect(Move.fromUci('e2e9'), isNull);
      expect(Move.fromUci('z2e4'), isNull);
    });

    test('GameStatus and GameResult coverage', () {
      expect(GameStatus.inProgress.isGameOver, isFalse);
      expect(GameStatus.checkmate.isGameOver, isTrue);
      expect(GameStatus.checkmate.isDraw, isFalse);
      expect(GameStatus.stalemate.isDraw, isTrue);
      expect(GameStatus.threefoldRepetition.isDraw, isTrue);
      expect(GameStatus.fiftyMoveRule.isDraw, isTrue);
      expect(GameStatus.seventyFiveMoveRule.isDraw, isTrue);
      expect(GameStatus.insufficientMaterial.isDraw, isTrue);
      expect(GameStatus.drawAgreed.isDraw, isTrue);
      expect(GameStatus.resignation.isDraw, isFalse);
      expect(GameStatus.timeout.isDraw, isFalse);

      const rWhite = GameResult(status: GameStatus.checkmate, winner: PieceColor.white, description: 'White wins');
      expect(rWhite.score, '1-0');
      expect(rWhite.toString(), 'White wins (1-0)');

      const rBlack = GameResult(status: GameStatus.checkmate, winner: PieceColor.black, description: 'Black wins');
      expect(rBlack.score, '0-1');

      const rDraw = GameResult(status: GameStatus.stalemate, description: 'Stalemate');
      expect(rDraw.score, '1/2-1/2');

      expect(GameResult.ongoing.score, '*');
    });

    test('ChessClock presets, lifecycle, displays and flags', () {
      final clocks = [
        ChessClock.classical90Plus30(),
        ChessClock.classical60Plus30(),
        ChessClock.classical45Plus15(),
        ChessClock.rapid15Plus10(),
        ChessClock.blitz3Plus2(),
        ChessClock.bullet1Plus0(),
      ];

      for (final clock in clocks) {
        expect(clock.whiteRemaining, greaterThan(Duration.zero));
        expect(clock.blackRemaining, greaterThan(Duration.zero));
        expect(clock.isRunning, isFalse);
        expect(clock.hasFlagFallen(PieceColor.white), isFalse);
        expect(clock.hasFlagFallen(PieceColor.black), isFalse);
        expect(clock.whiteDisplayString, isNotEmpty);
        expect(clock.blackDisplayString, isNotEmpty);

        clock.start();
        expect(clock.isRunning, isTrue);
        clock.tick();
        clock.pause();
        expect(clock.isRunning, isFalse);

        clock.start();
        clock.onMovePlayed(recordedDuration: const Duration(seconds: 2));
        expect(clock.activeColor, PieceColor.black);
        expect(clock.whiteMoveTimes.length, 1);

        clock.onMovePlayed(recordedDuration: const Duration(seconds: 1));
        expect(clock.activeColor, PieceColor.white);
        expect(clock.blackMoveTimes.length, 1);

        clock.pause();
      }

      // Test formatting
      expect(ChessClock.formatDuration(const Duration(hours: 1, minutes: 24, seconds: 5)), '1:24:05');
      expect(ChessClock.formatDuration(const Duration(minutes: 5, seconds: 30)), '05:30');
      expect(ChessClock.formatDuration(const Duration(seconds: 8, milliseconds: 400)), '00:08.4');
      expect(ChessClock.formatDuration(Duration.zero), '00:00');

      final zeroClock = ChessClock(initialTime: Duration.zero);
      expect(zeroClock.hasFlagFallen(PieceColor.white), isTrue);
    });

    test('Board cloning, manipulation, Zobrist, and FEN generation', () {
      final board = Board.initial();
      expect(board.kingSquare(PieceColor.white), Square.e1);
      expect(board.kingSquare(PieceColor.black), Square.fromName('e8')!);
      expect(board.pieceAt(Square.e1), Piece.whiteKing);

      final clone = board.clone();
      expect(clone.toFen(), board.toFen());
      expect(clone.currentZobrist, board.currentZobrist);
      expect(board.currentPositionOccurrences, 1);

      board.setPiece(Square.fromName('e4')!, Piece.whitePawn);
      expect(board.pieceAt(Square.fromName('e4')!), Piece.whitePawn);

      board.setPiece(Square.fromName('e4')!, null);
      expect(board.pieceAt(Square.fromName('e4')!), isNull);

      final emptyBoard = Board.empty();
      expect(emptyBoard.pieceAt(Square.e1), isNull);
      expect(emptyBoard.toFen(), '8/8/8/8/8/8/8/8 w - - 0 1');
    });

    test('50-move rule and 75-move rule detection', () {
      final board = Board.fromFen('8/8/8/8/8/4k3/8/4K3 w - - 100 50');
      expect(MoveGenerator.getGameStatus(board), GameStatus.fiftyMoveRule);

      final board75 = Board.fromFen('8/8/8/8/8/4k3/8/4K3 w - - 150 75');
      expect(MoveGenerator.getGameStatus(board75), GameStatus.seventyFiveMoveRule);
    });

    test('FenParser comprehensive validation branches', () {
      expect(FenParser.initialFen, contains('rnbqkbnr'));
      expect(FenParser.isValidFen(FenParser.initialFen), isTrue);
      expect(FenParser.parse(FenParser.initialFen).toFen(), FenParser.initialFen);

      // Too few or too many parts
      expect(FenParser.isValidFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR'), isFalse);
      expect(FenParser.isValidFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1 extra field'), isFalse);

      // Rank count != 8
      expect(FenParser.isValidFen('8/8/8/8/8/8/8 w - - 0 1'), isFalse);

      // Invalid rank length / digit out of bounds
      expect(FenParser.isValidFen('9/8/8/8/8/8/8/8 w - - 0 1'), isFalse);
      expect(FenParser.isValidFen('0/8/8/8/8/8/8/8 w - - 0 1'), isFalse);
      expect(FenParser.isValidFen('8/8/8/8/8/8/8/7 w - - 0 1'), isFalse);

      // Invalid piece char
      expect(FenParser.isValidFen('rnbqkxnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'), isFalse);

      // Pawns on 1st or 8th rank
      expect(FenParser.isValidFen('p7/8/8/8/8/8/8/8 w - - 0 1'), isFalse);
      expect(FenParser.isValidFen('8/8/8/8/8/8/8/P7 w - - 0 1'), isFalse);

      // King count != 1
      expect(FenParser.isValidFen('8/8/8/8/8/8/8/8 w - - 0 1'), isFalse);
      expect(FenParser.isValidFen('k7/k7/8/8/8/8/8/K7 w - - 0 1'), isFalse);

      // Invalid side to move
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 x - - 0 1'), isFalse);

      // Invalid castling rights
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 w XYZ - 0 1'), isFalse);
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 w KK - 0 1'), isFalse);

      // Invalid en passant square
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 w - z9 0 1'), isFalse);
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 w - e3 0 1'), isFalse); // White to move requires rank 6
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 b - e6 0 1'), isFalse); // Black to move requires rank 3

      // Invalid halfmove / fullmove
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 w - - -1 1'), isFalse);
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 w - - abc 1'), isFalse);
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 w - - 0 0'), isFalse);
      expect(FenParser.isValidFen('k7/8/8/8/8/8/8/K7 w - - 0 xyz'), isFalse);

      // Inactive king in check (illegal position)
      // White to move, but Black king is under attack by White rook
      expect(FenParser.isValidFen('4k3/4R3/8/8/8/8/8/4K3 w - - 0 1'), isFalse);
    });

    test('PgnParser and PgnGame complete property and metadata coverage', () {
      const pgn = '''[Event "World Championship 2024"]
[Site "Singapore"]
[Date "2024.11.25"]
[Round "1"]
[White "Gukesh D"]
[Black "Ding Liren"]
[Result "1/2-1/2"]
[ECO "C65"]
[Opening "Ruy Lopez: Berlin Defense"]
[CustomTag "CustomValue"]

1. e4 {[%eval 0.20] [%clk 2:00:00]} e5 2. Nf3 Nc6 3. Bb5 Nf6 {[%eval #3]} 1/2-1/2''';

      final games = PgnParser.parseMultiGame(pgn);
      expect(games.length, 1);
      final game = games.first;

      expect(game.event, 'World Championship 2024');
      expect(game.site, 'Singapore');
      expect(game.date, '2024.11.25');
      expect(game.year, '2024');
      expect(game.round, '1');
      expect(game.white, 'Gukesh D');
      expect(game.black, 'Ding Liren');
      expect(game.result, '1/2-1/2');
      expect(game.eco, 'C65');
      expect(game.opening, 'Ruy Lopez: Berlin Defense');
      expect(game.setupFen, isNull);

      final exported = game.toPgnString();
      expect(exported, contains('[Event "World Championship 2024"]'));
      expect(exported, contains('[CustomTag "CustomValue"]'));
      expect(exported, contains('1. e4'));
      expect(exported, contains('1/2-1/2'));

      // Move node properties
      final m1 = game.moves.first;
      expect(m1.evaluation, 0.20);
      expect(m1.clock, '2:00:00');
      expect(m1.comment, contains('%eval'));

      final mMate = game.moves.last;
      expect(mMate.evaluation, 100.0); // Mate in 3 parsed as 100.0

      // CopyWith coverage on PgnMoveNode
      final copy = m1.copyWith(
        ply: 10,
        moveNumber: 5,
        isWhite: false,
        san: 'd4',
        nags: [1, 2],
        variations: [],
      );
      expect(copy.ply, 10);
      expect(copy.san, 'd4');
      expect(copy.isWhite, isFalse);

      // Black moves first in PGN (e.g. FEN setup)
      const blackFirstPgn = '''[Event "Black to move test"]
[FEN "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1"]

1... e5 2. Nf3 Nc6 *''';
      final blackGame = PgnParser.parse(blackFirstPgn)!;
      expect(blackGame.setupFen, isNotNull);
      expect(blackGame.moves.first.isWhite, isFalse);
      final blackExported = blackGame.toPgnString();
      expect(blackExported, contains('1... e5'));
    });

    test('Full Coverage Booster for chess_core edge branches', () {
      // 1. Square.named, toString, hashCode
      final sq = Square.named('e4');
      expect(sq.name, 'e4');
      expect(sq.toString(), 'e4');
      expect(sq.hashCode, isNotNull);

      // 2. FenParser.export
      final bInit = Board.initial();
      expect(FenParser.export(bInit), bInit.toFen());

      // 3. Piece hashCode
      expect(Piece.whitePawn.hashCode, isNotNull);
      expect(Piece.blackKing.hashCode, isNotNull);

      // 4. PgnGame with NAGs in toPgnString
      const nagGame = PgnGame(
        headers: {'Event': 'NAG test', 'Result': '*'},
        moves: [
          PgnMoveNode(ply: 1, moveNumber: 1, isWhite: true, san: 'e4', nags: [1, 2], comment: 'good move'),
        ],
        result: '*',
      );
      expect(nagGame.toPgnString(), contains('\$1'));

      // 5. PgnParser.parseMultiGame with multiple games
      const multiPgn = '''[Event "G1"]
[Result "1-0"]
1. e4 e5 1-0

[Event "G2"]
[Result "0-1"]
1. d4 d5 0-1''';
      final games = PgnParser.parseMultiGame(multiPgn);
      expect(games.length, 2);

      // 6. Tokenize comment adjacent to move without space
      final commentGame = PgnParser.parse('1. e4{comment} e5 1-0');
      expect(commentGame, isNotNull);

      // 7. Board.fromFen error paths
      expect(() => Board.fromFen('8/8/8 w'), throwsArgumentError);
      expect(() => Board.fromFen('8/8/8 w - - 0 1'), throwsArgumentError);

      // 8. Board.setPiece King branches (white and black, setting to null and setting to king)
      final customBoard = Board.initial();
      customBoard.setPiece(Square.named('e1'), null);
      expect(customBoard.kingSquare(PieceColor.white), isNull);
      customBoard.setPiece(Square.named('e1'), Piece.whiteKing);
      expect(customBoard.kingSquare(PieceColor.white), Square.named('e1'));

      customBoard.setPiece(Square.named('e8'), null);
      expect(customBoard.kingSquare(PieceColor.black), isNull);
      customBoard.setPiece(Square.named('e8'), Piece.blackKing);
      expect(customBoard.kingSquare(PieceColor.black), Square.named('e8'));

      // 9. Board.makeMove on empty square
      expect(() => customBoard.makeMove(Move(from: Square.named('a4'), to: Square.named('a5'))), throwsStateError);

      // 10. Board.history
      expect(customBoard.history, isEmpty);

      // 11. MoveGenerator.getCheckingSquares with pawn and rook checks
      final pawnCheckBoard = Board.fromFen('8/8/8/8/8/4p3/5K2/8 w - - 0 1');
      final pawnCheckers = MoveGenerator.getCheckingSquares(pawnCheckBoard, PieceColor.white);
      expect(pawnCheckers.isNotEmpty, isTrue);

      final rookCheckBoard = Board.fromFen('8/8/8/8/8/8/4rK2/8 w - - 0 1');
      final rookCheckers = MoveGenerator.getCheckingSquares(rookCheckBoard, PieceColor.white);
      expect(rookCheckers.isNotEmpty, isTrue);

      // 12. MoveGenerator.isInsufficientMaterial with heavy pieces and pawns
      final heavyBoard = Board.fromFen('r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 1');
      expect(MoveGenerator.isInsufficientMaterial(heavyBoard), isFalse);

      // 13. MoveGenerator.moveToSan on empty square
      expect(MoveGenerator.moveToSan(bInit, Move(from: Square.named('a4'), to: Square.named('a5'))), 'a4a5');

      // 14. MoveGenerator.moveToSan pawn capture and check
      final capCheckBoard = Board.fromFen('r1bqkbnr/ppp1pppp/2n5/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq d6 0 3');
      final pawnCapMove = MoveGenerator.sanToMove(capCheckBoard, 'exd5');
      expect(pawnCapMove, isNotNull);
      expect(MoveGenerator.moveToSan(capCheckBoard, pawnCapMove!), 'exd5');

      // 15. MoveGenerator.moveToSan disambiguations
      // Two rooks on same rank, different files (e.g. Rad1)
      final twoRooksBoard = Board.fromFen('R6R/8/8/8/8/8/8/4K2k w - - 0 1');
      final rad1Move = MoveGenerator.sanToMove(twoRooksBoard, 'Rad8');
      expect(rad1Move, isNotNull);
      expect(MoveGenerator.moveToSan(twoRooksBoard, rad1Move!), 'Rad8+');

      // Two rooks on same file, different ranks (e.g. R1a3)
      final fileRooksBoard = Board.fromFen('7k/8/8/R7/8/8/8/R3K3 w - - 0 1');
      final r1a3Move = MoveGenerator.sanToMove(fileRooksBoard, 'R1a3');
      expect(r1a3Move, isNotNull);
      expect(MoveGenerator.moveToSan(fileRooksBoard, r1a3Move!), 'R1a3');

      // Disambiguation with rank: 'R1a3'
      final r1a3Parsed = MoveGenerator.sanToMove(fileRooksBoard, 'R1a3');
      expect(r1a3Parsed, isNotNull);

      // Disambiguation with full square (three queens):
      final threeQueensBoard = Board.fromFen('7k/8/8/Q7/8/8/8/Q3Q2K w - - 0 1');
      final qFullMove = MoveGenerator.sanToMove(threeQueensBoard, 'Qa1a3');
      expect(qFullMove, isNotNull);

      // 16. MoveGenerator.sanToMove 0-0 and 0-0-0
      final castleBoard = Board.fromFen('r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1');
      expect(MoveGenerator.sanToMove(castleBoard, '0-0'), isNotNull);
      expect(MoveGenerator.sanToMove(castleBoard, '0-0-0'), isNotNull);

      // 17. MoveGenerator.sanToMove promotion
      final promoBoard = Board.fromFen('8/4P1k1/8/8/8/8/8/4K3 w - - 0 1');
      expect(MoveGenerator.sanToMove(promoBoard, 'e8=Q'), isNotNull);
      expect(MoveGenerator.sanToMove(promoBoard, 'e8=R'), isNotNull);
      expect(MoveGenerator.sanToMove(promoBoard, 'e8=X'), isNull);
    });
  });
}
