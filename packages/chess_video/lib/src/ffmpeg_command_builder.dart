import 'models/video_profile.dart';

/// Builder that generates deterministic FFmpeg command lines for video generation.
class FfmpegCommandBuilder {
  /// Builds FFmpeg command line arguments to encode rendered frame images into video.
  static List<String> buildEncodeCommand({
    required String framesPattern, // e.g. 'frames/frame_%06d.png'
    required String outputPath,    // e.g. 'output/game.mp4'
    required VideoProfile profile,
    String? audioPath,
    String? hardwareEncoder,       // e.g. 'h264_nvenc', 'h264_qsv', 'h264_amf', 'libx264'
    double audioVolume = 1.0,
    bool loopAudio = false,
  }) {
    final args = <String>[
      '-y', // Overwrite output
      '-r', '${profile.fps}',
      '-f', 'image2',
      '-i', framesPattern,
    ];

    if (audioPath != null) {
      if (loopAudio) {
        args.addAll(['-stream_loop', '-1']);
      }
      args.addAll(['-i', audioPath]);
    }

    if (profile.aspectRatio == VideoAspectRatio.animatedGif || outputPath.toLowerCase().endsWith('.gif')) {
      // Optimized palette generation for GIF
      args.addAll([
        '-vf', 'fps=${profile.fps},scale=${profile.width}:${profile.height}:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse',
        outputPath,
      ]);
      return args;
    }

    final isWebm = outputPath.toLowerCase().endsWith('.webm');
    if (isWebm) {
      args.addAll([
        '-c:v', 'libvpx-vp9',
        '-b:v', '0',
        '-crf', '30',
        '-pix_fmt', 'yuv420p',
      ]);
    } else {
      // MP4 H.264 video encoding (Hardware acceleration with software fallback)
      final encoder = hardwareEncoder ?? 'libx264';
      args.addAll([
        '-c:v', encoder,
        '-pix_fmt', 'yuv420p',
      ]);
      if (encoder == 'libx264') {
        args.addAll(['-preset', 'fast', '-crf', '18']);
      } else if (encoder == 'h264_nvenc') {
        args.addAll(['-preset', 'p4', '-cq', '19']);
      } else if (encoder == 'h264_qsv') {
        args.addAll(['-preset', 'fast', '-global_quality', '20']);
      } else if (encoder == 'h264_amf') {
        args.addAll(['-quality', 'balanced']);
      }
      args.addAll(['-movflags', '+faststart']);
    }

    if (audioPath != null) {
      final audioCodec = isWebm ? 'libopus' : 'aac';
      args.addAll(['-c:a', audioCodec, '-b:a', '192k']);
      if ((audioVolume - 1.0).abs() > 0.01) {
        args.addAll(['-filter:a', 'volume=${audioVolume.toStringAsFixed(2)}']);
      }
      args.add('-shortest');
    }

    args.add(outputPath);
    return args;
  }

  /// Builds a string representation of the FFmpeg command line.
  static String buildCommandLineString({
    required String framesPattern,
    required String outputPath,
    required VideoProfile profile,
    String? audioPath,
    String? hardwareEncoder,
    double audioVolume = 1.0,
    bool loopAudio = false,
  }) {
    final args = buildEncodeCommand(
      framesPattern: framesPattern,
      outputPath: outputPath,
      profile: profile,
      audioPath: audioPath,
      hardwareEncoder: hardwareEncoder,
      audioVolume: audioVolume,
      loopAudio: loopAudio,
    );
    return 'ffmpeg ${args.map((a) => a.contains(' ') ? '"$a"' : a).join(' ')}';
  }
}
