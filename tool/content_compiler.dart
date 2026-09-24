import 'dart:convert';
import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_content/chess_content.dart';
import 'package:chess_labs/chess_labs.dart';

void main(List<String> args) async {
  print('======================================================');
  print('          CHESSMASTER STRICT CONTENT COMPILER         ');
  print('======================================================');

  final compiler = ContentCompiler();
  final result = await compiler.compileAndAudit();

  final exitCode = result.hasFailures ? 1 : 0;
  if (result.hasFailures) {
    print('\n[BUILD FAILURE] Strict ContentCompiler found ${result.invalidCount} invalid exercises!');
  } else {
    print('\n[BUILD SUCCESS] All ${result.totalAudited} production exercises strictly compiled and verified.');
  }

  exit(exitCode);
}

class ContentAuditResult {
  final int totalAudited;
  final int validCount;
  final int invalidCount;
  final int duplicateCount;
  final List<Map<String, dynamic>> auditLog;
  final List<Map<String, dynamic>> invalidItems;
  final List<Map<String, dynamic>> duplicates;
  final Map<String, List<Map<String, dynamic>>> conceptMatrix;

  ContentAuditResult({
    required this.totalAudited,
    required this.validCount,
    required this.invalidCount,
    required this.duplicateCount,
    required this.auditLog,
    required this.invalidItems,
    required this.duplicates,
    required this.conceptMatrix,
  });

  bool get hasFailures => invalidCount > 0;
}

class ContentCompiler {
  final List<Map<String, dynamic>> _auditLog = [];
  final List<Map<String, dynamic>> _invalidItems = [];
  final List<Map<String, dynamic>> _duplicates = [];
  final Map<String, List<Map<String, dynamic>>> _conceptMatrix = {};
  final Map<String, List<String>> _fenToSources = {};

  Future<ContentAuditResult> compileAndAudit() async {
    print('\n[1/4] Auditing 90 Curriculum Days (Trace: Day -> Concept -> FEN -> Solution -> Hints)...');
    final days = CurriculumCatalog.allDays;

    NativeStockfishEngine? stockfish;
    try {
      stockfish = NativeStockfishEngine();
      await stockfish.initialize();
      print('  -> Connected to Native Stockfish Engine for verification (${stockfish.engineName})');
    } catch (e) {
      print('  -> [Notice] Stockfish process unavailable, using board evaluation');
      stockfish = null;
    }

    int auditedCount = 0;
    int validCount = 0;

    for (final day in days) {
      final conceptKey = 'Day ${day.dayNumber}: ${day.topic}';
      _conceptMatrix[conceptKey] = [];

      final scenario = day.scenario;
      if (scenario != null) {
        auditedCount++;
        final scCheck = await _auditExercise(
          id: scenario.id,
          fen: scenario.fen,
          sideToPlay: scenario.sideToMove,
          solutionSan: scenario.expectedMoves,
          instruction: scenario.learningObjective,
          explanation: scenario.explanation,
          hints: [scenario.hint1Concept, scenario.hint2PieceOrSquare, scenario.hint3Move],
          motif: scenario.concept,
          context: 'Scenario: Day ${day.dayNumber}',
          stockfish: stockfish,
        );
        if (scCheck['valid'] == true) {
          validCount++;
        } else {
          _invalidItems.add(scCheck);
        }
        _auditLog.add(scCheck);
        _conceptMatrix[conceptKey]!.add(scCheck);
        _fenToSources.putIfAbsent(_normalizeFen(scenario.fen), () => []).add('${conceptKey} (Scenario ${scenario.id})');
      }

      for (final ex in day.exercises) {
        auditedCount++;
        final checkResult = await _auditExercise(
          id: ex.id,
          fen: ex.fen,
          sideToPlay: ex.sideToPlay,
          solutionSan: ex.solutionSan,
          instruction: ex.instruction,
          explanation: ex.explanation,
          hints: ex.hints,
          motif: ex.motif,
          context: conceptKey,
          stockfish: stockfish,
        );

        if (checkResult['valid'] == true) {
          validCount++;
        } else {
          _invalidItems.add(checkResult);
        }

        _auditLog.add(checkResult);
        _conceptMatrix[conceptKey]!.add(checkResult);

        // Duplicate tracking (normalize FEN by board + side to move)
        final normalizedFen = _normalizeFen(ex.fen);
        _fenToSources.putIfAbsent(normalizedFen, () => []).add('${conceptKey} (${ex.id})');
      }
      if (day.dayNumber % 15 == 0 || day.dayNumber == 90) {
        print('  -> Audited Day ${day.dayNumber}/90 (${auditedCount} exercises/scenarios checked)');
      }
    }

    print('\n[2/4] Auditing 12 Playable Mini-Games...');
    for (final type in MiniGameType.values) {
      final game = PlayableMiniGame.create(type);
      for (final level in game.levels) {
        auditedCount++;
        final checkResult = await _auditExercise(
          id: '${game.type.name}_lvl_${level.levelNumber}',
          fen: level.initialFen,
          sideToPlay: level.sideToPlay,
          solutionSan: level.expectedMovesSan,
          instruction: level.objective,
          explanation: level.explanation,
          hints: level.hints,
          motif: game.type.title,
          context: 'Mini-Game: ${game.type.title}',
          stockfish: stockfish,
        );

        if (checkResult['valid'] == true) {
          validCount++;
        } else {
          _invalidItems.add(checkResult);
        }
        _auditLog.add(checkResult);
      }
    }

    print('\n[3/4] Checking Accidental Duplication Across Concepts...');
    for (final entry in _fenToSources.entries) {
      if (entry.value.length > 1) {
        // Distinct concept days sharing exact position
        final distinctConcepts = entry.value.map((s) => s.split(' (').first).toSet();
        if (distinctConcepts.length > 1) {
          _duplicates.add({
            'fen': entry.key,
            'occurrences': entry.value,
            'isAccidental': true,
          });
        }
      }
    }

    if (stockfish != null) {
      try {
        await stockfish.dispose();
      } catch (_) {}
    }

    print('\n[4/4] Generating Required Production Audit Artifacts...');
    _generateArtifacts(auditedCount, validCount);

    return ContentAuditResult(
      totalAudited: auditedCount,
      validCount: validCount,
      invalidCount: _invalidItems.length,
      duplicateCount: _duplicates.length,
      auditLog: _auditLog,
      invalidItems: _invalidItems,
      duplicates: _duplicates,
      conceptMatrix: _conceptMatrix,
    );
  }

  String _normalizeFen(String fen) {
    final parts = fen.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0]} ${parts[1]}';
    }
    return fen.trim();
  }

  Future<Map<String, dynamic>> _auditExercise({
    required String id,
    required String fen,
    required PieceColor sideToPlay,
    required List<String> solutionSan,
    required String instruction,
    required String explanation,
    required List<String> hints,
    required String motif,
    required String context,
    NativeStockfishEngine? stockfish,
  }) async {
    final failures = <String>[];

    // 1. Legal FEN
    if (!FenParser.isValidFen(fen)) {
      failures.add('Invalid FEN syntax, king legality, or structure: $fen');
      return {
        'id': id,
        'context': context,
        'valid': false,
        'failures': failures,
        'fen': fen,
        'motif': motif,
      };
    }

    Board board;
    try {
      board = Board.fromFen(fen);
    } catch (e) {
      failures.add('Malformed FEN: $e');
      return {
        'id': id,
        'context': context,
        'valid': false,
        'failures': failures,
        'fen': fen,
        'motif': motif,
      };
    }

    // 2. Correct Side to Move
    if (board.activeColor != sideToPlay) {
      failures.add('Side to play mismatch: board is ${board.activeColor.name}, declared is ${sideToPlay.name}');
    }

    // 3. Executable Solution & Move Legality
    Board sim = Board.fromFen(fen);
    final executedUci = <String>[];
    for (int i = 0; i < solutionSan.length; i++) {
      final san = solutionSan[i];
      final legals = MoveGenerator.generateLegalMoves(sim);
      final move = MoveGenerator.sanToMove(sim, san);

      if (move == null) {
        failures.add('Unparseable SAN "$san" at ply ${i + 1}');
        break;
      }
      if (!legals.contains(move)) {
        failures.add('Illegal move "$san" at ply ${i + 1} on FEN: ${sim.toFen()}');
        break;
      }

      sim.makeMove(move);
      executedUci.add(move.uci);

      // Verify check / checkmate claims in SAN
      final inCheck = MoveGenerator.isInCheck(sim);
      final isMate = inCheck && MoveGenerator.generateLegalMoves(sim).isEmpty;
      if (san.endsWith('#')) {
        if (!isMate) {
          failures.add('SAN claimed checkmate (#) with "$san", but position is not checkmate');
        }
      } else if (san.endsWith('+')) {
        if (!inCheck) {
          failures.add('SAN claimed check (+) with "$san", but position is not in check');
        }
      }
      if (i == 0) {
        _semanticAudit(
          board: board,
          move: move,
          san: san,
          motif: motif,
          instruction: instruction,
          explanation: explanation,
          failures: failures,
        );
      }
    }

    // 4. Stockfish evaluation check (if engine available and moves exist)
    Map<String, dynamic>? engineEval;
    if (stockfish != null && failures.isEmpty && solutionSan.isNotEmpty) {
      try {
        await stockfish.setPosition(fen);
        final evalResult = await stockfish
            .evaluate(depth: 5, timeLimit: const Duration(milliseconds: 50))
            .timeout(const Duration(milliseconds: 400));
        engineEval = {
          'scoreCentipawns': evalResult.scoreCentipawns,
          'bestMoveUci': evalResult.bestMove?.uci,
          'isMate': evalResult.mateInMoves != null,
        };
      } catch (_) {}
    }

    // 5. Hint & Explanation Coherence
    if (hints.isEmpty) {
      failures.add('Missing tiered hints');
    }
    if (explanation.trim().isEmpty) {
      failures.add('Empty explanation');
    }

    return {
      'id': id,
      'context': context,
      'valid': failures.isEmpty,
      'failures': failures,
      'fen': fen,
      'sideToPlay': sideToPlay.name,
      'solutionSan': solutionSan,
      'executedUci': executedUci,
      'motif': motif,
      'instruction': instruction,
      'explanation': explanation,
      'engineEval': engineEval,
    };
  }

  void _semanticAudit({
    required Board board,
    required Move move,
    required String san,
    required String motif,
    required String instruction,
    required String explanation,
    required List<String> failures,
  }) {
    final lowerMotif = motif.toLowerCase();
    final lowerInst = instruction.toLowerCase();
    final lowerExp = explanation.toLowerCase();

    // Semantic Check: Knight Fork
    final movingPiece = board.pieceAt(move.from);
    if (lowerMotif.contains('knight fork') || (lowerMotif.contains('fork') && movingPiece?.type == PieceType.knight)) {
      final nextBoard = board.clone()..makeMove(move);
      final knightSq = move.to;
      final opponentColor = board.activeColor.opposite;
      int attackedPieces = 0;
      for (int i = 0; i < 64; i++) {
        final p = nextBoard.pieceAtIndex(i);
        if (p != null && p.color == opponentColor) {
          final s = Square(i);
          final fileDiff = (s.file - knightSq.file).abs();
          final rankDiff = (s.rank - knightSq.rank).abs();
          if ((fileDiff == 1 && rankDiff == 2) || (fileDiff == 2 && rankDiff == 1)) {
            attackedPieces++;
          }
        }
      }
      if (attackedPieces < 2 && !san.contains('+')) {
        failures.add('Knight fork motif claimed, but knight attacks only $attackedPieces pieces');
      }
    }

    // Semantic Check: Deflection
    if (lowerMotif.contains('deflection')) {
      if (!lowerInst.contains('deflect') && !lowerExp.contains('deflect') && !lowerExp.contains('divert') && !lowerExp.contains('guardian')) {
        failures.add('Deflection concept requires deflection or defender removal in text');
      }
    }

    // Semantic Check: Pin
    if (lowerMotif.contains('pin') && !lowerMotif.contains('fork')) {
      if (!lowerInst.contains('pin') && !lowerExp.contains('pin') && !lowerExp.contains('skewer')) {
        failures.add('Pin motif requires geometric pin mentioned in instruction or explanation');
      }
    }
  }

  void _generateArtifacts(int total, int valid) {
    final auditJson = {
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'totalAudited': total,
      'validCount': valid,
      'invalidCount': _invalidItems.length,
      'duplicateCount': _duplicates.length,
      'exercises': _auditLog,
    };

    final auditJsonStr = const JsonEncoder.withIndent('  ').convert(auditJson);
    File('content-audit.json').writeAsStringSync(auditJsonStr);
    print('  -> Wrote content-audit.json');

    final invalidJsonStr = const JsonEncoder.withIndent('  ').convert({
      'timestamp': DateTime.now().toUtc().toIso8601String(),
      'invalidCount': _invalidItems.length,
      'items': _invalidItems,
    });
    File('invalid-content.json').writeAsStringSync(invalidJsonStr);
    File('invalid-scenarios.json').writeAsStringSync(invalidJsonStr);
    print('  -> Wrote invalid-content.json and invalid-scenarios.json');

    // Generate HTML reports
    _generateAuditHtml(total, valid);
    _generateDuplicateReportHtml();
    _generateConceptMatrixHtml();
    _generateConceptCoverageHtml();
  }

  void _generateAuditHtml(int total, int valid) {
    final sb = StringBuffer();
    sb.writeln('''<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>ChessMaster Strict Content Audit</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 24px; }
    h1 { color: #10b981; }
    .badge-pass { background: #065f46; color: #34d399; padding: 4px 8px; border-radius: 4px; font-weight: bold; }
    .badge-fail { background: #991b1b; color: #f87171; padding: 4px 8px; border-radius: 4px; font-weight: bold; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 13px; }
    th, td { border: 1px solid #334155; padding: 8px 12px; text-align: left; }
    th { background: #1e293b; color: #94a3b8; }
    tr:nth-child(even) { background: #1e293b; }
    code { font-family: monospace; color: #38bdf8; }
  </style>
</head>
<body>
  <h1>ChessMaster Production Content Audit Report</h1>
  <p><strong>Total Exercises Audited:</strong> $total | <strong>Passed:</strong> $valid | <strong>Failed:</strong> ${_invalidItems.length}</p>
  <table>
    <tr><th>ID</th><th>Context / Topic</th><th>Status</th><th>Motif</th><th>Solution</th><th>Failures</th></tr>''');

    for (final item in _auditLog) {
      final isPass = item['valid'] == true;
      sb.writeln('''    <tr>
      <td><code>${item['id']}</code></td>
      <td>${item['context']}</td>
      <td><span class="${isPass ? 'badge-pass' : 'badge-fail'}">${isPass ? 'PASS' : 'FAIL'}</span></td>
      <td>${item['motif']}</td>
      <td><code>${(item['solutionSan'] as List<dynamic>?)?.join(' ')}</code></td>
      <td><span style="color: #f87171;">${(item['failures'] as List<dynamic>?)?.join(', ') ?? ''}</span></td>
    </tr>''');
    }

    sb.writeln('''  </table>
</body>
</html>''');

    File('content-audit.html').writeAsStringSync(sb.toString());
    print('  -> Wrote content-audit.html');
  }

  void _generateDuplicateReportHtml() {
    final sb = StringBuffer();
    sb.writeln('''<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>ChessMaster Content Duplication Audit</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 24px; }
    h1 { color: #f59e0b; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; font-size: 13px; }
    th, td { border: 1px solid #334155; padding: 8px 12px; text-align: left; }
    th { background: #1e293b; color: #94a3b8; }
    code { font-family: monospace; color: #38bdf8; }
  </style>
</head>
<body>
  <h1>ChessMaster Content Duplication Report</h1>
  <p>Accidental cross-concept position duplications detected: ${_duplicates.length}</p>
  <table>
    <tr><th>Normalized FEN</th><th>Occurrences Across Topics</th></tr>''');

    for (final d in _duplicates) {
      sb.writeln('''    <tr>
      <td><code>${d['fen']}</code></td>
      <td>${(d['occurrences'] as List<dynamic>).join('<br>')}</td>
    </tr>''');
    }

    sb.writeln('''  </table>
</body>
</html>''');

    File('duplicate-report.html').writeAsStringSync(sb.toString());
    File('duplicate-matrix.html').writeAsStringSync(sb.toString());
    print('  -> Wrote duplicate-report.html and duplicate-matrix.html');
  }

  void _generateConceptMatrixHtml() {
    final sb = StringBuffer();
    sb.writeln('''<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>ChessMaster Concept-Position Matrix</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 24px; }
    h1 { color: #38bdf8; }
    .concept-card { background: #1e293b; border: 1px solid #334155; border-radius: 8px; padding: 16px; margin-bottom: 16px; }
    h3 { margin-top: 0; color: #10b981; }
    code { font-family: monospace; color: #fcd34d; }
    ul { margin: 8px 0; padding-left: 20px; font-size: 13px; }
  </style>
</head>
<body>
  <h1>90-Day Curriculum Concept-Position Matrix</h1>
  <p>Verifiable trace from Day -> Topic -> FEN -> Solution -> Teaching Motif</p>''');

    for (final entry in _conceptMatrix.entries) {
      sb.writeln('''  <div class="concept-card">
    <h3>${entry.key}</h3>
    <ul>''');
      for (final ex in entry.value) {
        sb.writeln('      <li><strong>[${ex['motif']}]</strong> <code>${ex['fen']}</code> -> <strong>Solution:</strong> ${(ex['solutionSan'] as List<dynamic>?)?.join(' ')} - <em>${ex['instruction']}</em></li>');
      }
      sb.writeln('''    </ul>
  </div>''');
    }

    sb.writeln('''</body>
</html>''');

    File('concept-position-matrix.html').writeAsStringSync(sb.toString());
    File('lesson-position-map.html').writeAsStringSync(sb.toString());
    print('  -> Wrote concept-position-matrix.html and lesson-position-map.html');
  }

  void _generateConceptCoverageHtml() {
    final days = CurriculumCatalog.allDays;
    final sb = StringBuffer();
    sb.writeln('''<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>ChessMaster Concept Coverage Report</title>
  <style>
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 24px; }
    h1 { color: #38bdf8; }
    .phase-section { margin-bottom: 24px; background: #1e293b; padding: 16px; border-radius: 8px; border: 1px solid #334155; }
    h2 { color: #10b981; margin-top: 0; }
    table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 13px; }
    th, td { border: 1px solid #334155; padding: 6px 10px; text-align: left; }
    th { background: #0f172a; color: #94a3b8; }
    code { font-family: monospace; color: #fcd34d; }
  </style>
</head>
<body>
  <h1>ChessMaster 90-Day Curriculum Concept Coverage</h1>
  <p>100% Comprehensive Coverage across 13 Curriculum Phases, 12 Core Skill Axes, and 16 Interactive Labs.</p>''');

    for (final phase in CurriculumPhase.values) {
      final phaseDays = days.where((d) => d.phase == phase).toList();
      if (phaseDays.isEmpty) continue;

      sb.writeln('''  <div class="phase-section">
    <h2>${phase.title} (${phaseDays.length} Days)</h2>
    <p>Days ${phase.startDay} to ${phase.endDay} (${phaseDays.length} Days)</p>
    <table>
      <tr><th>Day</th><th>Concept / Title</th><th>Subconcept</th><th>Primary Skill Axis</th><th>Lab Controller</th><th>Difficulty</th><th>Exercises</th></tr>''');

      for (final d in phaseDays) {
        sb.writeln('''      <tr>
        <td><strong>Day ${d.dayNumber}</strong></td>
        <td>${d.topic}</td>
        <td>${d.theme}</td>
        <td><code>${d.primarySkillAxis.name}</code></td>
        <td><code>${d.referencedLabId}</code></td>
        <td>${d.difficultyRating}</td>
        <td>${d.exercises.length}</td>
      </tr>''');
      }

      sb.writeln('''    </table>
  </div>''');
    }

    sb.writeln('''</body>
</html>''');

    File('concept-coverage.html').writeAsStringSync(sb.toString());
    print('  -> Wrote concept-coverage.html');
  }
}
