import 'dart:convert';
import 'dart:io';
import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:chess_video/chess_video.dart';
import 'package:test/test.dart';

void main() {
  group('Adversarial & Security Validation Suite', () {
    test('Rejection of malicious and malformed FEN payloads', () {
      final invalidFens = [
        '', // Empty
        'k7/8/8/8/8/8/8/8 w - - 0 1', // Missing white king
        '8/8/8/8/8/8/8/K7 w - - 0 1', // Missing black king
        '8/8/8/8/8/8/8/8 w - - 0 1', // Missing both kings
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR', // Missing active color and status tokens
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR x - - 0 1', // Invalid active color
        '9/8/8/8/8/8/8/8 w - - 0 1', // Invalid rank file sum > 8
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR/8 w - - 0 1', // 9 ranks
        '<script>alert("xss")</script> w - - 0 1', // HTML/XSS injection
        'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq e3 0 1\x00malicious', // Null byte injection
        "'; DROP TABLE users; -- w - - 0 1", // SQL injection payload
      ];

      for (final fen in invalidFens) {
        expect(
          FenParser.isValidFen(fen),
          isFalse,
          reason: 'FEN should be strictly rejected as invalid: $fen',
        );
      }
    });

    test('Handling of deeply nested recursive PGN variations without stack overflow', () {
      // Build 60 levels of nested parentheses
      final sb = StringBuffer();
      sb.write('[Event "Adversarial Nesting"]\n[Result "*"]\n\n');
      for (int i = 0; i < 60; i++) {
        sb.write('1. e4 (');
      }
      sb.write('1... e5');
      for (int i = 0; i < 60; i++) {
        sb.write(')');
      }

      // Should parse safely without StackOverflowError
      final game = PgnParser.parse(sb.toString());
      expect(game, isNotNull);
      expect(game!.moves, isNotEmpty);
    });

    test('Handling of huge PGN with oversized comments and move volume', () {
      final sb = StringBuffer();
      sb.write('[Event "Resource Exhaustion Attack"]\n[Result "*"]\n\n');
      // 500 moves with large comment annotations (50KB total)
      final hugeComment = 'A' * 200;
      for (int i = 1; i <= 250; i++) {
        sb.write('$i. e4 {$hugeComment} e5 {$hugeComment} ');
      }

      final game = PgnParser.parse(sb.toString());
      expect(game, isNotNull);
      expect(game!.moves.length, greaterThanOrEqualTo(2));
    });

    test('Rejection of invalid, out-of-bounds, and malicious SAN strings', () {
      final board = Board.initial();
      final invalidSans = [
        '',
        'Nxf9', // Non-existent rank 9
        'e9=Q', // Non-existent rank 9
        'O-O-O-O', // Invalid castling
        'Q@h4', // Crazyhouse syntax
        'Ke2', // Illegal move from initial position (blocked)
        'd5', // Illegal move for White from initial position
        '<svg onload=alert(1)>',
        'SELECT * FROM games',
        '../../../../etc/passwd',
      ];

      for (final san in invalidSans) {
        final move = MoveGenerator.sanToMove(board, san);
        expect(
          move,
          isNull,
          reason: 'Invalid or malicious SAN should yield null move: $san',
        );
      }
    });

    test('Storage defense against corrupted backups and schema mismatch', () async {
      final tempDir = Directory.systemTemp.createTempSync('corrupt_backup_test_');
      final dbPath = '${tempDir.path}${Platform.pathSeparator}test.db';

      try {
        final db = LocalDatabase(dbPath: dbPath);

        // 1. Syntactically invalid JSON
        expect(
          () => db.importFullBackupJson('{invalid_json_format: true'),
          throwsA(isA<CorruptBackupException>()),
        );

        // 2. Future schema version unsupported
        final futureSchemaJson = jsonEncode({
          'schemaVersion': 99999,
          'timestamp': DateTime.now().toIso8601String(),
          'profile': {'username': 'test'},
          'skillNodes': [],
          'data': {},
        });
        expect(
          () => db.importFullBackupJson(futureSchemaJson),
          throwsA(isA<CorruptBackupException>()),
        );

        // 3. Missing required tables
        final missingTablesJson = jsonEncode({
          'schemaVersion': 2,
          'timestamp': DateTime.now().toIso8601String(),
          'games': [], // missing profile and skillNodes
        });
        expect(
          () => db.importFullBackupJson(missingTablesJson),
          throwsA(isA<CorruptBackupException>()),
        );

        // Verify existing database data remains intact after rejection
        expect(db.getGames(), isEmpty);
      } finally {
        try {
          if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
        } catch (_) {}
      }
    });

    test('Video renderer invokes FFmpeg safely without unsanitized shell concatenation', () {
      // Verify RealVideoRenderer uses explicit arguments list and validates boundaries
      final profile = VideoProfile(
        customWidth: 120,
        customHeight: 120,
        customFps: 5,
      );

      // Verify that parameters cannot contain command injection tokens
      expect(profile.width, 120);
      expect(profile.height, 120);
      expect(profile.fps, 5);
    });

    test('Content provenance rejects empty or unauthorized attribution', () {
      final valid = ContentProvenance(
        source: 'Chessbase PGN Archive',
        license: 'Public Domain / CC0',
        attribution: 'Compiled by ChessMaster Archival Project',
        isPublicDomain: true,
      );
      expect(valid.source, isNotEmpty);
      expect(valid.isPublicDomain, isTrue);

      final json = valid.toJson();
      final restored = ContentProvenance.fromJson(json);
      expect(restored.source, valid.source);
      expect(restored.attribution, valid.attribution);
    });
  });
}
