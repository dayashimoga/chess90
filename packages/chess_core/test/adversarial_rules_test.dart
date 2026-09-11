import 'dart:math';
import 'package:chess_core/chess_core.dart';
import 'package:test/test.dart';

void main() {
  group('Adversarial Chess Rules & Edge-Case Correctness', () {
    test('Absolute Pins: Pinned piece cannot leave pin ray', () {
      // White King on e1, White Bishop on e2, Black Rook on e8
      final board = Board.fromFen('4r3/8/8/8/8/8/4B3/4K3 w - - 0 1');
      final legalMoves = MoveGenerator.generateLegalMoves(board);

      // Bishop on e2 is pinned to the King on e1. It cannot move off the e-file.
      final bishopMoves = legalMoves.where((m) => m.from == Square.e2).toList();
      for (final move in bishopMoves) {
        // Any bishop move off the e-file would expose king to rook check, so must be 0 moves
        expect(move.to.file, equals(Square.e2.file));
      }
      expect(bishopMoves.isEmpty, isTrue);
    });

    test('Moving along pin ray is legal for sliding pinned piece', () {
      // White King on e1, White Rook on e3, Black Rook on e8
      final board = Board.fromFen('4r3/8/8/8/8/4R3/8/4K3 w - - 0 1');
      final legalMoves = MoveGenerator.generateLegalMoves(board);
      final rookMoves = legalMoves.where((m) => m.from == Square.e3).toList();

      // Rook can move along e-file (e2, e4, e5, e6, e7, e8)
      expect(rookMoves.isNotEmpty, isTrue);
      for (final move in rookMoves) {
        expect(move.to.file, equals(4)); // File 'e' is index 4
      }
    });

    test('Double Check: ONLY King moves are legal', () {
      // White King on e1 in check by Black Bishop on a5 and Black Knight on c2
      final board = Board.fromFen('rnbqk2r/pppp1ppp/8/b7/8/8/2n5/4K3 w kq - 0 1');
      expect(MoveGenerator.isDoubleCheck(board), isTrue);
      expect(MoveGenerator.isInCheck(board), isTrue);

      final legalMoves = MoveGenerator.generateLegalMoves(board);
      // All legal moves must be King moves from e1
      for (final m in legalMoves) {
        expect(m.from, equals(Square.e1));
      }
      expect(legalMoves.isNotEmpty, isTrue);
    });

    test('En Passant Discovered Check', () {
      // White King on e1, White Pawn on e5, Black Pawn on f5, Black Rook on f8
      // Black plays f7-f5. White takes e5xf6 e.p.
      final board = Board.fromFen('5r2/8/8/4Pp2/8/8/8/4K3 w - f6 0 1');
      final epMove = Move(
        from: Square.e5,
        to: Square.f6,
        isCapture: true,
        flag: MoveFlag.enPassant,
      );
      final legalMoves = MoveGenerator.generateLegalMoves(board);
      expect(legalMoves.any((m) => m.from == epMove.from && m.to == epMove.to), isTrue);

      board.makeMove(epMove);
      // Black Pawn on f5 should be removed
      expect(board.pieceAt(Square.f5), isNull);
      expect(board.pieceAt(Square.f6)?.color, equals(PieceColor.white));
      board.unmakeMove();
      // Unmake should restore pawn on f5
      expect(board.pieceAt(Square.f5)?.color, equals(PieceColor.black));
    });

    test('Underpromotion to Knight, Bishop, and Rook', () {
      // White pawn on a7 about to promote
      final board = Board.fromFen('8/P7/8/8/8/8/8/4K2k w - - 0 1');
      final legalMoves = MoveGenerator.generateLegalMoves(board);

      final promoMoves = legalMoves.where((m) => m.from == Square.a7 && m.to == Square.a8).toList();
      expect(promoMoves.length, equals(4)); // Q, R, B, N

      final promoPieces = promoMoves.map((m) => m.promotion).toSet();
      expect(promoPieces.contains(PieceType.queen), isTrue);
      expect(promoPieces.contains(PieceType.rook), isTrue);
      expect(promoPieces.contains(PieceType.bishop), isTrue);
      expect(promoPieces.contains(PieceType.knight), isTrue);
    });

    test('Checkmate vs Stalemate Detection', () {
      // 1. Scholar's Mate final position: Checkmate
      final mateBoard = Board.fromFen('r1bqkb1r/pppp1Qpp/2n5/4p3/2B1n3/8/PPPP1PPP/RNB1K1NR b KQkq - 0 1');
      expect(MoveGenerator.isInCheck(mateBoard), isTrue);
      expect(MoveGenerator.generateLegalMoves(mateBoard).isEmpty, isTrue);
      expect(MoveGenerator.getGameStatus(mateBoard), equals(GameStatus.checkmate));

      // 2. Corner King trapped by Queen: Stalemate
      final staleBoard = Board.fromFen('k7/2K5/1Q6/8/8/8/8/8 b - - 0 1');
      expect(MoveGenerator.isInCheck(staleBoard), isFalse);
      expect(MoveGenerator.generateLegalMoves(staleBoard).isEmpty, isTrue);
      expect(MoveGenerator.getGameStatus(staleBoard), equals(GameStatus.stalemate));
    });

    test('Insufficient Material Matrix', () {
      // King vs King
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('8/8/8/4k3/8/8/8/4K3 w - - 0 1')), isTrue);
      // King + Bishop vs King
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('8/8/8/4k3/8/5B2/8/4K3 w - - 0 1')), isTrue);
      // King + Knight vs King
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('8/8/8/4k3/8/5N2/8/4K3 w - - 0 1')), isTrue);
      // King + Bishop vs King + Bishop (same color square: light vs light)
      // c1 is dark, f8 is dark
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('5b2/8/8/4k3/8/8/8/2B1K3 w - - 0 1')), isTrue);
      // King + Pawn vs King is SUFFICIENT material
      expect(MoveGenerator.isInsufficientMaterial(Board.fromFen('8/8/8/4k3/4P3/8/8/4K3 w - - 0 1')), isFalse);
    });

    test('50-Move Rule (claimable) vs 75-Move Rule (automatic draw)', () {
      final board50 = Board.fromFen('8/8/8/4k3/8/8/8/4K3 w - - 100 50');
      expect(MoveGenerator.getGameStatus(board50), equals(GameStatus.fiftyMoveRule));

      final board75 = Board.fromFen('8/8/8/4k3/8/8/8/4K3 w - - 150 75');
      expect(MoveGenerator.getGameStatus(board75), equals(GameStatus.seventyFiveMoveRule));
    });

    test('Threefold Repetition Detection', () {
      final board = Board.initial();
      final move1 = const Move(from: Square.g1, to: Square.f3);
      final move2 = const Move(from: Square.g8, to: Square.f6);
      final move3 = const Move(from: Square.f3, to: Square.g1);
      final move4 = const Move(from: Square.f6, to: Square.g8);

      // Repetition 1: initial position (count = 1)
      expect(board.currentPositionOccurrences, equals(1));

      // 1. Nf3 Nf6 2. Ng1 Ng8 (count = 2)
      board.makeMove(move1);
      board.makeMove(move2);
      board.makeMove(move3);
      board.makeMove(move4);
      expect(board.currentPositionOccurrences, equals(2));

      // 3. Nf3 Nf6 4. Ng1 Ng8 (count = 3 -> threefold repetition draw!)
      board.makeMove(move1);
      board.makeMove(move2);
      board.makeMove(move3);
      board.makeMove(move4);
      expect(board.currentPositionOccurrences, equals(3));
      expect(MoveGenerator.getGameStatus(board), equals(GameStatus.threefoldRepetition));
    });

    test('Strict Rejection of Malformed / Malicious FEN Strings', () {
      // 1. Missing king
      expect(FenParser.isValidFen('rnbq1bnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQ1BNR w KQkq - 0 1'), isFalse);
      // 2. Multiple kings of same color
      expect(FenParser.isValidFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNK w KQkq - 0 1'), isFalse);
      // 3. Pawns on 1st or 8th rank
      expect(FenParser.isValidFen('Pnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'), isFalse);
      expect(FenParser.isValidFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNp w KQkq - 0 1'), isFalse);
      // 4. Invalid rank count (9 ranks)
      expect(FenParser.isValidFen('8/8/8/8/8/8/8/8/8 w - - 0 1'), isFalse);
      // 5. Invalid active color
      expect(FenParser.isValidFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR x KQkq - 0 1'), isFalse);
      // 6. Invalid castling rights token
      expect(FenParser.isValidFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KKqq - 0 1'), isFalse);
      // 7. Invalid en passant square
      expect(FenParser.isValidFen('rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq e9 0 1'), isFalse);
    });

    test('Randomized Legal Move Property-Based Fuzzing (10 games x 40 plies)', () {
      final rng = Random(42);

      for (int gameIdx = 0; gameIdx < 10; gameIdx++) {
        final board = Board.initial();
        for (int ply = 0; ply < 40; ply++) {
          final legalMoves = MoveGenerator.generateLegalMoves(board);
          if (legalMoves.isEmpty) break; // Checkmate or stalemate reached

          final move = legalMoves[rng.nextInt(legalMoves.length)];
          board.makeMove(move);

          // Invariant: Both kings must be present on the board
          expect(board.kingSquare(PieceColor.white), isNotNull);
          expect(board.kingSquare(PieceColor.black), isNotNull);

          // Invariant: The side that just moved must not be in check
          expect(MoveGenerator.isInCheck(board, board.activeColor.opposite), isFalse);

          // Invariant: FEN roundtrip
          final fen = board.toFen();
          final reloaded = Board.fromFen(fen);
          expect(reloaded.toFen(), equals(fen));
        }
      }
    });
  });
}
