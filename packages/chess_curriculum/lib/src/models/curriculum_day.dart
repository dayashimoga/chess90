import 'package:chess_learning/chess_learning.dart';
import 'curriculum_exercise.dart';

/// The 10 phases of the 90-day GM mastery program.
enum CurriculumPhase {
  phase1Diagnostic(1, 1, 'Phase 1: Baseline Diagnostic & Plan'),
  phase2Tactics(2, 14, 'Phase 2: Tactical Foundation & Pattern Vision'),
  phase3Calculation(15, 28, 'Phase 3: Calculation & Visualization Trees'),
  phase4Strategy(29, 42, 'Phase 4: Positional Strategy & Pawn Structures'),
  phase5Endgames(43, 56, 'Phase 5: Endgame Technique & Engine Conversion'),
  phase6Openings(57, 63, 'Phase 6: Personalized Opening Repertoire'),
  phase7AttackDefense(64, 70, 'Phase 7: King Attacks & Defensive Tenacity'),
  phase8Conversion(71, 77, 'Phase 8: Advantage Conversion & Practical Chess'),
  phase9Tournament(78, 84, 'Phase 9: Tournament Simulation Mode'),
  phase10Integration(85, 90, 'Phase 10: Retention Stabilization & Certification');

  final int startDay;
  final int endDay;
  final String title;

  const CurriculumPhase(this.startDay, this.endDay, this.title);

  static CurriculumPhase forDay(int day) {
    for (final phase in CurriculumPhase.values) {
      if (day >= phase.startDay && day <= phase.endDay) return phase;
    }
    return CurriculumPhase.phase10Integration;
  }
}

/// Represents one complete day in the 90-day GM-style program.
class CurriculumDay {
  final int dayNumber;
  final String title;
  final CurriculumPhase phase;
  final String theme;
  final List<String> learningObjectives;
  final String theoryMarkdown;
  final List<CurriculumExercise> exercises;
  final bool isWeeklyExam;
  final double examPassThreshold;
  final SkillAxis primarySkillAxis;
  final String referencedLabId;
  final int difficultyRating;
  final List<int> prerequisites;

  // Expanded pedagogical dimensions
  final String topic;
  final List<String> workedExamples;
  final List<String> referencedPuzzles;
  final String gameStudy;
  final String practiceTask;
  final String assessment;
  final double masteryThreshold;
  final String remediation;
  final List<String> srsReview;
  final int estimatedMinutes;

  const CurriculumDay({
    required this.dayNumber,
    required this.title,
    required this.phase,
    required this.theme,
    required this.learningObjectives,
    required this.theoryMarkdown,
    required this.exercises,
    this.isWeeklyExam = false,
    this.examPassThreshold = 0.85,
    required this.primarySkillAxis,
    this.referencedLabId = 'tactical_lab',
    this.difficultyRating = 1500,
    this.prerequisites = const [],
    String? topic,
    List<String>? workedExamples,
    List<String>? referencedPuzzles,
    String? gameStudy,
    String? practiceTask,
    String? assessment,
    double? masteryThreshold,
    String? remediation,
    List<String>? srsReview,
    int? estimatedMinutes,
  })  : topic = topic ?? title,
        workedExamples = workedExamples ?? const [],
        referencedPuzzles = referencedPuzzles ?? const [],
        gameStudy = gameStudy ?? 'Annotated Master Game Study',
        practiceTask = practiceTask ?? 'Interactive Engine Sparring Session',
        assessment = assessment ?? (isWeeklyExam ? 'Weekly Milestone Comprehensive Exam' : 'Daily Mastery Evaluation'),
        masteryThreshold = masteryThreshold ?? (isWeeklyExam ? 0.85 : 0.80),
        remediation = remediation ?? 'Review core tactical motifs and complete 5 targeted SRS flashcard drills.',
        srsReview = srsReview ?? const ['Tactical Pattern Flashcards', 'Candidate Selection Review'],
        estimatedMinutes = estimatedMinutes ?? (isWeeklyExam ? 90 : 60);

  String get displayLabel => 'Day $dayNumber · $topic — $theme';

  Map<String, dynamic> toJson() => {
        'dayNumber': dayNumber,
        'title': title,
        'phase': phase.name,
        'theme': theme,
        'learningObjectives': learningObjectives,
        'theoryMarkdown': theoryMarkdown,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'isWeeklyExam': isWeeklyExam,
        'examPassThreshold': examPassThreshold,
        'primarySkillAxis': primarySkillAxis.name,
        'referencedLabId': referencedLabId,
        'difficultyRating': difficultyRating,
        'prerequisites': prerequisites,
        'topic': topic,
        'workedExamples': workedExamples,
        'referencedPuzzles': referencedPuzzles,
        'gameStudy': gameStudy,
        'practiceTask': practiceTask,
        'assessment': assessment,
        'masteryThreshold': masteryThreshold,
        'remediation': remediation,
        'srsReview': srsReview,
        'estimatedMinutes': estimatedMinutes,
      };

  factory CurriculumDay.fromJson(Map<String, dynamic> json) {
    final isExam = json['isWeeklyExam'] as bool? ?? false;
    return CurriculumDay(
      dayNumber: json['dayNumber'] as int,
      title: json['title'] as String,
      phase: CurriculumPhase.values.firstWhere((p) => p.name == json['phase']),
      theme: json['theme'] as String,
      learningObjectives: (json['learningObjectives'] as List<dynamic>).cast<String>(),
      theoryMarkdown: json['theoryMarkdown'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => CurriculumExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      isWeeklyExam: isExam,
      examPassThreshold: (json['examPassThreshold'] as num?)?.toDouble() ?? 0.85,
      primarySkillAxis: SkillAxis.values.firstWhere((a) => a.name == json['primarySkillAxis']),
      referencedLabId: json['referencedLabId'] as String? ?? 'tactical_lab',
      difficultyRating: json['difficultyRating'] as int? ?? 1500,
      prerequisites: (json['prerequisites'] as List<dynamic>?)?.cast<int>() ?? const [],
      topic: json['topic'] as String?,
      workedExamples: (json['workedExamples'] as List<dynamic>?)?.cast<String>(),
      referencedPuzzles: (json['referencedPuzzles'] as List<dynamic>?)?.cast<String>(),
      gameStudy: json['gameStudy'] as String?,
      practiceTask: json['practiceTask'] as String?,
      assessment: json['assessment'] as String?,
      masteryThreshold: (json['masteryThreshold'] as num?)?.toDouble(),
      remediation: json['remediation'] as String?,
      srsReview: (json['srsReview'] as List<dynamic>?)?.cast<String>(),
      estimatedMinutes: json['estimatedMinutes'] as int?,
    );
  }
}
