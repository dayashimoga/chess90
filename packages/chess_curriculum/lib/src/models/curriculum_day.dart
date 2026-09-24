import 'package:chess_learning/chess_learning.dart';
import 'curriculum_exercise.dart';
import 'lesson_scenario.dart';

/// The 13 weekly phases of the authentic 90-day mastery spiral.
enum CurriculumPhase {
  phase1Fundamentals(1, 7, 'Phase 1: Rules, Notation, Movement & Board Vision'),
  phase2Tactics(8, 14, 'Phase 2: Tactical Motifs & Combinations'),
  phase3Calculation(15, 21, 'Phase 3: Candidate Moves & Calculation Trees (CCT)'),
  phase4Strategy(22, 28, 'Phase 4: Positional Strategy & Piece Activity'),
  phase5PawnStructures(29, 35, 'Phase 5: Pawn Structures, Chains & Breaks'),
  phase6AttackDefense(36, 42, 'Phase 6: King Attacks & Defensive Tenacity'),
  phase7PawnEndgames(43, 49, 'Phase 7: King & Pawn Endgames, Opposition & Mates'),
  phase8RookEndgames(50, 56, 'Phase 8: Rook Endgames (Lucena/Philidor) & Minor Pieces'),
  phase9Openings(57, 63, 'Phase 9: Opening Mastery & Compact Repertoires'),
  phase10Transitions(64, 70, 'Phase 10: Transitions, Strategic Transformations & Planning'),
  phase11Conversion(71, 77, 'Phase 11: Advantage Conversion & Pressure Decisions'),
  phase12ModelGames(78, 84, 'Phase 12: Master Model Games & Guess-The-Move'),
  phase13Tournament(85, 90, 'Phase 13: Tournament Simulation & Final Assessment');

  final int startDay;
  final int endDay;
  final String title;

  const CurriculumPhase(this.startDay, this.endDay, this.title);

  static CurriculumPhase forDay(int day) {
    for (final phase in CurriculumPhase.values) {
      if (day >= phase.startDay && day <= phase.endDay) return phase;
    }
    return CurriculumPhase.phase13Tournament;
  }

  // Legacy backwards-compatible aliases
  static const CurriculumPhase phase1Diagnostic = phase1Fundamentals;
  static const CurriculumPhase phase10Integration = phase13Tournament;
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

  // 10-step GM spiral dimensions
  final String? definition;
  final String? whyItMatters;
  final String? visualBoardFen;
  final String? patternRule;
  final List<String> commonMistakes;
  final List<String> cheatSheetSummary;
  final List<String> animatedDemoMoves;
  final String? miniGameType;
  final String? modelGameClip;
  final LessonScenario? scenario;

  String get shortExplanation => definition ?? (theoryMarkdown.isNotEmpty ? theoryMarkdown.split('\n\n').first : topic);
  List<String> get commonMistakesList => commonMistakes;
  String get cheatSheetText => cheatSheetSummary.isNotEmpty ? cheatSheetSummary.join(' • ') : (patternRule ?? theme);

  const CurriculumDay({
    required this.dayNumber,
    required this.title,
    required this.phase,
    required this.theme,
    required this.learningObjectives,
    required this.theoryMarkdown,
    required this.exercises,
    this.scenario,
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
    this.definition,
    this.whyItMatters,
    this.visualBoardFen,
    this.patternRule,
    List<String>? commonMistakes,
    List<String>? cheatSheetSummary,
    List<String>? animatedDemoMoves,
    this.miniGameType,
    this.modelGameClip,
  })  : topic = topic ?? title,
        workedExamples = workedExamples ?? const [],
        referencedPuzzles = referencedPuzzles ?? const [],
        gameStudy = gameStudy ?? 'Annotated Master Game Study',
        practiceTask = practiceTask ?? 'Interactive Engine Sparring Session',
        assessment = assessment ?? (isWeeklyExam ? 'Weekly Milestone Comprehensive Exam' : 'Daily Mastery Evaluation'),
        masteryThreshold = masteryThreshold ?? (isWeeklyExam ? 0.85 : 0.80),
        remediation = remediation ?? 'Review core tactical motifs and complete 5 targeted SRS flashcard drills.',
        srsReview = srsReview ?? const ['Tactical Pattern Flashcards', 'Candidate Selection Review'],
        estimatedMinutes = estimatedMinutes ?? (isWeeklyExam ? 90 : 60),
        commonMistakes = commonMistakes ?? const [],
        cheatSheetSummary = cheatSheetSummary ?? const [],
        animatedDemoMoves = animatedDemoMoves ?? const [];

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
        'definition': definition,
        'whyItMatters': whyItMatters,
        'visualBoardFen': visualBoardFen,
        'patternRule': patternRule,
        'commonMistakes': commonMistakes,
        'cheatSheetSummary': cheatSheetSummary,
        'animatedDemoMoves': animatedDemoMoves,
        'miniGameType': miniGameType,
        'modelGameClip': modelGameClip,
        'scenario': scenario?.toJson(),
      };

  factory CurriculumDay.fromJson(Map<String, dynamic> json) {
    final isExam = json['isWeeklyExam'] as bool? ?? false;
    final dayNum = json['dayNumber'] as int;
    final phaseName = json['phase'] as String?;
    final phase = CurriculumPhase.values.firstWhere(
      (p) => p.name == phaseName,
      orElse: () => CurriculumPhase.forDay(dayNum),
    );
    return CurriculumDay(
      dayNumber: dayNum,
      title: json['title'] as String,
      phase: phase,
      theme: json['theme'] as String,
      learningObjectives: (json['learningObjectives'] as List<dynamic>).cast<String>(),
      theoryMarkdown: json['theoryMarkdown'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => CurriculumExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      scenario: json['scenario'] != null
          ? LessonScenario.fromJson(json['scenario'] as Map<String, dynamic>)
          : null,
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
      definition: json['definition'] as String?,
      whyItMatters: json['whyItMatters'] as String?,
      visualBoardFen: json['visualBoardFen'] as String?,
      patternRule: json['patternRule'] as String?,
      commonMistakes: (json['commonMistakes'] as List<dynamic>?)?.cast<String>(),
      cheatSheetSummary: (json['cheatSheetSummary'] as List<dynamic>?)?.cast<String>(),
      animatedDemoMoves: (json['animatedDemoMoves'] as List<dynamic>?)?.cast<String>(),
      miniGameType: json['miniGameType'] as String?,
      modelGameClip: json['modelGameClip'] as String?,
    );
  }
}

