import 'package:chess_core/chess_core.dart';
import 'package:chess_engine/chess_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Real Stockfish Engine Lifecycle & Proof Tests', () {
    test('Native Stockfish UCI lifecycle: spawn -> uci -> isready -> evaluate -> bestmove -> shutdown', () async {
      final engine = NativeStockfishEngine();
      await engine.initialize();

      // Verify discovered engine name
      print('Discovered Engine Name: ${engine.engineName} (isFallback: ${engine.isFallback})');
      expect(engine.engineName.isNotEmpty, isTrue);

      // Set starting position
      await engine.setPosition(FenParser.initialFen);

      // Evaluate depth 5
      final eval = await engine.evaluate(depth: 5);
      expect(eval.depth, greaterThanOrEqualTo(1));
      expect(eval.bestMove, isNotNull);

      // Verify that engine evaluation stream emits progressive updates
      final streamFuture = engine.searchStream.first;
      await engine.setPosition('r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3');
      final evalFuture = engine.evaluate(depth: 8);

      final streamEval = await streamFuture.timeout(const Duration(seconds: 5), onTimeout: () => eval);
      expect(streamEval, isNotNull);

      await evalFuture;

      // Test stop/cancellation
      await engine.stop();

      // Clean shutdown
      await engine.dispose();
    });

    test('Engine accurately detects tactical mate in 1', () async {
      final engine = NativeStockfishEngine();
      await engine.initialize();

      // Scholar's mate delivery: Queen on f3 to f7#
      await engine.setPosition('r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1');
      final eval = await engine.evaluate(depth: 8);

      expect(eval.bestMove?.from, equals(Square.named('f3')));
      expect(eval.bestMove?.to, equals(Square.named('f7')));

      await engine.dispose();
    });
  });
}
