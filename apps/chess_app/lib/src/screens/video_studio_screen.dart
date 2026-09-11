import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_video/chess_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/chess_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/evaluation_bar_widget.dart';

/// Chess video creation studio supporting 16:9, 9:16 Shorts, 1:1 Social, and animated GIF.
class VideoStudioScreen extends StatefulWidget {
  final dynamic initialArgs;

  const VideoStudioScreen({super.key, this.initialArgs});

  @override
  State<VideoStudioScreen> createState() => _VideoStudioScreenState();
}

class _VideoStudioScreenState extends State<VideoStudioScreen> {
  late PgnGame _game;
  VideoAspectRatio _aspectRatio = VideoAspectRatio.youtube16x9;
  double _moveSpeed = 0.35;
  double _criticalPause = 2.0;
  bool _showEvalBar = true;
  bool _showArrows = true;
  bool _showSubtitles = true;

  List<VideoFrame> _generatedTimeline = [];
  int _currentFrameIndex = 0;
  String _generatedCommand = '';

  @override
  void initState() {
    super.initState();
    String pgn = ModelGamesDatabase.curatedGames.first.pgn;
    if (widget.initialArgs is Map && widget.initialArgs['pgn'] != null) {
      pgn = widget.initialArgs['pgn'] as String;
    }
    _game = PgnParser.parse(pgn) ?? PgnParser.parse(ModelGamesDatabase.curatedGames.first.pgn)!;
    _generateTimeline();
  }

  void _generateTimeline() {
    final profile = VideoProfile(
      aspectRatio: _aspectRatio,
      moveSpeedSeconds: _moveSpeed,
      criticalMomentPauseSeconds: _criticalPause,
      showEvaluationBar: _showEvalBar,
      showArrows: _showArrows,
      showSubtitles: _showSubtitles,
    );

    final generator = VideoTimelineGenerator(profile: profile);
    _generatedTimeline = generator.generateTimeline(_game);

    _generatedCommand = FfmpegCommandBuilder.buildCommandLineString(
      framesPattern: 'frames/frame_%06d.png',
      outputPath: 'output/chess_master_${_aspectRatio.name}.mp4',
      profile: profile,
    );

    setState(() {
      _currentFrameIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFrame = _generatedTimeline.isNotEmpty ? _generatedTimeline[_currentFrameIndex] : null;
    final board = currentFrame != null ? Board.fromFen(currentFrame.fen) : Board.initial();

    return Scaffold(
      backgroundColor: ChessTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            // Left: Profile Settings & FFmpeg Controls
            SizedBox(
              width: 360,
              child: Material(
                color: ChessTheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: ChessTheme.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.movie_creation, color: ChessTheme.primaryLight, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Video Studio Config',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ChessTheme.textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Format selector
                      const Text('Export Aspect Ratio & Profile', style: TextStyle(fontSize: 12, color: ChessTheme.textSecondary)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<VideoAspectRatio>(
                        initialValue: _aspectRatio,
                        isExpanded: true,
                        dropdownColor: ChessTheme.surfaceLight,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: VideoAspectRatio.values.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(p.label, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _aspectRatio = val;
                              _generateTimeline();
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // Move speed slider
                      Text('Move Animation Speed (${_moveSpeed.toStringAsFixed(2)}s)',
                          style: const TextStyle(fontSize: 12, color: ChessTheme.textSecondary)),
                      Slider(
                        value: _moveSpeed,
                        min: 0.15,
                        max: 0.80,
                        activeColor: ChessTheme.primary,
                        onChanged: (val) {
                          setState(() {
                            _moveSpeed = val;
                          });
                        },
                        onChangeEnd: (_) => _generateTimeline(),
                      ),

                      // Critical moment pause
                      Text('Critical Moment Pause (${_criticalPause.toStringAsFixed(1)}s)',
                          style: const TextStyle(fontSize: 12, color: ChessTheme.textSecondary)),
                      Slider(
                        value: _criticalPause,
                        min: 1.0,
                        max: 4.0,
                        activeColor: ChessTheme.primary,
                        onChanged: (val) {
                          setState(() {
                            _criticalPause = val;
                          });
                        },
                        onChangeEnd: (_) => _generateTimeline(),
                      ),

                      const Divider(height: 24),

                      // Feature Toggles
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Evaluation Bar', style: TextStyle(fontSize: 13, color: ChessTheme.textPrimary)),
                        value: _showEvalBar,
                        activeThumbColor: ChessTheme.primary,
                        onChanged: (val) => setState(() => _showEvalBar = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Move & Critical Arrows', style: TextStyle(fontSize: 13, color: ChessTheme.textPrimary)),
                        value: _showArrows,
                        activeThumbColor: ChessTheme.primary,
                        onChanged: (val) => setState(() => _showArrows = val),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Educational Subtitles', style: TextStyle(fontSize: 13, color: ChessTheme.textPrimary)),
                        value: _showSubtitles,
                        activeThumbColor: ChessTheme.primary,
                        onChanged: (val) => setState(() => _showSubtitles = val),
                      ),

                      const SizedBox(height: 16),

                      // FFmpeg Command Line Copy Box
                      const Text('Deterministic FFmpeg Command', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ChessTheme.textPrimary)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: ChessTheme.border),
                        ),
                        child: SelectableText(
                          _generatedCommand,
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: ChessTheme.primaryLight),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.copy, size: 14),
                        label: const Text('Copy FFmpeg Command'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ChessTheme.surfaceLight,
                          foregroundColor: ChessTheme.textPrimary,
                          minimumSize: const Size(double.infinity, 36),
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _generatedCommand));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('FFmpeg command copied to clipboard!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

            const SizedBox(width: 24),

            // Right: Interactive Frame Preview & Scrubber
            Expanded(
              child: Column(
                children: [
                  // Frame Preview Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: ChessTheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ChessTheme.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Frame ${_currentFrameIndex + 1} of ${_generatedTimeline.length} • ${currentFrame?.timestampSeconds.toStringAsFixed(2)}s',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: ChessTheme.textPrimary),
                        ),
                        if (currentFrame?.subtitleText != null && currentFrame!.subtitleText!.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                currentFrame.subtitleText!,
                                style: const TextStyle(color: ChessTheme.accentGold, fontSize: 12, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: ChessTheme.primary.withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${_aspectRatio.width}x${_aspectRatio.height} @ ${_aspectRatio.fps}fps',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Board Preview Area
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_showEvalBar) ...[
                            const SizedBox(
                              height: 480,
                              child: EvaluationBarWidget(isVertical: true),
                            ),
                            const SizedBox(width: 16),
                          ],
                          SizedBox(
                            width: 480,
                            height: 480,
                            child: ChessBoardWidget(
                              board: board,
                              isInteractive: false,
                              highlightedSquares: currentFrame?.highlightedSquares ?? [],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Timeline Scrubber Slider
                  if (_generatedTimeline.isNotEmpty)
                    Slider(
                      value: _currentFrameIndex.toDouble(),
                      min: 0,
                      max: (_generatedTimeline.length - 1).toDouble(),
                      activeColor: ChessTheme.primary,
                      onChanged: (val) {
                        setState(() {
                          _currentFrameIndex = val.toInt();
                        });
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
