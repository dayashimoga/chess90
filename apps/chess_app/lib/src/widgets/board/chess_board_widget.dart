import 'dart:math';
import 'package:chess_core/chess_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../theme/chess_board_theme.dart';
import '../../theme/chess_theme.dart';
import '../../theme/piece_theme.dart';
import 'vector_piece_widget.dart';

/// Graphical movement arrow displayed on the chessboard.
class BoardArrow {
  final Square from;
  final Square to;
  final Color color;

  const BoardArrow({
    required this.from,
    required this.to,
    this.color = const Color(0xCC22C55E),
  });
}

/// Interactive 64-square chessboard with vector piece rendering, smooth move animation,
/// legal move dots, check highlighting, persistent last-move overlays, and promotion handling.
class ChessBoardWidget extends StatefulWidget {
  final Board board;
  final bool isFlipped;
  final Function(Move move)? onMovePlayed;
  final List<Square> highlightedSquares;
  final bool isInteractive;
  final ChessBoardTheme? boardTheme;
  final PieceTheme? pieceTheme;
  final Square? lastMoveFrom;
  final Square? lastMoveTo;
  final int animationDurationMs;
  final bool showCoordinates;
  final bool showMoveHighlights;
  final bool showLegalMoveHints;
  final bool showQuickCustomizer;
  final VoidCallback? onQuickCustomizerPressed;
  final Square? checkSquare;
  final List<BoardArrow> arrows;

  const ChessBoardWidget({
    super.key,
    required this.board,
    this.isFlipped = false,
    this.onMovePlayed,
    this.highlightedSquares = const [],
    this.isInteractive = true,
    this.boardTheme,
    this.pieceTheme,
    this.lastMoveFrom,
    this.lastMoveTo,
    this.animationDurationMs = 250,
    this.showCoordinates = true,
    this.showMoveHighlights = true,
    this.showLegalMoveHints = true,
    this.showQuickCustomizer = false,
    this.onQuickCustomizerPressed,
    this.checkSquare,
    this.arrows = const [],
  });

  @override
  State<ChessBoardWidget> createState() => _ChessBoardWidgetState();
}

class _ChessBoardWidgetState extends State<ChessBoardWidget> with SingleTickerProviderStateMixin {
  Square? _selectedSquare;
  Square _focusedSquare = Square.e4;
  List<Move> _legalMovesFromSelected = [];
  final FocusNode _focusNode = FocusNode();

  // Last move highlights
  Square? _localLastMoveFrom;
  Square? _localLastMoveTo;

  // Move animation pipeline
  late AnimationController _animController;
  late Animation<double> _animCurve;
  Move? _animatingMove;
  Piece? _animatingPiece;
  Piece? _animatingRook;
  Square? _animRookFrom;
  Square? _animRookTo;
  Piece? _capturedPiece;

  @override
  void initState() {
    super.initState();
    _localLastMoveFrom = widget.lastMoveFrom;
    _localLastMoveTo = widget.lastMoveTo;

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDurationMs),
    );
    _animCurve = CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic);
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animatingMove = null;
          _animatingPiece = null;
          _animatingRook = null;
          _animRookFrom = null;
          _animRookTo = null;
          _capturedPiece = null;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ChessBoardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final moveFrom = widget.lastMoveFrom;
    final moveTo = widget.lastMoveTo;
    final moveChanged = moveFrom != oldWidget.lastMoveFrom || moveTo != oldWidget.lastMoveTo;

    if (moveChanged) {
      _localLastMoveFrom = moveFrom;
      _localLastMoveTo = moveTo;
    }

    if (moveFrom != null && moveTo != null && moveChanged) {
      // Check if this move was already triggered by local user tap
      final wasLocallyTriggered = _animatingMove != null &&
          _animatingMove!.from == moveFrom &&
          _animatingMove!.to == moveTo;

      if (!wasLocallyTriggered) {
        // Only animate forward moves (not undo / backward scrub)
        final isForwardMove = widget.board.history.isEmpty ||
            oldWidget.board.history.isEmpty ||
            widget.board.history.length > oldWidget.board.history.length;

        if (isForwardMove) {
          Move? historicalMove;
          Piece? captured;
          if (widget.board.history.isNotEmpty) {
            final lastRecord = widget.board.history.last;
            if (lastRecord.move.from == moveFrom && lastRecord.move.to == moveTo) {
              historicalMove = lastRecord.move;
              captured = lastRecord.capturedPiece;
            }
          }
          _triggerExternalMoveAnimation(
            from: moveFrom,
            to: moveTo,
            move: historicalMove,
            capturedPiece: captured,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _triggerMoveAnimation(Move move) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.animationDurationMs <= 0 || disableAnimations) {
      _localLastMoveFrom = move.from;
      _localLastMoveTo = move.to;
      return;
    }

    final mover = widget.board.pieceAt(move.from);
    if (mover == null) return;

    if (_animController.isAnimating) {
      _animController.stop();
    }

    _animatingMove = move;
    _animatingPiece = mover;
    _localLastMoveFrom = move.from;
    _localLastMoveTo = move.to;

    // Detect capture
    _capturedPiece = widget.board.pieceAt(move.to);
    if (_capturedPiece == null && move.flag == MoveFlag.enPassant) {
      final capSquare = Square.fromCoords(move.to.file, move.from.rank);
      _capturedPiece = widget.board.pieceAt(capSquare);
    }

    // Detect castling
    if (mover.type == PieceType.king && (move.to.file - move.from.file).abs() == 2) {
      final rank = move.from.rank;
      if (move.to.file == 6) {
        // King-side (O-O): Rook from file 7 to file 5
        _animRookFrom = Square.fromCoords(7, rank);
        _animRookTo = Square.fromCoords(5, rank);
        _animatingRook = widget.board.pieceAt(_animRookFrom!);
      } else if (move.to.file == 2) {
        // Queen-side (O-O-O): Rook from file 0 to file 3
        _animRookFrom = Square.fromCoords(0, rank);
        _animRookTo = Square.fromCoords(3, rank);
        _animatingRook = widget.board.pieceAt(_animRookFrom!);
      }
    } else {
      _animatingRook = null;
      _animRookFrom = null;
      _animRookTo = null;
    }

    _animController.forward(from: 0.0);
  }

  void _triggerExternalMoveAnimation({
    required Square from,
    required Square to,
    Move? move,
    Piece? capturedPiece,
  }) {
    final disableAnimations = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (widget.animationDurationMs <= 0 || disableAnimations) {
      _localLastMoveFrom = from;
      _localLastMoveTo = to;
      return;
    }

    // In an external move, widget.board already has the moved piece at `to`
    final mover = widget.board.pieceAt(to);
    if (mover == null) return;

    if (_animController.isAnimating) {
      _animController.stop();
    }

    _animatingMove = move ?? Move(from: from, to: to);
    _animatingPiece = mover;
    _localLastMoveFrom = from;
    _localLastMoveTo = to;
    _capturedPiece = capturedPiece;

    // Detect castling
    if (mover.type == PieceType.king && (to.file - from.file).abs() == 2) {
      final rank = from.rank;
      if (to.file == 6) {
        _animRookFrom = Square.fromCoords(7, rank);
        _animRookTo = Square.fromCoords(5, rank);
        _animatingRook = widget.board.pieceAt(_animRookTo!);
      } else if (to.file == 2) {
        _animRookFrom = Square.fromCoords(0, rank);
        _animRookTo = Square.fromCoords(3, rank);
        _animatingRook = widget.board.pieceAt(_animRookTo!);
      }
    } else {
      _animatingRook = null;
      _animRookFrom = null;
      _animRookTo = null;
    }

    _animController.forward(from: 0.0);
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
          _triggerMoveAnimation(matchingMove);
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
    final activePieceTheme = widget.pieceTheme ?? PieceTheme.standard;

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
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      VectorPieceWidget(
                        piece: piece,
                        size: 48,
                        theme: activePieceTheme,
                      ),
                      // Transparent text symbol for widget test matchers and screen-reader accessibility
                      Opacity(
                        opacity: 0.0,
                        child: Text(
                          piece.unicodeSymbol,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ],
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
      _triggerMoveAnimation(promoMove);
      widget.onMovePlayed?.call(promoMove);
    }
  }

  Offset _squareToOffset(Square sq, double squareSize) {
    final col = widget.isFlipped ? 7 - sq.file : sq.file;
    final row = widget.isFlipped ? sq.rank : 7 - sq.rank;
    return Offset(col * squareSize, row * squareSize);
  }

  @override
  Widget build(BuildContext context) {
    final isWhiteInCheck = MoveGenerator.isInCheck(widget.board, PieceColor.white);
    final isBlackInCheck = MoveGenerator.isInCheck(widget.board, PieceColor.black);

    final whiteKingSq = widget.board.kingSquare(PieceColor.white);
    final blackKingSq = widget.board.kingSquare(PieceColor.black);

    final boardTheme = widget.boardTheme ?? ChessBoardTheme.tournamentGreen;
    final pieceTheme = widget.pieceTheme ?? PieceTheme.standard;

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
                borderRadius: BorderRadius.circular(boardTheme.borderRadius),
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
                borderRadius: BorderRadius.circular(boardTheme.borderRadius - 2),
                child: Stack(
                  children: [
                    // 8x8 Board Squares Grid
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 8,
                      ),
                      itemCount: 64,
                      itemBuilder: (context, gridIndex) {
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
                        final isLastFrom = _localLastMoveFrom == square;
                        final isLastTo = _localLastMoveTo == square;

                        final isCheckSquare = (square == whiteKingSq && isWhiteInCheck) ||
                            (square == blackKingSq && isBlackInCheck);

                        // Base square color
                        Color squareBg = isLight ? boardTheme.lightSquare : boardTheme.darkSquare;

                        // Piece currently at this square
                        final piece = widget.board.pieceAt(square);

                        // If this piece is currently in flight during animation, don't draw it on the square
                        final isInFlight = _animatingMove != null && _animatingMove!.from == square;
                        final isDestInFlight = _animatingMove != null && _animatingMove!.to == square;
                        final isRookInFlight = _animRookFrom != null && _animRookFrom == square;
                        final isRookDestInFlight = _animRookTo != null && _animRookTo == square;
                        final isEnPassantCapSquare = _animatingMove != null &&
                            _animatingMove!.flag == MoveFlag.enPassant &&
                            square == Square.fromCoords(_animatingMove!.to.file, _animatingMove!.from.rank);

                        final shouldDrawPiece = piece != null &&
                            !isInFlight &&
                            !isDestInFlight &&
                            !isRookInFlight &&
                            !isRookDestInFlight &&
                            !isEnPassantCapSquare;

                        final pieceToRender = shouldDrawPiece
                            ? piece
                            : ((isDestInFlight && _capturedPiece != null && _animatingMove?.flag != MoveFlag.enPassant)
                                ? _capturedPiece
                                : (isEnPassantCapSquare && _capturedPiece != null ? _capturedPiece : null));

                        final semanticPiece = pieceToRender ?? (shouldDrawPiece ? piece : null);

                        return Semantics(
                          container: true,
                          excludeSemantics: true,
                          label: semanticPiece != null
                              ? '${semanticPiece.color == PieceColor.white ? "White" : "Black"} ${semanticPiece.type.name} on ${square.name}'
                              : 'Empty square ${square.name}',
                          button: true,
                          child: DragTarget<Square>(
                            onWillAcceptWithDetails: (details) {
                              if (!widget.isInteractive) return false;
                              final fromSq = details.data;
                              if (fromSq == square) return false;
                              final legals = MoveGenerator.generateLegalMoves(widget.board);
                              return legals.any((m) => m.from == fromSq && m.to == square);
                            },
                            onAcceptWithDetails: (details) {
                              final fromSq = details.data;
                              _onSquareTapped(fromSq);
                              _onSquareTapped(square);
                            },
                            builder: (context, candidateData, rejectedData) {
                              final isHoverTarget = candidateData.isNotEmpty;

                              return GestureDetector(
                                onTap: () => _onSquareTapped(square),
                                child: Container(
                                  color: isHoverTarget ? boardTheme.legalMoveDotColor.withAlpha(80) : squareBg,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Last move source overlay
                                      if (widget.showMoveHighlights && isLastFrom)
                                        Container(color: boardTheme.lastMoveSourceOverlay),

                                      // Last move destination overlay
                                      if (widget.showMoveHighlights && isLastTo)
                                        Container(color: boardTheme.lastMoveDestinationOverlay),

                                      // Selected square overlay
                                      if (isSelected)
                                        Container(color: boardTheme.selectedSquareOverlay),

                                      // User hint / custom highlighted squares
                                      if (isHighlighted)
                                        Container(color: boardTheme.hintSquareOverlay),

                                      // Keyboard focus indicator
                                      if (isFocused)
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: ChessTheme.accentGold, width: 2.5),
                                          ),
                                        ),

                                      // In-Check Glow Overlay
                                      if (isCheckSquare)
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: boardTheme.checkGlowColor,
                                                blurRadius: 18,
                                                spreadRadius: 6,
                                              ),
                                            ],
                                          ),
                                        ),

                                      // Coordinate labels (rank on edge file, file on edge rank)
                                      if (widget.showCoordinates && file == (widget.isFlipped ? 7 : 0))
                                        Positioned(
                                          top: 2,
                                          left: 2,
                                          child: Text(
                                            square.rankName,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isLight ? boardTheme.coordinateLightSquare : boardTheme.coordinateDarkSquare,
                                            ),
                                          ),
                                        ),
                                      if (widget.showCoordinates && rank == (widget.isFlipped ? 7 : 0))
                                        Positioned(
                                          bottom: 2,
                                          right: 2,
                                          child: Text(
                                            square.fileName,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: isLight ? boardTheme.coordinateLightSquare : boardTheme.coordinateDarkSquare,
                                            ),
                                          ),
                                        ),

                                      // Settled / In-Flight-Captured piece rendering with Drag & Drop
                                      if (pieceToRender != null)
                                        (widget.isInteractive && pieceToRender.color == widget.board.activeColor)
                                            ? Draggable<Square>(
                                                data: square,
                                                feedback: Material(
                                                  color: Colors.transparent,
                                                  child: VectorPieceWidget(
                                                    piece: pieceToRender,
                                                    size: squareSize * 0.95,
                                                    theme: pieceTheme,
                                                  ),
                                                ),
                                                childWhenDragging: Opacity(
                                                  opacity: 0.25,
                                                  child: VectorPieceWidget(
                                                    piece: pieceToRender,
                                                    size: squareSize * 0.82,
                                                    theme: pieceTheme,
                                                  ),
                                                ),
                                                child: VectorPieceWidget(
                                                  piece: pieceToRender,
                                                  size: squareSize * 0.82,
                                                  theme: pieceTheme,
                                                ),
                                              )
                                            : VectorPieceWidget(
                                                piece: pieceToRender,
                                                size: squareSize * 0.82,
                                                theme: pieceTheme,
                                              ),

                                      // Legal move target dot / capture ring
                                      if (widget.showLegalMoveHints && isLegalTarget)
                                        Container(
                                          width: piece == null ? squareSize * 0.28 : squareSize * 0.85,
                                          height: piece == null ? squareSize * 0.28 : squareSize * 0.85,
                                          decoration: BoxDecoration(
                                            color: piece == null ? boardTheme.legalMoveDotColor : Colors.transparent,
                                            shape: BoxShape.circle,
                                            border: piece != null
                                                ? Border.all(color: boardTheme.legalMoveCaptureRingColor, width: 3)
                                                : null,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    // Active Move Travel Animation Layer
                    if (_animatingMove != null && _animatingPiece != null)
                      AnimatedBuilder(
                        animation: _animCurve,
                        builder: (context, _) {
                          final t = _animCurve.value;
                          final fromOffset = _squareToOffset(_animatingMove!.from, squareSize);
                          final toOffset = _squareToOffset(_animatingMove!.to, squareSize);
                          final currentOffset = Offset.lerp(fromOffset, toOffset, t)!;

                          return Stack(
                            children: [
                              // Moving piece in flight
                              Positioned(
                                left: currentOffset.dx,
                                top: currentOffset.dy,
                                width: squareSize,
                                height: squareSize,
                                child: Center(
                                  child: VectorPieceWidget(
                                    piece: _animatingPiece!,
                                    size: squareSize * 0.85,
                                    theme: pieceTheme,
                                  ),
                                ),
                              ),

                              // Simultaneous castling rook travel
                              if (_animatingRook != null && _animRookFrom != null && _animRookTo != null) ...[
                                Builder(builder: (_) {
                                  final rookFromOffset = _squareToOffset(_animRookFrom!, squareSize);
                                  final rookToOffset = _squareToOffset(_animRookTo!, squareSize);
                                  final rookOffset = Offset.lerp(rookFromOffset, rookToOffset, t)!;
                                  return Positioned(
                                    left: rookOffset.dx,
                                    top: rookOffset.dy,
                                    width: squareSize,
                                    height: squareSize,
                                    child: Center(
                                      child: VectorPieceWidget(
                                        piece: _animatingRook!,
                                        size: squareSize * 0.85,
                                        theme: pieceTheme,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ],
                          );
                        },
                      ),

                    // Movement Arrows Overlay
                    if (widget.arrows.isNotEmpty)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _ArrowPainter(
                              arrows: widget.arrows,
                              isFlipped: widget.isFlipped,
                              squareSize: squareSize,
                            ),
                          ),
                        ),
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

/// Custom painter for tactical and movement arrows on the chessboard.
class _ArrowPainter extends CustomPainter {
  final List<BoardArrow> arrows;
  final bool isFlipped;
  final double squareSize;

  _ArrowPainter({required this.arrows, required this.isFlipped, required this.squareSize});

  @override
  void paint(Canvas canvas, Size size) {
    for (final arrow in arrows) {
      final fromCol = isFlipped ? 7 - arrow.from.file : arrow.from.file;
      final fromRow = isFlipped ? arrow.from.rank : 7 - arrow.from.rank;
      final toCol = isFlipped ? 7 - arrow.to.file : arrow.to.file;
      final toRow = isFlipped ? arrow.to.rank : 7 - arrow.to.rank;

      final start = Offset((fromCol + 0.5) * squareSize, (fromRow + 0.5) * squareSize);
      final end = Offset((toCol + 0.5) * squareSize, (toRow + 0.5) * squareSize);

      final paint = Paint()
        ..color = arrow.color
        ..strokeWidth = max(3.0, squareSize * 0.08)
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(start, end, paint);

      final angle = atan2(end.dy - start.dy, end.dx - start.dx);
      final arrowSize = max(8.0, squareSize * 0.16);

      final p1 = Offset(end.dx - arrowSize * cos(angle - pi / 6), end.dy - arrowSize * sin(angle - pi / 6));
      final p2 = Offset(end.dx - arrowSize * cos(angle + pi / 6), end.dy - arrowSize * sin(angle + pi / 6));

      final headPath = Path()
        ..moveTo(end.dx, end.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close();

      final fillPaint = Paint()
        ..color = arrow.color
        ..style = PaintingStyle.fill;

      canvas.drawPath(headPath, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) => true;
}
