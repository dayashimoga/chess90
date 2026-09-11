/// Video export format profiles.
enum VideoAspectRatio {
  youtube16x9(1920, 1080, 60, '16:9 YouTube / Desktop Landscape'),
  shorts9x16(1080, 1920, 60, '9:16 Shorts / Reels / TikTok Portrait'),
  social1x1(1080, 1080, 30, '1:1 Instagram / Social Square'),
  animatedGif(600, 600, 15, 'Optimized Animated GIF');

  final int width;
  final int height;
  final int fps;
  final String label;

  const VideoAspectRatio(this.width, this.height, this.fps, this.label);
}

/// Thematic content focus profiles for video generation.
enum VideoContentProfile {
  fullGame('Full Game Presentation'),
  highlightReel('Critical Moments & Highlights'),
  tacticsShot('Tactical Shot / Puzzle Walkthrough'),
  blunderReel('Blunder & Mistake Breakdown'),
  openingExplorer('Opening Preparation & Theory'),
  endgameStudy('Theoretical Endgame Technique'),
  shortClip('Bite-Sized Quick Clip');

  final String title;
  const VideoContentProfile(this.title);
}

/// Arrow overlay model on a video frame.
class VideoArrow {
  final String fromSquare;
  final String toSquare;
  final String colorHex; // e.g. '#22C55E' for best move, '#EF4444' for blunder

  const VideoArrow({
    required this.fromSquare,
    required this.toSquare,
    required this.colorHex,
  });
}

/// Complete configuration profile for video generation.
class VideoProfile {
  final VideoAspectRatio aspectRatio;
  final VideoContentProfile contentProfile;
  final bool showEvaluationBar;
  final bool showMoveList;
  final bool showPlayerCards;
  final bool showSubtitles;
  final bool showArrows;
  final double moveSpeedSeconds;
  final double criticalMomentPauseSeconds;
  final int? customWidth;
  final int? customHeight;
  final int? customFps;

  const VideoProfile({
    this.aspectRatio = VideoAspectRatio.youtube16x9,
    this.contentProfile = VideoContentProfile.fullGame,
    this.showEvaluationBar = true,
    this.showMoveList = true,
    this.showPlayerCards = true,
    this.showSubtitles = true,
    this.showArrows = true,
    this.moveSpeedSeconds = 0.35,
    this.criticalMomentPauseSeconds = 2.0,
    this.customWidth,
    this.customHeight,
    this.customFps,
  });

  int get width => customWidth ?? aspectRatio.width;
  int get height => customHeight ?? aspectRatio.height;
  int get fps => customFps ?? aspectRatio.fps;
}
