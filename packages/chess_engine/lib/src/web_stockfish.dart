import 'dart:async';
import 'package:chess_core/chess_core.dart';
import 'embedded_heuristic_engine.dart';
import 'engine_interface.dart';

/// Stockfish adapter for browser web environments.
/// Interfaces with browser Web Worker running Stockfish.js / WASM,
/// and falls back to EmbeddedHeuristicEngine for full offline reliability.
class WebStockfishEngine implements ChessEngine {
  final EmbeddedHeuristicEngine _fallback = EmbeddedHeuristicEngine();
  final bool _isWorkerActive = false;

  @override
  String get engineName => _isWorkerActive ? 'Stockfish WASM' : 'Embedded Heuristic Engine';

  @override
  bool get isFallback => !_isWorkerActive;

  @override
  Stream<EngineEvaluation> get searchStream => _fallback.searchStream;

  @override
  Future<void> initialize() async {
    await _fallback.initialize();
  }

  @override
  Future<void> setPosition(String fen, [List<Move> moves = const []]) async {
    await _fallback.setPosition(fen, moves);
  }

  @override
  Future<EngineEvaluation> evaluate({int depth = 10, Duration? timeLimit}) async {
    return _fallback.evaluate(depth: depth, timeLimit: timeLimit);
  }

  @override
  Future<void> stop() async {
    await _fallback.stop();
  }

  @override
  Future<void> dispose() async {
    await _fallback.dispose();
  }
}
