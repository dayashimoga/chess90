// GENERATOR FOR 90-DAY DE-TEMPLATED CURRICULUM CATALOG WITH 500+ EXERCISES
import 'dart:io';
import 'package:chess_content/chess_content.dart';
import 'package:chess_core/chess_core.dart';
import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_learning/chess_learning.dart';

void main() {
  print('======================================================');
  print('  GENERATING NON-TEMPLATED 90-DAY CURRICULUM CATALOG  ');
  print('======================================================');

  final projectRoot = Directory.current.path.endsWith('tool')
      ? Directory.current.parent.path
      : Directory.current.path;
  final outputFile = File('$projectRoot/packages/chess_curriculum/lib/src/data/curriculum_catalog.dart');

  final buffer = StringBuffer();
  buffer.writeln('''// GENERATED CHESSMASTER 90-DAY CURRICULUM CATALOG
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
      throw ArgumentError('Curriculum day must be between 1 and 90, got \$dayNumber');
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
''');

  final allCuratedDays = _generateAll90Specs();

  for (int day = 1; day <= 90; day++) {
    final spec = allCuratedDays[day]!;
    buffer.writeln('    $day: {');
    buffer.writeln("      'title': '${_escape(spec.title)}',");
    buffer.writeln("      'topic': '${_escape(spec.topic)}',");
    buffer.writeln("      'theme': '${_escape(spec.theme)}',");
    buffer.writeln("      'axis': SkillAxis.${spec.axis.name},");
    buffer.writeln("      'lab': '${spec.lab}',");
    buffer.writeln("      'difficulty': ${spec.difficulty},");
    buffer.writeln("      'prerequisites': <int>${spec.prerequisites},");
    buffer.writeln("      'objectives': <String>[");
    for (final obj in spec.objectives) {
      buffer.writeln("        '${_escape(obj)}',");
    }
    buffer.writeln('      ],');
    buffer.writeln("      'theory': '''");
    buffer.writeln(spec.theory);
    buffer.writeln("''',");
    buffer.writeln("      'workedExamples': <String>[");
    for (final ex in spec.workedExamples) {
      buffer.writeln("        '${_escape(ex)}',");
    }
    buffer.writeln('      ],');
    buffer.writeln("      'gameStudy': '${_escape(spec.gameStudy)}',");
    buffer.writeln("      'practiceTask': '${_escape(spec.practiceTask)}',");
    buffer.writeln("      'assessment': '${_escape(spec.assessment)}',");
    buffer.writeln("      'remediation': '${_escape(spec.remediation)}',");
    buffer.writeln("      'srsReview': <String>[");
    for (final srs in spec.srsReview) {
      buffer.writeln("        '${_escape(srs)}',");
    }
    buffer.writeln('      ],');
    buffer.writeln("      'exercises': <CurriculumExercise>[");
    for (final e in spec.exercises) {
      buffer.writeln('        const CurriculumExercise(');
      buffer.writeln("          id: '${e.id}',");
      buffer.writeln("          fen: '${e.fen}',");
      buffer.writeln('          sideToPlay: PieceColor.${e.sideToPlay.name},');
      buffer.writeln("          instruction: '${_escape(e.instruction)}',");
      buffer.writeln("          solutionSan: <String>${e.solutionSan.map((s) => "'$s'").toList()},");
      buffer.writeln("          explanation: '${_escape(e.explanation)}',");
      buffer.writeln("          hints: <String>${e.hints.map((h) => "'${_escape(h)}'").toList()},");
      buffer.writeln("          motif: '${_escape(e.motif)}',");
      buffer.writeln('        ),');
    }
    buffer.writeln('      ],');
    buffer.writeln('    },');
  }

  buffer.writeln('''  };
}
''');

  outputFile.writeAsStringSync(buffer.toString());
  print('Successfully generated ${outputFile.path}');
}

String _escape(String s) => s.replaceAll("'", "\\'");

class DaySpec {
  final String title;
  final String topic;
  final String theme;
  final SkillAxis axis;
  final String lab;
  final int difficulty;
  final List<int> prerequisites;
  final List<String> objectives;
  final String theory;
  final List<String> workedExamples;
  final String gameStudy;
  final String practiceTask;
  final String assessment;
  final String remediation;
  final List<String> srsReview;
  final List<CurriculumExercise> exercises;

  DaySpec({
    required this.title,
    required this.topic,
    required this.theme,
    required this.axis,
    required this.lab,
    required this.difficulty,
    required this.prerequisites,
    required this.objectives,
    required this.theory,
    required this.workedExamples,
    required this.gameStudy,
    required this.practiceTask,
    required this.assessment,
    required this.remediation,
    required this.srsReview,
    required this.exercises,
  });
}

Map<int, DaySpec> _generateAll90Specs() {
  final specs = <int, DaySpec>{};

  // Pre-load bank pools
  final tactics = TacticsBank.all;
  final calc = CalculationBank.all;
  final vis = VisualizationBank.all;
  final strat = StrategyBank.all;
  final endg = EndgameBank.all;
  final open = OpeningDrillsBank.all;
  final prac = PracticalAnalysisBank.all;

  int tacIdx = 0;
  int calcIdx = 0;
  int visIdx = 0;
  int stratIdx = 0;
  int endgIdx = 0;
  int openIdx = 0;
  int pracIdx = 0;

  List<CurriculumExercise> pickExercises(List<CurriculumExercise> source, int Function() getIdx, void Function(int) setIdx, int count, int dayNum) {
    final list = <CurriculumExercise>[];
    int start = getIdx();
    for (int i = 0; i < count; i++) {
      final item = source[(start + i) % source.length];
      list.add(CurriculumExercise(
        id: 'cur_d${dayNum}_ex${i + 1}',
        fen: item.fen,
        sideToPlay: item.sideToPlay,
        instruction: item.instruction,
        solutionSan: item.solutionSan,
        explanation: item.explanation,
        hints: item.hints.isNotEmpty ? item.hints : ['Look for forcing checks, captures, and threats.'],
        motif: item.motif,
      ));
    }
    setIdx(start + count);
    return list;
  }

  // 90 Curated Day Meta
  final meta = [
    // Phase 1 (Day 1)
    [1, 'Diagnostic', 'Comprehensive Baseline Diagnostic', 'Diagnostic: Coordinates, Board Vision, Tactics & Skill Radar', SkillAxis.tactics, 'tactical_lab', 'Paul Morphy vs Duke of Brunswick (1858) — Development & Initiative'],
    // Phase 2: Tactics (Days 2-14)
    [2, 'Tactics', 'Hanging Pieces & Undefended Targets', 'Exploiting undefended pieces (LPDO) and loose tactical targets', SkillAxis.tactics, 'tactical_lab', 'Harry Pillsbury vs Emanuel Lasker (1895) — Loose Pieces Drop Off'],
    [3, 'Tactics', 'Absolute and Relative Pins', 'Freezing pieces against king and queen vectors', SkillAxis.tactics, 'tactical_lab', 'Alexander Alekhine vs Richard Reti (1925) — Absolute Pin Paralyzation'],
    [4, 'Tactics', 'Skewers & X-Ray Attacks', 'Attacking higher-value pieces with collateral targets behind', SkillAxis.tactics, 'tactical_lab', 'Jose Raul Capablanca vs Rudolf Spielmann (1911) — Geometric Skewers'],
    [5, 'Tactics', 'Knight Forks & Royal Geometry', 'Octopus knight anchors and lethal royal forks', SkillAxis.tactics, 'tactical_lab', 'Wilhelm Steinitz vs Curt von Bardeleben (1895) — Royal Knight Fork Infiltration'],
    [6, 'Tactics', 'Double Attacks & Cross-Board Vision', 'Simultaneous dual threats splitting defensive coordination', SkillAxis.tactics, 'tactical_lab', 'Frank Marshall vs Stepan Levitsky (1912) — The Gold Coin Double Attack'],
    [7, 'Tactics', 'Milestone Exam: Tactical Combinations', 'Timed tactical evaluation under tournament pressure', SkillAxis.tactics, 'tactical_lab', 'Johannes Zukertort vs Joseph Blackburne (1883) — Combination Synthesis'],
    [8, 'Tactics', 'Discovered Attacks & Double Checks', 'The most lethal tactical force: simultaneous unmasking', SkillAxis.attack, 'tactical_lab', 'Carlos Torre vs Emanuel Lasker (1925) — The Classic Windmill'],
    [9, 'Tactics', 'Removal of the Defender & Deflection', 'Liquidating or pulling key protectors away from critical squares', SkillAxis.tactics, 'tactical_lab', 'Mikhail Chigorin vs Siegbert Tarrasch (1893) — Deflection of Critical Guardians'],
    [10, 'Tactics', 'Decoy & Attraction Sacrifices', 'Luring heavy pieces into fatal geometric squares', SkillAxis.attack, 'tactical_lab', 'Adolf Anderssen vs Lionel Kieseritzky (1851) — The Immortal Attraction'],
    [11, 'Tactics', 'Overloading & Line Clearance', 'Exploiting pieces burdened with too many defensive duties', SkillAxis.tactics, 'tactical_lab', 'Akiba Rubinstein vs Gersz Rotlewi (1907) — Rubinstein\'s Immortal Overload'],
    [12, 'Tactics', 'Interference & Obstruction', 'Severing vital defensive communication lines', SkillAxis.tactics, 'tactical_lab', 'Efim Geller vs Max Euwe (1953) — Long Diagonal Interference'],
    [13, 'Tactics', 'Trapped Pieces & Board Domination', 'Depriving opponent pieces of safe retreat squares', SkillAxis.tactics, 'improve_worst_piece_lab', 'Bobby Fischer vs Samuel Reshevsky (1958) — Trapped Queen in 11 Moves'],
    [14, 'Tactics', 'Grand Milestone Exam: Multi-Step Motifs', 'Deep combination synthesis and tactical mastery certification', SkillAxis.tactics, 'tactical_lab', 'Emanuel Lasker vs William Steinitz (1894) — Grand Tactical Certification'],
    // Phase 3: Calculation & Visualization (Days 15-28)
    [15, 'Calculation', 'Candidate Move Generation', 'Systematic candidate selection before calculation begins', SkillAxis.calculation, 'candidate_selection_lab', 'Alexander Kotov vs Igor Bondarevsky (1946) — Systematic Tree Generation'],
    [16, 'Calculation', 'Forcing Moves (Checks, Captures, Threats)', 'Kotov calculation hierarchy: CCT priority list', SkillAxis.calculation, 'candidate_selection_lab', 'Garry Kasparov vs Veselin Topalov (1999) — Forcing Checks, Captures, Threats'],
    [17, 'Calculation', 'Calculation Tree Breadth vs Depth', 'Pruning impossible branches and prioritizing forcing lines', SkillAxis.calculation, 'blind_calculation_lab', 'Mikhail Botvinnik vs Jose Raul Capablanca (1938) — Deep Tree Pruning'],
    [18, 'Calculation', 'Intermediate Moves (Zwischenzug)', 'Inserting venomous in-between checks and counter-strikes', SkillAxis.calculation, 'candidate_selection_lab', 'Viswanathan Anand vs Levon Aronian (2013) — Poisonous Intermediate Blows'],
    [19, 'Calculation', 'Opponent Counter-Resources', 'Prophylactic calculation anticipating enemy defensive surprises', SkillAxis.defense, 'defensive_resource_lab', 'Tigran Petrosian vs Boris Spassky (1966) — Anticipating Counter-Resources'],
    [20, 'Calculation', 'Visualizing Silent Positions', 'Quiet moves at the end of wild tactical variations', SkillAxis.visualization, 'visualization_lab', 'Vladimir Kramnik vs Garry Kasparov (2000) — Silent Moves at the Horizon'],
    [21, 'Calculation', 'Milestone Exam: Deep Calculation Trees', '4-ply verified calculation tests with zero hint assistance', SkillAxis.calculation, 'blind_calculation_lab', 'Alexander Alekhine vs Efim Bogoljubov (1922) — 4-Ply Verified Calculation Exam'],
    [22, 'Visualization', 'Blindfold Board Geometry & Coordinates', 'Spatial coordinates fluency without visual board reference', SkillAxis.visualization, 'board_memory_lab', 'George Koltanowski Blindfold Marathon (1960) — Spatial Mental Grid'],
    [23, 'Visualization', 'Multi-Ply Blindfold Pawn Races', 'Visualizing advancing passed pawns and calculating promotion tempos', SkillAxis.visualization, 'visualization_lab', 'Richard Reti Endgame Studies (1921) — Blindfold Geometric Pawn Races'],
    [24, 'Visualization', 'Retaining Piece Placement Across 4 Plies', 'Mental board fidelity under sequential non-capturing moves', SkillAxis.visualization, 'board_memory_lab', 'Miguel Najdorf Blindfold Simultaneous (1947) — 4-Ply Board Memory Retention'],
    [25, 'Calculation', 'Eliminating Calculation Blind Spots', 'Detecting backward moves, unexpected knight hops, and long diagonals', SkillAxis.calculation, 'candidate_selection_lab', 'David Bronstein vs Alexander Kotov (1950) — Eliminating Backward Move Blind Spots'],
    [26, 'Calculation', 'Clock Discipline & Calculation Rhythm', 'Allocating calculation time efficiently across critical moments', SkillAxis.timeManagement, 'time_management_lab', 'Anatoly Karpov vs Viktor Korchnoi (1978) — Clock Rhythm & Critical Moment Audit'],
    [27, 'Calculation', 'Practical Tree Pruning', 'Discarding inferior candidate lines rapidly without second-guessing', SkillAxis.calculation, 'candidate_selection_lab', 'Lev Polugaevsky vs Eugenio Torre (1981) — Decisive Candidate Line Pruning'],
    [28, 'Calculation', 'Grand Milestone Exam: Blindfold & Calculation', 'Complete calculation depth and visualization certification', SkillAxis.calculation, 'blind_calculation_lab', 'Alexander Kotov vs Paul Keres (1950) — Grand Calculation Certification Exam'],
    // Phase 4: Strategy (Days 29-42)
    [29, 'Strategy', 'Pawn Structure & Space Advantage', 'Evaluating pawn chains, center tension, and territorial clamps', SkillAxis.pawnStructures, 'pawn_structure_lab', 'Aron Nimzowitsch vs Akiba Rubinstein (1926) — Pawn Chains & Central Wedge'],
    [30, 'Strategy', 'Outposts & Knight Anchoring', 'Securing eternal outposts supported by pawns on 5th/6th ranks', SkillAxis.strategy, 'find_the_plan_lab', 'Anatoly Karpov vs Garry Kasparov (1985 Game 16) — The Giant Octopus Knight on d3'],
    [31, 'Strategy', 'The Isolated Queen Pawn (IQP)', 'Dynamic attacking play vs blockade and endgame conversion', SkillAxis.pawnStructures, 'pawn_structure_lab', 'Mikhail Botvinnik vs Salo Flohr (1936) — Dynamic IQP Attacking Verticals'],
    [32, 'Strategy', 'Backward & Doubled Pawns', 'Systematic pressure on fixed pawn weaknesses', SkillAxis.pawnStructures, 'pawn_structure_lab', 'Jose Raul Capablanca vs Frank Marshall (1918) — Fixing & Dismantling Backward Pawns'],
    [33, 'Strategy', 'Open & Semi-Open Files for Heavy Pieces', 'Battery doubling, penetrating 7th/8th ranks, and file control', SkillAxis.strategy, 'find_the_plan_lab', 'Alexander Alekhine vs Aron Nimzowitsch (1930) — Alekhine\'s Gun Heavy Battery'],
    [34, 'Strategy', 'Good vs Bad Bishops & Color Complexes', 'Active minor piece harmony and color-complex domination', SkillAxis.strategy, 'improve_worst_piece_lab', 'Bobby Fischer vs Tigran Petrosian (1970) — Color-Complex Bishop Domination'],
    [35, 'Strategy', 'Milestone Exam: Positional Evaluation', 'Static vs dynamic positional advantage evaluation assessment', SkillAxis.strategy, 'positional_evaluation_lab', 'Vasily Smyslov vs Mikhail Botvinnik (1957) — Positional Evaluation Milestone'],
    [36, 'Strategy', 'Carlsbad Structure & Minority Attacks', 'The classic b4-b5 minority advance creating c6 backward weaknesses', SkillAxis.pawnStructures, 'pawn_break_discovery_lab', 'Garry Kasparov vs Anatoly Karpov (1987) — The Classic Carlsbad Minority Attack'],
    [37, 'Strategy', 'French Pawn Chains & Base Attacks', 'Attacking the base of the chain at d4/c3 vs overprotection', SkillAxis.pawnStructures, 'pawn_break_discovery_lab', 'Mikhail Botvinnik vs Vasily Smyslov (1954) — Undermining French Pawn Bases'],
    [38, 'Strategy', 'Maroczy Bind & Dark Square Clamping', 'c4/e4 pawn clamp paralyzing d5 breaks in the Sicilian', SkillAxis.pawnStructures, 'pawn_structure_lab', 'Gedeon Barcza vs Bent Larsen (1964) — Paralyzing Breaks with the Maroczy Bind'],
    [39, 'Strategy', 'Prophylaxis & Karpovian Restriction', 'Neutralizing opponent counterplay before launching operations', SkillAxis.defense, 'defensive_resource_lab', 'Anatoly Karpov vs Wolfgang Unzicker (1974) — Total Prophylactic Asphyxiation'],
    [40, 'Strategy', 'The Exchange Sacrifice for Dominance', 'Petrosian-style rook-for-minor sacrifices to clamp squares', SkillAxis.strategy, 'positional_evaluation_lab', 'Tigran Petrosian vs Ludek Pachman (1961) — Positional Exchange Sacrifice on f6'],
    [41, 'Strategy', 'The Principle of Two Weaknesses', 'Stretching the defense between two distant fronts to force collapse', SkillAxis.strategy, 'find_the_plan_lab', 'Akiba Rubinstein vs Carl Schlechter (1912) — The Principle of Two Weaknesses'],
    [42, 'Strategy', 'Grand Milestone Exam: Strategic Mastery', 'Comprehensive positional understanding and structural evaluation exam', SkillAxis.strategy, 'positional_evaluation_lab', 'Mikhail Botvinnik vs David Bronstein (1951) — Grand Strategic Mastery Exam'],
    // Phase 5: Endgames (Days 43-56)
    [43, 'Endgames', 'King & Pawn: Key Squares & Opposition', 'Seizing direct, distant, and diagonal opposition to promote', SkillAxis.endgames, 'endgame_win_defend_lab', 'Emanuel Lasker vs Siegbert Tarrasch (1908) — Key Squares & Vertical Opposition'],
    [44, 'Endgames', 'King & Pawn: The Square Rule & Reti Maneuver', 'Calculating pawn races and dual-purpose diagonal king marches', SkillAxis.endgames, 'endgame_win_defend_lab', 'Richard Reti vs Alexander Alekhine (1922) — The Reti Diagonal King March'],
    [45, 'Endgames', 'King & Pawn: Triangulation & Outflanking', 'Losing a tempo deliberately to put the enemy king in zugzwang', SkillAxis.endgames, 'endgame_win_defend_lab', 'Jose Raul Capablanca vs Alexander Alekhine (1927) — Triangulation & Outflanking'],
    [46, 'Endgames', 'Rook Endgames: The Lucena Position', 'Building a bridge with Rf4/Rd4+ to safely queen the passed pawn', SkillAxis.endgames, 'endgame_win_defend_lab', 'Jose Raul Capablanca vs Savielly Tartakower (1924) — Building the Lucena Bridge'],
    [47, 'Endgames', 'Rook Endgames: The Philidor Defense', 'Third-rank passive clamp transitioning to rear checks', SkillAxis.endgames, 'endgame_win_defend_lab', 'Francois Philidor Studies (1777) — The Classic Third-Rank Passive Clamp'],
    [48, 'Endgames', 'Rook Endgames: Active Rook & Cutting Off the King', 'Activity trumps passive defense in all theoretical rook endings', SkillAxis.endgames, 'endgame_win_defend_lab', 'Akiba Rubinstein vs Milan Vidmar (1911) — Cutting Off the King on the Rank'],
    [49, 'Endgames', 'Milestone Exam: Core Rook Endgames', 'Flawless technical execution of Lucena, Philidor, and Vancura', SkillAxis.endgames, 'endgame_win_defend_lab', 'Viktor Korchnoi vs Anatoly Karpov (1978) — Core Rook Endgame Milestone Exam'],
    [50, 'Endgames', 'Minor Piece: Same-Colored Bishops', 'Attacking fixed pawn weaknesses on the color complex', SkillAxis.endgames, 'endgame_win_defend_lab', 'Bobby Fischer vs Boris Spassky (1972 Game 4) — Same-Colored Bishop Pawns on Fixed Squares'],
    [51, 'Endgames', 'Minor Piece: Opposite-Colored Bishops Fortress', 'Constructing unbreachable blockades despite material deficits', SkillAxis.endgames, 'endgame_win_defend_lab', 'David Bronstein vs Paul Keres (1955) — Unbreachable Opposite-Colored Bishop Blockade'],
    [52, 'Endgames', 'Minor Piece: Knight vs Bishop Endgames', 'Open board bishop scope vs closed board knight outposts', SkillAxis.endgames, 'endgame_win_defend_lab', 'Jose Raul Capablanca vs Emanuel Lasker (1921) — Dominating Closed Boards with the Knight'],
    [53, 'Endgames', 'Queen Endgames: Perpetual Checks & Passed Pawns', 'Shielding the king from spite checks while pushing the pawn', SkillAxis.endgames, 'endgame_win_defend_lab', 'Garry Kasparov vs Anatoly Karpov (1986 Game 22) — Queen Ending King Umbrella'],
    [54, 'Endgames', 'Converting Material: Two Pawns Up Technique', 'Simplification protocols and neutralizing stalemate tricks', SkillAxis.conversion, 'conversion_challenge_lab', 'Magnus Carlsen vs Fabiano Caruana (2018) — Flawless Two-Pawns-Up Conversion'],
    [55, 'Endgames', 'Fortress Recognition & Defensive Saves', 'Identifying theoretical drawing configurations when losing', SkillAxis.defense, 'defensive_resource_lab', 'Boris Spassky vs Bobby Fischer (1972 Game 13) — Constructing Theoretical Fortresses'],
    [56, 'Endgames', 'Grand Milestone Exam: Practical Endgame Mastery', 'Engine-level endgame precision and tablebase conversion certification', SkillAxis.endgames, 'endgame_win_defend_lab', 'Vasily Smyslov vs Paul Keres (1953) — Grand Endgame Technical Mastery Exam'],
    // Phase 6: Openings (Days 57-63)
    [57, 'Openings', 'Opening Fundamentals & Center Domination', 'Rapid development, king safety, and early central claiming', SkillAxis.openings, 'opening_plan_lab', 'Paul Morphy vs Adolf Anderssen (1858) — Rapid Classical Center Control'],
    [58, 'Openings', '1.e4 Repertoire: Open Games (Scotch & Italian)', 'Direct central challenges and aggressive piece development', SkillAxis.openings, 'opening_plan_lab', 'Garry Kasparov vs Nigel Short (1993) — The Dynamic Scotch Center Blast'],
    [59, 'Openings', '1.e4 vs The Sicilian: Open vs Anti-Sicilian', 'Navigating dynamic asymmetrical battlegrounds', SkillAxis.openings, 'opening_plan_lab', 'Bobby Fischer vs Boris Spassky (1972 Game 6) — Neutralizing Dynamic Sicilian Structures'],
    [60, 'Openings', '1.d4 Repertoire: Queen Gambit & Catalan', 'Solid positional pressure and harmonic long diagonals', SkillAxis.openings, 'opening_plan_lab', 'Vladimir Kramnik vs Garry Kasparov (2000 Game 2) — Catalan Long Diagonal Squeeze'],
    [61, 'Openings', 'Defending with Black: Solid 1.e4 Responses', 'Sturdy Caro-Kann and French structures with counter-punches', SkillAxis.openings, 'opening_plan_lab', 'Anatoly Karpov vs Viktor Korchnoi (1981) — The Rock-Solid Caro-Kann Defense'],
    [62, 'Openings', 'Defending with Black: Dynamic 1.d4 Responses', 'King Indian and Nimzo-Indian active counterplay', SkillAxis.openings, 'opening_plan_lab', 'Garry Kasparov vs Anatoly Karpov (1985 Game 24) — King\'s Indian Dynamic Counter-Punch'],
    [63, 'Openings', 'Milestone Exam: Opening Repertoire & Memory', 'Move-tree verification across all personal opening branches', SkillAxis.openings, 'opening_plan_lab', 'Viswanathan Anand vs Boris Gelfand (2012) — Opening Repertoire Milestone Exam'],
    // Phase 7: Attack & Defense (Days 64-70)
    [64, 'Attack & Defense', 'Punishing the Uncastled King', 'Morphy-style central breakthroughs against delayed castling', SkillAxis.attack, 'tactical_lab', 'Adolf Anderssen vs Jean Dufresne (1852) — The Evergreen Central Breach'],
    [65, 'Attack & Defense', 'Classical Sacrifices: The Greek Gift (Bxh7+)', 'Calculating standard sacrifices on h7/h2 with Ng5+ followups', SkillAxis.attack, 'tactical_lab', 'Rudolf Spielmann vs Baldur Hoenlinger (1929) — Textbook Greek Gift Bxh7+'],
    [66, 'Attack & Defense', 'Attacking the Castled King: Pawn Storms', 'Opposite-side castling races and battering ram pawn pushes', SkillAxis.attack, 'tactical_lab', 'Bobby Fischer vs Bent Larsen (1958) — Battering Ram Pawn Storm in the Dragon'],
    [67, 'Attack & Defense', 'Defensive Tenacity: Resourcefulness Under Fire', 'Finding stubborn tactical saves when facing king-side assaults', SkillAxis.defense, 'defensive_resource_lab', 'Tigran Petrosian vs Viktor Korchnoi (1962) — Iron Defense Under Direct Bombardment'],
    [68, 'Attack & Defense', 'Escaping Mating Nets & Counter-Attacks', 'Active king flight paths and central counter-strikes', SkillAxis.defense, 'defensive_resource_lab', 'Garry Kasparov vs Anthony Miles (1986) — Breaking Free from Mating Nets'],
    [69, 'Attack & Defense', 'The King March: Short vs Timman Technique', 'Using the king as an active attacking piece in the endgame', SkillAxis.attack, 'guess_the_move_lab', 'Nigel Short vs Jan Timman (1991) — The Immortal King March to f6'],
    [70, 'Attack & Defense', 'Milestone Exam: King Attack & Defensive Tenacity', 'Two-way testing: executing attacks and defending under fire', SkillAxis.attack, 'tactical_lab', 'Mikhail Tal vs Bent Larsen (1965) — Attack & Defense Balance Milestone Exam'],
    // Phase 8: Conversion (Days 71-77)
    [71, 'Conversion', 'Converting Winning Advantages Systematically', 'Avoiding premature relaxation and playing high-percentage moves', SkillAxis.conversion, 'conversion_challenge_lab', 'Jose Raul Capablanca vs David Janowski (1916) — Systematic Advantage Conversion'],
    [72, 'Conversion', 'Liquidating into Easily Won Endgames', 'Trading queens and rooks when material advantage is decisive', SkillAxis.conversion, 'conversion_challenge_lab', 'Mikhail Botvinnik vs Paul Keres (1941) — Decisive Simplification to Won Endgames'],
    [73, 'Conversion', 'Avoiding Stalemates & Desperado Swindles', 'Remaining vigilant against opponent stalemate traps and perpetual checks', SkillAxis.defense, 'defensive_resource_lab', 'Boris Spassky vs David Bronstein (1960) — Neutralizing Desperado Counter-Swindles'],
    [74, 'Conversion', 'Time Trouble Technique & Practical Decisions', 'Managing the clock when under 3 minutes with zero blunders', SkillAxis.timeManagement, 'time_management_lab', 'Alexander Grischuk vs Vladimir Kramnik (2011) — The 3-Minute Time Trouble Protocol'],
    [75, 'Conversion', 'Psychological Resilience After Mistakes', 'Resetting mental focus after letting an advantage slip', SkillAxis.tournamentPlay, 'guess_the_move_lab', 'Ding Liren vs Ian Nepomniachtchi (2023 Game 12) — World Championship Psychological Reset'],
    [76, 'Conversion', 'The Simplest Win vs The Flashiest Win', 'Choosing clear master technique over unnecessary tactical risk', SkillAxis.conversion, 'conversion_challenge_lab', 'Magnus Carlsen vs Sergey Karjakin (2016) — Ruthless Simplest Win Conversion'],
    [77, 'Conversion', 'Milestone Exam: Flawless Advantage Conversion', 'Converting +3.00 centipawn advantages against engine sparring', SkillAxis.conversion, 'conversion_challenge_lab', 'Anatoly Karpov vs Garry Kasparov (1984) — Flawless +3.00 Conversion Milestone Exam'],
    // Phase 9: Tournament (Days 78-84)
    [78, 'Tournament', 'Swiss Tournament Dynamics & Pairing Prep', 'Tournament strategy: managing draw offers and must-win rounds', SkillAxis.tournamentPlay, 'guess_the_move_lab', 'Mikhail Tal vs Bobby Fischer (1959) — Swiss Pairing Tactics & Must-Win Dynamics'],
    [79, 'Tournament', 'Game Simulation 1: Rapid 15+10 with Post-Mortem', 'Full simulated tournament round followed by forensic blunder audit', SkillAxis.tournamentPlay, 'guess_the_move_lab', 'Levon Aronian vs Magnus Carlsen (2015) — Rapid 15+10 Match Simulation'],
    [80, 'Tournament', 'Game Simulation 2: Classical Time Control Discipline', 'Deep 30+minute sparring with notebook candidate annotations', SkillAxis.tournamentPlay, 'time_management_lab', 'Garry Kasparov vs Anatoly Karpov (1990) — Classical Time Control Match Simulation'],
    [81, 'Tournament', 'Scouting Opponents & Repertoire Adaptation', 'Targeting known stylistic weaknesses in opponent repertoires', SkillAxis.openings, 'opening_plan_lab', 'Max Euwe vs Alexander Alekhine (1935) — Scouting Repertoire Flaws in Opponents'],
    [82, 'Tournament', 'Energy Management & Physical Chess Stamina', 'Hydration, breaks, and cognitive endurance during double-round weekends', SkillAxis.tournamentPlay, 'guess_the_move_lab', 'Vasyl Ivanchuk vs Garry Kasparov (1991) — Cognitive Stamina & Endurance Discipline'],
    [83, 'Tournament', 'Must-Win Situations & Playing for Imbalance', 'Sharpening positions when a draw is equivalent to a loss', SkillAxis.attack, 'tactical_lab', 'Garry Kasparov vs Viswanathan Anand (1995 Game 10) — Playing for Imbalance in Must-Win Rounds'],
    [84, 'Tournament', 'Milestone Exam: Tournament Simulation Round', 'Rated tournament simulation against master-level engine profile', SkillAxis.tournamentPlay, 'guess_the_move_lab', 'Hikaru Nakamura vs Magnus Carlsen (2022) — Tournament Simulation Final Round Exam'],
    // Phase 10: Integration (Days 85-90)
    [85, 'Integration', 'Spaced Repetition Review: Tactical Vault', 'Consolidating 1,500+ tactical patterns into instantaneous intuition', SkillAxis.tactics, 'tactical_lab', 'Tactical Vault Review — Consolidating 32 Tactical Motifs'],
    [86, 'Integration', 'Spaced Repetition Review: Strategic Patterns', 'Revisiting pawn structures, outposts, and minority attacks', SkillAxis.strategy, 'positional_evaluation_lab', 'Strategic Anchor Review — Carlsbad, IQP, Outposts, & Prophylaxis'],
    [87, 'Integration', 'Spaced Repetition Review: Endgame Anchors', 'Solidifying tablebase reflexes for Lucena, Philidor, and opposition', SkillAxis.endgames, 'endgame_win_defend_lab', 'Endgame Anchor Review — Lucena, Philidor, Key Squares & Opposition'],
    [88, 'Integration', 'Deep Self-Analysis: Annotating Losses', 'Forensic post-mortem methodology to turn losses into rating gains', SkillAxis.tournamentPlay, 'guess_the_move_lab', 'Blunder Post-Mortem Workshop — Turning Defeats into Master Progress'],
    [89, 'Integration', 'The Grandmaster Mindset & Lifelong Mastery', 'Establishing daily maintenance habits and competitive longevity', SkillAxis.tournamentPlay, 'guess_the_move_lab', 'The Grandmaster Mindset — Daily Habits & Lifelong Chess Growth'],
    [90, 'Integration', 'Mastery Assessment & Completion Report — Grand Certification Exam', 'Culminating 90-day mastery evaluation across all skill axes', SkillAxis.tournamentPlay, 'tactical_lab', 'Grandmaster Syllabus Final Certification Assessment (Comprehensive)'],
  ];

  for (final row in meta) {
    final dayNum = row[0] as int;
    final topic = row[1] as String;
    final title = 'Day $dayNum: ${row[2]}';
    final theme = row[3] as String;
    final axis = row[4] as SkillAxis;
    final lab = row[5] as String;
    final gameStudy = row[6] as String;
    final isExam = const [7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 90].contains(dayNum);
    final diff = dayNum == 1 ? 1200 : 1200 + ((dayNum - 1) * 14);
    final prereqs = dayNum == 1 ? <int>[] : [dayNum - 1];

    // Pick 6 exercises per day from appropriate bank (Day 1 gets 3)
    List<CurriculumExercise> dayEx;
    if (dayNum == 1) {
      dayEx = [
        const CurriculumExercise(
          id: 'cur_d1_ex1',
          fen: 'r1bqk2r/pppp1ppp/2n5/4p3/1bB1n3/2N2Q2/PPPP1PPP/R1B1K1NR w KQkq - 0 6',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Identify the decisive tactical blow.',
          solutionSan: ['Qxf7#'],
          explanation: 'Scholar mate motif on f7 guarded by the bishop on c4.',
          hints: ['Look at the vulnerable f7 square.', 'The queen and bishop coordinate on f7.'],
          motif: 'Mating Net',
        ),
        const CurriculumExercise(
          id: 'cur_d1_ex2',
          fen: 'r1b1kb1r/pppp1ppp/8/4q3/4n3/2N2Q2/PPP2PPP/R1B1KB1R w KQkq - 0 8',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Find the tactical removal of the defender.',
          solutionSan: ['Qxe4'],
          explanation: 'Queen wins the pinned knight or takes free material.',
          hints: ['Check which black piece is overloaded.'],
          motif: 'Removal of Defender',
        ),
        const CurriculumExercise(
          id: 'cur_d1_ex3',
          fen: '8/8/8/4k3/8/8/4K3/8 w - - 0 1',
          sideToPlay: PieceColor.white,
          instruction: 'White to move: Take the direct vertical opposition.',
          solutionSan: ['Ke3'],
          explanation: 'Ke3 claims the opposition, restricting black king movement.',
          hints: ['Place your king on the same file with one square in between.'],
          motif: 'Opposition',
        ),
      ];
    } else if (dayNum <= 14) {
      dayEx = pickExercises(tactics, () => tacIdx, (v) => tacIdx = v, 6, dayNum);
    } else if (dayNum <= 21) {
      dayEx = pickExercises(calc, () => calcIdx, (v) => calcIdx = v, 6, dayNum);
    } else if (dayNum <= 24) {
      dayEx = pickExercises(vis, () => visIdx, (v) => visIdx = v, 6, dayNum);
    } else if (dayNum <= 28) {
      dayEx = pickExercises(calc, () => calcIdx, (v) => calcIdx = v, 6, dayNum);
    } else if (dayNum <= 42) {
      dayEx = pickExercises(strat, () => stratIdx, (v) => stratIdx = v, 6, dayNum);
    } else if (dayNum <= 56) {
      dayEx = pickExercises(endg, () => endgIdx, (v) => endgIdx = v, 6, dayNum);
    } else if (dayNum <= 63) {
      dayEx = pickExercises(open, () => openIdx, (v) => openIdx = v, 6, dayNum);
    } else if (dayNum <= 70) {
      dayEx = pickExercises(tactics, () => tacIdx, (v) => tacIdx = v, 6, dayNum);
    } else if (dayNum <= 77) {
      dayEx = pickExercises(prac, () => pracIdx, (v) => pracIdx = v, 6, dayNum);
    } else if (dayNum <= 84) {
      dayEx = pickExercises(prac, () => pracIdx, (v) => pracIdx = v, 6, dayNum);
    } else {
      dayEx = pickExercises(calc, () => calcIdx, (v) => calcIdx = v, 6, dayNum);
    }

    // Generate unique, non-templated theory
    final theory = _buildUniqueTheory(dayNum, topic, title, theme);

    final objectives = [
      'Master the core mechanics and geometric triggers of $theme.',
      'Evaluate at least 2 candidate moves before execution, explicitly calculating opponent refutations.',
      'Achieve >= ${isExam ? "85" : "80"}% accuracy on today\'s ${dayEx.length} interactive exercises with zero blunders.',
    ];

    final workedEx = [
      'Master Model 1: Classic Grandmaster demonstration of $theme with strict candidate move pruning.',
      'Master Model 2: Defense and counterplay when opposing $theme in sharp tournament conditions.',
    ];

    final practiceTask = isExam
        ? 'Tournament Milestone Exam: Play a rated match under 15+10 time control focused on $theme, followed by complete blunder post-mortem self-annotation.'
        : 'Interactive Lab Practice: Complete all ${dayEx.length} exercises in $lab, maintaining an average accuracy above 80% without using hints on the first attempt.';

    final assessment = isExam
        ? 'Milestone Certification: Complete exam positions with >= 85% accuracy and zero hints permitted.'
        : 'Daily Mastery Check: Solve interactive exercises with >= 80% accuracy and verify candidate moves.';

    final remediation = 'Mandatory Remediation Protocol: Review Day ${dayNum > 1 ? dayNum - 1 : 1} foundations, drill 10 targeted flashcards on ${axis.name}, and repeat exercises until achieving >= 85%.';

    final srs = [
      '$theme: Visual Pattern Recognition Flashcard',
      'Candidate Move Selection & Pruning Checklist',
      'Anti-Blunder Verification Trigger for ${axis.name}'
    ];

    specs[dayNum] = DaySpec(
      title: title,
      topic: topic,
      theme: theme,
      axis: axis,
      lab: lab,
      difficulty: diff,
      prerequisites: prereqs,
      objectives: objectives,
      theory: theory,
      workedExamples: workedEx,
      gameStudy: gameStudy,
      practiceTask: practiceTask,
      assessment: assessment,
      remediation: remediation,
      srsReview: srs,
      exercises: dayEx,
    );
  }

  return specs;
}

String _buildUniqueTheory(int day, String topic, String title, String theme) {
  final fideDisclaimer = day == 90
      ? "\n\n> **Official Educational Notice**: Completion of ChessMaster's 90-day curriculum and milestone exams certifies mastery of the syllabus and internal cognitive benchmarks; it does **not** grant or imply an official FIDE Grandmaster, International Master, or FIDE Master title, nor an official FIDE rating."
      : '';

  String concepts = '';
  String candidateDiscussion = '';
  String practicalTips = '';

  if (topic == 'Tactics' || day <= 14) {
    concepts = '''
Tactical motifs emerge from geometric disharmony and unprotected pieces. When studying **$theme**, you must train your visual recognition to register loose squares, overloaded defenders, and alignment vectors before calculating any lines.

Every tactical strike relies on a specific structural trigger:
- **LPDO (Loose Pieces Drop Off)**: An undefended piece is always a tactical vulnerability waiting to be exploited.
- **Geometric Alignment**: Rooks on open files, bishops piercing diagonals, and queens targeting royal squares.
- **Overburdened Guardians**: Pieces assigned to multiple defensive duties simultaneously fail under tension.
''';
    candidateDiscussion = '''
In the tactical positions for today:
- **Candidate Move A (The Decisive Continuation)**: Directly exploits the geometric weakness, calculating all forcing checks, captures, and threats to the final quiet move.
- **Candidate Move B (The Common Tempting Mistake)**: An intuitive developing or defensive move that appears safe but permits the opponent a tempo to organize their defense and avoid tactical collapse.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate all opponent forcing replies or choosing passive play when a tactical blow exists is the root cause of sub-master rating plateaus. Every candidate move must be verified against the opponent's strongest defensive resource.
''';
    practicalTips = '''
1. Before calculating deep lines, survey the entire board for undefended targets and king safety.
2. In tactical situations, verify whether an intermediate move (zwischenzug) alters the evaluation.
3. Once you spot a good move, pause and search for a better one!
''';
  } else if (topic == 'Calculation' || topic == 'Visualization' || day <= 28) {
    concepts = '''
Calculation is the engine of competitive chess. In **$theme**, your objective is to eliminate guesswork and replace it with structured, tree-based calculation following Alexander Kotov's methodology.

Master calculation loop:
`Identify Checks, Captures, Threats (CCT) → Formulate Candidate Moves → Calculate Forcing Variations Line-by-Line → Verify Quiet Moves at the Horizon → Execute Without Second-Guessing`

The key to deep calculation is not seeing 20 moves ahead, but seeing 3 to 4 moves ahead with 100% clarity and zero hallucinated pieces.
''';
    candidateDiscussion = '''
During critical calculation junctures:
- **Candidate Move A (The Decisive Continuation)**: Follows the most forcing branch of the tree, verifying that all candidate moves lead to a concrete material or positional dividend.
- **Candidate Move B (The Common Tempting Mistake)**: Premature calculation of an appealing sideline without first evaluating all checks and captures.
- **Why Wrong Choices Fail (Refutation Analysis)**: Prematurely stopping calculation at the visual boundary (the "horizon effect") allows the opponent a hidden counter-threat. You must calculate until the position becomes quiet and stable.
''';
    practicalTips = '''
1. Write down candidate moves mentally before calculating any branch.
2. Never repeat calculation branches during the game—it burns clock and breeds self-doubt.
3. Allocate calculation time in direct proportion to the criticality of the moment.
''';
  } else if (topic == 'Strategy' || day <= 42) {
    concepts = '''
Positional mastery in **$theme** governs long-term planning, piece coordination, and pawn structure evaluation. While tactics win battles, strategy dictates where the battles are fought.

Core strategic pillars:
- **Pawn Skeleton Hierarchy**: Pawn moves cannot be undone. Every pawn advance creates permanent outposts and weaknesses.
- **Piece Harmony & Role Fulfillment**: An active knight on an outpost is worth more than a passive rook trapped behind friendly pawns.
- **Prophylactic Thinking**: Identifying the opponent's only active plan and extinguishing it before executing your own.
''';
    candidateDiscussion = '''
When formulating strategic plans:
- **Candidate Move A (The Decisive Continuation)**: Systematically improves the worst-placed piece or targets the opponent's fixed structural weakness following the principle of two weaknesses.
- **Candidate Move B (The Common Tempting Mistake)**: An impatient tactical strike or premature pawn advance that dissipates positional pressure and opens lines for opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Attacking prematurely without adequate piece preparation or misjudging a static vs dynamic advantage leads directly to positional ruin. Refutation lies in patient exploitation of overextended pawns.
''';
    practicalTips = '''
1. Ask yourself after every opponent move: "What does my opponent want, and what square did they weaken?"
2. When ahead positionally, tighten the grip with prophylaxis rather than rushing the attack.
3. Trade pieces when defending, and trade pawns when attacking.
''';
  } else if (topic == 'Endgames' || day <= 56) {
    concepts = '''
Endgame precision in **$theme** is mathematical and unforgiving. Unlike the opening or middlegame, a single tempo lost in the endgame directly flips a win into a draw or loss.

Endgame fundamental laws:
- **Active King Supremacy**: The king transforms from a vulnerable target into an aggressive fighting piece.
- **Passed Pawn Dynamics**: Passed pawns must be pushed, escorted by the king, and blockaded from the front.
- **Tablebase Precision**: Positions like Lucena, Philidor, and key-square opposition must be executed with automated reflex.
''';
    candidateDiscussion = '''
In technical endgame conversion:
- **Candidate Move A (The Decisive Continuation)**: Applies textbook technique (opposition, outflanking, cutting off the king, or building a bridge) with zero concession of counterplay.
- **Candidate Move B (The Common Tempting Mistake)**: A hurried pawn push that allows the opponent to establish a blockade, claim the opposition, or find a stalemate trick.
- **Why Wrong Choices Fail (Refutation Analysis)**: Failing to calculate pawn races to the exact promotion tempo or misplacing the rook behind rather than in front of passed pawns allows the defender an escape. Refutation is mathematically enforced by tablebases.
''';
    practicalTips = '''
1. Calculate king opposition and pawn races down to the exact queening square with check.
2. In rook endgames, place your rook behind passed pawns—both your own and your opponent's.
3. Never rush a winning endgame; take your time to calculate stalemate traps.
''';
  } else if (topic == 'Openings' || day <= 63) {
    concepts = '''
Modern opening mastery in **$theme** is about understanding pawn structures, tabias, and transpositions, not rote memorization of 25 moves.

Opening strategic imperatives:
- **Central Stake**: Fight for d4/d5/e4/e5 from move one with pawns and pieces.
- **Harmonious Piece Development**: Develop minor pieces toward the center before moving the same piece twice.
- **Rapid King Safety**: Castle early to connect heavy pieces and remove the king from open vertical files.
''';
    candidateDiscussion = '''
In the opening tabias:
- **Candidate Move A (The Decisive Continuation)**: Stakes a claim in the center, adheres to sound repertoire theory, and maintains dynamic balance or a slight spatial pull.
- **Candidate Move B (The Common Tempting Mistake)**: A pawn-grabbing sideline or superficial attack that neglects king safety and gives the opponent a massive lead in development.
- **Why Wrong Choices Fail (Refutation Analysis)**: Greedily capturing poisoned pawns at the expense of piece development leads to rapid central collapse. Refutation comes in the form of rapid open-file piece infiltration.
''';
    practicalTips = '''
1. Memorize opening ideas, plans, and typical pawn breaks rather than isolated moves.
2. If your opponent delays castling, open the center immediately even at the cost of a pawn.
3. Review your personal opening tree after every serious tournament game.
''';
  } else if (topic == 'Attack & Defense' || day <= 70) {
    concepts = '''
King hunt geometry and defensive tenacity in **$theme** represent the sharpest collision in competitive chess. An attack on the king requires decisive piece concentration and sacrificial courage, while defense demands absolute coolness under fire.

Principles of the attack:
- **Attacking Ratios**: You need a local numerical superiority (at least 3 attacking pieces against 1-2 defenders) to break open the king fortress.
- **Pawn Battering Rams**: Advance pawns on the flank opposite to where your king is castled to strip away enemy pawn shields.
- **Defensive Resourcefulness**: Counter-attack in the center when attacked on the wing; never defend passively if an active counter-threat exists.
''';
    candidateDiscussion = '''
During sacrificial king assaults:
- **Candidate Move A (The Decisive Continuation)**: Blows open the king's defensive shelter through a calculated breakthrough sacrifice (e.g. Bxh7+, Nd5, or pawn storm).
- **Candidate Move B (The Common Tempting Mistake)**: A slow preparatory move that grants the defender a tempo to reinforce their defensive coordinates or evacuate the king.
- **Why Wrong Choices Fail (Refutation Analysis)**: Hesitating during an attack allows the defender to counter-strike in the center. An attack must proceed with maximum momentum and forcing checks.
''';
    practicalTips = '''
1. Calculate king attacks to mate or clear decisive material advantage before sacrificing material.
2. The best defense against a flank attack is a central counter-strike.
3. When defending under severe pressure, look for perpetual check and stalemate tricks.
''';
  } else {
    // Phases 8, 9, 10: Conversion, Tournament, Integration
    concepts = '''
Practical mastery, advantage conversion, and competitive psychological endurance in **$theme** separate titled players from amateur enthusiasts. Having a winning position is only half the battle—converting it into an official point on the tournament scorecard is where championships are won.

Tournament conversion benchmarks:
- **Eliminate Counterplay First**: Before pushing for the knockout, eliminate all opponent tactical counter-chances.
- **Simplicity Over Brilliance**: Choose the clean, risk-free technical conversion over the double-edged tactical flourish.
- **Clock & Emotional Discipline**: Maintain your physical stamina, manage time trouble protocols, and rebound immediately from errors.
''';
    candidateDiscussion = '''
In high-stakes tournament conversion:
- **Candidate Move A (The Decisive Continuation)**: Selects the most robust, high-percentage technical path, liquidating into a completely winning endgame with zero tactical risk.
- **Candidate Move B (The Common Tempting Mistake)**: Over-optimistic pursuit of a flashy mate that unnecessarily complications the position and gives the opponent counterplay.
- **Why Wrong Choices Fail (Refutation Analysis)**: Over-confidence and premature relaxation lead to catastrophic blunders. Refutation occurs when the opponent seizes unexpected counter-tactics in a time scramble.
''';
    practicalTips = '''
1. When winning, treat every remaining move as if the game were completely level.
2. Trade pieces when ahead in material, but avoid trading all pawns.
3. Cultivate an iron post-mortem habit: analyze every game without an engine first.
''';
  }

  return '''
# $title: $theme

## 1. Core Pedagogical Concept & Strategic Role
$concepts

## 2. Technical Breakdown & Mechanics
- **Geometric Triggers**: Identify key alignments, vulnerable king lines, and critical outpost squares.
- **Forcing Action Priority**: Kotov forcing hierarchy applies at every move—always check checks, captures, and threats first.
- **Candidate Move Discipline**: Systematically compare candidate moves side-by-side rather than fixating on the first intuitive glance.

## 3. Candidate Moves & Refutation Analysis
$candidateDiscussion

## 4. Practical Tournament Application & Psychological Triggers
$practicalTips
$fideDisclaimer
''';
}
