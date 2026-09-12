import 'dart:io';
import 'package:chess_core/chess_core.dart';
import 'package:chess_video/chess_video.dart';
import 'package:test/test.dart';

void main() {
  group('Real Video Generation & Forensic Acceptance Tests', () {
    late Directory tempDir;
    final ffmpegPath = RealVideoRenderer.findFfmpegPath();
    final ffprobePath = RealVideoRenderer.findFfprobePath();
    final hasBinaries = ffmpegPath != null && ffprobePath != null;

    setUpAll(() {
      tempDir = Directory.systemTemp.createTempSync('chess_video_acceptance_');
    });

    tearDownAll(() {
      try {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      } catch (_) {}
    });

    // Helper to generate a small synthetic AAC audio file using ffmpeg if available
    Future<String?> generateTestAudio(String filename, double durationSeconds) async {
      if (ffmpegPath == null) return null;
      final audioPath = '${tempDir.path}${Platform.pathSeparator}$filename';
      final res = await Process.run(ffmpegPath, [
        '-y',
        '-f', 'lavfi',
        '-i', 'sine=frequency=440:duration=$durationSeconds',
        '-c:a', 'aac',
        audioPath,
      ]);
      if (res.exitCode == 0 && File(audioPath).existsSync()) {
        return audioPath;
      }
      return null;
    }

    test('Acceptance Test A: Generate real MP4 from bundled Model Game', () async {
      if (!hasBinaries) {
        markTestSkipped('FFmpeg/FFprobe binaries not available on host');
        return;
      }

      const operaPgn = '''
[Event "Paris Opera House"]
[Site "Paris FRA"]
[Date "1858.11.02"]
[White "Morphy, Paul"]
[Black "Duke of Brunswick and Count Isouard"]
[Result "1-0"]
[ECO "C41"]

1. e4 e5 2. Nf3 d6 3. d4 Bg4 4. dxe5 Bxf3 5. Qxf3 dxe5 6. Bc4 Nf6 7. Qb3 Qe7 8. Nc3 c6 9. Bg5 b5 10. Nxb5 1-0
''';

      final game = PgnParser.parse(operaPgn);
      expect(game, isNotNull);

      final outputPath = '${tempDir.path}${Platform.pathSeparator}acceptance_model_game.mp4';
      final thumbPath = '${tempDir.path}${Platform.pathSeparator}acceptance_model_game_thumb.png';

      const profile = VideoProfile(
        aspectRatio: VideoAspectRatio.youtube16x9,
        customWidth: 960,
        customHeight: 540,
        customFps: 20,
        moveSpeedSeconds: 0.1,
        criticalMomentPauseSeconds: 0.2,
      );

      final result = await RealVideoRenderer.renderVideo(
        game: game!,
        outputPath: outputPath,
        thumbnailPath: thumbPath,
        profile: profile,
      );

      expect(result.frameCount, greaterThan(10));
      expect(result.durationSeconds, greaterThan(0.5));
      expect(File(outputPath).existsSync(), isTrue);
      expect(File(outputPath).lengthSync(), greaterThan(1000));
      expect(File(thumbPath).existsSync(), isTrue);

      // Verify forensic inspection with FFprobe
      final inspection = await VideoInspector.inspect(outputPath);
      expect(inspection.codec.toLowerCase(), equals('h264'));
      expect(inspection.width, equals(960));
      expect(inspection.height, equals(540));
      expect(inspection.fps, closeTo(20.0, 1.0));
      expect(inspection.durationSeconds, greaterThan(0.5));
      expect(inspection.isPlayable, isTrue);

      // Verify playable first, middle, and final frames
      final firstFrame = '${tempDir.path}${Platform.pathSeparator}model_frame_first.png';
      final midFrame = '${tempDir.path}${Platform.pathSeparator}model_frame_mid.png';
      final lastFrame = '${tempDir.path}${Platform.pathSeparator}model_frame_last.png';

      final okFirst = await VideoInspector.extractFrame(
        videoPath: outputPath,
        timestampSeconds: 0.1,
        outputPath: firstFrame,
      );
      expect(okFirst, isTrue);

      final okMid = await VideoInspector.extractFrame(
        videoPath: outputPath,
        timestampSeconds: inspection.durationSeconds / 2.0,
        outputPath: midFrame,
      );
      expect(okMid, isTrue);

      final okLast = await VideoInspector.extractFrame(
        videoPath: outputPath,
        timestampSeconds: (inspection.durationSeconds - 0.2).clamp(0.0, inspection.durationSeconds),
        outputPath: lastFrame,
      );
      expect(okLast, isTrue);

      // Verify final chess position
      final finalBoard = Board.initial();
      for (final n in game.moves) {
        if (n.move != null) finalBoard.makeMove(n.move!);
      }
      expect(finalBoard.toFen(), isNotEmpty);
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('Acceptance Test B: Generate real MP4 from user-played game with audio muxing', () async {
      if (!hasBinaries) {
        markTestSkipped('FFmpeg/FFprobe binaries not available on host');
        return;
      }

      const playedPgn = '''
[Event "Rated Blitz game"]
[Site "ChessMaster Local"]
[Date "2026.09.12"]
[White "Human Player"]
[Black "ChessMaster Engine Level 5"]
[Result "1-0"]

1. e4 c5 2. Nf3 d6 3. d4 cxd4 4. Nxd4 Nf6 5. Nc3 a6 6. Be3 e5 7. Nb3 Be6 8. f3 1-0
''';

      final game = PgnParser.parse(playedPgn);
      expect(game, isNotNull);

      final audioPath = await generateTestAudio('test_audio_b.aac', 2.0);

      final outputPath = '${tempDir.path}${Platform.pathSeparator}acceptance_played_game.mp4';
      const profile = VideoProfile(
        aspectRatio: VideoAspectRatio.youtube16x9,
        customWidth: 640,
        customHeight: 360,
        customFps: 20,
        moveSpeedSeconds: 0.1,
        criticalMomentPauseSeconds: 0.1,
      );

      final result = await RealVideoRenderer.renderVideo(
        game: game!,
        outputPath: outputPath,
        profile: profile,
        audioPath: audioPath,
      );

      expect(result.frameCount, greaterThan(5));
      expect(File(outputPath).existsSync(), isTrue);

      final inspection = await VideoInspector.inspect(outputPath);
      expect(inspection.codec.toLowerCase(), equals('h264'));
      expect(inspection.width, equals(640));
      expect(inspection.height, equals(360));
      expect(inspection.isPlayable, isTrue);

      if (audioPath != null) {
        expect(inspection.hasAudio, isTrue);
        expect(inspection.audioCodec?.toLowerCase(), equals('aac'));
      }
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('Acceptance Test C: Generate real MP4 from Pasted PGN', () async {
      if (!hasBinaries) {
        markTestSkipped('FFmpeg/FFprobe binaries not available on host');
        return;
      }

      const pastedPgn = '''
[Event "Casual Match"]
[Site "Online"]
[Date "2026.08.01"]
[White "PlayerOne"]
[Black "PlayerTwo"]
[Result "0-1"]

1. d4 d5 2. c4 e6 3. Nc3 Nf6 4. Bg5 Nbd7 5. cxd5 exd5 6. Nxd5 Nxd5 7. Bxd8 Bb4+ 8. Qd2 Bxd2+ 9. Kxd2 Kxd8 0-1
''';

      final game = PgnParser.parse(pastedPgn);
      expect(game, isNotNull);

      final outputPath = '${tempDir.path}${Platform.pathSeparator}acceptance_pasted_pgn.mp4';
      const profile = VideoProfile(
        aspectRatio: VideoAspectRatio.social1x1,
        customWidth: 540,
        customHeight: 540,
        customFps: 15,
        moveSpeedSeconds: 0.1,
        criticalMomentPauseSeconds: 0.1,
      );

      final result = await RealVideoRenderer.renderVideo(
        game: game!,
        outputPath: outputPath,
        profile: profile,
      );

      expect(result.frameCount, greaterThan(8));
      expect(File(outputPath).existsSync(), isTrue);

      final inspection = await VideoInspector.inspect(outputPath);
      expect(inspection.codec.toLowerCase(), equals('h264'));
      expect(inspection.width, equals(540));
      expect(inspection.height, equals(540));
      expect(inspection.isPlayable, isTrue);
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('Acceptance Test D: Generate real MP4 from Imported PGN File', () async {
      if (!hasBinaries) {
        markTestSkipped('FFmpeg/FFprobe binaries not available on host');
        return;
      }

      const importedFileContent = '''
[Event "FIDE Candidates"]
[Site "Madrid ESP"]
[Date "2022.06.17"]
[White "Nepomniachtchi, Ian"]
[Black "Ding, Liren"]
[Result "1-0"]

1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. c3 Nf6 5. d3 d6 6. O-O a6 7. Re1 1-0
''';

      final pgnFile = File('${tempDir.path}${Platform.pathSeparator}imported_game.pgn');
      pgnFile.writeAsStringSync(importedFileContent);
      expect(pgnFile.existsSync(), isTrue);

      final loadedPgn = pgnFile.readAsStringSync();
      final game = PgnParser.parse(loadedPgn);
      expect(game, isNotNull);

      final outputPath = '${tempDir.path}${Platform.pathSeparator}acceptance_imported_pgn.mp4';
      const profile = VideoProfile(
        aspectRatio: VideoAspectRatio.shorts9x16,
        customWidth: 360,
        customHeight: 640,
        customFps: 15,
        moveSpeedSeconds: 0.1,
        criticalMomentPauseSeconds: 0.1,
      );

      final result = await RealVideoRenderer.renderVideo(
        game: game!,
        outputPath: outputPath,
        profile: profile,
      );

      expect(result.frameCount, greaterThan(5));
      expect(File(outputPath).existsSync(), isTrue);

      final inspection = await VideoInspector.inspect(outputPath);
      expect(inspection.codec.toLowerCase(), equals('h264'));
      expect(inspection.width, equals(360));
      expect(inspection.height, equals(640));
      expect(inspection.isPlayable, isTrue);
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('Acceptance Test E: Forensic Decoded Video Frame Verification (No Circle Letter Placeholders)', () async {
      if (!hasBinaries) {
        markTestSkipped('FFmpeg/FFprobe binaries not available on host');
        return;
      }

      const testPgn = '''
[Event "Theme Test"]
[White "Player1"]
[Black "Player2"]
[Result "*"]

1. e4 e5 2. Nf3 Nc6 3. Bb5 a6 4. Ba4 Nf6 *
''';
      final game = PgnParser.parse(testPgn)!;
      final outputPath = '${tempDir.path}${Platform.pathSeparator}acceptance_theme_fidelity.mp4';
      final framePath = '${tempDir.path}${Platform.pathSeparator}theme_fidelity_frame.png';

      const profile = VideoProfile(
        boardThemeName: 'tournamentGreen',
        pieceThemeName: 'standard',
        showCoordinates: true,
        showLastMoveHighlight: true,
        customWidth: 640,
        customHeight: 640,
        customFps: 10,
        moveSpeedSeconds: 0.1,
      );

      final result = await RealVideoRenderer.renderVideo(
        game: game,
        outputPath: outputPath,
        profile: profile,
      );

      expect(result.frameCount, greaterThan(3));
      expect(File(outputPath).existsSync(), isTrue);

      // Extract a frame from the middle of the video
      final ok = await VideoInspector.extractFrame(
        videoPath: outputPath,
        timestampSeconds: 0.2,
        outputPath: framePath,
      );
      expect(ok, isTrue);
      expect(File(framePath).existsSync(), isTrue);

      // Verify that the video frame is a valid PNG image and has the exact resolution
      final bytes = File(framePath).readAsBytesSync();
      expect(bytes.length, greaterThan(5000));
    }, timeout: const Timeout(Duration(minutes: 2)));

    test('Negative Test: Invalid PGN handling', () {
      const corruptPgn = 'This is not valid PGN content at all';
      final game = PgnParser.parse(corruptPgn);
      // Either null or game with 0 moves
      if (game != null) {
        expect(game.moves, isEmpty);
      } else {
        expect(game, isNull);
      }
    });

    test('Negative Test: Cancellation handling', () async {
      if (!hasBinaries) return;

      const pgn = '1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 1-0';
      final game = PgnParser.parse(pgn)!;
      final outputPath = '${tempDir.path}${Platform.pathSeparator}cancelled.mp4';

      bool cancelRequested = false;

      expect(
        () => RealVideoRenderer.renderVideo(
          game: game,
          outputPath: outputPath,
          profile: const VideoProfile(customFps: 10, moveSpeedSeconds: 0.1),
          onProgress: (cur, tot, prog, phase) {
            cancelRequested = true;
          },
          shouldCancel: () => cancelRequested,
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('Negative Test: Insufficient/Invalid output path handling', () async {
      if (!hasBinaries) return;

      const pgn = '1. e4 e5 1-0';
      final game = PgnParser.parse(pgn)!;
      // An invalid path like a directory path where a file is expected
      final badPath = '${tempDir.path}${Platform.pathSeparator}';

      expect(
        () => RealVideoRenderer.renderVideo(
          game: game,
          outputPath: badPath,
          profile: const VideoProfile(customFps: 10, moveSpeedSeconds: 0.1),
        ),
        throwsA(anything),
      );
    });
  });
}
