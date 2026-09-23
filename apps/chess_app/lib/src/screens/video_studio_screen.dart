import 'dart:async';
import 'dart:io';
import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:chess_video/chess_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/board_size_policy.dart';
import '../theme/chess_board_theme.dart';
import '../theme/chess_theme.dart';
import '../theme/piece_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/board/evaluation_bar_widget.dart';
import '../widgets/board/move_list_widget.dart';
import '../widgets/video/game_source_selector_dialog.dart';

/// Complete, production-grade chess video creation studio supporting game selection,
/// interactive preview, deterministic timeline scrubbing, and real native FFmpeg rendering.
class VideoStudioScreen extends StatefulWidget {
  final StorageRepository? repository;
  final dynamic initialArgs;

  const VideoStudioScreen({super.key, this.repository, this.initialArgs});

  @override
  State<VideoStudioScreen> createState() => _VideoStudioScreenState();
}

class _VideoStudioScreenState extends State<VideoStudioScreen> {
  late final StorageRepository _repository;
  late PgnGame _game;
  String _gameTitle = 'Adolf Anderssen vs Lionel Kieseritzky (1851)';
  String _gameSubtitle = 'The Immortal Game · ECO C33 · King\'s Gambit Accepted';

  VideoAspectRatio _aspectRatio = VideoAspectRatio.youtube16x9;
  VideoContentProfile _contentProfile = VideoContentProfile.fullGame;
  String _selectedAudioTrackId = 'none';
  double _audioVolume = 0.40;
  bool _loopAudio = true;
  bool _enableHardwareAccel = true;
  List<String> _availableHardwareEncoders = [];

  double _moveSpeed = 0.35;
  double _criticalPause = 2.0;
  bool _showEvalBar = true;
  bool _showArrows = true;
  bool _showSubtitles = true;
  bool _isBoardFlipped = false;
  String _selectedBoardTheme = 'tournamentGreen';
  String _selectedPieceTheme = 'standard';
  bool _showCoordinates = true;
  bool _showLastMoveHighlight = true;

  List<VideoFrame> _generatedTimeline = [];
  int _currentFrameIndex = 0;
  String _generatedCommand = '';

  // Playback preview timer
  Timer? _playbackTimer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? StorageRepository();
    _availableHardwareEncoders = RealVideoRenderer.detectHardwareEncoders();

    String pgn = ModelGamesDatabase.curatedGames.first.pgn;
    if (widget.initialArgs is Map) {
      final args = widget.initialArgs as Map;
      if (args['gameSession'] is GameSession) {
        final session = args['gameSession'] as GameSession;
        pgn = session.pgn.isNotEmpty ? session.pgn : session.toPgnGame().toPgnString();
      } else if (args['pgn'] != null) {
        pgn = args['pgn'] as String;
      }
    } else if (widget.initialArgs is String) {
      pgn = widget.initialArgs as String;
    }
    _loadPgn(pgn);
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _loadPgn(String pgn) {
    final parsed = PgnParser.parse(pgn) ?? PgnParser.parse(ModelGamesDatabase.curatedGames.first.pgn)!;
    setState(() {
      _game = parsed;
      final white = _game.headers['White'] ?? 'White';
      final black = _game.headers['Black'] ?? 'Black';
      final year = _game.headers['Date']?.split('.').firstOrNull ?? _game.headers['Year'] ?? '1851';
      final event = _game.headers['Event'] ?? 'Casual Game';
      final eco = _game.headers['ECO'] ?? 'A00';
      _gameTitle = '$white vs $black ($year)';
      _gameSubtitle = '$event · ECO $eco · ${_game.moves.length} plies';
    });
    _generateTimeline();
  }

  void _generateTimeline() {
    final profile = VideoProfile(
      aspectRatio: _aspectRatio,
      contentProfile: _contentProfile,
      moveSpeedSeconds: _moveSpeed,
      criticalMomentPauseSeconds: _criticalPause,
      showEvaluationBar: _showEvalBar,
      showArrows: _showArrows,
      showSubtitles: _showSubtitles,
      showCoordinates: _showCoordinates,
      showLastMoveHighlight: _showLastMoveHighlight,
      isBoardFlipped: _isBoardFlipped,
      boardThemeName: _selectedBoardTheme,
      pieceThemeName: _selectedPieceTheme,
      eventTitle: _gameTitle,
      whitePlayerName: _game.headers['White'] ?? 'White',
      blackPlayerName: _game.headers['Black'] ?? 'Black',
    );

    final generator = VideoTimelineGenerator(profile: profile);
    _generatedTimeline = generator.generateTimeline(_game);

    final track = AudioTrackManifest.getTrack(_selectedAudioTrackId);
    final audioPath = track.id != 'none' ? 'audio/${track.id}.mp3' : null;
    final hwEncoder = (_enableHardwareAccel && _availableHardwareEncoders.isNotEmpty)
        ? _availableHardwareEncoders.first
        : 'libx264';

    _generatedCommand = FfmpegCommandBuilder.buildCommandLineString(
      framesPattern: 'frames/frame_%06d.png',
      outputPath: 'output/chess_master_${_aspectRatio.name}.mp4',
      profile: profile,
      audioPath: audioPath,
      hardwareEncoder: hwEncoder,
      audioVolume: _audioVolume,
      loopAudio: _loopAudio,
    );

    setState(() {
      _currentFrameIndex = 0;
    });
  }

  void _togglePlayback() {
    if (_isPlaying) {
      _playbackTimer?.cancel();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_currentFrameIndex < _generatedTimeline.length - 1) {
          setState(() {
            _currentFrameIndex++;
          });
        } else {
          timer.cancel();
          setState(() => _isPlaying = false);
        }
      });
    }
  }

  void _goToFrame(int index) {
    if (index >= 0 && index < _generatedTimeline.length) {
      setState(() {
        _currentFrameIndex = index;
      });
    }
  }

  Future<void> _openGameSelector() async {
    final chosenPgn = await showDialog<String>(
      context: context,
      builder: (ctx) => GameSourceSelectorDialog(repository: _repository),
    );

    if (chosenPgn != null && chosenPgn.isNotEmpty) {
      _loadPgn(chosenPgn);
    }
  }

  Future<void> _startVideoGeneration() async {
    final outputPath = '${Directory.systemTemp.path}${Platform.pathSeparator}chessmaster_${DateTime.now().millisecondsSinceEpoch}.mp4';

    bool isCancelled = false;
    double currentProgress = 0.0;
    String currentPhase = 'Initializing render engine...';
    int currentFrame = 0;
    int totalFrames = _generatedTimeline.length;

    StateSetter? setModalState;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            setModalState = setDialogState;
            return AlertDialog(
              backgroundColor: context.surf,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: context.brd),
              ),
              title: Row(
                children: [
                  const Icon(Icons.movie, color: ChessTheme.primaryLight),
                  const SizedBox(width: 8),
                  Text('Generating MP4 Video', style: TextStyle(color: context.txt, fontSize: 16)),
                ],
              ),
              content: SizedBox(
                width: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentPhase, style: TextStyle(fontSize: 13, color: context.txtSec)),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: currentProgress > 0 ? currentProgress : null,
                      backgroundColor: context.surfLight,
                      color: ChessTheme.primary,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Frame $currentFrame / $totalFrames', style: TextStyle(fontSize: 11, color: context.txtMut)),
                        Text('${(currentProgress * 100).clamp(0, 100).toStringAsFixed(0)}%',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txt)),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    isCancelled = true;
                    Navigator.of(dialogCtx).pop();
                  },
                  child: const Text('Cancel', style: TextStyle(color: ChessTheme.qualityBlunder)),
                ),
              ],
            );
          },
        );
      },
    );

    try {
      final profile = VideoProfile(
        aspectRatio: _aspectRatio,
        contentProfile: _contentProfile,
        moveSpeedSeconds: _moveSpeed,
        criticalMomentPauseSeconds: _criticalPause,
        showEvaluationBar: _showEvalBar,
        showArrows: _showArrows,
        showSubtitles: _showSubtitles,
        showCoordinates: _showCoordinates,
        showLastMoveHighlight: _showLastMoveHighlight,
        isBoardFlipped: _isBoardFlipped,
        boardThemeName: _selectedBoardTheme,
        pieceThemeName: _selectedPieceTheme,
        eventTitle: _gameTitle,
        whitePlayerName: _game.headers['White'] ?? 'White',
        blackPlayerName: _game.headers['Black'] ?? 'Black',
      );

      final track = AudioTrackManifest.getTrack(_selectedAudioTrackId);
      final audioPath = track.id != 'none' ? 'audio/${track.id}.mp3' : null;
      final hwEncoder = (_enableHardwareAccel && _availableHardwareEncoders.isNotEmpty)
          ? _availableHardwareEncoders.first
          : 'libx264';

      final result = await RealVideoRenderer.renderVideo(
        game: _game,
        outputPath: outputPath,
        profile: profile,
        audioPath: audioPath,
        hardwareEncoder: hwEncoder,
        audioVolume: _audioVolume,
        loopAudio: _loopAudio,
        onProgress: (frame, total, prog, phase) {
          currentFrame = frame;
          totalFrames = total;
          currentProgress = prog;
          currentPhase = phase;
          setModalState?.call(() {});
        },
        shouldCancel: () => isCancelled,
      );

      // Close progress modal
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show success modal
      if (mounted && !isCancelled) {
        _showSuccessDialog(result);
      }
    } catch (e) {
      // Close progress modal
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (!isCancelled && mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.surf,
            title: const Row(
              children: [
                Icon(Icons.error_outline, color: ChessTheme.qualityBlunder, size: 20),
                SizedBox(width: 8),
                Text('Video Export Failed', style: TextStyle(color: ChessTheme.qualityBlunder)),
              ],
            ),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('An error occurred during video rendering:', style: TextStyle(color: ctx.txt)),
                  const SizedBox(height: 8),
                  SelectableText(
                    'Output Path: $outputPath\nDetails: $e',
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showSuccessDialog(VideoRenderResult result) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.surf,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ctx.brd),
        ),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: ChessTheme.primaryLight),
            const SizedBox(width: 8),
            Text('Video Generated Successfully!', style: TextStyle(color: ctx.txt, fontSize: 16)),
          ],
        ),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your MP4 chess video has been encoded and verified:', style: TextStyle(color: ctx.txtSec, fontSize: 13)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ctx.surfLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _metaRow('File Path:', result.outputPath),
                    const SizedBox(height: 6),
                    _metaRow('Duration:', '${result.durationSeconds.toStringAsFixed(1)} seconds'),
                    const SizedBox(height: 6),
                    _metaRow('Total Frames:', '${result.frameCount} frames'),
                    const SizedBox(height: 6),
                    _metaRow('File Size:', '${(result.fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: result.outputPath));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Video file path copied to clipboard!')),
              );
            },
            child: const Text('Copy File Path'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ChessTheme.primary,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
        Expanded(child: SelectableText(value, style: const TextStyle(fontSize: 11, fontFamily: 'monospace'))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFrame = _generatedTimeline.isNotEmpty ? _generatedTimeline[_currentFrameIndex] : null;
    final board = currentFrame != null ? Board.fromFen(currentFrame.fen) : Board.initial();

    return Scaffold(
      backgroundColor: context.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 960;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Top Game Header & Selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: context.surf,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.brd),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.movie_creation_outlined, color: ChessTheme.primaryLight, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Video Studio · $_gameTitle',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: context.txt),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _gameSubtitle,
                              style: TextStyle(fontSize: 11, color: context.txtSec),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.swap_horiz, size: 16),
                        label: const Text('Select Game'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.surfLight,
                          foregroundColor: context.txt,
                        ),
                        onPressed: _openGameSelector,
                      ),
                    ],
                  ),
                ),

                // Main Workspace Layout
                Expanded(
                  child: isCompact
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildPreviewCanvas(context, board, currentFrame, 460),
                              const SizedBox(height: 16),
                              _buildConfigPanel(context),
                            ],
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Configuration Panel
                            SizedBox(
                              width: 340,
                              child: _buildConfigPanel(context),
                            ),
                            const SizedBox(width: 20),

                            // Center: Maximized Canvas Preview
                            Expanded(
                              flex: 5,
                              child: _buildPreviewCanvas(context, board, currentFrame, null),
                            ),

                            const SizedBox(width: 20),

                            // Right: Move Tree
                            SizedBox(
                              width: 260,
                              child: MoveListWidget(
                                moves: _game.moves,
                                currentPlyIndex: currentFrame?.ply ?? 0,
                                onMoveSelected: (ply) {
                                  // Jump to first frame matching ply
                                  final idx = _generatedTimeline.indexWhere((f) => f.ply == ply);
                                  if (idx != -1) _goToFrame(idx);
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfigPanel(BuildContext context) {
    return Material(
      color: context.surf,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.brd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Video Profile & Canvas Format', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txt)),
              const SizedBox(height: 8),

              // Format selector
              DropdownButtonFormField<VideoAspectRatio>(
                value: _aspectRatio,
                isExpanded: true,
                dropdownColor: context.surfLight,
                decoration: InputDecoration(
                  labelText: 'CANVAS RATIO',
                  labelStyle: TextStyle(fontSize: 10, color: context.txtMut),
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

              const SizedBox(height: 10),

              // Content Profile selector
              DropdownButtonFormField<VideoContentProfile>(
                value: _contentProfile,
                isExpanded: true,
                dropdownColor: context.surfLight,
                decoration: InputDecoration(
                  labelText: 'CONTENT PROFILE',
                  labelStyle: TextStyle(fontSize: 10, color: context.txtMut),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: VideoContentProfile.values.map((cp) {
                  return DropdownMenuItem(
                    value: cp,
                    child: Text(cp.title, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _contentProfile = val;
                      _generateTimeline();
                    });
                  }
                },
              ),

              const SizedBox(height: 14),

              // Move speed slider
              Text('Move Animation (${_moveSpeed.toStringAsFixed(2)}s)',
                  style: TextStyle(fontSize: 11, color: context.txtSec)),
              Slider(
                value: _moveSpeed,
                min: 0.15,
                max: 0.80,
                activeColor: ChessTheme.primary,
                onChanged: (val) => setState(() => _moveSpeed = val),
                onChangeEnd: (_) => _generateTimeline(),
              ),

              // Critical moment pause
              Text('Critical Moment Pause (${_criticalPause.toStringAsFixed(1)}s)',
                  style: TextStyle(fontSize: 11, color: context.txtSec)),
              Slider(
                value: _criticalPause,
                min: 1.0,
                max: 4.0,
                activeColor: ChessTheme.primary,
                onChanged: (val) => setState(() => _criticalPause = val),
                onChangeEnd: (_) => _generateTimeline(),
              ),

              const Divider(height: 20),

              // Background Music & Audio Section
              Text('BACKGROUND MUSIC & AUDIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.txtMut)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedAudioTrackId,
                isExpanded: true,
                dropdownColor: context.surfLight,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: AudioTrackManifest.tracks.map((t) {
                  return DropdownMenuItem(
                    value: t.id,
                    child: Text(t.title, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedAudioTrackId = val;
                      final t = AudioTrackManifest.getTrack(val);
                      _audioVolume = t.defaultVolume > 0 ? t.defaultVolume : 0.35;
                      _generateTimeline();
                    });
                  }
                },
              ),

              if (_selectedAudioTrackId != 'none') ...[
                const SizedBox(height: 8),
                Builder(builder: (context) {
                  final t = AudioTrackManifest.getTrack(_selectedAudioTrackId);
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(35),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: context.brd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('License: ${t.license}', style: const TextStyle(fontSize: 10, color: ChessTheme.primaryLight, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text(t.attribution, style: TextStyle(fontSize: 9, color: context.txtMut)),
                        const SizedBox(height: 2),
                        Text('SHA-256: ${t.checksumSha256.substring(0, 16)}...', style: TextStyle(fontSize: 9, color: context.txtMut, fontFamily: 'monospace')),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Text('Music Volume (${(_audioVolume * 100).toInt()}%)',
                    style: TextStyle(fontSize: 11, color: context.txtSec)),
                Slider(
                  value: _audioVolume,
                  min: 0.05,
                  max: 1.0,
                  activeColor: ChessTheme.primary,
                  onChanged: (val) {
                    setState(() => _audioVolume = val);
                    _generateTimeline();
                  },
                ),
                SwitchListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('Loop Music Seamlessly', style: TextStyle(fontSize: 12, color: context.txt)),
                  value: _loopAudio,
                  activeColor: ChessTheme.primary,
                  onChanged: (val) {
                    setState(() => _loopAudio = val);
                    _generateTimeline();
                  },
                ),
              ],

              const Divider(height: 20),

              // Hardware Acceleration
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _availableHardwareEncoders.isNotEmpty
                      ? 'GPU Acceleration (${_availableHardwareEncoders.first})'
                      : 'GPU Acceleration (Fallback to CPU)',
                  style: TextStyle(fontSize: 12, color: context.txt),
                ),
                subtitle: Text(
                  _availableHardwareEncoders.isNotEmpty
                      ? 'Hardware encoder detected and validated'
                      : 'Software libx264 encoding active',
                  style: TextStyle(fontSize: 10, color: context.txtMut),
                ),
                value: _enableHardwareAccel,
                activeColor: ChessTheme.primary,
                onChanged: (val) {
                  setState(() => _enableHardwareAccel = val);
                  _generateTimeline();
                },
              ),

              const Divider(height: 20),

              // Visual Themes
              Text('BOARD THEME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.txtMut)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedBoardTheme,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  filled: true,
                  fillColor: context.surfLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.brd)),
                ),
                dropdownColor: context.surf,
                items: const [
                  DropdownMenuItem(value: 'tournamentGreen', child: Text('Tournament Green (Standard)')),
                  DropdownMenuItem(value: 'classicWood', child: Text('Classic Warm Walnut')),
                  DropdownMenuItem(value: 'slateBlue', child: Text('Slate Blue (Modern)')),
                  DropdownMenuItem(value: 'highContrast', child: Text('High Contrast (Accessible)')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedBoardTheme = val);
                    _generateTimeline();
                  }
                },
              ),

              const SizedBox(height: 12),
              Text('PIECE THEME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.txtMut)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedPieceTheme,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  filled: true,
                  fillColor: context.surfLight,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: context.brd)),
                ),
                dropdownColor: context.surf,
                items: const [
                  DropdownMenuItem(value: 'standard', child: Text('Staunton Vector (Crisp)')),
                  DropdownMenuItem(value: 'highContrast', child: Text('High Contrast (Black & White)')),
                  DropdownMenuItem(value: 'classicWood', child: Text('Classic Wood / Ivory')),
                  DropdownMenuItem(value: 'minimalNotation', child: Text('Minimal Notation (Letter Discs)')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedPieceTheme = val);
                    _generateTimeline();
                  }
                },
              ),

              const Divider(height: 20),

              // Overlays & Coordinates
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Show Coordinates', style: TextStyle(fontSize: 12, color: context.txt)),
                value: _showCoordinates,
                activeColor: ChessTheme.primary,
                onChanged: (val) {
                  setState(() => _showCoordinates = val);
                  _generateTimeline();
                },
              ),
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Highlight Last Move', style: TextStyle(fontSize: 12, color: context.txt)),
                value: _showLastMoveHighlight,
                activeColor: ChessTheme.primary,
                onChanged: (val) {
                  setState(() => _showLastMoveHighlight = val);
                  _generateTimeline();
                },
              ),
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Evaluation Bar', style: TextStyle(fontSize: 12, color: context.txt)),
                value: _showEvalBar,
                activeColor: ChessTheme.primary,
                onChanged: (val) => setState(() => _showEvalBar = val),
              ),
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Arrows & Highlights', style: TextStyle(fontSize: 12, color: context.txt)),
                value: _showArrows,
                activeColor: ChessTheme.primary,
                onChanged: (val) => setState(() => _showArrows = val),
              ),
              SwitchListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text('Educational Subtitles', style: TextStyle(fontSize: 12, color: context.txt)),
                value: _showSubtitles,
                activeColor: ChessTheme.primary,
                onChanged: (val) => setState(() => _showSubtitles = val),
              ),

              const SizedBox(height: 16),

              // Primary CTA
              ElevatedButton.icon(
                icon: const Icon(Icons.movie, size: 18),
                label: const Text('GENERATE VIDEO (MP4)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChessTheme.primary,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 44),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: _startVideoGeneration,
              ),

              const SizedBox(height: 12),

              // Collapsible Advanced FFmpeg details
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('Advanced FFmpeg Details', style: TextStyle(fontSize: 11, color: context.txtMut)),
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.isDark ? Colors.black45 : context.surfLight,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: context.brd),
                    ),
                    child: SelectableText(
                      _generatedCommand,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 9, color: ChessTheme.primaryLight),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextButton.icon(
                    icon: const Icon(Icons.copy, size: 12),
                    label: const Text('Copy Command', style: TextStyle(fontSize: 11)),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedCommand));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('FFmpeg command copied!')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCanvas(BuildContext context, Board board, VideoFrame? currentFrame, double? fixedHeight) {
    final totalFrames = _generatedTimeline.length;

    final canvas = Material(
      color: context.surf,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.brd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Playback and frame header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: currentFrame?.isCriticalMoment == true
                        ? ChessTheme.qualityBlunder.withAlpha(40)
                        : context.surfLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    currentFrame?.isCriticalMoment == true ? 'CRITICAL MOMENT' : 'PLY ${currentFrame?.ply ?? 0}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: currentFrame?.isCriticalMoment == true ? ChessTheme.qualityBlunder : context.txtSec,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentFrame?.subtitle ?? 'Preview Frame',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txt),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flip_camera_android, size: 18),
                  tooltip: 'Flip Board',
                  onPressed: () => setState(() => _isBoardFlipped = !_isBoardFlipped),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Canvas Board Preview
            Expanded(
              child: Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final boardSize = BoardSizePolicy.calculateBoardSize(
                      constraints: constraints,
                      mode: BoardSizeMode.editorPreview,
                      hasEvaluationBar: _showEvalBar,
                      evalBarWidth: 44.0,
                    );

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_showEvalBar) ...[
                          SizedBox(
                            width: 28,
                            height: boardSize,
                            child: EvaluationBarWidget(
                              isVertical: true,
                              evaluation: currentFrame?.evaluation != null
                                  ? EngineEvaluation(
                                      scoreCentipawns: currentFrame!.evaluation!,
                                      depth: 1,
                                      sideToMove: PieceColor.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 14),
                        ],
                        SizedBox(
                          width: boardSize,
                          height: boardSize,
                          child: ChessBoardWidget(
                            board: board,
                            isFlipped: _isBoardFlipped,
                            isInteractive: false,
                            boardTheme: ChessBoardTheme.fromName(_selectedBoardTheme),
                            pieceTheme: PieceTheme.fromName(_selectedPieceTheme),
                            showCoordinates: _showCoordinates,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Timeline Scrubber & Playback Controls
            Row(
              children: [
                IconButton(
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _togglePlayback,
                ),
                IconButton(
                  icon: const Icon(Icons.first_page, size: 18),
                  onPressed: _currentFrameIndex > 0 ? () => _goToFrame(0) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left, size: 18),
                  onPressed: _currentFrameIndex > 0 ? () => _goToFrame(_currentFrameIndex - 1) : null,
                ),
                Expanded(
                  child: Slider(
                    value: totalFrames > 0 ? _currentFrameIndex.toDouble() : 0.0,
                    min: 0.0,
                    max: totalFrames > 0 ? (totalFrames - 1).toDouble() : 0.0,
                    activeColor: ChessTheme.primary,
                    onChanged: (val) => _goToFrame(val.toInt()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, size: 18),
                  onPressed: _currentFrameIndex < totalFrames - 1 ? () => _goToFrame(_currentFrameIndex + 1) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.last_page, size: 18),
                  onPressed: _currentFrameIndex < totalFrames - 1 ? () => _goToFrame(totalFrames - 1) : null,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_currentFrameIndex + 1} / $totalFrames',
                  style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: context.txtMut),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (fixedHeight != null) {
      return SizedBox(height: fixedHeight, child: canvas);
    }
    return canvas;
  }
}
