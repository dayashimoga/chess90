import '../board/board.dart';
import '../models/move.dart';
import '../models/piece.dart';
import '../rules/move_generator.dart';

/// Represents a single move node in a PGN move tree with annotations and clock.
class PgnMoveNode {
  final int ply;
  final int moveNumber;
  final bool isWhite;
  final String san;
  final Move? move;
  final String? comment;
  final double? evaluation;
  final String? clock;
  final List<int> nags;
  final List<List<PgnMoveNode>> variations;

  const PgnMoveNode({
    required this.ply,
    required this.moveNumber,
    required this.isWhite,
    required this.san,
    this.move,
    this.comment,
    this.evaluation,
    this.clock,
    this.nags = const [],
    this.variations = const [],
  });

  PgnMoveNode copyWith({
    int? ply,
    int? moveNumber,
    bool? isWhite,
    String? san,
    Move? move,
    String? comment,
    double? evaluation,
    String? clock,
    List<int>? nags,
    List<List<PgnMoveNode>>? variations,
  }) {
    return PgnMoveNode(
      ply: ply ?? this.ply,
      moveNumber: moveNumber ?? this.moveNumber,
      isWhite: isWhite ?? this.isWhite,
      san: san ?? this.san,
      move: move ?? this.move,
      comment: comment ?? this.comment,
      evaluation: evaluation ?? this.evaluation,
      clock: clock ?? this.clock,
      nags: nags ?? this.nags,
      variations: variations ?? this.variations,
    );
  }
}

/// Represents a complete parsed PGN game.
class PgnGame {
  final Map<String, String> headers;
  final List<PgnMoveNode> moves;
  final String result;

  const PgnGame({
    required this.headers,
    required this.moves,
    this.result = '*',
  });

  String get event => headers['Event'] ?? '?';
  String get site => headers['Site'] ?? '?';
  String get date => headers['Date'] ?? '????.??.??';
  String get year => date.split('.').first;
  String get round => headers['Round'] ?? '?';
  String get white => headers['White'] ?? 'White';
  String get black => headers['Black'] ?? 'Black';
  String get eco => headers['ECO'] ?? '';
  String get opening => headers['Opening'] ?? '';
  String? get setupFen => headers['FEN'];

  /// Exports this game to standard PGN text.
  String toPgnString() {
    final sb = StringBuffer();

    // 7-tag roster + additional tags
    final standardTags = ['Event', 'Site', 'Date', 'Round', 'White', 'Black', 'Result'];
    for (final tag in standardTags) {
      sb.writeln('[$tag "${headers[tag] ?? (tag == 'Result' ? result : '?')}"]');
    }
    for (final entry in headers.entries) {
      if (!standardTags.contains(entry.key)) {
        sb.writeln('[${entry.key} "${entry.value}"]');
      }
    }
    sb.writeln();

    // Move text
    for (int i = 0; i < moves.length; i++) {
      final node = moves[i];
      if (node.isWhite) {
        sb.write('${node.moveNumber}. ');
      } else if (i == 0) {
        sb.write('${node.moveNumber}... ');
      }

      sb.write(node.san);

      for (final nag in node.nags) {
        sb.write(' \$$nag');
      }

      if (node.comment != null && node.comment!.isNotEmpty) {
        sb.write(' {${node.comment}}');
      }

      sb.write(' ');
    }

    sb.write(result);
    sb.writeln();

    return sb.toString();
  }
}

/// Parser for PGN (Portable Game Notation) formats.
class PgnParser {
  /// Parses a string containing one or multiple PGN games.
  static List<PgnGame> parseMultiGame(String pgnContent) {
    final games = <PgnGame>[];
    final lines = pgnContent.split('\n');

    Map<String, String> currentHeaders = {};
    final currentMoveLines = <String>[];
    bool readingHeaders = true;

    for (final rawLine in lines) {
      final line = rawLine.trim();
      if (line.isEmpty) {
        if (currentHeaders.isNotEmpty && !readingHeaders) {
          // Empty line separating games or header/moves
        }
        continue;
      }

      if (line.startsWith('[')) {
        if (currentMoveLines.isNotEmpty) {
          // Finish previous game
          final game = _buildGame(currentHeaders, currentMoveLines.join(' '));
          if (game != null) games.add(game);
          currentHeaders = {};
          currentMoveLines.clear();
        }
        readingHeaders = true;
        final match = RegExp(r'^\[(\w+)\s+"(.*)"\]$').firstMatch(line);
        if (match != null) {
          currentHeaders[match.group(1)!] = match.group(2)!;
        }
      } else {
        readingHeaders = false;
        currentMoveLines.add(line);
      }
    }

    if (currentHeaders.isNotEmpty || currentMoveLines.isNotEmpty) {
      final game = _buildGame(currentHeaders, currentMoveLines.join(' '));
      if (game != null) games.add(game);
    }

    return games;
  }

  /// Parses a single PGN game.
  static PgnGame? parse(String pgnContent) {
    final games = parseMultiGame(pgnContent);
    return games.isNotEmpty ? games.first : null;
  }

  static PgnGame? _buildGame(Map<String, String> headers, String moveText) {
    final initialFen = headers['FEN'];
    final board = initialFen != null ? Board.fromFen(initialFen) : Board.initial();

    String result = headers['Result'] ?? '*';
    final moveTokens = _tokenizeMoveText(moveText);
    final moves = <PgnMoveNode>[];

    int ply = 0;
    int currentMoveNumber = board.fullmoveNumber;
    bool isWhite = board.activeColor == PieceColor.white;

    for (int i = 0; i < moveTokens.length; i++) {
      final token = moveTokens[i];

      if (token == '1-0' || token == '0-1' || token == '1/2-1/2' || token == '*') {
        result = token;
        break;
      }

      // Skip move number indicators like "1." or "1..."
      if (RegExp(r'^\d+(\.+)?$').hasMatch(token)) {
        continue;
      }

      // Check if comment
      String? comment;
      double? evaluation;
      String? clock;
      if (token.startsWith('{') && token.endsWith('}')) {
        comment = token.substring(1, token.length - 1).trim();
        // Parse eval and clk if present
        final evalMatch = RegExp(r'\[%eval\s+([#\-\d\.]+)\]').firstMatch(comment);
        if (evalMatch != null) {
          final evalStr = evalMatch.group(1)!;
          if (evalStr.startsWith('#')) {
            // Mate in N
            final mateMoves = int.tryParse(evalStr.substring(1)) ?? 1;
            evaluation = mateMoves > 0 ? 100.0 : -100.0;
          } else {
            evaluation = double.tryParse(evalStr);
          }
        }
        final clkMatch = RegExp(r'\[%clk\s+([\d:]+)\]').firstMatch(comment);
        if (clkMatch != null) {
          clock = clkMatch.group(1);
        }

        // Attach comment to previous move if available
        if (moves.isNotEmpty) {
          final last = moves.removeLast();
          moves.add(last.copyWith(
            comment: comment,
            evaluation: evaluation,
            clock: clock,
          ));
        }
        continue;
      }

      // Try parsing SAN move
      final move = MoveGenerator.sanToMove(board, token);
      if (move != null) {
        board.makeMove(move);
        ply++;
        moves.add(PgnMoveNode(
          ply: ply,
          moveNumber: currentMoveNumber,
          isWhite: isWhite,
          san: token,
          move: move,
        ));

        if (!isWhite) {
          currentMoveNumber++;
        }
        isWhite = !isWhite;
      }
    }

    return PgnGame(
      headers: headers,
      moves: moves,
      result: result,
    );
  }

  static List<String> _tokenizeMoveText(String moveText) {
    final tokens = <String>[];
    final sb = StringBuffer();
    bool insideComment = false;

    for (int i = 0; i < moveText.length; i++) {
      final char = moveText[i];
      if (char == '{') {
        if (sb.isNotEmpty) {
          tokens.add(sb.toString().trim());
          sb.clear();
        }
        insideComment = true;
        sb.write(char);
      } else if (char == '}') {
        sb.write(char);
        insideComment = false;
        tokens.add(sb.toString().trim());
        sb.clear();
      } else if (insideComment) {
        sb.write(char);
      } else if (char == ' ' || char == '\t' || char == '\r' || char == '\n') {
        if (sb.isNotEmpty) {
          tokens.add(sb.toString().trim());
          sb.clear();
        }
      } else {
        sb.write(char);
      }
    }

    if (sb.isNotEmpty) {
      tokens.add(sb.toString().trim());
    }

    return tokens.where((t) => t.isNotEmpty).toList();
  }
}
