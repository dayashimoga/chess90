import 'package:chess_engine/chess_engine.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';
import '../widgets/radar/skill_radar_widget.dart';

/// Comprehensive weakness and blunder analytics workspace showing
/// 14 root cause distributions, recurrence, and actionable training prescriptions.
class WeaknessAnalyticsScreen extends StatelessWidget {
  final StorageRepository repository;
  final Function(String screenKey, {dynamic args})? onNavigate;

  const WeaknessAnalyticsScreen({
    super.key,
    required this.repository,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final skillNodes = repository.getSkillNodes();
    final reviewItems = repository.getReviewItems();

    // Map skill nodes to radar values
    final radarValues = <SkillAxis, double>{};
    for (final node in skillNodes) {
      radarValues[node.axis] = node.compositeScore;
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ChessTheme.qualityBlunder.withAlpha(30),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.troubleshoot, color: ChessTheme.qualityBlunder, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'WEAKNESS & COGNITIVE ROOT-CAUSE ANALYTICS',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
                        ),
                        Text(
                          '14-Axis diagnostic decomposition and retraining',
                          style: TextStyle(fontSize: 12, color: ChessTheme.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ChessTheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ChessTheme.border),
                  ),
                  child: Text(
                    'ACTIVE QUEUE: ${reviewItems.length} DRILLS',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Top Row: Radar & Cognitive Domain Summary
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 900;
                if (isCompact) {
                  return Column(
                    children: [
                      _buildRadarCard(radarValues),
                      const SizedBox(height: 16),
                      _buildCognitiveDomainsCard(),
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildRadarCard(radarValues)),
                    const SizedBox(width: 20),
                    Expanded(flex: 6, child: _buildCognitiveDomainsCard()),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // 14 Root Causes Breakdown
            const Text(
              '14 HIERARCHICAL ROOT-CAUSE BREAKDOWN',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cognitive categorization of calculation errors, strategic misjudgments, and psychological time slips.',
              style: TextStyle(fontSize: 12, color: ChessTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            _buildRootCauseGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarCard(Map<SkillAxis, double> radarValues) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ChessTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ChessTheme.border),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('12-Axis Skill Radar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Real Stored Metrics', style: TextStyle(fontSize: 11, color: ChessTheme.textMuted)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: SkillRadarWidget(currentScores: radarValues),
          ),
        ],
      ),
    );
  }

  Widget _buildCognitiveDomainsCard() {
    final domains = [
      {'domain': 'Calculation & Candidate Search', 'desc': 'Candidate generation, visualization, horizon depth, and blunder checks.', 'icon': Icons.psychology, 'color': ChessTheme.secondary},
      {'domain': 'Tactical Vision & Defense', 'desc': 'Tactical motifs, forcing opponent replies, and tenacious defensive resources.', 'icon': Icons.bolt, 'color': ChessTheme.accentGold},
      {'domain': 'Positional & Strategic Precision', 'desc': 'Pawn structure breaks, outposts, static evaluations, and opening transitions.', 'icon': Icons.grid_view, 'color': ChessTheme.primary},
      {'domain': 'Endgame Technique & Conversion', 'desc': 'Theoretical precision (Lucena/Philidor) and converting decisive winning advantages.', 'icon': Icons.flag, 'color': ChessTheme.qualityBrilliant},
      {'domain': 'Psychology & Time Discipline', 'desc': 'Clock management, avoiding impulsive moves, and sitting on hands before committing.', 'icon': Icons.timer, 'color': ChessTheme.qualityMistake},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ChessTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ChessTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cognitive Diagnostic Domains', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 12),
          ...domains.map((d) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (d['color'] as Color).withAlpha(30),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(d['icon'] as IconData, size: 16, color: d['color'] as Color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d['domain'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                        Text(d['desc'] as String, style: const TextStyle(fontSize: 11, color: ChessTheme.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRootCauseGrid(BuildContext context) {
    final categories = [
      RootCauseCategory.tacticsMotif,
      RootCauseCategory.candidateGeneration,
      RootCauseCategory.opponentForcingMoveBlindness,
      RootCauseCategory.visualization,
      RootCauseCategory.horizon,
      RootCauseCategory.quietMoveBlindness,
      RootCauseCategory.finalEvaluation,
      RootCauseCategory.pawnStructureStrategy,
      RootCauseCategory.openingUnderstandingMemory,
      RootCauseCategory.endgameTheory,
      RootCauseCategory.conversion,
      RootCauseCategory.defense,
      RootCauseCategory.timeManagement,
      RootCauseCategory.blunderCheckOmission,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 140,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, idx) {
        final cat = categories[idx];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: ChessTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ChessTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cat.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: ChessTheme.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Day ${cat.defaultCurriculumDay}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  cat.description,
                  style: const TextStyle(fontSize: 11, color: ChessTheme.textSecondary),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              const Divider(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lab: ${cat.prescribedLabType}',
                    style: const TextStyle(fontSize: 10, color: ChessTheme.textMuted),
                  ),
                  InkWell(
                    onTap: () => onNavigate?.call('labs', args: {'labType': cat.prescribedLabType}),
                    child: const Row(
                      children: [
                        Text('Train', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight)),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward, size: 12, color: ChessTheme.primaryLight),
                      ],
                    ),
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
