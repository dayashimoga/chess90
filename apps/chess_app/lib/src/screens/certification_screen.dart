import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';
import '../widgets/radar/skill_radar_widget.dart';

/// Screen presenting the Day 1 vs Day 90 certified comparison, mastery radar,
/// official certificate, and Next 90-day master roadmap.
class CertificationScreen extends StatelessWidget {
  final StorageRepository repository;

  const CertificationScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final profile = repository.getProfile();
    final nodes = repository.getSkillNodes();
    final currentRadar = MasteryGates.computeRadarValues(nodes);

    // Baseline values (Day 1 comparison: ~0.35 baseline)
    final baselineRadar = {
      for (final axis in SkillAxis.values) axis: 0.35,
    };

    final overallMasteryPct = MasteryGates.computeOverallMasteryPercentage(nodes);

    return Scaffold(
      backgroundColor: ChessTheme.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 16 : 32),
        child: Column(
          children: [
            // Official Certificate Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width < 600 ? 16 : 36),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ChessTheme.accentGold, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: ChessTheme.accentGold.withAlpha(30),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium, size: 64, color: ChessTheme.accentGold),
                  const SizedBox(height: 16),
                  const Text(
                    'CHESSMASTER GM-STYLE MASTERY PROGRAM',
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: ChessTheme.accentGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'CHESSMASTER 90-DAY MASTERY ASSESSMENT & COMPLETION REPORT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: ChessTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This certifies that ${profile.username} has completed the rigorous 90-Day ChessMaster Training Program, internalizing grandmaster calculation trees, root-cause blunder diagnostics, theoretical endgames, and tournament discipline.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, height: 1.6, color: ChessTheme.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  // Important FIDE Disclaimer
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ChessTheme.accentGold.withAlpha(80)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.gavel_outlined, size: 18, color: ChessTheme.accentGold),
                        SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'Official Disclaimer: Certifies analytical & calculation mastery within the 90-day program. This report does NOT confer an official FIDE title (GM, IM, FM, CM) or official FIDE rating, which require over-the-board tournament play in FIDE-sanctioned events.',
                            style: TextStyle(fontSize: 12, height: 1.4, color: ChessTheme.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Radar Comparison Section
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 800;

                final radarCard = Container(
                  height: 440,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ChessTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ChessTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          const Text(
                            'Day 1 vs Day 90 Mastery Radar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ChessTheme.textPrimary),
                          ),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              _legendItem('Day 1 Baseline (35%)', ChessTheme.accentGold),
                              _legendItem('Day 90 Certified (${overallMasteryPct.toStringAsFixed(0)}%)', ChessTheme.primaryLight),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SkillRadarWidget(
                          currentScores: currentRadar,
                          baselineScores: baselineRadar,
                        ),
                      ),
                    ],
                  ),
                );

                final roadmapCard = Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ChessTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ChessTheme.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Next 90-Day Advanced Master Roadmap',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ChessTheme.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      _roadmapStep(
                        'Days 91–120: Classical Opening Deepening',
                        'Master subordinate critical sidelines and rare transpositions across your core systems.',
                      ),
                      _roadmapStep(
                        'Days 121–150: Dvoretsky-Level Endgame Technique',
                        'Complex queen-and-pawn and opposite-colored bishop multi-piece transitions.',
                      ),
                      _roadmapStep(
                        'Days 151–180: Real-World Tournament Campaign',
                        'Register for in-person FIDE / national rated tournaments with rigorous self-annotation.',
                      ),
                    ],
                  ),
                );

                if (isNarrow) {
                  return Column(
                    children: [
                      radarCard,
                      const SizedBox(height: 24),
                      roadmapCard,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: radarCard),
                    const SizedBox(width: 24),
                    Expanded(flex: 4, child: roadmapCard),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: ChessTheme.textSecondary)),
      ],
    );
  }

  Widget _roadmapStep(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, color: ChessTheme.primaryLight),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: ChessTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontSize: 12, color: ChessTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
