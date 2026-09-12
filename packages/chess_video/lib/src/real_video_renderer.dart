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
  /// Resolves the absolute path to a native binary (ffmpeg or ffprobe).
  static String? _findBinary(String binaryName, String envVar) {
    final envPath = Platform.environment[envVar];
    if (envPath != null && File(envPath).existsSync()) return envPath;

    if (Platform.isWindows) {
      final localAppData = Platform.environment['LOCALAPPDATA'];
      if (localAppData != null) {
        try {
          final wingetPackages = Directory('$localAppData\\Microsoft\\WinGet\\Packages');
          if (wingetPackages.existsSync()) {
            final dirs = wingetPackages
                .listSync()
                .whereType<Directory>()
                .where((d) => d.path.toLowerCase().contains('ffmpeg'));
            for (final d in dirs) {
              final candidates = d
                  .listSync(recursive: true)
                  .whereType<File>()
                  .where((f) => f.path.toLowerCase().endsWith('$binaryName.exe'));
              for (final exe in candidates) {
                return exe.path;
              }
            }
          }
        } catch (_) {}
      }

      final standardWindowsPaths = [
        'C:\\ProgramData\\chocolatey\\bin\\$binaryName.exe',
        'C:\\tools\\ffmpeg\\bin\\$binaryName.exe',
        'C:\\Program Files\\ffmpeg\\bin\\$binaryName.exe',
        'C:\\ffmpeg\\bin\\$binaryName.exe',
      ];
      for (final p in standardWindowsPaths) {
        if (File(p).existsSync()) return p;
      }
    }

    try {
      final check = Process.runSync(Platform.isWindows ? 'where.exe' : 'which', [binaryName]);
      if (check.exitCode == 0) {
        final lines = check.stdout.toString().split(RegExp(r'[\r\n]+'));
        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.isNotEmpty && File(trimmed).existsSync()) return trimmed;
        }
      }
    } catch (_) {}

    return null;
  }

  /// Resolves the absolute path to the native FFmpeg executable.
  static String? findFfmpegPath() => _findBinary('ffmpeg', 'FFMPEG_PATH');

  /// Resolves the absolute path to the native FFprobe executable.
  static String? findFfprobePath() => _findBinary('ffprobe', 'FFPROBE_PATH');

  /// Renders a full playable MP4, GIF, or WebM video from a PGN game.
  static Future<VideoRenderResult> renderVideo({
    required PgnGame game,
    required String outputPath,
    VideoProfile profile = const VideoProfile(),
    Map<int, int> evaluationsByPly = const {},
    List<int> criticalPlies = const [],
    String? thumbnailPath,
    String? audioPath,
    void Function(int currentFrame, int totalFrames, double progress, String phase)? onProgress,
    bool Function()? shouldCancel,
  }) async {
    final ffmpegPath = findFfmpegPath();
    if (ffmpegPath == null) {
      throw StateError('FFmpeg binary not found on host system.');
    }

    onProgress?.call(0, 1, 0.02, 'Generating timeline...');

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

    if (shouldCancel?.call() == true) {
      throw StateError('Video rendering cancelled by user.');
    }

    // 2. Create isolated temporary directory for frames
    final tempDir = Directory.systemTemp.createTempSync('chess_video_render_');

    try {
      final framesPattern = '${tempDir.path}${Platform.pathSeparator}frame_%06d.png';

      // 3. Rasterize each frame
      for (int i = 0; i < timeline.length; i++) {
        if (shouldCancel?.call() == true) {
          throw StateError('Video rendering cancelled by user.');
        }

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

        final progress = (i + 1) / (timeline.length * 1.15);
        onProgress?.call(i + 1, timeline.length, progress, 'Rasterizing frame ${i + 1} of ${timeline.length}');
      }

      if (shouldCancel?.call() == true) {
        throw StateError('Video rendering cancelled by user.');
      }

      onProgress?.call(timeline.length, timeline.length, 0.90, 'Encoding with FFmpeg...');

      // 4. Ensure output parent directory exists
      final outFile = File(outputPath);
      outFile.parent.createSync(recursive: true);

      // 5. Build FFmpeg arguments and execute
      final ffmpegArgs = FfmpegCommandBuilder.buildEncodeCommand(
        framesPattern: framesPattern,
        outputPath: outputPath,
        profile: profile,
        audioPath: audioPath,
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
