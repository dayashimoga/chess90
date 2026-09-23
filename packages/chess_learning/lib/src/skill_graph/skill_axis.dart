/// The 12 core skill dimensions tracked across the 90-day program.
enum SkillAxis {
  tactics('Tactical Vision & Motifs', 'Forks, pins, skewers, deflection, clearance, and combination discovery.'),
  calculation('Concrete Calculation', 'Branching trees, candidate selection, move ordering, and deep forcing lines.'),
  visualization('Board Visualization & Memory', 'Blind calculation, board geometry recall, and mental board state tracking.'),
  strategy('Positional Strategy', 'Piece activity, outposts, weak squares, bishop pair, and prophylaxis.'),
  pawnStructures('Pawn Structures', 'IQP, Carlsbad, Hedgehog, Maroczy, pawn breaks, chains, and passed pawns.'),
  endgames('Endgame Technique', 'Opposition, Lucena, Philidor, Vancura, rook endings, and piece transitions.'),
  openings('Opening Repertoire', 'Understanding plans, typical pawn breaks, transpositions, and ideas behind moves.'),
  attack('Attacking King', 'Sacrifices, opening lines against the enemy king, and opposite-castling storms.'),
  defense('Defensive Tenacity', 'Prophylaxis, fortress construction, counterplay, and saving tough positions.'),
  conversion('Advantage Conversion', 'Simplification, technical precision, and avoiding counterplay when ahead.'),
  timeManagement('Clock Management', 'Pacing, critical moment detection, and making decisions with time pressure.'),
  tournamentPlay('Tournament Discipline', 'Psychological composure, tournament time controls, and self-analysis rigor.');

  final String title;
  final String description;

  const SkillAxis(this.title, this.description);
}

/// Mastery states for skill nodes representing the full adaptive mastery spiral:
/// UNSEEN -> LEARNING -> GUIDED -> PRACTICING -> INDEPENDENT -> MASTERED -> REVIEW-DUE.
enum SkillStatus {
  unseen('Unseen'),
  learning('Learning'),
  guided('Guided Practice'),
  practicing('Practicing'),
  independent('Independent'),
  mastered('Mastered'),
  reviewDue('Review Due'),

  // Backwards-compatible aliases for legacy persistence
  weak('Needs Review'),
  retest('Retest Required'),
  decaying('Review Due');

  final String label;
  const SkillStatus(this.label);

  static SkillStatus parse(String name) {
    for (final s in SkillStatus.values) {
      if (s.name.toLowerCase() == name.toLowerCase()) return s;
    }
    if (name.toLowerCase() == 'review_due') return SkillStatus.reviewDue;
    if (name.toLowerCase() == 'guided_practice') return SkillStatus.guided;
    return SkillStatus.unseen;
  }
}

/// Represents an individual tracked node in the hierarchical skill graph.
class SkillNode {
  final String id;
  final String name;
  final SkillAxis axis;
  final String? parentId;
  final List<String> childIds;

  double knowledgeScore; // 0.0 - 1.0 (understanding of principles)
  double isolatedAccuracy; // 0.0 - 1.0 (drill/lab accuracy)
  double mixedAccuracy; // 0.0 - 1.0 (mixed puzzle sets)
  double realGameApplication; // 0.0 - 1.0 (success in actual games)
  double retention7Day; // 0.0 - 1.0 (7-day recall)
  double retention30Day; // 0.0 - 1.0 (30-day recall)
  int responseTimeMs; // average response time in ms
  int recurrenceCount; // how many times blundered recently
  double confidenceScore; // 0.0 - 1.0
  SkillStatus status;
  DateTime lastPracticed;

  SkillNode({
    required this.id,
    required this.name,
    required this.axis,
    this.parentId,
    this.childIds = const [],
    this.knowledgeScore = 0.0,
    this.isolatedAccuracy = 0.0,
    this.mixedAccuracy = 0.0,
    this.realGameApplication = 0.0,
    this.retention7Day = 0.0,
    this.retention30Day = 0.0,
    this.responseTimeMs = 0,
    this.recurrenceCount = 0,
    this.confidenceScore = 0.5,
    this.status = SkillStatus.unseen,
    DateTime? lastPracticed,
  }) : lastPracticed = lastPracticed ?? DateTime.now();

  /// Composite difficulty-adjusted score (0.0 to 1.0)
  double get compositeScore {
    return (knowledgeScore * 0.15) +
        (isolatedAccuracy * 0.20) +
        (mixedAccuracy * 0.25) +
        (realGameApplication * 0.20) +
        (retention7Day * 0.10) +
        (retention30Day * 0.10);
  }

  SkillNode copyWith({
    String? id,
    String? name,
    SkillAxis? axis,
    String? parentId,
    List<String>? childIds,
    double? knowledgeScore,
    double? isolatedAccuracy,
    double? mixedAccuracy,
    double? realGameApplication,
    double? retention7Day,
    double? retention30Day,
    int? responseTimeMs,
    int? recurrenceCount,
    double? confidenceScore,
    SkillStatus? status,
    DateTime? lastPracticed,
  }) {
    return SkillNode(
      id: id ?? this.id,
      name: name ?? this.name,
      axis: axis ?? this.axis,
      parentId: parentId ?? this.parentId,
      childIds: childIds ?? this.childIds,
      knowledgeScore: knowledgeScore ?? this.knowledgeScore,
      isolatedAccuracy: isolatedAccuracy ?? this.isolatedAccuracy,
      mixedAccuracy: mixedAccuracy ?? this.mixedAccuracy,
      realGameApplication: realGameApplication ?? this.realGameApplication,
      retention7Day: retention7Day ?? this.retention7Day,
      retention30Day: retention30Day ?? this.retention30Day,
      responseTimeMs: responseTimeMs ?? this.responseTimeMs,
      recurrenceCount: recurrenceCount ?? this.recurrenceCount,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      status: status ?? this.status,
      lastPracticed: lastPracticed ?? this.lastPracticed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'axis': axis.name,
        'parentId': parentId,
        'childIds': childIds,
        'knowledgeScore': knowledgeScore,
        'isolatedAccuracy': isolatedAccuracy,
        'mixedAccuracy': mixedAccuracy,
        'realGameApplication': realGameApplication,
        'retention7Day': retention7Day,
        'retention30Day': retention30Day,
        'responseTimeMs': responseTimeMs,
        'recurrenceCount': recurrenceCount,
        'confidenceScore': confidenceScore,
        'status': status.name,
        'lastPracticed': lastPracticed.toIso8601String(),
      };

  factory SkillNode.fromJson(Map<String, dynamic> json) {
    return SkillNode(
      id: json['id'] as String,
      name: json['name'] as String,
      axis: SkillAxis.values.firstWhere((a) => a.name == json['axis']),
      parentId: json['parentId'] as String?,
      childIds: (json['childIds'] as List<dynamic>?)?.cast<String>() ?? [],
      knowledgeScore: (json['knowledgeScore'] as num?)?.toDouble() ?? 0.0,
      isolatedAccuracy: (json['isolatedAccuracy'] as num?)?.toDouble() ?? 0.0,
      mixedAccuracy: (json['mixedAccuracy'] as num?)?.toDouble() ?? 0.0,
      realGameApplication: (json['realGameApplication'] as num?)?.toDouble() ?? 0.0,
      retention7Day: (json['retention7Day'] as num?)?.toDouble() ?? 0.0,
      retention30Day: (json['retention30Day'] as num?)?.toDouble() ?? 0.0,
      responseTimeMs: json['responseTimeMs'] as int? ?? 0,
      recurrenceCount: json['recurrenceCount'] as int? ?? 0,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.5,
      status: SkillStatus.parse(json['status'] as String? ?? 'unseen'),
      lastPracticed: DateTime.tryParse(json['lastPracticed'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
