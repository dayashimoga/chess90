import 'package:chess_core/chess_core.dart';
import 'package:chess_video/chess_video.dart';
import 'package:test/test.dart';

void main() {
  group('Video Timeline & Generator Tests', () {
    test('Timeline generates interpolated frames for game', () {
      const pgnStr = '''
[Event "Test Match"]
[White "White"]
[Black "Black"]
[Result "1-0"]

1. e4 e5 2. Bc4 Nc6 1-0
''';
      final game = PgnParser.parse(pgnStr)!;
      const generator = VideoTimelineGenerator(
        profile: VideoProfile(
          aspectRatio: VideoAspectRatio.youtube16x9,
          moveSpeedSeconds: 0.2, // fast for test
        ),
      );

      final timeline = generator.generateTimeline(game);
      expect(timeline.isNotEmpty, isTrue);

      // Verify that there are frames with piece in motion
      final motionFrames = timeline.where((f) => f.isPieceInMotion).toList();
      expect(motionFrames.isNotEmpty, isTrue);
      expect(motionFrames.first.interpolationFraction, inExclusiveRange(0.0, 1.0));

      // Verify final frame
      expect(timeline.last.moveNotation, contains('1-0'));
    });

    test('FFmpeg command builder generates valid arguments', () {
      final mp4Cmd = FfmpegCommandBuilder.buildEncodeCommand(
        framesPattern: 'frames/%06d.png',
        outputPath: 'out.mp4',
        profile: const VideoProfile(aspectRatio: VideoAspectRatio.youtube16x9),
      );

      expect(mp4Cmd, contains('-c:v'));
      expect(mp4Cmd, contains('libx264'));
      expect(mp4Cmd, contains('out.mp4'));

      final gifCmd = FfmpegCommandBuilder.buildEncodeCommand(
        framesPattern: 'frames/%06d.png',
        outputPath: 'out.gif',
        profile: const VideoProfile(aspectRatio: VideoAspectRatio.animatedGif),
      );

      expect(gifCmd.any((a) => a.contains('palettegen')), isTrue);
      expect(gifCmd, contains('out.gif'));
    });
  });
}
