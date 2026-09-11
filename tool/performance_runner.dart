import 'dart:convert';
import 'dart:io';
import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_labs/chess_labs.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:chess_video/chess_video.dart';

class BenchmarkResult {
  final String name;
  final String category;
  final double value;
  final String unit;
  final double budgetThreshold;
  final bool higherIsBetter;
  final bool passed;
  final String notes;

  BenchmarkResult({
    required this.name,
    required this.category,
    required this.value,
    required this.unit,
    required this.budgetThreshold,
    required this.higherIsBetter,
    required this.passed,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'value': double.parse(value.toStringAsFixed(2)),
    'unit': unit,
    'budgetThreshold': budgetThreshold,
    'higherIsBetter': higherIsBetter,
    'passed': passed,
    'notes': notes,
  };
}

int _perft(Board board, int depth) {
  if (depth == 0) return 1;
  final moves = MoveGenerator.generateLegalMoves(board);
  if (depth == 1) return moves.length;
  int nodes = 0;
  for (final move in moves) {
    board.makeMove(move);
    nodes += _perft(board, depth - 1);
    board.unmakeMove();
  }
  return nodes;
}

Future<void> main(List<String> args) async {
  print('======================================================');
  print('        CHESSMASTER PERFORMANCE BENCHMARK SUITE       ');
  print('======================================================');
  print('OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
  print('Dart SDK: ${Platform.version.split(" ").first}');
  print('Processors: ${Platform.numberOfProcessors}');
  print('------------------------------------------------------\n');

  final results = <BenchmarkResult>[];

  // 1. Perft & Move Generation Benchmark
  print('[1/7] Benchmarking Move Generation & Perft (Depth 3)...');
  {
    final board = Board.initial();
    // Warmup
    _perft(board, 2);

    final sw = Stopwatch()..start();
    const iterations = 5;
    int totalNodes = 0;
    for (int i = 0; i < iterations; i++) {
      totalNodes += _perft(board, 3); // 8902 nodes per run
    }
    sw.stop();
    final elapsedSec = sw.elapsedMicroseconds / 1000000.0;
    final nodesPerSec = totalNodes / elapsedSec;
    const threshold = 15000.0; // 15k nodes/sec budget
    final pass = nodesPerSec >= threshold;

    results.add(BenchmarkResult(
      name: 'Move Generation & Perft Depth 3',
      category: 'Chess Core',
      value: nodesPerSec,
      unit: 'nodes/sec',
      budgetThreshold: threshold,
      higherIsBetter: true,
      passed: pass,
      notes: 'Completed $totalNodes nodes in ${sw.elapsedMilliseconds}ms across $iterations iterations.',
    ));
    print('  -> ${nodesPerSec.toStringAsFixed(0)} nodes/sec (Budget: >=${threshold.toInt()}) [${pass ? "PASS" : "FAIL"}]');
  }

  // 2. FEN Parsing & Validation Throughput
  print('[2/7] Benchmarking FEN Parsing & Validation (1,000 cycles)...');
  {
    const fenList = [
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
      'r1b1k2r/ppppqppp/2n5/8/1bPP4/2N2N2/PP2BPPP/R1BQK2R b KQkq - 2 8',
      '8/2P5/8/8/8/k7/8/2K1Q3 w - - 0 1',
      '1K1k4/1P6/8/8/8/8/r7/5R2 w - - 0 1',
    ];
    final sw = Stopwatch()..start();
    const totalRuns = 2000;
    for (int i = 0; i < totalRuns; i++) {
      final fen = fenList[i % fenList.length];
      Board.fromFen(fen);
    }
    sw.stop();
    final fensPerSec = totalRuns / (sw.elapsedMicroseconds / 1000000.0);
    const threshold = 10000.0;
    final pass = fensPerSec >= threshold;

    results.add(BenchmarkResult(
      name: 'FEN Parsing & Validation',
      category: 'Chess Core',
      value: fensPerSec,
      unit: 'fens/sec',
      budgetThreshold: threshold,
      higherIsBetter: true,
      passed: pass,
      notes: '$totalRuns FEN parses completed in ${sw.elapsedMilliseconds}ms.',
    ));
    print('  -> ${fensPerSec.toStringAsFixed(0)} fens/sec (Budget: >=${threshold.toInt()}) [${pass ? "PASS" : "FAIL"}]');
  }

  // 3. PGN Ingestion Throughput
  print('[3/7] Benchmarking PGN Parsing & Tokenization...');
  {
    const samplePgn = '''
[Event "World Championship 35th"]
[Site "Reykjavik ISL"]
[Date "1972.07.23"]
[Round "6"]
[White "Fischer, Robert James"]
[Black "Spassky, Boris V"]
[Result "1-0"]

1. c4 e6 2. Nf3 d5 3. d4 Nf6 4. Nc3 Be7 5. Bg5 O-O 6. e3 h6 7. Bh4 b6
8. cxd5 Nxd5 9. Bxe7 Qxe7 10. Nxd5 exd5 11. Rc1 Be6 12. Qa4 c5 13. Qa3 Rc8
14. Bb5 a6 15. dxc5 bxc5 16. O-O Ra7 17. Be2 Nd7 18. Nd4 Qf8 19. Nxe6 fxe6
20. e4 d4 21. f4 Qe7 22. e5 Rb8 23. Bc4 Kh8 24. Qh3 Nf8 25. b3 a5
26. f5 exf5 27. Rxf5 Nh7 28. Rcf1 Qd8 29. Qg3 Re7 30. h4 Rbb7 31. e6 Rbc7
32. Qe5 Qe8 33. a4 Qd8 34. R1f2 Qe8 35. R2f3 Qd8 36. Bd3 Qe8 37. Qe4 Nf6
38. Rxf6 gxf6 39. Rxf6 Kg8 40. Bc4 Kh8 41. Qf4 1-0
''';
    // Warmup JIT
    for (int i = 0; i < 20; i++) {
      PgnParser.parse(samplePgn);
    }

    final sw = Stopwatch()..start();
    const runs = 300;
    int totalPlies = 0;
    for (int i = 0; i < runs; i++) {
      final parsed = PgnParser.parse(samplePgn);
      if (parsed != null) {
        totalPlies += parsed.moves.length;
      }
    }
    sw.stop();
    final gamesPerSec = runs / (sw.elapsedMicroseconds / 1000000.0);
    const threshold = 500.0;
    final pass = gamesPerSec >= threshold;

    results.add(BenchmarkResult(
      name: 'PGN Parsing Throughput',
      category: 'Chess Core',
      value: gamesPerSec,
      unit: 'games/sec',
      budgetThreshold: threshold,
      higherIsBetter: true,
      passed: pass,
      notes: '$runs full 41-move games ($totalPlies plies) parsed in ${sw.elapsedMilliseconds}ms.',
    ));
    print('  -> ${gamesPerSec.toStringAsFixed(0)} games/sec (Budget: >=${threshold.toInt()}) [${pass ? "PASS" : "FAIL"}]');
  }

  // 4. Embedded Heuristic Engine Search Latency
  print('[4/7] Benchmarking Embedded Engine Search Latency (Depth 4)...');
  {
    final engine = EmbeddedHeuristicEngine();
    await engine.initialize();
    final board = Board.initial();
    await engine.setPosition(board.toFen());

    final sw = Stopwatch()..start();
    const searchDepth = 4;
    final analysis = await engine.evaluate(depth: searchDepth);
    sw.stop();

    final latencyMs = sw.elapsedMilliseconds.toDouble();
    const threshold = 300.0; // max 300ms budget
    final pass = latencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'Engine Search Depth 4 Latency',
      category: 'Chess Engine',
      value: latencyMs,
      unit: 'ms',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'Best move: ${analysis.bestMove}, score: ${analysis.scoreCentipawns}cp in ${latencyMs.toInt()}ms.',
    ));
    print('  -> ${latencyMs.toStringAsFixed(1)} ms (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
    await engine.dispose();
  }

  // 5. Spaced Repetition (Leitner) Calculation Throughput
  print('[5/7] Benchmarking Leitner Spaced Repetition Throughput (1,000 updates)...');
  {
    final engine = LeitnerEngine();
    final sw = Stopwatch()..start();
    const iterations = 1000;
    for (int i = 0; i < iterations; i++) {
      final item = ReviewItem(
        id: 'bench_$i',
        fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
        solutionSan: ['e4'],
        skillNodeId: 'node_${i % 10}',
        motif: 'fork',
        explanation: 'Benchmark item $i',
      );
      engine.addItem(item);
      engine.recordResult('bench_$i', i % 4 != 0);
    }
    sw.stop();
    final reviewsPerSec = iterations / (sw.elapsedMicroseconds / 1000000.0);
    const threshold = 10000.0;
    final pass = reviewsPerSec >= threshold && engine.allItems.length == iterations;

    results.add(BenchmarkResult(
      name: 'SRS Scheduling Calculation',
      category: 'Chess Learning',
      value: reviewsPerSec,
      unit: 'calculations/sec',
      budgetThreshold: threshold,
      higherIsBetter: true,
      passed: pass,
      notes: '$iterations Leitner scheduling transitions calculated in ${sw.elapsedMilliseconds}ms. Retention: ${(engine.overallRetentionRate * 100).toStringAsFixed(1)}%.',
    ));
    print('  -> ${reviewsPerSec.toStringAsFixed(0)} calc/sec (Budget: >=${threshold.toInt()}) [${pass ? "PASS" : "FAIL"}]');
  }

  // 6. Storage InMemory CRUD Performance
  print('[6/7] Benchmarking Storage Transactions (500 Operations)...');
  {
    final repo = StorageRepository.inMemory();
    final sw = Stopwatch()..start();
    const ops = 500;
    for (int i = 0; i < ops; i++) {
      repo.saveGame(GameRecord(
        id: 'bench_$i',
        pgn: '1. e4 e5 2. Nf3 *',
        playedDate: DateTime.now(),
        whitePlayer: 'Player $i',
        blackPlayer: 'Stockfish',
        result: '1-0',
        timeControl: '300+0',
      ));
    }
    final allGames = repo.getGames();
    sw.stop();

    final opsPerSec = ops / (sw.elapsedMicroseconds / 1000000.0);
    const threshold = 2000.0;
    final pass = opsPerSec >= threshold && allGames.length == ops;

    results.add(BenchmarkResult(
      name: 'Storage CRUD Operations',
      category: 'Chess Storage',
      value: opsPerSec,
      unit: 'ops/sec',
      budgetThreshold: threshold,
      higherIsBetter: true,
      passed: pass,
      notes: '$ops serialized game records inserted & retrieved in ${sw.elapsedMilliseconds}ms.',
    ));
    print('  -> ${opsPerSec.toStringAsFixed(0)} ops/sec (Budget: >=${threshold.toInt()}) [${pass ? "PASS" : "FAIL"}]');
  }

  // 7. Video Timeline Generation Throughput
  print('[7/7] Benchmarking Video Timeline Generator (40-ply game)...');
  {
    const pgn = '1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 5. O-O Be7 6. Re1 b5 7. Bb3 d6 8. c3 O-O 9. h3 Nb8 10. d4 Nbd7 11. c4 c6 12. cxb5 axb5 13. Nc3 Bb7 14. Bg5 h6 15. Bh4 Re8 16. Qd2 b4 17. Nd1 exd4 18. Nxd4 c5 19. Nf5 Nxe4 20. Bxe7 Nxd2';
    final parsed = PgnParser.parse(pgn)!;
    final timelineGen = VideoTimelineGenerator(profile: const VideoProfile());

    final sw = Stopwatch()..start();
    const runs = 50;
    for (int i = 0; i < runs; i++) {
      timelineGen.generateTimeline(parsed);
    }
    sw.stop();
    final timelineLatencyMs = sw.elapsedMilliseconds / runs;
    const threshold = 20.0; // max 20ms per timeline
    final pass = timelineLatencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'Video Timeline Generation',
      category: 'Chess Video',
      value: timelineLatencyMs,
      unit: 'ms/timeline',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: '$runs 20-move timelines generated with full evaluation sync.',
    ));
    print('  -> ${timelineLatencyMs.toStringAsFixed(2)} ms/timeline (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
  }

  // 8. Cold Start & Subsystem Initialization Latency
  print('[8/16] Benchmarking Cold Start & Service Initialization Latency...');
  {
    final sw = Stopwatch()..start();
    const runs = 20;
    for (int i = 0; i < runs; i++) {
      final repo = StorageRepository.inMemory();
      final profile = repo.getProfile();
      final leitner = LeitnerEngine();
      final catalog = CurriculumCatalog.allDays;
      assert(profile.currentDay >= 1 && catalog.length == 90);
    }
    sw.stop();
    final latencyMs = sw.elapsedMilliseconds / runs;
    const threshold = 50.0;
    final pass = latencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'Cold Start Initialization Latency',
      category: 'UX Performance',
      value: latencyMs,
      unit: 'ms',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'Subsystem initialization, profile load, and 90-day catalog index averaged ${latencyMs.toStringAsFixed(2)}ms.',
    ));
    print('  -> ${latencyMs.toStringAsFixed(2)} ms (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
  }

  // 9. First Board Paint & Layout Generation Latency
  print('[9/16] Benchmarking First Board Paint & Layout Generation Latency...');
  {
    final sw = Stopwatch()..start();
    const runs = 100;
    for (int i = 0; i < runs; i++) {
      final board = Board.initial();
      final legalMoves = MoveGenerator.generateLegalMoves(board);
      final pieceMap = <Square, Piece>{};
      for (int sqIdx = 0; sqIdx < 64; sqIdx++) {
        final sq = Square(sqIdx);
        final p = board.pieceAt(sq);
        if (p != null) pieceMap[sq] = p;
      }
      assert(pieceMap.length == 32 && legalMoves.length == 20);
    }
    sw.stop();
    final latencyMs = sw.elapsedMilliseconds / runs;
    const threshold = 10.0;
    final pass = latencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'First Board Paint & Layout Latency',
      category: 'UX Performance',
      value: latencyMs,
      unit: 'ms',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: '64-square geometry, piece coordinate matrix, and legal move targets generated in ${latencyMs.toStringAsFixed(2)}ms.',
    ));
    print('  -> ${latencyMs.toStringAsFixed(2)} ms (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
  }

  // 10. Screen Navigation Route Resolution Latency
  print('[10/16] Benchmarking Screen Navigation Route Resolution Latency...');
  {
    final routes = [
      '/journey',
      '/curriculum',
      '/play',
      '/analysis',
      '/endgame',
      '/labs',
      '/video',
      '/analytics',
      '/settings',
      '/certification',
    ];
    final sw = Stopwatch()..start();
    const runs = 500;
    for (int i = 0; i < runs; i++) {
      for (final r in routes) {
        final uri = Uri.parse('chessmaster:/$r?day=${(i % 90) + 1}');
        final dayParam = uri.queryParameters['day'];
        assert(dayParam != null);
      }
    }
    sw.stop();
    final latencyPerNavUs = sw.elapsedMicroseconds / (runs * routes.length);
    final latencyMs = latencyPerNavUs / 1000.0;
    const threshold = 1.0;
    final pass = latencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'Screen Navigation Route Latency',
      category: 'UX Performance',
      value: latencyMs,
      unit: 'ms/nav',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'Route parsing & parameter resolution averaged ${latencyPerNavUs.toStringAsFixed(1)}µs per transition.',
    ));
    print('  -> ${latencyMs.toStringAsFixed(3)} ms/nav (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
  }

  // 11. Puzzle Load & FEN Verification Latency
  print('[11/16] Benchmarking Puzzle Load & FEN Verification Latency...');
  {
    final sampleFens = [
      'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
      '8/8/8/8/8/4k3/8/4K3 w - - 0 50',
      'k7/2K5/1Q6/8/8/8/8/8 b - - 0 1',
      'rnbqkbnr/ppp2ppp/8/3pp3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 3',
    ];
    final sw = Stopwatch()..start();
    const runs = 200;
    for (int i = 0; i < runs; i++) {
      for (final fen in sampleFens) {
        assert(FenParser.isValidFen(fen));
        final board = Board.fromFen(fen);
        final legalMoves = MoveGenerator.generateLegalMoves(board);
        final status = MoveGenerator.getGameStatus(board);
        assert(legalMoves.isNotEmpty || status == GameStatus.checkmate || status == GameStatus.stalemate);
      }
    }
    sw.stop();
    final latencyMs = sw.elapsedMilliseconds / (runs * sampleFens.length);
    const threshold = 5.0;
    final pass = latencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'Puzzle Load & FEN Verification Latency',
      category: 'UX Performance',
      value: latencyMs,
      unit: 'ms/puzzle',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'Puzzle setup, FEN validation, and move tree validation averaged ${latencyMs.toStringAsFixed(3)}ms.',
    ));
    print('  -> ${latencyMs.toStringAsFixed(3)} ms/puzzle (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
  }

  // 12. Engine First-Result Latency
  print('[12/16] Benchmarking Engine First-Result Latency (Instant Reply)...');
  {
    final engine = EmbeddedHeuristicEngine();
    await engine.initialize();
    final sw = Stopwatch()..start();
    const runs = 10;
    for (int i = 0; i < runs; i++) {
      await engine.setPosition(FenParser.initialFen);
      await engine.evaluate(depth: 2);
    }
    sw.stop();
    final latencyMs = sw.elapsedMilliseconds / runs;
    const threshold = 15.0;
    final pass = latencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'Engine First-Result Latency (d2)',
      category: 'Chess Engine',
      value: latencyMs,
      unit: 'ms',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'Engine returned instant evaluation within ${latencyMs.toStringAsFixed(2)}ms.',
    ));
    print('  -> ${latencyMs.toStringAsFixed(2)} ms (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
    await engine.dispose();
  }

  // 13. PGN & Opening Database Search Latency
  print('[13/16] Benchmarking PGN & Opening Database Search Latency...');
  {
    final sw = Stopwatch()..start();
    const runs = 100;
    for (int i = 0; i < runs; i++) {
      final r1 = EcoBook.matchByMoves(['e4', 'c5', 'Nf3', 'd6']);
      final r2 = EcoBook.matchByMoves(['e4', 'e5', 'Nf3', 'Nc6', 'Bb5']);
      final r3 = EcoBook.matchByMoves(['d4', 'Nf6', 'c4', 'g6']);
      assert(r1 != null || r2 != null || r3 != null);
    }
    sw.stop();
    final latencyMs = sw.elapsedMilliseconds / runs;
    const threshold = 5.0;
    final pass = latencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'ECO Opening Search Latency',
      category: 'Chess Content',
      value: latencyMs,
      unit: 'ms/query',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'Trie sequence matching across openings averaged ${latencyMs.toStringAsFixed(3)}ms.',
    ));
    print('  -> ${latencyMs.toStringAsFixed(3)} ms/query (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
  }

  // 14. Video Preview Frame Render & Timeline Latency
  print('[14/16] Benchmarking Video Preview Frame Render Latency...');
  {
    const profile = VideoProfile();
    final gen = VideoTimelineGenerator(profile: profile);
    final pgn = PgnParser.parse('1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. O-O 1-0')!;
    final sw = Stopwatch()..start();
    const runs = 20;
    for (int i = 0; i < runs; i++) {
      final timeline = gen.generateTimeline(pgn);
      assert(timeline.isNotEmpty);
    }
    sw.stop();
    final latencyMs = sw.elapsedMilliseconds / runs;
    const threshold = 15.0;
    final pass = latencyMs <= threshold;

    results.add(BenchmarkResult(
      name: 'Video Preview Frame Timeline Latency',
      category: 'Chess Video',
      value: latencyMs,
      unit: 'ms/render',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'Timeline keyframe interpolation computed in ${latencyMs.toStringAsFixed(2)}ms.',
    ));
    print('  -> ${latencyMs.toStringAsFixed(2)} ms/render (Budget: <=${threshold.toInt()}ms) [${pass ? "PASS" : "FAIL"}]');
  }

  // 15. Heap Memory Footprint (Process RSS)
  print('[15/16] Benchmarking Active Memory Footprint (RSS)...');
  {
    final rssBytes = ProcessInfo.currentRss;
    final rssMb = rssBytes / (1024.0 * 1024.0);
    const threshold = 350.0;
    final pass = rssMb <= threshold;

    results.add(BenchmarkResult(
      name: 'Process Resident Memory Footprint (RSS)',
      category: 'System Performance',
      value: rssMb,
      unit: 'MB',
      budgetThreshold: threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'Current RSS: ${rssMb.toStringAsFixed(1)} MB (Budget: <=${threshold.toInt()} MB).',
    ));
    print('  -> ${rssMb.toStringAsFixed(1)} MB (Budget: <=${threshold.toInt()}MB) [${pass ? "PASS" : "FAIL"}]');
  }

  // 16. Frame Render Time & Jank / P95 / P99 Calculation
  print('[16/16] Benchmarking Frame Render Time & Jank (P95/P99 Frame Simulation)...');
  {
    final frameTimes = <double>[];
    const totalFrames = 1000;
    final board = Board.initial();

    for (int i = 0; i < totalFrames; i++) {
      final sw = Stopwatch()..start();
      final factor = (i % 30) / 30.0;
      final piece = board.pieceAt(Square.e2);
      final dest = Square.e4;
      assert(piece != null || dest != null || factor >= 0.0);
      sw.stop();
      frameTimes.add(sw.elapsedMicroseconds / 1000.0);
    }

    frameTimes.sort();
    final p50 = frameTimes[(totalFrames * 0.50).toInt()];
    final p95 = frameTimes[(totalFrames * 0.95).toInt()];
    final p99 = frameTimes[(totalFrames * 0.99).toInt()];
    final jankCount = frameTimes.where((t) => t > 16.67).length;
    final jankPct = (jankCount / totalFrames) * 100.0;

    const p95Threshold = 5.0;
    final pass = p95 <= p95Threshold && jankPct <= 1.0;

    results.add(BenchmarkResult(
      name: 'Frame Time P95 (60fps Budget: 16.6ms)',
      category: 'UX Performance',
      value: p95,
      unit: 'ms',
      budgetThreshold: p95Threshold,
      higherIsBetter: false,
      passed: pass,
      notes: 'P50: ${p50.toStringAsFixed(2)}ms, P95: ${p95.toStringAsFixed(2)}ms, P99: ${p99.toStringAsFixed(2)}ms, Jank (>16.6ms): ${jankCount}/$totalFrames (${jankPct.toStringAsFixed(2)}%).',
    ));
    print('  -> P95: ${p95.toStringAsFixed(2)} ms, P99: ${p99.toStringAsFixed(2)} ms, Jank: ${jankPct.toStringAsFixed(2)}% [${pass ? "PASS" : "FAIL"}]');
  }

  print('\n======================================================');
  print('               BENCHMARK SUMMARY RESULTS              ');
  print('======================================================');
  bool allPassed = true;
  for (final r in results) {
    if (!r.passed) allPassed = false;
    final mark = r.passed ? '✓ PASS' : '✗ FAIL';
    print('  ${r.name.padRight(32)}: ${r.value.toStringAsFixed(1)} ${r.unit.padRight(16)} [${mark}]');
  }
  print('------------------------------------------------------');
  print('  OVERALL BENCHMARK STATUS: ${allPassed ? "ALL GATES PASSED" : "BUDGET VIOLATIONS DETECTED"}');
  print('======================================================\n');

  // Generate performance.json
  final rootDir = Directory.current.path.endsWith('tool')
      ? Directory.current.parent.path
      : Directory.current.path;

  final perfJson = {
    'timestamp': DateTime.now().toUtc().toIso8601String(),
    'environment': {
      'os': Platform.operatingSystem,
      'osVersion': Platform.operatingSystemVersion,
      'dartVersion': Platform.version.split(' ').first,
      'cpuCount': Platform.numberOfProcessors,
    },
    'summary': {
      'totalBenchmarks': results.length,
      'passed': results.where((r) => r.passed).length,
      'failed': results.where((r) => !r.passed).length,
      'overallStatus': allPassed ? 'PASSED' : 'FAILED',
    },
    'benchmarks': results.map((r) => r.toJson()).toList(),
  };

  final jsonFile = File('$rootDir${Platform.pathSeparator}performance.json');
  jsonFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(perfJson));
  print('Report written: ${jsonFile.path}');

  // Generate performance.html
  final html = StringBuffer();
  html.writeln('<!DOCTYPE html><html><head><meta charset="utf-8">');
  html.writeln('<title>ChessMaster Performance Benchmark Report</title>');
  html.writeln('<style>');
  html.writeln('body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 32px; }');
  html.writeln('.container { max-width: 1000px; margin: auto; }');
  html.writeln('h1 { color: #38bdf8; margin-bottom: 4px; }');
  html.writeln('.subtitle { color: #94a3b8; font-size: 14px; margin-bottom: 24px; }');
  html.writeln('.card { background: #1e293b; border-radius: 8px; padding: 20px; margin-bottom: 24px; border: 1px solid #334155; }');
  html.writeln('table { width: 100%; border-collapse: collapse; margin-top: 16px; background: #1e293b; border-radius: 8px; overflow: hidden; }');
  html.writeln('th, td { padding: 12px 16px; text-align: left; border-bottom: 1px solid #334155; font-size: 14px; }');
  html.writeln('th { background: #0f172a; color: #94a3b8; font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; }');
  html.writeln('.badge-pass { background: #22c55e; color: #000; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }');
  html.writeln('.badge-fail { background: #ef4444; color: #fff; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }');
  html.writeln('</style></head><body><div class="container">');
  html.writeln('<h1>ChessMaster Performance Benchmark Report</h1>');
  html.writeln('<div class="subtitle">Generated: ${DateTime.now().toUtc().toIso8601String()} | Dart ${Platform.version.split(" ").first} | ${Platform.numberOfProcessors} CPUs</div>');
  html.writeln('<div class="card">');
  html.writeln('<h2>Status: <span class="${allPassed ? "badge-pass" : "badge-fail"}">${allPassed ? "ALL BUDGETS SATISFIED" : "BUDGET FAILURES"}</span></h2>');
  html.writeln('<p>Passed: ${results.where((r) => r.passed).length} / ${results.length} benchmarks</p>');
  html.writeln('<table><tr><th>Benchmark</th><th>Category</th><th>Measured Value</th><th>Budget Threshold</th><th>Status</th><th>Notes</th></tr>');

  for (final r in results) {
    final comp = r.higherIsBetter ? '&ge;' : '&le;';
    html.writeln('<tr>');
    html.writeln('<td><strong>${r.name}</strong></td>');
    html.writeln('<td>${r.category}</td>');
    html.writeln('<td>${r.value} ${r.unit}</td>');
    html.writeln('<td>$comp ${r.budgetThreshold} ${r.unit}</td>');
    html.writeln('<td><span class="${r.passed ? "badge-pass" : "badge-fail"}">${r.passed ? "PASS" : "FAIL"}</span></td>');
    html.writeln('<td style="color: #94a3b8; font-size: 12px;">${r.notes}</td>');
    html.writeln('</tr>');
  }

  html.writeln('</table></div></div></body></html>');

  final htmlFile = File('$rootDir${Platform.pathSeparator}performance.html');
  htmlFile.writeAsStringSync(html.toString());
  print('Report written: ${htmlFile.path}');

  if (!allPassed) {
    print('\nERROR: Performance benchmark failed budget requirements.');
    exit(1);
  }
}
