/// Permanent Grandmaster Reference Library & Universal Chess Companion Catalog.
library;
/// Provides 16 instant, visual reference guides across all core chess disciplines:
/// 1. Before-Move Thinking Checklist
/// 2. CCT (Checks, Captures, Threats) Algorithm
/// 3. Candidate & Calculation Decision Tree
/// 4. Tactical Motifs Visual Matrix
/// 5. Position Evaluation (Static vs Dynamic)
/// 6. Attack Checklist
/// 7. Defense Checklist
/// 8. Pawn Structures
/// 9. Opening Principles
/// 10. Opening Recognition
/// 11. Middlegame Planning
/// 12. Endgame Essentials
/// 13. Rook Endings
/// 14. Mate Patterns
/// 15. Time Management
/// 16. Post-Game Analysis

class CheatSheetEntry {
  final String id;
  final String category;
  final String title;
  final String summary;
  final List<String> bulletPoints;
  final String? diagramFen;
  final String? keyQuote;
  final String? decisionFlowchart;

  const CheatSheetEntry({
    required this.id,
    required this.category,
    required this.title,
    required this.summary,
    required this.bulletPoints,
    this.diagramFen,
    this.keyQuote,
    this.decisionFlowchart,
  });
}

class CheatSheetsCatalog {
  static const List<CheatSheetEntry> entries = [
    // 1. Before-Move Checklist
    CheatSheetEntry(
      id: 'before_move_checklist',
      category: 'Decision Algorithm',
      title: 'Before-Move Grandmaster Checklist',
      summary: 'The universal 10-step thinking process before touching or executing any move.',
      keyQuote: '"When you see a good move, wait! Look for a better one." — Emanuel Lasker',
      decisionFlowchart: 'What changed? → Opponent threat → Checks → Captures → Threats → Tactical scan → Evaluate → Candidates → Calculate strongest reply → Compare → Blunder check.',
      bulletPoints: [
        '1. What changed?: Identify squares vacated, lines opened, and new diagonals/files influenced by the opponent\'s move.',
        '2. Opponent threat: Does their move create an immediate check, capture, or concrete tactical threat?',
        '3. CCT Scan: Review all available Checks, Captures, and direct Threats for both colors.',
        '4. Tactical scan: Search for LPDO (Loose Pieces Drop Off), alignments, and vulnerable king targets.',
        '5. Evaluate position: Gauge material balance, king security, active piece mobility, and pawn structure.',
        '6. Generate candidates: Brainstorm 2 to 4 viable candidate moves without calculating deep variations yet.',
        '7. Calculate variations: Calculate forcing responses to your candidates, looking for opponent\'s strongest defense.',
        '8. Calculate strongest reply: Never assume passive play; calculate the most stubborn counter-reply.',
        '9. Compare candidates: Weigh static advantages vs dynamic possibilities among your evaluated branches.',
        '10. Blunder check: "If I play this move, can my opponent play an immediate tactic, check, or intermediate strike?"',
      ],
      diagramFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
    ),

    // 2. CCT Hierarchy
    CheatSheetEntry(
      id: 'cct_algorithm',
      category: 'Calculation & Decision Making',
      title: 'CCT Forcing Move Hierarchy',
      summary: 'The strict algorithmic priority: Checks → Captures → Threats.',
      keyQuote: '"Forcing moves are the bedrock of chess calculation. Never evaluate quiet moves before exhausting forcing ones." — Alexander Kotov',
      decisionFlowchart: 'Checks (Limits King) → Captures (Alters Material) → Threats (Forces Defensive Response)',
      bulletPoints: [
        '1. Checks: Calculate EVERY legal check, even sacrificial ones. Checks drastically limit opponent reply options.',
        '2. Captures: Calculate all captures, piece exchanges, and pawns takes. Identify undefended pieces immediately.',
        '3. Threats: Direct attacks on high-value pieces, mating nets, piece traps, or strategic pawn breaks.',
        'Priority rule: Forcing moves take immediate initiative and leave the opponent with minimal candidate replies.',
        'Anti-blunder trigger: Always inspect whether your opponent has a forcing CCT response before executing quiet plans.',
      ],
      diagramFen: 'r2qkb1r/pp2pppp/2n5/3p4/3Pn1b1/2NB1N2/PPP2PPP/R1BQK2R w KQkq - 4 7',
    ),

    // 3. Candidate & Calculation Algorithm
    CheatSheetEntry(
      id: 'candidate_calculation',
      category: 'Calculation & Decision Making',
      title: 'Candidate Moves & Calculation Algorithm',
      summary: 'Structured Kotov calculation tree, tree pruning, and horizon verification.',
      keyQuote: '"A player must calculate variations like a tree trunk branching outwards." — Alexander Kotov',
      decisionFlowchart: 'Candidate Generation (Broad) → Branch Calculation (Deep) → Horizon Evaluation (Quiet) → Selection',
      bulletPoints: [
        'Breadth First: Spend 30 seconds listing candidate moves at the root before diving into long calculation lines.',
        'No Flip-Flopping: Once you begin calculating Candidate A, follow it to a quiet horizon before switching to Candidate B.',
        'Pruning Dead Branches: When a branch clearly fails or is refuted by a tactic, prune it immediately.',
        'Quiet Moves at Horizon: Beware of subtle quiet moves or retreats (zwischenzug) at the end of calculated lines.',
        'Kotov Trap: Do not re-calculate variation A three times out of nervous hesitation. Verify once, trust your calculation.',
      ],
      diagramFen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PPQ1BPPP/R1B2RK1 w - - 0 9',
    ),

    // 4. Tactical Motifs Visual Matrix
    CheatSheetEntry(
      id: 'tactical_motifs',
      category: 'Tactics & Combinations',
      title: 'Tactical Motifs Visual Matrix',
      summary: 'The geometry of combinations: forks, pins, skewers, discoveries, deflection, and LPDO.',
      keyQuote: '"Tactics is knowing what to do when there is something to do." — Savielly Tartakower',
      bulletPoints: [
        'LPDO (Loose Pieces Drop Off): Undefended pieces are the primary trigger for 80% of tactical combinations.',
        'Absolute vs Relative Pin: Absolute pins freeze pieces against the King (illegal to move); relative pins against Queen/Rook.',
        'Fork (Double Attack): Single piece attacks two targets simultaneously (especially lethal with Knights and Pawns).',
        'Skewer (X-Ray Attack): Attacks a valuable piece in front, forcing it to move and exposing the target behind.',
        'Discovered Attack & Double Check: The moving piece delivers a threat while unmasking a battery. Double check FORCES King move.',
        'Deflection & Decoy: Deflection drives away a critical defender; Decoy lures an enemy piece to a fatal square.',
        'Interference & Clearance: Interference blocks enemy defense lines; Clearance vacates a vital square/diagonal for a friendly piece.',
        'Zwischenzug (In-Between Move): An unexpected venomous check or counter-threat inserted before expected recapture.',
      ],
      diagramFen: 'r1b1k2r/ppppqppp/2n5/1B2P3/1b2n3/2N2N2/PPP2PPP/R1BQK2R w KQkq - 0 7',
    ),

    // 5. Position Evaluation (Static vs Dynamic)
    CheatSheetEntry(
      id: 'position_evaluation',
      category: 'Strategy & Evaluation',
      title: 'Static vs Dynamic Position Evaluation',
      summary: 'Steinitz and Nimzowitsch evaluation parameters: long-term structure vs short-term activity.',
      keyQuote: '"He who has the advantage must attack, or he will lose it." — Wilhelm Steinitz',
      bulletPoints: [
        '1. Material Count: Absolute piece values (P=1, N=3, B=3.25, R=5, Q=9) adjusted for board context.',
        '2. King Safety: Pawn shelter intactness, open attacking avenues, proximity to enemy pieces, castling status.',
        '3. Piece Activity & Coordination: Scope of bishops, outposts for knights, open files for rooks, harmonization.',
        '4. Pawn Structure: Passed pawns, isolated pawns (IQP), doubled pawns, backward pawns, and pawn majorities.',
        '5. Space Advantage: Controlled ranks and central squares that restrict enemy piece maneuvers.',
        'Static vs Dynamic Rule: Static advantages (material, pawn structure) are permanent; dynamic advantages (initiative, development lead) are perishable.',
      ],
      diagramFen: 'r1bq1rk1/pp3ppp/2n1pn2/3p4/3P4/2NBPN2/PP3PPP/R1BQ1RK1 w - - 0 9',
    ),

    // 6. King Attack Checklist
    CheatSheetEntry(
      id: 'attack_checklist',
      category: 'Attack & Initiative',
      title: 'King Attack & Initiative Checklist',
      summary: 'Conditions and mechanics for launching decisive kingside and opposite-castling storms.',
      keyQuote: '"To attack the king, you must open lines. Sacrifices are the keys that unlock doors." — Mikhail Tal',
      bulletPoints: [
        'Attacking Preconditions: Development lead, active central control (or closed center), and superior piece concentration.',
        'Opening Lines: Pawn levers (h4-h5, g4-g5, f4-f5) or clearance sacrifices (Bxh7+, Nxg7) to rip open files.',
        'Piece Superiority: Ensure you have at least 3 attacking pieces surrounding the target king against 1-2 defenders.',
        'Opposite-Side Castling Storm: When castled on opposite sides, pawn storms on the opponent\'s king are top priority. Speed is everything.',
        'Prevent Counterplay: Ensure opponent cannot generate counter-attacks in the center while you are attacking the wing.',
      ],
      diagramFen: 'r1b2rk1/pp3ppp/4pn2/2pp4/3P4/2NBPN2/PPP2PPP/R2Q1RK1 w - - 0 9',
    ),

    // 7. Defense Checklist
    CheatSheetEntry(
      id: 'defense_checklist',
      category: 'Defense & Tenacity',
      title: 'Defensive Resources & Prophylaxis Checklist',
      summary: 'Techniques for surviving pressure, parrying threats, and constructing impenetrable fortresses.',
      keyQuote: '"Prophylaxis consists of detecting and neutralizing the opponent\'s plans before they are realized." — Aron Nimzowitsch',
      bulletPoints: [
        '1. Prophylaxis: Ask on every move: "What does my opponent want to do?" and eliminate their threat in advance.',
        '2. Economy of Defense: Defend threats with the least valuable piece possible. Never tie down a queen to guard a pawn.',
        '3. Simplification: Trade off the opponent\'s most active attacking pieces (especially the queen and bishop pair).',
        '4. Central Counter-Strike: The best antidote to a wing attack is a resolute counter-strike in the center.',
        '5. Fortress Construction: In desperate endgames, coordinate pieces to create a static, unbreakable defense perimeter.',
      ],
      diagramFen: '6k1/5ppp/8/8/8/8/5qPP/7K w - - 0 1',
    ),

    // 8. Pawn Structures
    CheatSheetEntry(
      id: 'pawn_structures',
      category: 'Pawn Structures',
      title: 'Master Pawn Structures & Plans',
      summary: 'Strategic roadmaps for Carlsbad, Isolani (IQP), Hanging Pawns, Hedgehog, and Pawn Chains.',
      keyQuote: '"Pawns are the soul of chess." — François-André Danican Philidor',
      bulletPoints: [
        'Carlsbad Structure (Minority Attack): White pushes a4-b4-b5 to exchange on c6, creating a permanent backward c6 pawn target.',
        'Isolated Queen\'s Pawn (IQP): The attacker has open files and active outpost squares (e5/c5); defender blocks d5 and aims for endgame simplification.',
        'Hanging Pawns (c4/d4 or c5/d5): Dynamic pair that can push (d5 break) to open lines, but vulnerable to frontal blockade and piece assault.',
        'Pawn Chains: Attack the base of the enemy chain (the pawn furthest back that is not defended by another pawn).',
        'Passed Pawns: A passed pawn must be pushed! Protect it from behind and use it as a deflection decoy.',
      ],
      diagramFen: 'r1bq1rk1/pp1nbppp/2p1pn2/3p4/2PP4/2N1PN2/PP2BPPP/R1BQ1RK1 w - - 0 8',
    ),

    // 9. Opening Principles
    CheatSheetEntry(
      id: 'opening_principles',
      category: 'Openings',
      title: 'Golden Opening Principles',
      summary: 'The non-negotiable fundamentals of the opening phase.',
      keyQuote: '"Play the opening like a book, the middlegame like a magician, and the endgame like a machine." — Rudolf Spielmann',
      bulletPoints: [
        '1. Control the Center: Occupy or control central squares (e4, d4, e5, d5) with pawns and minor pieces.',
        '2. Knights Before Bishops: Develop knights towards the center (Nf3/Nc3) before committing bishops.',
        '3. Do Not Move the Same Piece Twice: Mobilize all your forces before maneuvering with individual pieces.',
        '4. Castle Early: Secure your King and connect your rooks within the first 8-10 moves.',
        '5. Do Not Bring the Queen Out Too Early: Early queen sorties make her a target for developing enemy minor pieces with tempo.',
        '6. Connect Your Rooks: Opening is complete when the back rank is cleared and rooks communicate with each other.',
      ],
      diagramFen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1',
    ),

    // 10. Opening Recognition
    CheatSheetEntry(
      id: 'opening_recognition',
      category: 'Openings',
      title: 'Opening Recognition & ECO Architecture',
      summary: 'Taxonomy of main chess openings, pawn configurations, and transpositions.',
      bulletPoints: [
        'Open Games (1.e4 e5): Ruy Lopez (Spanish), Italian Game, Scotch Game, King\'s Gambit. Symmetrical central clashes.',
        'Semi-Open Games (1.e4 others): Sicilian Defense (c5 - asymmetric struggle), French (e6 - locked center), Caro-Kann (c6 - solid structure).',
        'Closed Games (1.d4 d5): Queen\'s Gambit (Accepted/Declined), Slav Defense, Catalan. Strategic, structure-heavy battles.',
        'Indian Defenses (1.d4 Nf6): King\'s Indian (d6/g6 - kingside attack), Nimzo-Indian (Bb4 - piece pressure), Grunfeld (d5/c5 - dynamic center break).',
        'Flank Openings: English (1.c4), Reti (1.Nf3). Hypermodern control of center from afar.',
      ],
      diagramFen: 'rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 0 2',
    ),

    // 11. Middlegame Planning
    CheatSheetEntry(
      id: 'middlegame_planning',
      category: 'Strategy & Evaluation',
      title: 'Middlegame Planning Blueprint',
      summary: 'How to formulate plans based on structural imbalances and piece coordination.',
      keyQuote: '"A bad plan is better than no plan at all." — Mikhail Chigorin',
      bulletPoints: [
        'Identify Imbalances: Who has the bishop pair? Where are the pawn majorities? Which files are open? Who controls outposts?',
        'Improve Your Worst Piece: Find your most passive piece on the board and chart a 2-move route to an active outpost.',
        'Trade Bad Pieces for Good Pieces: Swap your tall pawn (blocked bishop) for their active, biting bishop.',
        'Pawn Breaks: Open lines for your pieces by identifying thematic pawn breaks (e4, d5, c5, f4).',
        'Rook Placement: Place rooks on open files, semi-open files against backward pawns, or penetrate to the 7th rank.',
      ],
      diagramFen: 'r1b1r1k1/pp3ppp/2n1pn2/3p4/3P4/1PN1PN2/P4PPP/R1B1KB1R w KQ - 0 10',
    ),

    // 12. Endgame Essentials
    CheatSheetEntry(
      id: 'endgame_essentials',
      category: 'Endgames',
      title: 'Fundamental Endgame Essentials & Heuristics',
      summary: 'Principles that govern king & pawn endings, piece transitions, and technical conversions.',
      keyQuote: '"In the endgame, the King becomes a powerful attacking piece. Activate your king immediately!" — José Raúl Capablanca',
      bulletPoints: [
        'King Activity: In the endgame, the King is worth ~4 pawns of fighting power. Centralize your king without hesitation.',
        'The Opposition: Direct opposition (1 square apart) forces the opposing king to yield ground and concede key squares.',
        'Key Squares: Occupying the key squares in front of a passed pawn guarantees promotion regardless of who moves.',
        'The Rule of the Square: Draw a square from pawn to queening rank. If the defending king cannot step in, the pawn queens alone.',
        'Triangulation: Losing a move with king maneuvers to put the opponent into zugzwang.',
        'Passed Pawn Majorities: Create an outside passed pawn to lure the enemy king away from defending their kingside pawns.',
      ],
      diagramFen: '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
    ),

    // 13. Rook Endings
    CheatSheetEntry(
      id: 'rook_endings',
      category: 'Endgames',
      title: 'Master Rook Endings: Lucena & Philidor',
      summary: 'Theoretical mastery of the most common endgame type in chess (~50% of practical endgames).',
      keyQuote: '"All rook endgames are drawn." — Savielly Tartakower (practical hyperbole emphasizing tenacious defense)',
      bulletPoints: [
        'Lucena Position (Building the Bridge): Pawn on 7th rank, King on 8th rank. Play Rf4!, then Kc7, and when Black checks, block with Re4! Winning 1-0.',
        'Philidor Defense (Drawing Method): Defending king on back rank. Keep rook on 6th rank to stop enemy king. When pawn pushes to 6th rank, drop rook to 1st rank and deliver endless rear checks! 1/2-1/2.',
        'Active Rook Placement: Keep your rook BEHIND passed pawns—both your own (supporting push) and opponent\'s (restricting advance).',
        'Cut-Off King: Use your rook to cut off the enemy king along a file, preventing it from entering the theater of pawn action.',
        'Short-Side Defense: In rook endgames, the defending king moves to the short side, leaving the long side for rook lateral checks.',
      ],
      diagramFen: '1K1k4/1P6/8/8/8/8/8/2R5 w - - 0 1',
    ),

    // 14. Mate Patterns
    CheatSheetEntry(
      id: 'mate_patterns',
      category: 'Tactics & Combinations',
      title: 'Checkmating Patterns Encyclopedia',
      summary: 'Visual catalog of canonical checkmate geometries.',
      bulletPoints: [
        'Back-Rank Mate: Rook or Queen delivers mate along 8th rank when enemy pawns block king escape on 7th rank.',
        'Smothered Mate: Knight delivers checkmate against a king surrounded and trapped by its own friendly pieces.',
        'Anastasia\'s Mate: Knight blocks e7/g7 escape squares while Rook delivers mate along the open h-file.',
        'Boden\'s Mate: Criss-crossing pair of bishops deliver checkmate across open diagonals against castled/trapped king.',
        'Arabian Mate: Knight on f6/f3 protects the rook on h7/h2 while sealing the g8 escape square.',
        'Damiano\'s Mate: Queen backed by pawn/bishop breaks through on h7 after a rook sacrifice opens the h-file.',
        'Epaulette Mate: King trapped against board edge with friendly pieces on both lateral sides, allowing straight queen mate.',
      ],
      diagramFen: '6k1/5ppp/8/8/8/8/8/1R4K1 w - - 0 1',
    ),

    // 15. Time Management
    CheatSheetEntry(
      id: 'time_management',
      category: 'Tournament Play',
      title: 'Clock Discipline & Time Management Protocol',
      summary: 'Practical time allocation algorithms to avoid blitz blunders in classical and rapid time controls.',
      keyQuote: '"Time on the clock is as much a material factor as the pieces on the board." — Boris Spassky',
      bulletPoints: [
        'The 20-60-20 Rule: Allocate 20% of your clock to the first 15 opening moves, 60% for middlegame crisis points, and 20% for the endgame.',
        'Critical Moment Detection: Identify the 2-3 decisive junctures per game where an investment of 5-10 minutes is mandatory.',
        'Do Not Burn Clock on Forcing Moves: If you only have one legal or sensible move (recaptures, fleeing checks), play it quickly.',
        'Increment Discipline: In increment controls (e.g. +10s or +15s), never panic when under 2 minutes. Maintain steady physical rhythm.',
        'Opponent\'s Time: Use the opponent\'s turn to survey candidate moves, blunder-check, and plan next actions.',
      ],
      diagramFen: 'r1bqkb1r/pppp1ppp/2n5/4p3/2B1n3/5Q2/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
    ),

    // 16. Post-Game Analysis
    CheatSheetEntry(
      id: 'post_game_analysis',
      category: 'Tournament Play',
      title: 'Post-Game Autopsy & Analysis Protocol',
      summary: 'The grandmaster methodology for turning tournament mistakes into permanent knowledge.',
      keyQuote: '"You may learn much more from a game you lose than from a game you win." — José Raúl Capablanca',
      decisionFlowchart: 'Personal Analysis (No Engine) → Identify Turning Points → Note Psychology → Engine Audit → Flashcard Creation',
      bulletPoints: [
        '1. Engine-Free First Pass: Review the game immediately with your opponent or alone WITHOUT engine evaluation for 15-20 minutes.',
        '2. Identify Turning Points: Locate the critical move where the evaluation flipped from balanced to lost (or won to drawn).',
        '3. Reconstruct Thought Process: Record why you played the move. Did you miscalculate, overlook a counter-check, or panic on time?',
        '4. Engine Validation: Now turn on Stockfish. Compare the engine\'s top line against the candidate moves you calculated at the board.',
        '5. Root Cause Categorization: Classify the error (Tactical blindness, LPDO, opening departure, time pressure, passive defense).',
        '6. Convert to Training: Add the mistake position to your personal spaced repetition queue for retesting.',
      ],
      diagramFen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
    ),
  ];

  static List<CheatSheetEntry> search(String query) {
    if (query.trim().isEmpty) return entries;
    final q = query.toLowerCase().trim();
    return entries.where((e) {
      return e.title.toLowerCase().contains(q) ||
          e.summary.toLowerCase().contains(q) ||
          e.category.toLowerCase().contains(q) ||
          e.bulletPoints.any((b) => b.toLowerCase().contains(q)) ||
          (e.decisionFlowchart != null && e.decisionFlowchart!.toLowerCase().contains(q));
    }).toList();
  }

  static List<String> get categories =>
      entries.map((e) => e.category).toSet().toList();

  static List<CheatSheetEntry> forCategory(String category) =>
      entries.where((e) => e.category == category).toList();
}
