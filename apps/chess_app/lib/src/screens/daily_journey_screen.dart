import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';

/// Screen displaying the daily GM journey, adaptive schedule, and active weakness queue.
class DailyJourneyScreen extends StatefulWidget {
  final StorageRepository repository;
  final Function(String screenKey, {dynamic args}) onNavigate;

  const DailyJourneyScreen({
    super.key,
    required this.repository,
    required this.onNavigate,
  });

  @override
  State<DailyJourneyScreen> createState() => _DailyJourneyScreenState();
}

class _DailyJourneyScreenState extends State<DailyJourneyScreen> {
  late UserProfile _profile;
  late DailyTrainingPlan _dailyPlan;
  int _selectedBudgetMinutes = 480; // 8 hours default intensive

  @override
  void initState() {
    super.initState();
    _profile = widget.repository.getProfile();
    _selectedBudgetMinutes = _profile.dailyTimeBudgetMinutes;
    _updatePlan();
  }

  void _updatePlan() {
    _dailyPlan = DailyPlanner.generatePlan(
      curriculumDay: _profile.currentDay,
      availableBudget: Duration(minutes: _selectedBudgetMinutes),
      currentSkillNodes: widget.repository.getSkillNodes(),
    );
  }

  void _onBudgetChanged(int minutes) {
    setState(() {
      _selectedBudgetMinutes = minutes;
      _profile.dailyTimeBudgetMinutes = minutes;
      widget.repository.saveProfile(_profile);
      _updatePlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dayData = CurriculumCatalog.getDay(_profile.currentDay);
    final completionPct = (_profile.currentDay / 90.0).clamp(0.0, 1.0);
    final dueItemsCount = widget.repository.getReviewItems().where((i) => i.isDue).length;

    return Scaffold(
      backgroundColor: context.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: context.cardGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.brd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: ChessTheme.primary.withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: ChessTheme.primaryLight),
                        ),
                        child: Text(
                          dayData.phase.title.toUpperCase(),
                          style: const TextStyle(
                            color: ChessTheme.primaryLight,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'Day ${_profile.currentDay} of 90 (${(completionPct * 100).toStringAsFixed(1)}%)',
                        style: TextStyle(color: context.txtSec, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dayData.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.txt,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    dayData.theme,
                    style: TextStyle(fontSize: 14, color: context.txtSec),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: completionPct,
                      minHeight: 8,
                      backgroundColor: context.surfLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(ChessTheme.primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Time Mode Selector Row
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Text(
                  'Daily Adaptive Plan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: context.txt),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _budgetChip(context, '15m Express', 15),
                    _budgetChip(context, '60m Standard', 60),
                    _budgetChip(context, '8h Intensive GM', 480),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Spaced Review Notification Bar (if items due)
            if (dueItemsCount > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: ChessTheme.accentGold.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ChessTheme.accentGold.withAlpha(80)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.alarm, color: ChessTheme.accentGold, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$dueItemsCount spaced repetition retention items are due for review today.',
                        style: TextStyle(color: context.txt, fontSize: 13),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ChessTheme.accentGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () => widget.onNavigate('labs', args: {'labType': 'tactical_recognition'}),
                      child: const Text('Review Now', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

            // Training Blocks List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dailyPlan.blocks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final block = _dailyPlan.blocks[index];
                return _buildTrainingBlockCard(context, block);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _budgetChip(BuildContext context, String label, int minutes) {
    final isSelected = _selectedBudgetMinutes == minutes;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _onBudgetChanged(minutes),
      selectedColor: ChessTheme.primary,
      backgroundColor: context.surf,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : context.txtSec,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
    );
  }

  Widget _buildTrainingBlockCard(BuildContext context, TrainingBlock block) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surf,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: block.isMandatory ? ChessTheme.primary.withAlpha(80) : context.brd,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Duration badge
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: context.surfLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${block.scheduledDuration.inMinutes}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ChessTheme.primaryLight,
                    ),
                  ),
                  Text('MIN', style: TextStyle(fontSize: 10, color: context.txtMut)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      block.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.txt,
                      ),
                    ),
                    if (block.isMandatory)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: ChessTheme.primary.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'MANDATORY',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  block.objective,
                  style: TextStyle(fontSize: 12, color: context.txtSec),
                ),
              ],
            ),
          ),

          // Launch action button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: context.surfLight,
              foregroundColor: ChessTheme.primaryLight,
              side: const BorderSide(color: ChessTheme.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (block.labType == 'serious_game') {
                widget.onNavigate('play', args: {'isTournament': true});
              } else if (block.labType == 'self_analysis') {
                widget.onNavigate('analysis');
              } else {
                widget.onNavigate('labs', args: {'labType': block.labType});
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Start', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
