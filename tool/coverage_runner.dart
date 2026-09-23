import 'dart:convert';
import 'dart:io';

class FileCoverage {
  final String path;
  int linesFound = 0;
  int linesHit = 0;
  final Map<int, int> lineHits = {}; // line -> count

  FileCoverage(this.path);

  double get percentage => linesFound == 0 ? 100.0 : (linesHit / linesFound) * 100.0;
}

class PackageCoverage {
  final String name;
  final String dir;
  final bool isFlutter;
  final Map<String, FileCoverage> files = {};

  PackageCoverage({required this.name, required this.dir, this.isFlutter = false});

  int get totalLinesFound => files.values.fold(0, (sum, f) => sum + f.linesFound);
  int get totalLinesHit => files.values.fold(0, (sum, f) => sum + f.linesHit);
  double get percentage => totalLinesFound == 0 ? 100.0 : (totalLinesHit / totalLinesFound) * 100.0;
}

Future<void> main(List<String> args) async {
  print('======================================================');
  print('       CHESSMASTER COVERAGE COLLECTION & GATES        ');
  print('======================================================');

  final current = Directory.current;
  final rootDir = Directory('${current.path}/packages').existsSync()
      ? current.path
      : (Directory('${current.parent.path}/packages').existsSync()
          ? current.parent.path
          : current.path);

  final dartBin = Platform.isWindows && File('C:\\flutter\\bin\\dart.bat').existsSync()
      ? 'C:\\flutter\\bin\\dart.bat'
      : 'dart';
  final flutterBin = Platform.isWindows && File('C:\\flutter\\bin\\flutter.bat').existsSync()
      ? 'C:\\flutter\\bin\\flutter.bat'
      : 'flutter';

  final packages = [
    PackageCoverage(name: 'chess_core', dir: 'packages/chess_core'),
    PackageCoverage(name: 'chess_engine', dir: 'packages/chess_engine'),
    PackageCoverage(name: 'chess_learning', dir: 'packages/chess_learning'),
    PackageCoverage(name: 'chess_curriculum', dir: 'packages/chess_curriculum'),
    PackageCoverage(name: 'chess_labs', dir: 'packages/chess_labs'),
    PackageCoverage(name: 'chess_content', dir: 'packages/chess_content'),
    PackageCoverage(name: 'chess_video', dir: 'packages/chess_video'),
    PackageCoverage(name: 'chess_storage', dir: 'packages/chess_storage'),
    PackageCoverage(name: 'chess_app', dir: 'apps/chess_app', isFlutter: true),
  ];

  final coverageOutDir = Directory(Platform.isWindows ? '$rootDir\\coverage' : '$rootDir/coverage');
  if (!coverageOutDir.existsSync()) coverageOutDir.createSync(recursive: true);

  for (final pkg in packages) {
    print('\n[Coverage] Running tests for ${pkg.name} in ${pkg.dir}...');
    final pkgFullDir = Directory(Platform.isWindows ? '$rootDir\\${pkg.dir.replaceAll('/', '\\')}' : '$rootDir/${pkg.dir}');
    final pkgCoverageDir = Directory(Platform.isWindows ? '${pkgFullDir.path}\\coverage' : '${pkgFullDir.path}/coverage');
    if (pkgCoverageDir.existsSync()) {
      try {
        pkgCoverageDir.deleteSync(recursive: true);
      } catch (_) {}
    }

    ProcessResult res;
    if (pkg.isFlutter) {
      await Process.run(
        flutterBin,
        ['pub', 'get'],
        workingDirectory: pkgFullDir.path,
        runInShell: true,
      );
      res = await Process.run(
        flutterBin,
        ['test', '--coverage'],
        workingDirectory: pkgFullDir.path,
        runInShell: true,
      );
    } else {
      await Process.run(
        dartBin,
        ['pub', 'get'],
        workingDirectory: pkgFullDir.path,
        runInShell: true,
      );
      res = await Process.run(
        dartBin,
        ['test', '--coverage=coverage'],
        workingDirectory: pkgFullDir.path,
        runInShell: true,
      );
    }

    if (res.exitCode != 0) {
      print('ERROR: Test run failed for ${pkg.name}:\n${res.stdout}\n${res.stderr}');
      exit(1);
    }

    // Parse coverage output
    if (pkg.isFlutter) {
      final lcovFile = File('${pkgFullDir.path}${Platform.pathSeparator}coverage${Platform.pathSeparator}lcov.info');
      if (lcovFile.existsSync()) {
        _parseLcov(lcovFile.readAsStringSync(), pkg);
      }
    } else {
      final coverageDir = Directory('${pkgFullDir.path}${Platform.pathSeparator}coverage${Platform.pathSeparator}test');
      if (coverageDir.existsSync()) {
        for (final file in coverageDir.listSync().whereType<File>()) {
          if (file.path.endsWith('.vm.json')) {
            try {
              final jsonContent = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
              _parseVmJson(jsonContent, pkg);
            } catch (e) {
              print('Warning: Failed to parse ${file.path}: $e');
            }
          }
        }
      }
    }

    print('  ${pkg.name}: ${pkg.totalLinesHit} / ${pkg.totalLinesFound} lines (${pkg.percentage.toStringAsFixed(1)}%)');
  }

  // Aggregate stats
  int grandLinesFound = 0;
  int grandLinesHit = 0;
  for (final pkg in packages) {
    grandLinesFound += pkg.totalLinesFound;
    grandLinesHit += pkg.totalLinesHit;
  }
  final grandPercentage = grandLinesFound == 0 ? 100.0 : (grandLinesHit / grandLinesFound) * 100.0;

  print('\n======================================================');
  print('                 COVERAGE SUMMARY                      ');
  print('======================================================');
  for (final pkg in packages) {
    final pctStr = pkg.percentage.toStringAsFixed(1).padLeft(5);
    print('  ${pkg.name.padRight(18)} : $pctStr% (${pkg.totalLinesHit}/${pkg.totalLinesFound} lines)');
  }
  print('------------------------------------------------------');
  print('  TOTAL AGGREGATE    : ${grandPercentage.toStringAsFixed(1).padLeft(5)}% ($grandLinesHit/$grandLinesFound lines)');
  print('======================================================');

  // Export JSON Report
  final summaryJson = {
    'timestamp': DateTime.now().toIso8601String(),
    'aggregate': {
      'linesFound': grandLinesFound,
      'linesHit': grandLinesHit,
      'percentage': grandPercentage,
    },
    'packages': {
      for (final p in packages)
        p.name: {
          'linesFound': p.totalLinesFound,
          'linesHit': p.totalLinesHit,
          'percentage': p.percentage,
          'files': {
            for (final f in p.files.values)
              f.path: {
                'linesFound': f.linesFound,
                'linesHit': f.linesHit,
                'percentage': f.percentage,
              }
          }
        }
    }
  };

  final jsonFile = File('${coverageOutDir.path}${Platform.pathSeparator}coverage_summary.json');
  jsonFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(summaryJson));

  // Export HTML Report
  final htmlBuffer = StringBuffer();
  htmlBuffer.writeln('<!DOCTYPE html><html><head><meta charset="utf-8">');
  htmlBuffer.writeln('<title>ChessMaster Coverage Report</title>');
  htmlBuffer.writeln('<style>');
  htmlBuffer.writeln('body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #0f172a; color: #f8fafc; padding: 32px; }');
  htmlBuffer.writeln('.container { max-width: 960px; margin: auto; }');
  htmlBuffer.writeln('h1 { color: #38bdf8; }');
  htmlBuffer.writeln('table { width: 100%; border-collapse: collapse; margin-top: 24px; background: #1e293b; border-radius: 8px; overflow: hidden; }');
  htmlBuffer.writeln('th, td { padding: 12px 16px; text-align: left; border-bottom: 1px solid #334155; }');
  htmlBuffer.writeln('th { background: #0f172a; color: #94a3b8; font-weight: 600; }');
  htmlBuffer.writeln('.badge-pass { background: #22c55e; color: #000; padding: 4px 8px; border-radius: 4px; font-weight: bold; }');
  htmlBuffer.writeln('.badge-fail { background: #ef4444; color: #fff; padding: 4px 8px; border-radius: 4px; font-weight: bold; }');
  htmlBuffer.writeln('.bar-bg { background: #334155; border-radius: 4px; height: 8px; width: 120px; display: inline-block; vertical-align: middle; margin-left: 8px; }');
  htmlBuffer.writeln('.bar-fill { background: #38bdf8; height: 8px; border-radius: 4px; }');
  htmlBuffer.writeln('</style></head><body><div class="container">');
  htmlBuffer.writeln('<h1>ChessMaster Line Coverage Report</h1>');
  htmlBuffer.writeln('<p>Generated: ${DateTime.now().toUtc().toIso8601String()}</p>');
  htmlBuffer.writeln('<h2>Aggregate: ${grandPercentage.toStringAsFixed(1)}% ($grandLinesHit / $grandLinesFound lines)</h2>');
  htmlBuffer.writeln('<table><tr><th>Package</th><th>Covered / Total</th><th>Coverage</th><th>Gate Status</th></tr>');

  for (final pkg in packages) {
    final reqPct = (pkg.name == 'chess_core' || pkg.name == 'chess_learning') ? 95.0 : 90.0;
    final passed = pkg.percentage >= reqPct;
    htmlBuffer.writeln('<tr><td><strong>${pkg.name}</strong></td>');
    htmlBuffer.writeln('<td>${pkg.totalLinesHit} / ${pkg.totalLinesFound}</td>');
    htmlBuffer.writeln('<td>${pkg.percentage.toStringAsFixed(1)}%<div class="bar-bg"><div class="bar-fill" style="width: ${pkg.percentage.clamp(0, 100)}%;"></div></div></td>');
    htmlBuffer.writeln('<td><span class="${passed ? "badge-pass" : "badge-fail"}">${passed ? "PASS" : "FAIL"} (&ge;${reqPct.toInt()}%)</span></td></tr>');
  }
  htmlBuffer.writeln('</table></div></body></html>');

  final htmlFile = File('${coverageOutDir.path}${Platform.pathSeparator}coverage.html');
  htmlFile.writeAsStringSync(htmlBuffer.toString());

  print('\nReports written:');
  print('  -> ${jsonFile.path}');
  print('  -> ${htmlFile.path}');

  // Evaluate fail-under gates
  final corePkg = packages.firstWhere((p) => p.name == 'chess_core');
  final learningPkg = packages.firstWhere((p) => p.name == 'chess_learning');

  final domainPackages = packages.where((p) => p.name != 'chess_app').toList();
  final int domainLinesFound = domainPackages.fold(0, (sum, p) => sum + p.totalLinesFound);
  final int domainLinesHit = domainPackages.fold(0, (sum, p) => sum + p.totalLinesHit);
  final double domainPercentage = domainLinesFound == 0 ? 100.0 : (domainLinesHit / domainLinesFound) * 100.0;

  final bool corePass = corePkg.percentage >= 95.0;
  final bool learningPass = learningPkg.percentage >= 95.0;
  final bool domainPass = domainPercentage >= 90.0;
  final bool aggregatePass = grandPercentage >= 75.0;

  print('\n======================================================');
  print('                 FAIL-UNDER GATES                      ');
  print('======================================================');
  print('Gate 1: Domain Packages Coverage >= 90.0%: ${domainPass ? "PASSED" : "FAILED"} (${domainPercentage.toStringAsFixed(1)}%)');
  print('Gate 2: chess_core Line Coverage >= 95.0%: ${corePass ? "PASSED" : "FAILED"} (${corePkg.percentage.toStringAsFixed(1)}%)');
  print('Gate 3: chess_learning Line Coverage >= 95.0%: ${learningPass ? "PASSED" : "FAILED"} (${learningPkg.percentage.toStringAsFixed(1)}%)');
  print('Gate 4: Total Aggregate Coverage >= 75.0%: ${aggregatePass ? "PASSED" : "FAILED"} (${grandPercentage.toStringAsFixed(1)}%)');
  print('======================================================');

  if (!domainPass || !corePass || !learningPass || !aggregatePass) {
    print('\nFAILURE: One or more coverage gates failed! Enforcing fail-under blocker.');
    exit(1);
  }

  print('\nSUCCESS: All coverage gates passed clean!');
}

void _parseVmJson(Map<String, dynamic> jsonContent, PackageCoverage pkg) {
  final coverageList = jsonContent['coverage'] as List<dynamic>?;
  if (coverageList == null) return;

  for (final item in coverageList) {
    if (item is! Map<String, dynamic>) continue;
    final source = item['source'] as String?;
    if (source == null) continue;

    // Filter to package's own lib source
    if (!source.startsWith('package:${pkg.name}/') && !source.contains('/${pkg.dir}/lib/')) {
      continue;
    }

    // Exclude static training bank data catalogs from code coverage calculation
    if (source.contains('/training_banks/') || source.contains(r'\training_banks\')) {
      continue;
    }

    final fileCov = pkg.files.putIfAbsent(source, () => FileCoverage(source));
    final hits = item['hits'] as List<dynamic>? ?? [];

    for (int i = 0; i < hits.length - 1; i += 2) {
      final line = hits[i] as int;
      final count = hits[i + 1] as int;

      fileCov.lineHits.update(line, (prev) => prev + count, ifAbsent: () => count);
    }

    fileCov.linesFound = fileCov.lineHits.length;
    fileCov.linesHit = fileCov.lineHits.values.where((c) => c > 0).length;
  }
}

void _parseLcov(String content, PackageCoverage pkg) {
  FileCoverage? current;
  for (final line in LineSplitter.split(content)) {
    if (line.startsWith('SF:')) {
      final filePath = line.substring(3).trim();
      if (filePath.contains('/training_banks/') || filePath.contains(r'\training_banks\')) {
        current = null;
        continue;
      }
      current = pkg.files.putIfAbsent(filePath, () => FileCoverage(filePath));
    } else if (line.startsWith('DA:') && current != null) {
      final parts = line.substring(3).split(',');
      if (parts.length >= 2) {
        final lineNum = int.tryParse(parts[0]) ?? 0;
        final count = int.tryParse(parts[1]) ?? 0;
        current.lineHits.update(lineNum, (prev) => prev + count, ifAbsent: () => count);
      }
    } else if (line == 'end_of_record' && current != null) {
      current.linesFound = current.lineHits.length;
      current.linesHit = current.lineHits.values.where((c) => c > 0).length;
      current = null;
    }
  }
}
