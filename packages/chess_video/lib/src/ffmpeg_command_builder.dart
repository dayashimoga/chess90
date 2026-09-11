import 'models/video_profile.dart';

/// Builder that generates deterministic FFmpeg command lines for video generation.
class FfmpegCommandBuilder {
  /// Builds FFmpeg command line arguments to encode rendered frame images into video.
  static List<String> buildEncodeCommand({
    required String framesPattern, // e.g. 'frames/frame_%06d.png'
    required String outputPath,    // e.g. 'output/game.mp4'
    required VideoProfile profile,
    String? audioPath,
  }) {
    final args = <String>[
      '-y', // Overwrite output
      '-r', '${profile.fps}',
      '-f', 'image2',
      '-i', framesPattern,
    ];

    if (audioPath != null) {
      args.addAll(['-i', audioPath]);
    }

    if (profile.aspectRatio == VideoAspectRatio.animatedGif) {
      // Optimized palette generation for GIF
      args.addAll([
        '-vf', 'fps=${profile.fps},scale=${profile.width}:${profile.height}:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse',
        outputPath,
      ]);
      return args;
    }

    // MP4 H.264 video encoding
    args.addAll([
      '-c:v', 'libx264',
      '-pix_fmt', 'yuv420p',
      '-preset', 'fast',
      '-crf', '18', // visually lossless
      '-movflags', '+faststart',
    ]);

    if (audioPath != null) {
      args.addAll(['-c:a', 'aac', '-b:a', '192k', '-shortest']);
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
  }) {
    final args = buildEncodeCommand(
      framesPattern: framesPattern,
      outputPath: outputPath,
      profile: profile,
      audioPath: audioPath,
    );
    return 'ffmpeg ${args.map((a) => a.contains(' ') ? '"$a"' : a).join(' ')}';
  }
}
