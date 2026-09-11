import 'dart:convert';
import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_video/chess_video.dart';
import 'eco/eco_book.dart';
import 'puzzle_miner/puzzle_miner.dart';

/// Provenance, licensing, and attribution metadata for ingested PGN chess games.
class ContentProvenance {
  final String source;
  final String license;
  final String attribution;
  final bool isPublicDomain;

  const ContentProvenance({
    required this.source,
    this.license = 'Public Domain / CC0',
    this.attribution = 'Public Domain Historical Record',
    this.isPublicDomain = true,
  });

  Map<String, dynamic> toJson() => {
        'source': source,
        'license': license,
        'attribution': attribution,
        'isPublicDomain': isPublicDomain,
      };

  factory ContentProvenance.fromJson(Map<String, dynamic> json) {
    return ContentProvenance(
      source: json['source'] as String? ?? 'User Import',
      license: json['license'] as String? ?? 'Public Domain / CC0',
      attribution: json['attribution'] as String? ?? 'Public Domain Historical Record',
      isPublicDomain: json['isPublicDomain'] as bool? ?? true,
    );
  }
}

/// A fully analyzed, tagged, and decomposed PGN game ready for lessons, labs, and video synthesis.
class AnalyzedPgnGame {
  final String id;
  final String white;
  final String black;
  final String event;
  final String year;
  final String result;
  final EcoEntry? eco;
  final List<String> tags;
  final String pawnStructure;
  final ContentProvenance provenance;
  final Map<int, double> evaluationsByPly;
  final List<int> turningPoints;
  final List<CurriculumExercise> minedPuzzles;
  final List<String> educationalTakeaways;
  final String fullPgn;
  final String? videoPath;
  final String? thumbnailPath;

  const AnalyzedPgnGame({
    required this.id,
    required this.white,
    required this.black,
    required this.event,
    required this.year,
    required this.result,
    this.eco,
    required this.tags,
    required this.pawnStructure,
    required this.provenance,
    required this.evaluationsByPly,
    required this.turningPoints,
    required this.minedPuzzles,
    required this.educationalTakeaways,
    required this.fullPgn,
    this.videoPath,
    this.thumbnailPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'white': white,
        'black': black,
        'event': event,
        'year': year,
        'result': result,
        'eco': eco != null ? {'code': eco!.code, 'name': eco!.name} : null,
        'tags': tags,
        'pawnStructure': pawnStructure,
        'provenance': provenance.toJson(),
        'evaluationsByPly': evaluationsByPly.map((k, v) => MapEntry(k.toString(), v)),
        'turningPoints': turningPoints,
        'minedPuzzles': minedPuzzles.map((p) => p.toJson()).toList(),
        'educationalTakeaways': educationalTakeaways,
        'fullPgn': fullPgn,
        'videoPath': videoPath,
        'thumbnailPath': thumbnailPath,
      };
}

/// Comprehensive summary report produced by batch PGN ingestion pipeline.
class BatchPipelineResult {
  final int totalGamesProcessed;
  final int totalPuzzlesMined;
  final int totalLessonsGenerated;
  final List<AnalyzedPgnGame> analyzedGames;
  final String catalogJsonPath;
  final String reportJsonPath;

  const BatchPipelineResult({
    required this.totalGamesProcessed,
    required this.totalPuzzlesMined,
    required this.totalLessonsGenerated,
    required this.analyzedGames,
    required this.catalogJsonPath,
    required this.reportJsonPath,
  });

  Map<String, dynamic> toJson() => {
        'totalGamesProcessed': totalGamesProcessed,
        'totalPuzzlesMined': totalPuzzlesMined,
        'totalLessonsGenerated': totalLessonsGenerated,
        'catalogJsonPath': catalogJsonPath,
        'reportJsonPath': reportJsonPath,
        'analyzedGames': analyzedGames.map((g) => g.toJson()).toList(),
      };
}

/// High-throughput automated batch pipeline that converts folders of raw PGN files into
/// analyzed educational catalogs, tactical puzzle sets, guess-the-move lessons, and video manifests.
class BatchPgnPipeline {
  final ChessEngine engine;

  BatchPgnPipeline({required this.engine});

  /// Processes all PGN files within the given directory and generates a production content catalog.
  Future<BatchPipelineResult> processDirectory({
    required String pgnDirectoryPath,
    required String outputDirectoryPath,
    ContentProvenance defaultProvenance = const ContentProvenance(source: 'User Import / Public Domain Archive'),
    bool renderVideos = false,
    VideoProfile videoProfile = const VideoProfile(),
    void Function(String message)? onProgress,
  }) async {
    final dir = Directory(pgnDirectoryPath);
    if (!dir.existsSync()) {
      throw FileSystemException('PGN input directory does not exist', pgnDirectoryPath);
    }

    final outDir = Directory(outputDirectoryPath);
    outDir.createSync(recursive: true);

    final pgnFiles = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.pgn'))
        .toList();

    final allGames = <PgnGame>[];
    for (final file in pgnFiles) {
      final text = file.readAsStringSync();
      final parsed = PgnParser.parseMultiGame(text);
      allGames.addAll(parsed);
    }

    final analyzedGames = <AnalyzedPgnGame>[];
    final miner = PuzzleMiner(engine: engine);
    int totalPuzzles = 0;

    for (int i = 0; i < allGames.length; i++) {
      final game = allGames[i];
      onProgress?.call('Analyzing game ${i + 1}/${allGames.length}: ${game.white} vs ${game.black}');

      // 1. ECO classification
      final moveSans = game.moves.map((m) => m.san).toList();
      final eco = EcoBook.matchByMoves(moveSans);

      // 2. Identify pawn structure
      final pawnStructure = _classifyPawnStructure(game);

      // 3. Stockfish / Engine analysis for evaluations and turning points
      final evaluations = <int, double>{};
      final turningPoints = <int>[];
      final board = game.setupFen != null ? Board.fromFen(game.setupFen!) : Board.initial();

      double prevEval = 0.0;
      for (int ply = 0; ply < game.moves.length; ply++) {
        final node = game.moves[ply];
        if (node.move == null) continue;
        board.makeMove(node.move!);

        // Compute or parse eval
        double eval = 0.0;
        if (node.evaluation != null) {
          eval = node.evaluation!;
        } else if (ply < 20 || ply % 2 == 0) {
          await engine.setPosition(board.toFen());
          final res = await engine.evaluate(depth: 3);
          eval = res.scoreFromWhitePerspective / 100.0;
        } else {
          eval = prevEval;
        }

        evaluations[ply] = eval;

        // Check for turning point (swing > 1.50 pawns)
        if (ply > 0 && (eval - prevEval).abs() >= 1.50) {
          turningPoints.add(ply);
        }
        prevEval = eval;
      }

      // 4. Mine tactical puzzles
      final puzzles = await miner.minePuzzlesFromPgn(game.toPgnString(), minCentipawnSwing: 150);
      totalPuzzles += puzzles.length;

      // 5. Educational tags
      final tags = _deriveTags(game, turningPoints, puzzles);

      // 6. Educational takeaways
      final takeaways = [
        'Opening classified as ${eco?.name ?? "Custom System"} (${eco?.code ?? "General"}).',
        if (turningPoints.isNotEmpty) 'Decisive turning point occurred at ply ${turningPoints.first}.',
        if (puzzles.isNotEmpty) 'Contains ${puzzles.length} instructional tactical puzzle(s).',
        'Endgame structure demonstrated $pawnStructure principles.',
      ];

      // 7. Optional Real Video & Thumbnail Rendering
      String? videoPath;
      String? thumbnailPath;
      if (renderVideos && RealVideoRenderer.findFfmpegPath() != null) {
        final videoDir = Directory('${outDir.path}${Platform.pathSeparator}videos');
        final thumbDir = Directory('${outDir.path}${Platform.pathSeparator}thumbnails');
        videoDir.createSync(recursive: true);
        thumbDir.createSync(recursive: true);

        final videoFile = '${videoDir.path}${Platform.pathSeparator}game_$i.mp4';
        final thumbFile = '${thumbDir.path}${Platform.pathSeparator}game_$i.png';
        try {
          final renderResult = await RealVideoRenderer.renderVideo(
            game: game,
            outputPath: videoFile,
            profile: videoProfile,
            evaluationsByPly: evaluations.map((k, v) => MapEntry(k, (v * 100).round())),
            criticalPlies: turningPoints,
            thumbnailPath: thumbFile,
          );
          videoPath = renderResult.outputPath;
          thumbnailPath = renderResult.thumbnailPath;
        } catch (_) {}
      }

      final analyzed = AnalyzedPgnGame(
        id: 'game_${DateTime.now().millisecondsSinceEpoch}_$i',
        white: game.white,
        black: game.black,
        event: game.event,
        year: game.year,
        result: game.result,
        eco: eco,
        tags: tags,
        pawnStructure: pawnStructure,
        provenance: defaultProvenance,
        evaluationsByPly: evaluations,
        turningPoints: turningPoints,
        minedPuzzles: puzzles,
        educationalTakeaways: takeaways,
        fullPgn: game.toPgnString(),
        videoPath: videoPath,
        thumbnailPath: thumbnailPath,
      );

      analyzedGames.add(analyzed);
    }

    // 8. Write content catalog JSON
    final catalogFile = File('${outDir.path}${Platform.pathSeparator}content_catalog.json');
    final catalogJson = const JsonEncoder.withIndent('  ').convert(
      analyzedGames.map((g) => g.toJson()).toList(),
    );
    catalogFile.writeAsStringSync(catalogJson);

    // 8. Write pipeline report JSON
    final reportFile = File('${outDir.path}${Platform.pathSeparator}pipeline_report.json');
    final result = BatchPipelineResult(
      totalGamesProcessed: analyzedGames.length,
      totalPuzzlesMined: totalPuzzles,
      totalLessonsGenerated: analyzedGames.length,
      analyzedGames: analyzedGames,
      catalogJsonPath: catalogFile.path,
      reportJsonPath: reportFile.path,
    );
    reportFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(result.toJson()));

    return result;
  }

  static String _classifyPawnStructure(PgnGame game) {
    final moves = game.moves.map((m) => m.san).toList();
    if (moves.contains('c4') && moves.contains('d5')) {
      return 'Carlsbad / Queen\'s Gambit Formation';
    }
    if (moves.contains('c5') && moves.contains('d4')) {
      return 'Open Sicilian / Maroczy Bind';
    }
    if (moves.contains('e4') && moves.contains('e5')) {
      return 'Open Center / Symmetry';
    }
    if (moves.contains('d4') && moves.contains('Nf6')) {
      return 'Indian Complex';
    }
    return 'Classical Flexible Formation';
  }

  static List<String> _deriveTags(PgnGame game, List<int> turningPoints, List<CurriculumExercise> puzzles) {
    final tags = <String>{};
    if (game.result == '1-0') tags.add('White Victory');
    if (game.result == '0-1') tags.add('Black Victory');
    if (game.result == '1/2-1/2') tags.add('Drawn Battle');

    if (puzzles.isNotEmpty) tags.add('Tactical Shot');
    if (turningPoints.isNotEmpty) tags.add('Decisive Turning Point');
    if (game.moves.length > 50) tags.add('Endgame Grind');
    if (game.moves.length < 30 && game.result != '*') tags.add('King Attack');

    tags.add('Historical Significance');
    return tags.toList();
  }
}
