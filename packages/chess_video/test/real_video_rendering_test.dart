import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'package:chess_video/chess_video.dart';
import 'package:test/test.dart';

void main() {
  group('Real FFmpeg Video Rendering & Inspection Tests', () {
    const samplePgn = '''
[Event "Immortal Miniature"]
[Site "London"]
[Date "1851.??.??"]
[White "Adolf Anderssen"]
[Black "Lionel Kieseritzky"]
[Result "1-0"]

1. e4 e5 2. f4 exf4 3. Bc4 Qh4+ 4. Kf1 1-0
''';

    late PgnGame game;
    late Directory tempOutputDir;

    setUpAll(() {
      game = PgnParser.parse(samplePgn)!;
      tempOutputDir = Directory.systemTemp.createTempSync('chess_video_test_out_');
    });

    tearDownAll(() {
      try {
        if (tempOutputDir.existsSync()) {
          tempOutputDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    });

    test('FrameRasterizer generates valid high-resolution image bytes', () {
      const profile = VideoProfile(aspectRatio: VideoAspectRatio.youtube16x9);
      const frame = VideoFrame(
        frameIndex: 0,
        timestampSeconds: 0.0,
        fen: 'r1bqk2r/pppp1ppp/2n5/4p3/1bB1n3/2N2Q2/PPPP1PPP/R1B1K1NR w KQkq - 0 6',
        moveNotation: '6. Qxf7#',
        subtitleText: 'Anderssen vs Kieseritzky',
        arrows: [
          VideoArrow(fromSquare: 'f3', toSquare: 'f7', colorHex: '#22C55E'),
        ],
        evaluationCentipawns: 9999,
      );

      final img = FrameRasterizer.rasterize(frame, profile);
      expect(img.width, equals(1920));
      expect(img.height, equals(1080));
    });

    final ffmpegPath = RealVideoRenderer.findFfmpegPath();
    final ffprobePath = RealVideoRenderer.findFfprobePath();
    final hasBinaries = ffmpegPath != null && ffprobePath != null;

    test('Native FFmpeg and FFprobe binaries discovery or graceful fallback', () {
      if (hasBinaries) {
        expect(File(ffmpegPath).existsSync(), isTrue);
        expect(File(ffprobePath).existsSync(), isTrue);
      } else {
        expect(
          () => RealVideoRenderer.renderVideo(
            game: game,
            outputPath: '${tempOutputDir.path}${Platform.pathSeparator}unsupported.mp4',
          ),
          throwsStateError,
        );
      }
    });

    test('Render real MP4 video with H.264, thumbnail, and inspect with FFprobe', () async {
      if (!hasBinaries) {
        expect(
          () => RealVideoRenderer.renderVideo(
            game: game,
            outputPath: '${tempOutputDir.path}${Platform.pathSeparator}unsupported.mp4',
          ),
          throwsStateError,
        );
        return;
      }

      final mp4Path = '${tempOutputDir.path}${Platform.pathSeparator}test_miniature.mp4';
      final thumbPath = '${tempOutputDir.path}${Platform.pathSeparator}test_miniature_thumb.png';

      const profile = VideoProfile(
        aspectRatio: VideoAspectRatio.youtube16x9,
        customWidth: 960,
        customHeight: 540,
        customFps: 20,
        moveSpeedSeconds: 0.1,
        criticalMomentPauseSeconds: 0.2,
      );

      final renderResult = await RealVideoRenderer.renderVideo(
        game: game,
        outputPath: mp4Path,
        thumbnailPath: thumbPath,
        profile: profile,
      );

      expect(renderResult.frameCount, greaterThan(5));
      expect(renderResult.durationSeconds, greaterThan(0.2));
      expect(File(mp4Path).existsSync(), isTrue);
      expect(File(mp4Path).lengthSync(), greaterThan(1000));
      expect(File(thumbPath).existsSync(), isTrue);
      expect(File(thumbPath).lengthSync(), greaterThan(1000));

      // Forensic inspection via FFprobe
      final inspection = await VideoInspector.inspect(mp4Path);
      expect(inspection.codec.toLowerCase(), equals('h264'));
      expect(inspection.width, equals(960));
      expect(inspection.height, equals(540));
      expect(inspection.durationSeconds, greaterThan(0.2));
      expect(inspection.isPlayable, isTrue, reason: 'Null-mux decoding check must pass without errors');
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('Render palette-optimized animated GIF and inspect', () async {
      if (!hasBinaries) {
        expect(
          () => VideoInspector.inspect('${tempOutputDir.path}${Platform.pathSeparator}dummy.gif'),
          throwsStateError,
        );
        return;
      }

      final gifPath = '${tempOutputDir.path}${Platform.pathSeparator}test_animation.gif';

      const profile = VideoProfile(
        aspectRatio: VideoAspectRatio.animatedGif,
        customFps: 10,
        moveSpeedSeconds: 0.1,
        criticalMomentPauseSeconds: 0.2,
      );

      final renderResult = await RealVideoRenderer.renderVideo(
        game: game,
        outputPath: gifPath,
        profile: profile,
      );

      expect(renderResult.frameCount, greaterThan(5));
      expect(File(gifPath).existsSync(), isTrue);
      expect(File(gifPath).lengthSync(), greaterThan(1000));

      // Forensic inspection
      final inspection = await VideoInspector.inspect(gifPath);
      expect(inspection.codec.toLowerCase(), equals('gif'));
      expect(inspection.width, equals(600));
      expect(inspection.height, equals(600));
      expect(inspection.isPlayable, isTrue);
    }, timeout: const Timeout(Duration(minutes: 2)));
  });
}
