# Video Generation Pipeline

## 1. Overview
The ChessMaster video creation pipeline converts standard PGN games and lab sessions into high-definition, animated, annotated chess videos deterministically.

Pipeline architecture:
$$\text{PGN} \xrightarrow{\text{parse}} \text{Board States} \xrightarrow{\text{Stockfish}} \text{Annotations} \xrightarrow{\text{Render Canvas}} \text{Overlays} \xrightarrow{\text{Captions/TTS}} \text{FFmpeg} \xrightarrow{} \text{MP4 / WebM / GIF}$$

## 2. Video Profiles & Aspect Ratios

| Profile Name | Aspect Ratio | Dimensions | Frame Rate | Intended Distribution |
| :--- | :--- | :--- | :--- | :--- |
| **YouTube 16:9** | 16:9 | 1920 $\times$ 1080 | 30 / 60 FPS | YouTube long-form, desktop masterclasses, deep-dive analyses |
| **Shorts / Reels 9:16**| 9:16 | 1080 $\times$ 1920 | 30 / 60 FPS | YouTube Shorts, Instagram Reels, TikTok, mobile feeds |
| **Social Square 1:1** | 1:1 | 1080 $\times$ 1080 | 30 FPS | Twitter / X, Instagram feed, Discord embeds |
| **Animated GIF** | 1:1 / 16:9 | 480 $\times$ 480 / 720p | 15 / 20 FPS | Web documentation, forum posts, instant previews |

## 3. Timeline & Frame Generation Architecture

The `VideoTimelineGenerator` (`packages/chess_video/lib/src/timeline_generator.dart`) decomposes a chess game into discrete, sequentially indexed video frames:

```dart
class VideoFrameData {
  final int frameIndex;
  final double timestampSeconds;
  final String fen;
  final Move? movingPiece;
  final double moveProgress; // 0.0 to 1.0 smooth interpolation
  final double evalScore;
  final List<String> arrows;
  final String? subtitleText;
  final String? moveSan;
  final bool isCriticalPause;
}
```

### 3.1 Smooth Move Interpolation
Each move transition spans an animation window $T_{\text{move}}$ (default 300 ms). During this window, the moving piece's coordinate is linearly or easing-interpolated from origin square $(x_1, y_1)$ to target square $(x_2, y_2)$ using:
$$\vec{p}(t) = \vec{p}_1 + (\vec{p}_2 - \vec{p}_1) \cdot \operatorname{smoothstep}(t / T_{\text{move}})$$
where $\operatorname{smoothstep}(u) = 3u^2 - 2u^3$.

### 3.2 Critical Moments & Adaptive Pauses
When the engine flags a turning point or blunder (centipawn delta $\Delta cp > 150$), the timeline generator injects a **Critical Pause** (duration 1.5 to 3.0 seconds):
- Board highlights the critical square in gold/red.
- Subtitle card displays the tactical question: *"What should White play here?"* or *"Critical turning point: Black misses 24... Rxe4!"*.
- Evaluation bar pulses to emphasize the evaluation swing.

### 3.3 Dynamic Visual Overlays
- **Evaluation Bar**: Renders smoothly alongside the board, mapping centipawns into visual height via $h = \frac{1}{1 + e^{-0.004 \cdot cp}}$.
- **Tactical Arrows**: Visual vectors indicating threats (red), best moves (emerald green), or blunders (crimson).
- **Player & Clock Badges**: Displays player names, ratings, active turn indicator, and decremented clock values.

## 4. Deterministic FFmpeg Synthesis

The `FfmpegCommandBuilder` creates reproducible command lines without non-deterministic host dependencies.

### 4.1 H.264 MP4 Generation
```bash
ffmpeg -y -framerate 30 -i input_frames/frame_%05d.png \
  -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p \
  -movflags +faststart output.mp4
```

### 4.2 High-Quality Palette-Generated GIF
To eliminate banding and artifacting in GIF exports, a two-pass palette generator is used:
```bash
ffmpeg -y -i input_frames/frame_%05d.png \
  -vf "fps=15,scale=480:-1:flags=lanczos,palettegen" palette.png

ffmpeg -y -i input_frames/frame_%05d.png -i palette.png \
  -lavfi "fps=15,scale=480:-1:flags=lanczos [x]; [x][1:v] paletteuse" \
  output.gif
```

## 5. Automated Studio UI
In the Flutter desktop and web app (`apps/chess_app/lib/src/screens/video_studio_screen.dart`), users can:
1. Select any game from their profile or model game database.
2. Choose target profile (16:9, 9:16, 1:1, GIF).
3. Scrub through the generated timeline frame-by-frame with interactive preview.
4. Export the deterministic video script or copy the native FFmpeg CLI command with one click.
