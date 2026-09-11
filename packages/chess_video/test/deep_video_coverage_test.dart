import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'package:chess_video/chess_video.dart';
import 'package:test/test.dart';

void main() {
  group('Deep Chess Video Coverage & Profiles', () {
    test('FfmpegCommandBuilder all profiles and audio multiplexing', () {
      // 1. YouTube 16:9 with Audio
      const p16x9 = VideoProfile(aspectRatio: VideoAspectRatio.youtube16x9);
      final cmdAudio = FfmpegCommandBuilder.buildEncodeCommand(
        framesPattern: 'frames/frame_%06d.png',
        outputPath: 'out.mp4',
        profile: p16x9,
        audioPath: 'commentary.mp3',
      );
      expect(cmdAudio, contains('libx264'));
      expect(cmdAudio, contains('aac'));
      expect(cmdAudio, contains('commentary.mp3'));

      // 2. Animated GIF with palettegen filter
      const pGif = VideoProfile(aspectRatio: VideoAspectRatio.animatedGif);
      final cmdGif = FfmpegCommandBuilder.buildEncodeCommand(
        framesPattern: 'frames/frame_%06d.png',
        outputPath: 'out.gif',
        profile: pGif,
      );
      expect(cmdGif.join(' '), contains('palettegen'));
      expect(cmdGif.join(' '), contains('paletteuse'));

      // 3. String representation
      final str = FfmpegCommandBuilder.buildCommandLineString(
        framesPattern: 'frames/%d.png',
        outputPath: 'test.mp4',
        profile: p16x9,
      );
      expect(str, startsWith('ffmpeg '));
      expect(str, contains('libx264'));

      // 4. VideoAspectRatio labels
      for (final ratio in VideoAspectRatio.values) {
        expect(ratio.width, greaterThan(0));
        expect(ratio.height, greaterThan(0));
        expect(ratio.fps, greaterThan(0));
        expect(ratio.label, isNotEmpty);
      }
    });

    test('VideoRenderResult and VideoInspection serialization', () {
      const renderRes = VideoRenderResult(
        outputPath: 'video.mp4',
        frameCount: 120,
        durationSeconds: 4.0,
        fileSizeBytes: 204800,
        thumbnailPath: 'thumb.png',
      );
      final jsonRender = renderRes.toJson();
      expect(jsonRender['outputPath'], 'video.mp4');
      expect(jsonRender['frameCount'], 120);
      expect(jsonRender['durationSeconds'], 4.0);
      expect(jsonRender['fileSizeBytes'], 204800);
      expect(jsonRender['thumbnailPath'], 'thumb.png');

      const inspection = VideoInspection(
        filePath: 'video.mp4',
        codec: 'h264',
        width: 1920,
        height: 1080,
        fps: 30.0,
        durationSeconds: 4.0,
        frameCount: 120,
        bitRate: 400000,
        isPlayable: true,
      );
      final jsonInsp = inspection.toJson();
      expect(jsonInsp['filePath'], 'video.mp4');
      expect(jsonInsp['codec'], 'h264');
      expect(jsonInsp['width'], 1920);
      expect(jsonInsp['height'], 1080);
      expect(jsonInsp['fps'], 30.0);
      expect(jsonInsp['durationSeconds'], 4.0);
      expect(jsonInsp['frameCount'], 120);
      expect(jsonInsp['bitRate'], 400000);
      expect(jsonInsp['isPlayable'], isTrue);
    });

    test('RealVideoRenderer and VideoInspector binary path resolution', () {
      final ffmpeg = RealVideoRenderer.findFfmpegPath();
      if (ffmpeg != null) {
        expect(File(ffmpeg).existsSync(), isTrue);
      }

      final ffprobe = RealVideoRenderer.findFfprobePath();
      if (ffprobe != null) {
        expect(File(ffprobe).existsSync(), isTrue);
      }
    });

    test('FrameRasterizer deep branch testing across layouts, arrows, motion, and eval bar', () {
      // 1. Portrait (Shorts 9:16) with moving piece, arrows, and eval bar
      const portraitProfile = VideoProfile(
        aspectRatio: VideoAspectRatio.shorts9x16,
        showArrows: true,
        showEvaluationBar: true,
      );

      final whiteMotionFrame = VideoFrame(
        frameIndex: 1,
        timestampSeconds: 0.1,
        fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
        movingPiece: const Piece(PieceType.knight, PieceColor.white),
        movingFrom: Square.fromName('g1'),
        movingTo: Square.fromName('f3'),
        interpolationFraction: 0.5,
        evaluationCentipawns: 350,
        highlightedSquares: [Square.fromName('g1')!, Square.fromName('f3')!],
        arrows: const [
          VideoArrow(fromSquare: 'g1', toSquare: 'f3', colorHex: '#22c55e'),
          VideoArrow(fromSquare: 'c7', toSquare: 'c5', colorHex: 'badhex'), // tests hex fallback
        ],
        moveNotation: '1. Nf3',
        subtitleText: 'White develops knight to f3',
      );
      expect(whiteMotionFrame.isPieceInMotion, isTrue);

      final imgPortrait = FrameRasterizer.rasterize(whiteMotionFrame, portraitProfile);
      expect(imgPortrait.width, equals(1080));
      expect(imgPortrait.height, equals(1920));

      // 2. Square (1:1) layout with black piece in motion and negative eval
      const squareProfile = VideoProfile(
        aspectRatio: VideoAspectRatio.social1x1,
        showArrows: true,
        showEvaluationBar: true,
      );

      final blackMotionFrame = VideoFrame(
        frameIndex: 2,
        timestampSeconds: 0.2,
        fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq e6 0 2',
        movingPiece: const Piece(PieceType.queen, PieceColor.black),
        movingFrom: Square.fromName('d8'),
        movingTo: Square.fromName('h4'),
        interpolationFraction: 0.8,
        evaluationCentipawns: -450, // Negative evaluation test
        highlightedSquares: [Square.fromName('d8')!],
        arrows: const [
          VideoArrow(fromSquare: 'd8', toSquare: 'h4', colorHex: '#EF4444'),
        ],
        moveNotation: '1... Qh4',
        subtitleText: null, // Null subtitle test
      );
      expect(blackMotionFrame.isPieceInMotion, isTrue);

      final imgSquare = FrameRasterizer.rasterize(blackMotionFrame, squareProfile);
      expect(imgSquare.width, equals(1080));
      expect(imgSquare.height, equals(1080));

      // 3. Landscape with extreme clamped eval bar and no arrows
      const landscapeNoArrowsProfile = VideoProfile(
        aspectRatio: VideoAspectRatio.youtube16x9,
        showArrows: false,
        showEvaluationBar: true,
      );

      const extremeEvalFrame = VideoFrame(
        frameIndex: 3,
        timestampSeconds: 0.3,
        fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3',
        evaluationCentipawns: 2500, // Clamped > 1000
        moveNotation: '2. Bc4',
        subtitleText: '', // Empty subtitle test
      );

      final imgLandscape = FrameRasterizer.rasterize(extremeEvalFrame, landscapeNoArrowsProfile);
      expect(imgLandscape.width, equals(1920));
      expect(imgLandscape.height, equals(1080));

      // 4. Extreme negative clamped eval
      const extremeNegEvalFrame = VideoFrame(
        frameIndex: 4,
        timestampSeconds: 0.4,
        fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3',
        evaluationCentipawns: -3000, // Clamped < -1000
        moveNotation: '2... Nf6',
      );
      final imgNeg = FrameRasterizer.rasterize(extremeNegEvalFrame, landscapeNoArrowsProfile);
      expect(imgNeg.width, equals(1920));
    });

    test('VideoTimelineGenerator across all content profiles and critical moments', () {
      const pgnLong = '''
[Event "Master Game"]
[Site "Tournament"]
[Date "2024.01.01"]
[White "Player 1"]
[Black "Player 2"]
[Result "1-0"]

1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. c3 Nf6 5. d4 exd4 6. cxd4 Bb4+ 7. Bd2 Bxd2+ 8. Nbxd2 d5 9. exd5 Nxd5 10. Qb3 Nce7 11. O-O O-O 12. Rfe1 c6 13. a4 Rb8 14. Ne4 Bf5 15. Nc5 b6 16. Na6 Rc8 17. Ne5 Qd6 18. Rac1 Be6 19. g3 Rfd8 20. Qf3 Nf6 21. Bxe6 Qxe6 22. Nxc6 Rxc6 23. Rxe6 Rxc1+ 24. Kg2 fxe6 1-0
''';
      final game = PgnParser.parse(pgnLong)!;

      // 1. openingExplorer profile
      const openingGen = VideoTimelineGenerator(
        profile: VideoProfile(contentProfile: VideoContentProfile.openingExplorer),
      );
      final openingFrames = openingGen.generateTimeline(game);
      expect(openingFrames.isNotEmpty, isTrue);

      // 2. tacticsShot and blunderReel with critical plies
      const tacticsGen = VideoTimelineGenerator(
        profile: VideoProfile(contentProfile: VideoContentProfile.tacticsShot),
      );
      final tacticsFrames = tacticsGen.generateTimeline(
        game,
        evaluationsByPly: {20: 150, 21: 450, 22: 900},
        criticalPlies: [21, 22],
      );
      expect(tacticsFrames.isNotEmpty, isTrue);
      expect(tacticsFrames.any((f) => f.subtitleText?.contains('Critical') ?? false), isTrue);

      // 3. blunderReel profile
      const blunderGen = VideoTimelineGenerator(
        profile: VideoProfile(contentProfile: VideoContentProfile.blunderReel),
      );
      final blunderFrames = blunderGen.generateTimeline(
        game,
        criticalPlies: [15],
      );
      expect(blunderFrames.isNotEmpty, isTrue);

      // 4. endgameStudy profile (moves > 20)
      const endgameGen = VideoTimelineGenerator(
        profile: VideoProfile(contentProfile: VideoContentProfile.endgameStudy),
      );
      final endgameFrames = endgameGen.generateTimeline(game);
      expect(endgameFrames.isNotEmpty, isTrue);

      // 5. shortClip profile with critical plies
      const shortClipGen = VideoTimelineGenerator(
        profile: VideoProfile(contentProfile: VideoContentProfile.shortClip),
      );
      final shortClipFrames = shortClipGen.generateTimeline(
        game,
        criticalPlies: [10],
      );
      expect(shortClipFrames.isNotEmpty, isTrue);

      // 6. shortClip profile without critical plies
      final shortClipNoCritFrames = shortClipGen.generateTimeline(game);
      expect(shortClipNoCritFrames.isNotEmpty, isTrue);

      // 7. highlightReel profile
      const highlightGen = VideoTimelineGenerator(
        profile: VideoProfile(contentProfile: VideoContentProfile.highlightReel),
      );
      final highlightFrames = highlightGen.generateTimeline(game);
      expect(highlightFrames.isNotEmpty, isTrue);
    });
  });
}
