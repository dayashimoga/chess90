import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_learning/chess_learning.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';
import '../widgets/curriculum/onboarding_dialog.dart';

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

  String _getCausalWhyText(CurriculumDay day) {
    final weakNodes = widget.repository.getSkillNodes().where((n) => n.status == SkillStatus.reviewDue || n.status == SkillStatus.learning).toList();
    if (weakNodes.isNotEmpty) {
      final node = weakNodes.first;
      return '${node.axis.title} prioritized today because your recent drill accuracy was ${(node.isolatedAccuracy * 100).toStringAsFixed(0)}% with ${node.recurrenceCount} recurring inaccuracies.';
    }
    if (day.dayNumber > 1) {
      return 'Today\'s lesson directly builds on Day ${day.dayNumber - 1} foundational knowledge, spiraling into deeper pattern synthesis.';
    }
    return 'Welcome! Today establishes the visual coordinate reflexes and board anatomy essential for all future tactical calculations.';
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
            // Onboarding Level Selection Banner (Non-blocking)
            if (!_profile.hasCompletedDiagnostic)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ChessTheme.primary.withAlpha(25),
                      ChessTheme.accentGold.withAlpha(25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ChessTheme.primaryLight.withAlpha(100)),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.explore, color: ChessTheme.accentGold, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'First Time? Select Your Starting Level',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.txt),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Choose from 5 tiers or take an optional diagnostic.',
                                  style: TextStyle(fontSize: 12, color: context.txtSec),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _profile.hasCompletedDiagnostic = true;
                              widget.repository.saveProfile(_profile);
                            });
                          },
                          child: const Text('Start Day 1 (Beginner)'),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.tune, size: 16),
                          label: const Text('Choose Tier / Diagnostic'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ChessTheme.primary,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (ctx) => OnboardingDialog(
                                repository: widget.repository,
                                onPlanSelected: (day) {
                                  setState(() {
                                    _profile = widget.repository.getProfile();
                                    _updatePlan();
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Unfinished Game Quick-Resume Banner
            Builder(
              builder: (ctx) {
                final unfinished = widget.repository.getUnfinishedGame();
                if (unfinished == null) return const SizedBox.shrink();

                final movesCount = (unfinished.moveSanList.length / 2).ceil();
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: ChessTheme.accentGold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ChessTheme.accentGold.withOpacity(0.4)),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.play_circle_filled, color: ChessTheme.accentGold, size: 28),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Match in Progress (${unfinished.timeControl.toUpperCase()})',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: context.txt,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Move $movesCount • ${unfinished.whiteRemainingSeconds}s vs ${unfinished.blackRemainingSeconds}s',
                                style: TextStyle(fontSize: 12, color: context.txtSec),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              widget.repository.clearUnfinishedGame();
                              setState(() {});
                            },
                            child: const Text('Discard'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.play_arrow, size: 16),
                            label: const Text('Resume Game'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ChessTheme.accentGold,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () => widget.onNavigate('play'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

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
                  const SizedBox(height: 16),

                  // Causal "WHY" Diagnostic Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple.withAlpha(60)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.psychology, color: Colors.purpleAccent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'WHY THIS IS PRIORITIZED TODAY:',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                _getCausalWhyText(dayData),
                                style: TextStyle(fontSize: 12, height: 1.3, color: context.txt),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Primary Lesson Player Launcher
                  FilledButton.icon(
                    onPressed: () => widget.onNavigate('curriculum', args: {'dayNumber': _profile.currentDay}),
                    icon: const Icon(Icons.school, size: 18),
                    label: Text('Start Day ${_profile.currentDay}: 8-Stage Interactive Lesson'),
                    style: FilledButton.styleFrom(
                      backgroundColor: ChessTheme.primaryLight,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
