import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'package:image/image.dart' as img;
import 'ffmpeg_command_builder.dart';
import 'frame_rasterizer.dart';
import 'models/video_profile.dart';
import 'video_timeline_generator.dart';

/// Result produced by rendering a chess game video.
class VideoRenderResult {
  final String outputPath;
  final int frameCount;
  final double durationSeconds;
  final int fileSizeBytes;
  final String? thumbnailPath;

  const VideoRenderResult({
    required this.outputPath,
    required this.frameCount,
    required this.durationSeconds,
    required this.fileSizeBytes,
    this.thumbnailPath,
  });

  Map<String, dynamic> toJson() => {
        'outputPath': outputPath,
        'frameCount': frameCount,
        'durationSeconds': durationSeconds,
        'fileSizeBytes': fileSizeBytes,
        'thumbnailPath': thumbnailPath,
      };
}

/// Production video rendering engine that renders real MP4 / GIF / WebM using native FFmpeg.
class RealVideoRenderer {
  /// Resolves the absolute path to the native FFmpeg executable.
  static String? findFfmpegPath() {
    final envPath = Platform.environment['FFMPEG_PATH'];
    if (envPath != null && File(envPath).existsSync()) return envPath;

    if (Platform.isWindows) {
      const wingetCandidate = r'C:\Users\dayan\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-9.0.1-full_build\bin\ffmpeg.exe';
      if (File(wingetCandidate).existsSync()) return wingetCandidate;
    }

    try {
      final check = Process.runSync(Platform.isWindows ? 'where.exe' : 'which', ['ffmpeg']);
      if (check.exitCode == 0) {
        final firstLine = check.stdout.toString().split('\r\n').first.trim();
        if (File(firstLine).existsSync()) return firstLine;
      }
    } catch (_) {}

    return null;
  }

  /// Resolves the absolute path to the native FFprobe executable.
  static String? findFfprobePath() {
    final envPath = Platform.environment['FFPROBE_PATH'];
    if (envPath != null && File(envPath).existsSync()) return envPath;

    if (Platform.isWindows) {
      const wingetCandidate = r'C:\Users\dayan\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-9.0.1-full_build\bin\ffprobe.exe';
      if (File(wingetCandidate).existsSync()) return wingetCandidate;
    }

    try {
      final check = Process.runSync(Platform.isWindows ? 'where.exe' : 'which', ['ffprobe']);
      if (check.exitCode == 0) {
        final firstLine = check.stdout.toString().split('\r\n').first.trim();
        if (File(firstLine).existsSync()) return firstLine;
      }
    } catch (_) {}

    return null;
  }

  /// Renders a full playable MP4, GIF, or WebM video from a PGN game.
  static Future<VideoRenderResult> renderVideo({
    required PgnGame game,
    required String outputPath,
    VideoProfile profile = const VideoProfile(),
    Map<int, int> evaluationsByPly = const {},
    List<int> criticalPlies = const [],
    String? thumbnailPath,
  }) async {
    final ffmpegPath = findFfmpegPath();
    if (ffmpegPath == null) {
      throw StateError('FFmpeg binary not found on host system.');
    }

    // 1. Generate frame timeline
    final generator = VideoTimelineGenerator(profile: profile);
    final timeline = generator.generateTimeline(
      game,
      evaluationsByPly: evaluationsByPly,
      criticalPlies: criticalPlies,
    );

    if (timeline.isEmpty) {
      throw StateError('Timeline generator produced zero frames for game.');
    }

    // 2. Create isolated temporary directory for frames
    final tempDir = Directory.systemTemp.createTempSync('chess_video_render_');

    try {
      final framesPattern = '${tempDir.path}${Platform.pathSeparator}frame_%06d.png';

      // 3. Rasterize each frame
      for (int i = 0; i < timeline.length; i++) {
        final frame = timeline[i];
        final image = FrameRasterizer.rasterize(frame, profile);
        final frameFile = File('${tempDir.path}${Platform.pathSeparator}frame_${i.toString().padLeft(6, '0')}.png');
        final pngBytes = img.encodePng(image);
        await frameFile.writeAsBytes(pngBytes, flush: true);

        // Save thumbnail if requested
        if (i == 0 && thumbnailPath != null) {
          final thumbFile = File(thumbnailPath);
          thumbFile.parent.createSync(recursive: true);
          await thumbFile.writeAsBytes(pngBytes, flush: true);
        }
      }

      // 4. Ensure output parent directory exists
      final outFile = File(outputPath);
      outFile.parent.createSync(recursive: true);

      // 5. Build FFmpeg arguments and execute
      final ffmpegArgs = FfmpegCommandBuilder.buildEncodeCommand(
        framesPattern: framesPattern,
        outputPath: outputPath,
        profile: profile,
      );

      final result = await Process.run(ffmpegPath, ffmpegArgs);
      if (result.exitCode != 0) {
        throw ProcessException(
          ffmpegPath,
          ffmpegArgs,
          'FFmpeg encoding failed with exit code ${result.exitCode}:\n${result.stderr}',
          result.exitCode,
        );
      }

      if (!outFile.existsSync() || outFile.lengthSync() == 0) {
        throw StateError('FFmpeg reported success but output video file is missing or empty.');
      }

      return VideoRenderResult(
        outputPath: outputPath,
        frameCount: timeline.length,
        durationSeconds: timeline.length / profile.fps,
        fileSizeBytes: outFile.lengthSync(),
        thumbnailPath: thumbnailPath,
      );
    } finally {
      // Clean up temporary frames
      try {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    }
  }
}
