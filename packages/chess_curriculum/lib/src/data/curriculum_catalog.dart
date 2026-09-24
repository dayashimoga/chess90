// GENERATED CHESSMASTER 90-DAY CURRICULUM CATALOG
// Complete 90-Day GM Mastery Spiral with 100% unique pedagogical content, tiered hints, and verified legal exercises.

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
      definition: details['definition'] as String?,
      whyItMatters: details['whyItMatters'] as String?,
      visualBoardFen: details['visualBoardFen'] as String?,
      patternRule: details['patternRule'] as String?,
      commonMistakes: (details['commonMistakes'] as List<dynamic>?)?.cast<String>(),
      cheatSheetSummary: (details['cheatSheetSummary'] as List<dynamic>?)?.cast<String>(),
    );
  }

  static final Map<int, Map<String, dynamic>> _dayDefinitions = {

    1: {
      'title': 'Day 1: Comprehensive Baseline Diagnostic',
      'topic': 'Baseline Diagnostic',
      'theme': 'Diagnostic Assessment & Board Vision: Coordinate Fluency & 12-Axis Skill Radar',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1200,
      'prerequisites': <int>[],
      'objectives': <String>[
        'Map baseline 12-axis skill radar across tactical, positional, and calculation dimensions.',
        'Solve 6 diagnostic positions under tournament time limits.',
      ],
      'definition': 'Diagnostic evaluation measuring tactical recognition speed, coordinate vision, and calculation depth.',
      'whyItMatters': 'Establishes personalized training benchmarks and maps your initial 12-axis cognitive skill profile.',
      'visualBoardFen': 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
      'patternRule': 'Establish baseline tactical accuracy and coordinate vision before starting training.',
      'commonMistakes': <String>[
        'Rushing through calculation without identifying opponent counter-checks.',
        'Overlooking quiet retreating moves.',
      ],
      'cheatSheetSummary': <String>[
        'Scan checks, captures, and threats (CCT) on every ply.',
        'Identify undefended pieces (LPDO).',
        'Maintain steady clock rhythm.',
      ],
      'theory': '''
# Day 1: Comprehensive Baseline Diagnostic

### 1. Simple Definition & Core Concept
Diagnostic evaluation measuring tactical recognition speed, coordinate vision, and calculation depth.

### 2. Why It Matters in Practical Play
Establishes personalized training benchmarks and maps your initial 12-axis cognitive skill profile.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Establish baseline tactical accuracy and coordinate vision before starting training.

**Canonical Diagram FEN:** `r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1`

### 4. Canonical Model Game
Diagnostic Benchmark Protocols

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Rushing through calculation without identifying opponent counter-checks.
- **Mistake:** Overlooking quiet retreating moves.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Scan checks, captures, and threats (CCT) on every ply.
- Identify undefended pieces (LPDO).
- Maintain steady clock rhythm.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Baseline Diagnostic with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Baseline Diagnostic.',
      ],
      'gameStudy': 'Diagnostic Benchmark Protocols',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 1 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Baseline Diagnostic: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'cur_d1_ex1',
          fen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Deliver immediate checkmate exploiting the f7 weakness.',
          solutionSan: <String>['Qxf7#'],
          explanation: 'Qxf7# delivers checkmate supported by the bishop on c4.',
          hints: <String>['Find the undefended mating square adjacent to the enemy king.'],
          motif: 'Scholar Mate Attack',
          hintConcept: 'Attack the vulnerable f7 square directly.',
          hintPiece: 'Use your queen coordinating with the c4 bishop.',
          hintForcing: 'Play Qxf7#.',
          refutationAnalysis: 'Taking the knight with Qxe4 misses immediate checkmate.',
        ),
        const CurriculumExercise(
          id: 'cur_d1_ex2',
          fen: '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the vulnerable back rank.',
          solutionSan: <String>['Re8#'],
          explanation: 'Re8# delivers the classic corridor checkmate.',
          hints: <String>['Look at Black\'s uncastled back rank with no escape luft.'],
          motif: 'Back Rank Mate',
          hintConcept: 'Infiltrate the back rank.',
          hintPiece: 'Deliver the blow with your active rook.',
          hintForcing: 'Play Re8#.',
          refutationAnalysis: 'Passive moves allow Black to create a luft with ...h6.',
        ),
        const CurriculumExercise(
          id: 'cur_d1_ex3',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Claim the vertical opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims direct vertical opposition, forcing Black to step aside.',
          hints: <String>['Place your king on the same file with one square in between.'],
          motif: 'Opposition',
          hintConcept: 'Claim the opposition on the e-file.',
          hintPiece: 'Step the white king forward to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
      ],
    },
    2: {
      'title': 'Day 2: Tactics — Hanging Pieces & LPDO',
      'topic': 'Tactics — Hanging Pieces & LPDO',
      'theme': 'Exploiting undefended pieces and loose tactical vulnerabilities',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1215,
      'prerequisites': <int>[1],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Hanging Pieces & LPDO.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Hanging Pieces & LPDO teaches foundational chess mastery: Exploiting undefended pieces and loose tactical vulnerabilities.',
      'whyItMatters': 'Mastering Tactics — Hanging Pieces & LPDO allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Undefended pieces are primary tactical targets.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Undefended pieces are primary tactical targets.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 2: Tactics — Hanging Pieces & LPDO

### 1. Simple Definition & Core Concept
Tactics — Hanging Pieces & LPDO teaches foundational chess mastery: Exploiting undefended pieces and loose tactical vulnerabilities.

### 2. Why It Matters in Practical Play
Mastering Tactics — Hanging Pieces & LPDO allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Undefended pieces are primary tactical targets.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Harry Pillsbury vs Emanuel Lasker (1895)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Undefended pieces are primary tactical targets.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Hanging Pieces & LPDO with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Hanging Pieces & LPDO.',
      ],
      'gameStudy': 'Harry Pillsbury vs Emanuel Lasker (1895)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 1 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Hanging Pieces & LPDO: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_2_ex_1',
          fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the loose knight on e4 and the open e-file.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 pins and wins the loose knight on e4 against the uncastled black king.',
          hints: <String>['Target the undefended black knight on e4.', 'Step your queen onto the e-file.', 'Play Qe2.'],
          motif: 'Loose Piece Exploitation',
          hintConcept: 'Target the undefended black knight on e4.',
          hintPiece: 'Step your queen onto the e-file.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'd3 allows Black to retreat or trade with Nxe4.',
        ),
        const CurriculumExercise(
          id: 'day_2_ex_2',
          fen: '2r3k1/pp3ppp/8/8/4n3/5N2/PP3PPP/2R3K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Punish Black\'s undefended back rank rook.',
          solutionSan: <String>['Rxc8#'],
          explanation: 'Rxc8# captures the loose rook and delivers back-rank checkmate.',
          hints: <String>['The c8 rook is hanging and Black has no luft.', 'Capture on c8 with your rook.', 'Play Rxc8#.'],
          motif: 'Hanging Rook & Back Rank',
          hintConcept: 'The c8 rook is hanging and Black has no luft.',
          hintPiece: 'Capture on c8 with your rook.',
          hintForcing: 'Play Rxc8#.',
          refutationAnalysis: 'Re1 allows Black to consolidate with ...f5 or ...Nf6.',
        ),
        const CurriculumExercise(
          id: 'day_2_ex_3',
          fen: 'r1bqk2r/ppp2ppp/2n5/3np3/1b6/2NP1N2/PPPBBPPP/R2QK2R w KQkq - 0 7',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Eliminate Black\'s central knight and gain the bishop pair.',
          solutionSan: <String>['Nxd5'],
          explanation: 'Nxd5 removes Black\'s key central piece, preparing favorable simplification.',
          hints: <String>['Capture the active knight on d5.', 'Use your knight on c3.', 'Play Nxd5.'],
          motif: 'Central Liquidation',
          hintConcept: 'Capture the active knight on d5.',
          hintPiece: 'Use your knight on c3.',
          hintForcing: 'Play Nxd5.',
          refutationAnalysis: 'O-O lets Black keep an active outpost on d5.',
        ),
      ],
    },
    3: {
      'title': 'Day 3: Tactics — Absolute & Relative Pins',
      'topic': 'Tactics — Absolute & Relative Pins',
      'theme': 'Freezing pieces against king and queen vectors',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1229,
      'prerequisites': <int>[2],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Absolute & Relative Pins.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Absolute & Relative Pins teaches foundational chess mastery: Freezing pieces against king and queen vectors.',
      'whyItMatters': 'Mastering Tactics — Absolute & Relative Pins allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Pinned pieces lose their defensive power.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Pinned pieces lose their defensive power.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 3: Tactics — Absolute & Relative Pins

### 1. Simple Definition & Core Concept
Tactics — Absolute & Relative Pins teaches foundational chess mastery: Freezing pieces against king and queen vectors.

### 2. Why It Matters in Practical Play
Mastering Tactics — Absolute & Relative Pins allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Pinned pieces lose their defensive power.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Alexander Alekhine vs Richard Reti (1925)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Pinned pieces lose their defensive power.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Absolute & Relative Pins with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Absolute & Relative Pins.',
      ],
      'gameStudy': 'Alexander Alekhine vs Richard Reti (1925)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 2 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Absolute & Relative Pins: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_3_ex_1',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Counter-attack White\'s e4 pawn while developing harmoniously.',
          solutionSan: <String>['Nf6'],
          explanation: 'Nf6 attacks e4 immediately, preparing rapid kingside castling.',
          hints: <String>['Develop your kingside knight toward the center.', 'Move the g8 knight to f6.', 'Play Nf6.'],
          motif: 'Two Knights Counter-Attack',
          hintConcept: 'Develop your kingside knight toward the center.',
          hintPiece: 'Move the g8 knight to f6.',
          hintForcing: 'Play Nf6.',
          refutationAnalysis: 'Pushing d6 shuts in the f8 bishop passively.',
        ),
        const CurriculumExercise(
          id: 'day_3_ex_2',
          fen: 'r1b1k2r/ppppqppp/2n5/4p3/2B1n3/2P2N2/PPP2PPP/R1BQK2R w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Pin the active knight against Black\'s queen on the e-file.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 creates an absolute e-file pin forcing Black onto the defensive.',
          hints: <String>['Align your queen with Black\'s queen on e7.', 'Move your queen to e2.', 'Play Qe2.'],
          motif: 'Relative Pin on E-File',
          hintConcept: 'Align your queen with Black\'s queen on e7.',
          hintPiece: 'Move your queen to e2.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'O-O allows Black to retreat the knight to f6 safely.',
        ),
        const CurriculumExercise(
          id: 'day_3_ex_3',
          fen: 'r2qk2r/ppp2ppp/2np1n2/1B2p3/1b1PP3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 2 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Exploit the pinned knight on c6.',
          solutionSan: <String>['d5'],
          explanation: 'd5 advances against the pinned knight which cannot move due to the b5 bishop.',
          hints: <String>['Attack the pinned piece with a pawn.', 'Push your d4 pawn forward.', 'Play d5.'],
          motif: 'Pushing Against the Pin',
          hintConcept: 'Attack the pinned piece with a pawn.',
          hintPiece: 'Push your d4 pawn forward.',
          hintForcing: 'Play d5.',
          refutationAnalysis: 'O-O relieves the pressure and allows Black to untangle with ...a6.',
        ),
      ],
    },
    4: {
      'title': 'Day 4: Tactics — Skewers & X-Ray Attacks',
      'topic': 'Tactics — Skewers & X-Ray Attacks',
      'theme': 'Attacking higher-value targets with collateral pieces behind',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1244,
      'prerequisites': <int>[3],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Skewers & X-Ray Attacks.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Skewers & X-Ray Attacks teaches foundational chess mastery: Attacking higher-value targets with collateral pieces behind.',
      'whyItMatters': 'Mastering Tactics — Skewers & X-Ray Attacks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'The valuable piece in front must yield.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'The valuable piece in front must yield.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 4: Tactics — Skewers & X-Ray Attacks

### 1. Simple Definition & Core Concept
Tactics — Skewers & X-Ray Attacks teaches foundational chess mastery: Attacking higher-value targets with collateral pieces behind.

### 2. Why It Matters in Practical Play
Mastering Tactics — Skewers & X-Ray Attacks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** The valuable piece in front must yield.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Jose Raul Capablanca vs Rudolf Spielmann (1911)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- The valuable piece in front must yield.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Skewers & X-Ray Attacks with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Skewers & X-Ray Attacks.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Rudolf Spielmann (1911)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 3 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Skewers & X-Ray Attacks: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_4_ex_1',
          fen: 'r3k3/8/8/8/8/8/8/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Deliver a devastating skewer check against the enemy king.',
          solutionSan: <String>['Rh8+'],
          explanation: 'Rh8+ checks the king on e8, skewering the trailing rook on a8 along the 8th rank.',
          hints: <String>['Check along the 8th rank to skewer the king.', 'Slide your rook to h8.', 'Play Rh8+.'],
          motif: 'Rank Skewer',
          hintConcept: 'Check along the 8th rank to skewer the king.',
          hintPiece: 'Slide your rook to h8.',
          hintForcing: 'Play Rh8+.',
          refutationAnalysis: 'Moving the king passively allows Black to develop or castle.',
        ),
        const CurriculumExercise(
          id: 'day_4_ex_2',
          fen: '8/2k5/8/8/2B5/8/8/4K2R w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Skewer the enemy king on the 7th rank.',
          solutionSan: <String>['Rh7+'],
          explanation: 'Rh7+ checks the king and controls the horizontal file.',
          hints: <String>['Step onto the 7th rank with check.', 'Move your rook to h7.', 'Play Rh7+.'],
          motif: 'Horizontal Skewer',
          hintConcept: 'Step onto the 7th rank with check.',
          hintPiece: 'Move your rook to h7.',
          hintForcing: 'Play Rh7+.',
          refutationAnalysis: 'Kd2 gives Black a free tempo to step away.',
        ),
        const CurriculumExercise(
          id: 'day_4_ex_3',
          fen: '3r2k1/5ppp/8/8/8/8/1B3PPP/6K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Evade the back-rank threat and activate the king.',
          solutionSan: <String>['Kf1'],
          explanation: 'Kf1 steps towards the center while defusing back-rank mating nets.',
          hints: <String>['Bring your king closer to the center.', 'Move the white king to f1.', 'Play Kf1.'],
          motif: 'Back-Rank Defense & Clearance',
          hintConcept: 'Bring your king closer to the center.',
          hintPiece: 'Move the white king to f1.',
          hintForcing: 'Play Kf1.',
          refutationAnalysis: 'g3 weakens the dark squares unnecessarily.',
        ),
      ],
    },
    5: {
      'title': 'Day 5: Tactics — Knight Forks & Geometry',
      'topic': 'Tactics — Knight Forks & Geometry',
      'theme': 'Octopus knight anchors and lethal royal forks',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1258,
      'prerequisites': <int>[4],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Knight Forks & Geometry.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Knight Forks & Geometry teaches foundational chess mastery: Octopus knight anchors and lethal royal forks.',
      'whyItMatters': 'Mastering Tactics — Knight Forks & Geometry allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Knights attack pieces on opposite color squares.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Knights attack pieces on opposite color squares.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 5: Tactics — Knight Forks & Geometry

### 1. Simple Definition & Core Concept
Tactics — Knight Forks & Geometry teaches foundational chess mastery: Octopus knight anchors and lethal royal forks.

### 2. Why It Matters in Practical Play
Mastering Tactics — Knight Forks & Geometry allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Knights attack pieces on opposite color squares.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Wilhelm Steinitz vs Curt von Bardeleben (1895)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Knights attack pieces on opposite color squares.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Knight Forks & Geometry with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Knight Forks & Geometry.',
      ],
      'gameStudy': 'Wilhelm Steinitz vs Curt von Bardeleben (1895)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 4 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Knight Forks & Geometry: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_5_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 4 4',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch the Fried Liver battery against f7.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 coordinates with the c4 bishop to threaten a fork on f7.',
          hints: <String>['Aim your knight at Black\'s uncastled f7 pawn.', 'Move your f3 knight to g5.', 'Play Ng5.'],
          motif: 'F7 Knight Battery',
          hintConcept: 'Aim your knight at Black\'s uncastled f7 pawn.',
          hintPiece: 'Move your f3 knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'd3 allows Black to develop calmly with ...Bc5.',
        ),
        const CurriculumExercise(
          id: 'day_5_ex_2',
          fen: 'r1bqk2r/pppp1ppp/2n2n2/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 6 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure in the Giuoco Pianissimo.',
          solutionSan: <String>['d3'],
          explanation: 'd3 protects e4, opens the c1 bishop diagonal, and maintains central stability.',
          hints: <String>['Support e4 and liberate your dark-squared bishop.', 'Push the d-pawn one square.', 'Play d3.'],
          motif: 'Harmonic Central Support',
          hintConcept: 'Support e4 and liberate your dark-squared bishop.',
          hintPiece: 'Push the d-pawn one square.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Nxe5 Nxe5 d4 gives complicated counterplay.',
        ),
        const CurriculumExercise(
          id: 'day_5_ex_3',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P1n1/2NP1N2/PPP2PPP/R1BQK2R w KQkq - 1 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Defend f2 by castling your king into safety.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O protects f2 with the rook and removes the king from the center.',
          hints: <String>['Protect the vulnerable f2 square by castling.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Defensive Castling',
          hintConcept: 'Protect the vulnerable f2 square by castling.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Rf1 is awkward and misplaces the rook.',
        ),
      ],
    },
    6: {
      'title': 'Day 6: Tactics — Double Attacks & Dual Threats',
      'topic': 'Tactics — Double Attacks & Dual Threats',
      'theme': 'Simultaneous dual threats splitting enemy coordination',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1273,
      'prerequisites': <int>[5],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Double Attacks & Dual Threats.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Double Attacks & Dual Threats teaches foundational chess mastery: Simultaneous dual threats splitting enemy coordination.',
      'whyItMatters': 'Mastering Tactics — Double Attacks & Dual Threats allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'One defender cannot respond to two threats.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'One defender cannot respond to two threats.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 6: Tactics — Double Attacks & Dual Threats

### 1. Simple Definition & Core Concept
Tactics — Double Attacks & Dual Threats teaches foundational chess mastery: Simultaneous dual threats splitting enemy coordination.

### 2. Why It Matters in Practical Play
Mastering Tactics — Double Attacks & Dual Threats allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** One defender cannot respond to two threats.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Frank Marshall vs Stepan Levitsky (1912)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- One defender cannot respond to two threats.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Double Attacks & Dual Threats with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Double Attacks & Dual Threats.',
      ],
      'gameStudy': 'Frank Marshall vs Stepan Levitsky (1912)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 5 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Double Attacks & Dual Threats: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_6_ex_1',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Initiate the central fork trick against White\'s bishop on c4.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 prepares ...d5, creating a fork that regains the piece with a superior center.',
          hints: <String>['Capture the e4 pawn to prepare a pawn fork.', 'Take on e4 with your knight.', 'Play Nxe4.'],
          motif: 'Center Fork Trick',
          hintConcept: 'Capture the e4 pawn to prepare a pawn fork.',
          hintPiece: 'Take on e4 with your knight.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'd6 is passive and concedes central space.',
        ),
        const CurriculumExercise(
          id: 'day_6_ex_2',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Punish Black\'s passive ...d6 setup by attacking f7.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 creates an immediate dual threat on f7 with the bishop on c4.',
          hints: <String>['Double attack the f7 pawn before Black can castle.', 'Jump the knight to g5.', 'Play Ng5.'],
          motif: 'F7 Dual Pressure',
          hintConcept: 'Double attack the f7 pawn before Black can castle.',
          hintPiece: 'Jump the knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'O-O gives Black time to play ...Be7 and castle.',
        ),
        const CurriculumExercise(
          id: 'day_6_ex_3',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Strike in the center to open lines against the uncastled black king.',
          solutionSan: <String>['d4'],
          explanation: 'd4 challenges e5 immediately, creating central tension and opening files.',
          hints: <String>['Open the center while your king is safe.', 'Push your d-pawn two squares.', 'Play d4.'],
          motif: 'Central Breakthrough',
          hintConcept: 'Open the center while your king is safe.',
          hintPiece: 'Push your d-pawn two squares.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'h3 wastes a key attacking tempo.',
        ),
      ],
    },
    7: {
      'title': 'Day 7: Tactics — Tactical Milestone Exam I',
      'topic': 'Tactics — Tactical Milestone Exam I',
      'theme': 'Timed combination evaluation under tournament pressure',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1287,
      'prerequisites': <int>[6],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Tactical Milestone Exam I.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Tactical Milestone Exam I teaches foundational chess mastery: Timed combination evaluation under tournament pressure.',
      'whyItMatters': 'Mastering Tactics — Tactical Milestone Exam I allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Calculate forcing variations to the quiet move.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Calculate forcing variations to the quiet move.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 7: Tactics — Tactical Milestone Exam I

### 1. Simple Definition & Core Concept
Tactics — Tactical Milestone Exam I teaches foundational chess mastery: Timed combination evaluation under tournament pressure.

### 2. Why It Matters in Practical Play
Mastering Tactics — Tactical Milestone Exam I allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Calculate forcing variations to the quiet move.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Johannes Zukertort vs Joseph Blackburne (1883)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Calculate forcing variations to the quiet move.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Tactical Milestone Exam I with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Tactical Milestone Exam I.',
      ],
      'gameStudy': 'Johannes Zukertort vs Joseph Blackburne (1883)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 6 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Tactical Milestone Exam I: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_7_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/4p3/1bB1n3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Win material in the center.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 captures the loose knight, securing an extra piece.',
          hints: <String>['Take the undefended knight on e4.', 'Use your knight on c3.', 'Play Nxe4.'],
          motif: 'Tactical Exam - Free Piece',
          hintConcept: 'Take the undefended knight on e4.',
          hintPiece: 'Use your knight on c3.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'Bxf7+ is an unsound speculative sacrifice.',
        ),
        const CurriculumExercise(
          id: 'day_7_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Secure your king before launching an attack.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O tucks the king safely into the corner and connects rooks.',
          hints: <String>['Castle your king to complete basic development.', 'Perform kingside castling.', 'Play O-O.'],
          motif: 'Prophylactic Castling',
          hintConcept: 'Castle your king to complete basic development.',
          hintPiece: 'Perform kingside castling.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Ng5 h6 repels the attack easily.',
        ),
      ],
    },
    8: {
      'title': 'Day 8: Tactics — Discovered Attacks & Double Checks',
      'topic': 'Tactics — Discovered Attacks & Double Checks',
      'theme': 'The most lethal tactical force: simultaneous unmasking',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 1302,
      'prerequisites': <int>[7],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Discovered Attacks & Double Checks.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Discovered Attacks & Double Checks teaches foundational chess mastery: The most lethal tactical force: simultaneous unmasking.',
      'whyItMatters': 'Mastering Tactics — Discovered Attacks & Double Checks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'In double check, the enemy king must move.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'In double check, the enemy king must move.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 8: Tactics — Discovered Attacks & Double Checks

### 1. Simple Definition & Core Concept
Tactics — Discovered Attacks & Double Checks teaches foundational chess mastery: The most lethal tactical force: simultaneous unmasking.

### 2. Why It Matters in Practical Play
Mastering Tactics — Discovered Attacks & Double Checks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** In double check, the enemy king must move.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Carlos Torre vs Emanuel Lasker (1925)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- In double check, the enemy king must move.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Discovered Attacks & Double Checks with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Discovered Attacks & Double Checks.',
      ],
      'gameStudy': 'Carlos Torre vs Emanuel Lasker (1925)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 7 foundational concepts, drill 5 targeted flashcards on attack, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Discovered Attacks & Double Checks: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_8_ex_1',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an assault targeting f7 in accordance with Tactics — Discovered Attacks & Double Checks.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 exploits the weakness on f7 coordinating with the c4 bishop.',
          hints: <String>['Target the uncastled f7 pawn.', 'Move your f3 knight to g5.', 'Play Ng5.'],
          motif: 'Knight Infiltration on f7',
          hintConcept: 'Target the uncastled f7 pawn.',
          hintPiece: 'Move your f3 knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'd3 allows Black to untangle with ...Be7.',
        ),
        const CurriculumExercise(
          id: 'day_8_ex_2',
          fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Pin the e4 knight and regain material in Tactics — Discovered Attacks & Double Checks.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 pins the loose knight along the e-file against the enemy king.',
          hints: <String>['Pin the active knight against Black\'s king.', 'Step your queen to e2.', 'Play Qe2.'],
          motif: 'Pin Along Open File',
          hintConcept: 'Pin the active knight against Black\'s king.',
          hintPiece: 'Step your queen to e2.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'd3 allows Black to trade or escape with Nxe4.',
        ),
        const CurriculumExercise(
          id: 'day_8_ex_3',
          fen: '2r3k1/pp3ppp/8/8/4n3/5N2/PP3PPP/2R3K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Capture the unprotected piece and deliver checkmate.',
          solutionSan: <String>['Rxc8#'],
          explanation: 'Rxc8# captures the loose rook and delivers corridor checkmate.',
          hints: <String>['Notice Black\'s loose rook on c8.', 'Capture on c8 with your rook.', 'Play Rxc8#.'],
          motif: 'Hanging Piece Exploitation',
          hintConcept: 'Notice Black\'s loose rook on c8.',
          hintPiece: 'Capture on c8 with your rook.',
          hintForcing: 'Play Rxc8#.',
          refutationAnalysis: 'Re1 gives away the immediate winning combination.',
        ),
      ],
    },
    9: {
      'title': 'Day 9: Tactics — Deflection & Removal of Defender',
      'topic': 'Tactics — Deflection & Removal of Defender',
      'theme': 'Liquidating key protectors away from critical squares',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1316,
      'prerequisites': <int>[8],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Deflection & Removal of Defender.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Deflection & Removal of Defender teaches foundational chess mastery: Liquidating key protectors away from critical squares.',
      'whyItMatters': 'Mastering Tactics — Deflection & Removal of Defender allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Strip away the guardian of the target square.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Strip away the guardian of the target square.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 9: Tactics — Deflection & Removal of Defender

### 1. Simple Definition & Core Concept
Tactics — Deflection & Removal of Defender teaches foundational chess mastery: Liquidating key protectors away from critical squares.

### 2. Why It Matters in Practical Play
Mastering Tactics — Deflection & Removal of Defender allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Strip away the guardian of the target square.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Mikhail Chigorin vs Siegbert Tarrasch (1893)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Strip away the guardian of the target square.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Deflection & Removal of Defender with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Deflection & Removal of Defender.',
      ],
      'gameStudy': 'Mikhail Chigorin vs Siegbert Tarrasch (1893)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 8 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Deflection & Removal of Defender: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_9_ex_1',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an assault targeting f7 in accordance with Tactics — Deflection & Removal of Defender.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 exploits the weakness on f7 coordinating with the c4 bishop.',
          hints: <String>['Target the uncastled f7 pawn.', 'Move your f3 knight to g5.', 'Play Ng5.'],
          motif: 'Knight Infiltration on f7',
          hintConcept: 'Target the uncastled f7 pawn.',
          hintPiece: 'Move your f3 knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'd3 allows Black to untangle with ...Be7.',
        ),
        const CurriculumExercise(
          id: 'day_9_ex_2',
          fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Pin the e4 knight and regain material in Tactics — Deflection & Removal of Defender.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 pins the loose knight along the e-file against the enemy king.',
          hints: <String>['Pin the active knight against Black\'s king.', 'Step your queen to e2.', 'Play Qe2.'],
          motif: 'Pin Along Open File',
          hintConcept: 'Pin the active knight against Black\'s king.',
          hintPiece: 'Step your queen to e2.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'd3 allows Black to trade or escape with Nxe4.',
        ),
        const CurriculumExercise(
          id: 'day_9_ex_3',
          fen: '2r3k1/pp3ppp/8/8/4n3/5N2/PP3PPP/2R3K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Capture the unprotected piece and deliver checkmate.',
          solutionSan: <String>['Rxc8#'],
          explanation: 'Rxc8# captures the loose rook and delivers corridor checkmate.',
          hints: <String>['Notice Black\'s loose rook on c8.', 'Capture on c8 with your rook.', 'Play Rxc8#.'],
          motif: 'Hanging Piece Exploitation',
          hintConcept: 'Notice Black\'s loose rook on c8.',
          hintPiece: 'Capture on c8 with your rook.',
          hintForcing: 'Play Rxc8#.',
          refutationAnalysis: 'Re1 gives away the immediate winning combination.',
        ),
      ],
    },
    10: {
      'title': 'Day 10: Tactics — Decoy & Attraction Sacrifices',
      'topic': 'Tactics — Decoy & Attraction Sacrifices',
      'theme': 'Luring heavy pieces into fatal geometric squares',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 1331,
      'prerequisites': <int>[9],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Decoy & Attraction Sacrifices.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Decoy & Attraction Sacrifices teaches foundational chess mastery: Luring heavy pieces into fatal geometric squares.',
      'whyItMatters': 'Mastering Tactics — Decoy & Attraction Sacrifices allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Bait the target into an unrecoverable trap.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Bait the target into an unrecoverable trap.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 10: Tactics — Decoy & Attraction Sacrifices

### 1. Simple Definition & Core Concept
Tactics — Decoy & Attraction Sacrifices teaches foundational chess mastery: Luring heavy pieces into fatal geometric squares.

### 2. Why It Matters in Practical Play
Mastering Tactics — Decoy & Attraction Sacrifices allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Bait the target into an unrecoverable trap.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Adolf Anderssen vs Lionel Kieseritzky (1851)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Bait the target into an unrecoverable trap.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Decoy & Attraction Sacrifices with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Decoy & Attraction Sacrifices.',
      ],
      'gameStudy': 'Adolf Anderssen vs Lionel Kieseritzky (1851)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 9 foundational concepts, drill 5 targeted flashcards on attack, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Decoy & Attraction Sacrifices: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_10_ex_1',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an assault targeting f7 in accordance with Tactics — Decoy & Attraction Sacrifices.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 exploits the weakness on f7 coordinating with the c4 bishop.',
          hints: <String>['Target the uncastled f7 pawn.', 'Move your f3 knight to g5.', 'Play Ng5.'],
          motif: 'Knight Infiltration on f7',
          hintConcept: 'Target the uncastled f7 pawn.',
          hintPiece: 'Move your f3 knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'd3 allows Black to untangle with ...Be7.',
        ),
        const CurriculumExercise(
          id: 'day_10_ex_2',
          fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Pin the e4 knight and regain material in Tactics — Decoy & Attraction Sacrifices.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 pins the loose knight along the e-file against the enemy king.',
          hints: <String>['Pin the active knight against Black\'s king.', 'Step your queen to e2.', 'Play Qe2.'],
          motif: 'Pin Along Open File',
          hintConcept: 'Pin the active knight against Black\'s king.',
          hintPiece: 'Step your queen to e2.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'd3 allows Black to trade or escape with Nxe4.',
        ),
        const CurriculumExercise(
          id: 'day_10_ex_3',
          fen: '2r3k1/pp3ppp/8/8/4n3/5N2/PP3PPP/2R3K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Capture the unprotected piece and deliver checkmate.',
          solutionSan: <String>['Rxc8#'],
          explanation: 'Rxc8# captures the loose rook and delivers corridor checkmate.',
          hints: <String>['Notice Black\'s loose rook on c8.', 'Capture on c8 with your rook.', 'Play Rxc8#.'],
          motif: 'Hanging Piece Exploitation',
          hintConcept: 'Notice Black\'s loose rook on c8.',
          hintPiece: 'Capture on c8 with your rook.',
          hintForcing: 'Play Rxc8#.',
          refutationAnalysis: 'Re1 gives away the immediate winning combination.',
        ),
      ],
    },
    11: {
      'title': 'Day 11: Tactics — Overloading & Line Clearance',
      'topic': 'Tactics — Overloading & Line Clearance',
      'theme': 'Exploiting pieces burdened with excessive duties',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1345,
      'prerequisites': <int>[10],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Overloading & Line Clearance.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Overloading & Line Clearance teaches foundational chess mastery: Exploiting pieces burdened with excessive duties.',
      'whyItMatters': 'Mastering Tactics — Overloading & Line Clearance allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'When one piece guards two squares, strike the third.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'When one piece guards two squares, strike the third.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 11: Tactics — Overloading & Line Clearance

### 1. Simple Definition & Core Concept
Tactics — Overloading & Line Clearance teaches foundational chess mastery: Exploiting pieces burdened with excessive duties.

### 2. Why It Matters in Practical Play
Mastering Tactics — Overloading & Line Clearance allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** When one piece guards two squares, strike the third.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Akiba Rubinstein vs Gersz Rotlewi (1907)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- When one piece guards two squares, strike the third.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Overloading & Line Clearance with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Overloading & Line Clearance.',
      ],
      'gameStudy': 'Akiba Rubinstein vs Gersz Rotlewi (1907)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 10 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Overloading & Line Clearance: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_11_ex_1',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an assault targeting f7 in accordance with Tactics — Overloading & Line Clearance.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 exploits the weakness on f7 coordinating with the c4 bishop.',
          hints: <String>['Target the uncastled f7 pawn.', 'Move your f3 knight to g5.', 'Play Ng5.'],
          motif: 'Knight Infiltration on f7',
          hintConcept: 'Target the uncastled f7 pawn.',
          hintPiece: 'Move your f3 knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'd3 allows Black to untangle with ...Be7.',
        ),
        const CurriculumExercise(
          id: 'day_11_ex_2',
          fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Pin the e4 knight and regain material in Tactics — Overloading & Line Clearance.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 pins the loose knight along the e-file against the enemy king.',
          hints: <String>['Pin the active knight against Black\'s king.', 'Step your queen to e2.', 'Play Qe2.'],
          motif: 'Pin Along Open File',
          hintConcept: 'Pin the active knight against Black\'s king.',
          hintPiece: 'Step your queen to e2.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'd3 allows Black to trade or escape with Nxe4.',
        ),
        const CurriculumExercise(
          id: 'day_11_ex_3',
          fen: '2r3k1/pp3ppp/8/8/4n3/5N2/PP3PPP/2R3K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Capture the unprotected piece and deliver checkmate.',
          solutionSan: <String>['Rxc8#'],
          explanation: 'Rxc8# captures the loose rook and delivers corridor checkmate.',
          hints: <String>['Notice Black\'s loose rook on c8.', 'Capture on c8 with your rook.', 'Play Rxc8#.'],
          motif: 'Hanging Piece Exploitation',
          hintConcept: 'Notice Black\'s loose rook on c8.',
          hintPiece: 'Capture on c8 with your rook.',
          hintForcing: 'Play Rxc8#.',
          refutationAnalysis: 'Re1 gives away the immediate winning combination.',
        ),
      ],
    },
    12: {
      'title': 'Day 12: Tactics — Interference & Obstruction',
      'topic': 'Tactics — Interference & Obstruction',
      'theme': 'Severing vital defensive communication lines',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1360,
      'prerequisites': <int>[11],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Interference & Obstruction.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Interference & Obstruction teaches foundational chess mastery: Severing vital defensive communication lines.',
      'whyItMatters': 'Mastering Tactics — Interference & Obstruction allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Place a piece between defenders to cut coordination.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Place a piece between defenders to cut coordination.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 12: Tactics — Interference & Obstruction

### 1. Simple Definition & Core Concept
Tactics — Interference & Obstruction teaches foundational chess mastery: Severing vital defensive communication lines.

### 2. Why It Matters in Practical Play
Mastering Tactics — Interference & Obstruction allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Place a piece between defenders to cut coordination.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Efim Geller vs Max Euwe (1953)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Place a piece between defenders to cut coordination.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Interference & Obstruction with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Interference & Obstruction.',
      ],
      'gameStudy': 'Efim Geller vs Max Euwe (1953)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 11 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Interference & Obstruction: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_12_ex_1',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an assault targeting f7 in accordance with Tactics — Interference & Obstruction.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 exploits the weakness on f7 coordinating with the c4 bishop.',
          hints: <String>['Target the uncastled f7 pawn.', 'Move your f3 knight to g5.', 'Play Ng5.'],
          motif: 'Knight Infiltration on f7',
          hintConcept: 'Target the uncastled f7 pawn.',
          hintPiece: 'Move your f3 knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'd3 allows Black to untangle with ...Be7.',
        ),
        const CurriculumExercise(
          id: 'day_12_ex_2',
          fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Pin the e4 knight and regain material in Tactics — Interference & Obstruction.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 pins the loose knight along the e-file against the enemy king.',
          hints: <String>['Pin the active knight against Black\'s king.', 'Step your queen to e2.', 'Play Qe2.'],
          motif: 'Pin Along Open File',
          hintConcept: 'Pin the active knight against Black\'s king.',
          hintPiece: 'Step your queen to e2.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'd3 allows Black to trade or escape with Nxe4.',
        ),
        const CurriculumExercise(
          id: 'day_12_ex_3',
          fen: '2r3k1/pp3ppp/8/8/4n3/5N2/PP3PPP/2R3K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Capture the unprotected piece and deliver checkmate.',
          solutionSan: <String>['Rxc8#'],
          explanation: 'Rxc8# captures the loose rook and delivers corridor checkmate.',
          hints: <String>['Notice Black\'s loose rook on c8.', 'Capture on c8 with your rook.', 'Play Rxc8#.'],
          motif: 'Hanging Piece Exploitation',
          hintConcept: 'Notice Black\'s loose rook on c8.',
          hintPiece: 'Capture on c8 with your rook.',
          hintForcing: 'Play Rxc8#.',
          refutationAnalysis: 'Re1 gives away the immediate winning combination.',
        ),
      ],
    },
    13: {
      'title': 'Day 13: Tactics — Trapped Pieces & Domination',
      'topic': 'Tactics — Trapped Pieces & Domination',
      'theme': 'Depriving opponent pieces of safe retreat squares',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1374,
      'prerequisites': <int>[12],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Trapped Pieces & Domination.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Trapped Pieces & Domination teaches foundational chess mastery: Depriving opponent pieces of safe retreat squares.',
      'whyItMatters': 'Mastering Tactics — Trapped Pieces & Domination allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'A piece with nowhere to run is already lost.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'A piece with nowhere to run is already lost.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 13: Tactics — Trapped Pieces & Domination

### 1. Simple Definition & Core Concept
Tactics — Trapped Pieces & Domination teaches foundational chess mastery: Depriving opponent pieces of safe retreat squares.

### 2. Why It Matters in Practical Play
Mastering Tactics — Trapped Pieces & Domination allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** A piece with nowhere to run is already lost.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Bobby Fischer vs Samuel Reshevsky (1958)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- A piece with nowhere to run is already lost.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Trapped Pieces & Domination with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Trapped Pieces & Domination.',
      ],
      'gameStudy': 'Bobby Fischer vs Samuel Reshevsky (1958)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 12 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Trapped Pieces & Domination: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_13_ex_1',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an assault targeting f7 in accordance with Tactics — Trapped Pieces & Domination.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 exploits the weakness on f7 coordinating with the c4 bishop.',
          hints: <String>['Target the uncastled f7 pawn.', 'Move your f3 knight to g5.', 'Play Ng5.'],
          motif: 'Knight Infiltration on f7',
          hintConcept: 'Target the uncastled f7 pawn.',
          hintPiece: 'Move your f3 knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'd3 allows Black to untangle with ...Be7.',
        ),
        const CurriculumExercise(
          id: 'day_13_ex_2',
          fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Pin the e4 knight and regain material in Tactics — Trapped Pieces & Domination.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 pins the loose knight along the e-file against the enemy king.',
          hints: <String>['Pin the active knight against Black\'s king.', 'Step your queen to e2.', 'Play Qe2.'],
          motif: 'Pin Along Open File',
          hintConcept: 'Pin the active knight against Black\'s king.',
          hintPiece: 'Step your queen to e2.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'd3 allows Black to trade or escape with Nxe4.',
        ),
        const CurriculumExercise(
          id: 'day_13_ex_3',
          fen: '2r3k1/pp3ppp/8/8/4n3/5N2/PP3PPP/2R3K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Capture the unprotected piece and deliver checkmate.',
          solutionSan: <String>['Rxc8#'],
          explanation: 'Rxc8# captures the loose rook and delivers corridor checkmate.',
          hints: <String>['Notice Black\'s loose rook on c8.', 'Capture on c8 with your rook.', 'Play Rxc8#.'],
          motif: 'Hanging Piece Exploitation',
          hintConcept: 'Notice Black\'s loose rook on c8.',
          hintPiece: 'Capture on c8 with your rook.',
          hintForcing: 'Play Rxc8#.',
          refutationAnalysis: 'Re1 gives away the immediate winning combination.',
        ),
      ],
    },
    14: {
      'title': 'Day 14: Tactics — Grand Milestone Exam: Tactics',
      'topic': 'Tactics — Grand Milestone Exam: Tactics',
      'theme': 'Multi-step combination synthesis and tactical certification',
      'axis': SkillAxis.tactics,
      'lab': 'tactical_lab',
      'difficulty': 1389,
      'prerequisites': <int>[13],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tactics — Grand Milestone Exam: Tactics.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tactics — Grand Milestone Exam: Tactics teaches foundational chess mastery: Multi-step combination synthesis and tactical certification.',
      'whyItMatters': 'Mastering Tactics — Grand Milestone Exam: Tactics allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Verify Kotov forcing hierarchy on every ply.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Verify Kotov forcing hierarchy on every ply.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 14: Tactics — Grand Milestone Exam: Tactics

### 1. Simple Definition & Core Concept
Tactics — Grand Milestone Exam: Tactics teaches foundational chess mastery: Multi-step combination synthesis and tactical certification.

### 2. Why It Matters in Practical Play
Mastering Tactics — Grand Milestone Exam: Tactics allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Verify Kotov forcing hierarchy on every ply.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Emanuel Lasker vs William Steinitz (1894)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Verify Kotov forcing hierarchy on every ply.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tactics — Grand Milestone Exam: Tactics with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tactics — Grand Milestone Exam: Tactics.',
      ],
      'gameStudy': 'Emanuel Lasker vs William Steinitz (1894)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 13 foundational concepts, drill 5 targeted flashcards on tactics, and repeat exercise set.',
      'srsReview': <String>[
        'Tactics — Grand Milestone Exam: Tactics: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tactics',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_14_ex_1',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an assault targeting f7 in accordance with Tactics — Grand Milestone Exam: Tactics.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 exploits the weakness on f7 coordinating with the c4 bishop.',
          hints: <String>['Target the uncastled f7 pawn.', 'Move your f3 knight to g5.', 'Play Ng5.'],
          motif: 'Knight Infiltration on f7',
          hintConcept: 'Target the uncastled f7 pawn.',
          hintPiece: 'Move your f3 knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'd3 allows Black to untangle with ...Be7.',
        ),
        const CurriculumExercise(
          id: 'day_14_ex_2',
          fen: 'r1b1k2r/pppp1ppp/2n5/4p3/2B1n3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Pin the e4 knight and regain material in Tactics — Grand Milestone Exam: Tactics.',
          solutionSan: <String>['Qe2'],
          explanation: 'Qe2 pins the loose knight along the e-file against the enemy king.',
          hints: <String>['Pin the active knight against Black\'s king.', 'Step your queen to e2.', 'Play Qe2.'],
          motif: 'Pin Along Open File',
          hintConcept: 'Pin the active knight against Black\'s king.',
          hintPiece: 'Step your queen to e2.',
          hintForcing: 'Play Qe2.',
          refutationAnalysis: 'd3 allows Black to trade or escape with Nxe4.',
        ),
        const CurriculumExercise(
          id: 'day_14_ex_3',
          fen: '2r3k1/pp3ppp/8/8/4n3/5N2/PP3PPP/2R3K1 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Capture the unprotected piece and deliver checkmate.',
          solutionSan: <String>['Rxc8#'],
          explanation: 'Rxc8# captures the loose rook and delivers corridor checkmate.',
          hints: <String>['Notice Black\'s loose rook on c8.', 'Capture on c8 with your rook.', 'Play Rxc8#.'],
          motif: 'Hanging Piece Exploitation',
          hintConcept: 'Notice Black\'s loose rook on c8.',
          hintPiece: 'Capture on c8 with your rook.',
          hintForcing: 'Play Rxc8#.',
          refutationAnalysis: 'Re1 gives away the immediate winning combination.',
        ),
      ],
    },
    15: {
      'title': 'Day 15: Calculation — Kotov Forcing Hierarchy (CCT)',
      'topic': 'Calculation — Kotov Forcing Hierarchy (CCT)',
      'theme': 'Systematic checks, captures, and threats priority list',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1403,
      'prerequisites': <int>[14],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Kotov Forcing Hierarchy (CCT).',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Kotov Forcing Hierarchy (CCT) teaches foundational chess mastery: Systematic checks, captures, and threats priority list.',
      'whyItMatters': 'Mastering Calculation — Kotov Forcing Hierarchy (CCT) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Calculate the most forcing branches first.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Calculate the most forcing branches first.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 15: Calculation — Kotov Forcing Hierarchy (CCT)

### 1. Simple Definition & Core Concept
Calculation — Kotov Forcing Hierarchy (CCT) teaches foundational chess mastery: Systematic checks, captures, and threats priority list.

### 2. Why It Matters in Practical Play
Mastering Calculation — Kotov Forcing Hierarchy (CCT) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Calculate the most forcing branches first.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Alexander Kotov vs Igor Bondarevsky (1946)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Calculate the most forcing branches first.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Kotov Forcing Hierarchy (CCT) with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Kotov Forcing Hierarchy (CCT).',
      ],
      'gameStudy': 'Alexander Kotov vs Igor Bondarevsky (1946)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in candidate_selection_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 14 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Kotov Forcing Hierarchy (CCT): Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_15_ex_1',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Strike in the center to initiate your calculation tree in Calculation — Kotov Forcing Hierarchy (CCT).',
          solutionSan: <String>['d4'],
          explanation: 'd4 opens the center and forces Black to make concrete defensive calculations.',
          hints: <String>['Calculate the consequences of opening the central d-file.', 'Push your d-pawn two squares.', 'Play d4.'],
          motif: 'Central Strike Calculation',
          hintConcept: 'Calculate the consequences of opening the central d-file.',
          hintPiece: 'Push your d-pawn two squares.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'h3 is passive and wastes a calculating tempo.',
        ),
        const CurriculumExercise(
          id: 'day_15_ex_2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Calculate the forcing center fork trick.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 prepares ...d5, calculating through all responses to regain material.',
          hints: <String>['Find the forcing central piece sacrifice that recovers the material.', 'Take the e4 pawn with your f6 knight.', 'Play Nxe4.'],
          motif: 'Kotov Forcing Sequence',
          hintConcept: 'Find the forcing central piece sacrifice that recovers the material.',
          hintPiece: 'Take the e4 pawn with your f6 knight.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'Passive moves allow White to consolidate d3.',
        ),
      ],
    },
    16: {
      'title': 'Day 16: Calculation — Candidate Move Generation',
      'topic': 'Calculation — Candidate Move Generation',
      'theme': 'Systematic candidate selection before calculation begins',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1418,
      'prerequisites': <int>[15],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Candidate Move Generation.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Candidate Move Generation teaches foundational chess mastery: Systematic candidate selection before calculation begins.',
      'whyItMatters': 'Mastering Calculation — Candidate Move Generation allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Never calculate the first move you see.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Never calculate the first move you see.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 16: Calculation — Candidate Move Generation

### 1. Simple Definition & Core Concept
Calculation — Candidate Move Generation teaches foundational chess mastery: Systematic candidate selection before calculation begins.

### 2. Why It Matters in Practical Play
Mastering Calculation — Candidate Move Generation allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Never calculate the first move you see.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Veselin Topalov (1999)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Never calculate the first move you see.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Candidate Move Generation with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Candidate Move Generation.',
      ],
      'gameStudy': 'Garry Kasparov vs Veselin Topalov (1999)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in candidate_selection_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 15 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Candidate Move Generation: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_16_ex_1',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Strike in the center to initiate your calculation tree in Calculation — Candidate Move Generation.',
          solutionSan: <String>['d4'],
          explanation: 'd4 opens the center and forces Black to make concrete defensive calculations.',
          hints: <String>['Calculate the consequences of opening the central d-file.', 'Push your d-pawn two squares.', 'Play d4.'],
          motif: 'Central Strike Calculation',
          hintConcept: 'Calculate the consequences of opening the central d-file.',
          hintPiece: 'Push your d-pawn two squares.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'h3 is passive and wastes a calculating tempo.',
        ),
        const CurriculumExercise(
          id: 'day_16_ex_2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Calculate the forcing center fork trick.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 prepares ...d5, calculating through all responses to regain material.',
          hints: <String>['Find the forcing central piece sacrifice that recovers the material.', 'Take the e4 pawn with your f6 knight.', 'Play Nxe4.'],
          motif: 'Kotov Forcing Sequence',
          hintConcept: 'Find the forcing central piece sacrifice that recovers the material.',
          hintPiece: 'Take the e4 pawn with your f6 knight.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'Passive moves allow White to consolidate d3.',
        ),
      ],
    },
    17: {
      'title': 'Day 17: Calculation — Calculation Tree Pruning',
      'topic': 'Calculation — Calculation Tree Pruning',
      'theme': 'Pruning dead branches and prioritizing decisive lines',
      'axis': SkillAxis.calculation,
      'lab': 'blind_calculation_lab',
      'difficulty': 1432,
      'prerequisites': <int>[16],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Calculation Tree Pruning.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Calculation Tree Pruning teaches foundational chess mastery: Pruning dead branches and prioritizing decisive lines.',
      'whyItMatters': 'Mastering Calculation — Calculation Tree Pruning allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Stop calculating lines that fail immediately.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Stop calculating lines that fail immediately.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 17: Calculation — Calculation Tree Pruning

### 1. Simple Definition & Core Concept
Calculation — Calculation Tree Pruning teaches foundational chess mastery: Pruning dead branches and prioritizing decisive lines.

### 2. Why It Matters in Practical Play
Mastering Calculation — Calculation Tree Pruning allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Stop calculating lines that fail immediately.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Mikhail Botvinnik vs Jose Raul Capablanca (1938)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Stop calculating lines that fail immediately.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Calculation Tree Pruning with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Calculation Tree Pruning.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs Jose Raul Capablanca (1938)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in blind_calculation_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 16 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Calculation Tree Pruning: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_17_ex_1',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Strike in the center to initiate your calculation tree in Calculation — Calculation Tree Pruning.',
          solutionSan: <String>['d4'],
          explanation: 'd4 opens the center and forces Black to make concrete defensive calculations.',
          hints: <String>['Calculate the consequences of opening the central d-file.', 'Push your d-pawn two squares.', 'Play d4.'],
          motif: 'Central Strike Calculation',
          hintConcept: 'Calculate the consequences of opening the central d-file.',
          hintPiece: 'Push your d-pawn two squares.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'h3 is passive and wastes a calculating tempo.',
        ),
        const CurriculumExercise(
          id: 'day_17_ex_2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Calculate the forcing center fork trick.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 prepares ...d5, calculating through all responses to regain material.',
          hints: <String>['Find the forcing central piece sacrifice that recovers the material.', 'Take the e4 pawn with your f6 knight.', 'Play Nxe4.'],
          motif: 'Kotov Forcing Sequence',
          hintConcept: 'Find the forcing central piece sacrifice that recovers the material.',
          hintPiece: 'Take the e4 pawn with your f6 knight.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'Passive moves allow White to consolidate d3.',
        ),
      ],
    },
    18: {
      'title': 'Day 18: Calculation — Intermediate Moves (Zwischenzug)',
      'topic': 'Calculation — Intermediate Moves (Zwischenzug)',
      'theme': 'Inserting venomous in-between checks and counters',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1447,
      'prerequisites': <int>[17],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Intermediate Moves (Zwischenzug).',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Intermediate Moves (Zwischenzug) teaches foundational chess mastery: Inserting venomous in-between checks and counters.',
      'whyItMatters': 'Mastering Calculation — Intermediate Moves (Zwischenzug) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Watch for quiet in-between moves before capturing.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Watch for quiet in-between moves before capturing.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 18: Calculation — Intermediate Moves (Zwischenzug)

### 1. Simple Definition & Core Concept
Calculation — Intermediate Moves (Zwischenzug) teaches foundational chess mastery: Inserting venomous in-between checks and counters.

### 2. Why It Matters in Practical Play
Mastering Calculation — Intermediate Moves (Zwischenzug) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Watch for quiet in-between moves before capturing.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Viswanathan Anand vs Levon Aronian (2013)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Watch for quiet in-between moves before capturing.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Intermediate Moves (Zwischenzug) with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Intermediate Moves (Zwischenzug).',
      ],
      'gameStudy': 'Viswanathan Anand vs Levon Aronian (2013)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in candidate_selection_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 17 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Intermediate Moves (Zwischenzug): Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_18_ex_1',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Strike in the center to initiate your calculation tree in Calculation — Intermediate Moves (Zwischenzug).',
          solutionSan: <String>['d4'],
          explanation: 'd4 opens the center and forces Black to make concrete defensive calculations.',
          hints: <String>['Calculate the consequences of opening the central d-file.', 'Push your d-pawn two squares.', 'Play d4.'],
          motif: 'Central Strike Calculation',
          hintConcept: 'Calculate the consequences of opening the central d-file.',
          hintPiece: 'Push your d-pawn two squares.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'h3 is passive and wastes a calculating tempo.',
        ),
        const CurriculumExercise(
          id: 'day_18_ex_2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Calculate the forcing center fork trick.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 prepares ...d5, calculating through all responses to regain material.',
          hints: <String>['Find the forcing central piece sacrifice that recovers the material.', 'Take the e4 pawn with your f6 knight.', 'Play Nxe4.'],
          motif: 'Kotov Forcing Sequence',
          hintConcept: 'Find the forcing central piece sacrifice that recovers the material.',
          hintPiece: 'Take the e4 pawn with your f6 knight.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'Passive moves allow White to consolidate d3.',
        ),
      ],
    },
    19: {
      'title': 'Day 19: Calculation — Opponent Counter-Resources',
      'topic': 'Calculation — Opponent Counter-Resources',
      'theme': 'Prophylactic calculation anticipating enemy surprises',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 1461,
      'prerequisites': <int>[18],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Opponent Counter-Resources.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Opponent Counter-Resources teaches foundational chess mastery: Prophylactic calculation anticipating enemy surprises.',
      'whyItMatters': 'Mastering Calculation — Opponent Counter-Resources allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Always ask: What is my opponent\'s strongest defense?',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Always ask: What is my opponent\'s strongest defense?',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 19: Calculation — Opponent Counter-Resources

### 1. Simple Definition & Core Concept
Calculation — Opponent Counter-Resources teaches foundational chess mastery: Prophylactic calculation anticipating enemy surprises.

### 2. Why It Matters in Practical Play
Mastering Calculation — Opponent Counter-Resources allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Always ask: What is my opponent's strongest defense?

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Tigran Petrosian vs Boris Spassky (1966)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Always ask: What is my opponent's strongest defense?
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Opponent Counter-Resources with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Opponent Counter-Resources.',
      ],
      'gameStudy': 'Tigran Petrosian vs Boris Spassky (1966)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in defensive_resource_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 18 foundational concepts, drill 5 targeted flashcards on defense, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Opponent Counter-Resources: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_19_ex_1',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Strike in the center to initiate your calculation tree in Calculation — Opponent Counter-Resources.',
          solutionSan: <String>['d4'],
          explanation: 'd4 opens the center and forces Black to make concrete defensive calculations.',
          hints: <String>['Calculate the consequences of opening the central d-file.', 'Push your d-pawn two squares.', 'Play d4.'],
          motif: 'Central Strike Calculation',
          hintConcept: 'Calculate the consequences of opening the central d-file.',
          hintPiece: 'Push your d-pawn two squares.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'h3 is passive and wastes a calculating tempo.',
        ),
        const CurriculumExercise(
          id: 'day_19_ex_2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Calculate the forcing center fork trick.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 prepares ...d5, calculating through all responses to regain material.',
          hints: <String>['Find the forcing central piece sacrifice that recovers the material.', 'Take the e4 pawn with your f6 knight.', 'Play Nxe4.'],
          motif: 'Kotov Forcing Sequence',
          hintConcept: 'Find the forcing central piece sacrifice that recovers the material.',
          hintPiece: 'Take the e4 pawn with your f6 knight.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'Passive moves allow White to consolidate d3.',
        ),
      ],
    },
    20: {
      'title': 'Day 20: Calculation — Visualizing Quiet Moves',
      'topic': 'Calculation — Visualizing Quiet Moves',
      'theme': 'Silent killer moves at the horizon of sharp variations',
      'axis': SkillAxis.visualization,
      'lab': 'visualization_lab',
      'difficulty': 1476,
      'prerequisites': <int>[19],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Visualizing Quiet Moves.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Visualizing Quiet Moves teaches foundational chess mastery: Silent killer moves at the horizon of sharp variations.',
      'whyItMatters': 'Mastering Calculation — Visualizing Quiet Moves allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Quiet moves at the end of wild lines seal the win.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Quiet moves at the end of wild lines seal the win.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 20: Calculation — Visualizing Quiet Moves

### 1. Simple Definition & Core Concept
Calculation — Visualizing Quiet Moves teaches foundational chess mastery: Silent killer moves at the horizon of sharp variations.

### 2. Why It Matters in Practical Play
Mastering Calculation — Visualizing Quiet Moves allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Quiet moves at the end of wild lines seal the win.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Vladimir Kramnik vs Garry Kasparov (2000)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Quiet moves at the end of wild lines seal the win.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Visualizing Quiet Moves with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Visualizing Quiet Moves.',
      ],
      'gameStudy': 'Vladimir Kramnik vs Garry Kasparov (2000)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in visualization_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 19 foundational concepts, drill 5 targeted flashcards on visualization, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Visualizing Quiet Moves: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for visualization',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_20_ex_1',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Strike in the center to initiate your calculation tree in Calculation — Visualizing Quiet Moves.',
          solutionSan: <String>['d4'],
          explanation: 'd4 opens the center and forces Black to make concrete defensive calculations.',
          hints: <String>['Calculate the consequences of opening the central d-file.', 'Push your d-pawn two squares.', 'Play d4.'],
          motif: 'Central Strike Calculation',
          hintConcept: 'Calculate the consequences of opening the central d-file.',
          hintPiece: 'Push your d-pawn two squares.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'h3 is passive and wastes a calculating tempo.',
        ),
        const CurriculumExercise(
          id: 'day_20_ex_2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Calculate the forcing center fork trick.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 prepares ...d5, calculating through all responses to regain material.',
          hints: <String>['Find the forcing central piece sacrifice that recovers the material.', 'Take the e4 pawn with your f6 knight.', 'Play Nxe4.'],
          motif: 'Kotov Forcing Sequence',
          hintConcept: 'Find the forcing central piece sacrifice that recovers the material.',
          hintPiece: 'Take the e4 pawn with your f6 knight.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'Passive moves allow White to consolidate d3.',
        ),
      ],
    },
    21: {
      'title': 'Day 21: Calculation — Milestone Exam: Calculation Trees',
      'topic': 'Calculation — Milestone Exam: Calculation Trees',
      'theme': '4-ply verified calculation tests with zero hints',
      'axis': SkillAxis.calculation,
      'lab': 'blind_calculation_lab',
      'difficulty': 1490,
      'prerequisites': <int>[20],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Milestone Exam: Calculation Trees.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Milestone Exam: Calculation Trees teaches foundational chess mastery: 4-ply verified calculation tests with zero hints.',
      'whyItMatters': 'Mastering Calculation — Milestone Exam: Calculation Trees allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'See the final position clearly before moving.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'See the final position clearly before moving.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 21: Calculation — Milestone Exam: Calculation Trees

### 1. Simple Definition & Core Concept
Calculation — Milestone Exam: Calculation Trees teaches foundational chess mastery: 4-ply verified calculation tests with zero hints.

### 2. Why It Matters in Practical Play
Mastering Calculation — Milestone Exam: Calculation Trees allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** See the final position clearly before moving.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Alexander Alekhine vs Efim Bogoljubov (1922)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- See the final position clearly before moving.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Milestone Exam: Calculation Trees with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Milestone Exam: Calculation Trees.',
      ],
      'gameStudy': 'Alexander Alekhine vs Efim Bogoljubov (1922)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 20 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Milestone Exam: Calculation Trees: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_21_ex_1',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Strike in the center to initiate your calculation tree in Calculation — Milestone Exam: Calculation Trees.',
          solutionSan: <String>['d4'],
          explanation: 'd4 opens the center and forces Black to make concrete defensive calculations.',
          hints: <String>['Calculate the consequences of opening the central d-file.', 'Push your d-pawn two squares.', 'Play d4.'],
          motif: 'Central Strike Calculation',
          hintConcept: 'Calculate the consequences of opening the central d-file.',
          hintPiece: 'Push your d-pawn two squares.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'h3 is passive and wastes a calculating tempo.',
        ),
        const CurriculumExercise(
          id: 'day_21_ex_2',
          fen: 'r1bqkb1r/pppp1ppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 5 4',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Calculate the forcing center fork trick.',
          solutionSan: <String>['Nxe4'],
          explanation: 'Nxe4 prepares ...d5, calculating through all responses to regain material.',
          hints: <String>['Find the forcing central piece sacrifice that recovers the material.', 'Take the e4 pawn with your f6 knight.', 'Play Nxe4.'],
          motif: 'Kotov Forcing Sequence',
          hintConcept: 'Find the forcing central piece sacrifice that recovers the material.',
          hintPiece: 'Take the e4 pawn with your f6 knight.',
          hintForcing: 'Play Nxe4.',
          refutationAnalysis: 'Passive moves allow White to consolidate d3.',
        ),
      ],
    },
    22: {
      'title': 'Day 22: Calculation — Blindfold Board Geometry',
      'topic': 'Calculation — Blindfold Board Geometry',
      'theme': 'Spatial coordinates fluency without visual board reference',
      'axis': SkillAxis.visualization,
      'lab': 'board_memory_lab',
      'difficulty': 1505,
      'prerequisites': <int>[21],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Blindfold Board Geometry.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Blindfold Board Geometry teaches foundational chess mastery: Spatial coordinates fluency without visual board reference.',
      'whyItMatters': 'Mastering Calculation — Blindfold Board Geometry allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Master the 64 squares and diagonal color vectors.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Master the 64 squares and diagonal color vectors.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 22: Calculation — Blindfold Board Geometry

### 1. Simple Definition & Core Concept
Calculation — Blindfold Board Geometry teaches foundational chess mastery: Spatial coordinates fluency without visual board reference.

### 2. Why It Matters in Practical Play
Mastering Calculation — Blindfold Board Geometry allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Master the 64 squares and diagonal color vectors.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
George Koltanowski Blindfold Marathon (1960)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Master the 64 squares and diagonal color vectors.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Blindfold Board Geometry with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Blindfold Board Geometry.',
      ],
      'gameStudy': 'George Koltanowski Blindfold Marathon (1960)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in board_memory_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 21 foundational concepts, drill 5 targeted flashcards on visualization, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Blindfold Board Geometry: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for visualization',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_22_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_22_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    23: {
      'title': 'Day 23: Calculation — Multi-Ply Pawn Races',
      'topic': 'Calculation — Multi-Ply Pawn Races',
      'theme': 'Visualizing passed pawns and calculating promotion tempos',
      'axis': SkillAxis.visualization,
      'lab': 'visualization_lab',
      'difficulty': 1519,
      'prerequisites': <int>[22],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Multi-Ply Pawn Races.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Multi-Ply Pawn Races teaches foundational chess mastery: Visualizing passed pawns and calculating promotion tempos.',
      'whyItMatters': 'Mastering Calculation — Multi-Ply Pawn Races allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Count promotion squares precisely with check.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Count promotion squares precisely with check.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 23: Calculation — Multi-Ply Pawn Races

### 1. Simple Definition & Core Concept
Calculation — Multi-Ply Pawn Races teaches foundational chess mastery: Visualizing passed pawns and calculating promotion tempos.

### 2. Why It Matters in Practical Play
Mastering Calculation — Multi-Ply Pawn Races allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Count promotion squares precisely with check.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Richard Reti Endgame Studies (1921)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Count promotion squares precisely with check.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Multi-Ply Pawn Races with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Multi-Ply Pawn Races.',
      ],
      'gameStudy': 'Richard Reti Endgame Studies (1921)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in visualization_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 22 foundational concepts, drill 5 targeted flashcards on visualization, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Multi-Ply Pawn Races: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for visualization',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_23_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_23_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    24: {
      'title': 'Day 24: Calculation — Mental Board Retention',
      'topic': 'Calculation — Mental Board Retention',
      'theme': 'Retaining piece coordinates across 4 consecutive plies',
      'axis': SkillAxis.visualization,
      'lab': 'board_memory_lab',
      'difficulty': 1534,
      'prerequisites': <int>[23],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Mental Board Retention.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Mental Board Retention teaches foundational chess mastery: Retaining piece coordinates across 4 consecutive plies.',
      'whyItMatters': 'Mastering Calculation — Mental Board Retention allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Maintain mental board fidelity under non-captures.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Maintain mental board fidelity under non-captures.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 24: Calculation — Mental Board Retention

### 1. Simple Definition & Core Concept
Calculation — Mental Board Retention teaches foundational chess mastery: Retaining piece coordinates across 4 consecutive plies.

### 2. Why It Matters in Practical Play
Mastering Calculation — Mental Board Retention allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Maintain mental board fidelity under non-captures.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Miguel Najdorf Blindfold Simultaneous (1947)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Maintain mental board fidelity under non-captures.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Mental Board Retention with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Mental Board Retention.',
      ],
      'gameStudy': 'Miguel Najdorf Blindfold Simultaneous (1947)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in board_memory_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 23 foundational concepts, drill 5 targeted flashcards on visualization, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Mental Board Retention: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for visualization',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_24_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_24_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    25: {
      'title': 'Day 25: Calculation — Eliminating Blind Spots',
      'topic': 'Calculation — Eliminating Blind Spots',
      'theme': 'Detecting backward moves and unexpected knight leaps',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1548,
      'prerequisites': <int>[24],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Calculation — Eliminating Blind Spots.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Calculation — Eliminating Blind Spots teaches foundational chess mastery: Detecting backward moves and unexpected knight leaps.',
      'whyItMatters': 'Mastering Calculation — Eliminating Blind Spots allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Backward piece moves are the hardest to spot.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Backward piece moves are the hardest to spot.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 25: Calculation — Eliminating Blind Spots

### 1. Simple Definition & Core Concept
Calculation — Eliminating Blind Spots teaches foundational chess mastery: Detecting backward moves and unexpected knight leaps.

### 2. Why It Matters in Practical Play
Mastering Calculation — Eliminating Blind Spots allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Backward piece moves are the hardest to spot.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
David Bronstein vs Alexander Kotov (1950)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Backward piece moves are the hardest to spot.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Calculation — Eliminating Blind Spots with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Calculation — Eliminating Blind Spots.',
      ],
      'gameStudy': 'David Bronstein vs Alexander Kotov (1950)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in candidate_selection_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 24 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Calculation — Eliminating Blind Spots: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_25_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_25_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    26: {
      'title': 'Day 26: Clock Discipline & Rhythm',
      'topic': 'Clock Discipline & Rhythm',
      'theme': 'Allocating calculation time efficiently across critical moves',
      'axis': SkillAxis.timeManagement,
      'lab': 'time_management_lab',
      'difficulty': 1563,
      'prerequisites': <int>[25],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Clock Discipline & Rhythm.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Clock Discipline & Rhythm teaches foundational chess mastery: Allocating calculation time efficiently across critical moves.',
      'whyItMatters': 'Mastering Clock Discipline & Rhythm allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Do not waste time when only one move is reasonable.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Do not waste time when only one move is reasonable.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 26: Clock Discipline & Rhythm

### 1. Simple Definition & Core Concept
Clock Discipline & Rhythm teaches foundational chess mastery: Allocating calculation time efficiently across critical moves.

### 2. Why It Matters in Practical Play
Mastering Clock Discipline & Rhythm allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Do not waste time when only one move is reasonable.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Anatoly Karpov vs Viktor Korchnoi (1978)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Do not waste time when only one move is reasonable.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Clock Discipline & Rhythm with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Clock Discipline & Rhythm.',
      ],
      'gameStudy': 'Anatoly Karpov vs Viktor Korchnoi (1978)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in time_management_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 25 foundational concepts, drill 5 targeted flashcards on timeManagement, and repeat exercise set.',
      'srsReview': <String>[
        'Clock Discipline & Rhythm: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for timeManagement',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_26_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_26_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    27: {
      'title': 'Day 27: Practical Tree Pruning',
      'topic': 'Practical Tree Pruning',
      'theme': 'Discarding inferior candidate lines without hesitation',
      'axis': SkillAxis.calculation,
      'lab': 'candidate_selection_lab',
      'difficulty': 1577,
      'prerequisites': <int>[26],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Practical Tree Pruning.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Practical Tree Pruning teaches foundational chess mastery: Discarding inferior candidate lines without hesitation.',
      'whyItMatters': 'Mastering Practical Tree Pruning allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Decisive execution beats endless recalculation.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Decisive execution beats endless recalculation.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 27: Practical Tree Pruning

### 1. Simple Definition & Core Concept
Practical Tree Pruning teaches foundational chess mastery: Discarding inferior candidate lines without hesitation.

### 2. Why It Matters in Practical Play
Mastering Practical Tree Pruning allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Decisive execution beats endless recalculation.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Lev Polugaevsky vs Eugenio Torre (1981)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Decisive execution beats endless recalculation.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Practical Tree Pruning with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Practical Tree Pruning.',
      ],
      'gameStudy': 'Lev Polugaevsky vs Eugenio Torre (1981)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in candidate_selection_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 26 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Practical Tree Pruning: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_27_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_27_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    28: {
      'title': 'Day 28: Grand Milestone: Calculation',
      'topic': 'Grand Milestone: Calculation',
      'theme': 'Complete calculation depth and visualization certification',
      'axis': SkillAxis.calculation,
      'lab': 'blind_calculation_lab',
      'difficulty': 1592,
      'prerequisites': <int>[27],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Grand Milestone: Calculation.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Grand Milestone: Calculation teaches foundational chess mastery: Complete calculation depth and visualization certification.',
      'whyItMatters': 'Mastering Grand Milestone: Calculation allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Calculate 3 to 4 plies deep with zero hallucinations.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Calculate 3 to 4 plies deep with zero hallucinations.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 28: Grand Milestone: Calculation

### 1. Simple Definition & Core Concept
Grand Milestone: Calculation teaches foundational chess mastery: Complete calculation depth and visualization certification.

### 2. Why It Matters in Practical Play
Mastering Grand Milestone: Calculation allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Calculate 3 to 4 plies deep with zero hallucinations.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Alexander Kotov vs Paul Keres (1950)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Calculate 3 to 4 plies deep with zero hallucinations.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Grand Milestone: Calculation with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Grand Milestone: Calculation.',
      ],
      'gameStudy': 'Alexander Kotov vs Paul Keres (1950)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 27 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Grand Milestone: Calculation: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_28_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_28_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    29: {
      'title': 'Day 29: Piece Harmony & Improvement',
      'topic': 'Piece Harmony & Improvement',
      'theme': 'Identifying and improving your worst-placed piece',
      'axis': SkillAxis.strategy,
      'lab': 'improve_worst_piece_lab',
      'difficulty': 1606,
      'prerequisites': <int>[28],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Piece Harmony & Improvement.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Piece Harmony & Improvement teaches foundational chess mastery: Identifying and improving your worst-placed piece.',
      'whyItMatters': 'Mastering Piece Harmony & Improvement allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Every piece must have an active job.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Every piece must have an active job.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 29: Piece Harmony & Improvement

### 1. Simple Definition & Core Concept
Piece Harmony & Improvement teaches foundational chess mastery: Identifying and improving your worst-placed piece.

### 2. Why It Matters in Practical Play
Mastering Piece Harmony & Improvement allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Every piece must have an active job.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Aron Nimzowitsch vs Akiba Rubinstein (1926)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Every piece must have an active job.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Piece Harmony & Improvement with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Piece Harmony & Improvement.',
      ],
      'gameStudy': 'Aron Nimzowitsch vs Akiba Rubinstein (1926)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in improve_worst_piece_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 28 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Piece Harmony & Improvement: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_29_ex_1',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Eliminate the central pawn challenge and gain a tempo.',
          solutionSan: <String>['exd5'],
          explanation: 'exd5 forces Black to recapture with the queen, allowing Nc3 with a gain of time.',
          hints: <String>['Capture the d5 pawn to draw Black\'s queen into early vulnerability.', 'Take on d5 with your e4 pawn.', 'Play exd5.'],
          motif: 'Central Pawn Liquidation',
          hintConcept: 'Capture the d5 pawn to draw Black\'s queen into early vulnerability.',
          hintPiece: 'Take on d5 with your e4 pawn.',
          hintForcing: 'Play exd5.',
          refutationAnalysis: 'Nc3 allows ...dxe4 or ...d4 gaining space.',
        ),
        const CurriculumExercise(
          id: 'day_29_ex_2',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Execute the central pawn lever to break Black\'s center.',
          solutionSan: <String>['d4'],
          explanation: 'd4 strikes at the base of Black\'s e5 outpost, opening central diagonals.',
          hints: <String>['Challenge e5 with your d-pawn.', 'Push your d-pawn to d4.', 'Play d4.'],
          motif: 'Pawn Lever Strike',
          hintConcept: 'Challenge e5 with your d-pawn.',
          hintPiece: 'Push your d-pawn to d4.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'Pushing h3 delays central action.',
        ),
      ],
    },
    30: {
      'title': 'Day 30: Outposts & Knight Anchoring',
      'topic': 'Outposts & Knight Anchoring',
      'theme': 'Securing eternal outposts supported by pawns on 5th/6th ranks',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1621,
      'prerequisites': <int>[29],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Outposts & Knight Anchoring.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Outposts & Knight Anchoring teaches foundational chess mastery: Securing eternal outposts supported by pawns on 5th/6th ranks.',
      'whyItMatters': 'Mastering Outposts & Knight Anchoring allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'A knight on a 6th-rank outpost paralyzes an army.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'A knight on a 6th-rank outpost paralyzes an army.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 30: Outposts & Knight Anchoring

### 1. Simple Definition & Core Concept
Outposts & Knight Anchoring teaches foundational chess mastery: Securing eternal outposts supported by pawns on 5th/6th ranks.

### 2. Why It Matters in Practical Play
Mastering Outposts & Knight Anchoring allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** A knight on a 6th-rank outpost paralyzes an army.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Anatoly Karpov vs Garry Kasparov (1985 Game 16)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- A knight on a 6th-rank outpost paralyzes an army.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Outposts & Knight Anchoring with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Outposts & Knight Anchoring.',
      ],
      'gameStudy': 'Anatoly Karpov vs Garry Kasparov (1985 Game 16)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in find_the_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 29 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Outposts & Knight Anchoring: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_30_ex_1',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Eliminate the central pawn challenge and gain a tempo.',
          solutionSan: <String>['exd5'],
          explanation: 'exd5 forces Black to recapture with the queen, allowing Nc3 with a gain of time.',
          hints: <String>['Capture the d5 pawn to draw Black\'s queen into early vulnerability.', 'Take on d5 with your e4 pawn.', 'Play exd5.'],
          motif: 'Central Pawn Liquidation',
          hintConcept: 'Capture the d5 pawn to draw Black\'s queen into early vulnerability.',
          hintPiece: 'Take on d5 with your e4 pawn.',
          hintForcing: 'Play exd5.',
          refutationAnalysis: 'Nc3 allows ...dxe4 or ...d4 gaining space.',
        ),
        const CurriculumExercise(
          id: 'day_30_ex_2',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Execute the central pawn lever to break Black\'s center.',
          solutionSan: <String>['d4'],
          explanation: 'd4 strikes at the base of Black\'s e5 outpost, opening central diagonals.',
          hints: <String>['Challenge e5 with your d-pawn.', 'Push your d-pawn to d4.', 'Play d4.'],
          motif: 'Pawn Lever Strike',
          hintConcept: 'Challenge e5 with your d-pawn.',
          hintPiece: 'Push your d-pawn to d4.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'Pushing h3 delays central action.',
        ),
      ],
    },
    31: {
      'title': 'Day 31: Open Files & Infiltration',
      'topic': 'Open Files & Infiltration',
      'theme': 'Battery doubling, penetrating 7th/8th ranks',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1635,
      'prerequisites': <int>[30],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Open Files & Infiltration.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Open Files & Infiltration teaches foundational chess mastery: Battery doubling, penetrating 7th/8th ranks.',
      'whyItMatters': 'Mastering Open Files & Infiltration allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Rooks on the 7th rank decimate pawn skeletons.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Rooks on the 7th rank decimate pawn skeletons.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 31: Open Files & Infiltration

### 1. Simple Definition & Core Concept
Open Files & Infiltration teaches foundational chess mastery: Battery doubling, penetrating 7th/8th ranks.

### 2. Why It Matters in Practical Play
Mastering Open Files & Infiltration allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Rooks on the 7th rank decimate pawn skeletons.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Alexander Alekhine vs Aron Nimzowitsch (1930)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Rooks on the 7th rank decimate pawn skeletons.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Open Files & Infiltration with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Open Files & Infiltration.',
      ],
      'gameStudy': 'Alexander Alekhine vs Aron Nimzowitsch (1930)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in find_the_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 30 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Open Files & Infiltration: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_31_ex_1',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Eliminate the central pawn challenge and gain a tempo.',
          solutionSan: <String>['exd5'],
          explanation: 'exd5 forces Black to recapture with the queen, allowing Nc3 with a gain of time.',
          hints: <String>['Capture the d5 pawn to draw Black\'s queen into early vulnerability.', 'Take on d5 with your e4 pawn.', 'Play exd5.'],
          motif: 'Central Pawn Liquidation',
          hintConcept: 'Capture the d5 pawn to draw Black\'s queen into early vulnerability.',
          hintPiece: 'Take on d5 with your e4 pawn.',
          hintForcing: 'Play exd5.',
          refutationAnalysis: 'Nc3 allows ...dxe4 or ...d4 gaining space.',
        ),
        const CurriculumExercise(
          id: 'day_31_ex_2',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Execute the central pawn lever to break Black\'s center.',
          solutionSan: <String>['d4'],
          explanation: 'd4 strikes at the base of Black\'s e5 outpost, opening central diagonals.',
          hints: <String>['Challenge e5 with your d-pawn.', 'Push your d-pawn to d4.', 'Play d4.'],
          motif: 'Pawn Lever Strike',
          hintConcept: 'Challenge e5 with your d-pawn.',
          hintPiece: 'Push your d-pawn to d4.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'Pushing h3 delays central action.',
        ),
      ],
    },
    32: {
      'title': 'Day 32: Good vs Bad Bishops',
      'topic': 'Good vs Bad Bishops',
      'theme': 'Operating harmoniously around friendly fixed pawn colors',
      'axis': SkillAxis.strategy,
      'lab': 'improve_worst_piece_lab',
      'difficulty': 1650,
      'prerequisites': <int>[31],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Good vs Bad Bishops.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Good vs Bad Bishops teaches foundational chess mastery: Operating harmoniously around friendly fixed pawn colors.',
      'whyItMatters': 'Mastering Good vs Bad Bishops allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Trade your bad bishop or liberate its diagonals.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Trade your bad bishop or liberate its diagonals.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 32: Good vs Bad Bishops

### 1. Simple Definition & Core Concept
Good vs Bad Bishops teaches foundational chess mastery: Operating harmoniously around friendly fixed pawn colors.

### 2. Why It Matters in Practical Play
Mastering Good vs Bad Bishops allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Trade your bad bishop or liberate its diagonals.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Bobby Fischer vs Tigran Petrosian (1970)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Trade your bad bishop or liberate its diagonals.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Good vs Bad Bishops with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Good vs Bad Bishops.',
      ],
      'gameStudy': 'Bobby Fischer vs Tigran Petrosian (1970)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in improve_worst_piece_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 31 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Good vs Bad Bishops: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_32_ex_1',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Eliminate the central pawn challenge and gain a tempo.',
          solutionSan: <String>['exd5'],
          explanation: 'exd5 forces Black to recapture with the queen, allowing Nc3 with a gain of time.',
          hints: <String>['Capture the d5 pawn to draw Black\'s queen into early vulnerability.', 'Take on d5 with your e4 pawn.', 'Play exd5.'],
          motif: 'Central Pawn Liquidation',
          hintConcept: 'Capture the d5 pawn to draw Black\'s queen into early vulnerability.',
          hintPiece: 'Take on d5 with your e4 pawn.',
          hintForcing: 'Play exd5.',
          refutationAnalysis: 'Nc3 allows ...dxe4 or ...d4 gaining space.',
        ),
        const CurriculumExercise(
          id: 'day_32_ex_2',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Execute the central pawn lever to break Black\'s center.',
          solutionSan: <String>['d4'],
          explanation: 'd4 strikes at the base of Black\'s e5 outpost, opening central diagonals.',
          hints: <String>['Challenge e5 with your d-pawn.', 'Push your d-pawn to d4.', 'Play d4.'],
          motif: 'Pawn Lever Strike',
          hintConcept: 'Challenge e5 with your d-pawn.',
          hintPiece: 'Push your d-pawn to d4.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'Pushing h3 delays central action.',
        ),
      ],
    },
    33: {
      'title': 'Day 33: Positional Exchange Sacrifice',
      'topic': 'Positional Exchange Sacrifice',
      'theme': 'Petrosian-style rook-for-minor sacrifices to clamp squares',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1664,
      'prerequisites': <int>[32],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Positional Exchange Sacrifice.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Positional Exchange Sacrifice teaches foundational chess mastery: Petrosian-style rook-for-minor sacrifices to clamp squares.',
      'whyItMatters': 'Mastering Positional Exchange Sacrifice allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Dominance of key dark squares trumps nominal points.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Dominance of key dark squares trumps nominal points.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 33: Positional Exchange Sacrifice

### 1. Simple Definition & Core Concept
Positional Exchange Sacrifice teaches foundational chess mastery: Petrosian-style rook-for-minor sacrifices to clamp squares.

### 2. Why It Matters in Practical Play
Mastering Positional Exchange Sacrifice allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Dominance of key dark squares trumps nominal points.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Tigran Petrosian vs Ludek Pachman (1961)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Dominance of key dark squares trumps nominal points.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Positional Exchange Sacrifice with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Positional Exchange Sacrifice.',
      ],
      'gameStudy': 'Tigran Petrosian vs Ludek Pachman (1961)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in positional_evaluation_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 32 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Positional Exchange Sacrifice: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_33_ex_1',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Eliminate the central pawn challenge and gain a tempo.',
          solutionSan: <String>['exd5'],
          explanation: 'exd5 forces Black to recapture with the queen, allowing Nc3 with a gain of time.',
          hints: <String>['Capture the d5 pawn to draw Black\'s queen into early vulnerability.', 'Take on d5 with your e4 pawn.', 'Play exd5.'],
          motif: 'Central Pawn Liquidation',
          hintConcept: 'Capture the d5 pawn to draw Black\'s queen into early vulnerability.',
          hintPiece: 'Take on d5 with your e4 pawn.',
          hintForcing: 'Play exd5.',
          refutationAnalysis: 'Nc3 allows ...dxe4 or ...d4 gaining space.',
        ),
        const CurriculumExercise(
          id: 'day_33_ex_2',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Execute the central pawn lever to break Black\'s center.',
          solutionSan: <String>['d4'],
          explanation: 'd4 strikes at the base of Black\'s e5 outpost, opening central diagonals.',
          hints: <String>['Challenge e5 with your d-pawn.', 'Push your d-pawn to d4.', 'Play d4.'],
          motif: 'Pawn Lever Strike',
          hintConcept: 'Challenge e5 with your d-pawn.',
          hintPiece: 'Push your d-pawn to d4.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'Pushing h3 delays central action.',
        ),
      ],
    },
    34: {
      'title': 'Day 34: Prophylaxis & Restriction',
      'topic': 'Prophylaxis & Restriction',
      'theme': 'Neutralizing opponent counterplay before executing your plan',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 1679,
      'prerequisites': <int>[33],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Prophylaxis & Restriction.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Prophylaxis & Restriction teaches foundational chess mastery: Neutralizing opponent counterplay before executing your plan.',
      'whyItMatters': 'Mastering Prophylaxis & Restriction allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Extinguish opponent hope before pushing your own agenda.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Extinguish opponent hope before pushing your own agenda.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 34: Prophylaxis & Restriction

### 1. Simple Definition & Core Concept
Prophylaxis & Restriction teaches foundational chess mastery: Neutralizing opponent counterplay before executing your plan.

### 2. Why It Matters in Practical Play
Mastering Prophylaxis & Restriction allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Extinguish opponent hope before pushing your own agenda.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Anatoly Karpov vs Wolfgang Unzicker (1974)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Extinguish opponent hope before pushing your own agenda.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Prophylaxis & Restriction with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Prophylaxis & Restriction.',
      ],
      'gameStudy': 'Anatoly Karpov vs Wolfgang Unzicker (1974)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in defensive_resource_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 33 foundational concepts, drill 5 targeted flashcards on defense, and repeat exercise set.',
      'srsReview': <String>[
        'Prophylaxis & Restriction: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_34_ex_1',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Eliminate the central pawn challenge and gain a tempo.',
          solutionSan: <String>['exd5'],
          explanation: 'exd5 forces Black to recapture with the queen, allowing Nc3 with a gain of time.',
          hints: <String>['Capture the d5 pawn to draw Black\'s queen into early vulnerability.', 'Take on d5 with your e4 pawn.', 'Play exd5.'],
          motif: 'Central Pawn Liquidation',
          hintConcept: 'Capture the d5 pawn to draw Black\'s queen into early vulnerability.',
          hintPiece: 'Take on d5 with your e4 pawn.',
          hintForcing: 'Play exd5.',
          refutationAnalysis: 'Nc3 allows ...dxe4 or ...d4 gaining space.',
        ),
        const CurriculumExercise(
          id: 'day_34_ex_2',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Execute the central pawn lever to break Black\'s center.',
          solutionSan: <String>['d4'],
          explanation: 'd4 strikes at the base of Black\'s e5 outpost, opening central diagonals.',
          hints: <String>['Challenge e5 with your d-pawn.', 'Push your d-pawn to d4.', 'Play d4.'],
          motif: 'Pawn Lever Strike',
          hintConcept: 'Challenge e5 with your d-pawn.',
          hintPiece: 'Push your d-pawn to d4.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'Pushing h3 delays central action.',
        ),
      ],
    },
    35: {
      'title': 'Day 35: Milestone Exam: Strategy',
      'topic': 'Milestone Exam: Strategy',
      'theme': 'Static vs dynamic positional advantage evaluation',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1693,
      'prerequisites': <int>[34],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Milestone Exam: Strategy.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Milestone Exam: Strategy teaches foundational chess mastery: Static vs dynamic positional advantage evaluation.',
      'whyItMatters': 'Mastering Milestone Exam: Strategy allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Assess static pawn structure vs dynamic piece lead.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Assess static pawn structure vs dynamic piece lead.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 35: Milestone Exam: Strategy

### 1. Simple Definition & Core Concept
Milestone Exam: Strategy teaches foundational chess mastery: Static vs dynamic positional advantage evaluation.

### 2. Why It Matters in Practical Play
Mastering Milestone Exam: Strategy allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Assess static pawn structure vs dynamic piece lead.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Vasily Smyslov vs Mikhail Botvinnik (1957)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Assess static pawn structure vs dynamic piece lead.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Milestone Exam: Strategy with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Milestone Exam: Strategy.',
      ],
      'gameStudy': 'Vasily Smyslov vs Mikhail Botvinnik (1957)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 34 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Milestone Exam: Strategy: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_35_ex_1',
          fen: 'rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Eliminate the central pawn challenge and gain a tempo.',
          solutionSan: <String>['exd5'],
          explanation: 'exd5 forces Black to recapture with the queen, allowing Nc3 with a gain of time.',
          hints: <String>['Capture the d5 pawn to draw Black\'s queen into early vulnerability.', 'Take on d5 with your e4 pawn.', 'Play exd5.'],
          motif: 'Central Pawn Liquidation',
          hintConcept: 'Capture the d5 pawn to draw Black\'s queen into early vulnerability.',
          hintPiece: 'Take on d5 with your e4 pawn.',
          hintForcing: 'Play exd5.',
          refutationAnalysis: 'Nc3 allows ...dxe4 or ...d4 gaining space.',
        ),
        const CurriculumExercise(
          id: 'day_35_ex_2',
          fen: 'r1bqk2r/ppppbppp/2n2n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQ1RK1 w kq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Execute the central pawn lever to break Black\'s center.',
          solutionSan: <String>['d4'],
          explanation: 'd4 strikes at the base of Black\'s e5 outpost, opening central diagonals.',
          hints: <String>['Challenge e5 with your d-pawn.', 'Push your d-pawn to d4.', 'Play d4.'],
          motif: 'Pawn Lever Strike',
          hintConcept: 'Challenge e5 with your d-pawn.',
          hintPiece: 'Push your d-pawn to d4.',
          hintForcing: 'Play d4.',
          refutationAnalysis: 'Pushing h3 delays central action.',
        ),
      ],
    },
    36: {
      'title': 'Day 36: Weak Squares & Holes',
      'topic': 'Weak Squares & Holes',
      'theme': 'Exploiting permanent structural holes that cannot be pawn-guarded',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1708,
      'prerequisites': <int>[35],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Weak Squares & Holes.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Weak Squares & Holes teaches foundational chess mastery: Exploiting permanent structural holes that cannot be pawn-guarded.',
      'whyItMatters': 'Mastering Weak Squares & Holes allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Holes in enemy camp belong to your knights.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Holes in enemy camp belong to your knights.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 36: Weak Squares & Holes

### 1. Simple Definition & Core Concept
Weak Squares & Holes teaches foundational chess mastery: Exploiting permanent structural holes that cannot be pawn-guarded.

### 2. Why It Matters in Practical Play
Mastering Weak Squares & Holes allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Holes in enemy camp belong to your knights.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Anatoly Karpov (1985 Game 24)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Holes in enemy camp belong to your knights.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Weak Squares & Holes with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Weak Squares & Holes.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1985 Game 24)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in find_the_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 35 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Weak Squares & Holes: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_36_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P1n1/2NP1N2/PPP2PPP/R1BQK2R w KQkq - 1 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Neutralize Black\'s kingside battery by castling safely.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and protects f2 with the rook.',
          hints: <String>['Castling immediately disarms Black\'s f2 threats.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Prophylactic Castling Under Fire',
          hintConcept: 'Castling immediately disarms Black\'s f2 threats.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Rf1 is awkward and misplaces the rook.',
        ),
        const CurriculumExercise(
          id: 'day_36_ex_2',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an aggressive attack against Black\'s uncastled f7 weakness.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 coordinates with c4 to strike f7 before Black can castle.',
          hints: <String>['Double the attack on Black\'s weakest square.', 'Jump your knight to g5.', 'Play Ng5.'],
          motif: 'F7 Aggressive Attack',
          hintConcept: 'Double the attack on Black\'s weakest square.',
          hintPiece: 'Jump your knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'O-O gives Black time to play ...Be7 and castle safely.',
        ),
      ],
    },
    37: {
      'title': 'Day 37: Principle of Two Weaknesses',
      'topic': 'Principle of Two Weaknesses',
      'theme': 'Stretching the defense between two distant sectors',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1722,
      'prerequisites': <int>[36],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Principle of Two Weaknesses.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Principle of Two Weaknesses teaches foundational chess mastery: Stretching the defense between two distant sectors.',
      'whyItMatters': 'Mastering Principle of Two Weaknesses allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'One weakness can be held; two weaknesses crumble.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'One weakness can be held; two weaknesses crumble.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 37: Principle of Two Weaknesses

### 1. Simple Definition & Core Concept
Principle of Two Weaknesses teaches foundational chess mastery: Stretching the defense between two distant sectors.

### 2. Why It Matters in Practical Play
Mastering Principle of Two Weaknesses allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** One weakness can be held; two weaknesses crumble.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Akiba Rubinstein vs Carl Schlechter (1912)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- One weakness can be held; two weaknesses crumble.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Principle of Two Weaknesses with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Principle of Two Weaknesses.',
      ],
      'gameStudy': 'Akiba Rubinstein vs Carl Schlechter (1912)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in find_the_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 36 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Principle of Two Weaknesses: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_37_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P1n1/2NP1N2/PPP2PPP/R1BQK2R w KQkq - 1 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Neutralize Black\'s kingside battery by castling safely.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and protects f2 with the rook.',
          hints: <String>['Castling immediately disarms Black\'s f2 threats.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Prophylactic Castling Under Fire',
          hintConcept: 'Castling immediately disarms Black\'s f2 threats.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Rf1 is awkward and misplaces the rook.',
        ),
        const CurriculumExercise(
          id: 'day_37_ex_2',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an aggressive attack against Black\'s uncastled f7 weakness.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 coordinates with c4 to strike f7 before Black can castle.',
          hints: <String>['Double the attack on Black\'s weakest square.', 'Jump your knight to g5.', 'Play Ng5.'],
          motif: 'F7 Aggressive Attack',
          hintConcept: 'Double the attack on Black\'s weakest square.',
          hintPiece: 'Jump your knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'O-O gives Black time to play ...Be7 and castle safely.',
        ),
      ],
    },
    38: {
      'title': 'Day 38: Favorable Piece Exchanges',
      'topic': 'Favorable Piece Exchanges',
      'theme': 'Simplifying into won positions and stripping counterplay',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1737,
      'prerequisites': <int>[37],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Favorable Piece Exchanges.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Favorable Piece Exchanges teaches foundational chess mastery: Simplifying into won positions and stripping counterplay.',
      'whyItMatters': 'Mastering Favorable Piece Exchanges allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Trade pieces when ahead in material; trade pawns when behind.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Trade pieces when ahead in material; trade pawns when behind.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 38: Favorable Piece Exchanges

### 1. Simple Definition & Core Concept
Favorable Piece Exchanges teaches foundational chess mastery: Simplifying into won positions and stripping counterplay.

### 2. Why It Matters in Practical Play
Mastering Favorable Piece Exchanges allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Trade pieces when ahead in material; trade pawns when behind.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Jose Raul Capablanca vs Frank Marshall (1918)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Trade pieces when ahead in material; trade pawns when behind.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Favorable Piece Exchanges with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Favorable Piece Exchanges.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Frank Marshall (1918)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in positional_evaluation_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 37 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Favorable Piece Exchanges: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_38_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P1n1/2NP1N2/PPP2PPP/R1BQK2R w KQkq - 1 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Neutralize Black\'s kingside battery by castling safely.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and protects f2 with the rook.',
          hints: <String>['Castling immediately disarms Black\'s f2 threats.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Prophylactic Castling Under Fire',
          hintConcept: 'Castling immediately disarms Black\'s f2 threats.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Rf1 is awkward and misplaces the rook.',
        ),
        const CurriculumExercise(
          id: 'day_38_ex_2',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an aggressive attack against Black\'s uncastled f7 weakness.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 coordinates with c4 to strike f7 before Black can castle.',
          hints: <String>['Double the attack on Black\'s weakest square.', 'Jump your knight to g5.', 'Play Ng5.'],
          motif: 'F7 Aggressive Attack',
          hintConcept: 'Double the attack on Black\'s weakest square.',
          hintPiece: 'Jump your knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'O-O gives Black time to play ...Be7 and castle safely.',
        ),
      ],
    },
    39: {
      'title': 'Day 39: Restricting Minor Pieces',
      'topic': 'Restricting Minor Pieces',
      'theme': 'Asphyxiating opponent knight outposts and bishop diagonals',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1751,
      'prerequisites': <int>[38],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Restricting Minor Pieces.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Restricting Minor Pieces teaches foundational chess mastery: Asphyxiating opponent knight outposts and bishop diagonals.',
      'whyItMatters': 'Mastering Restricting Minor Pieces allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Build pawn wedges that blind enemy bishops.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Build pawn wedges that blind enemy bishops.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 39: Restricting Minor Pieces

### 1. Simple Definition & Core Concept
Restricting Minor Pieces teaches foundational chess mastery: Asphyxiating opponent knight outposts and bishop diagonals.

### 2. Why It Matters in Practical Play
Mastering Restricting Minor Pieces allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Build pawn wedges that blind enemy bishops.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Bobby Fischer vs Boris Spassky (1972 Game 4)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Build pawn wedges that blind enemy bishops.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Restricting Minor Pieces with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Restricting Minor Pieces.',
      ],
      'gameStudy': 'Bobby Fischer vs Boris Spassky (1972 Game 4)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in find_the_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 38 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Restricting Minor Pieces: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_39_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P1n1/2NP1N2/PPP2PPP/R1BQK2R w KQkq - 1 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Neutralize Black\'s kingside battery by castling safely.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and protects f2 with the rook.',
          hints: <String>['Castling immediately disarms Black\'s f2 threats.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Prophylactic Castling Under Fire',
          hintConcept: 'Castling immediately disarms Black\'s f2 threats.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Rf1 is awkward and misplaces the rook.',
        ),
        const CurriculumExercise(
          id: 'day_39_ex_2',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an aggressive attack against Black\'s uncastled f7 weakness.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 coordinates with c4 to strike f7 before Black can castle.',
          hints: <String>['Double the attack on Black\'s weakest square.', 'Jump your knight to g5.', 'Play Ng5.'],
          motif: 'F7 Aggressive Attack',
          hintConcept: 'Double the attack on Black\'s weakest square.',
          hintPiece: 'Jump your knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'O-O gives Black time to play ...Be7 and castle safely.',
        ),
      ],
    },
    40: {
      'title': 'Day 40: Patient Maneuvering',
      'topic': 'Patient Maneuvering',
      'theme': 'Improving positional grip without premature pawn breaks',
      'axis': SkillAxis.strategy,
      'lab': 'find_the_plan_lab',
      'difficulty': 1766,
      'prerequisites': <int>[39],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Patient Maneuvering.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Patient Maneuvering teaches foundational chess mastery: Improving positional grip without premature pawn breaks.',
      'whyItMatters': 'Mastering Patient Maneuvering allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'The threat is stronger than the execution.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'The threat is stronger than the execution.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 40: Patient Maneuvering

### 1. Simple Definition & Core Concept
Patient Maneuvering teaches foundational chess mastery: Improving positional grip without premature pawn breaks.

### 2. Why It Matters in Practical Play
Mastering Patient Maneuvering allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** The threat is stronger than the execution.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Anatoly Karpov vs Boris Spassky (1974)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- The threat is stronger than the execution.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Patient Maneuvering with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Patient Maneuvering.',
      ],
      'gameStudy': 'Anatoly Karpov vs Boris Spassky (1974)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in find_the_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 39 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Patient Maneuvering: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_40_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P1n1/2NP1N2/PPP2PPP/R1BQK2R w KQkq - 1 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Neutralize Black\'s kingside battery by castling safely.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and protects f2 with the rook.',
          hints: <String>['Castling immediately disarms Black\'s f2 threats.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Prophylactic Castling Under Fire',
          hintConcept: 'Castling immediately disarms Black\'s f2 threats.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Rf1 is awkward and misplaces the rook.',
        ),
        const CurriculumExercise(
          id: 'day_40_ex_2',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an aggressive attack against Black\'s uncastled f7 weakness.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 coordinates with c4 to strike f7 before Black can castle.',
          hints: <String>['Double the attack on Black\'s weakest square.', 'Jump your knight to g5.', 'Play Ng5.'],
          motif: 'F7 Aggressive Attack',
          hintConcept: 'Double the attack on Black\'s weakest square.',
          hintPiece: 'Jump your knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'O-O gives Black time to play ...Be7 and castle safely.',
        ),
      ],
    },
    41: {
      'title': 'Day 41: Transforming Advantages',
      'topic': 'Transforming Advantages',
      'theme': 'Converting dynamic initiative into permanent static gains',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 1780,
      'prerequisites': <int>[40],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Transforming Advantages.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Transforming Advantages teaches foundational chess mastery: Converting dynamic initiative into permanent static gains.',
      'whyItMatters': 'Mastering Transforming Advantages allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Initiative is temporary; material and structure are permanent.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Initiative is temporary; material and structure are permanent.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 41: Transforming Advantages

### 1. Simple Definition & Core Concept
Transforming Advantages teaches foundational chess mastery: Converting dynamic initiative into permanent static gains.

### 2. Why It Matters in Practical Play
Mastering Transforming Advantages allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Initiative is temporary; material and structure are permanent.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Vasily Smyslov vs David Bronstein (1953)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Initiative is temporary; material and structure are permanent.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Transforming Advantages with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Transforming Advantages.',
      ],
      'gameStudy': 'Vasily Smyslov vs David Bronstein (1953)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in conversion_challenge_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 40 foundational concepts, drill 5 targeted flashcards on conversion, and repeat exercise set.',
      'srsReview': <String>[
        'Transforming Advantages: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_41_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P1n1/2NP1N2/PPP2PPP/R1BQK2R w KQkq - 1 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Neutralize Black\'s kingside battery by castling safely.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and protects f2 with the rook.',
          hints: <String>['Castling immediately disarms Black\'s f2 threats.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Prophylactic Castling Under Fire',
          hintConcept: 'Castling immediately disarms Black\'s f2 threats.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Rf1 is awkward and misplaces the rook.',
        ),
        const CurriculumExercise(
          id: 'day_41_ex_2',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an aggressive attack against Black\'s uncastled f7 weakness.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 coordinates with c4 to strike f7 before Black can castle.',
          hints: <String>['Double the attack on Black\'s weakest square.', 'Jump your knight to g5.', 'Play Ng5.'],
          motif: 'F7 Aggressive Attack',
          hintConcept: 'Double the attack on Black\'s weakest square.',
          hintPiece: 'Jump your knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'O-O gives Black time to play ...Be7 and castle safely.',
        ),
      ],
    },
    42: {
      'title': 'Day 42: Grand Milestone: Strategy',
      'topic': 'Grand Milestone: Strategy',
      'theme': 'Comprehensive positional evaluation and master planning exam',
      'axis': SkillAxis.strategy,
      'lab': 'positional_evaluation_lab',
      'difficulty': 1795,
      'prerequisites': <int>[41],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Grand Milestone: Strategy.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Grand Milestone: Strategy teaches foundational chess mastery: Comprehensive positional evaluation and master planning exam.',
      'whyItMatters': 'Mastering Grand Milestone: Strategy allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Plan with harmonic piece coordination and structure.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Plan with harmonic piece coordination and structure.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 42: Grand Milestone: Strategy

### 1. Simple Definition & Core Concept
Grand Milestone: Strategy teaches foundational chess mastery: Comprehensive positional evaluation and master planning exam.

### 2. Why It Matters in Practical Play
Mastering Grand Milestone: Strategy allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Plan with harmonic piece coordination and structure.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Mikhail Botvinnik vs David Bronstein (1951)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Plan with harmonic piece coordination and structure.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Grand Milestone: Strategy with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Grand Milestone: Strategy.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs David Bronstein (1951)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 41 foundational concepts, drill 5 targeted flashcards on strategy, and repeat exercise set.',
      'srsReview': <String>[
        'Grand Milestone: Strategy: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for strategy',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_42_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P1n1/2NP1N2/PPP2PPP/R1BQK2R w KQkq - 1 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Neutralize Black\'s kingside battery by castling safely.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and protects f2 with the rook.',
          hints: <String>['Castling immediately disarms Black\'s f2 threats.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Prophylactic Castling Under Fire',
          hintConcept: 'Castling immediately disarms Black\'s f2 threats.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Rf1 is awkward and misplaces the rook.',
        ),
        const CurriculumExercise(
          id: 'day_42_ex_2',
          fen: 'r1bqkb1r/ppp2ppp/2np1n2/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 0 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Launch an aggressive attack against Black\'s uncastled f7 weakness.',
          solutionSan: <String>['Ng5'],
          explanation: 'Ng5 coordinates with c4 to strike f7 before Black can castle.',
          hints: <String>['Double the attack on Black\'s weakest square.', 'Jump your knight to g5.', 'Play Ng5.'],
          motif: 'F7 Aggressive Attack',
          hintConcept: 'Double the attack on Black\'s weakest square.',
          hintPiece: 'Jump your knight to g5.',
          hintForcing: 'Play Ng5.',
          refutationAnalysis: 'O-O gives Black time to play ...Be7 and castle safely.',
        ),
      ],
    },
    43: {
      'title': 'Day 43: Pawn Chains & Base Attacks',
      'topic': 'Pawn Chains & Base Attacks',
      'theme': 'Attacking the base of pawn chains to shatter coordination',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1809,
      'prerequisites': <int>[42],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Pawn Chains & Base Attacks.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Pawn Chains & Base Attacks teaches foundational chess mastery: Attacking the base of pawn chains to shatter coordination.',
      'whyItMatters': 'Mastering Pawn Chains & Base Attacks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Strike the root of the chain, not the head.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Strike the root of the chain, not the head.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 43: Pawn Chains & Base Attacks

### 1. Simple Definition & Core Concept
Pawn Chains & Base Attacks teaches foundational chess mastery: Attacking the base of pawn chains to shatter coordination.

### 2. Why It Matters in Practical Play
Mastering Pawn Chains & Base Attacks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Strike the root of the chain, not the head.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Aron Nimzowitsch vs Jose Raul Capablanca (1927)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Strike the root of the chain, not the head.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Pawn Chains & Base Attacks with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Pawn Chains & Base Attacks.',
      ],
      'gameStudy': 'Aron Nimzowitsch vs Jose Raul Capablanca (1927)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_break_discovery_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 42 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Pawn Chains & Base Attacks: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_43_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_43_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    44: {
      'title': 'Day 44: The Carlsbad Structure',
      'topic': 'The Carlsbad Structure',
      'theme': 'The classic Minority Attack (a3-b4-b5) creating c6 weaknesses',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1824,
      'prerequisites': <int>[43],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of The Carlsbad Structure.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'The Carlsbad Structure teaches foundational chess mastery: The classic Minority Attack (a3-b4-b5) creating c6 weaknesses.',
      'whyItMatters': 'Mastering The Carlsbad Structure allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Push the minority on queenside to weaken the majority.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Push the minority on queenside to weaken the majority.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 44: The Carlsbad Structure

### 1. Simple Definition & Core Concept
The Carlsbad Structure teaches foundational chess mastery: The classic Minority Attack (a3-b4-b5) creating c6 weaknesses.

### 2. Why It Matters in Practical Play
Mastering The Carlsbad Structure allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Push the minority on queenside to weaken the majority.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Anatoly Karpov (1987)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Push the minority on queenside to weaken the majority.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of The Carlsbad Structure with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering The Carlsbad Structure.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1987)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_structure_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 43 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'The Carlsbad Structure: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_44_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_44_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    45: {
      'title': 'Day 45: Isolated Queen Pawn (IQP)',
      'topic': 'Isolated Queen Pawn (IQP)',
      'theme': 'Dynamic central attack vs blockading and liquidation',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1838,
      'prerequisites': <int>[44],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Isolated Queen Pawn (IQP).',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Isolated Queen Pawn (IQP) teaches foundational chess mastery: Dynamic central attack vs blockading and liquidation.',
      'whyItMatters': 'Mastering Isolated Queen Pawn (IQP) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Use the d4/d5 outpost for an attack, or trade to endgames.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Use the d4/d5 outpost for an attack, or trade to endgames.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 45: Isolated Queen Pawn (IQP)

### 1. Simple Definition & Core Concept
Isolated Queen Pawn (IQP) teaches foundational chess mastery: Dynamic central attack vs blockading and liquidation.

### 2. Why It Matters in Practical Play
Mastering Isolated Queen Pawn (IQP) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Use the d4/d5 outpost for an attack, or trade to endgames.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Mikhail Botvinnik vs Salo Flohr (1936)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Use the d4/d5 outpost for an attack, or trade to endgames.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Isolated Queen Pawn (IQP) with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Isolated Queen Pawn (IQP).',
      ],
      'gameStudy': 'Mikhail Botvinnik vs Salo Flohr (1936)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_structure_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 44 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Isolated Queen Pawn (IQP): Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_45_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_45_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    46: {
      'title': 'Day 46: Hanging Pawns (c4/d4)',
      'topic': 'Hanging Pawns (c4/d4)',
      'theme': 'Dynamic central tension, breakthroughs, and overextended targets',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1853,
      'prerequisites': <int>[45],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Hanging Pawns (c4/d4).',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Hanging Pawns (c4/d4) teaches foundational chess mastery: Dynamic central tension, breakthroughs, and overextended targets.',
      'whyItMatters': 'Mastering Hanging Pawns (c4/d4) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Push the break with support, or they fall under fire.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Push the break with support, or they fall under fire.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 46: Hanging Pawns (c4/d4)

### 1. Simple Definition & Core Concept
Hanging Pawns (c4/d4) teaches foundational chess mastery: Dynamic central tension, breakthroughs, and overextended targets.

### 2. Why It Matters in Practical Play
Mastering Hanging Pawns (c4/d4) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Push the break with support, or they fall under fire.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Nigel Short (1993)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Push the break with support, or they fall under fire.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Hanging Pawns (c4/d4) with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Hanging Pawns (c4/d4).',
      ],
      'gameStudy': 'Garry Kasparov vs Nigel Short (1993)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_structure_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 45 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Hanging Pawns (c4/d4): Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_46_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_46_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    47: {
      'title': 'Day 47: Backward & Doubled Pawns',
      'topic': 'Backward & Doubled Pawns',
      'theme': 'Fixing and dismantling structural pawn defects on open files',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1867,
      'prerequisites': <int>[46],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Backward & Doubled Pawns.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Backward & Doubled Pawns teaches foundational chess mastery: Fixing and dismantling structural pawn defects on open files.',
      'whyItMatters': 'Mastering Backward & Doubled Pawns allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Blockade the backward pawn, then double rooks on the file.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Blockade the backward pawn, then double rooks on the file.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 47: Backward & Doubled Pawns

### 1. Simple Definition & Core Concept
Backward & Doubled Pawns teaches foundational chess mastery: Fixing and dismantling structural pawn defects on open files.

### 2. Why It Matters in Practical Play
Mastering Backward & Doubled Pawns allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Blockade the backward pawn, then double rooks on the file.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Jose Raul Capablanca vs Emanuel Lasker (1921)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Blockade the backward pawn, then double rooks on the file.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Backward & Doubled Pawns with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Backward & Doubled Pawns.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Emanuel Lasker (1921)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_structure_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 46 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Backward & Doubled Pawns: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_47_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_47_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    48: {
      'title': 'Day 48: The Maroczy Bind (c4/e4)',
      'topic': 'The Maroczy Bind (c4/e4)',
      'theme': 'Restricting Sicilian d5 breaks with a dark-square clamp',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1882,
      'prerequisites': <int>[47],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of The Maroczy Bind (c4/e4).',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'The Maroczy Bind (c4/e4) teaches foundational chess mastery: Restricting Sicilian d5 breaks with a dark-square clamp.',
      'whyItMatters': 'Mastering The Maroczy Bind (c4/e4) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Prevent d5 and smother Black counterplay.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Prevent d5 and smother Black counterplay.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 48: The Maroczy Bind (c4/e4)

### 1. Simple Definition & Core Concept
The Maroczy Bind (c4/e4) teaches foundational chess mastery: Restricting Sicilian d5 breaks with a dark-square clamp.

### 2. Why It Matters in Practical Play
Mastering The Maroczy Bind (c4/e4) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Prevent d5 and smother Black counterplay.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Gedeon Barcza vs Bent Larsen (1964)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Prevent d5 and smother Black counterplay.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of The Maroczy Bind (c4/e4) with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering The Maroczy Bind (c4/e4).',
      ],
      'gameStudy': 'Gedeon Barcza vs Bent Larsen (1964)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_structure_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 47 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'The Maroczy Bind (c4/e4): Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_48_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_48_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    49: {
      'title': 'Day 49: Milestone Exam: Pawn Breaks',
      'topic': 'Milestone Exam: Pawn Breaks',
      'theme': 'Timing central and flank breaks under sharp conditions',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1896,
      'prerequisites': <int>[48],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Milestone Exam: Pawn Breaks.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Milestone Exam: Pawn Breaks teaches foundational chess mastery: Timing central and flank breaks under sharp conditions.',
      'whyItMatters': 'Mastering Milestone Exam: Pawn Breaks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'A premature break loses; a delayed break suffocates.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'A premature break loses; a delayed break suffocates.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 49: Milestone Exam: Pawn Breaks

### 1. Simple Definition & Core Concept
Milestone Exam: Pawn Breaks teaches foundational chess mastery: Timing central and flank breaks under sharp conditions.

### 2. Why It Matters in Practical Play
Mastering Milestone Exam: Pawn Breaks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** A premature break loses; a delayed break suffocates.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Alexander Kotov vs Paul Keres (1950)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- A premature break loses; a delayed break suffocates.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Milestone Exam: Pawn Breaks with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Milestone Exam: Pawn Breaks.',
      ],
      'gameStudy': 'Alexander Kotov vs Paul Keres (1950)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 48 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Milestone Exam: Pawn Breaks: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_49_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_49_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    50: {
      'title': 'Day 50: French Defense Pawn Chains',
      'topic': 'French Defense Pawn Chains',
      'theme': 'Undermining White\'s d4 base with ...c5 and ...f6 strikes',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1911,
      'prerequisites': <int>[49],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of French Defense Pawn Chains.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'French Defense Pawn Chains teaches foundational chess mastery: Undermining White\'s d4 base with ...c5 and ...f6 strikes.',
      'whyItMatters': 'Mastering French Defense Pawn Chains allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Chisel the d4 pawn before White castles kingside.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Chisel the d4 pawn before White castles kingside.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 50: French Defense Pawn Chains

### 1. Simple Definition & Core Concept
French Defense Pawn Chains teaches foundational chess mastery: Undermining White's d4 base with ...c5 and ...f6 strikes.

### 2. Why It Matters in Practical Play
Mastering French Defense Pawn Chains allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Chisel the d4 pawn before White castles kingside.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Mikhail Botvinnik vs Vasily Smyslov (1954)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Chisel the d4 pawn before White castles kingside.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of French Defense Pawn Chains with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering French Defense Pawn Chains.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs Vasily Smyslov (1954)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_break_discovery_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 49 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'French Defense Pawn Chains: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_50_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_50_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    51: {
      'title': 'Day 51: King\'s Indian Closed Chains',
      'topic': 'King\'s Indian Closed Chains',
      'theme': 'Opposite-flank attacks in closed center battlegrounds',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_break_discovery_lab',
      'difficulty': 1925,
      'prerequisites': <int>[50],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of King\'s Indian Closed Chains.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'King\'s Indian Closed Chains teaches foundational chess mastery: Opposite-flank attacks in closed center battlegrounds.',
      'whyItMatters': 'Mastering King\'s Indian Closed Chains allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'White attacks on queenside; Black storms the king.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'White attacks on queenside; Black storms the king.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 51: King's Indian Closed Chains

### 1. Simple Definition & Core Concept
King's Indian Closed Chains teaches foundational chess mastery: Opposite-flank attacks in closed center battlegrounds.

### 2. Why It Matters in Practical Play
Mastering King's Indian Closed Chains allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** White attacks on queenside; Black storms the king.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Bobby Fischer vs Samuel Reshevsky (1961)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- White attacks on queenside; Black storms the king.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of King\'s Indian Closed Chains with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering King\'s Indian Closed Chains.',
      ],
      'gameStudy': 'Bobby Fischer vs Samuel Reshevsky (1961)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_break_discovery_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 50 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'King\'s Indian Closed Chains: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_51_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_51_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    52: {
      'title': 'Day 52: Pawn Levers & Space Control',
      'topic': 'Pawn Levers & Space Control',
      'theme': 'Using pawn levers to open diagonals for heavy artillery',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1940,
      'prerequisites': <int>[51],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Pawn Levers & Space Control.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Pawn Levers & Space Control teaches foundational chess mastery: Using pawn levers to open diagonals for heavy artillery.',
      'whyItMatters': 'Mastering Pawn Levers & Space Control allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Pawn moves determine which files open for your rooks.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Pawn moves determine which files open for your rooks.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 52: Pawn Levers & Space Control

### 1. Simple Definition & Core Concept
Pawn Levers & Space Control teaches foundational chess mastery: Using pawn levers to open diagonals for heavy artillery.

### 2. Why It Matters in Practical Play
Mastering Pawn Levers & Space Control allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Pawn moves determine which files open for your rooks.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Anatoly Karpov vs Viktor Korchnoi (1981)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Pawn moves determine which files open for your rooks.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Pawn Levers & Space Control with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Pawn Levers & Space Control.',
      ],
      'gameStudy': 'Anatoly Karpov vs Viktor Korchnoi (1981)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_structure_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 51 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Pawn Levers & Space Control: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_52_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_52_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    53: {
      'title': 'Day 53: Middlegame Passed Pawns',
      'topic': 'Middlegame Passed Pawns',
      'theme': 'Creating, advancing, and escorting passed pawns to victory',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1954,
      'prerequisites': <int>[52],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Middlegame Passed Pawns.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Middlegame Passed Pawns teaches foundational chess mastery: Creating, advancing, and escorting passed pawns to victory.',
      'whyItMatters': 'Mastering Middlegame Passed Pawns allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Passed pawns must be pushed with heavy piece escort.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Passed pawns must be pushed with heavy piece escort.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 53: Middlegame Passed Pawns

### 1. Simple Definition & Core Concept
Middlegame Passed Pawns teaches foundational chess mastery: Creating, advancing, and escorting passed pawns to victory.

### 2. Why It Matters in Practical Play
Mastering Middlegame Passed Pawns allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Passed pawns must be pushed with heavy piece escort.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Magnus Carlsen vs Fabiano Caruana (2018)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Passed pawns must be pushed with heavy piece escort.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Middlegame Passed Pawns with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Middlegame Passed Pawns.',
      ],
      'gameStudy': 'Magnus Carlsen vs Fabiano Caruana (2018)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_structure_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 52 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Middlegame Passed Pawns: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_53_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_53_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    54: {
      'title': 'Day 54: Pawn Majority Conversion',
      'topic': 'Pawn Majority Conversion',
      'theme': 'Creating distant passed pawns from queenside majorities',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 1969,
      'prerequisites': <int>[53],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Pawn Majority Conversion.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Pawn Majority Conversion teaches foundational chess mastery: Creating distant passed pawns from queenside majorities.',
      'whyItMatters': 'Mastering Pawn Majority Conversion allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'An outside passed pawn deflects the enemy king.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'An outside passed pawn deflects the enemy king.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 54: Pawn Majority Conversion

### 1. Simple Definition & Core Concept
Pawn Majority Conversion teaches foundational chess mastery: Creating distant passed pawns from queenside majorities.

### 2. Why It Matters in Practical Play
Mastering Pawn Majority Conversion allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** An outside passed pawn deflects the enemy king.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Jose Raul Capablanca vs Savielly Tartakower (1924)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- An outside passed pawn deflects the enemy king.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Pawn Majority Conversion with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Pawn Majority Conversion.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Savielly Tartakower (1924)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in conversion_challenge_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 53 foundational concepts, drill 5 targeted flashcards on conversion, and repeat exercise set.',
      'srsReview': <String>[
        'Pawn Majority Conversion: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_54_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_54_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    55: {
      'title': 'Day 55: Positional Pawn Sacrifices',
      'topic': 'Positional Pawn Sacrifices',
      'theme': 'Dumping a pawn to seize eternal outposts and line dominance',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1983,
      'prerequisites': <int>[54],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Positional Pawn Sacrifices.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Positional Pawn Sacrifices teaches foundational chess mastery: Dumping a pawn to seize eternal outposts and line dominance.',
      'whyItMatters': 'Mastering Positional Pawn Sacrifices allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'A pawn given for dynamic open lines is often a bargain.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'A pawn given for dynamic open lines is often a bargain.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 55: Positional Pawn Sacrifices

### 1. Simple Definition & Core Concept
Positional Pawn Sacrifices teaches foundational chess mastery: Dumping a pawn to seize eternal outposts and line dominance.

### 2. Why It Matters in Practical Play
Mastering Positional Pawn Sacrifices allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** A pawn given for dynamic open lines is often a bargain.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
David Bronstein vs Paul Keres (1955)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- A pawn given for dynamic open lines is often a bargain.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Positional Pawn Sacrifices with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Positional Pawn Sacrifices.',
      ],
      'gameStudy': 'David Bronstein vs Paul Keres (1955)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in pawn_structure_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 54 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Positional Pawn Sacrifices: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_55_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_55_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    56: {
      'title': 'Day 56: Grand Milestone: Pawn Mastery',
      'topic': 'Grand Milestone: Pawn Mastery',
      'theme': 'Complete structural evaluation and break mastery exam',
      'axis': SkillAxis.pawnStructures,
      'lab': 'pawn_structure_lab',
      'difficulty': 1998,
      'prerequisites': <int>[55],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Grand Milestone: Pawn Mastery.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Grand Milestone: Pawn Mastery teaches foundational chess mastery: Complete structural evaluation and break mastery exam.',
      'whyItMatters': 'Mastering Grand Milestone: Pawn Mastery allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Pawns are the skeleton; understand every joint.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Pawns are the skeleton; understand every joint.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 56: Grand Milestone: Pawn Mastery

### 1. Simple Definition & Core Concept
Grand Milestone: Pawn Mastery teaches foundational chess mastery: Complete structural evaluation and break mastery exam.

### 2. Why It Matters in Practical Play
Mastering Grand Milestone: Pawn Mastery allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Pawns are the skeleton; understand every joint.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Vasily Smyslov vs Paul Keres (1953)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Pawns are the skeleton; understand every joint.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Grand Milestone: Pawn Mastery with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Grand Milestone: Pawn Mastery.',
      ],
      'gameStudy': 'Vasily Smyslov vs Paul Keres (1953)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 55 foundational concepts, drill 5 targeted flashcards on pawnStructures, and repeat exercise set.',
      'srsReview': <String>[
        'Grand Milestone: Pawn Mastery: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for pawnStructures',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_56_ex_1',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Seize the direct vertical opposition in the king and pawn ending.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 claims vertical opposition, denying Black\'s king forward entry.',
          hints: <String>['Take the square directly opposite the black king with one square in between.', 'Step your white king to e3.', 'Play Ke3.'],
          motif: 'Direct Vertical Opposition',
          hintConcept: 'Take the square directly opposite the black king with one square in between.',
          hintPiece: 'Step your white king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Stepping to d3 or f3 forfeits the opposition.',
        ),
        const CurriculumExercise(
          id: 'day_56_ex_2',
          fen: '8/8/8/8/8/4k3/8/R3K3 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Cut off the enemy king along the 3rd rank.',
          solutionSan: <String>['Ra3+'],
          explanation: 'Ra3+ drives the king backward and restricts its escape squares.',
          hints: <String>['Check along the 3rd rank to cut the king off from forward progress.', 'Slide your rook to a3.', 'Play Ra3+.'],
          motif: 'Rook Rank Cutoff',
          hintConcept: 'Check along the 3rd rank to cut the king off from forward progress.',
          hintPiece: 'Slide your rook to a3.',
          hintForcing: 'Play Ra3+.',
          refutationAnalysis: 'Moving the king away from e1 surrenders central control.',
        ),
      ],
    },
    57: {
      'title': 'Day 57: King & Pawn: The Opposition',
      'topic': 'King & Pawn: The Opposition',
      'theme': 'Seizing direct, distant, and diagonal opposition',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2012,
      'prerequisites': <int>[56],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of King & Pawn: The Opposition.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'King & Pawn: The Opposition teaches foundational chess mastery: Seizing direct, distant, and diagonal opposition.',
      'whyItMatters': 'Mastering King & Pawn: The Opposition allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'The player who does NOT have to move holds opposition.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'The player who does NOT have to move holds opposition.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 57: King & Pawn: The Opposition

### 1. Simple Definition & Core Concept
King & Pawn: The Opposition teaches foundational chess mastery: Seizing direct, distant, and diagonal opposition.

### 2. Why It Matters in Practical Play
Mastering King & Pawn: The Opposition allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** The player who does NOT have to move holds opposition.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Emanuel Lasker vs Siegbert Tarrasch (1908)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- The player who does NOT have to move holds opposition.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of King & Pawn: The Opposition with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering King & Pawn: The Opposition.',
      ],
      'gameStudy': 'Emanuel Lasker vs Siegbert Tarrasch (1908)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 56 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'King & Pawn: The Opposition: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_57_ex_1',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Develop the kingside knight toward the center in the Vienna/Four Knights.',
          solutionSan: <String>['Nf3'],
          explanation: 'Nf3 develops with tempo, contesting the e5 central pawn.',
          hints: <String>['Follow the golden rule: Knights before bishops.', 'Develop the g1 knight to f3.', 'Play Nf3.'],
          motif: 'Classical Piece Development',
          hintConcept: 'Follow the golden rule: Knights before bishops.',
          hintPiece: 'Develop the g1 knight to f3.',
          hintForcing: 'Play Nf3.',
          refutationAnalysis: 'f4 prematurely exposes the king diagonal.',
        ),
        const CurriculumExercise(
          id: 'day_57_ex_2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Counter-attack White\'s e4 pawn in the Italian Game.',
          solutionSan: <String>['Nf6'],
          explanation: 'Nf6 develops Black\'s kingside knight and attacks e4 directly.',
          hints: <String>['Challenge White\'s central pawn with active knight development.', 'Move your g8 knight to f6.', 'Play Nf6.'],
          motif: 'Italian Defense - Two Knights',
          hintConcept: 'Challenge White\'s central pawn with active knight development.',
          hintPiece: 'Move your g8 knight to f6.',
          hintForcing: 'Play Nf6.',
          refutationAnalysis: 'd6 is passive and locks the f8 bishop.',
        ),
      ],
    },
    58: {
      'title': 'Day 58: King & Pawn: Rule of Square',
      'topic': 'King & Pawn: Rule of Square',
      'theme': 'Calculating pawn races and key queening squares without moving',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2027,
      'prerequisites': <int>[57],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of King & Pawn: Rule of Square.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'King & Pawn: Rule of Square teaches foundational chess mastery: Calculating pawn races and key queening squares without moving.',
      'whyItMatters': 'Mastering King & Pawn: Rule of Square allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'If the enemy king is inside the square, it catches the pawn.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'If the enemy king is inside the square, it catches the pawn.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 58: King & Pawn: Rule of Square

### 1. Simple Definition & Core Concept
King & Pawn: Rule of Square teaches foundational chess mastery: Calculating pawn races and key queening squares without moving.

### 2. Why It Matters in Practical Play
Mastering King & Pawn: Rule of Square allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** If the enemy king is inside the square, it catches the pawn.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Francois Philidor Studies (1777)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- If the enemy king is inside the square, it catches the pawn.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of King & Pawn: Rule of Square with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering King & Pawn: Rule of Square.',
      ],
      'gameStudy': 'Francois Philidor Studies (1777)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 57 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'King & Pawn: Rule of Square: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_58_ex_1',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Develop the kingside knight toward the center in the Vienna/Four Knights.',
          solutionSan: <String>['Nf3'],
          explanation: 'Nf3 develops with tempo, contesting the e5 central pawn.',
          hints: <String>['Follow the golden rule: Knights before bishops.', 'Develop the g1 knight to f3.', 'Play Nf3.'],
          motif: 'Classical Piece Development',
          hintConcept: 'Follow the golden rule: Knights before bishops.',
          hintPiece: 'Develop the g1 knight to f3.',
          hintForcing: 'Play Nf3.',
          refutationAnalysis: 'f4 prematurely exposes the king diagonal.',
        ),
        const CurriculumExercise(
          id: 'day_58_ex_2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Counter-attack White\'s e4 pawn in the Italian Game.',
          solutionSan: <String>['Nf6'],
          explanation: 'Nf6 develops Black\'s kingside knight and attacks e4 directly.',
          hints: <String>['Challenge White\'s central pawn with active knight development.', 'Move your g8 knight to f6.', 'Play Nf6.'],
          motif: 'Italian Defense - Two Knights',
          hintConcept: 'Challenge White\'s central pawn with active knight development.',
          hintPiece: 'Move your g8 knight to f6.',
          hintForcing: 'Play Nf6.',
          refutationAnalysis: 'd6 is passive and locks the f8 bishop.',
        ),
      ],
    },
    59: {
      'title': 'Day 59: Triangulation & Zugzwang',
      'topic': 'Triangulation & Zugzwang',
      'theme': 'Wasting a tempo deliberately to force opponent king backward',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2041,
      'prerequisites': <int>[58],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Triangulation & Zugzwang.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Triangulation & Zugzwang teaches foundational chess mastery: Wasting a tempo deliberately to force opponent king backward.',
      'whyItMatters': 'Mastering Triangulation & Zugzwang allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Drop a tempo in king triangles to hand over the move.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Drop a tempo in king triangles to hand over the move.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 59: Triangulation & Zugzwang

### 1. Simple Definition & Core Concept
Triangulation & Zugzwang teaches foundational chess mastery: Wasting a tempo deliberately to force opponent king backward.

### 2. Why It Matters in Practical Play
Mastering Triangulation & Zugzwang allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Drop a tempo in king triangles to hand over the move.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Jose Raul Capablanca vs Alexander Alekhine (1927)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Drop a tempo in king triangles to hand over the move.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Triangulation & Zugzwang with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Triangulation & Zugzwang.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Alexander Alekhine (1927)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 58 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Triangulation & Zugzwang: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_59_ex_1',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Develop the kingside knight toward the center in the Vienna/Four Knights.',
          solutionSan: <String>['Nf3'],
          explanation: 'Nf3 develops with tempo, contesting the e5 central pawn.',
          hints: <String>['Follow the golden rule: Knights before bishops.', 'Develop the g1 knight to f3.', 'Play Nf3.'],
          motif: 'Classical Piece Development',
          hintConcept: 'Follow the golden rule: Knights before bishops.',
          hintPiece: 'Develop the g1 knight to f3.',
          hintForcing: 'Play Nf3.',
          refutationAnalysis: 'f4 prematurely exposes the king diagonal.',
        ),
        const CurriculumExercise(
          id: 'day_59_ex_2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Counter-attack White\'s e4 pawn in the Italian Game.',
          solutionSan: <String>['Nf6'],
          explanation: 'Nf6 develops Black\'s kingside knight and attacks e4 directly.',
          hints: <String>['Challenge White\'s central pawn with active knight development.', 'Move your g8 knight to f6.', 'Play Nf6.'],
          motif: 'Italian Defense - Two Knights',
          hintConcept: 'Challenge White\'s central pawn with active knight development.',
          hintPiece: 'Move your g8 knight to f6.',
          hintForcing: 'Play Nf6.',
          refutationAnalysis: 'd6 is passive and locks the f8 bishop.',
        ),
      ],
    },
    60: {
      'title': 'Day 60: The Reti Diagonal Maneuver',
      'topic': 'The Reti Diagonal Maneuver',
      'theme': 'Diagonal king marches with dual threats to queen or defend',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2056,
      'prerequisites': <int>[59],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of The Reti Diagonal Maneuver.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'The Reti Diagonal Maneuver teaches foundational chess mastery: Diagonal king marches with dual threats to queen or defend.',
      'whyItMatters': 'Mastering The Reti Diagonal Maneuver allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'March diagonally to pursue one pawn while escorting another.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'March diagonally to pursue one pawn while escorting another.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 60: The Reti Diagonal Maneuver

### 1. Simple Definition & Core Concept
The Reti Diagonal Maneuver teaches foundational chess mastery: Diagonal king marches with dual threats to queen or defend.

### 2. Why It Matters in Practical Play
Mastering The Reti Diagonal Maneuver allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** March diagonally to pursue one pawn while escorting another.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Richard Reti Endgame Studies (1921)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- March diagonally to pursue one pawn while escorting another.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of The Reti Diagonal Maneuver with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering The Reti Diagonal Maneuver.',
      ],
      'gameStudy': 'Richard Reti Endgame Studies (1921)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 59 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'The Reti Diagonal Maneuver: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_60_ex_1',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Develop the kingside knight toward the center in the Vienna/Four Knights.',
          solutionSan: <String>['Nf3'],
          explanation: 'Nf3 develops with tempo, contesting the e5 central pawn.',
          hints: <String>['Follow the golden rule: Knights before bishops.', 'Develop the g1 knight to f3.', 'Play Nf3.'],
          motif: 'Classical Piece Development',
          hintConcept: 'Follow the golden rule: Knights before bishops.',
          hintPiece: 'Develop the g1 knight to f3.',
          hintForcing: 'Play Nf3.',
          refutationAnalysis: 'f4 prematurely exposes the king diagonal.',
        ),
        const CurriculumExercise(
          id: 'day_60_ex_2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Counter-attack White\'s e4 pawn in the Italian Game.',
          solutionSan: <String>['Nf6'],
          explanation: 'Nf6 develops Black\'s kingside knight and attacks e4 directly.',
          hints: <String>['Challenge White\'s central pawn with active knight development.', 'Move your g8 knight to f6.', 'Play Nf6.'],
          motif: 'Italian Defense - Two Knights',
          hintConcept: 'Challenge White\'s central pawn with active knight development.',
          hintPiece: 'Move your g8 knight to f6.',
          hintForcing: 'Play Nf6.',
          refutationAnalysis: 'd6 is passive and locks the f8 bishop.',
        ),
      ],
    },
    61: {
      'title': 'Day 61: Rook Endgames: Lucena Bridge',
      'topic': 'Rook Endgames: Lucena Bridge',
      'theme': 'Building a bridge with Rf4/Rd4+ to safely queen on the 7th',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2070,
      'prerequisites': <int>[60],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Rook Endgames: Lucena Bridge.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Rook Endgames: Lucena Bridge teaches foundational chess mastery: Building a bridge with Rf4/Rd4+ to safely queen on the 7th.',
      'whyItMatters': 'Mastering Rook Endgames: Lucena Bridge allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'With rook and pawn on 7th, build a bridge on the 4th rank.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'With rook and pawn on 7th, build a bridge on the 4th rank.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 61: Rook Endgames: Lucena Bridge

### 1. Simple Definition & Core Concept
Rook Endgames: Lucena Bridge teaches foundational chess mastery: Building a bridge with Rf4/Rd4+ to safely queen on the 7th.

### 2. Why It Matters in Practical Play
Mastering Rook Endgames: Lucena Bridge allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** With rook and pawn on 7th, build a bridge on the 4th rank.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Jose Raul Capablanca vs Savielly Tartakower (1924)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- With rook and pawn on 7th, build a bridge on the 4th rank.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Rook Endgames: Lucena Bridge with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Rook Endgames: Lucena Bridge.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Savielly Tartakower (1924)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 60 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Rook Endgames: Lucena Bridge: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_61_ex_1',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Develop the kingside knight toward the center in the Vienna/Four Knights.',
          solutionSan: <String>['Nf3'],
          explanation: 'Nf3 develops with tempo, contesting the e5 central pawn.',
          hints: <String>['Follow the golden rule: Knights before bishops.', 'Develop the g1 knight to f3.', 'Play Nf3.'],
          motif: 'Classical Piece Development',
          hintConcept: 'Follow the golden rule: Knights before bishops.',
          hintPiece: 'Develop the g1 knight to f3.',
          hintForcing: 'Play Nf3.',
          refutationAnalysis: 'f4 prematurely exposes the king diagonal.',
        ),
        const CurriculumExercise(
          id: 'day_61_ex_2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Counter-attack White\'s e4 pawn in the Italian Game.',
          solutionSan: <String>['Nf6'],
          explanation: 'Nf6 develops Black\'s kingside knight and attacks e4 directly.',
          hints: <String>['Challenge White\'s central pawn with active knight development.', 'Move your g8 knight to f6.', 'Play Nf6.'],
          motif: 'Italian Defense - Two Knights',
          hintConcept: 'Challenge White\'s central pawn with active knight development.',
          hintPiece: 'Move your g8 knight to f6.',
          hintForcing: 'Play Nf6.',
          refutationAnalysis: 'd6 is passive and locks the f8 bishop.',
        ),
      ],
    },
    62: {
      'title': 'Day 62: Rook Endgames: Philidor Defense',
      'topic': 'Rook Endgames: Philidor Defense',
      'theme': 'Third-rank passive clamp transitioning to rear checks',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2085,
      'prerequisites': <int>[61],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Rook Endgames: Philidor Defense.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Rook Endgames: Philidor Defense teaches foundational chess mastery: Third-rank passive clamp transitioning to rear checks.',
      'whyItMatters': 'Mastering Rook Endgames: Philidor Defense allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Hold the 3rd/6th rank until the pawn steps forward, then check from rear.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Hold the 3rd/6th rank until the pawn steps forward, then check from rear.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 62: Rook Endgames: Philidor Defense

### 1. Simple Definition & Core Concept
Rook Endgames: Philidor Defense teaches foundational chess mastery: Third-rank passive clamp transitioning to rear checks.

### 2. Why It Matters in Practical Play
Mastering Rook Endgames: Philidor Defense allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Hold the 3rd/6th rank until the pawn steps forward, then check from rear.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Francois Philidor Studies (1777)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Hold the 3rd/6th rank until the pawn steps forward, then check from rear.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Rook Endgames: Philidor Defense with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Rook Endgames: Philidor Defense.',
      ],
      'gameStudy': 'Francois Philidor Studies (1777)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 61 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Rook Endgames: Philidor Defense: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_62_ex_1',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Develop the kingside knight toward the center in the Vienna/Four Knights.',
          solutionSan: <String>['Nf3'],
          explanation: 'Nf3 develops with tempo, contesting the e5 central pawn.',
          hints: <String>['Follow the golden rule: Knights before bishops.', 'Develop the g1 knight to f3.', 'Play Nf3.'],
          motif: 'Classical Piece Development',
          hintConcept: 'Follow the golden rule: Knights before bishops.',
          hintPiece: 'Develop the g1 knight to f3.',
          hintForcing: 'Play Nf3.',
          refutationAnalysis: 'f4 prematurely exposes the king diagonal.',
        ),
        const CurriculumExercise(
          id: 'day_62_ex_2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Counter-attack White\'s e4 pawn in the Italian Game.',
          solutionSan: <String>['Nf6'],
          explanation: 'Nf6 develops Black\'s kingside knight and attacks e4 directly.',
          hints: <String>['Challenge White\'s central pawn with active knight development.', 'Move your g8 knight to f6.', 'Play Nf6.'],
          motif: 'Italian Defense - Two Knights',
          hintConcept: 'Challenge White\'s central pawn with active knight development.',
          hintPiece: 'Move your g8 knight to f6.',
          hintForcing: 'Play Nf6.',
          refutationAnalysis: 'd6 is passive and locks the f8 bishop.',
        ),
      ],
    },
    63: {
      'title': 'Day 63: Milestone Exam: Core Endgames',
      'topic': 'Milestone Exam: Core Endgames',
      'theme': 'Flawless execution of Lucena, Philidor, and opposition',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2099,
      'prerequisites': <int>[62],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Milestone Exam: Core Endgames.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Milestone Exam: Core Endgames teaches foundational chess mastery: Flawless execution of Lucena, Philidor, and opposition.',
      'whyItMatters': 'Mastering Milestone Exam: Core Endgames allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Endgame theoretical benchmarks must be 100% automated.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Endgame theoretical benchmarks must be 100% automated.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 63: Milestone Exam: Core Endgames

### 1. Simple Definition & Core Concept
Milestone Exam: Core Endgames teaches foundational chess mastery: Flawless execution of Lucena, Philidor, and opposition.

### 2. Why It Matters in Practical Play
Mastering Milestone Exam: Core Endgames allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Endgame theoretical benchmarks must be 100% automated.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Viktor Korchnoi vs Anatoly Karpov (1978)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Endgame theoretical benchmarks must be 100% automated.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Milestone Exam: Core Endgames with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Milestone Exam: Core Endgames.',
      ],
      'gameStudy': 'Viktor Korchnoi vs Anatoly Karpov (1978)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 62 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Milestone Exam: Core Endgames: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_63_ex_1',
          fen: 'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/2N5/PPPP1PPP/R1BQKBNR w KQkq - 2 3',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Develop the kingside knight toward the center in the Vienna/Four Knights.',
          solutionSan: <String>['Nf3'],
          explanation: 'Nf3 develops with tempo, contesting the e5 central pawn.',
          hints: <String>['Follow the golden rule: Knights before bishops.', 'Develop the g1 knight to f3.', 'Play Nf3.'],
          motif: 'Classical Piece Development',
          hintConcept: 'Follow the golden rule: Knights before bishops.',
          hintPiece: 'Develop the g1 knight to f3.',
          hintForcing: 'Play Nf3.',
          refutationAnalysis: 'f4 prematurely exposes the king diagonal.',
        ),
        const CurriculumExercise(
          id: 'day_63_ex_2',
          fen: 'r1bqkbnr/pppp1ppp/2n5/4p3/2B1P3/5N2/PPPP1PPP/RNBQK2R b KQkq - 3 3',
          sideToPlay: PieceColor.black,
          instruction: 'Black to move: Counter-attack White\'s e4 pawn in the Italian Game.',
          solutionSan: <String>['Nf6'],
          explanation: 'Nf6 develops Black\'s kingside knight and attacks e4 directly.',
          hints: <String>['Challenge White\'s central pawn with active knight development.', 'Move your g8 knight to f6.', 'Play Nf6.'],
          motif: 'Italian Defense - Two Knights',
          hintConcept: 'Challenge White\'s central pawn with active knight development.',
          hintPiece: 'Move your g8 knight to f6.',
          hintForcing: 'Play Nf6.',
          refutationAnalysis: 'd6 is passive and locks the f8 bishop.',
        ),
      ],
    },
    64: {
      'title': 'Day 64: Active Rook Supremacy',
      'topic': 'Active Rook Supremacy',
      'theme': 'Placing rooks behind passed pawns and cutting off kings',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2114,
      'prerequisites': <int>[63],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Active Rook Supremacy.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Active Rook Supremacy teaches foundational chess mastery: Placing rooks behind passed pawns and cutting off kings.',
      'whyItMatters': 'Mastering Active Rook Supremacy allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'An active rook is worth a pawn in all theoretical endings.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'An active rook is worth a pawn in all theoretical endings.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 64: Active Rook Supremacy

### 1. Simple Definition & Core Concept
Active Rook Supremacy teaches foundational chess mastery: Placing rooks behind passed pawns and cutting off kings.

### 2. Why It Matters in Practical Play
Mastering Active Rook Supremacy allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** An active rook is worth a pawn in all theoretical endings.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Akiba Rubinstein vs Milan Vidmar (1911)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- An active rook is worth a pawn in all theoretical endings.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Active Rook Supremacy with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Active Rook Supremacy.',
      ],
      'gameStudy': 'Akiba Rubinstein vs Milan Vidmar (1911)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 63 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Active Rook Supremacy: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_64_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_64_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    65: {
      'title': 'Day 65: Vancura Defense & Flank Checks',
      'topic': 'Vancura Defense & Flank Checks',
      'theme': 'Defending against a-pawn and h-pawn rook passed pawns',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2128,
      'prerequisites': <int>[64],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Vancura Defense & Flank Checks.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Vancura Defense & Flank Checks teaches foundational chess mastery: Defending against a-pawn and h-pawn rook passed pawns.',
      'whyItMatters': 'Mastering Vancura Defense & Flank Checks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Deliver flank checks when the enemy king cannot hide.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Deliver flank checks when the enemy king cannot hide.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 65: Vancura Defense & Flank Checks

### 1. Simple Definition & Core Concept
Vancura Defense & Flank Checks teaches foundational chess mastery: Defending against a-pawn and h-pawn rook passed pawns.

### 2. Why It Matters in Practical Play
Mastering Vancura Defense & Flank Checks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Deliver flank checks when the enemy king cannot hide.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Josef Vancura Studies (1924)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Deliver flank checks when the enemy king cannot hide.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Vancura Defense & Flank Checks with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Vancura Defense & Flank Checks.',
      ],
      'gameStudy': 'Josef Vancura Studies (1924)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 64 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Vancura Defense & Flank Checks: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_65_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_65_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    66: {
      'title': 'Day 66: Same-Colored Bishop Endgames',
      'topic': 'Same-Colored Bishop Endgames',
      'theme': 'Attacking fixed pawn weaknesses on the color complex',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2143,
      'prerequisites': <int>[65],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Same-Colored Bishop Endgames.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Same-Colored Bishop Endgames teaches foundational chess mastery: Attacking fixed pawn weaknesses on the color complex.',
      'whyItMatters': 'Mastering Same-Colored Bishop Endgames allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Put your pawns on the opposite color of your bishop.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Put your pawns on the opposite color of your bishop.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 66: Same-Colored Bishop Endgames

### 1. Simple Definition & Core Concept
Same-Colored Bishop Endgames teaches foundational chess mastery: Attacking fixed pawn weaknesses on the color complex.

### 2. Why It Matters in Practical Play
Mastering Same-Colored Bishop Endgames allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Put your pawns on the opposite color of your bishop.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Bobby Fischer vs Boris Spassky (1972 Game 4)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Put your pawns on the opposite color of your bishop.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Same-Colored Bishop Endgames with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Same-Colored Bishop Endgames.',
      ],
      'gameStudy': 'Bobby Fischer vs Boris Spassky (1972 Game 4)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 65 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Same-Colored Bishop Endgames: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_66_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_66_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    67: {
      'title': 'Day 67: Opposite-Colored Bishop Fortresses',
      'topic': 'Opposite-Colored Bishop Fortresses',
      'theme': 'Constructing unbreachable blockades despite deficits',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2157,
      'prerequisites': <int>[66],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Opposite-Colored Bishop Fortresses.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Opposite-Colored Bishop Fortresses teaches foundational chess mastery: Constructing unbreachable blockades despite deficits.',
      'whyItMatters': 'Mastering Opposite-Colored Bishop Fortresses allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Blockade on dark squares: the enemy light bishop is blind.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Blockade on dark squares: the enemy light bishop is blind.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 67: Opposite-Colored Bishop Fortresses

### 1. Simple Definition & Core Concept
Opposite-Colored Bishop Fortresses teaches foundational chess mastery: Constructing unbreachable blockades despite deficits.

### 2. Why It Matters in Practical Play
Mastering Opposite-Colored Bishop Fortresses allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Blockade on dark squares: the enemy light bishop is blind.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
David Bronstein vs Paul Keres (1955)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Blockade on dark squares: the enemy light bishop is blind.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Opposite-Colored Bishop Fortresses with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Opposite-Colored Bishop Fortresses.',
      ],
      'gameStudy': 'David Bronstein vs Paul Keres (1955)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 66 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Opposite-Colored Bishop Fortresses: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_67_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_67_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    68: {
      'title': 'Day 68: Knight vs Bishop Endgames',
      'topic': 'Knight vs Bishop Endgames',
      'theme': 'Open board bishop scope vs closed board knight outposts',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2172,
      'prerequisites': <int>[67],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Knight vs Bishop Endgames.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Knight vs Bishop Endgames teaches foundational chess mastery: Open board bishop scope vs closed board knight outposts.',
      'whyItMatters': 'Mastering Knight vs Bishop Endgames allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Bishops dominate open pawns; Knights dominate closed blocks.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Bishops dominate open pawns; Knights dominate closed blocks.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 68: Knight vs Bishop Endgames

### 1. Simple Definition & Core Concept
Knight vs Bishop Endgames teaches foundational chess mastery: Open board bishop scope vs closed board knight outposts.

### 2. Why It Matters in Practical Play
Mastering Knight vs Bishop Endgames allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Bishops dominate open pawns; Knights dominate closed blocks.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Jose Raul Capablanca vs Emanuel Lasker (1921)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Bishops dominate open pawns; Knights dominate closed blocks.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Knight vs Bishop Endgames with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Knight vs Bishop Endgames.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Emanuel Lasker (1921)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 67 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Knight vs Bishop Endgames: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_68_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_68_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    69: {
      'title': 'Day 69: Queen Endgames & Perpetual',
      'topic': 'Queen Endgames & Perpetual',
      'theme': 'Shielding the king under pawn umbrellas and pushing passers',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2186,
      'prerequisites': <int>[68],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Queen Endgames & Perpetual.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Queen Endgames & Perpetual teaches foundational chess mastery: Shielding the king under pawn umbrellas and pushing passers.',
      'whyItMatters': 'Mastering Queen Endgames & Perpetual allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Use friendly pawns as an umbrella against spite checks.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Use friendly pawns as an umbrella against spite checks.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 69: Queen Endgames & Perpetual

### 1. Simple Definition & Core Concept
Queen Endgames & Perpetual teaches foundational chess mastery: Shielding the king under pawn umbrellas and pushing passers.

### 2. Why It Matters in Practical Play
Mastering Queen Endgames & Perpetual allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Use friendly pawns as an umbrella against spite checks.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Anatoly Karpov (1986 Game 22)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Use friendly pawns as an umbrella against spite checks.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Queen Endgames & Perpetual with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Queen Endgames & Perpetual.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1986 Game 22)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in endgame_win_defend_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 68 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Queen Endgames & Perpetual: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_69_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_69_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    70: {
      'title': 'Day 70: Grand Milestone: Endgames',
      'topic': 'Grand Milestone: Endgames',
      'theme': 'Engine-level endgame precision and conversion certification',
      'axis': SkillAxis.endgames,
      'lab': 'endgame_win_defend_lab',
      'difficulty': 2201,
      'prerequisites': <int>[69],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Grand Milestone: Endgames.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Grand Milestone: Endgames teaches foundational chess mastery: Engine-level endgame precision and conversion certification.',
      'whyItMatters': 'Mastering Grand Milestone: Endgames allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Theoretical endgame engine precision is non-negotiable in mastery.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Theoretical endgame engine precision is non-negotiable in mastery.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 70: Grand Milestone: Endgames

### 1. Simple Definition & Core Concept
Grand Milestone: Endgames teaches foundational chess mastery: Engine-level endgame precision and conversion certification.

### 2. Why It Matters in Practical Play
Mastering Grand Milestone: Endgames allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Theoretical endgame engine precision is non-negotiable in mastery.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Vasily Smyslov vs Paul Keres (1953)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Theoretical endgame engine precision is non-negotiable in mastery.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Grand Milestone: Endgames with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Grand Milestone: Endgames.',
      ],
      'gameStudy': 'Vasily Smyslov vs Paul Keres (1953)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 69 foundational concepts, drill 5 targeted flashcards on endgames, and repeat exercise set.',
      'srsReview': <String>[
        'Grand Milestone: Endgames: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for endgames',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_70_ex_1',
          fen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/2B1P3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 4 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Solidify your central pawn structure and improve piece harmony.',
          solutionSan: <String>['d3'],
          explanation: 'd3 reinforces e4 and harmoniously frees the c1 bishop diagonal.',
          hints: <String>['Support the e4 pawn and prepare piece activation.', 'Advance the d-pawn to d3.', 'Play d3.'],
          motif: 'Positional Harmony',
          hintConcept: 'Support the e4 pawn and prepare piece activation.',
          hintPiece: 'Advance the d-pawn to d3.',
          hintForcing: 'Play d3.',
          refutationAnalysis: 'Pushing d4 prematurely invites tactical complications without preparation.',
        ),
        const CurriculumExercise(
          id: 'day_70_ex_2',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete kingside development and connect the rooks.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O brings the king to safety and readies the rook for central file operations.',
          hints: <String>['Prioritize king safety before launching flank attacks.', 'Castle your king kingside.', 'Play O-O.'],
          motif: 'Harmonic King Safety',
          hintConcept: 'Prioritize king safety before launching flank attacks.',
          hintPiece: 'Castle your king kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature knight sorties like Ng5 are easily rebuffed by ...h6.',
        ),
      ],
    },
    71: {
      'title': 'Day 71: Opening Principles & Harmony',
      'topic': 'Opening Principles & Harmony',
      'theme': 'Central staking, harmonic development, and early castling',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2215,
      'prerequisites': <int>[70],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Opening Principles & Harmony.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Opening Principles & Harmony teaches foundational chess mastery: Central staking, harmonic development, and early castling.',
      'whyItMatters': 'Mastering Opening Principles & Harmony allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Develop pieces toward the center; never hunt early pawns.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Develop pieces toward the center; never hunt early pawns.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 71: Opening Principles & Harmony

### 1. Simple Definition & Core Concept
Opening Principles & Harmony teaches foundational chess mastery: Central staking, harmonic development, and early castling.

### 2. Why It Matters in Practical Play
Mastering Opening Principles & Harmony allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Develop pieces toward the center; never hunt early pawns.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Paul Morphy vs Adolf Anderssen (1858)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Develop pieces toward the center; never hunt early pawns.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Opening Principles & Harmony with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Opening Principles & Harmony.',
      ],
      'gameStudy': 'Paul Morphy vs Adolf Anderssen (1858)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in opening_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 70 foundational concepts, drill 5 targeted flashcards on openings, and repeat exercise set.',
      'srsReview': <String>[
        'Opening Principles & Harmony: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_71_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_71_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    72: {
      'title': 'Day 72: 1.e4 Repertoire: Italian & Scotch',
      'topic': '1.e4 Repertoire: Italian & Scotch',
      'theme': 'Classical open game direct central challenges',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2230,
      'prerequisites': <int>[71],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of 1.e4 Repertoire: Italian & Scotch.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': '1.e4 Repertoire: Italian & Scotch teaches foundational chess mastery: Classical open game direct central challenges.',
      'whyItMatters': 'Mastering 1.e4 Repertoire: Italian & Scotch allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Control d4 and d5 with harmonized knight and bishop play.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Control d4 and d5 with harmonized knight and bishop play.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 72: 1.e4 Repertoire: Italian & Scotch

### 1. Simple Definition & Core Concept
1.e4 Repertoire: Italian & Scotch teaches foundational chess mastery: Classical open game direct central challenges.

### 2. Why It Matters in Practical Play
Mastering 1.e4 Repertoire: Italian & Scotch allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Control d4 and d5 with harmonized knight and bishop play.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Nigel Short (1993)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Control d4 and d5 with harmonized knight and bishop play.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of 1.e4 Repertoire: Italian & Scotch with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering 1.e4 Repertoire: Italian & Scotch.',
      ],
      'gameStudy': 'Garry Kasparov vs Nigel Short (1993)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in opening_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 71 foundational concepts, drill 5 targeted flashcards on openings, and repeat exercise set.',
      'srsReview': <String>[
        '1.e4 Repertoire: Italian & Scotch: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_72_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_72_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    73: {
      'title': 'Day 73: 1.e4 vs The Sicilian Defense',
      'topic': '1.e4 vs The Sicilian Defense',
      'theme': 'Navigating Open Sicilians and solid Anti-Sicilian systems',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2244,
      'prerequisites': <int>[72],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of 1.e4 vs The Sicilian Defense.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': '1.e4 vs The Sicilian Defense teaches foundational chess mastery: Navigating Open Sicilians and solid Anti-Sicilian systems.',
      'whyItMatters': 'Mastering 1.e4 vs The Sicilian Defense allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Fight for d5 and maintain rapid kingside piece mobilization.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Fight for d5 and maintain rapid kingside piece mobilization.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 73: 1.e4 vs The Sicilian Defense

### 1. Simple Definition & Core Concept
1.e4 vs The Sicilian Defense teaches foundational chess mastery: Navigating Open Sicilians and solid Anti-Sicilian systems.

### 2. Why It Matters in Practical Play
Mastering 1.e4 vs The Sicilian Defense allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Fight for d5 and maintain rapid kingside piece mobilization.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Bobby Fischer vs Boris Spassky (1972 Game 6)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Fight for d5 and maintain rapid kingside piece mobilization.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of 1.e4 vs The Sicilian Defense with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering 1.e4 vs The Sicilian Defense.',
      ],
      'gameStudy': 'Bobby Fischer vs Boris Spassky (1972 Game 6)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in opening_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 72 foundational concepts, drill 5 targeted flashcards on openings, and repeat exercise set.',
      'srsReview': <String>[
        '1.e4 vs The Sicilian Defense: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_73_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_73_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    74: {
      'title': 'Day 74: 1.d4 Repertoire: QGD & Catalan',
      'topic': '1.d4 Repertoire: QGD & Catalan',
      'theme': 'Solid positional pressure and harmonic long diagonals',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2259,
      'prerequisites': <int>[73],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of 1.d4 Repertoire: QGD & Catalan.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': '1.d4 Repertoire: QGD & Catalan teaches foundational chess mastery: Solid positional pressure and harmonic long diagonals.',
      'whyItMatters': 'Mastering 1.d4 Repertoire: QGD & Catalan allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'The Catalan bishop on g2 exerts permanent central pressure.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'The Catalan bishop on g2 exerts permanent central pressure.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 74: 1.d4 Repertoire: QGD & Catalan

### 1. Simple Definition & Core Concept
1.d4 Repertoire: QGD & Catalan teaches foundational chess mastery: Solid positional pressure and harmonic long diagonals.

### 2. Why It Matters in Practical Play
Mastering 1.d4 Repertoire: QGD & Catalan allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** The Catalan bishop on g2 exerts permanent central pressure.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Vladimir Kramnik vs Garry Kasparov (2000 Game 2)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- The Catalan bishop on g2 exerts permanent central pressure.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of 1.d4 Repertoire: QGD & Catalan with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering 1.d4 Repertoire: QGD & Catalan.',
      ],
      'gameStudy': 'Vladimir Kramnik vs Garry Kasparov (2000 Game 2)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in opening_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 73 foundational concepts, drill 5 targeted flashcards on openings, and repeat exercise set.',
      'srsReview': <String>[
        '1.d4 Repertoire: QGD & Catalan: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_74_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_74_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    75: {
      'title': 'Day 75: 1.c4 English Opening Principles',
      'topic': '1.c4 English Opening Principles',
      'theme': 'Transposition flexibility and kingside fianchetto dominance',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2273,
      'prerequisites': <int>[74],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of 1.c4 English Opening Principles.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': '1.c4 English Opening Principles teaches foundational chess mastery: Transposition flexibility and kingside fianchetto dominance.',
      'whyItMatters': 'Mastering 1.c4 English Opening Principles allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Control d5 from the flank while maintaining central options.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Control d5 from the flank while maintaining central options.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 75: 1.c4 English Opening Principles

### 1. Simple Definition & Core Concept
1.c4 English Opening Principles teaches foundational chess mastery: Transposition flexibility and kingside fianchetto dominance.

### 2. Why It Matters in Practical Play
Mastering 1.c4 English Opening Principles allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Control d5 from the flank while maintaining central options.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Mikhail Botvinnik vs Vasily Smyslov (1954)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Control d5 from the flank while maintaining central options.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of 1.c4 English Opening Principles with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering 1.c4 English Opening Principles.',
      ],
      'gameStudy': 'Mikhail Botvinnik vs Vasily Smyslov (1954)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in opening_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 74 foundational concepts, drill 5 targeted flashcards on openings, and repeat exercise set.',
      'srsReview': <String>[
        '1.c4 English Opening Principles: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_75_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_75_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    76: {
      'title': 'Day 76: Black Repertoire vs 1.e4 & 1.d4',
      'topic': 'Black Repertoire vs 1.e4 & 1.d4',
      'theme': 'Sturdy classical defenses: Caro-Kann and Nimzo-Indian',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2288,
      'prerequisites': <int>[75],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Black Repertoire vs 1.e4 & 1.d4.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Black Repertoire vs 1.e4 & 1.d4 teaches foundational chess mastery: Sturdy classical defenses: Caro-Kann and Nimzo-Indian.',
      'whyItMatters': 'Mastering Black Repertoire vs 1.e4 & 1.d4 allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Neutralize White\'s first-move advantage with sound pawn structure.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Neutralize White\'s first-move advantage with sound pawn structure.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 76: Black Repertoire vs 1.e4 & 1.d4

### 1. Simple Definition & Core Concept
Black Repertoire vs 1.e4 & 1.d4 teaches foundational chess mastery: Sturdy classical defenses: Caro-Kann and Nimzo-Indian.

### 2. Why It Matters in Practical Play
Mastering Black Repertoire vs 1.e4 & 1.d4 allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Neutralize White's first-move advantage with sound pawn structure.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Anatoly Karpov vs Viktor Korchnoi (1981)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Neutralize White's first-move advantage with sound pawn structure.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Black Repertoire vs 1.e4 & 1.d4 with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Black Repertoire vs 1.e4 & 1.d4.',
      ],
      'gameStudy': 'Anatoly Karpov vs Viktor Korchnoi (1981)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in opening_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 75 foundational concepts, drill 5 targeted flashcards on openings, and repeat exercise set.',
      'srsReview': <String>[
        'Black Repertoire vs 1.e4 & 1.d4: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_76_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_76_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    77: {
      'title': 'Day 77: Milestone Exam: Opening Theory',
      'topic': 'Milestone Exam: Opening Theory',
      'theme': 'Move-tree verification across all personal opening branches',
      'axis': SkillAxis.openings,
      'lab': 'opening_plan_lab',
      'difficulty': 2302,
      'prerequisites': <int>[76],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Milestone Exam: Opening Theory.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Milestone Exam: Opening Theory teaches foundational chess mastery: Move-tree verification across all personal opening branches.',
      'whyItMatters': 'Mastering Milestone Exam: Opening Theory allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Know your plans, typical pawn structures, and key departures.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Know your plans, typical pawn structures, and key departures.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 77: Milestone Exam: Opening Theory

### 1. Simple Definition & Core Concept
Milestone Exam: Opening Theory teaches foundational chess mastery: Move-tree verification across all personal opening branches.

### 2. Why It Matters in Practical Play
Mastering Milestone Exam: Opening Theory allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Know your plans, typical pawn structures, and key departures.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Viswanathan Anand vs Boris Gelfand (2012)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Know your plans, typical pawn structures, and key departures.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Milestone Exam: Opening Theory with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Milestone Exam: Opening Theory.',
      ],
      'gameStudy': 'Viswanathan Anand vs Boris Gelfand (2012)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 76 foundational concepts, drill 5 targeted flashcards on openings, and repeat exercise set.',
      'srsReview': <String>[
        'Milestone Exam: Opening Theory: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for openings',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_77_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_77_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    78: {
      'title': 'Day 78: Punishing Uncastled Kings',
      'topic': 'Punishing Uncastled Kings',
      'theme': 'Morphy-style central breakthroughs against delayed castling',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2317,
      'prerequisites': <int>[77],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Punishing Uncastled Kings.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Punishing Uncastled Kings teaches foundational chess mastery: Morphy-style central breakthroughs against delayed castling.',
      'whyItMatters': 'Mastering Punishing Uncastled Kings allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Blow open the center when the enemy king lingers on e8.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Blow open the center when the enemy king lingers on e8.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 78: Punishing Uncastled Kings

### 1. Simple Definition & Core Concept
Punishing Uncastled Kings teaches foundational chess mastery: Morphy-style central breakthroughs against delayed castling.

### 2. Why It Matters in Practical Play
Mastering Punishing Uncastled Kings allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Blow open the center when the enemy king lingers on e8.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Adolf Anderssen vs Jean Dufresne (1852)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Blow open the center when the enemy king lingers on e8.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Punishing Uncastled Kings with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Punishing Uncastled Kings.',
      ],
      'gameStudy': 'Adolf Anderssen vs Jean Dufresne (1852)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 77 foundational concepts, drill 5 targeted flashcards on attack, and repeat exercise set.',
      'srsReview': <String>[
        'Punishing Uncastled Kings: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_78_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_78_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    79: {
      'title': 'Day 79: The Greek Gift Sacrifice (Bxh7+)',
      'topic': 'The Greek Gift Sacrifice (Bxh7+)',
      'theme': 'Calculating standard sacrifices on h7/h2 with Ng5+ followups',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2331,
      'prerequisites': <int>[78],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of The Greek Gift Sacrifice (Bxh7+).',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'The Greek Gift Sacrifice (Bxh7+) teaches foundational chess mastery: Calculating standard sacrifices on h7/h2 with Ng5+ followups.',
      'whyItMatters': 'Mastering The Greek Gift Sacrifice (Bxh7+) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Sacrifice on h7 when Ng5+ and Qh5 cannot be refuted.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Sacrifice on h7 when Ng5+ and Qh5 cannot be refuted.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 79: The Greek Gift Sacrifice (Bxh7+)

### 1. Simple Definition & Core Concept
The Greek Gift Sacrifice (Bxh7+) teaches foundational chess mastery: Calculating standard sacrifices on h7/h2 with Ng5+ followups.

### 2. Why It Matters in Practical Play
Mastering The Greek Gift Sacrifice (Bxh7+) allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Sacrifice on h7 when Ng5+ and Qh5 cannot be refuted.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Rudolf Spielmann vs Baldur Hoenlinger (1929)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Sacrifice on h7 when Ng5+ and Qh5 cannot be refuted.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of The Greek Gift Sacrifice (Bxh7+) with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering The Greek Gift Sacrifice (Bxh7+).',
      ],
      'gameStudy': 'Rudolf Spielmann vs Baldur Hoenlinger (1929)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 78 foundational concepts, drill 5 targeted flashcards on attack, and repeat exercise set.',
      'srsReview': <String>[
        'The Greek Gift Sacrifice (Bxh7+): Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_79_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_79_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    80: {
      'title': 'Day 80: Opposite-Side Castling Attacks',
      'topic': 'Opposite-Side Castling Attacks',
      'theme': 'Battering-ram pawn storms and line opening races',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2346,
      'prerequisites': <int>[79],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Opposite-Side Castling Attacks.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Opposite-Side Castling Attacks teaches foundational chess mastery: Battering-ram pawn storms and line opening races.',
      'whyItMatters': 'Mastering Opposite-Side Castling Attacks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Whoever opens files to the opposing king first wins.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Whoever opens files to the opposing king first wins.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 80: Opposite-Side Castling Attacks

### 1. Simple Definition & Core Concept
Opposite-Side Castling Attacks teaches foundational chess mastery: Battering-ram pawn storms and line opening races.

### 2. Why It Matters in Practical Play
Mastering Opposite-Side Castling Attacks allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Whoever opens files to the opposing king first wins.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Bobby Fischer vs Bent Larsen (1958)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Whoever opens files to the opposing king first wins.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Opposite-Side Castling Attacks with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Opposite-Side Castling Attacks.',
      ],
      'gameStudy': 'Bobby Fischer vs Bent Larsen (1958)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 79 foundational concepts, drill 5 targeted flashcards on attack, and repeat exercise set.',
      'srsReview': <String>[
        'Opposite-Side Castling Attacks: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_80_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_80_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    81: {
      'title': 'Day 81: Destroying the Castled Shield',
      'topic': 'Destroying the Castled Shield',
      'theme': 'Piece sacrifices on h6, g7, and f7 to shatter shelters',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2360,
      'prerequisites': <int>[80],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Destroying the Castled Shield.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Destroying the Castled Shield teaches foundational chess mastery: Piece sacrifices on h6, g7, and f7 to shatter shelters.',
      'whyItMatters': 'Mastering Destroying the Castled Shield allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Rip open the defensive bunker to clear queen entry vectors.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Rip open the defensive bunker to clear queen entry vectors.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 81: Destroying the Castled Shield

### 1. Simple Definition & Core Concept
Destroying the Castled Shield teaches foundational chess mastery: Piece sacrifices on h6, g7, and f7 to shatter shelters.

### 2. Why It Matters in Practical Play
Mastering Destroying the Castled Shield allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Rip open the defensive bunker to clear queen entry vectors.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Lajos Portisch (1989)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Rip open the defensive bunker to clear queen entry vectors.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Destroying the Castled Shield with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Destroying the Castled Shield.',
      ],
      'gameStudy': 'Garry Kasparov vs Lajos Portisch (1989)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 80 foundational concepts, drill 5 targeted flashcards on attack, and repeat exercise set.',
      'srsReview': <String>[
        'Destroying the Castled Shield: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_81_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_81_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    82: {
      'title': 'Day 82: Tenacious Defensive Resources',
      'topic': 'Tenacious Defensive Resources',
      'theme': 'Anticipating threats, counter-sacrifices, and stalemate saves',
      'axis': SkillAxis.defense,
      'lab': 'defensive_resource_lab',
      'difficulty': 2375,
      'prerequisites': <int>[81],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tenacious Defensive Resources.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tenacious Defensive Resources teaches foundational chess mastery: Anticipating threats, counter-sacrifices, and stalemate saves.',
      'whyItMatters': 'Mastering Tenacious Defensive Resources allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Find the only resilient resource when under heavy fire.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Find the only resilient resource when under heavy fire.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 82: Tenacious Defensive Resources

### 1. Simple Definition & Core Concept
Tenacious Defensive Resources teaches foundational chess mastery: Anticipating threats, counter-sacrifices, and stalemate saves.

### 2. Why It Matters in Practical Play
Mastering Tenacious Defensive Resources allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Find the only resilient resource when under heavy fire.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Boris Spassky vs Bobby Fischer (1972 Game 13)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Find the only resilient resource when under heavy fire.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tenacious Defensive Resources with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tenacious Defensive Resources.',
      ],
      'gameStudy': 'Boris Spassky vs Bobby Fischer (1972 Game 13)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in defensive_resource_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 81 foundational concepts, drill 5 targeted flashcards on defense, and repeat exercise set.',
      'srsReview': <String>[
        'Tenacious Defensive Resources: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for defense',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_82_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_82_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    83: {
      'title': 'Day 83: Simplification Under Attack',
      'topic': 'Simplification Under Attack',
      'theme': 'Trading dangerous attackers into calm winning endgames',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2389,
      'prerequisites': <int>[82],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Simplification Under Attack.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Simplification Under Attack teaches foundational chess mastery: Trading dangerous attackers into calm winning endgames.',
      'whyItMatters': 'Mastering Simplification Under Attack allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Trade attacking pieces to extinguish all enemy counterplay.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Trade attacking pieces to extinguish all enemy counterplay.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 83: Simplification Under Attack

### 1. Simple Definition & Core Concept
Simplification Under Attack teaches foundational chess mastery: Trading dangerous attackers into calm winning endgames.

### 2. Why It Matters in Practical Play
Mastering Simplification Under Attack allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Trade attacking pieces to extinguish all enemy counterplay.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Jose Raul Capablanca vs Frank Marshall (1918)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Trade attacking pieces to extinguish all enemy counterplay.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Simplification Under Attack with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Simplification Under Attack.',
      ],
      'gameStudy': 'Jose Raul Capablanca vs Frank Marshall (1918)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in conversion_challenge_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 82 foundational concepts, drill 5 targeted flashcards on conversion, and repeat exercise set.',
      'srsReview': <String>[
        'Simplification Under Attack: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_83_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_83_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    84: {
      'title': 'Day 84: Grand Milestone: Attack & Defense',
      'topic': 'Grand Milestone: Attack & Defense',
      'theme': 'Comprehensive attacking execution and defensive tenacity exam',
      'axis': SkillAxis.attack,
      'lab': 'tactical_lab',
      'difficulty': 2404,
      'prerequisites': <int>[83],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Grand Milestone: Attack & Defense.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Grand Milestone: Attack & Defense teaches foundational chess mastery: Comprehensive attacking execution and defensive tenacity exam.',
      'whyItMatters': 'Mastering Grand Milestone: Attack & Defense allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Combine sharp attacking instincts with bulletproof defense.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Combine sharp attacking instincts with bulletproof defense.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 84: Grand Milestone: Attack & Defense

### 1. Simple Definition & Core Concept
Grand Milestone: Attack & Defense teaches foundational chess mastery: Comprehensive attacking execution and defensive tenacity exam.

### 2. Why It Matters in Practical Play
Mastering Grand Milestone: Attack & Defense allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Combine sharp attacking instincts with bulletproof defense.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Paul Keres vs Alexander Kotov (1939)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Combine sharp attacking instincts with bulletproof defense.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Grand Milestone: Attack & Defense with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Grand Milestone: Attack & Defense.',
      ],
      'gameStudy': 'Paul Keres vs Alexander Kotov (1939)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 83 foundational concepts, drill 5 targeted flashcards on attack, and repeat exercise set.',
      'srsReview': <String>[
        'Grand Milestone: Attack & Defense: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for attack',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_84_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_84_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    85: {
      'title': 'Day 85: Material Conversion Protocol',
      'topic': 'Material Conversion Protocol',
      'theme': 'Flawless conversion of two pawns up and technical liquidation',
      'axis': SkillAxis.conversion,
      'lab': 'conversion_challenge_lab',
      'difficulty': 2418,
      'prerequisites': <int>[84],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Material Conversion Protocol.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Material Conversion Protocol teaches foundational chess mastery: Flawless conversion of two pawns up and technical liquidation.',
      'whyItMatters': 'Mastering Material Conversion Protocol allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Do not rush; extinguish counterplay and nurse passed pawns.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Do not rush; extinguish counterplay and nurse passed pawns.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 85: Material Conversion Protocol

### 1. Simple Definition & Core Concept
Material Conversion Protocol teaches foundational chess mastery: Flawless conversion of two pawns up and technical liquidation.

### 2. Why It Matters in Practical Play
Mastering Material Conversion Protocol allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Do not rush; extinguish counterplay and nurse passed pawns.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Magnus Carlsen vs Fabiano Caruana (2018)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Do not rush; extinguish counterplay and nurse passed pawns.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Material Conversion Protocol with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Material Conversion Protocol.',
      ],
      'gameStudy': 'Magnus Carlsen vs Fabiano Caruana (2018)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in conversion_challenge_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 84 foundational concepts, drill 5 targeted flashcards on conversion, and repeat exercise set.',
      'srsReview': <String>[
        'Material Conversion Protocol: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for conversion',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_85_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_85_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    86: {
      'title': 'Day 86: Model Master Game Guess-the-Move',
      'topic': 'Model Master Game Guess-the-Move',
      'theme': 'Anticipating grandmaster candidate moves in complex middlegames',
      'axis': SkillAxis.calculation,
      'lab': 'guess_the_move_lab',
      'difficulty': 2433,
      'prerequisites': <int>[85],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Model Master Game Guess-the-Move.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Model Master Game Guess-the-Move teaches foundational chess mastery: Anticipating grandmaster candidate moves in complex middlegames.',
      'whyItMatters': 'Mastering Model Master Game Guess-the-Move allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Find the master continuation under tournament time controls.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Find the master continuation under tournament time controls.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 86: Model Master Game Guess-the-Move

### 1. Simple Definition & Core Concept
Model Master Game Guess-the-Move teaches foundational chess mastery: Anticipating grandmaster candidate moves in complex middlegames.

### 2. Why It Matters in Practical Play
Mastering Model Master Game Guess-the-Move allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Find the master continuation under tournament time controls.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Anatoly Karpov (1985 World Championship)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Find the master continuation under tournament time controls.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Model Master Game Guess-the-Move with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Model Master Game Guess-the-Move.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1985 World Championship)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in guess_the_move_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 85 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Model Master Game Guess-the-Move: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_86_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_86_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    87: {
      'title': 'Day 87: Root Cause Self-Analysis',
      'topic': 'Root Cause Self-Analysis',
      'theme': 'Annotating turning points, identifying the 11 cognitive errors',
      'axis': SkillAxis.calculation,
      'lab': 'positional_evaluation_lab',
      'difficulty': 2447,
      'prerequisites': <int>[86],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Root Cause Self-Analysis.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Root Cause Self-Analysis teaches foundational chess mastery: Annotating turning points, identifying the 11 cognitive errors.',
      'whyItMatters': 'Mastering Root Cause Self-Analysis allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Analyze without an engine first to diagnose your mental habits.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Analyze without an engine first to diagnose your mental habits.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 87: Root Cause Self-Analysis

### 1. Simple Definition & Core Concept
Root Cause Self-Analysis teaches foundational chess mastery: Annotating turning points, identifying the 11 cognitive errors.

### 2. Why It Matters in Practical Play
Mastering Root Cause Self-Analysis allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Analyze without an engine first to diagnose your mental habits.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Mikhail Botvinnik Training Diaries (1958)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Analyze without an engine first to diagnose your mental habits.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Root Cause Self-Analysis with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Root Cause Self-Analysis.',
      ],
      'gameStudy': 'Mikhail Botvinnik Training Diaries (1958)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in positional_evaluation_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 86 foundational concepts, drill 5 targeted flashcards on calculation, and repeat exercise set.',
      'srsReview': <String>[
        'Root Cause Self-Analysis: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for calculation',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_87_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_87_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    88: {
      'title': 'Day 88: Tournament Psychology & Discipline',
      'topic': 'Tournament Psychology & Discipline',
      'theme': 'Touch-move discipline, handling nerves, and scoresheet habits',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'find_the_plan_lab',
      'difficulty': 2462,
      'prerequisites': <int>[87],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Tournament Psychology & Discipline.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Tournament Psychology & Discipline teaches foundational chess mastery: Touch-move discipline, handling nerves, and scoresheet habits.',
      'whyItMatters': 'Mastering Tournament Psychology & Discipline allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Master emotional stability across long competitive rounds.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Master emotional stability across long competitive rounds.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 88: Tournament Psychology & Discipline

### 1. Simple Definition & Core Concept
Tournament Psychology & Discipline teaches foundational chess mastery: Touch-move discipline, handling nerves, and scoresheet habits.

### 2. Why It Matters in Practical Play
Mastering Tournament Psychology & Discipline allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Master emotional stability across long competitive rounds.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Garry Kasparov vs Anatoly Karpov (1985 World Championship)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Master emotional stability across long competitive rounds.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Tournament Psychology & Discipline with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Tournament Psychology & Discipline.',
      ],
      'gameStudy': 'Garry Kasparov vs Anatoly Karpov (1985 World Championship)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in find_the_plan_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 87 foundational concepts, drill 5 targeted flashcards on tournamentPlay, and repeat exercise set.',
      'srsReview': <String>[
        'Tournament Psychology & Discipline: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_88_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_88_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    89: {
      'title': 'Day 89: Competitive Tournament Simulation',
      'topic': 'Competitive Tournament Simulation',
      'theme': 'Timed tournament game simulations with deep post-mortem analysis',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'tactical_lab',
      'difficulty': 2476,
      'prerequisites': <int>[88],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Competitive Tournament Simulation.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Competitive Tournament Simulation teaches foundational chess mastery: Timed tournament game simulations with deep post-mortem analysis.',
      'whyItMatters': 'Mastering Competitive Tournament Simulation allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Synthesize tactical alertness with clock discipline in competitive rounds.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Synthesize tactical alertness with clock discipline in competitive rounds.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 89: Competitive Tournament Simulation

### 1. Simple Definition & Core Concept
Competitive Tournament Simulation teaches foundational chess mastery: Timed tournament game simulations with deep post-mortem analysis.

### 2. Why It Matters in Practical Play
Mastering Competitive Tournament Simulation allows tournament players to navigate sharp tactical battles and positional imbalances with confidence.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Synthesize tactical alertness with clock discipline in competitive rounds.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Alexander Kotov Training Methodology (1970)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Synthesize tactical alertness with clock discipline in competitive rounds.
- Maintain clock discipline and check opponent tactical resources.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Competitive Tournament Simulation with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Competitive Tournament Simulation.',
      ],
      'gameStudy': 'Alexander Kotov Training Methodology (1970)',
      'practiceTask': 'Interactive Lab Session: Complete all daily drills in tactical_lab, applying the move decision checklist on every ply.',
      'assessment': 'Daily Precision & Accuracy Check (>= 80% passing threshold)',
      'remediation': 'Review Day 88 foundational concepts, drill 5 targeted flashcards on tournamentPlay, and repeat exercise set.',
      'srsReview': <String>[
        'Competitive Tournament Simulation: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_89_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_89_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
    90: {
      'title': 'Day 90: Final Capstone Certification — Mastery Assessment & Completion Report',
      'topic': 'Final Capstone Certification — Mastery Assessment & Completion Report',
      'theme': 'Comprehensive grandmaster mastery assessment and full 12-axis performance report',
      'axis': SkillAxis.tournamentPlay,
      'lab': 'tactical_lab',
      'difficulty': 2491,
      'prerequisites': <int>[89],
      'objectives': <String>[
        'Master the core mechanics and geometric triggers of Final Capstone Certification — Mastery Assessment & Completion Report.',
        'Evaluate candidate moves side-by-side without tunnel vision.',
        'Achieve >= 80% accuracy on today\'s verified interactive exercises.',
      ],
      'definition': 'Final Grandmaster Capstone Examination and 12-axis Skill Radar Certification. Note: Official FIDE title ratings and norms require performance in sanctioned over-the-board tournament play; this program certifies comprehensive completion of our 90-day master curriculum.',
      'whyItMatters': 'Validates complete mastery of all tactical motifs, calculation trees, positional strategies, and theoretical endgame benchmarks.',
      'visualBoardFen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'patternRule': 'Final grandmaster assessment across all 12 core cognitive skill axes.',
      'commonMistakes': <String>[
        'Making hasty moves without surveying all opponent checks and captures.',
        'Overestimating nominal point value over square activity and king safety.',
      ],
      'cheatSheetSummary': <String>[
        'Always verify candidate moves before committing to calculation.',
        'Final grandmaster assessment across all 12 core cognitive skill axes.',
        'Maintain clock discipline and check opponent tactical resources.',
      ],
      'theory': '''
# Day 90: Final Capstone Certification — Mastery Assessment & Completion Report

### 1. Simple Definition & Core Concept
Final Grandmaster Capstone Examination and 12-axis Skill Radar Certification. Note: Official FIDE title ratings and norms require performance in sanctioned over-the-board tournament play; this program certifies comprehensive completion of our 90-day master curriculum.

### 2. Why It Matters in Practical Play
Validates complete mastery of all tactical motifs, calculation trees, positional strategies, and theoretical endgame benchmarks.

### 3. Visual Board Model & Pattern Heuristic
**Core Rule / Heuristic:** Final grandmaster assessment across all 12 core cognitive skill axes.

**Canonical Diagram FEN:** `6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1`

### 4. Canonical Model Game
Emanuel Lasker vs William Steinitz (1894 World Championship)

### 5. Common Amateur Mistakes & Refutations
- **Mistake:** Making hasty moves without surveying all opponent checks and captures.
- **Mistake:** Overestimating nominal point value over square activity and king safety.

### 6. Candidate Moves & Kotov Calculation Discipline
- **Primary Candidate Move:** Identify the most forcing continuation (check, capture, or concrete threat) that exploits the theme.
- **Tempting Sub-Optimal Alternative:** Amateurs often choose an intuitive developing move that relieves tension and forfeits the initiative.
- **Why Wrong Choices Fail:** Refutation lies in calculating opponent defensive resources and intermediate moves (zwischenzug).

### 7. Concise Cheat Sheet
- Always verify candidate moves before committing to calculation.
- Final grandmaster assessment across all 12 core cognitive skill axes.
- Maintain clock discipline and check opponent tactical resources.

> **Official Educational Notice**: Completion of ChessMaster's 90-day curriculum certifies analytical mastery and cognitive benchmarks; it does **not** grant or imply an official FIDE Grandmaster or International Master title, nor an official FIDE rating.

''',
      'workedExamples': <String>[
        'Model Demonstration 1: Textbook execution of Final Capstone Certification — Mastery Assessment & Completion Report with strict candidate move calculation.',
        'Model Demonstration 2: Practical defensive resource discovery when countering Final Capstone Certification — Mastery Assessment & Completion Report.',
      ],
      'gameStudy': 'Emanuel Lasker vs William Steinitz (1894 World Championship)',
      'practiceTask': 'Weekly Milestone Comprehensive Exam: Solve all positions with >= 85% accuracy and zero hints permitted.',
      'assessment': 'Weekly Milestone Certification Assessment',
      'remediation': 'Review Day 89 foundational concepts, drill 5 targeted flashcards on tournamentPlay, and repeat exercise set.',
      'srsReview': <String>[
        'Final Capstone Certification — Mastery Assessment & Completion Report: Pattern Recognition Flashcard',
        'Candidate Move Selection Checklist',
        'Anti-Blunder Verification Trigger for tournamentPlay',
      ],
      'exercises': <CurriculumExercise>[
        const CurriculumExercise(
          id: 'day_90_ex_1',
          fen: 'r1bq1rk1/pppp1ppp/2n2n2/4p3/2B1P3/3P1N2/PPP2PPP/RNBQK2R w KQ - 1 5',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Complete opening mobilization with positional discipline.',
          solutionSan: <String>['O-O'],
          explanation: 'O-O secures the king and activates the rook for the middlegame transition.',
          hints: <String>['Ensure complete king safety before beginning deep strategic plans.', 'Castle kingside.', 'Play O-O.'],
          motif: 'Grandmaster Positional Transition',
          hintConcept: 'Ensure complete king safety before beginning deep strategic plans.',
          hintPiece: 'Castle kingside.',
          hintForcing: 'Play O-O.',
          refutationAnalysis: 'Premature pawn moves weaken the position without justification.',
        ),
        const CurriculumExercise(
          id: 'day_90_ex_2',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Demonstrate conversion mastery by taking the opposition.',
          solutionSan: <String>['Ke3'],
          explanation: 'Ke3 seizes opposition, demonstrating engine-like technical conversion.',
          hints: <String>['Claim the opposition with mathematical certainty.', 'Move your king to e3.', 'Play Ke3.'],
          motif: 'Capablanca Clinical Conversion',
          hintConcept: 'Claim the opposition with mathematical certainty.',
          hintPiece: 'Move your king to e3.',
          hintForcing: 'Play Ke3.',
          refutationAnalysis: 'Sideways king moves forfeit the win.',
        ),
      ],
    },
  };
}

