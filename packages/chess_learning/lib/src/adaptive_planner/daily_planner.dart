import '../skill_graph/skill_axis.dart';

/// Training activity block within a daily study plan.
class TrainingBlock {
  final String title;
  final SkillAxis primaryAxis;
  final Duration scheduledDuration;
  final String labType;
  final String objective;
  final bool isMandatory;

  const TrainingBlock({
    required this.title,
    required this.primaryAxis,
    required this.scheduledDuration,
    required this.labType,
    required this.objective,
    this.isMandatory = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'primaryAxis': primaryAxis.name,
        'scheduledDurationMinutes': scheduledDuration.inMinutes,
        'labType': labType,
        'objective': objective,
        'isMandatory': isMandatory,
      };
}

/// A complete personalized daily training schedule.
class DailyTrainingPlan {
  final int curriculumDay; // 1 to 90
  final Duration totalBudget;
  final List<TrainingBlock> blocks;
  final String primaryFocus;

  const DailyTrainingPlan({
    required this.curriculumDay,
    required this.totalBudget,
    required this.blocks,
    required this.primaryFocus,
  });

  Duration get calculatedTotalDuration =>
      blocks.fold<Duration>(Duration.zero, (acc, b) => acc + b.scheduledDuration);
}

/// Adaptive planner that schedules daily work based on curriculum day, user available time, and skill gaps.
class DailyPlanner {
  /// Generates the daily training plan.
  static DailyTrainingPlan generatePlan({
    required int curriculumDay,
    Duration availableBudget = const Duration(hours: 8),
    required List<SkillNode> currentSkillNodes,
  }) {
    // Find highest priority weaknesses
    final weakNodes = currentSkillNodes.where((n) => n.status == SkillStatus.weak || n.recurrenceCount > 0).toList();
    final decayingNodes = currentSkillNodes.where((n) => n.status == SkillStatus.decaying).toList();

    // Determine focus theme based on curriculum phase
    final primaryFocus = _getCurriculumPhaseTheme(curriculumDay);

    final blocks = <TrainingBlock>[];
    final totalMinutes = availableBudget.inMinutes;

    if (totalMinutes <= 15) {
      // 5m to 15m Express Mode: Focus on Spaced Review + 1 Critical Lab
      blocks.add(const TrainingBlock(
        title: 'Spaced Repetition Review',
        primaryAxis: SkillAxis.tactics,
        scheduledDuration: Duration(minutes: 5),
        labType: 'tactical_recognition',
        objective: 'Clear due review queue and retain critical patterns.',
        isMandatory: true,
      ));
      blocks.add(TrainingBlock(
        title: 'Targeted Weakness Drill',
        primaryAxis: weakNodes.isNotEmpty ? weakNodes.first.axis : SkillAxis.calculation,
        scheduledDuration: Duration(minutes: totalMinutes - 5),
        labType: 'candidate_selection',
        objective: 'High-intensity resolution of active tactical/calculation blindspot.',
      ));
    } else if (totalMinutes <= 60) {
      // 30m to 60m Standard Mode
      blocks.add(const TrainingBlock(
        title: 'Spaced Review & Retention',
        primaryAxis: SkillAxis.tactics,
        scheduledDuration: Duration(minutes: 10),
        labType: 'tactical_recognition',
        objective: 'Daily spaced-repetition retention check.',
        isMandatory: true,
      ));
      blocks.add(TrainingBlock(
        title: 'Core Curriculum Lab',
        primaryAxis: axisForDay(curriculumDay),
        scheduledDuration: Duration(minutes: (totalMinutes * 0.4).round()),
        labType: labForDay(curriculumDay),
        objective: 'Master today\'s scheduled curriculum module.',
        isMandatory: true,
      ));
      blocks.add(TrainingBlock(
        title: 'Serious Game & Self-Analysis',
        primaryAxis: SkillAxis.tournamentPlay,
        scheduledDuration: Duration(minutes: (totalMinutes * 0.4).round()),
        labType: 'play_and_analyze',
        objective: 'Apply concepts under time control and self-diagnose mistakes.',
      ));
    } else {
      // Full Intensive GM Mode (~7.5 to 8 hours)
      blocks.add(const TrainingBlock(
        title: 'Tactical Foundation & Pattern Vision',
        primaryAxis: SkillAxis.tactics,
        scheduledDuration: Duration(minutes: 50),
        labType: 'tactical_recognition',
        objective: 'Rapid motif recognition, hanging pieces, and calculation sharpness.',
      ));
      blocks.add(const TrainingBlock(
        title: 'Deep Concrete Calculation',
        primaryAxis: SkillAxis.calculation,
        scheduledDuration: Duration(minutes: 90),
        labType: 'candidate_selection',
        objective: 'Candidate move generation, pruning, opponent best replies, and anti-puzzles.',
      ));
      blocks.add(TrainingBlock(
        title: 'Positional Strategy & Pawn Structures',
        primaryAxis: axisForDay(curriculumDay),
        scheduledDuration: const Duration(minutes: 60),
        labType: labForDay(curriculumDay),
        objective: 'Curriculum phase study: imbalances, piece placement, and pawn breaks.',
      ));
      blocks.add(const TrainingBlock(
        title: 'Endgame Mastery',
        primaryAxis: SkillAxis.endgames,
        scheduledDuration: Duration(minutes: 60),
        labType: 'endgame_win_defend',
        objective: 'Winning and defending theoretical and practical endgames against engine.',
      ));
      blocks.add(const TrainingBlock(
        title: 'Opening Repertoire & Model Games',
        primaryAxis: SkillAxis.openings,
        scheduledDuration: Duration(minutes: 45),
        labType: 'opening_plans',
        objective: 'Repertoire lines, structural plans, transpositions, and GM model games.',
      ));
      blocks.add(const TrainingBlock(
        title: 'Serious Classical Game',
        primaryAxis: SkillAxis.tournamentPlay,
        scheduledDuration: Duration(minutes: 120),
        labType: 'serious_game',
        objective: 'Tournament conditions: no hints, no engine, clock management.',
        isMandatory: true,
      ));
      blocks.add(const TrainingBlock(
        title: 'Self-Analysis & Root-Cause Diagnosis',
        primaryAxis: SkillAxis.tournamentPlay,
        scheduledDuration: Duration(minutes: 60),
        labType: 'self_analysis',
        objective: 'Human thought-process recording, engine comparison, and blunder classification.',
        isMandatory: true,
      ));
      blocks.add(TrainingBlock(
        title: 'Weakness Retraining & Spaced Review',
        primaryAxis: weakNodes.isNotEmpty ? weakNodes.first.axis : SkillAxis.tactics,
        scheduledDuration: const Duration(minutes: 30),
        labType: 'weakness_retraining',
        objective: 'Review decaying items (${decayingNodes.length}) and blundered patterns (${weakNodes.length}).',
        isMandatory: true,
      ));
    }

    return DailyTrainingPlan(
      curriculumDay: curriculumDay,
      totalBudget: availableBudget,
      blocks: blocks,
      primaryFocus: primaryFocus,
    );
  }

  static String _getCurriculumPhaseTheme(int day) {
    if (day == 1) return 'Baseline Diagnostic & Personalized Skill Graph Generation';
    if (day <= 14) return 'Tactical Foundation & Pattern Vision Mastery';
    if (day <= 28) return 'Calculation Trees, Candidate Generation & Blindfold Visualization';
    if (day <= 42) return 'Positional Strategy, Planning & Pawn Structures';
    if (day <= 56) return 'Endgame Technique & Engine Conversion';
    if (day <= 63) return 'Compact Opening Repertoire & Structural Plans';
    if (day <= 70) return 'Attacking the King & Defensive Tenacity';
    if (day <= 77) return 'Advantage Conversion & Practical Decision Making';
    if (day <= 84) return 'Tournament Simulation Mode (Classical Time Controls)';
    return 'Integration, Retention Stabilization & Day 90 Final Certification';
  }

  static SkillAxis axisForDay(int day) {
    if (day <= 14) return SkillAxis.tactics;
    if (day <= 28) return SkillAxis.calculation;
    if (day <= 42) return SkillAxis.strategy;
    if (day <= 56) return SkillAxis.endgames;
    if (day <= 63) return SkillAxis.openings;
    if (day <= 70) return SkillAxis.attack;
    if (day <= 77) return SkillAxis.conversion;
    if (day <= 84) return SkillAxis.tournamentPlay;
    return SkillAxis.calculation;
  }

  static String labForDay(int day) {
    if (day <= 14) return 'tactical_recognition';
    if (day <= 28) return 'candidate_selection';
    if (day <= 42) return 'positional_evaluation';
    if (day <= 56) return 'endgame_win_defend';
    if (day <= 63) return 'opening_plans';
    if (day <= 70) return 'tactical_recognition';
    if (day <= 77) return 'conversion_defense';
    return 'serious_game';
  }
}
