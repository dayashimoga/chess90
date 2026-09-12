import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../theme/chess_theme.dart';

/// Interactive 64-square chessboard with legal move dots, check highlighting,
/// and promotion handling.
class ChessBoardWidget extends StatefulWidget {
  final Board board;
  final bool isFlipped;
  final Function(Move move)? onMovePlayed;
  final List<Square> highlightedSquares;
  final bool isInteractive;

  const ChessBoardWidget({
    super.key,
    required this.board,
    this.isFlipped = false,
    this.onMovePlayed,
    this.highlightedSquares = const [],
    this.isInteractive = true,
  });

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> {
  Square? _selectedSquare;
  Square _focusedSquare = Square.e4;
  List<Move> _legalMovesFromSelected = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onSquareTapped(Square square) {
    if (!widget.isInteractive) return;
    _focusedSquare = square;

    final piece = widget.board.pieceAt(square);

    // If already selected and tapped a valid destination
    if (_selectedSquare != null) {
      final matchingMove = _legalMovesFromSelected.where((m) => m.to == square).firstOrNull;
      if (matchingMove != null) {
        // Handle pawn promotion
        if (matchingMove.flag == MoveFlag.promotion ||
            (_isPawn(matchingMove.from) && (square.rank == 0 || square.rank == 7))) {
          _promptPromotion(matchingMove.from, square);
        } else {
          final san = MoveGenerator.moveToSan(widget.board, matchingMove);
          SemanticsService.sendAnnouncement(View.of(context), 'Move played: $san', TextDirection.ltr);
          widget.onMovePlayed?.call(matchingMove);
        }
        setState(() {
          _selectedSquare = null;
          _legalMovesFromSelected = [];
        });
        return;
      }
    }

    // Select piece if it belongs to active color
    if (piece != null && piece.color == widget.board.activeColor) {
      final allLegal = MoveGenerator.generateLegalMoves(widget.board);
      setState(() {
        _selectedSquare = square;
        _legalMovesFromSelected = allLegal.where((m) => m.from == square).toList();
      });
    } else {
      setState(() {
        _selectedSquare = null;
        _legalMovesFromSelected = [];
      });
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    int file = _focusedSquare.file;
    int rank = _focusedSquare.rank;

    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      file = (file + 1).clamp(0, 7);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      file = (file - 1).clamp(0, 7);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      rank = (rank + 1).clamp(0, 7);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      rank = (rank - 1).clamp(0, 7);
    } else if (event.logicalKey == LogicalKeyboardKey.space ||
               event.logicalKey == LogicalKeyboardKey.enter) {
      _onSquareTapped(_focusedSquare);
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }

    setState(() {
      _focusedSquare = Square.fromCoords(file, rank);
    });
    return KeyEventResult.handled;
  }

  bool _isPawn(Square square) {
    final piece = widget.board.pieceAt(square);
    return piece != null && piece.type == PieceType.pawn;
  }

  Future<void> _promptPromotion(Square from, Square to) async {
    final color = widget.board.activeColor;
    final options = [PieceType.queen, PieceType.rook, PieceType.bishop, PieceType.knight];

    final chosen = await showDialog<PieceType>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: ctx.surf,
          title: Text('Promote Pawn', style: TextStyle(color: ctx.txt)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: options.map((type) {
              final piece = Piece(type, color);
              return InkWell(
                onTap: () => Navigator.of(ctx).pop(type),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    piece.unicodeSymbol,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );

    if (chosen != null) {
      final promoMove = Move(
        from: from,
        to: to,
        promotion: chosen,
        flag: MoveFlag.promotion,
      );
      widget.onMovePlayed?.call(promoMove);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWhiteInCheck = MoveGenerator.isInCheck(widget.board, PieceColor.white);
    final isBlackInCheck = MoveGenerator.isInCheck(widget.board, PieceColor.black);

    final whiteKingSq = widget.board.kingSquare(PieceColor.white);
    final blackKingSq = widget.board.kingSquare(PieceColor.black);

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final squareSize = boardSize / 8.0;

        return Center(
          child: Focus(
            focusNode: _focusNode,
            onKeyEvent: _handleKeyEvent,
            child: Container(
              width: boardSize,
              height: boardSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.brd, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(context.isDark ? 80 : 25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  children: [
                    // 8x8 Board Squares Grid
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                      itemCount: 64,
                      itemBuilder: (context, gridIndex) {
                        // Map gridIndex (0 at top-left) to Square (0 at a1 = bottom-left)
                        final row = gridIndex ~/ 8; // 0 (top) to 7 (bottom)
                        final col = gridIndex % 8; // 0 (left) to 7 (right)

                        final rank = widget.isFlipped ? row : 7 - row;
                        final file = widget.isFlipped ? 7 - col : col;
                        final square = Square.fromCoords(file, rank);

                        final isLight = square.isLightSquare;
                        final isSelected = _selectedSquare == square;
                        final isFocused = _focusNode.hasFocus && _focusedSquare == square;
                        final isHighlighted = widget.highlightedSquares.contains(square);
                        final isLegalTarget = _legalMovesFromSelected.any((m) => m.to == square);

                        final isCheckSquare = (square == whiteKingSq && isWhiteInCheck) ||
                            (square == blackKingSq && isBlackInCheck);

                        Color bgColor = isLight ? ChessTheme.boardLight : ChessTheme.boardDark;
                        if (isSelected || isHighlighted) {
                          bgColor = ChessTheme.boardHighlight;
                        }

                        final piece = widget.board.pieceAt(square);

                        return Semantics(
                          container: true,
                          excludeSemantics: true,
                          label: piece != null
                              ? '${piece.color == PieceColor.white ? "White" : "Black"} ${piece.type.name} on ${square.name}'
                              : 'Empty square ${square.name}',
                          button: true,
                          child: GestureDetector(
                            onTap: () => _onSquareTapped(square),
                            child: Container(
                              decoration: BoxDecoration(
                                color: bgColor,
                                border: isFocused
                                    ? Border.all(color: ChessTheme.accentGold, width: 2.5)
                                    : null,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                              children: [
                                // Coordinate labels
                                if (file == (widget.isFlipped ? 7 : 0))
                                  Positioned(
                                    top: 2,
                                    left: 2,
                                    child: Text(
                                      square.rankName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isLight ? ChessTheme.boardDark : ChessTheme.boardLight,
                                      ),
                                    ),
                                  ),
                                if (rank == (widget.isFlipped ? 7 : 0))
                                  Positioned(
                                    bottom: 2,
                                    right: 2,
                                    child: Text(
                                      square.fileName,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isLight ? ChessTheme.boardDark : ChessTheme.boardLight,
                                      ),
                                    ),
                                  ),

                                // In-Check Red Glow
                                if (isCheckSquare)
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: ChessTheme.checkGlow,
                                          blurRadius: 18,
                                          spreadRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),

                                // Chess Piece Display
                                if (piece != null)
                                  Text(
                                    piece.unicodeSymbol,
                                    style: TextStyle(
                                      fontSize: squareSize * 0.72,
                                      fontWeight: FontWeight.bold,
                                      color: piece.color == PieceColor.white ? Colors.white : Colors.black,
                                      shadows: [
                                        Shadow(
                                          color: piece.color == PieceColor.white
                                              ? Colors.black87
                                              : Colors.white70,
                                          blurRadius: 2,
                                          offset: const Offset(1, 1),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Legal move target dot / capture ring
                                if (isLegalTarget)
                                  Container(
                                    width: piece == null ? squareSize * 0.28 : squareSize * 0.85,
                                    height: piece == null ? squareSize * 0.28 : squareSize * 0.85,
                                    decoration: BoxDecoration(
                                      color: piece == null ? ChessTheme.legalMoveDot : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: piece != null
                                          ? Border.all(color: ChessTheme.legalMoveDot, width: 3)
                                          : null,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  }
}
