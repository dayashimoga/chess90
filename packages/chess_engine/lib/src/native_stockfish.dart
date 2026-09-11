import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'embedded_heuristic_engine.dart';
import 'engine_interface.dart';

/// Native UCI process adapter for Stockfish.
/// Connects to real Stockfish process via standard UCI pipes.
/// Automatically falls back to EmbeddedHeuristicEngine if Stockfish binary is not present.
class NativeStockfishEngine implements ChessEngine {
  final String? customBinaryPath;
  Process? _process;
  final _controller = StreamController<EngineEvaluation>.broadcast();
  final EmbeddedHeuristicEngine _fallbackEngine = EmbeddedHeuristicEngine();
  StreamSubscription<String>? _stdoutSub;
  bool _useFallback = false;
  String _discoveredEngineName = 'Stockfish';
  Completer<void>? _readyCompleter;
  Completer<EngineEvaluation>? _evaluationCompleter;
  EngineEvaluation? _lastEvaluation;
  PieceColor _currentSideToMove = PieceColor.white;
  Timer? _initTimer;
  final bool forceFallback;

  NativeStockfishEngine({this.customBinaryPath, this.forceFallback = false});

  static bool get isSupported {
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS || Platform.isAndroid;
    } catch (_) {
      return false;
    }
  }

  @override
  String get engineName => _useFallback ? 'Embedded Heuristic Engine' : _discoveredEngineName;

  @override
  bool get isFallback => _useFallback;

  @override
  Stream<EngineEvaluation> get searchStream =>
      _useFallback ? _fallbackEngine.searchStream : _controller.stream;

  @override
  Future<void> initialize() async {
    if (forceFallback) {
      await _switchToFallback();
      return;
    }
    final candidatePaths = _resolveCandidatePaths();

    for (final path in candidatePaths) {
      try {
        final process = await Process.start(path, []);
        _process = process;
        unawaited(_process!.stdin.done.catchError((_) {}));

        _stdoutSub = _process!.stdout
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(_onEngineOutput, onError: (_) => _switchToFallback());

        _initTimer?.cancel();
        _readyCompleter = Completer<void>();
        _safeWrite('uci');
        _safeWrite('setoption name UCI_ShowWDL value true');
        _safeWrite('isready');

        // Wait up to 3 seconds for readyok without leaving a dangling timer
        _initTimer = Timer(const Duration(seconds: 3), () {
          if (_readyCompleter != null && !_readyCompleter!.isCompleted) {
            _readyCompleter!.complete();
          }
        });

        await _readyCompleter!.future;
        _initTimer?.cancel();
        _initTimer = null;
        _useFallback = false;
        return;
      } catch (_) {
        _initTimer?.cancel();
        _initTimer = null;
        // Try next candidate path
        _process?.kill();
        _process = null;
      }
    }

    // If no native binary launched successfully, switch to embedded engine
    await _switchToFallback();
  }

  Future<void> _switchToFallback() async {
    _initTimer?.cancel();
    _initTimer = null;
    if (_readyCompleter != null && !_readyCompleter!.isCompleted) {
      _readyCompleter!.complete();
    }
    _useFallback = true;
    await _fallbackEngine.initialize();
  }

  List<String> _resolveCandidatePaths() {
    final paths = <String>[];
    if (customBinaryPath != null && customBinaryPath!.isNotEmpty) {
      paths.add(customBinaryPath!);
    }

    final envPath = Platform.environment['CHESSMASTER_STOCKFISH_PATH'];
    if (envPath != null && envPath.isNotEmpty) {
      paths.add(envPath);
    }

    // Windows WinGet package detection
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData != null) {
      try {
        final wingetPackages = Directory('$localAppData\\Microsoft\\WinGet\\Packages');
        if (wingetPackages.existsSync()) {
          final sfDirs = wingetPackages
              .listSync()
              .whereType<Directory>()
              .where((d) => d.path.contains('Stockfish'));
          for (final d in sfDirs) {
            final exeCandidates = d
                .listSync(recursive: true)
                .whereType<File>()
                .where((f) => f.path.endsWith('.exe'));
            for (final exe in exeCandidates) {
              paths.add(exe.path);
            }
          }
        }
      } catch (_) {}
    }

    // Standard PATH binaries
    paths.addAll([
      'stockfish',
      'stockfish.exe',
      '/usr/games/stockfish',
      '/usr/local/bin/stockfish',
      '/opt/homebrew/bin/stockfish',
    ]);

    return paths;
  }

  void _onEngineOutput(String line) {
    line = line.trim();
    if (line.isEmpty) return;

    if (line == 'readyok') {
      _initTimer?.cancel();
      _initTimer = null;
      if (_readyCompleter != null && !_readyCompleter!.isCompleted) {
        _readyCompleter!.complete();
      }
      return;
    }

    if (line.startsWith('id name ')) {
      _discoveredEngineName = line.substring(8).trim();
      return;
    }

    // Parse UCI info lines: "info depth 12 score cp 45 wdl 600 250 150 nodes 10234 pv e2e4 c7c5"
    if (line.startsWith('info') && line.contains('score')) {
      final depthMatch = RegExp(r'depth\s+(\d+)').firstMatch(line);
      final scoreCpMatch = RegExp(r'score\s+cp\s+(-?\d+)').firstMatch(line);
      final mateMatch = RegExp(r'score\s+mate\s+(-?\d+)').firstMatch(line);
      final nodesMatch = RegExp(r'nodes\s+(\d+)').firstMatch(line);
      final pvMatch = RegExp(r'pv\s+(.+)$').firstMatch(line);
      final wdlMatch = RegExp(r'\bwdl\s+(\d+)\s+(\d+)\s+(\d+)\b').firstMatch(line);

      final depth = depthMatch != null ? int.parse(depthMatch.group(1)!) : 0;
      final cp = scoreCpMatch != null ? int.parse(scoreCpMatch.group(1)!) : null;
      final mate = mateMatch != null ? int.parse(mateMatch.group(1)!) : null;
      final nodes = nodesMatch != null ? int.parse(nodesMatch.group(1)!) : 0;

      EngineWdl? wdl;
      if (wdlMatch != null) {
        wdl = EngineWdl(
          winPerMille: int.parse(wdlMatch.group(1)!),
          drawPerMille: int.parse(wdlMatch.group(2)!),
          lossPerMille: int.parse(wdlMatch.group(3)!),
        );
      }

      Move? best;
      final pvMoves = <Move>[];
      if (pvMatch != null) {
        final uciList = pvMatch.group(1)!.trim().split(RegExp(r'\s+'));
        for (final u in uciList) {
          final m = Move.fromUci(u);
          if (m != null) pvMoves.add(m);
        }
        if (pvMoves.isNotEmpty) best = pvMoves.first;
      }

      final eval = EngineEvaluation(
        scoreCentipawns: cp,
        mateInMoves: mate,
        depth: depth,
        nodes: nodes,
        bestMove: best,
        pvLine: pvMoves,
        sideToMove: _currentSideToMove,
        wdl: wdl,
      );

      _lastEvaluation = eval;
      _controller.add(eval);
    }

    // Parse bestmove line: "bestmove e2e4 ponder e7e5"
    if (line.startsWith('bestmove')) {
      final parts = line.split(RegExp(r'\s+'));
      Move? best;
      if (parts.length > 1 && parts[1] != '(none)') {
        best = Move.fromUci(parts[1]);
      }

      final finalEval = _lastEvaluation ??
          EngineEvaluation(
            scoreCentipawns: 0,
            depth: 1,
            bestMove: best,
            sideToMove: _currentSideToMove,
          );

      if (_evaluationCompleter != null && !_evaluationCompleter!.isCompleted) {
        _evaluationCompleter!.complete(finalEval);
      }
    }
  }

  void _safeWrite(String cmd) {
    try {
      _process?.stdin.writeln(cmd);
    } catch (_) {}
  }

  /// Configures a UCI option (e.g. MultiPV, Threads, Hash).
  void setOption(String name, dynamic value) {
    if (_useFallback) return;
    _safeWrite('setoption name $name value $value');
  }

  @override
  Future<void> setPosition(String fen, [List<Move> moves = const []]) async {
    final board = Board.fromFen(fen);
    _currentSideToMove = board.activeColor;

    if (_useFallback) {
      return _fallbackEngine.setPosition(fen, moves);
    }

    final moveListStr = moves.isEmpty ? '' : ' moves ${moves.map((m) => m.uci).join(' ')}';
    _safeWrite('position fen $fen$moveListStr');
  }

  @override
  Future<EngineEvaluation> evaluate({int depth = 10, Duration? timeLimit}) async {
    if (_useFallback) {
      return _fallbackEngine.evaluate(depth: depth, timeLimit: timeLimit);
    }

    _evaluationCompleter = Completer<EngineEvaluation>();
    final movetime = timeLimit != null ? ' movetime ${timeLimit.inMilliseconds}' : '';
    _safeWrite('go depth $depth$movetime');

    return _evaluationCompleter!.future;
  }

  @override
  Future<void> stop() async {
    if (_useFallback) {
      return _fallbackEngine.stop();
    }
    _safeWrite('stop');
  }

  @override
  Future<void> dispose() async {
    _initTimer?.cancel();
    _initTimer = null;
    if (_readyCompleter != null && !_readyCompleter!.isCompleted) {
      _readyCompleter!.complete();
    }
    if (_evaluationCompleter != null && !_evaluationCompleter!.isCompleted) {
      _evaluationCompleter!.complete(EngineEvaluation(depth: 0, sideToMove: _currentSideToMove));
    }
    if (_useFallback) {
      return _fallbackEngine.dispose();
    }
    try {
      _safeWrite('quit');
      _process?.kill();
    } catch (_) {}
    _process = null;
    await _stdoutSub?.cancel();
    await _controller.close();
  }
}
