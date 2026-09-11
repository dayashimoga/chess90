import '../models/piece.dart';

/// Configurable chess clock supporting standard time controls, increment, and delay.
class ChessClock {
  final Duration initialTime;
  final Duration increment;
  final Duration delay;

  Duration whiteRemaining;
  Duration blackRemaining;
  PieceColor activeColor;
  bool isRunning;
  DateTime? _lastTickTime;

  final List<Duration> whiteMoveTimes = [];
  final List<Duration> blackMoveTimes = [];

  ChessClock({
    required this.initialTime,
    this.increment = Duration.zero,
    this.delay = Duration.zero,
    this.activeColor = PieceColor.white,
  })  : whiteRemaining = initialTime,
        blackRemaining = initialTime,
        isRunning = false;

  /// Common presets
  factory ChessClock.classical90Plus30() => ChessClock(
        initialTime: const Duration(minutes: 90),
        increment: const Duration(seconds: 30),
      );

  factory ChessClock.classical60Plus30() => ChessClock(
        initialTime: const Duration(minutes: 60),
        increment: const Duration(seconds: 30),
      );

  factory ChessClock.classical45Plus15() => ChessClock(
        initialTime: const Duration(minutes: 45),
        increment: const Duration(seconds: 15),
      );

  factory ChessClock.rapid15Plus10() => ChessClock(
        initialTime: const Duration(minutes: 15),
        increment: const Duration(seconds: 10),
      );

  factory ChessClock.blitz3Plus2() => ChessClock(
        initialTime: const Duration(minutes: 3),
        increment: const Duration(seconds: 2),
      );

  factory ChessClock.bullet1Plus0() => ChessClock(
        initialTime: const Duration(minutes: 1),
        increment: Duration.zero,
      );

  /// Starts or resumes the clock.
  void start() {
    if (!isRunning) {
      isRunning = true;
      _lastTickTime = DateTime.now();
    }
  }

  /// Pauses the clock.
  void pause() {
    if (isRunning) {
      _tick();
      isRunning = false;
      _lastTickTime = null;
    }
  }

  /// Updates remaining time based on elapsed real time.
  void tick() {
    if (isRunning) {
      _tick();
    }
  }

  void _tick() {
    if (_lastTickTime == null) return;
    final now = DateTime.now();
    final elapsed = now.difference(_lastTickTime!);
    _lastTickTime = now;

    if (activeColor == PieceColor.white) {
      whiteRemaining -= elapsed;
      if (whiteRemaining < Duration.zero) whiteRemaining = Duration.zero;
    } else {
      blackRemaining -= elapsed;
      if (blackRemaining < Duration.zero) blackRemaining = Duration.zero;
    }
  }

  /// Called when a move is executed: switches turn and applies increment.
  void onMovePlayed({Duration? recordedDuration}) {
    if (isRunning) {
      _tick();
    }

    if (activeColor == PieceColor.white) {
      if (recordedDuration != null) {
        whiteMoveTimes.add(recordedDuration);
      }
      whiteRemaining += increment;
      activeColor = PieceColor.black;
    } else {
      if (recordedDuration != null) {
        blackMoveTimes.add(recordedDuration);
      }
      blackRemaining += increment;
      activeColor = PieceColor.white;
    }

    if (isRunning) {
      _lastTickTime = DateTime.now();
    }
  }

  /// True if the specified player's flag has fallen (time ran out).
  bool hasFlagFallen(PieceColor color) {
    if (isRunning) _tick();
    return color == PieceColor.white ? whiteRemaining <= Duration.zero : blackRemaining <= Duration.zero;
  }

  /// Formats duration into a readable clock string: e.g. "1:24:05" or "04:12" or "00:05.4"
  static String formatDuration(Duration d) {
    if (d <= Duration.zero) return '00:00';
    final totalSeconds = d.inSeconds;
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    if (totalSeconds < 20) {
      final tenths = (d.inMilliseconds % 1000) ~/ 100;
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.$tenths';
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get whiteDisplayString {
    if (isRunning && activeColor == PieceColor.white) _tick();
    return formatDuration(whiteRemaining);
  }

  String get blackDisplayString {
    if (isRunning && activeColor == PieceColor.black) _tick();
    return formatDuration(blackRemaining);
  }
}
