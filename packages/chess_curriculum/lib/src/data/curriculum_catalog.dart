// GENERATED CHESSMASTER 90-DAY CURRICULUM CATALOG
// Comprehensive 90-Day GM Mastery Curriculum with full integrity.

import 'package:chess_core/chess_core.dart';
import 'package:chess_learning/chess_learning.dart';
import '../models/curriculum_day.dart';
import '../models/curriculum_exercise.dart';

/// Full 90-day GM-style mastery curriculum database.
class CurriculumCatalog {
  static final List<CurriculumDay> _days = _buildAll90Days();

  static List<CurriculumDay> get allDays => List.unmodifiable(_days);

  static CurriculumDay getDay(int dayNumber) {
    if (dayNumber < 1 || dayNumber > 90) {
      throw ArgumentError('Curriculum day must be between 1 and 90, got $dayNumber');
    }
    return _days[dayNumber - 1];
  }

  static List<CurriculumDay> get weeklyExams =>
      _days.where((d) => d.isWeeklyExam).toList();

  static List<CurriculumDay> _buildAll90Days() {
    final list = <CurriculumDay>[];
    for (int day = 1; day <= 90; day++) {
      list.add(_generateDay(day));
    }
    return list;
  }

  static CurriculumDay _generateDay(int day) {
    final phase = CurriculumPhase.forDay(day);
    final isExam = const [7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90].contains(day);
    final details = _dayDefinitions[day]!;
    final exercises = (details['exercises'] as List<CurriculumExercise>);

    final workedExamples = (details['workedExamples'] as List<dynamic>?)?.cast<String>() ??
        _defaultWorkedExamples(day, details);
    final referencedPuzzles = (details['referencedPuzzles'] as List<dynamic>?)?.cast<String>() ??
        exercises.map((e) => e.id).toList();
    final gameStudy = details['gameStudy'] as String? ?? _defaultGameStudy(day);
    final practiceTask = details['practiceTask'] as String? ?? _defaultPracticeTask(day, isExam);
    final assessment = details['assessment'] as String? ??
        (isExam
            ? 'Milestone Exam: Complete test positions with >= 85% accuracy and zero hints permitted.'
            : 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy.');
    final remediation = details['remediation'] as String? ??
        _defaultRemediation(day, details['axis'] as SkillAxis);
    final srsReview = (details['srsReview'] as List<dynamic>?)?.cast<String>() ??
        _defaultSrsReview(day, details['theme'] as String);
    final estimatedMinutes = details['estimatedMinutes'] as int? ?? (isExam ? 90 : 60);

    return CurriculumDay(
      dayNumber: day,
      title: details['title'] as String,
      phase: phase,
      theme: details['theme'] as String,
      learningObjectives: (details['objectives'] as List<dynamic>).cast<String>(),
      theoryMarkdown: details['theory'] as String,
      exercises: exercises,
      isWeeklyExam: isExam,
      examPassThreshold: isExam ? 0.85 : 0.80,
      primarySkillAxis: details['axis'] as SkillAxis,
      referencedLabId: details['lab'] as String,
      difficultyRating: details['difficulty'] as int,
      prerequisites: (details['prerequisites'] as List<dynamic>).cast<int>(),
      topic: details['topic'] as String? ?? details['title'] as String,
      workedExamples: workedExamples,
      referencedPuzzles: referencedPuzzles,
      gameStudy: gameStudy,
      practiceTask: practiceTask,
      assessment: assessment,
      masteryThreshold: isExam ? 0.85 : 0.80,
      remediation: remediation,
      srsReview: srsReview,
      estimatedMinutes: estimatedMinutes,
    );
  }

  static List<String> _defaultWorkedExamples(int day, Map<String, dynamic> details) {
    final theme = details['theme'] as String;
    return [
      'Master Model 1: Classic execution of $theme demonstrating calculation tree pruning.',
      'Master Model 2: Defense under pressure and counter-strikes arising from $theme.'
    ];
  }

  static String _defaultGameStudy(int day) {
    if (day <= 9) return 'Paul Morphy vs Duke of Brunswick (1858) — Rapid Development & Central Dominance';
    if (day <= 18) return 'Adolf Anderssen vs Lionel Kieseritzky (1851) — Dynamic Sacrifices & The Immortal Game';
    if (day <= 27) return 'Garry Kasparov vs Veselin Topalov (1999) — Deep Calculation & Attack Horizon';
    if (day <= 36) return 'Akiba Rubinstein vs Gersz Rotlewi (1907) — Rubinstein\'s Immortal & Piece Coordination';
    if (day <= 45) return 'Jose Raul Capablanca vs Savielly Tartakower (1924) — Textbook Rook & Pawn Endgame Technique';
    if (day <= 54) return 'Bobby Fischer vs Donald Byrne (1956) — Game of the Century & Queen Sacrifice';
    if (day <= 63) return 'Mikhail Tal vs Bent Larsen (1965) — Intuitive Piece Sacrifice & Attack Under Stress';
    if (day <= 72) return 'Anatoly Karpov vs Garry Kasparov (1985) — Knight Outpost Dominance & Structural Clamping';
    if (day <= 81) return 'Magnus Carlsen vs Fabiano Caruana (2018) — Squeezing Practical Endgames & Opposition';
    return 'Mikhail Botvinnik vs Vasily Smyslov (1954) — Complete Strategic Integration & Championship Discipline';
  }

  static String _defaultPracticeTask(int day, bool isExam) {
    if (isExam) {
      return 'Tournament Simulation: Play a 15+10 time-control rated sparring match against the Heuristic Engine capped at master depth, followed by full blunder post-mortem self-analysis.';
    }
    return 'Interactive Sparring Assignment: Complete 3 engine sparring rounds from the critical position, maintaining zero unforced blunders (<=50cp loss per move).';
  }

  static String _defaultRemediation(int day, SkillAxis axis) {
    final priorDay = day > 1 ? day - 1 : 1;
    return 'Mandatory Remediation: Review Day $priorDay foundations, complete 10 targeted Leitner flashcards focused on ${axis.name}, and repeat the interactive exercises with zero hint usage until reaching >=85%.';
  }

  static List<String> _defaultSrsReview(int day, String theme) {
    return [
      '$theme: Critical Pattern Flashcard',
      'Candidate Move Pruning Checklist',
      'Anti-Blunder Verification Trigger'
    ];
  }

  static final Map<int, Map<String, dynamic>> _dayDefinitions = {
    1: {
      'title': 'Day 1: Comprehensive Baseline Diagnostic',
      'theme': 'Complete Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1200,
      'prerequisites': <int>[],
      'objectives': [
        'Understand core grandmaster principles of Complete Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 1: Comprehensive Baseline Diagnostic

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Complete Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'diag_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/4p3/1bB1n3/2N2Q2/PPPP1PPP/R1B1K1NR w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Identify the decisive tactical blow.',
          solutionSan: ['Qxf7#'],
          explanation: 'Scholar mate motif on f7 guarded by the bishop on c4.',
          hints: ['Look at the vulnerable f7 square.', 'The queen and bishop coordinate on f7.'],
          motif: 'Mating Net',
        ),
        const CurriculumExercise(
          id: 'diag_2',
          fen: 'r1b1kb1r/pppp1ppp/8/4q3/4n3/2N2Q2/PPP2PPP/R1B1KB1R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Find the tactical removal of the defender.',
          solutionSan: ['Qxe4'],
          explanation: 'Queen wins the pinned knight or takes free material.',
          hints: ['Check which black piece is overloaded.'],
          motif: 'Removal of Defender',
        ),
        const CurriculumExercise(
          id: 'diag_3',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Take the direct vertical opposition.',
          solutionSan: ['Ke3'],
          explanation: 'Ke3 claims the opposition, restricting black king movement.',
          hints: ['Place your king on the same file with one square in between.'],
          motif: 'Opposition',
        ),
      ],
    },
    2: {
      'title': 'Day 2: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1215,
      'prerequisites': [1],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 2: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd2_ex1',
          fen: 'rnbqkbnr/ppp2ppp/8/3pp3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nxe5'],
          explanation: 'Demonstrates master-level execution of Hanging Piece.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Hanging Piece',
        ),
      ],
    },
    3: {
      'title': 'Day 3: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1229,
      'prerequisites': [2],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 3: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd3_ex1',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['O-O'],
          explanation: 'Demonstrates master-level execution of King Safety.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Safety',
        ),
      ],
    },
    4: {
      'title': 'Day 4: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1244,
      'prerequisites': [3],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 4: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd4_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Bc5'],
          explanation: 'Demonstrates master-level execution of Piece Development.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Piece Development',
        ),
      ],
    },
    5: {
      'title': 'Day 5: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1258,
      'prerequisites': [4],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 5: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd5_ex1',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/3PP3/5N2/PPP2PPP/RNBQKB1R b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['exd4'],
          explanation: 'Demonstrates master-level execution of Pawn Tension.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Pawn Tension',
        ),
      ],
    },
    6: {
      'title': 'Day 6: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1273,
      'prerequisites': [5],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 6: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd6_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d3'],
          explanation: 'Demonstrates master-level execution of Quiet Move.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Quiet Move',
          isNoTacticPosition: true,
        ),
      ],
    },
    7: {
      'title': 'Day 7: Weekly Exam 1 (Tactics Gate 1)',
      'theme': 'Weekly Mastery Gate: Forks, Pins, Skewers & Double Attacks',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1287,
      'prerequisites': [1, 2, 3, 4, 5, 6],
      'objectives': [
        'Understand core grandmaster principles of Weekly Mastery Gate: Forks, Pins, Skewers & Double Attacks.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 7: Weekly Exam 1 (Tactics Gate 1)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Weekly Mastery Gate: Forks, Pins, Skewers & Double Attacks**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd7_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d3'],
          explanation: 'Demonstrates master-level execution of Prophylaxis.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Prophylaxis',
          isNoTacticPosition: true,
        ),
      ],
    },
    8: {
      'title': 'Day 8: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1302,
      'prerequisites': [7],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 8: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd8_ex1',
          fen: '6k1/5ppp/8/8/8/8/1r3PPP/3R2K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Rd8#'],
          explanation: 'Demonstrates master-level execution of Back-Rank Mate.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Back-Rank Mate',
        ),
      ],
    },
    9: {
      'title': 'Day 9: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1316,
      'prerequisites': [8],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 9: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd9_ex1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Ke3'],
          explanation: 'Demonstrates master-level execution of Opposition.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Opposition',
        ),
      ],
    },
    10: {
      'title': 'Day 10: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1331,
      'prerequisites': [9],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 10: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd10_ex1',
          fen: '8/8/4k3/8/8/4K3/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd4'],
          explanation: 'Demonstrates master-level execution of Key Squares.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Key Squares',
        ),
      ],
    },
    11: {
      'title': 'Day 11: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1345,
      'prerequisites': [10],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 11: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd11_ex1',
          fen: 'r1b1kb1r/pppp1ppp/8/4q3/4n3/2N2Q2/PPP2PPP/R1B1KB1R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxe4'],
          explanation: 'Demonstrates master-level execution of Removal of Defender.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Removal of Defender',
        ),
      ],
    },
    12: {
      'title': 'Day 12: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1360,
      'prerequisites': [11],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 12: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd12_ex1',
          fen: 'r1b1k2r/pppp1ppp/2n5/2b1p3/2B1n2q/2N2Q2/PPPP1PPP/R1B1K2R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxf7+'],
          explanation: 'Demonstrates master-level execution of Attack on King.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Attack on King',
        ),
      ],
    },
    13: {
      'title': 'Day 13: Tactical Motifs, Pattern Recognition & Combinations',
      'theme': 'Tactical Motifs, Pattern Recognition & Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1374,
      'prerequisites': [12],
      'objectives': [
        'Understand core grandmaster principles of Tactical Motifs, Pattern Recognition & Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 13: Tactical Motifs, Pattern Recognition & Combinations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tactical Motifs, Pattern Recognition & Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd13_ex1',
          fen: 'r2qkb1r/pp2pppp/2n2n2/1Bpp4/3P4/2N1PN2/PPP2PPP/R1BQK2R w KQkq - 2 6',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['O-O'],
          explanation: 'Demonstrates master-level execution of Candidate Selection.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Candidate Selection',
        ),
      ],
    },
    14: {
      'title': 'Day 14: Weekly Exam 2 (Tactics Mastery Gate)',
      'theme': 'Complete Tactical Foundation Gate & Multi-Motif Combinations',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1389,
      'prerequisites': [7, 8, 9, 10, 11, 12, 13],
      'objectives': [
        'Understand core grandmaster principles of Complete Tactical Foundation Gate & Multi-Motif Combinations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 14: Weekly Exam 2 (Tactics Mastery Gate)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Complete Tactical Foundation Gate & Multi-Motif Combinations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd14_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 b - - 5 8',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['b6'],
          explanation: 'Demonstrates master-level execution of Pawn Break.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Pawn Break',
        ),
      ],
    },
    15: {
      'title': 'Day 15: Calculation Trees, Candidate Generation & Pruning',
      'theme': 'Calculation Trees, Candidate Generation & Pruning',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1403,
      'prerequisites': [14],
      'objectives': [
        'Understand core grandmaster principles of Calculation Trees, Candidate Generation & Pruning.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 15: Calculation Trees, Candidate Generation & Pruning

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Calculation Trees, Candidate Generation & Pruning**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd15_ex1',
          fen: 'r1b2rk1/ppqn1ppp/2p1pn2/3p4/2PP4/1PN1PN2/P1Q1BPPP/R1B2RK1 w - - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4'],
          explanation: 'Demonstrates master-level execution of Central Break.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Central Break',
        ),
      ],
    },
    16: {
      'title': 'Day 16: Calculation Trees, Candidate Generation & Pruning',
      'theme': 'Calculation Trees, Candidate Generation & Pruning',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1418,
      'prerequisites': [15],
      'objectives': [
        'Understand core grandmaster principles of Calculation Trees, Candidate Generation & Pruning.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 16: Calculation Trees, Candidate Generation & Pruning

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Calculation Trees, Candidate Generation & Pruning**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd16_ex1',
          fen: '1K1k4/1P6/8/8/8/8/7r/2R5 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Rc4'],
          explanation: 'Demonstrates master-level execution of Lucena Bridge.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Lucena Bridge',
        ),
      ],
    },
    17: {
      'title': 'Day 17: Calculation Trees, Candidate Generation & Pruning',
      'theme': 'Calculation Trees, Candidate Generation & Pruning',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1432,
      'prerequisites': [16],
      'objectives': [
        'Understand core grandmaster principles of Calculation Trees, Candidate Generation & Pruning.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 17: Calculation Trees, Candidate Generation & Pruning

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Calculation Trees, Candidate Generation & Pruning**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd17_ex1',
          fen: '8/8/8/4k3/8/4K3/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd3'],
          explanation: 'Demonstrates master-level execution of King Activity.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Activity',
        ),
      ],
    },
    18: {
      'title': 'Day 18: Calculation Trees, Candidate Generation & Pruning',
      'theme': 'Calculation Trees, Candidate Generation & Pruning',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1447,
      'prerequisites': [17],
      'objectives': [
        'Understand core grandmaster principles of Calculation Trees, Candidate Generation & Pruning.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 18: Calculation Trees, Candidate Generation & Pruning

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Calculation Trees, Candidate Generation & Pruning**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd18_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2NP1N2/PPP2PPP/R1BQK2R b KQkq - 0 5',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d6'],
          explanation: 'Demonstrates master-level execution of Piece Harmony.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Piece Harmony',
        ),
      ],
    },
    19: {
      'title': 'Day 19: Calculation Trees, Candidate Generation & Pruning',
      'theme': 'Calculation Trees, Candidate Generation & Pruning',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1461,
      'prerequisites': [18],
      'objectives': [
        'Understand core grandmaster principles of Calculation Trees, Candidate Generation & Pruning.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 19: Calculation Trees, Candidate Generation & Pruning

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Calculation Trees, Candidate Generation & Pruning**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd19_ex1',
          fen: 'r1b2rk1/pp1nqppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ2PPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4'],
          explanation: 'Demonstrates master-level execution of King Attack.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Attack',
        ),
      ],
    },
    20: {
      'title': 'Day 20: Calculation Trees, Candidate Generation & Pruning',
      'theme': 'Calculation Trees, Candidate Generation & Pruning',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1476,
      'prerequisites': [19],
      'objectives': [
        'Understand core grandmaster principles of Calculation Trees, Candidate Generation & Pruning.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 20: Calculation Trees, Candidate Generation & Pruning

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Calculation Trees, Candidate Generation & Pruning**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd20_ex1',
          fen: '8/5k2/8/3K4/4P3/8/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd6'],
          explanation: 'Demonstrates master-level execution of King Escort.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Escort',
        ),
      ],
    },
    21: {
      'title': 'Day 21: Weekly Exam 3 (Calculation Gate 1)',
      'theme': 'Calculation Depth, Candidate Selection & Move Ordering',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1490,
      'prerequisites': [14, 15, 16, 17, 18, 19, 20],
      'objectives': [
        'Understand core grandmaster principles of Calculation Depth, Candidate Selection & Move Ordering.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 21: Weekly Exam 3 (Calculation Gate 1)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Calculation Depth, Candidate Selection & Move Ordering**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd21_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxf7#'],
          explanation: 'Demonstrates master-level execution of Checkmate.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Checkmate',
        ),
      ],
    },
    22: {
      'title': 'Day 22: Blindfold Visualization, Board Memory & Mental Board Stepping',
      'theme': 'Blindfold Visualization, Board Memory & Mental Board Stepping',
      'axis': SkillAxis.visualization,
      'lab': 'board_memory_lab',
      'difficulty': 1505,
      'prerequisites': [21],
      'objectives': [
        'Understand core grandmaster principles of Blindfold Visualization, Board Memory & Mental Board Stepping.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 22: Blindfold Visualization, Board Memory & Mental Board Stepping

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Blindfold Visualization, Board Memory & Mental Board Stepping**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd22_ex1',
          fen: '8/8/8/3k4/8/3K4/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4+'],
          explanation: 'Demonstrates master-level execution of Tempo Push.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Tempo Push',
        ),
      ],
    },
    23: {
      'title': 'Day 23: Blindfold Visualization, Board Memory & Mental Board Stepping',
      'theme': 'Blindfold Visualization, Board Memory & Mental Board Stepping',
      'axis': SkillAxis.visualization,
      'lab': 'visualization_lab',
      'difficulty': 1519,
      'prerequisites': [22],
      'objectives': [
        'Understand core grandmaster principles of Blindfold Visualization, Board Memory & Mental Board Stepping.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 23: Blindfold Visualization, Board Memory & Mental Board Stepping

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Blindfold Visualization, Board Memory & Mental Board Stepping**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd23_ex1',
          fen: 'r1b1k2r/pppp1ppp/8/4n3/3N4/2P5/P1P2PPP/R1B1KB1R w KQkq - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nb5'],
          explanation: 'Demonstrates master-level execution of Outpost Threat.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Outpost Threat',
        ),
      ],
    },
    24: {
      'title': 'Day 24: Blindfold Visualization, Board Memory & Mental Board Stepping',
      'theme': 'Blindfold Visualization, Board Memory & Mental Board Stepping',
      'axis': SkillAxis.visualization,
      'lab': 'board_memory_lab',
      'difficulty': 1534,
      'prerequisites': [23],
      'objectives': [
        'Understand core grandmaster principles of Blindfold Visualization, Board Memory & Mental Board Stepping.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 24: Blindfold Visualization, Board Memory & Mental Board Stepping

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Blindfold Visualization, Board Memory & Mental Board Stepping**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd24_ex1',
          fen: 'r4rk1/ppp2ppp/2n5/8/8/5N2/PPP2PPP/R3R1K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Re3'],
          explanation: 'Demonstrates master-level execution of Rook Lift.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Rook Lift',
        ),
      ],
    },
    25: {
      'title': 'Day 25: Blindfold Visualization, Board Memory & Mental Board Stepping',
      'theme': 'Blindfold Visualization, Board Memory & Mental Board Stepping',
      'axis': SkillAxis.visualization,
      'lab': 'visualization_lab',
      'difficulty': 1548,
      'prerequisites': [24],
      'objectives': [
        'Understand core grandmaster principles of Blindfold Visualization, Board Memory & Mental Board Stepping.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 25: Blindfold Visualization, Board Memory & Mental Board Stepping

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Blindfold Visualization, Board Memory & Mental Board Stepping**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd25_ex1',
          fen: '4k3/8/8/8/8/8/1r6/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Ra8+'],
          explanation: 'Demonstrates master-level execution of Skewer.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Skewer',
        ),
      ],
    },
    26: {
      'title': 'Day 26: Blindfold Visualization, Board Memory & Mental Board Stepping',
      'theme': 'Blindfold Visualization, Board Memory & Mental Board Stepping',
      'axis': SkillAxis.visualization,
      'lab': 'board_memory_lab',
      'difficulty': 1563,
      'prerequisites': [25],
      'objectives': [
        'Understand core grandmaster principles of Blindfold Visualization, Board Memory & Mental Board Stepping.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 26: Blindfold Visualization, Board Memory & Mental Board Stepping

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Blindfold Visualization, Board Memory & Mental Board Stepping**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd26_ex1',
          fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nf3'],
          explanation: 'Demonstrates master-level execution of Repertoire Opening.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Repertoire Opening',
        ),
      ],
    },
    27: {
      'title': 'Day 27: Blindfold Visualization, Board Memory & Mental Board Stepping',
      'theme': 'Blindfold Visualization, Board Memory & Mental Board Stepping',
      'axis': SkillAxis.visualization,
      'lab': 'visualization_lab',
      'difficulty': 1577,
      'prerequisites': [26],
      'objectives': [
        'Understand core grandmaster principles of Blindfold Visualization, Board Memory & Mental Board Stepping.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 27: Blindfold Visualization, Board Memory & Mental Board Stepping

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Blindfold Visualization, Board Memory & Mental Board Stepping**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd27_ex1',
          fen: 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nf3'],
          explanation: 'Demonstrates master-level execution of Sicilian Control.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Sicilian Control',
        ),
      ],
    },
    28: {
      'title': 'Day 28: Weekly Exam 4 (Calculation & Visualization Mastery)',
      'theme': 'Calculation & Visualization Mastery Gate (Phase 3 Graduation)',
      'axis': SkillAxis.visualization,
      'lab': 'blind_calculation_lab',
      'difficulty': 1592,
      'prerequisites': [21, 22, 23, 24, 25, 26, 27],
      'objectives': [
        'Understand core grandmaster principles of Calculation & Visualization Mastery Gate (Phase 3 Graduation).',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 28: Weekly Exam 4 (Calculation & Visualization Mastery)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Calculation & Visualization Mastery Gate (Phase 3 Graduation)**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd28_ex1',
          fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d4'],
          explanation: 'Demonstrates master-level execution of French Center.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'French Center',
        ),
      ],
    },
    29: {
      'title': 'Day 29: Imbalances, Weak Squares, Outposts & Prophylaxis',
      'theme': 'Imbalances, Weak Squares, Outposts & Prophylaxis',
      'axis': SkillAxis.strategy,
      'lab': 'improve_worst_piece_lab',
      'difficulty': 1606,
      'prerequisites': [28],
      'objectives': [
        'Understand core grandmaster principles of Imbalances, Weak Squares, Outposts & Prophylaxis.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 29: Imbalances, Weak Squares, Outposts & Prophylaxis

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Imbalances, Weak Squares, Outposts & Prophylaxis**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd29_ex1',
          fen: 'rnbqkbnr/pp1ppppp/2p5/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d4'],
          explanation: 'Demonstrates master-level execution of Caro Center.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Caro Center',
        ),
      ],
    },
    30: {
      'title': 'Day 30: Imbalances, Weak Squares, Outposts & Prophylaxis',
      'theme': 'Imbalances, Weak Squares, Outposts & Prophylaxis',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1621,
      'prerequisites': [29],
      'objectives': [
        'Understand core grandmaster principles of Imbalances, Weak Squares, Outposts & Prophylaxis.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 30: Imbalances, Weak Squares, Outposts & Prophylaxis

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Imbalances, Weak Squares, Outposts & Prophylaxis**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd30_ex1',
          fen: 'rnbqkb1r/pppppp1p/5np1/8/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nc3'],
          explanation: 'Demonstrates master-level execution of KID Challenge.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'KID Challenge',
        ),
      ],
    },
    31: {
      'title': 'Day 31: Imbalances, Weak Squares, Outposts & Prophylaxis',
      'theme': 'Imbalances, Weak Squares, Outposts & Prophylaxis',
      'axis': SkillAxis.strategy,
      'lab': 'improve_worst_piece_lab',
      'difficulty': 1635,
      'prerequisites': [30],
      'objectives': [
        'Understand core grandmaster principles of Imbalances, Weak Squares, Outposts & Prophylaxis.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 31: Imbalances, Weak Squares, Outposts & Prophylaxis

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Imbalances, Weak Squares, Outposts & Prophylaxis**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd31_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n5/4p3/1bB1n3/2N2Q2/PPPP1PPP/R1B1K1NR w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxf7#'],
          explanation: 'Demonstrates master-level execution of Mating Net.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Mating Net',
        ),
      ],
    },
    32: {
      'title': 'Day 32: Imbalances, Weak Squares, Outposts & Prophylaxis',
      'theme': 'Imbalances, Weak Squares, Outposts & Prophylaxis',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1650,
      'prerequisites': [31],
      'objectives': [
        'Understand core grandmaster principles of Imbalances, Weak Squares, Outposts & Prophylaxis.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 32: Imbalances, Weak Squares, Outposts & Prophylaxis

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Imbalances, Weak Squares, Outposts & Prophylaxis**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd32_ex1',
          fen: 'rnbqkbnr/ppp2ppp/8/3pp3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nxe5'],
          explanation: 'Demonstrates master-level execution of Hanging Piece.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Hanging Piece',
        ),
      ],
    },
    33: {
      'title': 'Day 33: Imbalances, Weak Squares, Outposts & Prophylaxis',
      'theme': 'Imbalances, Weak Squares, Outposts & Prophylaxis',
      'axis': SkillAxis.strategy,
      'lab': 'improve_worst_piece_lab',
      'difficulty': 1664,
      'prerequisites': [32],
      'objectives': [
        'Understand core grandmaster principles of Imbalances, Weak Squares, Outposts & Prophylaxis.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 33: Imbalances, Weak Squares, Outposts & Prophylaxis

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Imbalances, Weak Squares, Outposts & Prophylaxis**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd33_ex1',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['O-O'],
          explanation: 'Demonstrates master-level execution of King Safety.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Safety',
        ),
      ],
    },
    34: {
      'title': 'Day 34: Imbalances, Weak Squares, Outposts & Prophylaxis',
      'theme': 'Imbalances, Weak Squares, Outposts & Prophylaxis',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1679,
      'prerequisites': [33],
      'objectives': [
        'Understand core grandmaster principles of Imbalances, Weak Squares, Outposts & Prophylaxis.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 34: Imbalances, Weak Squares, Outposts & Prophylaxis

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Imbalances, Weak Squares, Outposts & Prophylaxis**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd34_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Bc5'],
          explanation: 'Demonstrates master-level execution of Piece Development.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Piece Development',
        ),
      ],
    },
    35: {
      'title': 'Day 35: Weekly Exam 5 (Positional Strategy Gate 1)',
      'theme': 'Imbalances, Weak Squares, Outposts & Piece Coordination',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1693,
      'prerequisites': [28, 29, 30, 31, 32, 33, 34],
      'objectives': [
        'Understand core grandmaster principles of Imbalances, Weak Squares, Outposts & Piece Coordination.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 35: Weekly Exam 5 (Positional Strategy Gate 1)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Imbalances, Weak Squares, Outposts & Piece Coordination**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd35_ex1',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/3PP3/5N2/PPP2PPP/RNBQKB1R b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['exd4'],
          explanation: 'Demonstrates master-level execution of Pawn Tension.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Pawn Tension',
        ),
      ],
    },
    36: {
      'title': 'Day 36: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'theme': 'Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1708,
      'prerequisites': [35],
      'objectives': [
        'Understand core grandmaster principles of Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 36: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd36_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d3'],
          explanation: 'Demonstrates master-level execution of Quiet Move.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Quiet Move',
          isNoTacticPosition: true,
        ),
      ],
    },
    37: {
      'title': 'Day 37: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'theme': 'Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1722,
      'prerequisites': [36],
      'objectives': [
        'Understand core grandmaster principles of Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 37: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd37_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d3'],
          explanation: 'Demonstrates master-level execution of Prophylaxis.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Prophylaxis',
          isNoTacticPosition: true,
        ),
      ],
    },
    38: {
      'title': 'Day 38: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'theme': 'Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1737,
      'prerequisites': [37],
      'objectives': [
        'Understand core grandmaster principles of Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 38: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd38_ex1',
          fen: '6k1/5ppp/8/8/8/8/1r3PPP/3R2K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Rd8#'],
          explanation: 'Demonstrates master-level execution of Back-Rank Mate.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Back-Rank Mate',
        ),
      ],
    },
    39: {
      'title': 'Day 39: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'theme': 'Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1751,
      'prerequisites': [38],
      'objectives': [
        'Understand core grandmaster principles of Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 39: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd39_ex1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Ke3'],
          explanation: 'Demonstrates master-level execution of Opposition.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Opposition',
        ),
      ],
    },
    40: {
      'title': 'Day 40: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'theme': 'Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1766,
      'prerequisites': [39],
      'objectives': [
        'Understand core grandmaster principles of Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 40: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd40_ex1',
          fen: '8/8/4k3/8/8/4K3/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd4'],
          explanation: 'Demonstrates master-level execution of Key Squares.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Key Squares',
        ),
      ],
    },
    41: {
      'title': 'Day 41: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'theme': 'Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1780,
      'prerequisites': [40],
      'objectives': [
        'Understand core grandmaster principles of Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 41: Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Pawn Structures: IQP, Carlsbad, Maroczy & Hedgehog Formations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd41_ex1',
          fen: 'r1b1kb1r/pppp1ppp/8/4q3/4n3/2N2Q2/PPP2PPP/R1B1KB1R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxe4'],
          explanation: 'Demonstrates master-level execution of Removal of Defender.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Removal of Defender',
        ),
      ],
    },
    42: {
      'title': 'Day 42: Weekly Exam 6 (Strategy & Pawn Structures Gate)',
      'theme': 'Pawn Structure Mastery: IQP, Carlsbad, Maroczy & Hedgehog Formations',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1795,
      'prerequisites': [35, 36, 37, 38, 39, 40, 41],
      'objectives': [
        'Understand core grandmaster principles of Pawn Structure Mastery: IQP, Carlsbad, Maroczy & Hedgehog Formations.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 42: Weekly Exam 6 (Strategy & Pawn Structures Gate)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Pawn Structure Mastery: IQP, Carlsbad, Maroczy & Hedgehog Formations**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd42_ex1',
          fen: 'r1b1k2r/pppp1ppp/2n5/2b1p3/2B1n2q/2N2Q2/PPPP1PPP/R1B1K2R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxf7+'],
          explanation: 'Demonstrates master-level execution of Attack on King.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Attack on King',
        ),
      ],
    },
    43: {
      'title': 'Day 43: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1809,
      'prerequisites': [42],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 43: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd43_ex1',
          fen: 'r2qkb1r/pp2pppp/2n2n2/1Bpp4/3P4/2N1PN2/PPP2PPP/R1BQK2R w KQkq - 2 6',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['O-O'],
          explanation: 'Demonstrates master-level execution of Candidate Selection.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Candidate Selection',
        ),
      ],
    },
    44: {
      'title': 'Day 44: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1824,
      'prerequisites': [43],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 44: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd44_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 b - - 5 8',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['b6'],
          explanation: 'Demonstrates master-level execution of Pawn Break.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Pawn Break',
        ),
      ],
    },
    45: {
      'title': 'Day 45: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1838,
      'prerequisites': [44],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 45: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd45_ex1',
          fen: 'r1b2rk1/ppqn1ppp/2p1pn2/3p4/2PP4/1PN1PN2/P1Q1BPPP/R1B2RK1 w - - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4'],
          explanation: 'Demonstrates master-level execution of Central Break.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Central Break',
        ),
      ],
    },
    46: {
      'title': 'Day 46: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1853,
      'prerequisites': [45],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 46: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd46_ex1',
          fen: '1K1k4/1P6/8/8/8/8/7r/2R5 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Rc4'],
          explanation: 'Demonstrates master-level execution of Lucena Bridge.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Lucena Bridge',
        ),
      ],
    },
    47: {
      'title': 'Day 47: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1867,
      'prerequisites': [46],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 47: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd47_ex1',
          fen: '8/8/8/4k3/8/4K3/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd3'],
          explanation: 'Demonstrates master-level execution of King Activity.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Activity',
        ),
      ],
    },
    48: {
      'title': 'Day 48: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1882,
      'prerequisites': [47],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 48: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd48_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2NP1N2/PPP2PPP/R1BQK2R b KQkq - 0 5',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d6'],
          explanation: 'Demonstrates master-level execution of Piece Harmony.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Piece Harmony',
        ),
      ],
    },
    49: {
      'title': 'Day 49: Weekly Exam 7 (Pawn & Rook Endgames Gate)',
      'theme': 'Theoretical Rook Endings: Lucena Position & Philidor Defense',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1896,
      'prerequisites': [42, 43, 44, 45, 46, 47, 48],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Rook Endings: Lucena Position & Philidor Defense.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 49: Weekly Exam 7 (Pawn & Rook Endgames Gate)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Rook Endings: Lucena Position & Philidor Defense**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd49_ex1',
          fen: 'r1b2rk1/pp1nqppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ2PPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4'],
          explanation: 'Demonstrates master-level execution of King Attack.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Attack',
        ),
      ],
    },
    50: {
      'title': 'Day 50: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1911,
      'prerequisites': [49],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 50: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd50_ex1',
          fen: '8/5k2/8/3K4/4P3/8/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd6'],
          explanation: 'Demonstrates master-level execution of King Escort.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Escort',
        ),
      ],
    },
    51: {
      'title': 'Day 51: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1925,
      'prerequisites': [50],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 51: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd51_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxf7#'],
          explanation: 'Demonstrates master-level execution of Checkmate.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Checkmate',
        ),
      ],
    },
    52: {
      'title': 'Day 52: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1940,
      'prerequisites': [51],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 52: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd52_ex1',
          fen: '8/8/8/3k4/8/3K4/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4+'],
          explanation: 'Demonstrates master-level execution of Tempo Push.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Tempo Push',
        ),
      ],
    },
    53: {
      'title': 'Day 53: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1954,
      'prerequisites': [52],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 53: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd53_ex1',
          fen: 'r1b1k2r/pppp1ppp/8/4n3/3N4/2P5/P1P2PPP/R1B1KB1R w KQkq - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nb5'],
          explanation: 'Demonstrates master-level execution of Outpost Threat.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Outpost Threat',
        ),
      ],
    },
    54: {
      'title': 'Day 54: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1969,
      'prerequisites': [53],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 54: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd54_ex1',
          fen: 'r4rk1/ppp2ppp/2n5/8/8/5N2/PPP2PPP/R3R1K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Re3'],
          explanation: 'Demonstrates master-level execution of Rook Lift.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Rook Lift',
        ),
      ],
    },
    55: {
      'title': 'Day 55: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'theme': 'Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1983,
      'prerequisites': [54],
      'objectives': [
        'Understand core grandmaster principles of Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 55: Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Theoretical Endgames: Opposition, Rooks & Minor Piece Mastery**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd55_ex1',
          fen: '4k3/8/8/8/8/8/1r6/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Ra8+'],
          explanation: 'Demonstrates master-level execution of Skewer.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Skewer',
        ),
      ],
    },
    56: {
      'title': 'Day 56: Weekly Exam 8 (Endgame Mastery Gate)',
      'theme': 'Complete Endgame Mastery: Minor Pieces, Vancura & Queen Endings',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1998,
      'prerequisites': [49, 50, 51, 52, 53, 54, 55],
      'objectives': [
        'Understand core grandmaster principles of Complete Endgame Mastery: Minor Pieces, Vancura & Queen Endings.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 56: Weekly Exam 8 (Endgame Mastery Gate)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Complete Endgame Mastery: Minor Pieces, Vancura & Queen Endings**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd56_ex1',
          fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nf3'],
          explanation: 'Demonstrates master-level execution of Repertoire Opening.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Repertoire Opening',
        ),
      ],
    },
    57: {
      'title': 'Day 57: Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'theme': 'Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'axis': SkillAxis.openings,
      'lab': 'guess_the_move_lab',
      'difficulty': 2012,
      'prerequisites': [56],
      'objectives': [
        'Understand core grandmaster principles of Opening Plans, Typical Pawn Breaks & Model Repertoire.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 57: Opening Plans, Typical Pawn Breaks & Model Repertoire

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Opening Plans, Typical Pawn Breaks & Model Repertoire**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd57_ex1',
          fen: 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nf3'],
          explanation: 'Demonstrates master-level execution of Sicilian Control.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Sicilian Control',
        ),
      ],
    },
    58: {
      'title': 'Day 58: Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'theme': 'Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2027,
      'prerequisites': [57],
      'objectives': [
        'Understand core grandmaster principles of Opening Plans, Typical Pawn Breaks & Model Repertoire.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 58: Opening Plans, Typical Pawn Breaks & Model Repertoire

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Opening Plans, Typical Pawn Breaks & Model Repertoire**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd58_ex1',
          fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d4'],
          explanation: 'Demonstrates master-level execution of French Center.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'French Center',
        ),
      ],
    },
    59: {
      'title': 'Day 59: Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'theme': 'Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'axis': SkillAxis.openings,
      'lab': 'guess_the_move_lab',
      'difficulty': 2041,
      'prerequisites': [58],
      'objectives': [
        'Understand core grandmaster principles of Opening Plans, Typical Pawn Breaks & Model Repertoire.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 59: Opening Plans, Typical Pawn Breaks & Model Repertoire

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Opening Plans, Typical Pawn Breaks & Model Repertoire**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd59_ex1',
          fen: 'rnbqkbnr/pp1ppppp/2p5/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d4'],
          explanation: 'Demonstrates master-level execution of Caro Center.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Caro Center',
        ),
      ],
    },
    60: {
      'title': 'Day 60: Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'theme': 'Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2056,
      'prerequisites': [59],
      'objectives': [
        'Understand core grandmaster principles of Opening Plans, Typical Pawn Breaks & Model Repertoire.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 60: Opening Plans, Typical Pawn Breaks & Model Repertoire

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Opening Plans, Typical Pawn Breaks & Model Repertoire**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd60_ex1',
          fen: 'rnbqkb1r/pppppp1p/5np1/8/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nc3'],
          explanation: 'Demonstrates master-level execution of KID Challenge.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'KID Challenge',
        ),
      ],
    },
    61: {
      'title': 'Day 61: Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'theme': 'Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'axis': SkillAxis.openings,
      'lab': 'guess_the_move_lab',
      'difficulty': 2070,
      'prerequisites': [60],
      'objectives': [
        'Understand core grandmaster principles of Opening Plans, Typical Pawn Breaks & Model Repertoire.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 61: Opening Plans, Typical Pawn Breaks & Model Repertoire

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Opening Plans, Typical Pawn Breaks & Model Repertoire**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd61_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n5/4p3/1bB1n3/2N2Q2/PPPP1PPP/R1B1K1NR w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxf7#'],
          explanation: 'Demonstrates master-level execution of Mating Net.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Mating Net',
        ),
      ],
    },
    62: {
      'title': 'Day 62: Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'theme': 'Opening Plans, Typical Pawn Breaks & Model Repertoire',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2085,
      'prerequisites': [61],
      'objectives': [
        'Understand core grandmaster principles of Opening Plans, Typical Pawn Breaks & Model Repertoire.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 62: Opening Plans, Typical Pawn Breaks & Model Repertoire

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Opening Plans, Typical Pawn Breaks & Model Repertoire**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd62_ex1',
          fen: 'rnbqkbnr/ppp2ppp/8/3pp3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nxe5'],
          explanation: 'Demonstrates master-level execution of Hanging Piece.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Hanging Piece',
        ),
      ],
    },
    63: {
      'title': 'Day 63: Weekly Exam 9 (Opening Repertoire & Plan Test)',
      'theme': 'Compact Personalized Repertoire & Transposition Audit',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2099,
      'prerequisites': [56, 57, 58, 59, 60, 61, 62],
      'objectives': [
        'Understand core grandmaster principles of Compact Personalized Repertoire & Transposition Audit.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 63: Weekly Exam 9 (Opening Repertoire & Plan Test)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Compact Personalized Repertoire & Transposition Audit**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd63_ex1',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['O-O'],
          explanation: 'Demonstrates master-level execution of King Safety.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Safety',
        ),
      ],
    },
    64: {
      'title': 'Day 64: King Attack Dynamics & Breakthrough Sacrifices',
      'theme': 'King Attack Dynamics & Breakthrough Sacrifices',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2114,
      'prerequisites': [63],
      'objectives': [
        'Understand core grandmaster principles of King Attack Dynamics & Breakthrough Sacrifices.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 64: King Attack Dynamics & Breakthrough Sacrifices

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **King Attack Dynamics & Breakthrough Sacrifices**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd64_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Bc5'],
          explanation: 'Demonstrates master-level execution of Piece Development.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Piece Development',
        ),
      ],
    },
    65: {
      'title': 'Day 65: King Attack Dynamics & Breakthrough Sacrifices',
      'theme': 'King Attack Dynamics & Breakthrough Sacrifices',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2128,
      'prerequisites': [64],
      'objectives': [
        'Understand core grandmaster principles of King Attack Dynamics & Breakthrough Sacrifices.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 65: King Attack Dynamics & Breakthrough Sacrifices

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **King Attack Dynamics & Breakthrough Sacrifices**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd65_ex1',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/3PP3/5N2/PPP2PPP/RNBQKB1R b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['exd4'],
          explanation: 'Demonstrates master-level execution of Pawn Tension.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Pawn Tension',
        ),
      ],
    },
    66: {
      'title': 'Day 66: King Attack Dynamics & Breakthrough Sacrifices',
      'theme': 'King Attack Dynamics & Breakthrough Sacrifices',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2143,
      'prerequisites': [65],
      'objectives': [
        'Understand core grandmaster principles of King Attack Dynamics & Breakthrough Sacrifices.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 66: King Attack Dynamics & Breakthrough Sacrifices

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **King Attack Dynamics & Breakthrough Sacrifices**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd66_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d3'],
          explanation: 'Demonstrates master-level execution of Quiet Move.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Quiet Move',
          isNoTacticPosition: true,
        ),
      ],
    },
    67: {
      'title': 'Day 67: Defensive Tenacity, Prophylaxis & Fortress Construction',
      'theme': 'Defensive Tenacity, Prophylaxis & Fortress Construction',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 2157,
      'prerequisites': [66],
      'objectives': [
        'Understand core grandmaster principles of Defensive Tenacity, Prophylaxis & Fortress Construction.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 67: Defensive Tenacity, Prophylaxis & Fortress Construction

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Defensive Tenacity, Prophylaxis & Fortress Construction**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd67_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d3'],
          explanation: 'Demonstrates master-level execution of Prophylaxis.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Prophylaxis',
          isNoTacticPosition: true,
        ),
      ],
    },
    68: {
      'title': 'Day 68: Defensive Tenacity, Prophylaxis & Fortress Construction',
      'theme': 'Defensive Tenacity, Prophylaxis & Fortress Construction',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 2172,
      'prerequisites': [67],
      'objectives': [
        'Understand core grandmaster principles of Defensive Tenacity, Prophylaxis & Fortress Construction.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 68: Defensive Tenacity, Prophylaxis & Fortress Construction

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Defensive Tenacity, Prophylaxis & Fortress Construction**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd68_ex1',
          fen: '6k1/5ppp/8/8/8/8/1r3PPP/3R2K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Rd8#'],
          explanation: 'Demonstrates master-level execution of Back-Rank Mate.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Back-Rank Mate',
        ),
      ],
    },
    69: {
      'title': 'Day 69: Defensive Tenacity, Prophylaxis & Fortress Construction',
      'theme': 'Defensive Tenacity, Prophylaxis & Fortress Construction',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 2186,
      'prerequisites': [68],
      'objectives': [
        'Understand core grandmaster principles of Defensive Tenacity, Prophylaxis & Fortress Construction.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 69: Defensive Tenacity, Prophylaxis & Fortress Construction

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Defensive Tenacity, Prophylaxis & Fortress Construction**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd69_ex1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Ke3'],
          explanation: 'Demonstrates master-level execution of Opposition.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Opposition',
        ),
      ],
    },
    70: {
      'title': 'Day 70: Weekly Exam 10 (Attack & Defense Gate)',
      'theme': 'Attacking the Castled King, Sacrificial Breakdowns & Fortress Defense',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 2201,
      'prerequisites': [63, 64, 65, 66, 67, 68, 69],
      'objectives': [
        'Understand core grandmaster principles of Attacking the Castled King, Sacrificial Breakdowns & Fortress Defense.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 70: Weekly Exam 10 (Attack & Defense Gate)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Attacking the Castled King, Sacrificial Breakdowns & Fortress Defense**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd70_ex1',
          fen: '8/8/4k3/8/8/4K3/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd4'],
          explanation: 'Demonstrates master-level execution of Key Squares.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Key Squares',
        ),
      ],
    },
    71: {
      'title': 'Day 71: Advantage Conversion & Neutralizing Counterplay',
      'theme': 'Advantage Conversion & Neutralizing Counterplay',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2215,
      'prerequisites': [70],
      'objectives': [
        'Understand core grandmaster principles of Advantage Conversion & Neutralizing Counterplay.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 71: Advantage Conversion & Neutralizing Counterplay

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Advantage Conversion & Neutralizing Counterplay**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd71_ex1',
          fen: 'r1b1kb1r/pppp1ppp/8/4q3/4n3/2N2Q2/PPP2PPP/R1B1KB1R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxe4'],
          explanation: 'Demonstrates master-level execution of Removal of Defender.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Removal of Defender',
        ),
      ],
    },
    72: {
      'title': 'Day 72: Advantage Conversion & Neutralizing Counterplay',
      'theme': 'Advantage Conversion & Neutralizing Counterplay',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2230,
      'prerequisites': [71],
      'objectives': [
        'Understand core grandmaster principles of Advantage Conversion & Neutralizing Counterplay.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 72: Advantage Conversion & Neutralizing Counterplay

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Advantage Conversion & Neutralizing Counterplay**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd72_ex1',
          fen: 'r1b1k2r/pppp1ppp/2n5/2b1p3/2B1n2q/2N2Q2/PPPP1PPP/R1B1K2R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxf7+'],
          explanation: 'Demonstrates master-level execution of Attack on King.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Attack on King',
        ),
      ],
    },
    73: {
      'title': 'Day 73: Advantage Conversion & Neutralizing Counterplay',
      'theme': 'Advantage Conversion & Neutralizing Counterplay',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2244,
      'prerequisites': [72],
      'objectives': [
        'Understand core grandmaster principles of Advantage Conversion & Neutralizing Counterplay.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 73: Advantage Conversion & Neutralizing Counterplay

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Advantage Conversion & Neutralizing Counterplay**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd73_ex1',
          fen: 'r2qkb1r/pp2pppp/2n2n2/1Bpp4/3P4/2N1PN2/PPP2PPP/R1BQK2R w KQkq - 2 6',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['O-O'],
          explanation: 'Demonstrates master-level execution of Candidate Selection.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Candidate Selection',
        ),
      ],
    },
    74: {
      'title': 'Day 74: Advantage Conversion & Neutralizing Counterplay',
      'theme': 'Advantage Conversion & Neutralizing Counterplay',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2259,
      'prerequisites': [73],
      'objectives': [
        'Understand core grandmaster principles of Advantage Conversion & Neutralizing Counterplay.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 74: Advantage Conversion & Neutralizing Counterplay

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Advantage Conversion & Neutralizing Counterplay**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd74_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 b - - 5 8',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['b6'],
          explanation: 'Demonstrates master-level execution of Pawn Break.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Pawn Break',
        ),
      ],
    },
    75: {
      'title': 'Day 75: Time Management, Critical Moment Detection & Clock Composure',
      'theme': 'Time Management, Critical Moment Detection & Clock Composure',
      'axis': SkillAxis.timeManagement,
      'lab': 'time_management_lab',
      'difficulty': 2273,
      'prerequisites': [74],
      'objectives': [
        'Understand core grandmaster principles of Time Management, Critical Moment Detection & Clock Composure.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 75: Time Management, Critical Moment Detection & Clock Composure

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Time Management, Critical Moment Detection & Clock Composure**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd75_ex1',
          fen: 'r1b2rk1/ppqn1ppp/2p1pn2/3p4/2PP4/1PN1PN2/P1Q1BPPP/R1B2RK1 w - - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4'],
          explanation: 'Demonstrates master-level execution of Central Break.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Central Break',
        ),
      ],
    },
    76: {
      'title': 'Day 76: Time Management, Critical Moment Detection & Clock Composure',
      'theme': 'Time Management, Critical Moment Detection & Clock Composure',
      'axis': SkillAxis.timeManagement,
      'lab': 'time_management_lab',
      'difficulty': 2288,
      'prerequisites': [75],
      'objectives': [
        'Understand core grandmaster principles of Time Management, Critical Moment Detection & Clock Composure.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 76: Time Management, Critical Moment Detection & Clock Composure

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Time Management, Critical Moment Detection & Clock Composure**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd76_ex1',
          fen: '1K1k4/1P6/8/8/8/8/7r/2R5 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Rc4'],
          explanation: 'Demonstrates master-level execution of Lucena Bridge.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Lucena Bridge',
        ),
      ],
    },
    77: {
      'title': 'Day 77: Weekly Exam 11 (Conversion & Practical Decision Gate)',
      'theme': 'Advantage Conversion, Tension Management & Clock Composure',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2302,
      'prerequisites': [70, 71, 72, 73, 74, 75, 76],
      'objectives': [
        'Understand core grandmaster principles of Advantage Conversion, Tension Management & Clock Composure.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 77: Weekly Exam 11 (Conversion & Practical Decision Gate)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Advantage Conversion, Tension Management & Clock Composure**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd77_ex1',
          fen: '8/8/8/4k3/8/4K3/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd3'],
          explanation: 'Demonstrates master-level execution of King Activity.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Activity',
        ),
      ],
    },
    78: {
      'title': 'Day 78: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'theme': 'Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2317,
      'prerequisites': [77],
      'objectives': [
        'Understand core grandmaster principles of Tournament Simulation, Strict Self-Analysis & Root Cause Retraining.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 78: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tournament Simulation, Strict Self-Analysis & Root Cause Retraining**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd78_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2NP1N2/PPP2PPP/R1BQK2R b KQkq - 0 5',
          sideToPlay: PieceColor.black,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d6'],
          explanation: 'Demonstrates master-level execution of Piece Harmony.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Piece Harmony',
        ),
      ],
    },
    79: {
      'title': 'Day 79: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'theme': 'Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2331,
      'prerequisites': [78],
      'objectives': [
        'Understand core grandmaster principles of Tournament Simulation, Strict Self-Analysis & Root Cause Retraining.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 79: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tournament Simulation, Strict Self-Analysis & Root Cause Retraining**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd79_ex1',
          fen: 'r1b2rk1/pp1nqppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ2PPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4'],
          explanation: 'Demonstrates master-level execution of King Attack.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Attack',
        ),
      ],
    },
    80: {
      'title': 'Day 80: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'theme': 'Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2346,
      'prerequisites': [79],
      'objectives': [
        'Understand core grandmaster principles of Tournament Simulation, Strict Self-Analysis & Root Cause Retraining.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 80: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tournament Simulation, Strict Self-Analysis & Root Cause Retraining**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd80_ex1',
          fen: '8/5k2/8/3K4/4P3/8/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Kd6'],
          explanation: 'Demonstrates master-level execution of King Escort.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'King Escort',
        ),
      ],
    },
    81: {
      'title': 'Day 81: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'theme': 'Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2360,
      'prerequisites': [80],
      'objectives': [
        'Understand core grandmaster principles of Tournament Simulation, Strict Self-Analysis & Root Cause Retraining.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 81: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tournament Simulation, Strict Self-Analysis & Root Cause Retraining**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd81_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Qxf7#'],
          explanation: 'Demonstrates master-level execution of Checkmate.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Checkmate',
        ),
      ],
    },
    82: {
      'title': 'Day 82: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'theme': 'Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2375,
      'prerequisites': [81],
      'objectives': [
        'Understand core grandmaster principles of Tournament Simulation, Strict Self-Analysis & Root Cause Retraining.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 82: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tournament Simulation, Strict Self-Analysis & Root Cause Retraining**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd82_ex1',
          fen: '8/8/8/3k4/8/3K4/4P3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['e4+'],
          explanation: 'Demonstrates master-level execution of Tempo Push.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Tempo Push',
        ),
      ],
    },
    83: {
      'title': 'Day 83: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'theme': 'Tournament Simulation, Strict Self-Analysis & Root Cause Retraining',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2389,
      'prerequisites': [82],
      'objectives': [
        'Understand core grandmaster principles of Tournament Simulation, Strict Self-Analysis & Root Cause Retraining.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 83: Tournament Simulation, Strict Self-Analysis & Root Cause Retraining

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Tournament Simulation, Strict Self-Analysis & Root Cause Retraining**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd83_ex1',
          fen: 'r1b1k2r/pppp1ppp/8/4n3/3N4/2P5/P1P2PPP/R1B1KB1R w KQkq - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nb5'],
          explanation: 'Demonstrates master-level execution of Outpost Threat.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Outpost Threat',
        ),
      ],
    },
    84: {
      'title': 'Day 84: Weekly Exam 12 (Tournament Readiness Exam)',
      'theme': 'Classical Tournament Simulation (90+30) & Strict Self-Analysis',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2404,
      'prerequisites': [77, 78, 79, 80, 81, 82, 83],
      'objectives': [
        'Understand core grandmaster principles of Classical Tournament Simulation (90+30) & Strict Self-Analysis.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 84: Weekly Exam 12 (Tournament Readiness Exam)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Classical Tournament Simulation (90+30) & Strict Self-Analysis**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd84_ex1',
          fen: 'r4rk1/ppp2ppp/2n5/8/8/5N2/PPP2PPP/R3R1K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Re3'],
          explanation: 'Demonstrates master-level execution of Rook Lift.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Rook Lift',
        ),
      ],
    },
    85: {
      'title': 'Day 85: Integration, Retention Stabilization & Cognitive Re-anchoring',
      'theme': 'Integration, Retention Stabilization & Cognitive Re-anchoring',
      'axis': SkillAxis.calculation,
      'lab': 'visualization_lab',
      'difficulty': 2418,
      'prerequisites': [84],
      'objectives': [
        'Understand core grandmaster principles of Integration, Retention Stabilization & Cognitive Re-anchoring.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 85: Integration, Retention Stabilization & Cognitive Re-anchoring

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Integration, Retention Stabilization & Cognitive Re-anchoring**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd85_ex1',
          fen: '4k3/8/8/8/8/8/1r6/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Ra8+'],
          explanation: 'Demonstrates master-level execution of Skewer.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Skewer',
        ),
      ],
    },
    86: {
      'title': 'Day 86: Integration, Retention Stabilization & Cognitive Re-anchoring',
      'theme': 'Integration, Retention Stabilization & Cognitive Re-anchoring',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 2433,
      'prerequisites': [85],
      'objectives': [
        'Understand core grandmaster principles of Integration, Retention Stabilization & Cognitive Re-anchoring.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 86: Integration, Retention Stabilization & Cognitive Re-anchoring

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Integration, Retention Stabilization & Cognitive Re-anchoring**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd86_ex1',
          fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nf3'],
          explanation: 'Demonstrates master-level execution of Repertoire Opening.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Repertoire Opening',
        ),
      ],
    },
    87: {
      'title': 'Day 87: Integration, Retention Stabilization & Cognitive Re-anchoring',
      'theme': 'Integration, Retention Stabilization & Cognitive Re-anchoring',
      'axis': SkillAxis.calculation,
      'lab': 'visualization_lab',
      'difficulty': 2447,
      'prerequisites': [86],
      'objectives': [
        'Understand core grandmaster principles of Integration, Retention Stabilization & Cognitive Re-anchoring.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 87: Integration, Retention Stabilization & Cognitive Re-anchoring

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Integration, Retention Stabilization & Cognitive Re-anchoring**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd87_ex1',
          fen: 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nf3'],
          explanation: 'Demonstrates master-level execution of Sicilian Control.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Sicilian Control',
        ),
      ],
    },
    88: {
      'title': 'Day 88: Integration, Retention Stabilization & Cognitive Re-anchoring',
      'theme': 'Integration, Retention Stabilization & Cognitive Re-anchoring',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 2462,
      'prerequisites': [87],
      'objectives': [
        'Understand core grandmaster principles of Integration, Retention Stabilization & Cognitive Re-anchoring.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 88: Integration, Retention Stabilization & Cognitive Re-anchoring

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Integration, Retention Stabilization & Cognitive Re-anchoring**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd88_ex1',
          fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d4'],
          explanation: 'Demonstrates master-level execution of French Center.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'French Center',
        ),
      ],
    },
    89: {
      'title': 'Day 89: Integration, Retention Stabilization & Cognitive Re-anchoring',
      'theme': 'Integration, Retention Stabilization & Cognitive Re-anchoring',
      'axis': SkillAxis.calculation,
      'lab': 'visualization_lab',
      'difficulty': 2476,
      'prerequisites': [88],
      'objectives': [
        'Understand core grandmaster principles of Integration, Retention Stabilization & Cognitive Re-anchoring.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 89: Integration, Retention Stabilization & Cognitive Re-anchoring

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Integration, Retention Stabilization & Cognitive Re-anchoring**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd89_ex1',
          fen: 'rnbqkbnr/pp1ppppp/2p5/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['d4'],
          explanation: 'Demonstrates master-level execution of Caro Center.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'Caro Center',
        ),
      ],
    },
    90: {
      'title': 'Day 90: ChessMaster 90-Day Mastery Assessment & Completion Report (Certification)',
      'theme': 'Comprehensive 12-Axis Mastery Assessment & FIDE Grandmaster Method Report',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2491,
      'prerequisites': [84, 85, 86, 87, 88, 89],
      'objectives': [
        'Understand core grandmaster principles of Comprehensive 12-Axis Mastery Assessment & FIDE Grandmaster Method Report.',
        'Execute interactive exercises with >=85% accuracy and zero unforced blunders.',
        'Connect tactical patterns to deep calculation trees and practical game decisions.',
      ],
      'theory': '''
# Day 90: ChessMaster 90-Day Mastery Assessment & Completion Report (Certification)

Operational GM loop:
`Understand → Recognize → Calculate → Apply → Play → Analyze → Diagnose → Retrain → Retest → Retain`

Focus today on **Comprehensive 12-Axis Mastery Assessment & FIDE Grandmaster Method Report**.
Ensure all candidate moves are generated before committing to calculations.
Always identify opponent counter-resources before playing forcing lines.

''',
      'exercises': [
        const CurriculumExercise(
          id: 'd90_ex1',
          fen: 'rnbqkb1r/pppppp1p/5np1/8/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Find the most accurate grandmaster move in this position.',
          solutionSan: ['Nc3'],
          explanation: 'Demonstrates master-level execution of KID Challenge.',
          hints: ['Look at forcing moves first: checks, captures, threats.'],
          motif: 'KID Challenge',
        ),
      ],
    },
  };
}
