/// Represents an individual spaced-repetition exercise item in the Leitner review queue.
class ReviewItem {
  final String id;
  final String fen;
  final List<String> solutionSan;
  final String skillNodeId;
  final String motif;
  final String explanation;

  int stage; // 0 to 5
  DateTime nextReviewDate;
  DateTime lastReviewedDate;
  int successStreak;
  int failureCount;

  // Intervals: stage 0 (0 hours), stage 1 (1 day), stage 2 (3 days),
  // stage 3 (7 days), stage 4 (14 days), stage 5 (30 days)
  static const List<Duration> intervals = [
    Duration.zero, // Same session
    Duration(days: 1),
    Duration(days: 3),
    Duration(days: 7),
    Duration(days: 14),
    Duration(days: 30),
  ];

  ReviewItem({
    required this.id,
    required this.fen,
    required this.solutionSan,
    required this.skillNodeId,
    required this.motif,
    required this.explanation,
    this.stage = 0,
    DateTime? nextReviewDate,
    DateTime? lastReviewedDate,
    this.successStreak = 0,
    this.failureCount = 0,
  })  : nextReviewDate = nextReviewDate ?? DateTime.now(),
        lastReviewedDate = lastReviewedDate ?? DateTime.now();

  /// True if this item is currently due for review.
  bool get isDue => DateTime.now().isAfter(nextReviewDate);

  /// Records a user attempt and updates spaced repetition schedule.
  void recordAttempt({required bool isCorrect}) {
    final now = DateTime.now();
    lastReviewedDate = now;

    if (isCorrect) {
      successStreak++;
      if (stage < intervals.length - 1) {
        stage++;
      }
      nextReviewDate = now.add(intervals[stage]);
    } else {
      failureCount++;
      successStreak = 0;
      // Shrink back: step back to stage 0 or 1 on failure
      stage = stage > 1 ? 1 : 0;
      nextReviewDate = now.add(intervals[stage]);
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fen': fen,
        'solutionSan': solutionSan,
        'skillNodeId': skillNodeId,
        'motif': motif,
        'explanation': explanation,
        'stage': stage,
        'nextReviewDate': nextReviewDate.toIso8601String(),
        'lastReviewedDate': lastReviewedDate.toIso8601String(),
        'successStreak': successStreak,
        'failureCount': failureCount,
      };

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'] as String,
      fen: json['fen'] as String,
      solutionSan: (json['solutionSan'] as List<dynamic>).cast<String>(),
      skillNodeId: json['skillNodeId'] as String,
      motif: json['motif'] as String,
      explanation: json['explanation'] as String,
      stage: json['stage'] as int? ?? 0,
      nextReviewDate: DateTime.tryParse(json['nextReviewDate'] as String? ?? '') ?? DateTime.now(),
      lastReviewedDate: DateTime.tryParse(json['lastReviewedDate'] as String? ?? '') ?? DateTime.now(),
      successStreak: json['successStreak'] as int? ?? 0,
      failureCount: json['failureCount'] as int? ?? 0,
    );
  }
}

/// Spaced repetition manager implementing adaptive Leitner intervals:
/// same session -> 1d -> 3d -> 7d -> 14d -> 30d
class LeitnerEngine {
  final List<ReviewItem> _items = [];

  List<ReviewItem> get allItems => List.unmodifiable(_items);

  List<ReviewItem> get dueItems => _items.where((i) => i.isDue).toList();

  void addItem(ReviewItem item) {
    _items.removeWhere((i) => i.id == item.id);
    _items.add(item);
  }

  void recordResult(String itemId, bool isCorrect) {
    final item = _items.firstWhere((i) => i.id == itemId, orElse: () => throw StateError('Item not found: $itemId'));
    item.recordAttempt(isCorrect: isCorrect);
  }

  /// Calculates retention rate across all reviewed items.
  double get overallRetentionRate {
    if (_items.isEmpty) return 1.0;
    int totalAttempts = 0;
    int totalSuccesses = 0;
    for (final item in _items) {
      totalSuccesses += item.successStreak;
      totalAttempts += (item.successStreak + item.failureCount);
    }
    return totalAttempts == 0 ? 1.0 : totalSuccesses / totalAttempts;
  }
}
