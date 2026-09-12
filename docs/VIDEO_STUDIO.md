# Chess Video Studio — Architecture & Export Workflow

## 1. Overview
Chess Video Studio transforms played games, master model games, and custom PGNs into broadcast-quality chess video lessons. The pipeline is 100% deterministic and produces verified MP4 videos with synchronized move animations, educational subtitles, evaluation bars, and optional audio narration.

---

## 2. End-to-End Game-to-Video Workflow
The complete user workflow is structured across 8 verifiable milestones:

```
[GAME SOURCE] ➔ [VALIDATE] ➔ [EDIT / PREVIEW] ➔ [CONFIGURE] ➔ [GENERATE] ➔ [PROGRESS] ➔ [VERIFY] ➔ [PLAY / OPEN]
```

### 2.1 Game Source Selection
Users can select a game from 4 integrated sources via `GameSourceSelectorDialog`:
1. **My Played Games**: Load games from local SQLite/storage records.
2. **Model Games**: 60 bundled grandmaster games with ECO classifications.
3. **Paste PGN**: Paste raw PGN text with real-time parser validation and move legality checks.
4. **Import PGN File**: Native file picker for `.pgn` files.

### 2.2 Desktop 3-Pane Responsive Layout
- **Left Pane (Configuration)**: Aspect ratio (16:9, 9:16, 1:1), Resolution (720p, 1080p, 4K), FPS (30/60), animation speed, overlays (evaluation bar, coordinates, educational subtitles, arrows).
- **Center Pane (Preview Canvas)**: Maximized responsive board preview with transport controls (first, prev, play/pause, next, last), scrubber slider, and timecode.
- **Right Pane (Moves & Timeline)**: Interactive move list, eval graph, annotations, and critical moment markers.
- **Primary CTA**: Prominent `Export Video` button.

---

## 3. Real Video Generation Pipeline (`RealVideoRenderer`)
The renderer executes in `packages/chess_video/lib/src/real_video_renderer.dart`:

1. **Timeline Construction**: `VideoTimelineGenerator` generates discrete video frames (interpolating plies, critical moment pauses, and transitions).
2. **Frame Rasterization**: Frames are rasterized in-memory into PNG/RGB pixel buffers using `FrameRasterizer`.
3. **FFmpeg Encoding**: Frames are piped or written to temp storage and encoded via native `ffmpeg`:
   `ffmpeg -y -framerate $fps -i frame_%05d.png -c:v libx264 -pix_fmt yuv420p output.mp4`
4. **Audio Muxing**: If narration or audio background is selected, AAC audio is muxed into the MP4 container:
   `-i audio.aac -c:a aac -shortest`
5. **Output Verification**: `VideoInspector` invokes native `ffprobe` to verify duration, resolution, frame rate, container format, and audio stream existence.
6. **Atomic Publishing**: Moves output from staging to user's destination folder.

---

## 4. Acceptance Test Evidence
Verified in `packages/chess_video/test/real_video_generation_e2e_test.dart` with 100% pass rate:
- **Test A**: Model Game MP4 generation (1920x1080, 30fps).
- **Test B**: Played Game MP4 generation with AAC audio muxing.
- **Test C**: Pasted PGN generation.
- **Test D**: Imported PGN file generation.
- **Negative Tests**: Corrupted PGN rejection, user cancellation cleanup, missing FFmpeg binary handling.
