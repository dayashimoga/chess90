import 'package:chess_curriculum/chess_curriculum.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import '../theme/chess_theme.dart';
import '../widgets/curriculum/lesson_player_widget.dart';
import '../widgets/curriculum/reference_library_dialog.dart';

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
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _launchLessonPlayer(CurriculumDay day) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => LessonPlayerWidget(
        day: day,
        repository: widget.repository,
        onLessonCompleted: () {
          setState(() {
            final profile = widget.repository.getProfile();
            profile.completedDays.add(day.dayNumber);
            if (day.dayNumber == profile.currentDay && profile.currentDay < 90) {
              profile.currentDay++;
            }
            widget.repository.saveProfile(profile);
          });
          Navigator.of(ctx).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Congratulations! Day ${day.dayNumber} mastered and certified.'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allDays = CurriculumCatalog.allDays;
    final profile = widget.repository.getProfile();

    final filteredDays = allDays.where((d) {
      if (_selectedPhase != null && d.phase != _selectedPhase) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchesNum = d.dayNumber.toString() == query;
        final matchesTopic = d.topic.toLowerCase().contains(query);
        final matchesTheme = d.theme.toLowerCase().contains(query);
        final matchesAxis = d.primarySkillAxis.name.toLowerCase().contains(query);
        final matchesTitle = d.title.toLowerCase().contains(query);
        final matchesObj = d.learningObjectives.any((o) => o.toLowerCase().contains(query));
        return matchesNum || matchesTopic || matchesTheme || matchesAxis || matchesTitle || matchesObj;
      }
      return true;
    }).toList();

    final currentDayData = CurriculumCatalog.getDay(_selectedDay);

    return Scaffold(
      backgroundColor: context.bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 1050;
          final sidebarWidth = constraints.maxWidth > 900
              ? 350.0
              : (constraints.maxWidth > 650 ? 290.0 : 250.0);

          return Row(
            children: [
              // Left Sidebar: 90-Day Timeline Navigator with Search & Filter
              SizedBox(
                width: sidebarWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.surf,
                    border: Border(right: BorderSide(color: context.brd)),
                  ),
                  child: Column(
                    children: [
                      // Search & Phase Filter Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: context.brd)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Search Box
                            TextField(
                              key: const Key('curriculum_search_field'),
                              controller: _searchController,
                              style: TextStyle(color: context.txt, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Search day, topic, or skill...',
                                hintStyle: TextStyle(color: context.txtMut, fontSize: 12),
                                prefixIcon: Icon(Icons.search, size: 18, color: context.txtSec),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.clear, size: 16),
                                        onPressed: () {
                                          setState(() {
                                            _searchController.clear();
                                            _searchQuery = '';
                                          });
                                        },
                                      )
                                    : null,
                                filled: true,
                                fillColor: context.surfLight,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: context.brd),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            // Phase Selector Dropdown
                            DropdownButtonFormField<CurriculumPhase?>(
                              value: _selectedPhase,
                              isExpanded: true,
                              dropdownColor: context.surfLight,
                              decoration: InputDecoration(
                                labelText: 'Curriculum Phase',
                                labelStyle: TextStyle(color: context.txtSec, fontSize: 11),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: context.brd),
                                ),
                              ),
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('All 90 Days (Complete Program)',
                                      style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
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
                            const SizedBox(height: 6),
                            Text(
                              'Showing ${filteredDays.length} of ${allDays.length} days',
                              style: TextStyle(fontSize: 11, color: context.txtMut),
                            ),
                          ],
                        ),
                      ),

                      // Day List
                      Expanded(
                        child: filteredDays.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    'No curriculum days match "$_searchQuery".',
                                    style: TextStyle(color: context.txtSec, fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredDays.length,
                                itemBuilder: (context, index) {
                                  final day = filteredDays[index];
                                  final isSelected = day.dayNumber == _selectedDay;
                                  final isPassedExam = profile.passedExams.contains(day.dayNumber);
                                  final isCurrent = day.dayNumber == profile.currentDay;
                                  final isCompleted = day.dayNumber < profile.currentDay;

                                  // Determine status badge
                                  Widget? statusBadge;
                                  if (isCurrent) {
                                    statusBadge = Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: ChessTheme.primary.withAlpha(50),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: ChessTheme.primary),
                                      ),
                                      child: const Text(
                                        'CURRENT',
                                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                                      ),
                                    );
                                  } else if (day.isWeeklyExam) {
                                    statusBadge = Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isPassedExam
                                            ? Colors.green.withAlpha(40)
                                            : ChessTheme.accentGold.withAlpha(40),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: isPassedExam ? Colors.green : ChessTheme.accentGold,
                                        ),
                                      ),
                                      child: Text(
                                        isPassedExam ? 'PASSED' : 'EXAM',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isPassedExam ? Colors.greenAccent : ChessTheme.accentGold,
                                        ),
                                      ),
                                    );
                                  } else if (isCompleted) {
                                    statusBadge = Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withAlpha(30),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'DONE',
                                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                                      ),
                                    );
                                  }

                                  return Tooltip(
                                    message: '${day.displayLabel}\nTarget: ${day.learningObjectives.firstOrNull ?? day.theme}',
                                    waitDuration: const Duration(milliseconds: 400),
                                    child: Material(
                                      color: isSelected ? context.surfLight : Colors.transparent,
                                      child: InkWell(
                                        key: Key('curriculum_day_tile_${day.dayNumber}'),
                                        onTap: () {
                                          setState(() {
                                            _selectedDay = day.dayNumber;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(color: context.brd.withAlpha(60)),
                                              left: isSelected
                                                  ? const BorderSide(color: ChessTheme.primary, width: 3)
                                                  : BorderSide.none,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: 14,
                                                backgroundColor: day.isWeeklyExam
                                                    ? ChessTheme.accentGold.withAlpha(40)
                                                    : (isSelected ? ChessTheme.primary : context.surfLight),
                                                child: Text(
                                                  '${day.dayNumber}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: day.isWeeklyExam
                                                        ? ChessTheme.accentGold
                                                        : (isSelected ? Colors.black : context.txt),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      day.displayLabel,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                        color: isSelected ? context.txt : context.txt.withAlpha(220),
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      day.learningObjectives.firstOrNull ?? day.theme,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: context.txtMut,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (statusBadge != null) ...[
                                                const SizedBox(width: 6),
                                                statusBadge,
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Phase, Display Label, Meta Badges & Action
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isCompact = constraints.maxWidth < 1100;
                          final infoColumn = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentDayData.phase.title.toUpperCase(),
                                style: const TextStyle(
                                  color: ChessTheme.primaryLight,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                currentDayData.displayLabel,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: context.txt,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Meta Chips
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Chip(
                                    avatar: const Icon(Icons.star, size: 14, color: ChessTheme.accentGold),
                                    label: Text('Elo ${currentDayData.difficultyRating}'),
                                    backgroundColor: context.surfLight,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  Chip(
                                    avatar: const Icon(Icons.timer_outlined, size: 14, color: ChessTheme.primaryLight),
                                    label: Text('${currentDayData.estimatedMinutes} min'),
                                    backgroundColor: context.surfLight,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  Chip(
                                    avatar: const Icon(Icons.track_changes, size: 14, color: Colors.cyanAccent),
                                    label: Text(currentDayData.primarySkillAxis.name.toUpperCase()),
                                    backgroundColor: context.surfLight,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  Chip(
                                    avatar: const Icon(Icons.science_outlined, size: 14, color: Colors.purpleAccent),
                                    label: Text(currentDayData.referencedLabId),
                                    backgroundColor: context.surfLight,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  if (currentDayData.isWeeklyExam)
                                    Chip(
                                      avatar: const Icon(Icons.verified, size: 14, color: Colors.orangeAccent),
                                      label: Text('Pass: ${(currentDayData.examPassThreshold * 100).toInt()}%'),
                                      backgroundColor: context.surfLight,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                ],
                              ),
                            ],
                          );

                          final actionButtons = Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.menu_book, size: 16),
                                label: const Text('Cheat Sheets / Reference'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: context.txt,
                                  side: BorderSide(color: context.brd),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => ReferenceLibraryDialog.show(context),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.school, size: 16),
                                label: const Text('Start 8-Stage Lesson',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ChessTheme.primaryLight,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _launchLessonPlayer(currentDayData),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.play_arrow),
                                label: const Text('Launch Lab',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ChessTheme.primary,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  widget.onNavigate('labs', args: {
                                    'dayNumber': currentDayData.dayNumber,
                                  });
                                },
                              ),
                            ],
                          );

                          if (isCompact) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                infoColumn,
                                const SizedBox(height: 16),
                                actionButtons,
                              ],
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: infoColumn),
                              const SizedBox(width: 16),
                              actionButtons,
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Pedagogical 8-Stage Flow Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: ChessTheme.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: ChessTheme.primaryLight.withAlpha(80)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_stories, color: ChessTheme.primaryLight, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      '8-STAGE FLOW',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                        color: ChessTheme.primaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'No Reading-Only Completion',
                                  style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: context.txtMut),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'LEARN → SEE → UNDERSTAND → GUIDED PRACTICE → INDEPENDENT PRACTICE → MINI-GAME → REVIEW → RETENTION TEST',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.txt),
                            ),
                            const SizedBox(height: 12),
                            FilledButton.icon(
                              onPressed: () => _launchLessonPlayer(currentDayData),
                              icon: const Icon(Icons.play_circle_outline, size: 18),
                              label: Text('Launch Interactive Lesson Player (Day ${currentDayData.dayNumber})'),
                              style: FilledButton.styleFrom(backgroundColor: ChessTheme.primaryLight),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Objectives Box
                      Container(
                        padding: const EdgeInsets.all(18),
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
                                const Icon(Icons.check_circle_outline, color: ChessTheme.primary, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Core Learning Objectives',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: context.txt),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...currentDayData.learningObjectives.map((obj) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('• ',
                                          style: TextStyle(color: ChessTheme.primaryLight, fontSize: 16, fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(obj, style: TextStyle(color: context.txtSec, fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Theory Text
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: context.surf,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: context.brd),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Educational Material & Grandmaster Principles',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.txt),
                            ),
                            const SizedBox(height: 14),
                            _buildTheoryMarkdownView(context, currentDayData.theoryMarkdown),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Responsive Worked Examples & Game Study
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildWorkedExamplesCard(context, currentDayData)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildGameStudyCard(context, currentDayData)),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildWorkedExamplesCard(context, currentDayData),
                            const SizedBox(height: 16),
                            _buildGameStudyCard(context, currentDayData),
                          ],
                        ),

                      const SizedBox(height: 20),

                      // Responsive Practice Task & Remediation
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _buildPracticeCard(context, currentDayData)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildRemediationCard(context, currentDayData)),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildPracticeCard(context, currentDayData),
                            const SizedBox(height: 16),
                            _buildRemediationCard(context, currentDayData),
                          ],
                        ),

                      const SizedBox(height: 20),

                      // Interactive Exercises in this Day
                      Text(
                        'Interactive Lab Exercises',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.txt),
                      ),
                      const SizedBox(height: 10),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentDayData.exercises.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final ex = currentDayData.exercises[i];
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: context.surf,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: context.brd),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: context.surfLight,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ex.instruction,
                                        style: TextStyle(fontWeight: FontWeight.bold, color: context.txt, fontSize: 13),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Motif: ${ex.motif} • Side: ${ex.sideToPlay.name.toUpperCase()} • FEN: ${ex.fen}',
                                        style: TextStyle(fontSize: 11, color: context.txtMut),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.surfLight,
                                    foregroundColor: ChessTheme.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                  onPressed: () {
                                    widget.onNavigate('labs', args: {
                                      'exerciseId': ex.id,
                                      'dayNumber': currentDayData.dayNumber,
                                    });
                                  },
                                  child: const Text('Practice', style: TextStyle(fontSize: 12)),
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
          );
        },
      ),
    );
  }

  Widget _buildWorkedExamplesCard(BuildContext context, CurriculumDay currentDayData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              const Icon(Icons.lightbulb_outline, color: ChessTheme.accentGold, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Worked Master Models',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.txt),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (currentDayData.workedExamples.isEmpty)
            Text('Standard illustrative positions presented in practice lab.',
                style: TextStyle(fontSize: 12, color: context.txtMut))
          else
            ...currentDayData.workedExamples.map((ex) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text('• $ex', style: TextStyle(fontSize: 12, color: context.txtSec, height: 1.4)),
                )),
        ],
      ),
    );
  }

  Widget _buildGameStudyCard(BuildContext context, CurriculumDay currentDayData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              const Icon(Icons.history_edu, color: Colors.blueAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Historic Model Game Study',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.txt),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            currentDayData.gameStudy,
            style: TextStyle(fontSize: 12, color: context.txtSec, height: 1.4),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.auto_stories, size: 14),
            label: const Text('Open Model Game', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              foregroundColor: ChessTheme.primaryLight,
              side: BorderSide(color: context.brd),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            onPressed: () {
              widget.onNavigate('model_games');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(BuildContext context, CurriculumDay currentDayData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              const Icon(Icons.fitness_center, color: Colors.greenAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Practice Task',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.txt),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currentDayData.practiceTask,
            style: TextStyle(fontSize: 12, color: context.txtSec, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildRemediationCard(BuildContext context, CurriculumDay currentDayData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
              const Icon(Icons.loop, color: Colors.orangeAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Remediation & Review',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.txt),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            currentDayData.remediation,
            style: TextStyle(fontSize: 12, color: context.txtSec, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildTheoryMarkdownView(BuildContext context, String markdown) {
    final lines = markdown.split('\n');
    final widgets = <Widget>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 6));
        continue;
      }

      if (line.startsWith('# ')) {
        final text = line.substring(2).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 10),
            child: Row(
              children: [
                const Icon(Icons.school, color: ChessTheme.primaryLight, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.txt,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith('## ')) {
        final text = line.substring(3).trim();
        widgets.add(
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: context.surfLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.brd),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: ChessTheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: ChessTheme.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else if (line.startsWith('- ') || line.startsWith('* ')) {
        final rawText = line.substring(2).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 3, bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(Icons.arrow_right, size: 16, color: ChessTheme.primaryLight),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: _buildRichFormattedText(context, rawText),
                ),
              ],
            ),
          ),
        );
      } else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        final match = RegExp(r'^(\d+)\.\s*(.*)').firstMatch(line);
        final stepNum = match?.group(1) ?? '1';
        final rawText = match?.group(2) ?? line;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 3, bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ChessTheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    stepNum,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ChessTheme.primaryLight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildRichFormattedText(context, rawText),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: _buildRichFormattedText(context, line),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildRichFormattedText(BuildContext context, String text) {
    final spans = <TextSpan>[];
    final parts = text.split('**');

    for (int i = 0; i < parts.length; i++) {
      final isBold = i % 2 == 1;
      if (parts[i].isEmpty) continue;
      spans.add(
        TextSpan(
          text: parts[i],
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? context.txt : context.txtSec,
          ),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}
