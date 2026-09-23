import '../skill_graph/skill_axis.dart';

/// Evaluates mastery gates and readiness status according to the strict criteria:
/// - knowledge >= 90%
/// - isolated >= 90%
/// - mixed >= 85%
/// - real-game >= 80%
/// - 7-day retention >= 85%
/// - 30-day retention >= 80%
class MasteryGates {
  static const double knowledgeThreshold = 0.90;
  static const double isolatedThreshold = 0.90;
  static const double mixedThreshold = 0.85;
  static const double realGameThreshold = 0.80;
  static const double retention7DayThreshold = 0.85;
  static const double retention30DayThreshold = 0.80;

  /// Checks whether a single skill node passes the GM-style mastery gate.
  static bool hasMastered(SkillNode node) {
    return node.knowledgeScore >= knowledgeThreshold &&
        node.isolatedAccuracy >= isolatedThreshold &&
        node.mixedAccuracy >= mixedThreshold &&
        node.realGameApplication >= realGameThreshold &&
        node.retention7Day >= retention7DayThreshold &&
        node.retention30Day >= retention30DayThreshold;
  }

  /// Updates node status based on metric thresholds and practice recency:
  /// UNSEEN -> LEARNING -> GUIDED -> PRACTICING -> INDEPENDENT -> MASTERED -> REVIEW-DUE.
  static void updateNodeStatus(SkillNode node) {
    final now = DateTime.now();
    final daysSincePractice = now.difference(node.lastPracticed).inDays;

    if (hasMastered(node)) {
      if (daysSincePractice > 14) {
        node.status = SkillStatus.decaying;
      } else {
        node.status = SkillStatus.mastered;
      }
      return;
    }

    if (node.recurrenceCount >= 3 || (node.realGameApplication < 0.60 && node.realGameApplication > 0.0)) {
      node.status = SkillStatus.weak;
      return;
    }

    if (node.realGameApplication >= 0.80 || (node.isolatedAccuracy >= 0.85 && node.mixedAccuracy >= 0.80)) {
      node.status = SkillStatus.independent;
      return;
    }

    if (node.isolatedAccuracy >= 0.70 || node.mixedAccuracy >= 0.65) {
      node.status = SkillStatus.practicing;
      return;
    }

    if (node.isolatedAccuracy > 0.0) {
      node.status = SkillStatus.guided;
      return;
    }

    if (node.knowledgeScore > 0.0) {
      node.status = SkillStatus.learning;
      return;
    }

    node.status = SkillStatus.unseen;
  }

  /// Diagnoses in-game blunders and maps them to concrete skill nodes and causal explanations.
  /// Generates the human-readable "WHY" for adaptive daily priorities.
  static ({SkillAxis axis, String cause, String recommendation}) diagnoseMistake({
    required String motifOrType,
    int mistakeCount = 1,
  }) {
    final lower = motifOrType.toLowerCase();
    if (lower.contains('pin') || lower.contains('pinned')) {
      return (
        axis: SkillAxis.tactics,
        cause: 'Missed $mistakeCount pinned piece${mistakeCount > 1 ? "s" : ""} or relative pin threat in recent play.',
        recommendation: 'Pins prioritized: Review pin ray geometry and relative vs absolute pin mechanics.',
      );
    }
    if (lower.contains('fork') || lower.contains('double attack')) {
      return (
        axis: SkillAxis.tactics,
        cause: 'Overlooked $mistakeCount knight or pawn fork${mistakeCount > 1 ? "s" : ""} during calculation.',
        recommendation: 'Forks prioritized: Drill LPDO (loose pieces drop off) scanning before every move.',
      );
    }
    if (lower.contains('skewer') || lower.contains('discovery')) {
      return (
        axis: SkillAxis.tactics,
        cause: 'Conceded $mistakeCount discovered attack${mistakeCount > 1 ? "s" : ""} along open lines.',
        recommendation: 'Discovery defense prioritized: Track aligned king and queen batteries.',
      );
    }
    if (lower.contains('blunder') || lower.contains('hanging') || lower.contains('lpdo')) {
      return (
        axis: SkillAxis.calculation,
        cause: 'Left $mistakeCount undefended piece${mistakeCount > 1 ? "s" : ""} under opponent attack.',
        recommendation: 'Blunder prevention check prioritized: Run the 3-step safety check before committing.',
      );
    }
    if (lower.contains('endgame') || lower.contains('pawn race') || lower.contains('lucena')) {
      return (
        axis: SkillAxis.endgames,
        cause: 'Struggled with technical conversion or opposition in the endgame.',
        recommendation: 'Endgame technique prioritized: Practice Lucena and Philidor reference positions.',
      );
    }
    if (lower.contains('opening') || lower.contains('deviation')) {
      return (
        axis: SkillAxis.openings,
        cause: 'Deviated prematurely from opening principles or theoretical mainlines.',
        recommendation: 'Opening repertoire prioritized: Reinforce rapid piece development and center control.',
      );
    }
    return (
      axis: SkillAxis.tactics,
      cause: 'Tactical inaccuracy detected during recent game play.',
      recommendation: 'Tactical scan prioritized: Execute CCT (Checks, Captures, Threats) on every ply.',
    );
  }

  /// Calculates radar plot values (0.0 to 1.0) for each of the 12 skill axes.
  static Map<SkillAxis, double> computeRadarValues(List<SkillNode> nodes) {
    final values = <SkillAxis, double>{};
    for (final axis in SkillAxis.values) {
      final axisNodes = nodes.where((n) => n.axis == axis).toList();
      if (axisNodes.isEmpty) {
        values[axis] = 0.0;
      } else {
        final total = axisNodes.fold<double>(0.0, (acc, n) => acc + n.compositeScore);
        values[axis] = total / axisNodes.length;
      }
    }
    return values;
  }

  /// Computes overall mastery readiness score (0.0 to 100.0) with continuous multi-factor calibration:
  /// - Skill Axis Mastery Attainment (continuous composite score + threshold rewards)
  /// - Optional Curriculum Progression credit (completedDays / 90)
  /// - Optional Milestone Examination Rigor credit (passedExams / 13)
  /// - Decay and weakness adjustments
  static double computeOverallMasteryPercentage(
    List<SkillNode> nodes, {
    int? completedDays,
    int? passedExams,
  }) {
    if (nodes.isEmpty) return 0.0;

    // Compute effective axis score with continuous credit
    final totalAxisScore = nodes.fold<double>(0.0, (acc, n) {
      if (hasMastered(n)) return acc + 1.0;
      if (n.status == SkillStatus.decaying) return acc + (n.compositeScore * 0.85);
      if (n.status == SkillStatus.weak) return acc + (n.compositeScore * 0.80);
      return acc + n.compositeScore;
    });
    final axisScore = totalAxisScore / nodes.length;

    if (completedDays == null && passedExams == null) {
      return (axisScore * 100.0).clamp(0.0, 100.0);
    }

    final daysCredit = ((completedDays ?? 0) / 90.0).clamp(0.0, 1.0);
    final examsCredit = ((passedExams ?? 0) / 13.0).clamp(0.0, 1.0);

    // Pedagogical weighting:
    // 70% Skill Axis Mastery Attainment
    // 15% 90-Day Curriculum Progression
    // 15% Milestone Examination Rigor
    final composite = (axisScore * 0.70) + (daysCredit * 0.15) + (examsCredit * 0.15);
    return (composite * 100.0).clamp(0.0, 100.0);
  }
}
