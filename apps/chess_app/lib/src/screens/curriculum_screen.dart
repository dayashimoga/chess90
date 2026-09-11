import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';

/// 90-Day Curriculum browser and study material reader.
class CurriculumScreen extends StatefulWidget {
  final StorageRepository repository;
  final Function(String screenKey, {dynamic args}) onNavigate;

  const CurriculumScreen({
    super.key,
    required this.repository,
    required this.onNavigate,
  });

  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  CurriculumPhase? _selectedPhase;
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    final allDays = CurriculumCatalog.allDays;
    final filteredDays = _selectedPhase == null
        ? allDays
        : allDays.where((d) => d.phase == _selectedPhase).toList();

    final currentDayData = CurriculumCatalog.getDay(_selectedDay);

    return Scaffold(
      backgroundColor: ChessTheme.background,
      body: Row(
        children: [
          // Left Sidebar: 90-Day Timeline Navigator
          SizedBox(
            width: 380,
            child: Container(
              decoration: const BoxDecoration(
                color: ChessTheme.surface,
                border: Border(right: BorderSide(color: ChessTheme.border)),
              ),
              child: Column(
                children: [
                  // Phase Selector Dropdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: ChessTheme.border)),
                    ),
                    child: DropdownButtonFormField<CurriculumPhase?>(
                      value: _selectedPhase,
                      isExpanded: true,
                      dropdownColor: ChessTheme.surfaceLight,
                      decoration: InputDecoration(
                        labelText: 'Filter by Curriculum Phase',
                        labelStyle: const TextStyle(
                            color: ChessTheme.textSecondary, fontSize: 12),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: ChessTheme.border),
                        ),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('All 90 Days (Complete Program)',
                              style: TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis),
                        ),
                        ...CurriculumPhase.values.map((phase) {
                          return DropdownMenuItem(
                            value: phase,
                            child: Text(
                              phase.title,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedPhase = val;
                        });
                      },
                    ),
                  ),

                  // Day List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredDays.length,
                      itemBuilder: (context, index) {
                        final day = filteredDays[index];
                        final isSelected = day.dayNumber == _selectedDay;
                        final isPassed = widget.repository
                            .getProfile()
                            .passedExams
                            .contains(day.dayNumber);

                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            selected: isSelected,
                            selectedTileColor: ChessTheme.surfaceLight,
                            onTap: () {
                              setState(() {
                                _selectedDay = day.dayNumber;
                              });
                            },
                            leading: CircleAvatar(
                              radius: 16,
                              backgroundColor: day.isWeeklyExam
                                  ? ChessTheme.accentGold.withAlpha(40)
                                  : (isSelected
                                      ? ChessTheme.primary
                                      : ChessTheme.surfaceLight),
                              child: Text(
                                '${day.dayNumber}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: day.isWeeklyExam
                                      ? ChessTheme.accentGold
                                      : (isSelected
                                          ? Colors.black
                                          : ChessTheme.textPrimary),
                                ),
                              ),
                            ),
                            title: Text(
                              day.title,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: ChessTheme.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              day.theme,
                              style: const TextStyle(
                                  fontSize: 11, color: ChessTheme.textMuted),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: day.isWeeklyExam
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isPassed
                                          ? ChessTheme.primary.withAlpha(40)
                                          : ChessTheme.accentGold.withAlpha(40),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: isPassed
                                            ? ChessTheme.primary
                                            : ChessTheme.accentGold,
                                      ),
                                    ),
                                    child: Text(
                                      isPassed ? 'PASSED' : 'EXAM',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: isPassed
                                            ? ChessTheme.primaryLight
                                            : ChessTheme.accentGold,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Pane: Detailed Day Content & Exercises
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Meta
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentDayData.phase.title.toUpperCase(),
                              style: const TextStyle(
                                  color: ChessTheme.primaryLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentDayData.title,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: ChessTheme.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Launch Practice Lab',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ChessTheme.primary,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          widget.onNavigate('labs', args: {
                            'dayNumber': currentDayData.dayNumber,
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Objectives Box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ChessTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ChessTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: ChessTheme.primary, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Core Learning Objectives',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ChessTheme.textPrimary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...currentDayData.learningObjectives
                            .map((obj) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ',
                                          style: TextStyle(
                                              color: ChessTheme.primaryLight,
                                              fontSize: 16)),
                                      Expanded(
                                        child: Text(obj,
                                            style: const TextStyle(
                                                color: ChessTheme.textSecondary,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Theory Text
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ChessTheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: ChessTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Educational Material & Grandmaster Principles',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ChessTheme.textPrimary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentDayData.theoryMarkdown,
                          style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: ChessTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Interactive Exercises in this Day
                  const Text(
                    'Interactive Lab Exercises',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ChessTheme.textPrimary),
                  ),
                  const SizedBox(height: 12),

                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: currentDayData.exercises.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final ex = currentDayData.exercises[i];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ChessTheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ChessTheme.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: ChessTheme.surfaceLight,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ChessTheme.primaryLight),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ex.instruction,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ChessTheme.textPrimary),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Motif: ${ex.motif} • Side: ${ex.sideToPlay.name.toUpperCase()}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: ChessTheme.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ChessTheme.surfaceLight,
                                foregroundColor: ChessTheme.primaryLight,
                              ),
                              onPressed: () {
                                widget.onNavigate('labs', args: {
                                  'exerciseId': ex.id,
                                  'dayNumber': currentDayData.dayNumber,
                                });
                              },
                              child: const Text('Practice'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
