import 'package:chess_core/chess_core.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../../theme/chess_theme.dart';
import '../board/chess_board_widget.dart';

/// 5-Tier First-Run Onboarding Modal ensuring beginners are taught before tested.
/// Offers:
/// 1. New to Chess (Day 1)
/// 2. Know the Basics (Day 8: Tactics & Motifs)
/// 3. Intermediate (Day 22: Positional Strategy & Planning)
/// 4. Advanced (Day 57: Opening Mastery & Deep Endgames)
/// 5. Optional Diagnostic / Test Out (Gentle 5-question baseline test that never blocks learning)
class OnboardingDialog extends StatefulWidget {
  final StorageRepository repository;
  final Function(int selectedDay)? onPlanSelected;

  const OnboardingDialog({
    super.key,
    required this.repository,
    this.onPlanSelected,
  });

  static Future<void> showIfNeeded(BuildContext context, StorageRepository repo, {Function(int day)? onPlanSelected}) async {
    final profile = repo.getProfile();
    if (!profile.hasCompletedDiagnostic && profile.completedDays.isEmpty) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => OnboardingDialog(
          repository: repo,
          onPlanSelected: onPlanSelected,
        ),
      );
    }
  }

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  bool _inDiagnosticMode = false;
  int _diagnosticIndex = 0;
  int _diagnosticScore = 0;
  String? _feedback;

  // 5 gentle baseline questions for optional test-out
  static final List<Map<String, dynamic>> _diagnosticQuestions = [
    {
      'title': 'Question 1 of 5: Fundamentals',
      'instruction': 'White to move: Strike the center with King\'s pawn.',
      'fen': 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      'solution': 'e4',
      'levelIfPassed': 8,
      'explanation': '1. e4 takes immediate control of central squares d5 and f5.',
    },
    {
      'title': 'Question 2 of 5: Hanging Pieces (LPDO)',
      'instruction': 'White to move: Capture the undefended black knight.',
      'fen': 'r1bqk2r/pppp1ppp/2n5/2b1p3/4n3/3P1N2/PPP2PPP/RNBQKB1R w KQkq - 0 5',
      'solution': 'dxe4',
      'levelIfPassed': 15,
      'explanation': 'dxe4 captures the loose knight on e4 winning 3 points.',
    },
    {
      'title': 'Question 3 of 5: Back-Rank Mate',
      'instruction': 'White to move: Deliver checkmate on the back rank.',
      'fen': '6k1/5ppp/8/8/8/8/5PPP/4R1K1 w - - 0 1',
      'solution': 'Re8#',
      'levelIfPassed': 22,
      'explanation': 'Re8# delivers back-rank checkmate behind friendly pawns.',
    },
    {
      'title': 'Question 4 of 5: Tactical Pin Strike',
      'instruction': 'White to move: Exploit the pin on the knight with pawn push.',
      'fen': 'r1bqkb1r/pppp1ppp/2n5/4p3/1b2n3/3P1N2/PPP2PPP/RNBQKB1R w KQkq - 0 5',
      'solution': 'c3',
      'levelIfPassed': 43,
      'explanation': 'c3 blocks the checking bishop while maintaining tactical tension.',
    },
    {
      'title': 'Question 5 of 5: Endgame Promotion Race',
      'instruction': 'White to move: Push the outside passed pawn toward promotion.',
      'fen': '8/8/5k2/P7/8/8/8/4K3 w - - 0 1',
      'solution': 'a6',
      'levelIfPassed': 57,
      'explanation': 'a6 guarantees the pawn will promote cleanly into a Queen.',
    },
  ];

  void _chooseLevel(int day, String tierName) {
    final profile = widget.repository.getProfile();
    profile.currentDay = day;
    profile.hasCompletedDiagnostic = true;

    // Mark previous days completed if jumping ahead
    if (day > 1) {
      for (int i = 1; i < day; i++) {
        profile.completedDays.add(i);
      }
    }

    widget.repository.saveProfile(profile);
    widget.onPlanSelected?.call(day);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Welcome to ChessMaster! Program customized starting at Day $day ($tierName).'),
        backgroundColor: ChessTheme.primaryLight,
      ),
    );
  }

  void _handleDiagnosticMove(Move move) {
    final q = _diagnosticQuestions[_diagnosticIndex];
    final currentBoard = Board.fromFen(q['fen'] as String);
    final san = MoveGenerator.moveToSan(currentBoard, move);

    final expectedSan = q['solution'] as String;
    final isCorrect = san == expectedSan;

    setState(() {
      if (isCorrect) {
        _diagnosticScore++;
        _feedback = 'Correct! $san — ${q['explanation']}';
      } else {
        _feedback = 'Note: $san was played. Model move was $expectedSan.';
      }
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      if (_diagnosticIndex + 1 < _diagnosticQuestions.length) {
        setState(() {
          _diagnosticIndex++;
          _feedback = null;
        });
      } else {
        // Conclude diagnostic
        int recommendedDay = 1;
        String tier = 'Beginner Track';
        if (_diagnosticScore == 5) {
          recommendedDay = 57;
          tier = 'Advanced Track';
        } else if (_diagnosticScore >= 3) {
          recommendedDay = 22;
          tier = 'Intermediate Strategy';
        } else if (_diagnosticScore >= 1) {
          recommendedDay = 8;
          tier = 'Tactics Foundation';
        }
        _chooseLevel(recommendedDay, tier);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_inDiagnosticMode) {
      return _buildDiagnosticView();
    }
    return _buildSelectionView();
  }

  Widget _buildSelectionView() {
    return Dialog(
      backgroundColor: context.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 680,
        constraints: const BoxConstraints(maxHeight: 740),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.brd, width: 1.5),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ChessTheme.primary.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.school, color: ChessTheme.primaryLight, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalize Your 90-Day Journey',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: context.txt,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'We teach before testing. Choose your starting experience level:',
                          style: TextStyle(fontSize: 12, color: context.txtMut),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Option 1: New to Chess
              _buildTierCard(
                icon: Icons.child_care,
                title: 'New to Chess',
                subtitle: 'Day 1 — Rules, coordinates, piece movement & board vision from scratch.',
                badge: 'Recommended for Beginners',
                badgeColor: Colors.blueAccent,
                onTap: () => _chooseLevel(1, 'New to Chess'),
              ),
              const SizedBox(height: 10),

              // Option 2: Know the Basics
              _buildTierCard(
                icon: Icons.extension,
                title: 'Know the Basics',
                subtitle: 'Day 8 — Jump directly to forks, pins, skewers, deflection & tactical motifs.',
                badge: 'Casual / ~1000 Rating',
                badgeColor: Colors.teal,
                onTap: () => _chooseLevel(8, 'Know the Basics'),
              ),
              const SizedBox(height: 10),

              // Option 3: Intermediate
              _buildTierCard(
                icon: Icons.military_tech,
                title: 'Intermediate',
                subtitle: 'Day 22 — Positional strategy, outposts, weak complexes, pawn chains & planning.',
                badge: 'Club / ~1400 Rating',
                badgeColor: Colors.amber.shade700,
                onTap: () => _chooseLevel(22, 'Intermediate'),
              ),
              const SizedBox(height: 10),

              // Option 4: Advanced
              _buildTierCard(
                icon: Icons.workspace_premium,
                title: 'Advanced',
                subtitle: 'Day 57 — Compact opening repertoires, Lucena/Philidor endgames & master model games.',
                badge: 'Tournament / ~1700+ Rating',
                badgeColor: Colors.purpleAccent,
                onTap: () => _chooseLevel(57, 'Advanced'),
              ),
              const SizedBox(height: 14),

              const Divider(),
              const SizedBox(height: 10),

              // Option 5: Optional Diagnostic / Test Out
              OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _inDiagnosticMode = true;
                    _diagnosticIndex = 0;
                    _diagnosticScore = 0;
                    _feedback = null;
                  });
                },
                icon: const Icon(Icons.speed, size: 20),
                label: const Text('Optional Diagnostic / Test Out (5 Gentle Questions)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: ChessTheme.primaryLight.withAlpha(160)),
                  foregroundColor: ChessTheme.primaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'The diagnostic test is 100% optional and never blocks your learning access.',
                  style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: context.txtMut),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.surf,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.brd),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: badgeColor.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: badgeColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: context.txt,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: badgeColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: badgeColor.withAlpha(80)),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: context.txtMut),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.txtMut),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticView() {
    final q = _diagnosticQuestions[_diagnosticIndex];
    final board = Board.fromFen(q['fen'] as String);

    return Dialog(
      backgroundColor: context.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.brd),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    q['title'] as String,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.txt),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => _inDiagnosticMode = false);
                    },
                    child: const Text('Cancel & Pick Manually'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                q['instruction'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ChessTheme.primaryLight),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 320,
                height: 320,
                child: ChessBoardWidget(
                  board: board,
                  isInteractive: _feedback == null,
                  onMovePlayed: _handleDiagnosticMove,
                ),
              ),
              const SizedBox(height: 12),
              if (_feedback != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    _feedback!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                )
              else
                Text(
                  'Make your move on the board above. Take your time!',
                  style: TextStyle(fontSize: 12, color: context.txtMut),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
