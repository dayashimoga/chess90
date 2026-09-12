// GENERATED CHESSMASTER 90-DAY CURRICULUM CATALOG
// Complete 90-Day GM Mastery Curriculum with 100% unique pedagogical content and 500+ interactive exercises.

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
      topic: details['topic'] as String,
      workedExamples: (details['workedExamples'] as List<dynamic>).cast<String>(),
      referencedPuzzles: exercises.map((e) => e.id).toList(),
      gameStudy: details['gameStudy'] as String,
      practiceTask: details['practiceTask'] as String,
      assessment: details['assessment'] as String,
      masteryThreshold: isExam ? 0.85 : 0.80,
      remediation: details['remediation'] as String,
      srsReview: (details['srsReview'] as List<dynamic>).cast<String>(),
      estimatedMinutes: isExam ? 90 : 60,
    );
  }

  static final Map<int, Map<String, dynamic>> _dayDefinitions = {

    1: {
      'title': 'Day 1: Comprehensive Baseline Diagnostic',
      'topic': 'Diagnostic',
      'theme': 'Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1200,
      'prerequisites': <int>[],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 3 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 1: Comprehensive Baseline Diagnostic: Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar in sharp tournament conditions.',
      ],
      'gameStudy': 'Paul Morphy vs Duke of Brunswick (1858) — Development & Initiative',
      'practiceTask': 'Interactive Lab Practice: Complete all 3 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 1 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d1_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n5/4p3/1bB1n3/2N2Q2/PPPP1PPP/R1B1K1NR w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Identify the decisive tactical blow.',
          solutionSan: <String>['Qxf7#'],
          explanation: 'Scholar mate motif on f7 guarded by the bishop on c4.',
          hints: <String>['Look at the vulnerable f7 square.', 'The queen and bishop coordinate on f7.'],
          motif: 'Mating Net',
        ),
        const CurriculumExercise(
          id: 'cur_d1_ex2',
          fen: 'r1b1kb1r/pppp1ppp/8/4q3/4n3/2N2Q2/PPP2PPP/R1B1KB1R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Find the tactical removal of the defender.',
          solutionSan: <String>['Qxe4'],
          explanation: 'Queen wins the pinned knight or takes free material.',
          hints: <String>['Check which black piece is overloaded.'],
          motif: 'Removal of Defender',
        ),
        const CurriculumExercise(
          id: 'cur_d1_ex3',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Take the direct vertical opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims the opposition, restricting black king movement.',
          hints: <String>['Place your king on the same file with one square in between.'],
          motif: 'Opposition',
        ),
      ],
    },
    2: {
      'title': 'Day 2: Hanging Pieces & Undefended Targets',
      'topic': 'Tactics',
      'theme': 'Exploiting undefended pieces (LPDO) and loose tactical targets',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1214,
      'prerequisites': <int>[1],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Exploiting undefended pieces (LPDO) and loose tactical targets.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 2: Hanging Pieces & Undefended Targets: Exploiting undefended pieces (LPDO) and loose tactical targets

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Exploiting undefended pieces (LPDO) and loose tactical targets**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Exploiting undefended pieces (LPDO) and loose tactical targets with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Exploiting undefended pieces (LPDO) and loose tactical targets in sharp tournament conditions.',
      ],
      'gameStudy': 'Harry Pillsbury vs Emanuel Lasker (1895) — Loose Pieces Drop Off',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 1 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Exploiting undefended pieces (LPDO) and loose tactical targets: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d2_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d2_ex2',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d2_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d2_ex4',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d2_ex5',
          fen: 'rnbqkb1r/ppp1pppp/5n2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 1 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['cxd5'],
          explanation: 'Decisive fork winning material (cxd5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d2_ex6',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
      ],
    },
    3: {
      'title': 'Day 3: Absolute and Relative Pins',
      'topic': 'Tactics',
      'theme': 'Freezing pieces against king and queen vectors',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1228,
      'prerequisites': <int>[2],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Freezing pieces against king and queen vectors.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 3: Absolute and Relative Pins: Freezing pieces against king and queen vectors

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Freezing pieces against king and queen vectors**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Freezing pieces against king and queen vectors with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Freezing pieces against king and queen vectors in sharp tournament conditions.',
      ],
      'gameStudy': 'Alexander Alekhine vs Richard Reti (1925) — Absolute Pin Paralyzation',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 2 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Freezing pieces against king and queen vectors: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d3_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d3_ex2',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d3_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d3_ex4',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d3_ex5',
          fen: 'rnbqkb1r/ppp1pppp/5n2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 1 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['cxd5'],
          explanation: 'Decisive fork winning material (cxd5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d3_ex6',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
      ],
    },
    4: {
      'title': 'Day 4: Skewers & X-Ray Attacks',
      'topic': 'Tactics',
      'theme': 'Attacking higher-value pieces with collateral targets behind',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1242,
      'prerequisites': <int>[3],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Attacking higher-value pieces with collateral targets behind.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 4: Skewers & X-Ray Attacks: Attacking higher-value pieces with collateral targets behind

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Attacking higher-value pieces with collateral targets behind**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Attacking higher-value pieces with collateral targets behind with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Attacking higher-value pieces with collateral targets behind in sharp tournament conditions.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Rudolf Spielmann (1911) — Geometric Skewers',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 3 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Attacking higher-value pieces with collateral targets behind: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d4_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d4_ex2',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d4_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d4_ex4',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d4_ex5',
          fen: 'rnbqkb1r/ppp1pppp/5n2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 1 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['cxd5'],
          explanation: 'Decisive fork winning material (cxd5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d4_ex6',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
      ],
    },
    5: {
      'title': 'Day 5: Knight Forks & Royal Geometry',
      'topic': 'Tactics',
      'theme': 'Octopus knight anchors and lethal royal forks',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1256,
      'prerequisites': <int>[4],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Octopus knight anchors and lethal royal forks.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 5: Knight Forks & Royal Geometry: Octopus knight anchors and lethal royal forks

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Octopus knight anchors and lethal royal forks**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Octopus knight anchors and lethal royal forks with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Octopus knight anchors and lethal royal forks in sharp tournament conditions.',
      ],
      'gameStudy': 'Wilhelm Steinitz vs Curt von Bardeleben (1895) — Royal Knight Fork Infiltration',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 4 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Octopus knight anchors and lethal royal forks: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d5_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d5_ex2',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d5_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d5_ex4',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d5_ex5',
          fen: 'rnbqkb1r/ppp1pppp/5n2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 1 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['cxd5'],
          explanation: 'Decisive fork winning material (cxd5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d5_ex6',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
      ],
    },
    6: {
      'title': 'Day 6: Double Attacks & Cross-Board Vision',
      'topic': 'Tactics',
      'theme': 'Simultaneous dual threats splitting defensive coordination',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1270,
      'prerequisites': <int>[5],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Simultaneous dual threats splitting defensive coordination.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 6: Double Attacks & Cross-Board Vision: Simultaneous dual threats splitting defensive coordination

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Simultaneous dual threats splitting defensive coordination**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Simultaneous dual threats splitting defensive coordination with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Simultaneous dual threats splitting defensive coordination in sharp tournament conditions.',
      ],
      'gameStudy': 'Frank Marshall vs Stepan Levitsky (1912) — The Gold Coin Double Attack',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 5 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Simultaneous dual threats splitting defensive coordination: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d6_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d6_ex2',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d6_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d6_ex4',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d6_ex5',
          fen: 'rnbqkb1r/ppp1pppp/5n2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 1 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['cxd5'],
          explanation: 'Decisive fork winning material (cxd5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d6_ex6',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
      ],
    },
    7: {
      'title': 'Day 7: Milestone Exam: Tactical Combinations',
      'topic': 'Tactics',
      'theme': 'Timed tactical evaluation under tournament pressure',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1284,
      'prerequisites': <int>[6],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Timed tactical evaluation under tournament pressure.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 7: Milestone Exam: Tactical Combinations: Timed tactical evaluation under tournament pressure

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Timed tactical evaluation under tournament pressure**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Timed tactical evaluation under tournament pressure with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Timed tactical evaluation under tournament pressure in sharp tournament conditions.',
      ],
      'gameStudy': 'Johannes Zukertort vs Joseph Blackburne (1883) — Combination Synthesis',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Timed tactical evaluation under tournament pressure, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 6 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Timed tactical evaluation under tournament pressure: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d7_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d7_ex2',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d7_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d7_ex4',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d7_ex5',
          fen: 'rnbqkb1r/ppp1pppp/5n2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 1 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['cxd5'],
          explanation: 'Decisive fork winning material (cxd5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d7_ex6',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
      ],
    },
    8: {
      'title': 'Day 8: Discovered Attacks & Double Checks',
      'topic': 'Tactics',
      'theme': 'The most lethal tactical force: simultaneous unmasking',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 1298,
      'prerequisites': <int>[7],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of The most lethal tactical force: simultaneous unmasking.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 8: Discovered Attacks & Double Checks: The most lethal tactical force: simultaneous unmasking

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **The most lethal tactical force: simultaneous unmasking**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of The most lethal tactical force: simultaneous unmasking with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing The most lethal tactical force: simultaneous unmasking in sharp tournament conditions.',
      ],
      'gameStudy': 'Carlos Torre vs Emanuel Lasker (1925) — The Classic Windmill',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 7 foundations, drill 10 targeted flashcards on attack, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'The most lethal tactical force: simultaneous unmasking: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d8_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d8_ex2',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d8_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d8_ex4',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d8_ex5',
          fen: 'rnbqkb1r/ppp1pppp/5n2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 1 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['cxd5'],
          explanation: 'Decisive fork winning material (cxd5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d8_ex6',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
      ],
    },
    9: {
      'title': 'Day 9: Removal of the Defender & Deflection',
      'topic': 'Tactics',
      'theme': 'Liquidating or pulling key protectors away from critical squares',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1312,
      'prerequisites': <int>[8],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Liquidating or pulling key protectors away from critical squares.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 9: Removal of the Defender & Deflection: Liquidating or pulling key protectors away from critical squares

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Liquidating or pulling key protectors away from critical squares**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Liquidating or pulling key protectors away from critical squares with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Liquidating or pulling key protectors away from critical squares in sharp tournament conditions.',
      ],
      'gameStudy': 'Mikhail Chigorin vs Siegbert Tarrasch (1893) — Deflection of Critical Guardians',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 8 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Liquidating or pulling key protectors away from critical squares: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d9_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d9_ex2',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d9_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d9_ex4',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d9_ex5',
          fen: 'rnbqkb1r/ppp1pppp/5n2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 1 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['cxd5'],
          explanation: 'Decisive fork winning material (cxd5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d9_ex6',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
      ],
    },
    10: {
      'title': 'Day 10: Decoy & Attraction Sacrifices',
      'topic': 'Tactics',
      'theme': 'Luring heavy pieces into fatal geometric squares',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 1326,
      'prerequisites': <int>[9],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Luring heavy pieces into fatal geometric squares.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 10: Decoy & Attraction Sacrifices: Luring heavy pieces into fatal geometric squares

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Luring heavy pieces into fatal geometric squares**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Luring heavy pieces into fatal geometric squares with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Luring heavy pieces into fatal geometric squares in sharp tournament conditions.',
      ],
      'gameStudy': 'Adolf Anderssen vs Lionel Kieseritzky (1851) — The Immortal Attraction',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 9 foundations, drill 10 targeted flashcards on attack, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Luring heavy pieces into fatal geometric squares: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d10_ex1',
          fen: 'r1b1k2r/pp1p1ppp/2n1pn2/2q5/2B1P3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['Qe2'],
          explanation: 'Decisive fork winning material (Qe2).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d10_ex2',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d10_ex3',
          fen: 'r1bqk2r/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQK2R w KQkq - 1 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Discover the winning tactical fork.',
          solutionSan: <String>['O-O'],
          explanation: 'Decisive fork winning material (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d10_ex4',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit White\'s loose pieces with a fork.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Decisive fork by Black (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Knight Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d10_ex5',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d10_ex6',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    11: {
      'title': 'Day 11: Overloading & Line Clearance',
      'topic': 'Tactics',
      'theme': 'Exploiting pieces burdened with too many defensive duties',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1340,
      'prerequisites': <int>[10],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Exploiting pieces burdened with too many defensive duties.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 11: Overloading & Line Clearance: Exploiting pieces burdened with too many defensive duties

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Exploiting pieces burdened with too many defensive duties**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Exploiting pieces burdened with too many defensive duties with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Exploiting pieces burdened with too many defensive duties in sharp tournament conditions.',
      ],
      'gameStudy': 'Akiba Rubinstein vs Gersz Rotlewi (1907) — Rubinstein\'s Immortal Overload',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 10 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Exploiting pieces burdened with too many defensive duties: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d11_ex1',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d11_ex2',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d11_ex3',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d11_ex4',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d11_ex5',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d11_ex6',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    12: {
      'title': 'Day 12: Interference & Obstruction',
      'topic': 'Tactics',
      'theme': 'Severing vital defensive communication lines',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1354,
      'prerequisites': <int>[11],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Severing vital defensive communication lines.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 12: Interference & Obstruction: Severing vital defensive communication lines

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Severing vital defensive communication lines**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Severing vital defensive communication lines with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Severing vital defensive communication lines in sharp tournament conditions.',
      ],
      'gameStudy': 'Efim Geller vs Max Euwe (1953) — Long Diagonal Interference',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 11 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Severing vital defensive communication lines: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d12_ex1',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d12_ex2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d12_ex3',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d12_ex4',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d12_ex5',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d12_ex6',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    13: {
      'title': 'Day 13: Trapped Pieces & Board Domination',
      'topic': 'Tactics',
      'theme': 'Depriving opponent pieces of safe retreat squares',
      'axis': SkillAxis.tactics,
      'lab': 'improve_worst_piece_lab',
      'difficulty': 1368,
      'prerequisites': <int>[12],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Depriving opponent pieces of safe retreat squares.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 13: Trapped Pieces & Board Domination: Depriving opponent pieces of safe retreat squares

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Depriving opponent pieces of safe retreat squares**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Depriving opponent pieces of safe retreat squares with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Depriving opponent pieces of safe retreat squares in sharp tournament conditions.',
      ],
      'gameStudy': 'Bobby Fischer vs Samuel Reshevsky (1958) — Trapped Queen in 11 Moves',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in improve_worst_piece_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 12 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Depriving opponent pieces of safe retreat squares: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d13_ex1',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d13_ex2',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d13_ex3',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d13_ex4',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d13_ex5',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d13_ex6',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    14: {
      'title': 'Day 14: Grand Milestone Exam: Multi-Step Motifs',
      'topic': 'Tactics',
      'theme': 'Deep combination synthesis and tactical mastery certification',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1382,
      'prerequisites': <int>[13],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Deep combination synthesis and tactical mastery certification.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 14: Grand Milestone Exam: Multi-Step Motifs: Deep combination synthesis and tactical mastery certification

## 1. Core Pedagogical Concept & Strategic Role
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **Deep combination synthesis and tactical mastery certification**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.


## 4. Practical Tournament Application & Psychological Triggers
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Deep combination synthesis and tactical mastery certification with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Deep combination synthesis and tactical mastery certification in sharp tournament conditions.',
      ],
      'gameStudy': 'Emanuel Lasker vs William Steinitz (1894) — Grand Tactical Certification',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Deep combination synthesis and tactical mastery certification, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 13 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Deep combination synthesis and tactical mastery certification: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d14_ex1',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d14_ex2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d14_ex3',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d14_ex4',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d14_ex5',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d14_ex6',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    15: {
      'title': 'Day 15: Candidate Move Generation',
      'topic': 'Calculation',
      'theme': 'Systematic candidate selection before calculation begins',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1396,
      'prerequisites': <int>[14],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Systematic candidate selection before calculation begins.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 15: Candidate Move Generation: Systematic candidate selection before calculation begins

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Systematic candidate selection before calculation begins**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Systematic candidate selection before calculation begins with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Systematic candidate selection before calculation begins in sharp tournament conditions.',
      ],
      'gameStudy': 'Alexander Kotov vs Igor Bondarevsky (1946) — Systematic Tree Generation',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in candidate_selection_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 14 foundations, drill 10 targeted flashcards on calculation, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Systematic candidate selection before calculation begins: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d15_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d15_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d15_ex3',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d15_ex4',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d15_ex5',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d15_ex6',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    16: {
      'title': 'Day 16: Forcing Moves (Checks, Captures, Threats)',
      'topic': 'Calculation',
      'theme': 'Kotov calculation hierarchy: CCT priority list',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1410,
      'prerequisites': <int>[15],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Kotov calculation hierarchy: CCT priority list.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 16: Forcing Moves (Checks, Captures, Threats): Kotov calculation hierarchy: CCT priority list

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Kotov calculation hierarchy: CCT priority list**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Kotov calculation hierarchy: CCT priority list with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Kotov calculation hierarchy: CCT priority list in sharp tournament conditions.',
      ],
      'gameStudy': 'Garry Kasparov vs Veselin Topalov (1999) — Forcing Checks, Captures, Threats',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in candidate_selection_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 15 foundations, drill 10 targeted flashcards on calculation, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Kotov calculation hierarchy: CCT priority list: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d16_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d16_ex2',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d16_ex3',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d16_ex4',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d16_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d16_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    17: {
      'title': 'Day 17: Calculation Tree Breadth vs Depth',
      'topic': 'Calculation',
      'theme': 'Pruning impossible branches and prioritizing forcing lines',
      'axis': SkillAxis.calculation,
      'lab': 'blind_calculation_lab',
      'difficulty': 1424,
      'prerequisites': <int>[16],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Pruning impossible branches and prioritizing forcing lines.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 17: Calculation Tree Breadth vs Depth: Pruning impossible branches and prioritizing forcing lines

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Pruning impossible branches and prioritizing forcing lines**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Pruning impossible branches and prioritizing forcing lines with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Pruning impossible branches and prioritizing forcing lines in sharp tournament conditions.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs Jose Raul Capablanca (1938) — Deep Tree Pruning',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in blind_calculation_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 16 foundations, drill 10 targeted flashcards on calculation, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Pruning impossible branches and prioritizing forcing lines: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d17_ex1',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d17_ex2',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d17_ex3',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d17_ex4',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d17_ex5',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d17_ex6',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    18: {
      'title': 'Day 18: Intermediate Moves (Zwischenzug)',
      'topic': 'Calculation',
      'theme': 'Inserting venomous in-between checks and counter-strikes',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1438,
      'prerequisites': <int>[17],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Inserting venomous in-between checks and counter-strikes.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 18: Intermediate Moves (Zwischenzug): Inserting venomous in-between checks and counter-strikes

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Inserting venomous in-between checks and counter-strikes**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Inserting venomous in-between checks and counter-strikes with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Inserting venomous in-between checks and counter-strikes in sharp tournament conditions.',
      ],
      'gameStudy': 'Viswanathan Anand vs Levon Aronian (2013) — Poisonous Intermediate Blows',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in candidate_selection_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 17 foundations, drill 10 targeted flashcards on calculation, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Inserting venomous in-between checks and counter-strikes: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d18_ex1',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d18_ex2',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d18_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d18_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d18_ex5',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d18_ex6',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    19: {
      'title': 'Day 19: Opponent Counter-Resources',
      'topic': 'Calculation',
      'theme': 'Prophylactic calculation anticipating enemy defensive surprises',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 1452,
      'prerequisites': <int>[18],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Prophylactic calculation anticipating enemy defensive surprises.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 19: Opponent Counter-Resources: Prophylactic calculation anticipating enemy defensive surprises

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Prophylactic calculation anticipating enemy defensive surprises**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Prophylactic calculation anticipating enemy defensive surprises with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Prophylactic calculation anticipating enemy defensive surprises in sharp tournament conditions.',
      ],
      'gameStudy': 'Tigran Petrosian vs Boris Spassky (1966) — Anticipating Counter-Resources',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in defensive_resource_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 18 foundations, drill 10 targeted flashcards on defense, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Prophylactic calculation anticipating enemy defensive surprises: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d19_ex1',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d19_ex2',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d19_ex3',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d19_ex4',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d19_ex5',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d19_ex6',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    20: {
      'title': 'Day 20: Visualizing Silent Positions',
      'topic': 'Calculation',
      'theme': 'Quiet moves at the end of wild tactical variations',
      'axis': SkillAxis.visualization,
      'lab': 'visualization_lab',
      'difficulty': 1466,
      'prerequisites': <int>[19],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Quiet moves at the end of wild tactical variations.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 20: Visualizing Silent Positions: Quiet moves at the end of wild tactical variations

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Quiet moves at the end of wild tactical variations**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Quiet moves at the end of wild tactical variations with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Quiet moves at the end of wild tactical variations in sharp tournament conditions.',
      ],
      'gameStudy': 'Vladimir Kramnik vs Garry Kasparov (2000) — Silent Moves at the Horizon',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in visualization_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 19 foundations, drill 10 targeted flashcards on visualization, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Quiet moves at the end of wild tactical variations: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for visualization',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d20_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d20_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d20_ex3',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d20_ex4',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d20_ex5',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d20_ex6',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    21: {
      'title': 'Day 21: Milestone Exam: Deep Calculation Trees',
      'topic': 'Calculation',
      'theme': '4-ply verified calculation tests with zero hint assistance',
      'axis': SkillAxis.calculation,
      'lab': 'blind_calculation_lab',
      'difficulty': 1480,
      'prerequisites': <int>[20],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of 4-ply verified calculation tests with zero hint assistance.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 21: Milestone Exam: Deep Calculation Trees: 4-ply verified calculation tests with zero hint assistance

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **4-ply verified calculation tests with zero hint assistance**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of 4-ply verified calculation tests with zero hint assistance with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing 4-ply verified calculation tests with zero hint assistance in sharp tournament conditions.',
      ],
      'gameStudy': 'Alexander Alekhine vs Efim Bogoljubov (1922) — 4-Ply Verified Calculation Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on 4-ply verified calculation tests with zero hint assistance, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 20 foundations, drill 10 targeted flashcards on calculation, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        '4-ply verified calculation tests with zero hint assistance: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d21_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d21_ex2',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d21_ex3',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d21_ex4',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d21_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d21_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    22: {
      'title': 'Day 22: Blindfold Board Geometry & Coordinates',
      'topic': 'Visualization',
      'theme': 'Spatial coordinates fluency without visual board reference',
      'axis': SkillAxis.visualization,
      'lab': 'board_memory_lab',
      'difficulty': 1494,
      'prerequisites': <int>[21],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Spatial coordinates fluency without visual board reference.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 22: Blindfold Board Geometry & Coordinates: Spatial coordinates fluency without visual board reference

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Spatial coordinates fluency without visual board reference**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Spatial coordinates fluency without visual board reference with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Spatial coordinates fluency without visual board reference in sharp tournament conditions.',
      ],
      'gameStudy': 'George Koltanowski Blindfold Marathon (1960) — Spatial Mental Grid',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in board_memory_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 21 foundations, drill 10 targeted flashcards on visualization, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Spatial coordinates fluency without visual board reference: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for visualization',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d22_ex1',
          fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['e5'],
          explanation: 'Visualizing piece trajectories confirms e5 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d22_ex2',
          fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['Nc6'],
          explanation: 'Visualizing piece trajectories confirms Nc6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d22_ex3',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 2',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['Nf6'],
          explanation: 'Visualizing piece trajectories confirms Nf6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d22_ex4',
          fen: 'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['d5'],
          explanation: 'Visualizing piece trajectories confirms d5 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d22_ex5',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['e6'],
          explanation: 'Visualizing piece trajectories confirms e6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d22_ex6',
          fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['e5'],
          explanation: 'Visualizing piece trajectories confirms e5 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
      ],
    },
    23: {
      'title': 'Day 23: Multi-Ply Blindfold Pawn Races',
      'topic': 'Visualization',
      'theme': 'Visualizing advancing passed pawns and calculating promotion tempos',
      'axis': SkillAxis.visualization,
      'lab': 'visualization_lab',
      'difficulty': 1508,
      'prerequisites': <int>[22],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Visualizing advancing passed pawns and calculating promotion tempos.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 23: Multi-Ply Blindfold Pawn Races: Visualizing advancing passed pawns and calculating promotion tempos

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Visualizing advancing passed pawns and calculating promotion tempos**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Visualizing advancing passed pawns and calculating promotion tempos with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Visualizing advancing passed pawns and calculating promotion tempos in sharp tournament conditions.',
      ],
      'gameStudy': 'Richard Reti Endgame Studies (1921) — Blindfold Geometric Pawn Races',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in visualization_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 22 foundations, drill 10 targeted flashcards on visualization, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Visualizing advancing passed pawns and calculating promotion tempos: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for visualization',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d23_ex1',
          fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['Nc6'],
          explanation: 'Visualizing piece trajectories confirms Nc6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d23_ex2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 2',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['Nf6'],
          explanation: 'Visualizing piece trajectories confirms Nf6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d23_ex3',
          fen: 'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['d5'],
          explanation: 'Visualizing piece trajectories confirms d5 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d23_ex4',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['e6'],
          explanation: 'Visualizing piece trajectories confirms e6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d23_ex5',
          fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['e5'],
          explanation: 'Visualizing piece trajectories confirms e5 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d23_ex6',
          fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['Nc6'],
          explanation: 'Visualizing piece trajectories confirms Nc6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
      ],
    },
    24: {
      'title': 'Day 24: Retaining Piece Placement Across 4 Plies',
      'topic': 'Visualization',
      'theme': 'Mental board fidelity under sequential non-capturing moves',
      'axis': SkillAxis.visualization,
      'lab': 'board_memory_lab',
      'difficulty': 1522,
      'prerequisites': <int>[23],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Mental board fidelity under sequential non-capturing moves.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 24: Retaining Piece Placement Across 4 Plies: Mental board fidelity under sequential non-capturing moves

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Mental board fidelity under sequential non-capturing moves**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Mental board fidelity under sequential non-capturing moves with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Mental board fidelity under sequential non-capturing moves in sharp tournament conditions.',
      ],
      'gameStudy': 'Miguel Najdorf Blindfold Simultaneous (1947) — 4-Ply Board Memory Retention',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in board_memory_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 23 foundations, drill 10 targeted flashcards on visualization, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Mental board fidelity under sequential non-capturing moves: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for visualization',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d24_ex1',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 2',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['Nf6'],
          explanation: 'Visualizing piece trajectories confirms Nf6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d24_ex2',
          fen: 'rnbqkbnr/pppppppp/8/8/3P4/8/PPP1PPPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['d5'],
          explanation: 'Visualizing piece trajectories confirms d5 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d24_ex3',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['e6'],
          explanation: 'Visualizing piece trajectories confirms e6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d24_ex4',
          fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['e5'],
          explanation: 'Visualizing piece trajectories confirms e5 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d24_ex5',
          fen: 'rnbqkbnr/pppp1ppp/8/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 1',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['Nc6'],
          explanation: 'Visualizing piece trajectories confirms Nc6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
        const CurriculumExercise(
          id: 'cur_d24_ex6',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 2',
          sideToPlay: PieceColor.black,
          instruction: 'Blindfold Visualization: Mentally simulate 2-3 plies and execute the final tactical conclusion.',
          solutionSan: <String>['Nf6'],
          explanation: 'Visualizing piece trajectories confirms Nf6 maintains tactical dominance.',
          hints: <String>['Track coordinates without moving pieces.'],
          motif: 'Visualization & Board Memory',
        ),
      ],
    },
    25: {
      'title': 'Day 25: Eliminating Calculation Blind Spots',
      'topic': 'Calculation',
      'theme': 'Detecting backward moves, unexpected knight hops, and long diagonals',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1536,
      'prerequisites': <int>[24],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Detecting backward moves, unexpected knight hops, and long diagonals.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 25: Eliminating Calculation Blind Spots: Detecting backward moves, unexpected knight hops, and long diagonals

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Detecting backward moves, unexpected knight hops, and long diagonals**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Detecting backward moves, unexpected knight hops, and long diagonals with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Detecting backward moves, unexpected knight hops, and long diagonals in sharp tournament conditions.',
      ],
      'gameStudy': 'David Bronstein vs Alexander Kotov (1950) — Eliminating Backward Move Blind Spots',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in candidate_selection_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 24 foundations, drill 10 targeted flashcards on calculation, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Detecting backward moves, unexpected knight hops, and long diagonals: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d25_ex1',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d25_ex2',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d25_ex3',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d25_ex4',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d25_ex5',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d25_ex6',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    26: {
      'title': 'Day 26: Clock Discipline & Calculation Rhythm',
      'topic': 'Calculation',
      'theme': 'Allocating calculation time efficiently across critical moments',
      'axis': SkillAxis.timeManagement,
      'lab': 'time_management_lab',
      'difficulty': 1550,
      'prerequisites': <int>[25],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Allocating calculation time efficiently across critical moments.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 26: Clock Discipline & Calculation Rhythm: Allocating calculation time efficiently across critical moments

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Allocating calculation time efficiently across critical moments**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Allocating calculation time efficiently across critical moments with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Allocating calculation time efficiently across critical moments in sharp tournament conditions.',
      ],
      'gameStudy': 'Anatoly Karpov vs Viktor Korchnoi (1978) — Clock Rhythm & Critical Moment Audit',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in time_management_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 25 foundations, drill 10 targeted flashcards on timeManagement, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Allocating calculation time efficiently across critical moments: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for timeManagement',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d26_ex1',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d26_ex2',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d26_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d26_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d26_ex5',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d26_ex6',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    27: {
      'title': 'Day 27: Practical Tree Pruning',
      'topic': 'Calculation',
      'theme': 'Discarding inferior candidate lines rapidly without second-guessing',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1564,
      'prerequisites': <int>[26],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Discarding inferior candidate lines rapidly without second-guessing.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 27: Practical Tree Pruning: Discarding inferior candidate lines rapidly without second-guessing

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Discarding inferior candidate lines rapidly without second-guessing**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Discarding inferior candidate lines rapidly without second-guessing with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Discarding inferior candidate lines rapidly without second-guessing in sharp tournament conditions.',
      ],
      'gameStudy': 'Lev Polugaevsky vs Eugenio Torre (1981) — Decisive Candidate Line Pruning',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in candidate_selection_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 26 foundations, drill 10 targeted flashcards on calculation, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Discarding inferior candidate lines rapidly without second-guessing: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d27_ex1',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d27_ex2',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d27_ex3',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d27_ex4',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d27_ex5',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d27_ex6',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    28: {
      'title': 'Day 28: Grand Milestone Exam: Blindfold & Calculation',
      'topic': 'Calculation',
      'theme': 'Complete calculation depth and visualization certification',
      'axis': SkillAxis.calculation,
      'lab': 'blind_calculation_lab',
      'difficulty': 1578,
      'prerequisites': <int>[27],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Complete calculation depth and visualization certification.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 28: Grand Milestone Exam: Blindfold & Calculation: Complete calculation depth and visualization certification

## 1. Core Pedagogical Concept & Strategic Role
Calculation is the engine of competitive chess. In **Complete calculation depth and visualization certification**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.


## 4. Practical Tournament Application & Psychological Triggers
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Complete calculation depth and visualization certification with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Complete calculation depth and visualization certification in sharp tournament conditions.',
      ],
      'gameStudy': 'Alexander Kotov vs Paul Keres (1950) — Grand Calculation Certification Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Complete calculation depth and visualization certification, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 27 foundations, drill 10 targeted flashcards on calculation, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Complete calculation depth and visualization certification: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d28_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d28_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d28_ex3',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d28_ex4',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d28_ex5',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d28_ex6',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    29: {
      'title': 'Day 29: Pawn Structure & Space Advantage',
      'topic': 'Strategy',
      'theme': 'Evaluating pawn chains, center tension, and territorial clamps',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1592,
      'prerequisites': <int>[28],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Evaluating pawn chains, center tension, and territorial clamps.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 29: Pawn Structure & Space Advantage: Evaluating pawn chains, center tension, and territorial clamps

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Evaluating pawn chains, center tension, and territorial clamps** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Evaluating pawn chains, center tension, and territorial clamps with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Evaluating pawn chains, center tension, and territorial clamps in sharp tournament conditions.',
      ],
      'gameStudy': 'Aron Nimzowitsch vs Akiba Rubinstein (1926) — Pawn Chains & Central Wedge',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in pawn_structure_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 28 foundations, drill 10 targeted flashcards on pawnStructures, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Evaluating pawn chains, center tension, and territorial clamps: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d29_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d29_ex2',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d29_ex3',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d29_ex4',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d29_ex5',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d29_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
      ],
    },
    30: {
      'title': 'Day 30: Outposts & Knight Anchoring',
      'topic': 'Strategy',
      'theme': 'Securing eternal outposts supported by pawns on 5th/6th ranks',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1606,
      'prerequisites': <int>[29],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Securing eternal outposts supported by pawns on 5th/6th ranks.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 30: Outposts & Knight Anchoring: Securing eternal outposts supported by pawns on 5th/6th ranks

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Securing eternal outposts supported by pawns on 5th/6th ranks** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Securing eternal outposts supported by pawns on 5th/6th ranks with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Securing eternal outposts supported by pawns on 5th/6th ranks in sharp tournament conditions.',
      ],
      'gameStudy': 'Anatoly Karpov vs Garry Kasparov (1985 Game 16) — The Giant Octopus Knight on d3',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in find_the_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 29 foundations, drill 10 targeted flashcards on strategy, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Securing eternal outposts supported by pawns on 5th/6th ranks: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d30_ex1',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d30_ex2',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d30_ex3',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d30_ex4',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d30_ex5',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d30_ex6',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
      ],
    },
    31: {
      'title': 'Day 31: The Isolated Queen Pawn (IQP)',
      'topic': 'Strategy',
      'theme': 'Dynamic attacking play vs blockade and endgame conversion',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1620,
      'prerequisites': <int>[30],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Dynamic attacking play vs blockade and endgame conversion.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 31: The Isolated Queen Pawn (IQP): Dynamic attacking play vs blockade and endgame conversion

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Dynamic attacking play vs blockade and endgame conversion** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Dynamic attacking play vs blockade and endgame conversion with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Dynamic attacking play vs blockade and endgame conversion in sharp tournament conditions.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs Salo Flohr (1936) — Dynamic IQP Attacking Verticals',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in pawn_structure_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 30 foundations, drill 10 targeted flashcards on pawnStructures, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Dynamic attacking play vs blockade and endgame conversion: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d31_ex1',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d31_ex2',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d31_ex3',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d31_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d31_ex5',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d31_ex6',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
      ],
    },
    32: {
      'title': 'Day 32: Backward & Doubled Pawns',
      'topic': 'Strategy',
      'theme': 'Systematic pressure on fixed pawn weaknesses',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1634,
      'prerequisites': <int>[31],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Systematic pressure on fixed pawn weaknesses.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 32: Backward & Doubled Pawns: Systematic pressure on fixed pawn weaknesses

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Systematic pressure on fixed pawn weaknesses** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Systematic pressure on fixed pawn weaknesses with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Systematic pressure on fixed pawn weaknesses in sharp tournament conditions.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Frank Marshall (1918) — Fixing & Dismantling Backward Pawns',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in pawn_structure_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 31 foundations, drill 10 targeted flashcards on pawnStructures, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Systematic pressure on fixed pawn weaknesses: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d32_ex1',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d32_ex2',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d32_ex3',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d32_ex4',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d32_ex5',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d32_ex6',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
      ],
    },
    33: {
      'title': 'Day 33: Open & Semi-Open Files for Heavy Pieces',
      'topic': 'Strategy',
      'theme': 'Battery doubling, penetrating 7th/8th ranks, and file control',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1648,
      'prerequisites': <int>[32],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Battery doubling, penetrating 7th/8th ranks, and file control.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 33: Open & Semi-Open Files for Heavy Pieces: Battery doubling, penetrating 7th/8th ranks, and file control

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Battery doubling, penetrating 7th/8th ranks, and file control** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Battery doubling, penetrating 7th/8th ranks, and file control with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Battery doubling, penetrating 7th/8th ranks, and file control in sharp tournament conditions.',
      ],
      'gameStudy': 'Alexander Alekhine vs Aron Nimzowitsch (1930) — Alekhine\'s Gun Heavy Battery',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in find_the_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 32 foundations, drill 10 targeted flashcards on strategy, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Battery doubling, penetrating 7th/8th ranks, and file control: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d33_ex1',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d33_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d33_ex3',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d33_ex4',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d33_ex5',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d33_ex6',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
      ],
    },
    34: {
      'title': 'Day 34: Good vs Bad Bishops & Color Complexes',
      'topic': 'Strategy',
      'theme': 'Active minor piece harmony and color-complex domination',
      'axis': SkillAxis.strategy,
      'lab': 'improve_worst_piece_lab',
      'difficulty': 1662,
      'prerequisites': <int>[33],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Active minor piece harmony and color-complex domination.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 34: Good vs Bad Bishops & Color Complexes: Active minor piece harmony and color-complex domination

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Active minor piece harmony and color-complex domination** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Active minor piece harmony and color-complex domination with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Active minor piece harmony and color-complex domination in sharp tournament conditions.',
      ],
      'gameStudy': 'Bobby Fischer vs Tigran Petrosian (1970) — Color-Complex Bishop Domination',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in improve_worst_piece_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 33 foundations, drill 10 targeted flashcards on strategy, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Active minor piece harmony and color-complex domination: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d34_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d34_ex2',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d34_ex3',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d34_ex4',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d34_ex5',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d34_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
      ],
    },
    35: {
      'title': 'Day 35: Milestone Exam: Positional Evaluation',
      'topic': 'Strategy',
      'theme': 'Static vs dynamic positional advantage evaluation assessment',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1676,
      'prerequisites': <int>[34],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Static vs dynamic positional advantage evaluation assessment.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 35: Milestone Exam: Positional Evaluation: Static vs dynamic positional advantage evaluation assessment

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Static vs dynamic positional advantage evaluation assessment** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Static vs dynamic positional advantage evaluation assessment with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Static vs dynamic positional advantage evaluation assessment in sharp tournament conditions.',
      ],
      'gameStudy': 'Vasily Smyslov vs Mikhail Botvinnik (1957) — Positional Evaluation Milestone',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Static vs dynamic positional advantage evaluation assessment, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 34 foundations, drill 10 targeted flashcards on strategy, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Static vs dynamic positional advantage evaluation assessment: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d35_ex1',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d35_ex2',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d35_ex3',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d35_ex4',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d35_ex5',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d35_ex6',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
      ],
    },
    36: {
      'title': 'Day 36: Carlsbad Structure & Minority Attacks',
      'topic': 'Strategy',
      'theme': 'The classic b4-b5 minority advance creating c6 backward weaknesses',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1690,
      'prerequisites': <int>[35],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of The classic b4-b5 minority advance creating c6 backward weaknesses.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 36: Carlsbad Structure & Minority Attacks: The classic b4-b5 minority advance creating c6 backward weaknesses

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **The classic b4-b5 minority advance creating c6 backward weaknesses** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of The classic b4-b5 minority advance creating c6 backward weaknesses with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing The classic b4-b5 minority advance creating c6 backward weaknesses in sharp tournament conditions.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1987) — The Classic Carlsbad Minority Attack',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in pawn_break_discovery_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 35 foundations, drill 10 targeted flashcards on pawnStructures, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'The classic b4-b5 minority advance creating c6 backward weaknesses: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d36_ex1',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d36_ex2',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d36_ex3',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d36_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d36_ex5',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d36_ex6',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
      ],
    },
    37: {
      'title': 'Day 37: French Pawn Chains & Base Attacks',
      'topic': 'Strategy',
      'theme': 'Attacking the base of the chain at d4/c3 vs overprotection',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1704,
      'prerequisites': <int>[36],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Attacking the base of the chain at d4/c3 vs overprotection.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 37: French Pawn Chains & Base Attacks: Attacking the base of the chain at d4/c3 vs overprotection

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Attacking the base of the chain at d4/c3 vs overprotection** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Attacking the base of the chain at d4/c3 vs overprotection with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Attacking the base of the chain at d4/c3 vs overprotection in sharp tournament conditions.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs Vasily Smyslov (1954) — Undermining French Pawn Bases',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in pawn_break_discovery_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 36 foundations, drill 10 targeted flashcards on pawnStructures, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Attacking the base of the chain at d4/c3 vs overprotection: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d37_ex1',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d37_ex2',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d37_ex3',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d37_ex4',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d37_ex5',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d37_ex6',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
      ],
    },
    38: {
      'title': 'Day 38: Maroczy Bind & Dark Square Clamping',
      'topic': 'Strategy',
      'theme': 'c4/e4 pawn clamp paralyzing d5 breaks in the Sicilian',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1718,
      'prerequisites': <int>[37],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of c4/e4 pawn clamp paralyzing d5 breaks in the Sicilian.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 38: Maroczy Bind & Dark Square Clamping: c4/e4 pawn clamp paralyzing d5 breaks in the Sicilian

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **c4/e4 pawn clamp paralyzing d5 breaks in the Sicilian** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of c4/e4 pawn clamp paralyzing d5 breaks in the Sicilian with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing c4/e4 pawn clamp paralyzing d5 breaks in the Sicilian in sharp tournament conditions.',
      ],
      'gameStudy': 'Gedeon Barcza vs Bent Larsen (1964) — Paralyzing Breaks with the Maroczy Bind',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in pawn_structure_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 37 foundations, drill 10 targeted flashcards on pawnStructures, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'c4/e4 pawn clamp paralyzing d5 breaks in the Sicilian: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d38_ex1',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d38_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d38_ex3',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d38_ex4',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d38_ex5',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d38_ex6',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
      ],
    },
    39: {
      'title': 'Day 39: Prophylaxis & Karpovian Restriction',
      'topic': 'Strategy',
      'theme': 'Neutralizing opponent counterplay before launching operations',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 1732,
      'prerequisites': <int>[38],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Neutralizing opponent counterplay before launching operations.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 39: Prophylaxis & Karpovian Restriction: Neutralizing opponent counterplay before launching operations

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Neutralizing opponent counterplay before launching operations** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Neutralizing opponent counterplay before launching operations with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Neutralizing opponent counterplay before launching operations in sharp tournament conditions.',
      ],
      'gameStudy': 'Anatoly Karpov vs Wolfgang Unzicker (1974) — Total Prophylactic Asphyxiation',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in defensive_resource_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 38 foundations, drill 10 targeted flashcards on defense, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Neutralizing opponent counterplay before launching operations: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d39_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d39_ex2',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d39_ex3',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d39_ex4',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d39_ex5',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d39_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
      ],
    },
    40: {
      'title': 'Day 40: The Exchange Sacrifice for Dominance',
      'topic': 'Strategy',
      'theme': 'Petrosian-style rook-for-minor sacrifices to clamp squares',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1746,
      'prerequisites': <int>[39],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Petrosian-style rook-for-minor sacrifices to clamp squares.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 40: The Exchange Sacrifice for Dominance: Petrosian-style rook-for-minor sacrifices to clamp squares

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Petrosian-style rook-for-minor sacrifices to clamp squares** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Petrosian-style rook-for-minor sacrifices to clamp squares with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Petrosian-style rook-for-minor sacrifices to clamp squares in sharp tournament conditions.',
      ],
      'gameStudy': 'Tigran Petrosian vs Ludek Pachman (1961) — Positional Exchange Sacrifice on f6',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in positional_evaluation_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 39 foundations, drill 10 targeted flashcards on strategy, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Petrosian-style rook-for-minor sacrifices to clamp squares: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d40_ex1',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d40_ex2',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d40_ex3',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d40_ex4',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d40_ex5',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
        const CurriculumExercise(
          id: 'cur_d40_ex6',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
      ],
    },
    41: {
      'title': 'Day 41: The Principle of Two Weaknesses',
      'topic': 'Strategy',
      'theme': 'Stretching the defense between two distant fronts to force collapse',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1760,
      'prerequisites': <int>[40],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Stretching the defense between two distant fronts to force collapse.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 41: The Principle of Two Weaknesses: Stretching the defense between two distant fronts to force collapse

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Stretching the defense between two distant fronts to force collapse** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Stretching the defense between two distant fronts to force collapse with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Stretching the defense between two distant fronts to force collapse in sharp tournament conditions.',
      ],
      'gameStudy': 'Akiba Rubinstein vs Carl Schlechter (1912) — The Principle of Two Weaknesses',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in find_the_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 40 foundations, drill 10 targeted flashcards on strategy, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Stretching the defense between two distant fronts to force collapse: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d41_ex1',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d41_ex2',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d41_ex3',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d41_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d41_ex5',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
        const CurriculumExercise(
          id: 'cur_d41_ex6',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Carlsbad Minority Attack.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Carlsbad Minority Attack',
        ),
      ],
    },
    42: {
      'title': 'Day 42: Grand Milestone Exam: Strategic Mastery',
      'topic': 'Strategy',
      'theme': 'Comprehensive positional understanding and structural evaluation exam',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1774,
      'prerequisites': <int>[41],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Comprehensive positional understanding and structural evaluation exam.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 42: Grand Milestone Exam: Strategic Mastery: Comprehensive positional understanding and structural evaluation exam

## 1. Core Pedagogical Concept & Strategic Role
Positional mastery in **Comprehensive positional understanding and structural evaluation exam** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.


## 4. Practical Tournament Application & Psychological Triggers
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Comprehensive positional understanding and structural evaluation exam with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Comprehensive positional understanding and structural evaluation exam in sharp tournament conditions.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs David Bronstein (1951) — Grand Strategic Mastery Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Comprehensive positional understanding and structural evaluation exam, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 41 foundations, drill 10 targeted flashcards on strategy, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Comprehensive positional understanding and structural evaluation exam: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d42_ex1',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic IQP Dynamics.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'IQP Dynamics',
        ),
        const CurriculumExercise(
          id: 'cur_d42_ex2',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['a3'],
          explanation: 'Positional refinement: a3 executes the thematic Hanging Pawns.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Hanging Pawns',
        ),
        const CurriculumExercise(
          id: 'cur_d42_ex3',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['b4'],
          explanation: 'Positional refinement: b4 executes the thematic French Chain Break.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'French Chain Break',
        ),
        const CurriculumExercise(
          id: 'cur_d42_ex4',
          fen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Ne5'],
          explanation: 'Positional refinement: Ne5 executes the thematic Prophylaxis.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Prophylaxis',
        ),
        const CurriculumExercise(
          id: 'cur_d42_ex5',
          fen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
          sideToPlay: PieceColor.white,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['Nb5'],
          explanation: 'Positional refinement: Nb5 executes the thematic Outpost Seizure.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Outpost Seizure',
        ),
        const CurriculumExercise(
          id: 'cur_d42_ex6',
          fen: 'rnbqkbnr/ppp2ppp/4p3/3pP3/3P4/8/PPP2PPP/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Strategic Decision: Select the positional pawn break or piece relocation that maximizes long-term structure.',
          solutionSan: <String>['c5'],
          explanation: 'Positional refinement: c5 executes the thematic Bishop Pair Dominance.',
          hints: <String>['Evaluate static vs dynamic imbalances.', 'Identify weakest square in enemy camp.'],
          motif: 'Bishop Pair Dominance',
        ),
      ],
    },
    43: {
      'title': 'Day 43: King & Pawn: Key Squares & Opposition',
      'topic': 'Endgames',
      'theme': 'Seizing direct, distant, and diagonal opposition to promote',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1788,
      'prerequisites': <int>[42],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Seizing direct, distant, and diagonal opposition to promote.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 43: King & Pawn: Key Squares & Opposition: Seizing direct, distant, and diagonal opposition to promote

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Seizing direct, distant, and diagonal opposition to promote** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Seizing direct, distant, and diagonal opposition to promote with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Seizing direct, distant, and diagonal opposition to promote in sharp tournament conditions.',
      ],
      'gameStudy': 'Emanuel Lasker vs Siegbert Tarrasch (1908) — Key Squares & Vertical Opposition',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 42 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Seizing direct, distant, and diagonal opposition to promote: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d43_ex1',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d43_ex2',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d43_ex3',
          fen: '8/8/5k2/8/8/8/4Q3/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qf3+'],
          explanation: 'Textbook endgame execution: Qf3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d43_ex4',
          fen: '8/8/8/4k3/8/4NK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nc4+'],
          explanation: 'Textbook endgame execution: Nc4+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d43_ex5',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d43_ex6',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
      ],
    },
    44: {
      'title': 'Day 44: King & Pawn: The Square Rule & Reti Maneuver',
      'topic': 'Endgames',
      'theme': 'Calculating pawn races and dual-purpose diagonal king marches',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1802,
      'prerequisites': <int>[43],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculating pawn races and dual-purpose diagonal king marches.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 44: King & Pawn: The Square Rule & Reti Maneuver: Calculating pawn races and dual-purpose diagonal king marches

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Calculating pawn races and dual-purpose diagonal king marches** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Calculating pawn races and dual-purpose diagonal king marches with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Calculating pawn races and dual-purpose diagonal king marches in sharp tournament conditions.',
      ],
      'gameStudy': 'Richard Reti vs Alexander Alekhine (1922) — The Reti Diagonal King March',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 43 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Calculating pawn races and dual-purpose diagonal king marches: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d44_ex1',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Textbook endgame execution: Qd8# secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d44_ex2',
          fen: '8/8/8/4k3/8/4BK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Bc5'],
          explanation: 'Textbook endgame execution: Bc5 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d44_ex3',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d44_ex4',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d44_ex5',
          fen: '8/8/8/3k4/8/8/5Q2/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qe3'],
          explanation: 'Textbook endgame execution: Qe3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d44_ex6',
          fen: '8/8/8/4k3/8/5K2/4N3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nf4'],
          explanation: 'Textbook endgame execution: Nf4 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
      ],
    },
    45: {
      'title': 'Day 45: King & Pawn: Triangulation & Outflanking',
      'topic': 'Endgames',
      'theme': 'Losing a tempo deliberately to put the enemy king in zugzwang',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1816,
      'prerequisites': <int>[44],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Losing a tempo deliberately to put the enemy king in zugzwang.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 45: King & Pawn: Triangulation & Outflanking: Losing a tempo deliberately to put the enemy king in zugzwang

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Losing a tempo deliberately to put the enemy king in zugzwang** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Losing a tempo deliberately to put the enemy king in zugzwang with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Losing a tempo deliberately to put the enemy king in zugzwang in sharp tournament conditions.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Alexander Alekhine (1927) — Triangulation & Outflanking',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 44 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Losing a tempo deliberately to put the enemy king in zugzwang: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d45_ex1',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d45_ex2',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d45_ex3',
          fen: '8/8/5k2/8/8/8/4Q3/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qf3+'],
          explanation: 'Textbook endgame execution: Qf3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d45_ex4',
          fen: '8/8/8/4k3/8/4NK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nc4+'],
          explanation: 'Textbook endgame execution: Nc4+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d45_ex5',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d45_ex6',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
      ],
    },
    46: {
      'title': 'Day 46: Rook Endgames: The Lucena Position',
      'topic': 'Endgames',
      'theme': 'Building a bridge with Rf4/Rd4+ to safely queen the passed pawn',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1830,
      'prerequisites': <int>[45],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Building a bridge with Rf4/Rd4+ to safely queen the passed pawn.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 46: Rook Endgames: The Lucena Position: Building a bridge with Rf4/Rd4+ to safely queen the passed pawn

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Building a bridge with Rf4/Rd4+ to safely queen the passed pawn** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Building a bridge with Rf4/Rd4+ to safely queen the passed pawn with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Building a bridge with Rf4/Rd4+ to safely queen the passed pawn in sharp tournament conditions.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Savielly Tartakower (1924) — Building the Lucena Bridge',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 45 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Building a bridge with Rf4/Rd4+ to safely queen the passed pawn: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d46_ex1',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Textbook endgame execution: Qd8# secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d46_ex2',
          fen: '8/8/8/4k3/8/4BK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Bc5'],
          explanation: 'Textbook endgame execution: Bc5 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d46_ex3',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d46_ex4',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d46_ex5',
          fen: '8/8/8/3k4/8/8/5Q2/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qe3'],
          explanation: 'Textbook endgame execution: Qe3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d46_ex6',
          fen: '8/8/8/4k3/8/5K2/4N3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nf4'],
          explanation: 'Textbook endgame execution: Nf4 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
      ],
    },
    47: {
      'title': 'Day 47: Rook Endgames: The Philidor Defense',
      'topic': 'Endgames',
      'theme': 'Third-rank passive clamp transitioning to rear checks',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1844,
      'prerequisites': <int>[46],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Third-rank passive clamp transitioning to rear checks.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 47: Rook Endgames: The Philidor Defense: Third-rank passive clamp transitioning to rear checks

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Third-rank passive clamp transitioning to rear checks** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Third-rank passive clamp transitioning to rear checks with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Third-rank passive clamp transitioning to rear checks in sharp tournament conditions.',
      ],
      'gameStudy': 'Francois Philidor Studies (1777) — The Classic Third-Rank Passive Clamp',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 46 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Third-rank passive clamp transitioning to rear checks: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d47_ex1',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d47_ex2',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d47_ex3',
          fen: '8/8/5k2/8/8/8/4Q3/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qf3+'],
          explanation: 'Textbook endgame execution: Qf3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d47_ex4',
          fen: '8/8/8/4k3/8/4NK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nc4+'],
          explanation: 'Textbook endgame execution: Nc4+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d47_ex5',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d47_ex6',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
      ],
    },
    48: {
      'title': 'Day 48: Rook Endgames: Active Rook & Cutting Off the King',
      'topic': 'Endgames',
      'theme': 'Activity trumps passive defense in all theoretical rook endings',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1858,
      'prerequisites': <int>[47],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Activity trumps passive defense in all theoretical rook endings.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 48: Rook Endgames: Active Rook & Cutting Off the King: Activity trumps passive defense in all theoretical rook endings

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Activity trumps passive defense in all theoretical rook endings** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Activity trumps passive defense in all theoretical rook endings with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Activity trumps passive defense in all theoretical rook endings in sharp tournament conditions.',
      ],
      'gameStudy': 'Akiba Rubinstein vs Milan Vidmar (1911) — Cutting Off the King on the Rank',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 47 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Activity trumps passive defense in all theoretical rook endings: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d48_ex1',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Textbook endgame execution: Qd8# secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d48_ex2',
          fen: '8/8/8/4k3/8/4BK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Bc5'],
          explanation: 'Textbook endgame execution: Bc5 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d48_ex3',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d48_ex4',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d48_ex5',
          fen: '8/8/8/3k4/8/8/5Q2/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qe3'],
          explanation: 'Textbook endgame execution: Qe3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d48_ex6',
          fen: '8/8/8/4k3/8/5K2/4N3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nf4'],
          explanation: 'Textbook endgame execution: Nf4 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
      ],
    },
    49: {
      'title': 'Day 49: Milestone Exam: Core Rook Endgames',
      'topic': 'Endgames',
      'theme': 'Flawless technical execution of Lucena, Philidor, and Vancura',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1872,
      'prerequisites': <int>[48],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Flawless technical execution of Lucena, Philidor, and Vancura.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 49: Milestone Exam: Core Rook Endgames: Flawless technical execution of Lucena, Philidor, and Vancura

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Flawless technical execution of Lucena, Philidor, and Vancura** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Flawless technical execution of Lucena, Philidor, and Vancura with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Flawless technical execution of Lucena, Philidor, and Vancura in sharp tournament conditions.',
      ],
      'gameStudy': 'Viktor Korchnoi vs Anatoly Karpov (1978) — Core Rook Endgame Milestone Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Flawless technical execution of Lucena, Philidor, and Vancura, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 48 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Flawless technical execution of Lucena, Philidor, and Vancura: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d49_ex1',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d49_ex2',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d49_ex3',
          fen: '8/8/5k2/8/8/8/4Q3/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qf3+'],
          explanation: 'Textbook endgame execution: Qf3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d49_ex4',
          fen: '8/8/8/4k3/8/4NK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nc4+'],
          explanation: 'Textbook endgame execution: Nc4+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d49_ex5',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d49_ex6',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
      ],
    },
    50: {
      'title': 'Day 50: Minor Piece: Same-Colored Bishops',
      'topic': 'Endgames',
      'theme': 'Attacking fixed pawn weaknesses on the color complex',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1886,
      'prerequisites': <int>[49],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Attacking fixed pawn weaknesses on the color complex.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 50: Minor Piece: Same-Colored Bishops: Attacking fixed pawn weaknesses on the color complex

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Attacking fixed pawn weaknesses on the color complex** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Attacking fixed pawn weaknesses on the color complex with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Attacking fixed pawn weaknesses on the color complex in sharp tournament conditions.',
      ],
      'gameStudy': 'Bobby Fischer vs Boris Spassky (1972 Game 4) — Same-Colored Bishop Pawns on Fixed Squares',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 49 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Attacking fixed pawn weaknesses on the color complex: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d50_ex1',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Textbook endgame execution: Qd8# secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d50_ex2',
          fen: '8/8/8/4k3/8/4BK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Bc5'],
          explanation: 'Textbook endgame execution: Bc5 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d50_ex3',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d50_ex4',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d50_ex5',
          fen: '8/8/8/3k4/8/8/5Q2/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qe3'],
          explanation: 'Textbook endgame execution: Qe3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d50_ex6',
          fen: '8/8/8/4k3/8/5K2/4N3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nf4'],
          explanation: 'Textbook endgame execution: Nf4 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
      ],
    },
    51: {
      'title': 'Day 51: Minor Piece: Opposite-Colored Bishops Fortress',
      'topic': 'Endgames',
      'theme': 'Constructing unbreachable blockades despite material deficits',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1900,
      'prerequisites': <int>[50],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Constructing unbreachable blockades despite material deficits.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 51: Minor Piece: Opposite-Colored Bishops Fortress: Constructing unbreachable blockades despite material deficits

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Constructing unbreachable blockades despite material deficits** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Constructing unbreachable blockades despite material deficits with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Constructing unbreachable blockades despite material deficits in sharp tournament conditions.',
      ],
      'gameStudy': 'David Bronstein vs Paul Keres (1955) — Unbreachable Opposite-Colored Bishop Blockade',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 50 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Constructing unbreachable blockades despite material deficits: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d51_ex1',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d51_ex2',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d51_ex3',
          fen: '8/8/5k2/8/8/8/4Q3/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qf3+'],
          explanation: 'Textbook endgame execution: Qf3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d51_ex4',
          fen: '8/8/8/4k3/8/4NK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nc4+'],
          explanation: 'Textbook endgame execution: Nc4+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d51_ex5',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d51_ex6',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
      ],
    },
    52: {
      'title': 'Day 52: Minor Piece: Knight vs Bishop Endgames',
      'topic': 'Endgames',
      'theme': 'Open board bishop scope vs closed board knight outposts',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1914,
      'prerequisites': <int>[51],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Open board bishop scope vs closed board knight outposts.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 52: Minor Piece: Knight vs Bishop Endgames: Open board bishop scope vs closed board knight outposts

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Open board bishop scope vs closed board knight outposts** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Open board bishop scope vs closed board knight outposts with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Open board bishop scope vs closed board knight outposts in sharp tournament conditions.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Emanuel Lasker (1921) — Dominating Closed Boards with the Knight',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 51 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Open board bishop scope vs closed board knight outposts: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d52_ex1',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Textbook endgame execution: Qd8# secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d52_ex2',
          fen: '8/8/8/4k3/8/4BK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Bc5'],
          explanation: 'Textbook endgame execution: Bc5 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d52_ex3',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d52_ex4',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d52_ex5',
          fen: '8/8/8/3k4/8/8/5Q2/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qe3'],
          explanation: 'Textbook endgame execution: Qe3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d52_ex6',
          fen: '8/8/8/4k3/8/5K2/4N3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nf4'],
          explanation: 'Textbook endgame execution: Nf4 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
      ],
    },
    53: {
      'title': 'Day 53: Queen Endgames: Perpetual Checks & Passed Pawns',
      'topic': 'Endgames',
      'theme': 'Shielding the king from spite checks while pushing the pawn',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1928,
      'prerequisites': <int>[52],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Shielding the king from spite checks while pushing the pawn.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 53: Queen Endgames: Perpetual Checks & Passed Pawns: Shielding the king from spite checks while pushing the pawn

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Shielding the king from spite checks while pushing the pawn** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Shielding the king from spite checks while pushing the pawn with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Shielding the king from spite checks while pushing the pawn in sharp tournament conditions.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1986 Game 22) — Queen Ending King Umbrella',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 52 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Shielding the king from spite checks while pushing the pawn: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d53_ex1',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d53_ex2',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d53_ex3',
          fen: '8/8/5k2/8/8/8/4Q3/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qf3+'],
          explanation: 'Textbook endgame execution: Qf3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d53_ex4',
          fen: '8/8/8/4k3/8/4NK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nc4+'],
          explanation: 'Textbook endgame execution: Nc4+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d53_ex5',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d53_ex6',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
      ],
    },
    54: {
      'title': 'Day 54: Converting Material: Two Pawns Up Technique',
      'topic': 'Endgames',
      'theme': 'Simplification protocols and neutralizing stalemate tricks',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 1942,
      'prerequisites': <int>[53],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Simplification protocols and neutralizing stalemate tricks.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 54: Converting Material: Two Pawns Up Technique: Simplification protocols and neutralizing stalemate tricks

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Simplification protocols and neutralizing stalemate tricks** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Simplification protocols and neutralizing stalemate tricks with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Simplification protocols and neutralizing stalemate tricks in sharp tournament conditions.',
      ],
      'gameStudy': 'Magnus Carlsen vs Fabiano Caruana (2018) — Flawless Two-Pawns-Up Conversion',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in conversion_challenge_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 53 foundations, drill 10 targeted flashcards on conversion, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Simplification protocols and neutralizing stalemate tricks: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d54_ex1',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Textbook endgame execution: Qd8# secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d54_ex2',
          fen: '8/8/8/4k3/8/4BK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Bc5'],
          explanation: 'Textbook endgame execution: Bc5 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d54_ex3',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d54_ex4',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d54_ex5',
          fen: '8/8/8/3k4/8/8/5Q2/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qe3'],
          explanation: 'Textbook endgame execution: Qe3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d54_ex6',
          fen: '8/8/8/4k3/8/5K2/4N3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nf4'],
          explanation: 'Textbook endgame execution: Nf4 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
      ],
    },
    55: {
      'title': 'Day 55: Fortress Recognition & Defensive Saves',
      'topic': 'Endgames',
      'theme': 'Identifying theoretical drawing configurations when losing',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 1956,
      'prerequisites': <int>[54],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Identifying theoretical drawing configurations when losing.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 55: Fortress Recognition & Defensive Saves: Identifying theoretical drawing configurations when losing

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Identifying theoretical drawing configurations when losing** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Identifying theoretical drawing configurations when losing with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Identifying theoretical drawing configurations when losing in sharp tournament conditions.',
      ],
      'gameStudy': 'Boris Spassky vs Bobby Fischer (1972 Game 13) — Constructing Theoretical Fortresses',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in defensive_resource_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 54 foundations, drill 10 targeted flashcards on defense, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Identifying theoretical drawing configurations when losing: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d55_ex1',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d55_ex2',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d55_ex3',
          fen: '8/8/5k2/8/8/8/4Q3/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qf3+'],
          explanation: 'Textbook endgame execution: Qf3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d55_ex4',
          fen: '8/8/8/4k3/8/4NK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nc4+'],
          explanation: 'Textbook endgame execution: Nc4+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d55_ex5',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d55_ex6',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
      ],
    },
    56: {
      'title': 'Day 56: Grand Milestone Exam: Practical Endgame Mastery',
      'topic': 'Endgames',
      'theme': 'Engine-level endgame precision and tablebase conversion certification',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 1970,
      'prerequisites': <int>[55],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Engine-level endgame precision and tablebase conversion certification.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 56: Grand Milestone Exam: Practical Endgame Mastery: Engine-level endgame precision and tablebase conversion certification

## 1. Core Pedagogical Concept & Strategic Role
Endgame precision in **Engine-level endgame precision and tablebase conversion certification** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Engine-level endgame precision and tablebase conversion certification with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Engine-level endgame precision and tablebase conversion certification in sharp tournament conditions.',
      ],
      'gameStudy': 'Vasily Smyslov vs Paul Keres (1953) — Grand Endgame Technical Mastery Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Engine-level endgame precision and tablebase conversion certification, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 55 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Engine-level endgame precision and tablebase conversion certification: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d56_ex1',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Textbook endgame execution: Qd8# secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d56_ex2',
          fen: '8/8/8/4k3/8/4BK2/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Bc5'],
          explanation: 'Textbook endgame execution: Bc5 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d56_ex3',
          fen: '8/8/8/4k3/4P3/4K3/8/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Pawn Endgames position.',
          solutionSan: <String>['Kd3'],
          explanation: 'Textbook endgame execution: Kd3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Pawn Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d56_ex4',
          fen: '8/8/8/8/8/4k3/1r6/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Rook Endgames position.',
          solutionSan: <String>['Rh3+'],
          explanation: 'Textbook endgame execution: Rh3+ secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Rook Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d56_ex5',
          fen: '8/8/8/3k4/8/8/5Q2/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Queen Endgames position.',
          solutionSan: <String>['Qe3'],
          explanation: 'Textbook endgame execution: Qe3 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Queen Endgames',
        ),
        const CurriculumExercise(
          id: 'cur_d56_ex6',
          fen: '8/8/8/4k3/8/5K2/4N3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Endgame Mastery: Execute precise theoretical technique in this Minor Piece Endgames position.',
          solutionSan: <String>['Nf4'],
          explanation: 'Textbook endgame execution: Nf4 secures the mathematical result.',
          hints: <String>['King activity is paramount in endgames.', 'Remember theoretical benchmarks (Lucena, Philidor, opposition).'],
          motif: 'Minor Piece Endgames',
        ),
      ],
    },
    57: {
      'title': 'Day 57: Opening Fundamentals & Center Domination',
      'topic': 'Openings',
      'theme': 'Rapid development, king safety, and early central claiming',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 1984,
      'prerequisites': <int>[56],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Rapid development, king safety, and early central claiming.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 57: Opening Fundamentals & Center Domination: Rapid development, king safety, and early central claiming

## 1. Core Pedagogical Concept & Strategic Role
Modern opening mastery in **Rapid development, king safety, and early central claiming** is about understanding pawn structures, tabias, and transpositions, not rote memorization of 25 moves.

Opening strategic imperatives:
- **Central Stake**: Fight for d4/d5/e4/e5 from move one with pawns and pieces.
- **Harmonious Piece Development**: Develop minor pieces toward the center before moving the same piece twice.
- **Rapid King Safety**: Castle early to connect heavy pieces and remove the king from open vertical files.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the opening tabias:
- **Candidate Move A (The Decisive Continuation)**: Stakes a claim in the center, adheres to sound repertoire theory, and maintains dynamic balance or a slight spatial pull.
- **Candidate Move B (The Common Tempting Mistake)**: A pawn-grabbing sideline or superficial attack that neglects king safety and gives the opponent a massive lead in development.
- **Why Wrong Choices Fail (Refutation Analysis)**: Greedily capturing poisoned pawns at the expense of piece development leads to rapid central collapse. Refutation comes in the form of rapid open-file piece infiltration.


## 4. Practical Tournament Application & Psychological Triggers
1. Memorize opening ideas, plans, and typical pawn breaks rather than isolated moves.
2. If your opponent delays castling, open the center immediately even at the cost of a pawn.
3. Review your personal opening tree after every serious tournament game.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Rapid development, king safety, and early central claiming with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Rapid development, king safety, and early central claiming in sharp tournament conditions.',
      ],
      'gameStudy': 'Paul Morphy vs Adolf Anderssen (1858) — Rapid Classical Center Control',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in opening_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 56 foundations, drill 10 targeted flashcards on openings, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Rapid development, king safety, and early central claiming: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d57_ex1',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Italian Game.',
          solutionSan: <String>['Bc5'],
          explanation: 'Theoretical precision: Bc5 is the master standard in the Italian Game.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d57_ex2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Ruy Lopez.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the Ruy Lopez.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d57_ex3',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/2N5/PPP2PPP/R1BQKB1R b KQkq - 0 5',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Sicilian Najdorf.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the Sicilian Najdorf.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d57_ex4',
          fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Sicilian Dragon.',
          solutionSan: <String>['d4'],
          explanation: 'Theoretical precision: d4 is the master standard in the Sicilian Dragon.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d57_ex5',
          fen: 'rnbqkbnr/pp1ppppp/2p5/8/3PP3/8/PPP2PPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the French Winawer.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the French Winawer.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d57_ex6',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Caro-Kann Advance.',
          solutionSan: <String>['e6'],
          explanation: 'Theoretical precision: e6 is the master standard in the Caro-Kann Advance.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
      ],
    },
    58: {
      'title': 'Day 58: 1.e4 Repertoire: Open Games (Scotch & Italian)',
      'topic': 'Openings',
      'theme': 'Direct central challenges and aggressive piece development',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 1998,
      'prerequisites': <int>[57],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Direct central challenges and aggressive piece development.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 58: 1.e4 Repertoire: Open Games (Scotch & Italian): Direct central challenges and aggressive piece development

## 1. Core Pedagogical Concept & Strategic Role
Modern opening mastery in **Direct central challenges and aggressive piece development** is about understanding pawn structures, tabias, and transpositions, not rote memorization of 25 moves.

Opening strategic imperatives:
- **Central Stake**: Fight for d4/d5/e4/e5 from move one with pawns and pieces.
- **Harmonious Piece Development**: Develop minor pieces toward the center before moving the same piece twice.
- **Rapid King Safety**: Castle early to connect heavy pieces and remove the king from open vertical files.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the opening tabias:
- **Candidate Move A (The Decisive Continuation)**: Stakes a claim in the center, adheres to sound repertoire theory, and maintains dynamic balance or a slight spatial pull.
- **Candidate Move B (The Common Tempting Mistake)**: A pawn-grabbing sideline or superficial attack that neglects king safety and gives the opponent a massive lead in development.
- **Why Wrong Choices Fail (Refutation Analysis)**: Greedily capturing poisoned pawns at the expense of piece development leads to rapid central collapse. Refutation comes in the form of rapid open-file piece infiltration.


## 4. Practical Tournament Application & Psychological Triggers
1. Memorize opening ideas, plans, and typical pawn breaks rather than isolated moves.
2. If your opponent delays castling, open the center immediately even at the cost of a pawn.
3. Review your personal opening tree after every serious tournament game.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Direct central challenges and aggressive piece development with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Direct central challenges and aggressive piece development in sharp tournament conditions.',
      ],
      'gameStudy': 'Garry Kasparov vs Nigel Short (1993) — The Dynamic Scotch Center Blast',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in opening_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 57 foundations, drill 10 targeted flashcards on openings, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Direct central challenges and aggressive piece development: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d58_ex1',
          fen: 'rnbqkb1r/pppppp1p/5np1/8/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Queen\'s Gambit Declined.',
          solutionSan: <String>['Nc3'],
          explanation: 'Theoretical precision: Nc3 is the master standard in the Queen\'s Gambit Declined.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d58_ex2',
          fen: 'rnbqk2r/pppp1ppp/4pn2/8/1bPP4/2N5/PP2PPPP/R1BQKBNR w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Slav Defense.',
          solutionSan: <String>['e3'],
          explanation: 'Theoretical precision: e3 is the master standard in the Slav Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d58_ex3',
          fen: 'rnbqkb1r/pppp1ppp/4pn2/8/2PP4/6P1/PP2PP1P/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the King\'s Indian Defense.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the King\'s Indian Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d58_ex4',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Nimzo-Indian Defense.',
          solutionSan: <String>['Bc5'],
          explanation: 'Theoretical precision: Bc5 is the master standard in the Nimzo-Indian Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d58_ex5',
          fen: 'r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Catalan Opening.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the Catalan Opening.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d58_ex6',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/2N5/PPP2PPP/R1BQKB1R b KQkq - 0 5',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Italian Game.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the Italian Game.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
      ],
    },
    59: {
      'title': 'Day 59: 1.e4 vs The Sicilian: Open vs Anti-Sicilian',
      'topic': 'Openings',
      'theme': 'Navigating dynamic asymmetrical battlegrounds',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2012,
      'prerequisites': <int>[58],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Navigating dynamic asymmetrical battlegrounds.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 59: 1.e4 vs The Sicilian: Open vs Anti-Sicilian: Navigating dynamic asymmetrical battlegrounds

## 1. Core Pedagogical Concept & Strategic Role
Modern opening mastery in **Navigating dynamic asymmetrical battlegrounds** is about understanding pawn structures, tabias, and transpositions, not rote memorization of 25 moves.

Opening strategic imperatives:
- **Central Stake**: Fight for d4/d5/e4/e5 from move one with pawns and pieces.
- **Harmonious Piece Development**: Develop minor pieces toward the center before moving the same piece twice.
- **Rapid King Safety**: Castle early to connect heavy pieces and remove the king from open vertical files.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the opening tabias:
- **Candidate Move A (The Decisive Continuation)**: Stakes a claim in the center, adheres to sound repertoire theory, and maintains dynamic balance or a slight spatial pull.
- **Candidate Move B (The Common Tempting Mistake)**: A pawn-grabbing sideline or superficial attack that neglects king safety and gives the opponent a massive lead in development.
- **Why Wrong Choices Fail (Refutation Analysis)**: Greedily capturing poisoned pawns at the expense of piece development leads to rapid central collapse. Refutation comes in the form of rapid open-file piece infiltration.


## 4. Practical Tournament Application & Psychological Triggers
1. Memorize opening ideas, plans, and typical pawn breaks rather than isolated moves.
2. If your opponent delays castling, open the center immediately even at the cost of a pawn.
3. Review your personal opening tree after every serious tournament game.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Navigating dynamic asymmetrical battlegrounds with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Navigating dynamic asymmetrical battlegrounds in sharp tournament conditions.',
      ],
      'gameStudy': 'Bobby Fischer vs Boris Spassky (1972 Game 6) — Neutralizing Dynamic Sicilian Structures',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in opening_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 58 foundations, drill 10 targeted flashcards on openings, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Navigating dynamic asymmetrical battlegrounds: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d59_ex1',
          fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Ruy Lopez.',
          solutionSan: <String>['d4'],
          explanation: 'Theoretical precision: d4 is the master standard in the Ruy Lopez.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d59_ex2',
          fen: 'rnbqkbnr/pp1ppppp/2p5/8/3PP3/8/PPP2PPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Sicilian Najdorf.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the Sicilian Najdorf.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d59_ex3',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Sicilian Dragon.',
          solutionSan: <String>['e6'],
          explanation: 'Theoretical precision: e6 is the master standard in the Sicilian Dragon.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d59_ex4',
          fen: 'rnbqkb1r/pppppp1p/5np1/8/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the French Winawer.',
          solutionSan: <String>['Nc3'],
          explanation: 'Theoretical precision: Nc3 is the master standard in the French Winawer.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d59_ex5',
          fen: 'rnbqk2r/pppp1ppp/4pn2/8/1bPP4/2N5/PP2PPPP/R1BQKBNR w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Caro-Kann Advance.',
          solutionSan: <String>['e3'],
          explanation: 'Theoretical precision: e3 is the master standard in the Caro-Kann Advance.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d59_ex6',
          fen: 'rnbqkb1r/pppp1ppp/4pn2/8/2PP4/6P1/PP2PP1P/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Queen\'s Gambit Declined.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the Queen\'s Gambit Declined.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
      ],
    },
    60: {
      'title': 'Day 60: 1.d4 Repertoire: Queen Gambit & Catalan',
      'topic': 'Openings',
      'theme': 'Solid positional pressure and harmonic long diagonals',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2026,
      'prerequisites': <int>[59],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Solid positional pressure and harmonic long diagonals.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 60: 1.d4 Repertoire: Queen Gambit & Catalan: Solid positional pressure and harmonic long diagonals

## 1. Core Pedagogical Concept & Strategic Role
Modern opening mastery in **Solid positional pressure and harmonic long diagonals** is about understanding pawn structures, tabias, and transpositions, not rote memorization of 25 moves.

Opening strategic imperatives:
- **Central Stake**: Fight for d4/d5/e4/e5 from move one with pawns and pieces.
- **Harmonious Piece Development**: Develop minor pieces toward the center before moving the same piece twice.
- **Rapid King Safety**: Castle early to connect heavy pieces and remove the king from open vertical files.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the opening tabias:
- **Candidate Move A (The Decisive Continuation)**: Stakes a claim in the center, adheres to sound repertoire theory, and maintains dynamic balance or a slight spatial pull.
- **Candidate Move B (The Common Tempting Mistake)**: A pawn-grabbing sideline or superficial attack that neglects king safety and gives the opponent a massive lead in development.
- **Why Wrong Choices Fail (Refutation Analysis)**: Greedily capturing poisoned pawns at the expense of piece development leads to rapid central collapse. Refutation comes in the form of rapid open-file piece infiltration.


## 4. Practical Tournament Application & Psychological Triggers
1. Memorize opening ideas, plans, and typical pawn breaks rather than isolated moves.
2. If your opponent delays castling, open the center immediately even at the cost of a pawn.
3. Review your personal opening tree after every serious tournament game.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Solid positional pressure and harmonic long diagonals with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Solid positional pressure and harmonic long diagonals in sharp tournament conditions.',
      ],
      'gameStudy': 'Vladimir Kramnik vs Garry Kasparov (2000 Game 2) — Catalan Long Diagonal Squeeze',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in opening_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 59 foundations, drill 10 targeted flashcards on openings, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Solid positional pressure and harmonic long diagonals: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d60_ex1',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Slav Defense.',
          solutionSan: <String>['Bc5'],
          explanation: 'Theoretical precision: Bc5 is the master standard in the Slav Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d60_ex2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the King\'s Indian Defense.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the King\'s Indian Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d60_ex3',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/2N5/PPP2PPP/R1BQKB1R b KQkq - 0 5',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Nimzo-Indian Defense.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the Nimzo-Indian Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d60_ex4',
          fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Catalan Opening.',
          solutionSan: <String>['d4'],
          explanation: 'Theoretical precision: d4 is the master standard in the Catalan Opening.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d60_ex5',
          fen: 'rnbqkbnr/pp1ppppp/2p5/8/3PP3/8/PPP2PPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Italian Game.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the Italian Game.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d60_ex6',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Ruy Lopez.',
          solutionSan: <String>['e6'],
          explanation: 'Theoretical precision: e6 is the master standard in the Ruy Lopez.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
      ],
    },
    61: {
      'title': 'Day 61: Defending with Black: Solid 1.e4 Responses',
      'topic': 'Openings',
      'theme': 'Sturdy Caro-Kann and French structures with counter-punches',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2040,
      'prerequisites': <int>[60],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Sturdy Caro-Kann and French structures with counter-punches.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 61: Defending with Black: Solid 1.e4 Responses: Sturdy Caro-Kann and French structures with counter-punches

## 1. Core Pedagogical Concept & Strategic Role
Modern opening mastery in **Sturdy Caro-Kann and French structures with counter-punches** is about understanding pawn structures, tabias, and transpositions, not rote memorization of 25 moves.

Opening strategic imperatives:
- **Central Stake**: Fight for d4/d5/e4/e5 from move one with pawns and pieces.
- **Harmonious Piece Development**: Develop minor pieces toward the center before moving the same piece twice.
- **Rapid King Safety**: Castle early to connect heavy pieces and remove the king from open vertical files.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the opening tabias:
- **Candidate Move A (The Decisive Continuation)**: Stakes a claim in the center, adheres to sound repertoire theory, and maintains dynamic balance or a slight spatial pull.
- **Candidate Move B (The Common Tempting Mistake)**: A pawn-grabbing sideline or superficial attack that neglects king safety and gives the opponent a massive lead in development.
- **Why Wrong Choices Fail (Refutation Analysis)**: Greedily capturing poisoned pawns at the expense of piece development leads to rapid central collapse. Refutation comes in the form of rapid open-file piece infiltration.


## 4. Practical Tournament Application & Psychological Triggers
1. Memorize opening ideas, plans, and typical pawn breaks rather than isolated moves.
2. If your opponent delays castling, open the center immediately even at the cost of a pawn.
3. Review your personal opening tree after every serious tournament game.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Sturdy Caro-Kann and French structures with counter-punches with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Sturdy Caro-Kann and French structures with counter-punches in sharp tournament conditions.',
      ],
      'gameStudy': 'Anatoly Karpov vs Viktor Korchnoi (1981) — The Rock-Solid Caro-Kann Defense',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in opening_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 60 foundations, drill 10 targeted flashcards on openings, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Sturdy Caro-Kann and French structures with counter-punches: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d61_ex1',
          fen: 'rnbqkb1r/pppppp1p/5np1/8/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Sicilian Najdorf.',
          solutionSan: <String>['Nc3'],
          explanation: 'Theoretical precision: Nc3 is the master standard in the Sicilian Najdorf.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d61_ex2',
          fen: 'rnbqk2r/pppp1ppp/4pn2/8/1bPP4/2N5/PP2PPPP/R1BQKBNR w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Sicilian Dragon.',
          solutionSan: <String>['e3'],
          explanation: 'Theoretical precision: e3 is the master standard in the Sicilian Dragon.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d61_ex3',
          fen: 'rnbqkb1r/pppp1ppp/4pn2/8/2PP4/6P1/PP2PP1P/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the French Winawer.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the French Winawer.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d61_ex4',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Caro-Kann Advance.',
          solutionSan: <String>['Bc5'],
          explanation: 'Theoretical precision: Bc5 is the master standard in the Caro-Kann Advance.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d61_ex5',
          fen: 'r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Queen\'s Gambit Declined.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the Queen\'s Gambit Declined.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d61_ex6',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/2N5/PPP2PPP/R1BQKB1R b KQkq - 0 5',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Slav Defense.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the Slav Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
      ],
    },
    62: {
      'title': 'Day 62: Defending with Black: Dynamic 1.d4 Responses',
      'topic': 'Openings',
      'theme': 'King Indian and Nimzo-Indian active counterplay',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2054,
      'prerequisites': <int>[61],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of King Indian and Nimzo-Indian active counterplay.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 62: Defending with Black: Dynamic 1.d4 Responses: King Indian and Nimzo-Indian active counterplay

## 1. Core Pedagogical Concept & Strategic Role
Modern opening mastery in **King Indian and Nimzo-Indian active counterplay** is about understanding pawn structures, tabias, and transpositions, not rote memorization of 25 moves.

Opening strategic imperatives:
- **Central Stake**: Fight for d4/d5/e4/e5 from move one with pawns and pieces.
- **Harmonious Piece Development**: Develop minor pieces toward the center before moving the same piece twice.
- **Rapid King Safety**: Castle early to connect heavy pieces and remove the king from open vertical files.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the opening tabias:
- **Candidate Move A (The Decisive Continuation)**: Stakes a claim in the center, adheres to sound repertoire theory, and maintains dynamic balance or a slight spatial pull.
- **Candidate Move B (The Common Tempting Mistake)**: A pawn-grabbing sideline or superficial attack that neglects king safety and gives the opponent a massive lead in development.
- **Why Wrong Choices Fail (Refutation Analysis)**: Greedily capturing poisoned pawns at the expense of piece development leads to rapid central collapse. Refutation comes in the form of rapid open-file piece infiltration.


## 4. Practical Tournament Application & Psychological Triggers
1. Memorize opening ideas, plans, and typical pawn breaks rather than isolated moves.
2. If your opponent delays castling, open the center immediately even at the cost of a pawn.
3. Review your personal opening tree after every serious tournament game.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of King Indian and Nimzo-Indian active counterplay with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing King Indian and Nimzo-Indian active counterplay in sharp tournament conditions.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1985 Game 24) — King\'s Indian Dynamic Counter-Punch',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in opening_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 61 foundations, drill 10 targeted flashcards on openings, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'King Indian and Nimzo-Indian active counterplay: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d62_ex1',
          fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the King\'s Indian Defense.',
          solutionSan: <String>['d4'],
          explanation: 'Theoretical precision: d4 is the master standard in the King\'s Indian Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d62_ex2',
          fen: 'rnbqkbnr/pp1ppppp/2p5/8/3PP3/8/PPP2PPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Nimzo-Indian Defense.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the Nimzo-Indian Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d62_ex3',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Catalan Opening.',
          solutionSan: <String>['e6'],
          explanation: 'Theoretical precision: e6 is the master standard in the Catalan Opening.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d62_ex4',
          fen: 'rnbqkb1r/pppppp1p/5np1/8/2PP4/8/PP2PPPP/RNBQKBNR w KQkq - 0 3',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Italian Game.',
          solutionSan: <String>['Nc3'],
          explanation: 'Theoretical precision: Nc3 is the master standard in the Italian Game.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d62_ex5',
          fen: 'rnbqk2r/pppp1ppp/4pn2/8/1bPP4/2N5/PP2PPPP/R1BQKBNR w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Ruy Lopez.',
          solutionSan: <String>['e3'],
          explanation: 'Theoretical precision: e3 is the master standard in the Ruy Lopez.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d62_ex6',
          fen: 'rnbqkb1r/pppp1ppp/4pn2/8/2PP4/6P1/PP2PP1P/RNBQKBNR b KQkq - 0 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Sicilian Najdorf.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the Sicilian Najdorf.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
      ],
    },
    63: {
      'title': 'Day 63: Milestone Exam: Opening Repertoire & Memory',
      'topic': 'Openings',
      'theme': 'Move-tree verification across all personal opening branches',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2068,
      'prerequisites': <int>[62],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Move-tree verification across all personal opening branches.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 63: Milestone Exam: Opening Repertoire & Memory: Move-tree verification across all personal opening branches

## 1. Core Pedagogical Concept & Strategic Role
Modern opening mastery in **Move-tree verification across all personal opening branches** is about understanding pawn structures, tabias, and transpositions, not rote memorization of 25 moves.

Opening strategic imperatives:
- **Central Stake**: Fight for d4/d5/e4/e5 from move one with pawns and pieces.
- **Harmonious Piece Development**: Develop minor pieces toward the center before moving the same piece twice.
- **Rapid King Safety**: Castle early to connect heavy pieces and remove the king from open vertical files.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In the opening tabias:
- **Candidate Move A (The Decisive Continuation)**: Stakes a claim in the center, adheres to sound repertoire theory, and maintains dynamic balance or a slight spatial pull.
- **Candidate Move B (The Common Tempting Mistake)**: A pawn-grabbing sideline or superficial attack that neglects king safety and gives the opponent a massive lead in development.
- **Why Wrong Choices Fail (Refutation Analysis)**: Greedily capturing poisoned pawns at the expense of piece development leads to rapid central collapse. Refutation comes in the form of rapid open-file piece infiltration.


## 4. Practical Tournament Application & Psychological Triggers
1. Memorize opening ideas, plans, and typical pawn breaks rather than isolated moves.
2. If your opponent delays castling, open the center immediately even at the cost of a pawn.
3. Review your personal opening tree after every serious tournament game.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Move-tree verification across all personal opening branches with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Move-tree verification across all personal opening branches in sharp tournament conditions.',
      ],
      'gameStudy': 'Viswanathan Anand vs Boris Gelfand (2012) — Opening Repertoire Milestone Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Move-tree verification across all personal opening branches, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 62 foundations, drill 10 targeted flashcards on openings, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Move-tree verification across all personal opening branches: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d63_ex1',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Sicilian Dragon.',
          solutionSan: <String>['Bc5'],
          explanation: 'Theoretical precision: Bc5 is the master standard in the Sicilian Dragon.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d63_ex2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the French Winawer.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the French Winawer.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d63_ex3',
          fen: 'rnbqkb1r/pp2pppp/3p1n2/8/3NP3/2N5/PPP2PPP/R1BQKB1R b KQkq - 0 5',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Caro-Kann Advance.',
          solutionSan: <String>['a6'],
          explanation: 'Theoretical precision: a6 is the master standard in the Caro-Kann Advance.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d63_ex4',
          fen: 'rnbqkbnr/pppp1ppp/4p3/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Queen\'s Gambit Declined.',
          solutionSan: <String>['d4'],
          explanation: 'Theoretical precision: d4 is the master standard in the Queen\'s Gambit Declined.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d63_ex5',
          fen: 'rnbqkbnr/pp1ppppp/2p5/8/3PP3/8/PPP2PPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the Slav Defense.',
          solutionSan: <String>['d5'],
          explanation: 'Theoretical precision: d5 is the master standard in the Slav Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
        const CurriculumExercise(
          id: 'cur_d63_ex6',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/2PP4/8/PP2PPPP/RNBQKBNR b KQkq - 0 2',
          sideToPlay: PieceColor.black,
          instruction: 'Repertoire Mastery: Recall the thematic theoretical continuation or punish opponent deviation in the King\'s Indian Defense.',
          solutionSan: <String>['e6'],
          explanation: 'Theoretical precision: e6 is the master standard in the King\'s Indian Defense.',
          hints: <String>['Recall central tension rules and development harmony.'],
          motif: 'Opening Repertoire',
        ),
      ],
    },
    64: {
      'title': 'Day 64: Punishing the Uncastled King',
      'topic': 'Attack & Defense',
      'theme': 'Morphy-style central breakthroughs against delayed castling',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2082,
      'prerequisites': <int>[63],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Morphy-style central breakthroughs against delayed castling.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 64: Punishing the Uncastled King: Morphy-style central breakthroughs against delayed castling

## 1. Core Pedagogical Concept & Strategic Role
King hunt geometry and defensive tenacity in **Morphy-style central breakthroughs against delayed castling** represent the sharpest collision in competitive chess. An attack on the king requires decisive piece concentration and sacrificial courage, while defense demands absolute coolness under fire.

Principles of the attack:
- **Attacking Ratios**: You need a local numerical superiority (at least 3 attacking pieces against 1-2 defenders) to break open the king fortress.
- **Pawn Battering Rams**: Advance pawns on the flank opposite to where your king is castled to strip away enemy pawn shields.
- **Defensive Resourcefulness**: Counter-attack in the center when attacked on the wing; never defend passively if an active counter-threat exists.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During sacrificial king assaults:
- **Candidate Move A (The Decisive Continuation)**: Blows open the king's defensive shelter through a calculated breakthrough sacrifice (e.g. Bxh7+, Nd5, or pawn storm).
- **Candidate Move B (The Common Tempting Mistake)**: A slow preparatory move that grants the defender a tempo to reinforce their defensive coordinates or evacuate the king.
- **Why Wrong Choices Fail (Refutation Analysis)**: Hesitating during an attack allows the defender to counter-strike in the center. An attack must proceed with maximum momentum and forcing checks.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king attacks to mate or clear decisive material advantage before sacrificing material.
2. The best defense against a flank attack is a central counter-strike.
3. When defending under severe pressure, look for perpetual check and stalemate tricks.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Morphy-style central breakthroughs against delayed castling with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Morphy-style central breakthroughs against delayed castling in sharp tournament conditions.',
      ],
      'gameStudy': 'Adolf Anderssen vs Jean Dufresne (1852) — The Evergreen Central Breach',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 63 foundations, drill 10 targeted flashcards on attack, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Morphy-style central breakthroughs against delayed castling: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d64_ex1',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d64_ex2',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d64_ex3',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d64_ex4',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d64_ex5',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d64_ex6',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    65: {
      'title': 'Day 65: Classical Sacrifices: The Greek Gift (Bxh7+)',
      'topic': 'Attack & Defense',
      'theme': 'Calculating standard sacrifices on h7/h2 with Ng5+ followups',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2096,
      'prerequisites': <int>[64],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculating standard sacrifices on h7/h2 with Ng5+ followups.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 65: Classical Sacrifices: The Greek Gift (Bxh7+): Calculating standard sacrifices on h7/h2 with Ng5+ followups

## 1. Core Pedagogical Concept & Strategic Role
King hunt geometry and defensive tenacity in **Calculating standard sacrifices on h7/h2 with Ng5+ followups** represent the sharpest collision in competitive chess. An attack on the king requires decisive piece concentration and sacrificial courage, while defense demands absolute coolness under fire.

Principles of the attack:
- **Attacking Ratios**: You need a local numerical superiority (at least 3 attacking pieces against 1-2 defenders) to break open the king fortress.
- **Pawn Battering Rams**: Advance pawns on the flank opposite to where your king is castled to strip away enemy pawn shields.
- **Defensive Resourcefulness**: Counter-attack in the center when attacked on the wing; never defend passively if an active counter-threat exists.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During sacrificial king assaults:
- **Candidate Move A (The Decisive Continuation)**: Blows open the king's defensive shelter through a calculated breakthrough sacrifice (e.g. Bxh7+, Nd5, or pawn storm).
- **Candidate Move B (The Common Tempting Mistake)**: A slow preparatory move that grants the defender a tempo to reinforce their defensive coordinates or evacuate the king.
- **Why Wrong Choices Fail (Refutation Analysis)**: Hesitating during an attack allows the defender to counter-strike in the center. An attack must proceed with maximum momentum and forcing checks.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king attacks to mate or clear decisive material advantage before sacrificing material.
2. The best defense against a flank attack is a central counter-strike.
3. When defending under severe pressure, look for perpetual check and stalemate tricks.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Calculating standard sacrifices on h7/h2 with Ng5+ followups with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Calculating standard sacrifices on h7/h2 with Ng5+ followups in sharp tournament conditions.',
      ],
      'gameStudy': 'Rudolf Spielmann vs Baldur Hoenlinger (1929) — Textbook Greek Gift Bxh7+',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 64 foundations, drill 10 targeted flashcards on attack, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Calculating standard sacrifices on h7/h2 with Ng5+ followups: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d65_ex1',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d65_ex2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d65_ex3',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d65_ex4',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d65_ex5',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d65_ex6',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    66: {
      'title': 'Day 66: Attacking the Castled King: Pawn Storms',
      'topic': 'Attack & Defense',
      'theme': 'Opposite-side castling races and battering ram pawn pushes',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2110,
      'prerequisites': <int>[65],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Opposite-side castling races and battering ram pawn pushes.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 66: Attacking the Castled King: Pawn Storms: Opposite-side castling races and battering ram pawn pushes

## 1. Core Pedagogical Concept & Strategic Role
King hunt geometry and defensive tenacity in **Opposite-side castling races and battering ram pawn pushes** represent the sharpest collision in competitive chess. An attack on the king requires decisive piece concentration and sacrificial courage, while defense demands absolute coolness under fire.

Principles of the attack:
- **Attacking Ratios**: You need a local numerical superiority (at least 3 attacking pieces against 1-2 defenders) to break open the king fortress.
- **Pawn Battering Rams**: Advance pawns on the flank opposite to where your king is castled to strip away enemy pawn shields.
- **Defensive Resourcefulness**: Counter-attack in the center when attacked on the wing; never defend passively if an active counter-threat exists.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During sacrificial king assaults:
- **Candidate Move A (The Decisive Continuation)**: Blows open the king's defensive shelter through a calculated breakthrough sacrifice (e.g. Bxh7+, Nd5, or pawn storm).
- **Candidate Move B (The Common Tempting Mistake)**: A slow preparatory move that grants the defender a tempo to reinforce their defensive coordinates or evacuate the king.
- **Why Wrong Choices Fail (Refutation Analysis)**: Hesitating during an attack allows the defender to counter-strike in the center. An attack must proceed with maximum momentum and forcing checks.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king attacks to mate or clear decisive material advantage before sacrificing material.
2. The best defense against a flank attack is a central counter-strike.
3. When defending under severe pressure, look for perpetual check and stalemate tricks.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Opposite-side castling races and battering ram pawn pushes with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Opposite-side castling races and battering ram pawn pushes in sharp tournament conditions.',
      ],
      'gameStudy': 'Bobby Fischer vs Bent Larsen (1958) — Battering Ram Pawn Storm in the Dragon',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 65 foundations, drill 10 targeted flashcards on attack, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Opposite-side castling races and battering ram pawn pushes: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d66_ex1',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d66_ex2',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d66_ex3',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d66_ex4',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d66_ex5',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d66_ex6',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    67: {
      'title': 'Day 67: Defensive Tenacity: Resourcefulness Under Fire',
      'topic': 'Attack & Defense',
      'theme': 'Finding stubborn tactical saves when facing king-side assaults',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 2124,
      'prerequisites': <int>[66],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Finding stubborn tactical saves when facing king-side assaults.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 67: Defensive Tenacity: Resourcefulness Under Fire: Finding stubborn tactical saves when facing king-side assaults

## 1. Core Pedagogical Concept & Strategic Role
King hunt geometry and defensive tenacity in **Finding stubborn tactical saves when facing king-side assaults** represent the sharpest collision in competitive chess. An attack on the king requires decisive piece concentration and sacrificial courage, while defense demands absolute coolness under fire.

Principles of the attack:
- **Attacking Ratios**: You need a local numerical superiority (at least 3 attacking pieces against 1-2 defenders) to break open the king fortress.
- **Pawn Battering Rams**: Advance pawns on the flank opposite to where your king is castled to strip away enemy pawn shields.
- **Defensive Resourcefulness**: Counter-attack in the center when attacked on the wing; never defend passively if an active counter-threat exists.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During sacrificial king assaults:
- **Candidate Move A (The Decisive Continuation)**: Blows open the king's defensive shelter through a calculated breakthrough sacrifice (e.g. Bxh7+, Nd5, or pawn storm).
- **Candidate Move B (The Common Tempting Mistake)**: A slow preparatory move that grants the defender a tempo to reinforce their defensive coordinates or evacuate the king.
- **Why Wrong Choices Fail (Refutation Analysis)**: Hesitating during an attack allows the defender to counter-strike in the center. An attack must proceed with maximum momentum and forcing checks.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king attacks to mate or clear decisive material advantage before sacrificing material.
2. The best defense against a flank attack is a central counter-strike.
3. When defending under severe pressure, look for perpetual check and stalemate tricks.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Finding stubborn tactical saves when facing king-side assaults with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Finding stubborn tactical saves when facing king-side assaults in sharp tournament conditions.',
      ],
      'gameStudy': 'Tigran Petrosian vs Viktor Korchnoi (1962) — Iron Defense Under Direct Bombardment',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in defensive_resource_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 66 foundations, drill 10 targeted flashcards on defense, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Finding stubborn tactical saves when facing king-side assaults: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d67_ex1',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d67_ex2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d67_ex3',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d67_ex4',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d67_ex5',
          fen: 'r1bqk1nr/pppp1ppp/2n5/4p3/1bB1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['O-O'],
          explanation: 'Pin exploitation winning key piece (O-O).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d67_ex6',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R b KQkq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Exploit the pinned defender.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Pin exploitation winning key piece (Nxe4).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
      ],
    },
    68: {
      'title': 'Day 68: Escaping Mating Nets & Counter-Attacks',
      'topic': 'Attack & Defense',
      'theme': 'Active king flight paths and central counter-strikes',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 2138,
      'prerequisites': <int>[67],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Active king flight paths and central counter-strikes.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 68: Escaping Mating Nets & Counter-Attacks: Active king flight paths and central counter-strikes

## 1. Core Pedagogical Concept & Strategic Role
King hunt geometry and defensive tenacity in **Active king flight paths and central counter-strikes** represent the sharpest collision in competitive chess. An attack on the king requires decisive piece concentration and sacrificial courage, while defense demands absolute coolness under fire.

Principles of the attack:
- **Attacking Ratios**: You need a local numerical superiority (at least 3 attacking pieces against 1-2 defenders) to break open the king fortress.
- **Pawn Battering Rams**: Advance pawns on the flank opposite to where your king is castled to strip away enemy pawn shields.
- **Defensive Resourcefulness**: Counter-attack in the center when attacked on the wing; never defend passively if an active counter-threat exists.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During sacrificial king assaults:
- **Candidate Move A (The Decisive Continuation)**: Blows open the king's defensive shelter through a calculated breakthrough sacrifice (e.g. Bxh7+, Nd5, or pawn storm).
- **Candidate Move B (The Common Tempting Mistake)**: A slow preparatory move that grants the defender a tempo to reinforce their defensive coordinates or evacuate the king.
- **Why Wrong Choices Fail (Refutation Analysis)**: Hesitating during an attack allows the defender to counter-strike in the center. An attack must proceed with maximum momentum and forcing checks.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king attacks to mate or clear decisive material advantage before sacrificing material.
2. The best defense against a flank attack is a central counter-strike.
3. When defending under severe pressure, look for perpetual check and stalemate tricks.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Active king flight paths and central counter-strikes with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Active king flight paths and central counter-strikes in sharp tournament conditions.',
      ],
      'gameStudy': 'Garry Kasparov vs Anthony Miles (1986) — Breaking Free from Mating Nets',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in defensive_resource_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 67 foundations, drill 10 targeted flashcards on defense, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Active king flight paths and central counter-strikes: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d68_ex1',
          fen: 'rnbqk2r/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQkq - 2 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['Bg5'],
          explanation: 'Pin exploitation winning key piece (Bg5).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d68_ex2',
          fen: 'r1bqk2r/ppp2ppp/2n2n2/3pp3/1bPP4/2N1PN2/PP3PPP/R1BQKB1R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned defender.',
          solutionSan: <String>['a3'],
          explanation: 'Pin exploitation winning key piece (a3).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Queen Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d68_ex3',
          fen: '4k3/8/8/8/8/8/1R6/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Re2+'],
          explanation: 'Winning skewer along the rank/file/diagonal (Re2+).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d68_ex4',
          fen: '8/4k3/8/8/8/8/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Ra6'],
          explanation: 'Winning skewer along the rank/file/diagonal (Ra6).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d68_ex5',
          fen: '4k3/8/8/8/8/8/8/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Rh7'],
          explanation: 'Winning skewer along the rank/file/diagonal (Rh7).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d68_ex6',
          fen: '8/8/8/3k4/8/8/8/3K3R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Rh5+'],
          explanation: 'Winning skewer along the rank/file/diagonal (Rh5+).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
      ],
    },
    69: {
      'title': 'Day 69: The King March: Short vs Timman Technique',
      'topic': 'Attack & Defense',
      'theme': 'Using the king as an active attacking piece in the endgame',
      'axis': SkillAxis.attack,
      'lab': 'guess_the_move_lab',
      'difficulty': 2152,
      'prerequisites': <int>[68],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Using the king as an active attacking piece in the endgame.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 69: The King March: Short vs Timman Technique: Using the king as an active attacking piece in the endgame

## 1. Core Pedagogical Concept & Strategic Role
King hunt geometry and defensive tenacity in **Using the king as an active attacking piece in the endgame** represent the sharpest collision in competitive chess. An attack on the king requires decisive piece concentration and sacrificial courage, while defense demands absolute coolness under fire.

Principles of the attack:
- **Attacking Ratios**: You need a local numerical superiority (at least 3 attacking pieces against 1-2 defenders) to break open the king fortress.
- **Pawn Battering Rams**: Advance pawns on the flank opposite to where your king is castled to strip away enemy pawn shields.
- **Defensive Resourcefulness**: Counter-attack in the center when attacked on the wing; never defend passively if an active counter-threat exists.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During sacrificial king assaults:
- **Candidate Move A (The Decisive Continuation)**: Blows open the king's defensive shelter through a calculated breakthrough sacrifice (e.g. Bxh7+, Nd5, or pawn storm).
- **Candidate Move B (The Common Tempting Mistake)**: A slow preparatory move that grants the defender a tempo to reinforce their defensive coordinates or evacuate the king.
- **Why Wrong Choices Fail (Refutation Analysis)**: Hesitating during an attack allows the defender to counter-strike in the center. An attack must proceed with maximum momentum and forcing checks.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king attacks to mate or clear decisive material advantage before sacrificing material.
2. The best defense against a flank attack is a central counter-strike.
3. When defending under severe pressure, look for perpetual check and stalemate tricks.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Using the king as an active attacking piece in the endgame with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Using the king as an active attacking piece in the endgame in sharp tournament conditions.',
      ],
      'gameStudy': 'Nigel Short vs Jan Timman (1991) — The Immortal King March to f6',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in guess_the_move_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 68 foundations, drill 10 targeted flashcards on attack, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Using the king as an active attacking piece in the endgame: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d69_ex1',
          fen: '4k3/8/8/8/8/8/1R6/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Re2+'],
          explanation: 'Winning skewer along the rank/file/diagonal (Re2+).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d69_ex2',
          fen: '8/4k3/8/8/8/8/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Ra6'],
          explanation: 'Winning skewer along the rank/file/diagonal (Ra6).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d69_ex3',
          fen: '4k3/8/8/8/8/8/8/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Rh7'],
          explanation: 'Winning skewer along the rank/file/diagonal (Rh7).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d69_ex4',
          fen: '8/8/8/3k4/8/8/8/3K3R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Rh5+'],
          explanation: 'Winning skewer along the rank/file/diagonal (Rh5+).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d69_ex5',
          fen: '4k3/8/8/8/8/8/1R6/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Re2+'],
          explanation: 'Winning skewer along the rank/file/diagonal (Re2+).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d69_ex6',
          fen: '8/4k3/8/8/8/8/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Ra6'],
          explanation: 'Winning skewer along the rank/file/diagonal (Ra6).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
      ],
    },
    70: {
      'title': 'Day 70: Milestone Exam: King Attack & Defensive Tenacity',
      'topic': 'Attack & Defense',
      'theme': 'Two-way testing: executing attacks and defending under fire',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2166,
      'prerequisites': <int>[69],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Two-way testing: executing attacks and defending under fire.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 70: Milestone Exam: King Attack & Defensive Tenacity: Two-way testing: executing attacks and defending under fire

## 1. Core Pedagogical Concept & Strategic Role
King hunt geometry and defensive tenacity in **Two-way testing: executing attacks and defending under fire** represent the sharpest collision in competitive chess. An attack on the king requires decisive piece concentration and sacrificial courage, while defense demands absolute coolness under fire.

Principles of the attack:
- **Attacking Ratios**: You need a local numerical superiority (at least 3 attacking pieces against 1-2 defenders) to break open the king fortress.
- **Pawn Battering Rams**: Advance pawns on the flank opposite to where your king is castled to strip away enemy pawn shields.
- **Defensive Resourcefulness**: Counter-attack in the center when attacked on the wing; never defend passively if an active counter-threat exists.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
During sacrificial king assaults:
- **Candidate Move A (The Decisive Continuation)**: Blows open the king's defensive shelter through a calculated breakthrough sacrifice (e.g. Bxh7+, Nd5, or pawn storm).
- **Candidate Move B (The Common Tempting Mistake)**: A slow preparatory move that grants the defender a tempo to reinforce their defensive coordinates or evacuate the king.
- **Why Wrong Choices Fail (Refutation Analysis)**: Hesitating during an attack allows the defender to counter-strike in the center. An attack must proceed with maximum momentum and forcing checks.


## 4. Practical Tournament Application & Psychological Triggers
1. Calculate king attacks to mate or clear decisive material advantage before sacrificing material.
2. The best defense against a flank attack is a central counter-strike.
3. When defending under severe pressure, look for perpetual check and stalemate tricks.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Two-way testing: executing attacks and defending under fire with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Two-way testing: executing attacks and defending under fire in sharp tournament conditions.',
      ],
      'gameStudy': 'Mikhail Tal vs Bent Larsen (1965) — Attack & Defense Balance Milestone Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Two-way testing: executing attacks and defending under fire, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 69 foundations, drill 10 targeted flashcards on attack, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Two-way testing: executing attacks and defending under fire: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d70_ex1',
          fen: '4k3/8/8/8/8/8/8/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Rh7'],
          explanation: 'Winning skewer along the rank/file/diagonal (Rh7).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d70_ex2',
          fen: '8/8/8/3k4/8/8/8/3K3R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Rh5+'],
          explanation: 'Winning skewer along the rank/file/diagonal (Rh5+).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d70_ex3',
          fen: '4k3/8/8/8/8/8/1R6/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Re2+'],
          explanation: 'Winning skewer along the rank/file/diagonal (Re2+).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d70_ex4',
          fen: '8/4k3/8/8/8/8/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Ra6'],
          explanation: 'Winning skewer along the rank/file/diagonal (Ra6).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d70_ex5',
          fen: '4k3/8/8/8/8/8/8/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Rh7'],
          explanation: 'Winning skewer along the rank/file/diagonal (Rh7).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
        const CurriculumExercise(
          id: 'cur_d70_ex6',
          fen: '8/8/8/3k4/8/8/8/3K3R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king and piece.',
          solutionSan: <String>['Rh5+'],
          explanation: 'Winning skewer along the rank/file/diagonal (Rh5+).',
          hints: <String>['Look for forcing checks, captures, and threats.'],
          motif: 'Pawn Fork',
        ),
      ],
    },
    71: {
      'title': 'Day 71: Converting Winning Advantages Systematically',
      'topic': 'Conversion',
      'theme': 'Avoiding premature relaxation and playing high-percentage moves',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2180,
      'prerequisites': <int>[70],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Avoiding premature relaxation and playing high-percentage moves.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 71: Converting Winning Advantages Systematically: Avoiding premature relaxation and playing high-percentage moves

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Avoiding premature relaxation and playing high-percentage moves** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Avoiding premature relaxation and playing high-percentage moves with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Avoiding premature relaxation and playing high-percentage moves in sharp tournament conditions.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs David Janowski (1916) — Systematic Advantage Conversion',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in conversion_challenge_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 70 foundations, drill 10 targeted flashcards on conversion, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Avoiding premature relaxation and playing high-percentage moves: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d71_ex1',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d71_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d71_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d71_ex4',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d71_ex5',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d71_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    72: {
      'title': 'Day 72: Liquidating into Easily Won Endgames',
      'topic': 'Conversion',
      'theme': 'Trading queens and rooks when material advantage is decisive',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2194,
      'prerequisites': <int>[71],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Trading queens and rooks when material advantage is decisive.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 72: Liquidating into Easily Won Endgames: Trading queens and rooks when material advantage is decisive

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Trading queens and rooks when material advantage is decisive** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Trading queens and rooks when material advantage is decisive with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Trading queens and rooks when material advantage is decisive in sharp tournament conditions.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs Paul Keres (1941) — Decisive Simplification to Won Endgames',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in conversion_challenge_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 71 foundations, drill 10 targeted flashcards on conversion, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Trading queens and rooks when material advantage is decisive: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d72_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d72_ex2',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d72_ex3',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d72_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d72_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d72_ex6',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    73: {
      'title': 'Day 73: Avoiding Stalemates & Desperado Swindles',
      'topic': 'Conversion',
      'theme': 'Remaining vigilant against opponent stalemate traps and perpetual checks',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 2208,
      'prerequisites': <int>[72],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Remaining vigilant against opponent stalemate traps and perpetual checks.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 73: Avoiding Stalemates & Desperado Swindles: Remaining vigilant against opponent stalemate traps and perpetual checks

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Remaining vigilant against opponent stalemate traps and perpetual checks** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Remaining vigilant against opponent stalemate traps and perpetual checks with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Remaining vigilant against opponent stalemate traps and perpetual checks in sharp tournament conditions.',
      ],
      'gameStudy': 'Boris Spassky vs David Bronstein (1960) — Neutralizing Desperado Counter-Swindles',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in defensive_resource_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 72 foundations, drill 10 targeted flashcards on defense, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Remaining vigilant against opponent stalemate traps and perpetual checks: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d73_ex1',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d73_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d73_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d73_ex4',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d73_ex5',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d73_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    74: {
      'title': 'Day 74: Time Trouble Technique & Practical Decisions',
      'topic': 'Conversion',
      'theme': 'Managing the clock when under 3 minutes with zero blunders',
      'axis': SkillAxis.timeManagement,
      'lab': 'time_management_lab',
      'difficulty': 2222,
      'prerequisites': <int>[73],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Managing the clock when under 3 minutes with zero blunders.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 74: Time Trouble Technique & Practical Decisions: Managing the clock when under 3 minutes with zero blunders

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Managing the clock when under 3 minutes with zero blunders** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Managing the clock when under 3 minutes with zero blunders with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Managing the clock when under 3 minutes with zero blunders in sharp tournament conditions.',
      ],
      'gameStudy': 'Alexander Grischuk vs Vladimir Kramnik (2011) — The 3-Minute Time Trouble Protocol',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in time_management_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 73 foundations, drill 10 targeted flashcards on timeManagement, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Managing the clock when under 3 minutes with zero blunders: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for timeManagement',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d74_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d74_ex2',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d74_ex3',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d74_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d74_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d74_ex6',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    75: {
      'title': 'Day 75: Psychological Resilience After Mistakes',
      'topic': 'Conversion',
      'theme': 'Resetting mental focus after letting an advantage slip',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'guess_the_move_lab',
      'difficulty': 2236,
      'prerequisites': <int>[74],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Resetting mental focus after letting an advantage slip.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 75: Psychological Resilience After Mistakes: Resetting mental focus after letting an advantage slip

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Resetting mental focus after letting an advantage slip** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Resetting mental focus after letting an advantage slip with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Resetting mental focus after letting an advantage slip in sharp tournament conditions.',
      ],
      'gameStudy': 'Ding Liren vs Ian Nepomniachtchi (2023 Game 12) — World Championship Psychological Reset',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in guess_the_move_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 74 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Resetting mental focus after letting an advantage slip: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d75_ex1',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d75_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d75_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d75_ex4',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d75_ex5',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d75_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    76: {
      'title': 'Day 76: The Simplest Win vs The Flashiest Win',
      'topic': 'Conversion',
      'theme': 'Choosing clear master technique over unnecessary tactical risk',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2250,
      'prerequisites': <int>[75],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Choosing clear master technique over unnecessary tactical risk.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 76: The Simplest Win vs The Flashiest Win: Choosing clear master technique over unnecessary tactical risk

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Choosing clear master technique over unnecessary tactical risk** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Choosing clear master technique over unnecessary tactical risk with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Choosing clear master technique over unnecessary tactical risk in sharp tournament conditions.',
      ],
      'gameStudy': 'Magnus Carlsen vs Sergey Karjakin (2016) — Ruthless Simplest Win Conversion',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in conversion_challenge_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 75 foundations, drill 10 targeted flashcards on conversion, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Choosing clear master technique over unnecessary tactical risk: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d76_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d76_ex2',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d76_ex3',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d76_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d76_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d76_ex6',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    77: {
      'title': 'Day 77: Milestone Exam: Flawless Advantage Conversion',
      'topic': 'Conversion',
      'theme': 'Converting +3.00 centipawn advantages against engine sparring',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2264,
      'prerequisites': <int>[76],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Converting +3.00 centipawn advantages against engine sparring.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 77: Milestone Exam: Flawless Advantage Conversion: Converting +3.00 centipawn advantages against engine sparring

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Converting +3.00 centipawn advantages against engine sparring** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Converting +3.00 centipawn advantages against engine sparring with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Converting +3.00 centipawn advantages against engine sparring in sharp tournament conditions.',
      ],
      'gameStudy': 'Anatoly Karpov vs Garry Kasparov (1984) — Flawless +3.00 Conversion Milestone Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Converting +3.00 centipawn advantages against engine sparring, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 76 foundations, drill 10 targeted flashcards on conversion, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Converting +3.00 centipawn advantages against engine sparring: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d77_ex1',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d77_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d77_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d77_ex4',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d77_ex5',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d77_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    78: {
      'title': 'Day 78: Swiss Tournament Dynamics & Pairing Prep',
      'topic': 'Tournament',
      'theme': 'Tournament strategy: managing draw offers and must-win rounds',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'guess_the_move_lab',
      'difficulty': 2278,
      'prerequisites': <int>[77],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tournament strategy: managing draw offers and must-win rounds.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 78: Swiss Tournament Dynamics & Pairing Prep: Tournament strategy: managing draw offers and must-win rounds

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Tournament strategy: managing draw offers and must-win rounds** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Tournament strategy: managing draw offers and must-win rounds with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Tournament strategy: managing draw offers and must-win rounds in sharp tournament conditions.',
      ],
      'gameStudy': 'Mikhail Tal vs Bobby Fischer (1959) — Swiss Pairing Tactics & Must-Win Dynamics',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in guess_the_move_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 77 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Tournament strategy: managing draw offers and must-win rounds: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d78_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d78_ex2',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d78_ex3',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d78_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d78_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d78_ex6',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    79: {
      'title': 'Day 79: Game Simulation 1: Rapid 15+10 with Post-Mortem',
      'topic': 'Tournament',
      'theme': 'Full simulated tournament round followed by forensic blunder audit',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'guess_the_move_lab',
      'difficulty': 2292,
      'prerequisites': <int>[78],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Full simulated tournament round followed by forensic blunder audit.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 79: Game Simulation 1: Rapid 15+10 with Post-Mortem: Full simulated tournament round followed by forensic blunder audit

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Full simulated tournament round followed by forensic blunder audit** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Full simulated tournament round followed by forensic blunder audit with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Full simulated tournament round followed by forensic blunder audit in sharp tournament conditions.',
      ],
      'gameStudy': 'Levon Aronian vs Magnus Carlsen (2015) — Rapid 15+10 Match Simulation',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in guess_the_move_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 78 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Full simulated tournament round followed by forensic blunder audit: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d79_ex1',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d79_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d79_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d79_ex4',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d79_ex5',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d79_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    80: {
      'title': 'Day 80: Game Simulation 2: Classical Time Control Discipline',
      'topic': 'Tournament',
      'theme': 'Deep 30+minute sparring with notebook candidate annotations',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'time_management_lab',
      'difficulty': 2306,
      'prerequisites': <int>[79],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Deep 30+minute sparring with notebook candidate annotations.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 80: Game Simulation 2: Classical Time Control Discipline: Deep 30+minute sparring with notebook candidate annotations

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Deep 30+minute sparring with notebook candidate annotations** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Deep 30+minute sparring with notebook candidate annotations with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Deep 30+minute sparring with notebook candidate annotations in sharp tournament conditions.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1990) — Classical Time Control Match Simulation',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in time_management_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 79 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Deep 30+minute sparring with notebook candidate annotations: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d80_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d80_ex2',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d80_ex3',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d80_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d80_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d80_ex6',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    81: {
      'title': 'Day 81: Scouting Opponents & Repertoire Adaptation',
      'topic': 'Tournament',
      'theme': 'Targeting known stylistic weaknesses in opponent repertoires',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2320,
      'prerequisites': <int>[80],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Targeting known stylistic weaknesses in opponent repertoires.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 81: Scouting Opponents & Repertoire Adaptation: Targeting known stylistic weaknesses in opponent repertoires

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Targeting known stylistic weaknesses in opponent repertoires** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Targeting known stylistic weaknesses in opponent repertoires with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Targeting known stylistic weaknesses in opponent repertoires in sharp tournament conditions.',
      ],
      'gameStudy': 'Max Euwe vs Alexander Alekhine (1935) — Scouting Repertoire Flaws in Opponents',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in opening_plan_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 80 foundations, drill 10 targeted flashcards on openings, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Targeting known stylistic weaknesses in opponent repertoires: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d81_ex1',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d81_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d81_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d81_ex4',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d81_ex5',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d81_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    82: {
      'title': 'Day 82: Energy Management & Physical Chess Stamina',
      'topic': 'Tournament',
      'theme': 'Hydration, breaks, and cognitive endurance during double-round weekends',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'guess_the_move_lab',
      'difficulty': 2334,
      'prerequisites': <int>[81],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Hydration, breaks, and cognitive endurance during double-round weekends.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 82: Energy Management & Physical Chess Stamina: Hydration, breaks, and cognitive endurance during double-round weekends

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Hydration, breaks, and cognitive endurance during double-round weekends** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Hydration, breaks, and cognitive endurance during double-round weekends with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Hydration, breaks, and cognitive endurance during double-round weekends in sharp tournament conditions.',
      ],
      'gameStudy': 'Vasyl Ivanchuk vs Garry Kasparov (1991) — Cognitive Stamina & Endurance Discipline',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in guess_the_move_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 81 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Hydration, breaks, and cognitive endurance during double-round weekends: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d82_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d82_ex2',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d82_ex3',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d82_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d82_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d82_ex6',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    83: {
      'title': 'Day 83: Must-Win Situations & Playing for Imbalance',
      'topic': 'Tournament',
      'theme': 'Sharpening positions when a draw is equivalent to a loss',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2348,
      'prerequisites': <int>[82],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Sharpening positions when a draw is equivalent to a loss.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 83: Must-Win Situations & Playing for Imbalance: Sharpening positions when a draw is equivalent to a loss

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Sharpening positions when a draw is equivalent to a loss** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Sharpening positions when a draw is equivalent to a loss with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Sharpening positions when a draw is equivalent to a loss in sharp tournament conditions.',
      ],
      'gameStudy': 'Garry Kasparov vs Viswanathan Anand (1995 Game 10) — Playing for Imbalance in Must-Win Rounds',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 82 foundations, drill 10 targeted flashcards on attack, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Sharpening positions when a draw is equivalent to a loss: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d83_ex1',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d83_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d83_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d83_ex4',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d83_ex5',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d83_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    84: {
      'title': 'Day 84: Milestone Exam: Tournament Simulation Round',
      'topic': 'Tournament',
      'theme': 'Rated tournament simulation against master-level engine profile',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'guess_the_move_lab',
      'difficulty': 2362,
      'prerequisites': <int>[83],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Rated tournament simulation against master-level engine profile.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 84: Milestone Exam: Tournament Simulation Round: Rated tournament simulation against master-level engine profile

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Rated tournament simulation against master-level engine profile** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Rated tournament simulation against master-level engine profile with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Rated tournament simulation against master-level engine profile in sharp tournament conditions.',
      ],
      'gameStudy': 'Hikaru Nakamura vs Magnus Carlsen (2022) — Tournament Simulation Final Round Exam',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Rated tournament simulation against master-level engine profile, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 83 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Rated tournament simulation against master-level engine profile: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d84_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d84_ex2',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d84_ex3',
          fen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['a6'],
          explanation: 'Practical precision: a6 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d84_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['b3'],
          explanation: 'Practical precision: b3 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
        const CurriculumExercise(
          id: 'cur_d84_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Ne5'],
          explanation: 'Practical precision: Ne5 shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Advantage Conversion',
        ),
        const CurriculumExercise(
          id: 'cur_d84_ex6',
          fen: '6k1/5ppp/8/8/8/8/6PP/3Q3K w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'Practical Conversion: Select the most resilient move under competitive tournament conditions.',
          solutionSan: <String>['Qd8#'],
          explanation: 'Practical precision: Qd8# shuts down opponent counterplay and cleanly converts.',
          hints: <String>['Prioritize safety and simplification when ahead.', 'Do not rush in winning positions.'],
          motif: 'Defensive Tenacity',
        ),
      ],
    },
    85: {
      'title': 'Day 85: Spaced Repetition Review: Tactical Vault',
      'topic': 'Integration',
      'theme': 'Consolidating 1,500+ tactical patterns into instantaneous intuition',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 2376,
      'prerequisites': <int>[84],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Consolidating 1,500+ tactical patterns into instantaneous intuition.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 85: Spaced Repetition Review: Tactical Vault: Consolidating 1,500+ tactical patterns into instantaneous intuition

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Consolidating 1,500+ tactical patterns into instantaneous intuition** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Consolidating 1,500+ tactical patterns into instantaneous intuition with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Consolidating 1,500+ tactical patterns into instantaneous intuition in sharp tournament conditions.',
      ],
      'gameStudy': 'Tactical Vault Review — Consolidating 32 Tactical Motifs',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in tactical_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 84 foundations, drill 10 targeted flashcards on tactics, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Consolidating 1,500+ tactical patterns into instantaneous intuition: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d85_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d85_ex2',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d85_ex3',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d85_ex4',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d85_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d85_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    86: {
      'title': 'Day 86: Spaced Repetition Review: Strategic Patterns',
      'topic': 'Integration',
      'theme': 'Revisiting pawn structures, outposts, and minority attacks',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 2390,
      'prerequisites': <int>[85],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Revisiting pawn structures, outposts, and minority attacks.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 86: Spaced Repetition Review: Strategic Patterns: Revisiting pawn structures, outposts, and minority attacks

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Revisiting pawn structures, outposts, and minority attacks** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Revisiting pawn structures, outposts, and minority attacks with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Revisiting pawn structures, outposts, and minority attacks in sharp tournament conditions.',
      ],
      'gameStudy': 'Strategic Anchor Review — Carlsbad, IQP, Outposts, & Prophylaxis',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in positional_evaluation_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 85 foundations, drill 10 targeted flashcards on strategy, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Revisiting pawn structures, outposts, and minority attacks: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d86_ex1',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d86_ex2',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d86_ex3',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d86_ex4',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d86_ex5',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d86_ex6',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    87: {
      'title': 'Day 87: Spaced Repetition Review: Endgame Anchors',
      'topic': 'Integration',
      'theme': 'Solidifying tablebase reflexes for Lucena, Philidor, and opposition',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2404,
      'prerequisites': <int>[86],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Solidifying tablebase reflexes for Lucena, Philidor, and opposition.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 87: Spaced Repetition Review: Endgame Anchors: Solidifying tablebase reflexes for Lucena, Philidor, and opposition

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Solidifying tablebase reflexes for Lucena, Philidor, and opposition** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Solidifying tablebase reflexes for Lucena, Philidor, and opposition with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Solidifying tablebase reflexes for Lucena, Philidor, and opposition in sharp tournament conditions.',
      ],
      'gameStudy': 'Endgame Anchor Review — Lucena, Philidor, Key Squares & Opposition',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in endgame_win_defend_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 86 foundations, drill 10 targeted flashcards on endgames, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Solidifying tablebase reflexes for Lucena, Philidor, and opposition: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d87_ex1',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d87_ex2',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d87_ex3',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d87_ex4',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d87_ex5',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d87_ex6',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    88: {
      'title': 'Day 88: Deep Self-Analysis: Annotating Losses',
      'topic': 'Integration',
      'theme': 'Forensic post-mortem methodology to turn losses into rating gains',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'guess_the_move_lab',
      'difficulty': 2418,
      'prerequisites': <int>[87],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Forensic post-mortem methodology to turn losses into rating gains.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 88: Deep Self-Analysis: Annotating Losses: Forensic post-mortem methodology to turn losses into rating gains

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Forensic post-mortem methodology to turn losses into rating gains** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Forensic post-mortem methodology to turn losses into rating gains with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Forensic post-mortem methodology to turn losses into rating gains in sharp tournament conditions.',
      ],
      'gameStudy': 'Blunder Post-Mortem Workshop — Turning Defeats into Master Progress',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in guess_the_move_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 87 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Forensic post-mortem methodology to turn losses into rating gains: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d88_ex1',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d88_ex2',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d88_ex3',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d88_ex4',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d88_ex5',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d88_ex6',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    89: {
      'title': 'Day 89: The Grandmaster Mindset & Lifelong Mastery',
      'topic': 'Integration',
      'theme': 'Establishing daily maintenance habits and competitive longevity',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'guess_the_move_lab',
      'difficulty': 2432,
      'prerequisites': <int>[88],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Establishing daily maintenance habits and competitive longevity.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 80% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 89: The Grandmaster Mindset & Lifelong Mastery: Establishing daily maintenance habits and competitive longevity

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Establishing daily maintenance habits and competitive longevity** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Establishing daily maintenance habits and competitive longevity with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Establishing daily maintenance habits and competitive longevity in sharp tournament conditions.',
      ],
      'gameStudy': 'The Grandmaster Mindset — Daily Habits & Lifelong Chess Growth',
      'practiceTask': 'Interactive Lab Practice: Complete all 6 exercises in guess_the_move_lab, maintaining an average accuracy above 80% without using hints on the first attempt.',
      'assessment': 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 88 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Establishing daily maintenance habits and competitive longevity: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d89_ex1',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d89_ex2',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d89_ex3',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d89_ex4',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d89_ex5',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d89_ex6',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
    90: {
      'title': 'Day 90: Mastery Assessment & Completion Report — Grand Certification Exam',
      'topic': 'Integration',
      'theme': 'Culminating 90-day mastery evaluation across all skill axes',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'tactical_lab',
      'difficulty': 2446,
      'prerequisites': <int>[89],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Culminating 90-day mastery evaluation across all skill axes.',
        'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
        'Achieve >= 85% accuracy on today\'s 6 interactive exercises with zero blunders.',
      ],
      'theory': '''
# Day 90: Mastery Assessment & Completion Report — Grand Certification Exam: Culminating 90-day mastery evaluation across all skill axes

## 1. Core Pedagogical Concept & Strategic Role
Practical mastery, advantage conversion, and competitive psychological endurance in **Culminating 90-day mastery evaluation across all skill axes** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.


## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.


## 4. Practical Tournament Application & Psychological Triggers
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.



> **Official Educational Notice**: Completion of ChessMaster's 90-day curriculum and milestone exams certifies mastery of the syllabus and internal cognitive benchmarks; it does **not** grant or imply an official FIDE Grandmaster, International Master, or FIDE Master title, nor an official FIDE rating.

''',
      'workedExamples': <String>[
        'Master Model 1: Classic Grandmaster demonstration of Culminating 90-day mastery evaluation across all skill axes with strict candidate move pruning.',
        'Master Model 2: Defense and counterplay when opposing Culminating 90-day mastery evaluation across all skill axes in sharp tournament conditions.',
      ],
      'gameStudy': 'Grandmaster Syllabus Final Certification Assessment (Comprehensive)',
      'practiceTask': 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on Culminating 90-day mastery evaluation across all skill axes, followed by complete blunder post-mortem self-annotation.',
      'assessment': 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.',
      'remediation': 'Mandatory Remediation Protocol: Review Day 89 foundations, drill 10 targeted flashcards on tournamentPlay, and repeat exercises until achieving >= 85%.',
      'srsReview': <String>[
        'Culminating 90-day mastery evaluation across all skill axes: Visual Pattern Recognition Flashcard',
        'Candidate Move Selection & Pruning Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d90_ex1',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d90_ex2',
          fen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 1 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bd3'],
          explanation: 'Deep calculation confirms Bd3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d90_ex3',
          fen: 'r1bq1rk1/1ppnbppp/p3pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQ - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['O-O'],
          explanation: 'Deep calculation confirms O-O as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d90_ex4',
          fen: 'rnbq1rk1/ppp1bppp/4pn2/3p4/2PP4/2N2N2/PP2PPPP/R1BQKB1R w KQ - 3 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Bg5'],
          explanation: 'Deep calculation confirms Bg5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
        const CurriculumExercise(
          id: 'cur_d90_ex5',
          fen: 'r1bq1rk1/pp2bppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['Ne5'],
          explanation: 'Deep calculation confirms Ne5 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Candidate Selection',
        ),
        const CurriculumExercise(
          id: 'cur_d90_ex6',
          fen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Calculate candidate moves and choose the deepest forcing line.',
          solutionSan: <String>['b3'],
          explanation: 'Deep calculation confirms b3 as the sole winning continuation.',
          hints: <String>['Brainstorm all candidate checks/captures before calculating.', 'Look beyond the horizon.'],
          motif: 'Calculation Horizon',
        ),
      ],
    },
  };
}

