import 'package:chess_core/chess_core.dart';
import 'models/video_frame.dart';
import 'models/video_profile.dart';

/// Generates a continuous, deterministic timeline of discrete frames from a PGN game.
class VideoTimelineGenerator {
  final VideoProfile profile;

  const VideoTimelineGenerator({this.profile = const VideoProfile()});

  /// Generates the full sequence of video frames for a game.
  List<VideoFrame> generateTimeline(
    PgnGame game, {
    Map<int, int> evaluationsByPly = const {},
    List<int> criticalPlies = const [],
  }) {
    final frames = <VideoFrame>[];
    final board = game.setupFen != null ? Board.fromFen(game.setupFen!) : Board.initial();

    final fps = profile.fps;
    final moveFramesCount = (profile.moveSpeedSeconds * fps).round().clamp(1, 60);
    final pauseFramesCount = (0.2 * fps).round().clamp(1, 60); // 0.2s pause after move
    final criticalPauseFramesCount = (profile.criticalMomentPauseSeconds * fps).round().clamp(1, 120);

    int currentFrameIndex = 0;
    double currentTimestamp = 0.0;
    final frameDeltaTime = 1.0 / fps;

    // Initial position pause (0.4 second)
    final initialPauseFrames = (0.4 * fps).round().clamp(1, 60);
    for (int f = 0; f < initialPauseFrames; f++) {
      frames.add(VideoFrame(
        frameIndex: currentFrameIndex++,
        timestampSeconds: currentTimestamp,
        fen: board.toFen(),
        moveNotation: 'Start of Game',
        subtitleText: '${game.white} vs ${game.black} (${game.event}, ${game.year})',
        whiteClock: game.moves.firstOrNull?.clock,
        blackClock: game.moves.firstOrNull?.clock,
      ));
      currentTimestamp += frameDeltaTime;
    }

    // Determine ply range according to content profile
    int startPly = 0;
    int endPly = game.moves.length;

    switch (profile.contentProfile) {
      case VideoContentProfile.openingExplorer:
        endPly = game.moves.length.clamp(0, 24); // First 12 moves
        break;
      case VideoContentProfile.tacticsShot:
      case VideoContentProfile.blunderReel:
        if (criticalPlies.isNotEmpty) {
          final cp = criticalPlies.first;
          startPly = (cp - 2).clamp(0, game.moves.length);
          endPly = (cp + 4).clamp(0, game.moves.length);
        }
        break;
      case VideoContentProfile.endgameStudy:
        if (game.moves.length > 20) {
          startPly = (game.moves.length - 20).clamp(0, game.moves.length);
        }
        break;
      case VideoContentProfile.shortClip:
        if (criticalPlies.isNotEmpty) {
          final cp = criticalPlies.first;
          startPly = (cp - 2).clamp(0, game.moves.length);
          endPly = (cp + 6).clamp(0, game.moves.length);
        } else {
          endPly = game.moves.length.clamp(0, 16);
        }
        break;
      case VideoContentProfile.fullGame:
      case VideoContentProfile.highlightReel:
        break;
    }

    // Advance board to startPly if needed
    for (int p = 0; p < startPly; p++) {
      final m = game.moves[p].move;
      if (m != null) board.makeMove(m);
    }

    // Step through each ply in range
    for (int ply = startPly; ply < endPly; ply++) {
      final pgnNode = game.moves[ply];
      final move = pgnNode.move;
      if (move == null) continue;

      final movingPiece = board.pieceAt(move.from);
      final fenBefore = board.toFen();
      final evalCp = evaluationsByPly[ply] ?? (pgnNode.evaluation != null ? (pgnNode.evaluation! * 100).round() : null);
      final isCritical = criticalPlies.contains(ply);

      final arrows = <VideoArrow>[
        VideoArrow(
          fromSquare: move.from.name,
          toSquare: move.to.name,
          colorHex: isCritical ? '#EAB308' : '#22C55E', // Yellow for critical, Green for normal
        ),
      ];

      // Interpolation frames (piece moving smoothly)
      for (int step = 0; step < moveFramesCount; step++) {
        final fraction = (step + 1) / moveFramesCount;
        frames.add(VideoFrame(
          frameIndex: currentFrameIndex++,
          timestampSeconds: currentTimestamp,
          fen: fenBefore,
          ply: ply,
          isCriticalMoment: isCritical,
          movingPiece: movingPiece,
          movingFrom: move.from,
          movingTo: move.to,
          interpolationFraction: fraction,
          evaluationCentipawns: evalCp,
          highlightedSquares: [move.from, move.to],
          arrows: arrows,
          moveNotation: '${pgnNode.isWhite ? "${pgnNode.moveNumber}. " : "${pgnNode.moveNumber}... "}${pgnNode.san}',
          subtitleText: isCritical ? 'Critical Turning Point: ${pgnNode.san}' : (pgnNode.comment ?? ''),
          whiteClock: pgnNode.clock,
          blackClock: pgnNode.clock,
        ));
        currentTimestamp += frameDeltaTime;
      }

      // Execute move on internal board
      board.makeMove(move);
      final fenAfter = board.toFen();

      // Post-move dwell pause
      final dwellFrames = isCritical ? criticalPauseFramesCount : pauseFramesCount;
      for (int step = 0; step < dwellFrames; step++) {
        frames.add(VideoFrame(
          frameIndex: currentFrameIndex++,
          timestampSeconds: currentTimestamp,
          fen: fenAfter,
          ply: ply,
          isCriticalMoment: isCritical,
          movingPiece: null,
          evaluationCentipawns: evalCp,
          highlightedSquares: [move.from, move.to],
          arrows: arrows,
          moveNotation: '${pgnNode.isWhite ? "${pgnNode.moveNumber}. " : "${pgnNode.moveNumber}... "}${pgnNode.san}',
          subtitleText: isCritical ? 'Critical Position: ${pgnNode.san}' : (pgnNode.comment ?? ''),
          whiteClock: pgnNode.clock,
          blackClock: pgnNode.clock,
        ));
        currentTimestamp += frameDeltaTime;
      }
    }

    // Final result screen pause (2 seconds)
    final endPauseFrames = fps * 2;
    for (int f = 0; f < endPauseFrames; f++) {
      frames.add(VideoFrame(
        frameIndex: currentFrameIndex++,
        timestampSeconds: currentTimestamp,
        fen: board.toFen(),
        moveNotation: 'Final Position: ${game.result}',
        subtitleText: 'Result: ${game.result} - Game Complete',
      ));
      currentTimestamp += frameDeltaTime;
    }

    return frames;
  }
}
