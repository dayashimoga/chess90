import 'package:chess_core/chess_core.dart';
import 'video_profile.dart';

/// Represents a single discrete frame in the video animation timeline.
class VideoFrame {
  final int frameIndex;
  final double timestampSeconds;
  final String fen;
  final int ply;
  final bool isCriticalMoment;
  final Piece? movingPiece;
  final Square? movingFrom;
  final Square? movingTo;
  final double interpolationFraction; // 0.0 to 1.0 (0.0 = at start, 1.0 = arrived)
  final int? evaluationCentipawns;
  final List<Square> highlightedSquares;
  final List<VideoArrow> arrows;
  final String moveNotation;
  final String? subtitleText;
  final String? whiteClock;
  final String? blackClock;

  const VideoFrame({
    required this.frameIndex,
    required this.timestampSeconds,
    required this.fen,
    this.ply = 0,
    this.isCriticalMoment = false,
    this.movingPiece,
    this.movingFrom,
    this.movingTo,
    this.interpolationFraction = 1.0,
    this.evaluationCentipawns,
    this.highlightedSquares = const [],
    this.arrows = const [],
    required this.moveNotation,
    this.subtitleText,
    this.whiteClock,
    this.blackClock,
  });

  String? get subtitle => subtitleText;
  int? get evaluation => evaluationCentipawns;

  bool get isPieceInMotion =>
      movingPiece != null && movingFrom != null && movingTo != null && interpolationFraction < 1.0;
}
