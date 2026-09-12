import 'dart:convert';
import 'dart:io';
import 'real_video_renderer.dart';

/// Inspection report of a rendered video artifact.
class VideoInspection {
  final String filePath;
  final String codec;
  final int width;
  final int height;
  final double fps;
  final double durationSeconds;
  final int frameCount;
  final int bitRate;
  final bool isPlayable;
  final bool hasAudio;
  final String? audioCodec;

  const VideoInspection({
    required this.filePath,
    required this.codec,
    required this.width,
    required this.height,
    required this.fps,
    required this.durationSeconds,
    required this.frameCount,
    required this.bitRate,
    required this.isPlayable,
    this.hasAudio = false,
    this.audioCodec,
  });

  Map<String, dynamic> toJson() => {
        'filePath': filePath,
        'codec': codec,
        'width': width,
        'height': height,
        'fps': fps,
        'durationSeconds': durationSeconds,
        'frameCount': frameCount,
        'bitRate': bitRate,
        'isPlayable': isPlayable,
        'hasAudio': hasAudio,
        'audioCodec': audioCodec,
      };
}

/// Forensic video inspector using FFprobe and FFmpeg null-mux decoding.
class VideoInspector {
  /// Extracts a single frame at [timestampSeconds] to [outputPath] and verifies it.
  static Future<bool> extractFrame({
    required String videoPath,
    required double timestampSeconds,
    required String outputPath,
  }) async {
    final ffmpegPath = RealVideoRenderer.findFfmpegPath();
    if (ffmpegPath == null) return false;

    final outFile = File(outputPath);
    outFile.parent.createSync(recursive: true);

    final result = await Process.run(ffmpegPath, [
      '-y',
      '-ss',
      timestampSeconds.toStringAsFixed(2),
      '-i',
      videoPath,
      '-vframes',
      '1',
      '-q:v',
      '2',
      outputPath,
    ]);
    return result.exitCode == 0 && outFile.existsSync() && outFile.lengthSync() > 0;
  }

  /// Inspects a video file and verifies its encoding, streams, and decode integrity.
  static Future<VideoInspection> inspect(String filePath) async {
    final ffprobePath = RealVideoRenderer.findFfprobePath();
    final ffmpegPath = RealVideoRenderer.findFfmpegPath();

    if (ffprobePath == null) {
      throw StateError('FFprobe binary not found on host system.');
    }

    final probeArgs = [
      '-v', 'quiet',
      '-print_format', 'json',
      '-show_format',
      '-show_streams',
      filePath,
    ];

    final probeResult = await Process.run(ffprobePath, probeArgs);
    if (probeResult.exitCode != 0) {
      throw ProcessException(
        ffprobePath,
        probeArgs,
        'FFprobe failed with code ${probeResult.exitCode}: ${probeResult.stderr}',
        probeResult.exitCode,
      );
    }

    final jsonMap = jsonDecode(probeResult.stdout as String) as Map<String, dynamic>;
    final streams = (jsonMap['streams'] as List<dynamic>?) ?? [];
    final videoStream = streams.firstWhere(
      (s) => s['codec_type'] == 'video',
      orElse: () => streams.isNotEmpty ? streams.first : <String, dynamic>{},
    ) as Map<String, dynamic>;

    final audioStream = streams.firstWhere(
      (s) => s['codec_type'] == 'audio',
      orElse: () => null,
    ) as Map<String, dynamic>?;

    final format = (jsonMap['format'] as Map<String, dynamic>?) ?? {};

    final codec = (videoStream['codec_name'] as String?) ?? 'unknown';
    final width = (videoStream['width'] as int?) ?? 0;
    final height = (videoStream['height'] as int?) ?? 0;

    // Parse FPS from r_frame_rate (e.g. "30/1" or "60/1")
    double fps = 30.0;
    final fpsStr = videoStream['r_frame_rate'] as String?;
    if (fpsStr != null && fpsStr.contains('/')) {
      final parts = fpsStr.split('/');
      final num = double.tryParse(parts[0]) ?? 30.0;
      final den = double.tryParse(parts[1]) ?? 1.0;
      if (den > 0) fps = num / den;
    }

    final durationStr = (videoStream['duration'] ?? format['duration']) as String?;
    final duration = double.tryParse(durationStr ?? '0') ?? 0.0;

    final framesStr = videoStream['nb_frames'] as String?;
    final frameCount = int.tryParse(framesStr ?? '0') ?? (duration * fps).round();

    final bitRateStr = (videoStream['bit_rate'] ?? format['bit_rate']) as String?;
    final bitRate = int.tryParse(bitRateStr ?? '0') ?? 0;

    // Verify playback / decoding
    bool playable = false;
    if (ffmpegPath != null) {
      final decodeCheck = await Process.run(ffmpegPath, [
        '-v', 'error',
        '-i', filePath,
        '-f', 'null',
        '-',
      ]);
      playable = (decodeCheck.exitCode == 0);
    }

    return VideoInspection(
      filePath: filePath,
      codec: codec,
      width: width,
      height: height,
      fps: fps,
      durationSeconds: duration,
      frameCount: frameCount,
      bitRate: bitRate,
      isPlayable: playable,
      hasAudio: audioStream != null,
      audioCodec: audioStream?['codec_name'] as String?,
    );
  }
}
