import 'dart:io';
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
  });
}
