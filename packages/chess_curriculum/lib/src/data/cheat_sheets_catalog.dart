/// Permanent Grandmaster Reference Library & Cheat Sheets Catalog entry.
/// Provides instant, accessible reference guides across all core chess disciplines.
class CheatSheetEntry {
  final String id;
  final String category;
  final String title;
  final String summary;
  final List<String> bulletPoints;
  final String? diagramFen;
  final String? keyQuote;

  const CheatSheetEntry({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.bulletPoints,
    this.diagramFen,
    this.keyQuote,
  });
}

class CheatSheetsCatalog {
  static const List<CheatSheetEntry> entries = [
    // 1. Move Checklist & Calculation Process
    CheatSheetEntry(
      id: 'move_checklist',
      category: 'Calculation & Decision Making',
      title: 'Grandmaster Move Decision Checklist',
      summary: 'Strict mental protocol before executing every single move to eradicate blunders.',
      keyQuote: '"When you see a good move, wait! Look for a better one." — Emanuel Lasker',
      bulletPoints: [
        '1. Opponent Threat Check: What did their last move attack, uncover, or threaten? What square did they leave?',
        '2. Kotov Forcing Hierarchy (CCT): Check all Checks, then all Captures, then all concrete direct Threats.',
        '3. Candidate Move Generation: Brainstorm 2 to 4 candidate moves mentally before calculating any variations.',
        '4. Systematic Calculation: Calculate candidate branches line-by-line without jumping between them.',
        '5. Horizon Verification: Evaluate the resulting quiet position at the end of the line (look for hidden counter-blows).',
        '6. Final Blunder Check: "If I play this move, can my opponent play an immediate check, capture, or tactic?"',
      ],
    ),
    CheatSheetEntry(
      id: 'calculation_trees',
      category: 'Calculation & Decision Making',
      title: 'Kotov Calculation Trees & Pruning',
      summary: 'Structured tree calculation methodology from Alexander Kotov\'s classic "Think Like a Grandmaster".',
      keyQuote: '"A player must calculate variations like a tree trunk branching outwards." — Alexander Kotov',
      bulletPoints: [
        'Tree Breadth: Spend time at the root generating all plausible candidate moves, not just your first impulse.',
        'Forcing Lines First: Always calculate forcing moves (checks, captures) to completion before quiet strategic lines.',
        'Pruning the Dead Branches: Discard moves that fail tactically immediately without repeated second-guessing.',
        'Avoid Retracing: Once a variation has been calculated and assessed, do not recalculate it during clock tension.',
        'Quiet Moves at Horizon: Watch out for quiet intermezzo moves (zwischenzugs) that completely overturn an evaluation.',
      ],
    ),

    // 2. Tactical Motifs
    CheatSheetEntry(
      id: 'tactical_motifs',
      category: 'Tactics & Combinations',
      title: 'Universal Tactical Motifs Compendium',
      summary: 'The geometry of tactical strikes and undefended pieces.',
      keyQuote: '"Tactics is knowing what to do when there is something to do." — Savielly Tartakower',
      bulletPoints: [
        'Loose Pieces Drop Off (LPDO): Undefended pieces are magnets for double attacks, forks, and deflection strikes.',
        'Absolute vs Relative Pin: Absolute pins freeze a piece against the King (illegal to move); relative pins freeze against higher value pieces (Queen, Rook).',
        'Fork Geometry: Knights fork across asymmetric color squares; Queens and pawns fork along diagonals and verticals.',
        'Skewer (X-Ray): High-value piece in front is forced to step aside, exposing the vulnerable prize behind it.',
        'Discovered Attack & Double Check: The moving piece unmasks an attack while creating its own threat. In double check, the King MUST move.',
        'Decoy & Deflection: Decoy lures a piece to a fatal square; Deflection drives a guardian piece away from its critical duty.',
        'Zwischenzug (In-Between Move): Inserting a venomous intermediate check or counter-threat before expected recapture.',
        'Overloading: A piece assigned two defensive tasks simultaneously collapses when one side is pressured.',
      ],
    ),

    // 3. Positional Evaluation
    CheatSheetEntry(
      id: 'positional_evaluation',
      category: 'Positional Strategy',
      title: 'Steinitz Positional Evaluation Framework',
      summary: 'Diagnosing static vs dynamic advantages to determine whether to attack or consolidate.',
      keyQuote: '"A plan is made for a few moves only, not for the whole game." — Wilhelm Steinitz',
      bulletPoints: [
        'Static vs Dynamic: Static features (pawn structure, weak squares) are permanent; dynamic features (initiative, lead in development) are temporary and must be used immediately.',
        'Piece Activity & Harmony: Measure pieces not by their point value, but by the number of meaningful squares they control.',
        'Good vs Bad Bishops: A bishop hemmed in by its own pawns fixed on the same color is bad; swap it or change the pawn structure.',
        'Outpost Anchors: An outpost is a square on the 4th, 5th, or 6th rank that cannot be attacked by opponent pawns. Knights are lethal here.',
        'Open & Semi-Open Files: Rooks belong on open files. Penetrate to the 7th rank (the "blind pigs" double rooks) to decimate pawns.',
        'Prophylaxis (Petrosian/Karpov): Neutralize opponent active plans and ideas before commencing your own operations.',
      ],
    ),

    // 4. Pawn Structures & Breaks
    CheatSheetEntry(
      id: 'pawn_structures',
      category: 'Pawn Structures',
      title: 'Pawn Skeleton Compendium & Breaks',
      summary: 'Pawns are the soul of chess (Philidor). Every pawn move creates permanent weaknesses.',
      keyQuote: '"Pawns are born free, yet everywhere they are in chains." — Aron Nimzowitsch',
      bulletPoints: [
        'Carlsbad Structure (Queen\'s Gambit): White plays the Minority Attack (a3, b4, b5) to create a fixed backward c6 pawn.',
        'Isolated Queen Pawn (IQP / Isolani): Dynamic attacking chances for the player with the IQP (open c/e files, Ne5 outpost). The defender seeks to blockade on d4/d5 and trade into a winning endgame.',
        'French Pawn Chain: Attacking the base of the chain (c5 attacking d4, or f4/f5 attacking e6) is the golden rule.',
        'Maroczy Bind: Pawns on c4 and e4 clamp down completely on the d5 break in the Sicilian, denying Black counterplay.',
        'Hanging Pawns (c4+d4): Dynamic duo controlling central squares; if blockaded or split, they become permanent targets.',
        'Pawn Breaks: Central tension must be resolved with timely pawn breaks (e4, d4, c4, or f4). A passive pawn structure suffocates pieces.',
      ],
    ),

    // 5. Opening Principles
    CheatSheetEntry(
      id: 'opening_principles',
      category: 'Openings',
      title: 'Master Opening Principles & Repertoire Rules',
      summary: 'Navigate the first 10-15 moves with sound classical fundamentals, not rote memorization.',
      keyQuote: '"Play the opening like a book, the middlegame like a magician, and the endgame like a machine." — Rudolf Spielmann',
      bulletPoints: [
        '1. Stake a Claim in the Center: Push e4 or d4 to establish central pawn presence from move one.',
        '2. Minor Pieces Before Major Pieces: Develop Knights before Bishops, and both before moving Queens or Rooks.',
        '3. Do Not Move the Same Piece Twice: In the opening, each move must bring a new soldier into the battle.',
        '4. Castle Early for King Safety: Connect the rooks and remove the king from open central files before move 10.',
        '5. Do Not Hunt Pawns with the Queen: Premature queen excursions lead to rapid loss of tempos and trapped queens.',
        '6. Punish Development Delays: If your opponent ignores king safety or development, open the center immediately with pawn breaks.',
      ],
    ),

    // 6. Attacking & Defending
    CheatSheetEntry(
      id: 'attacking_defending',
      category: 'Attack & Defense',
      title: 'Attacking the King & Tenacious Defense',
      summary: 'Rules for conducting decisive kingside assaults and holding difficult positions.',
      keyQuote: '"To win an attack, you must bring more attackers to the sector than the defender can muster." — Paul Morphy',
      bulletPoints: [
        'The Greek Gift (Bxh7+ / Bxh2+): Valid when attacker has Ng5+, Qh5, control of e4/g5, and defender cannot play ...Nf6 or ...Qxg5.',
        'Opposite-Side Castling: Pawn storms are the order of the day. Speed is everything; whoever opens lines to the enemy king first wins.',
        'Destroying the Castled Pawn Shield: Sacrifices on h6, g7, or f7 tear open the defensive bunker for heavy piece infiltration.',
        'Defensive Economy: Defend with the minimum number of pieces required so your remaining army can generate counterplay.',
        'Trade Pieces When Defending: Simplification reduces attacking firepower and steers sharp positions toward calm endgames.',
        'Fortress Construction: In inferior endgames, set up unbreachable barriers where the opponent cannot infiltrate despite material advantage.',
      ],
    ),

    // 7. Endgame Essentials
    CheatSheetEntry(
      id: 'endgame_essentials',
      category: 'Endgames',
      title: 'Theoretical Endgame Essentials & Benchmarks',
      summary: 'Non-negotiable theoretical positions and techniques that every serious chess player must execute automatically.',
      keyQuote: '"In the endgame, a single lost tempo flips a win into a draw or a loss." — Mark Dvoretsky',
      bulletPoints: [
        'King & Pawn: The Opposition: Direct (1 square apart), Distant (3 or 5 squares), and Diagonal. The player who does NOT have to move holds the opposition.',
        'Square Rule: Draw a square from the passed pawn to its queening square. If the enemy king is inside or can step into the square on its turn, it catches the pawn.',
        'Lucena Position (Building a Bridge): With rook and pawn on the 7th rank, play Rf4! (or Rd4), then Kc7, and bridge with Re4+ when checked.',
        'Philidor Defense (Rook & Pawn): Keep your rook on the 6th rank to prevent the enemy king from advancing. When the pawn pushes to the 6th rank, drop the rook to the 1st rank and deliver infinite rear checks!',
        'Active Rook Supremacy: Place your rook BEHIND passed pawns—both your own (supporting advance) and opponent\'s (paralyzing advance).',
        'Queen Endgames: Push passed pawns while keeping the king shielded from spite checks under the "umbrella" of friendly pawns.',
      ],
    ),

    // 8. Tournament & Time Management
    CheatSheetEntry(
      id: 'tournament_rules',
      category: 'Tournament Play',
      title: 'Tournament Psychology, Clock & Rules',
      summary: 'Navigating competitive time controls, touch-move regulations, and psychological resilience.',
      keyQuote: '"Time pressure is the great equalizer—it reveals the true depth of automated habits." — Garry Kasparov',
      bulletPoints: [
        'The 20% Time Rule: Spend 20% of your time on the first 15 moves, save 60% for the critical middlegame complexities, and keep 20% for the endgame.',
        'Touch-Move Rule: If you touch a piece with intention to move, you MUST move it if legal. If you touch an opponent piece, you must capture it if legal. Say "J\'adoube" or "I adjust" BEFORE touching if only adjusting.',
        'Clock Rhythm: Press the clock with the same hand that made the move. Never hover over the clock.',
        'Threefold Repetition & 50-Move Rule: Claim repetition on your turn BEFORE making the move on the board by writing it on the scoresheet.',
        'Post-Game Analysis Discipline: Analyze games without engine assistance first; identify your emotional and cognitive turning points before consulting Stockfish.',
      ],
    ),
  ];

  static List<CheatSheetEntry> search(String query) {
    if (query.trim().isEmpty) return entries;
    final q = query.toLowerCase().trim();
    return entries.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.summary.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.bulletPoints.any((b) => b.toLowerCase().contains(q));
    }).toList();
  }

  static List<String> get categories =>
      entries.map((e) => e.category).toSet().toList();

  static List<CheatSheetEntry> forCategory(String category) =>
      entries.where((e) => e.category == category).toList();
}
