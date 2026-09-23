import 'package:chess_core/chess_core.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';
import '../widgets/board/chess_board_widget.dart';
import '../widgets/curriculum/chess_companion_dialog.dart';

/// Micro-course entry for the Academy
class AcademyMicroCourse {
  final String id;
  final String title;
  final String category;
  final SkillAxis axis;
  final String duration;
  final String summary;
  final String rule;
  final String diagramFen;
  final String modelMove;
  final String targetLab;

  const AcademyMicroCourse({
    required this.id,
    required this.title,
    required this.category,
    required this.axis,
    required this.duration,
    required this.summary,
    required this.rule,
    required this.diagramFen,
    required this.modelMove,
    required this.targetLab,
  });
}

/// Terminology item in the GM glossary
class ChessGlossaryTerm {
  final String term;
  final String pronunciation;
  final String simpleDefinition;
  final String whyItMatters;
  final String example;

  const ChessGlossaryTerm({
    required this.term,
    this.pronunciation = '',
    required this.simpleDefinition,
    required this.whyItMatters,
    required this.example,
  });
}

/// Searchable visual crash-course and GM knowledge map covering beginner to advanced chess.
class AcademyScreen extends StatefulWidget {
  final StorageRepository repository;
  final Function(String screenKey, {dynamic args})? onNavigate;

  const AcademyScreen({
    super.key,
    required this.repository,
    this.onNavigate,
  });

  @override
  State<AcademyScreen> createState() => _AcademyScreenState();
}

class _AcademyScreenState extends State<AcademyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();
  SkillAxis? _selectedAxisFilter;
  AcademyMicroCourse? _activeCourse;

  static const List<AcademyMicroCourse> _microCourses = [
    AcademyMicroCourse(
      id: 'mc_rules',
      title: 'Rules, Coordinates & Notation',
      category: 'Fundamentals',
      axis: SkillAxis.visualization,
      duration: '3 min',
      summary: '64 squares, files a-h, ranks 1-8, algebraic notation, and legal castling conditions.',
      rule: 'Light square on the bottom right ("White on right"). White Queen on d1, Black Queen on d8.',
      diagramFen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      modelMove: 'e4',
      targetLab: 'visualization_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_piece_values',
      title: 'Piece Values & Trade Math',
      category: 'Fundamentals',
      axis: SkillAxis.tactics,
      duration: '2 min',
      summary: 'Pawn=1, Knight/Bishop=3, Rook=5, Queen=9. Static values vs dynamic piece activity.',
      rule: 'Never trade an active piece for a passive piece of equal raw point value without a concrete advantage.',
      diagramFen: 'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3',
      modelMove: 'Nxe5',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_check_mate_draw',
      title: 'Check, Mate & The 5 Draw Rules',
      category: 'Fundamentals',
      axis: SkillAxis.endgames,
      duration: '3 min',
      summary: 'Distinguish checkmate from stalemate. Master threefold repetition, 50-move rule, and insufficient material.',
      rule: 'Stalemate occurs when the side to move has no legal moves and is NOT in check; the game is immediately a draw.',
      diagramFen: '7k/5Q2/6K1/8/8/8/8/8 b - - 0 1',
      modelMove: 'Kh8',
      targetLab: 'endgame_win_defend_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_lpdo',
      title: 'Hanging Pieces & LPDO',
      category: 'Tactics',
      axis: SkillAxis.tactics,
      duration: '2 min',
      summary: 'John Nunn\'s classic heuristic: "Loose Pieces Drop Off." Undefended pieces invite decisive tactics.',
      rule: 'Count attackers vs defenders before every move. Never leave a piece unguarded in an open center.',
      diagramFen: 'r1bqk2r/pppp1ppp/2n5/2b1p3/4n3/3P1N2/PPP2PPP/RNBQKB1R w KQkq - 0 5',
      modelMove: 'dxe4',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_forks',
      title: 'Forks & Royal Double Attacks',
      category: 'Tactics',
      axis: SkillAxis.tactics,
      duration: '3 min',
      summary: 'Attacking two enemy pieces simultaneously with one piece. Knights and pawns are master forking units.',
      rule: 'Knights leap over obstacles and cannot be blocked. Look for checks that simultaneously attack unprotected rooks or queens.',
      diagramFen: 'r1b1k2r/pppp1ppp/2n5/1B2p3/4n3/2N2N2/PPPP1PPP/R1BQK2R w KQkq - 0 6',
      modelMove: 'Nd5',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_pins',
      title: 'Absolute vs Relative Pins',
      category: 'Tactics',
      axis: SkillAxis.tactics,
      duration: '3 min',
      summary: 'Paralyzing a piece along a geometric ray. Absolute pins freeze against the king; relative pins freeze against the queen.',
      rule: 'Pinned pieces lose their defensive power. Always pile pressure onto the pinned piece with pawns and minor pieces.',
      diagramFen: 'r1bqk2r/pppp1ppp/2n2n2/1B2p3/4P3/5N2/PPPP1PPP/RNBQK2R w KQkq - 2 4',
      modelMove: 'Bxc6',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_skewers',
      title: 'Skewers & X-Ray Attacks',
      category: 'Tactics',
      axis: SkillAxis.tactics,
      duration: '3 min',
      summary: 'An attack along a line where the more valuable piece is in front and must move, exposing the unit behind.',
      rule: 'Linear pieces (Queens, Rooks, Bishops) deliver skewers. Look for aligned kings and queens on open ranks and diagonals.',
      diagramFen: '1k6/8/8/3q4/8/8/3Q4/4K3 w - - 0 1',
      modelMove: 'Qxd5',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_discovered',
      title: 'Discovered Attacks & Double Checks',
      category: 'Tactics',
      axis: SkillAxis.tactics,
      duration: '3 min',
      summary: 'Moving a piece to unmask an ambush from a piece behind it. Double check forces the enemy king to flee.',
      rule: 'A double check cannot be blocked and the checking pieces cannot both be captured; the king MUST move.',
      diagramFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/3Pn3/2N2N2/PPP2PPP/R1BQKB1R w KQkq - 0 5',
      modelMove: 'Nxe4',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_deflection',
      title: 'Deflection & Decoy Tactics',
      category: 'Tactics',
      axis: SkillAxis.tactics,
      duration: '3 min',
      summary: 'Luring an enemy piece away from its critical defensive duty, opening up an immediate tactical strike.',
      rule: 'Identify the key defender guarding against checkmate or piece loss, then forcefully deflect it with a sacrifice.',
      diagramFen: '3r2k1/5ppp/8/8/8/8/3Q4/4R1K1 w - - 0 1',
      modelMove: 'Qxd8+',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_overload',
      title: 'Overloaded Pieces & Interference',
      category: 'Tactics',
      axis: SkillAxis.tactics,
      duration: '3 min',
      summary: 'When a single piece is burdened with defending two critical points or lines simultaneously.',
      rule: 'Attack both points an overloaded piece defends; it cannot hold both and the position collapses.',
      diagramFen: 'r1b2rk1/pp3ppp/2n1p3/3q4/3P4/3B1N2/PP1Q1PPP/R4RK1 w - - 0 12',
      modelMove: 'Bxh7+',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_clearance',
      title: 'Clearance & Zwischenzug (In-Between)',
      category: 'Tactics',
      axis: SkillAxis.calculation,
      duration: '4 min',
      summary: 'Vacating a square or line with tempo, and inserting an unexpected intermediate check or threat before recapturing.',
      rule: 'Before playing an automatic recapture, always ask: "Do I have an intermediate check or capture that changes the evaluation?"',
      diagramFen: 'r1b2rk1/pp1p1ppp/1qn1p3/8/1b1PP3/1BN2N2/PP3PPP/R2Q1RK1 w - - 0 1',
      modelMove: 'd5',
      targetLab: 'candidate_selection_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_mating_patterns',
      title: 'Checkmating Patterns Encyclopedia',
      category: 'Tactics',
      axis: SkillAxis.tactics,
      duration: '4 min',
      summary: 'Back-Rank, Smothered (Philidor), Anastasia, Boden\'s double-bishop mate, and the Hook mate.',
      rule: 'Recognize the geometric signature of common mates so you execute them without spending calculation time.',
      diagramFen: '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
      modelMove: 'Re8#',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_cct',
      title: 'The CCT Forcing Hierarchy',
      category: 'Calculation',
      axis: SkillAxis.calculation,
      duration: '4 min',
      summary: 'Grandmaster move ordering: Calculate Checks first, then Captures, then concrete Threats.',
      rule: 'Forcing moves severely limit enemy replies. Never calculate quiet moves before exhausting all checks and captures.',
      diagramFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
      modelMove: 'Qxf7#',
      targetLab: 'candidate_selection_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_candidates',
      title: 'Candidate Moves & Calculation Trees',
      category: 'Calculation',
      axis: SkillAxis.calculation,
      duration: '5 min',
      summary: 'Kotov\'s tree of calculation: identify 2-4 candidate moves first before calculating any single line deeply.',
      rule: 'Do not dive into calculating the first move you see. Survey candidate moves broadly before calculating deeply.',
      diagramFen: 'r1bq1rk1/ppp2ppp/2n1pn2/3p4/2PP4/2N1PN2/PP3PPP/R1BQKB1R w KQ - 0 6',
      modelMove: 'cxd5',
      targetLab: 'candidate_selection_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_blunder_check',
      title: 'Visualization & Blunder Checks',
      category: 'Calculation',
      axis: SkillAxis.visualization,
      duration: '3 min',
      summary: 'Mentally picture the destination square and verify what line or piece becomes unguarded before releasing your hand.',
      rule: 'Before every move, perform a 5-second blunder check: "What can my opponent do to hurt me after my intended move?"',
      diagramFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3',
      modelMove: 'Bb5',
      targetLab: 'visualization_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_positional_eval',
      title: 'Positional Evaluation Framework',
      category: 'Strategy',
      axis: SkillAxis.strategy,
      duration: '4 min',
      summary: 'Steinitz positional elements: Material balance, King safety, Piece activity, and Pawn structure integrity.',
      rule: 'Static advantages (material, pawn structure) last forever; dynamic advantages (lead in development, initiative) must be cashed in quickly.',
      diagramFen: 'r1bq1rk1/pp2bppp/2n1pn2/2pp4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
      modelMove: 'dxc5',
      targetLab: 'positional_evaluation_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_outposts',
      title: 'Holes & Knight Outposts',
      category: 'Strategy',
      axis: SkillAxis.strategy,
      duration: '4 min',
      summary: 'A hole is a square that can never be guarded by an enemy pawn. An outpost is an anchored forward post.',
      rule: 'Plant knights in enemy territory where they cannot be evicted by pawns (e.g. d5 or e5 in Sicilian/French structures).',
      diagramFen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
      modelMove: 'Ne5',
      targetLab: 'find_the_plan_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_open_files',
      title: 'Open Files, Diagonals & 7th Rank',
      category: 'Strategy',
      axis: SkillAxis.strategy,
      duration: '3 min',
      summary: 'Rooks belong on open files; rooks on the 7th rank attack pawns from behind and trap the opposing king.',
      rule: 'Doubling rooks on an open file guarantees penetration to the 7th rank ("Pigs on the Seventh").',
      diagramFen: '2r2rk1/pp3ppp/8/8/8/8/PP3PPP/2R2RK1 w - - 0 1',
      modelMove: 'Rxc8',
      targetLab: 'find_the_plan_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_bishop_pair',
      title: 'The Bishop Pair & Bad Bishops',
      category: 'Strategy',
      axis: SkillAxis.strategy,
      duration: '4 min',
      summary: 'Two bishops rake across both color complexes. A bad bishop is blocked by its own fixed central pawns.',
      rule: 'Keep positions open when you hold the bishop pair. If saddled with a bad bishop, trade it or relocate it outside the pawn chain.',
      diagramFen: 'r1bq1rk1/ppp2ppp/2n5/1B1p4/3Pn3/2P2N2/P4PPP/R1BQ1RK1 w - - 0 10',
      modelMove: 'Bxc6',
      targetLab: 'improve_worst_piece_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_pawn_chains',
      title: 'Pawn Chains, Breaks & Levers',
      category: 'Pawn Structures',
      axis: SkillAxis.pawnStructures,
      duration: '4 min',
      summary: 'The base and head of a pawn chain. Pawn breaks open lines and challenge the opponent\'s spatial grasp.',
      rule: 'Attack a pawn chain at its base (the rearmost undefended pawn), not at its apex.',
      diagramFen: 'r1bqk2r/pp1n1ppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQK2R w KQkq - 0 7',
      modelMove: 'c5',
      targetLab: 'pawn_structure_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_minority',
      title: 'Carlsbad Minority Attack',
      category: 'Pawn Structures',
      axis: SkillAxis.pawnStructures,
      duration: '5 min',
      summary: 'Pushing a 2-pawn flank (a and b pawns) against a 3-pawn block (a, b, c pawns) to create a backward pawn target.',
      rule: 'In the Exchange Queen\'s Gambit, advance b4-b5 to exchange on c6 and leave Black with a permanent backward c6 pawn.',
      diagramFen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
      modelMove: 'b4',
      targetLab: 'pawn_structure_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_iqp',
      title: 'Isolated Queen Pawn (IQP) Dynamics',
      category: 'Pawn Structures',
      axis: SkillAxis.pawnStructures,
      duration: '4 min',
      summary: 'An IQP provides open files, central space, and attacking outposts in the middlegame, but becomes a weakness in the endgame.',
      rule: 'With the IQP, attack the enemy king and push d4-d5. Playing against the IQP, blockade the square in front (d5) and trade pieces.',
      diagramFen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/2PP4/2N2N2/PP2BPPP/R1BQ1RK1 w - - 0 8',
      modelMove: 'cxd5',
      targetLab: 'pawn_structure_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_king_attacks',
      title: 'King Attacks & Opposite Castling',
      category: 'Attack',
      axis: SkillAxis.attack,
      duration: '4 min',
      summary: 'Pawn storms with opposite-side castling. Sacrifices on h7, g7, and opening lines against the enemy monarch.',
      rule: 'When castled on opposite sides, speed of attack is paramount: push pawns aggressively toward the enemy king.',
      diagramFen: 'r1b2rk1/pp2qppp/2n1pn2/3p4/2PP4/2NBPN2/PP3PPP/R2Q1RK1 w - - 0 9',
      modelMove: 'e4',
      targetLab: 'tactical_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_lucena',
      title: 'Lucena Position (Building the Bridge)',
      category: 'Endgames',
      axis: SkillAxis.endgames,
      duration: '4 min',
      summary: 'The universal winning method for Rook + Pawn vs Rook endings with a pawn on the 7th rank.',
      rule: 'Place your rook on the 4th rank (e.g. Re4) to shield your king from vertical checks while stepping out to promote.',
      diagramFen: '1K1R4/8/k7/8/8/8/r7/8 w - - 0 1',
      modelMove: 'Rd4',
      targetLab: 'endgame_win_defend_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_philidor',
      title: 'Philidor Defensive Drawing Method',
      category: 'Endgames',
      axis: SkillAxis.endgames,
      duration: '4 min',
      summary: 'The rock-solid defensive technique for drawing Rook + Pawn endings as the defending side.',
      rule: 'Keep your rook on the 6th rank to prevent the enemy king from advancing; when the pawn pushes to the 6th rank, switch to rear checks.',
      diagramFen: '8/8/8/8/8/4k3/4r3/4K3 w - - 0 1',
      modelMove: 'Kf1',
      targetLab: 'endgame_win_defend_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_endgame_principles',
      title: 'King & Pawn Endgames: Opposition',
      category: 'Endgames',
      axis: SkillAxis.endgames,
      duration: '4 min',
      summary: 'Direct and distant opposition. Outflanking, key squares, and the rule of the square for pawn races.',
      rule: 'When kings face each other with one square between them, the player who does NOT have to move holds the opposition.',
      diagramFen: '8/8/4k3/8/4K3/8/8/8 w - - 0 1',
      modelMove: 'Kd4',
      targetLab: 'endgame_win_defend_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_opening_principles',
      title: 'Golden Opening Principles',
      category: 'Openings',
      axis: SkillAxis.openings,
      duration: '3 min',
      summary: 'Control the center (e4/d4/e5/d5), develop knights before bishops, castle early, and do not move the same piece twice.',
      rule: 'Every opening move must contest the center or aid rapid piece development toward king safety.',
      diagramFen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
      modelMove: 'e5',
      targetLab: 'opening_plan_lab',
    ),
    AcademyMicroCourse(
      id: 'mc_tournament_time',
      title: 'Clock & Time Management Protocol',
      category: 'Tournament',
      axis: SkillAxis.timeManagement,
      duration: '3 min',
      summary: 'Identifying critical moments vs routine moves. Budgeting time and staying composed in time pressure.',
      rule: 'Spend extra time only when calculating concrete tactical lines or major strategic transitions; play opening and endgame basics quickly.',
      diagramFen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      modelMove: 'd4',
      targetLab: 'time_management_lab',
    ),
  ];

  static const List<ChessGlossaryTerm> _glossary = [
    ChessGlossaryTerm(
      term: 'Initiative',
      simpleDefinition: 'The ability to dictate the course of the game by creating threats that the opponent must answer.',
      whyItMatters: 'Having the initiative forces your opponent onto the back foot, limiting their creative options and inducing blunders.',
      example: 'Morphy developing with tempo against the Duke of Brunswick in 1858.',
    ),
    ChessGlossaryTerm(
      term: 'Tempo',
      simpleDefinition: 'A single turn or move unit. Gaining a tempo means developing with a threat while your opponent wastes a move defending.',
      whyItMatters: 'In open tactical games, 2-3 tempi are frequently worth more than a full sacrificed piece.',
      example: 'Developing a knight to c3 attacking an exposed early queen on d4.',
    ),
    ChessGlossaryTerm(
      term: 'LPDO (Loose Pieces Drop Off)',
      simpleDefinition: 'John Nunn\'s famous acronym noting that unprotected units are the target of nearly all tactics.',
      whyItMatters: 'Before playing any move, checking for undefended pieces on both sides prevents 80% of tactical blunders.',
      example: 'A bishop on b4 with no friendly pawns or pieces guarding it.',
    ),
    ChessGlossaryTerm(
      term: 'Zwischenzug (In-Between Move)',
      pronunciation: 'tsvee-shen-tsoog',
      simpleDefinition: 'An unexpected intermediate check, capture, or threat inserted before playing the expected reply.',
      whyItMatters: 'Automatic recaptures frequently walk into devastating in-between moves.',
      example: 'Instead of recapturing immediately, White inserts 1. Qxf7+ forcing Black\'s king into the open.',
    ),
    ChessGlossaryTerm(
      term: 'Prophylaxis',
      simpleDefinition: 'Anticipating and neutralizing the opponent\'s tactical and positional threats before they happen.',
      whyItMatters: 'Tigran Petrosian and Anatoly Karpov built World Championship careers on suppressing enemy counterplay.',
      example: 'Playing h3 (luft) to eliminate back-rank checkmate threats and prevent enemy pieces from landing on g4.',
    ),
    ChessGlossaryTerm(
      term: 'Outpost',
      simpleDefinition: 'A square in enemy territory that cannot be attacked or driven away by an enemy pawn.',
      whyItMatters: 'An anchored knight on a central outpost controls 8 squares and often paralyzes the opponent\'s camp.',
      example: 'A White knight on d5 in the Sicilian Defense supported by pawns on c4 and e4.',
    ),
    ChessGlossaryTerm(
      term: 'Interference',
      simpleDefinition: 'Placing a piece between two enemy units to sever communication lines (like a queen guarding a checkmating square).',
      whyItMatters: 'Interference destroys coordinate defense and allows immediate decisive strikes.',
      example: 'Dropping a knight on e6 to block a rook on e8 from defending the back rank.',
    ),
    ChessGlossaryTerm(
      term: 'Deflection',
      simpleDefinition: 'A tactical sacrifice or threat that lures an enemy defending piece away from its critical defensive duty.',
      whyItMatters: 'When a key piece is defended, deflecting the defender breaks the entire defense.',
      example: 'Checking the king on the 8th rank to deflect the queen away from guarding an undefended bishop.',
    ),
    ChessGlossaryTerm(
      term: 'Minority Attack',
      simpleDefinition: 'Advancing a smaller number of flank pawns against a larger pawn majority to create structural defects.',
      whyItMatters: 'Creates a permanent backward pawn or isolated pawn that can be besieged in the endgame.',
      example: 'White\'s a4-b4-b5 push against Black\'s a7-b7-c6 pawn chain in the Queen\'s Gambit Carlsbad structure.',
    ),
    ChessGlossaryTerm(
      term: 'Opposition',
      simpleDefinition: 'A situation in king and pawn endings where two kings face each other on the same rank, file, or diagonal with one square between.',
      whyItMatters: 'The player who does NOT have to move holds the opposition and can outflank the opponent king.',
      example: 'White King on e4, Black King on e6. Whoever has to move loses control of key flanking squares.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      body: Column(
        children: [
          // Academy Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: context.surf,
              border: Border(bottom: BorderSide(color: context.brd)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ChessTheme.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.school, color: ChessTheme.primaryLight, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CHESS ACADEMY & KNOWLEDGE MAP',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          color: context.txt,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '2–5 Minute Visual Micro-Courses and Master Terminology Glossary',
                        style: TextStyle(fontSize: 12, color: context.txtMut),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => ChessCompanionDialog.show(context),
                  icon: const Icon(Icons.auto_stories, size: 16),
                  label: const Text('Open Chess Companion (16 Cheat Sheets)'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ChessTheme.primaryLight,
                    side: const BorderSide(color: ChessTheme.primaryLight),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar & Search
          Container(
            color: context.surf,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: ChessTheme.primaryLight,
                  unselectedLabelColor: context.txtMut,
                  indicatorColor: ChessTheme.primaryLight,
                  tabs: const [
                    Tab(icon: Icon(Icons.play_circle_outline, size: 18), text: 'Visual Micro-Courses'),
                    Tab(icon: Icon(Icons.spellcheck, size: 18), text: 'GM Terminology Glossary'),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 280,
                  height: 38,
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      hintText: 'Search micro-courses & terms...',
                      hintStyle: TextStyle(fontSize: 12, color: context.txtMut),
                      prefixIcon: const Icon(Icons.search, size: 16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (val) {
                      setState(() => _searchQuery = val.trim().toLowerCase());
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMicroCoursesTab(),
                _buildGlossaryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMicroCoursesTab() {
    final filtered = _microCourses.where((mc) {
      if (_selectedAxisFilter != null && mc.axis != _selectedAxisFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery;
        return mc.title.toLowerCase().contains(q) ||
            mc.summary.toLowerCase().contains(q) ||
            mc.category.toLowerCase().contains(q) ||
            mc.rule.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Row(
      children: [
        // Course Grid / List
        Expanded(
          flex: 3,
          child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 380,
              mainAxisExtent: 220,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, idx) {
              final course = filtered[idx];
              final isSelected = _activeCourse?.id == course.id;

              return InkWell(
                onTap: () {
                  setState(() => _activeCourse = course);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? ChessTheme.primary.withAlpha(25) : context.surf,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? ChessTheme.primaryLight : context.brd,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: ChessTheme.primary.withAlpha(30),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              course.category.toUpperCase(),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(course.duration, style: const TextStyle(fontSize: 11, color: Colors.amber)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        course.title,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: context.txt),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          course.summary,
                          style: TextStyle(fontSize: 12, color: context.txtMut, height: 1.4),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Row(
                        children: [
                          Text('View Micro-Course', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14, color: ChessTheme.primaryLight),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Right Preview Sidebar
        if (_activeCourse != null) ...[
          VerticalDivider(width: 1, thickness: 1, color: context.brd),
          SizedBox(
            width: 380,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _activeCourse!.title,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.txt),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _activeCourse = null),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 320,
                    height: 320,
                    child: ChessBoardWidget(
                      board: Board.fromFen(_activeCourse!.diagramFen),
                      isInteractive: false,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.surf,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.brd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Core GM Heuristic:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: context.txtMut)),
                        const SizedBox(height: 4),
                        Text(_activeCourse!.rule, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.txt)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {
                      widget.onNavigate?.call('labs', args: {'labId': _activeCourse!.targetLab});
                    },
                    icon: const Icon(Icons.science, size: 16),
                    label: const Text('Practice in Teaching Lab'),
                    style: FilledButton.styleFrom(
                      backgroundColor: ChessTheme.primaryLight,
                      minimumSize: const Size.fromHeight(40),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGlossaryTab() {
    final filtered = _glossary.where((t) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery;
        return t.term.toLowerCase().contains(q) ||
            t.simpleDefinition.toLowerCase().contains(q) ||
            t.whyItMatters.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final item = filtered[idx];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.surf,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.brd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.term,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: ChessTheme.primaryLight),
                  ),
                  if (item.pronunciation.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      '/${item.pronunciation}/',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: context.txtMut),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                item.simpleDefinition,
                style: TextStyle(fontSize: 14, height: 1.4, color: context.txt),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Why it matters: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.txtMut)),
                  Expanded(
                    child: Text(item.whyItMatters, style: TextStyle(fontSize: 12, color: context.txtMut)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Example: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ChessTheme.accentGold)),
                  Expanded(
                    child: Text(item.example, style: TextStyle(fontSize: 12, color: context.txt)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
