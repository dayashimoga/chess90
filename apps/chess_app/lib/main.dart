import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
import 'src/screens/academy_screen.dart';
import 'src/screens/analysis_screen.dart';
import 'src/screens/certification_screen.dart';
import 'src/screens/curriculum_screen.dart';
import 'src/screens/daily_journey_screen.dart';
import 'src/screens/endgame_workspace_screen.dart';
import 'src/screens/labs_screen.dart';
import 'src/screens/model_games_screen.dart';
import 'src/screens/opening_explorer_screen.dart';
import 'src/screens/play_screen.dart';
import 'src/screens/settings_storage_screen.dart';
import 'src/screens/video_studio_screen.dart';
import 'src/screens/weakness_analytics_screen.dart';
import 'src/theme/chess_theme.dart';
import 'src/widgets/curriculum/chess_companion_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChessMasterApp());
}

class ChessMasterApp extends StatefulWidget {
  final StorageRepository? repository;
  final ChessEngine? engine;
  final ThemeMode initialThemeMode;

  const ChessMasterApp({
    super.key,
    this.repository,
    this.engine,
    this.initialThemeMode = ThemeMode.dark,
  });

  @override
  State<ChessMasterApp> createState() => _ChessMasterAppState();
}

class _ChessMasterAppState extends State<ChessMasterApp> {
  late ThemeMode _themeMode;
  late final StorageRepository _repo;

  @override
  void initState() {
    super.initState();
    _repo = widget.repository ?? StorageRepository();
    final profile = _repo.getProfile();
    _themeMode = profile.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void _toggleTheme() {
    setState(() {
      final newIsDark = _themeMode != ThemeMode.dark;
      _themeMode = newIsDark ? ThemeMode.dark : ThemeMode.light;
      final profile = _repo.getProfile();
      profile.isDarkMode = newIsDark;
      _repo.saveProfile(profile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChessMaster | 90-Day GM Chess Mastery Platform',
      debugShowCheckedModeBanner: false,
      theme: ChessTheme.lightTheme,
      darkTheme: ChessTheme.darkTheme,
      themeMode: _themeMode,
      home: MainShell(
        repository: widget.repository,
        engine: widget.engine,
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final StorageRepository? repository;
  final ChessEngine? engine;
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;

  const MainShell({
    super.key,
    this.repository,
    this.engine,
    this.onToggleTheme,
    this.isDarkMode = true,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final StorageRepository _repository;
  String _activeScreen = 'daily';
  dynamic _navigationArgs;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? StorageRepository();
  }

  void _navigateTo(String screenKey, {dynamic args}) {
    setState(() {
      _activeScreen = screenKey;
      _navigationArgs = args;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = _repository.getProfile();
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 720;

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield, color: ChessTheme.primaryLight, size: 24),
              const SizedBox(width: 8),
              const Text(
                'CHESSMASTER',
                style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, fontSize: 15),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: ChessTheme.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: ChessTheme.primaryLight),
                  ),
                  child: Text(
                    'DAY ${profile.currentDay} / 90',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: ChessTheme.primaryLight),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          // Chess Companion (16 Cheat Sheets & Algorithm)
          IconButton(
            icon: const Icon(Icons.auto_stories, size: 20),
            tooltip: 'Chess Companion (16 Cheat Sheets & Algorithm)',
            onPressed: () => ChessCompanionDialog.show(context),
          ),

          // Theme Toggle
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode, size: 20),
            tooltip: 'Toggle Theme (Light / Dark)',
            onPressed: widget.onToggleTheme,
          ),

          // Offline indicator
          if (!isMobile)
            Row(
              children: [
                Icon(Icons.wifi_off, size: 14, color: context.txtMut),
                const SizedBox(width: 4),
                Text(
                  'OFFLINE-FIRST CORE',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: context.txtMut),
                ),
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(Icons.wifi_off, size: 16, color: context.txtMut),
            ),
          const SizedBox(width: 8),

          // JSON Backup Export/Import
          IconButton(
            icon: const Icon(Icons.backup_outlined, size: 20),
            tooltip: 'Export / Backup Offline Platform JSON',
            onPressed: () {
              final jsonStr = _repository.exportFullBackupJson();
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: ctx.surf,
                  title: Text('Offline JSON Backup', style: TextStyle(color: ctx.txt)),
                  content: SizedBox(
                    width: 500,
                    height: 300,
                    child: SelectableText(jsonStr, style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isMobile
          ? _buildCurrentScreen()
          : Row(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: NavigationRail(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            selectedIndex: _navIndexForScreen(_activeScreen),
                            onDestinationSelected: (idx) {
                              _navigateTo(_screenKeyForNavIndex(idx));
                            },
                            labelType: NavigationRailLabelType.all,
                            selectedIconTheme: const IconThemeData(color: ChessTheme.primaryLight),
                            selectedLabelTextStyle: const TextStyle(color: ChessTheme.primaryLight, fontSize: 11, fontWeight: FontWeight.bold),
                            unselectedIconTheme: IconThemeData(color: context.txtMut),
                            unselectedLabelTextStyle: TextStyle(color: context.txtMut, fontSize: 11),
                            destinations: const [
                              NavigationRailDestination(
                                icon: Icon(Icons.today),
                                label: Text('Daily Journey'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.menu_book),
                                label: Text('Curriculum'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.school),
                                label: Text('Academy'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.science),
                                label: Text('Labs'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.sports_esports),
                                label: Text('Play / Tourney'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.analytics),
                                label: Text('Analysis'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.video_library),
                                label: Text('Video Studio'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.workspace_premium),
                                label: Text('Mastery Report'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.settings),
                                label: Text('Settings'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                VerticalDivider(thickness: 1, width: 1, color: context.brd),
                Expanded(child: _buildCurrentScreen()),
              ],
            ),
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _mobileNavIndexForScreen(_activeScreen),
              onDestinationSelected: (idx) {
                if (idx == 5) {
                  _openMobileMoreSheet(context);
                } else {
                  _navigateTo(_mobileScreenKeyForNavIndex(idx));
                }
              },
              destinations: const [
                NavigationDestination(icon: Icon(Icons.today), label: 'Daily'),
                NavigationDestination(icon: Icon(Icons.menu_book), label: 'Curriculum'),
                NavigationDestination(icon: Icon(Icons.science), label: 'Labs'),
                NavigationDestination(icon: Icon(Icons.sports_esports), label: 'Play'),
                NavigationDestination(icon: Icon(Icons.analytics), label: 'Analysis'),
                NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
              ],
            )
          : null,
    );
  }

  int _navIndexForScreen(String screen) {
    switch (screen) {
      case 'daily':
        return 0;
      case 'curriculum':
        return 1;
      case 'academy':
        return 2;
      case 'labs':
        return 3;
      case 'play':
        return 4;
      case 'analysis':
      case 'openings':
      case 'endgame':
      case 'models':
        return 5;
      case 'video':
        return 6;
      case 'cert':
      case 'weakness':
        return 7;
      case 'settings':
        return 8;
      default:
        return 0;
    }
  }

  String _screenKeyForNavIndex(int idx) {
    switch (idx) {
      case 0:
        return 'daily';
      case 1:
        return 'curriculum';
      case 2:
        return 'academy';
      case 3:
        return 'labs';
      case 4:
        return 'play';
      case 5:
        return 'analysis';
      case 6:
        return 'video';
      case 7:
        return 'cert';
      case 8:
        return 'settings';
      default:
        return 'daily';
    }
  }

  int _mobileNavIndexForScreen(String screen) {
    switch (screen) {
      case 'daily':
        return 0;
      case 'curriculum':
        return 1;
      case 'labs':
        return 2;
      case 'play':
        return 3;
      case 'analysis':
      case 'openings':
      case 'endgame':
      case 'models':
        return 4;
      default:
        return 5;
    }
  }

  String _mobileScreenKeyForNavIndex(int idx) {
    switch (idx) {
      case 0:
        return 'daily';
      case 1:
        return 'curriculum';
      case 2:
        return 'labs';
      case 3:
        return 'play';
      case 4:
        return 'analysis';
      case 5:
        return 'settings';
      default:
        return 'daily';
    }
  }

  void _openMobileMoreSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surf,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.apps, color: ChessTheme.primaryLight),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'All Learning & Analysis Hubs',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ctx.txt),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.video_library, color: ChessTheme.primaryLight),
                  title: const Text('Video Studio'),
                  subtitle: const Text('Export animated tactical reels & narrated videos'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateTo('video');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.workspace_premium, color: ChessTheme.primaryLight),
                  title: const Text('Mastery Report & Certification'),
                  subtitle: const Text('GM progress audit and performance credentials'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateTo('cert');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.troubleshoot, color: ChessTheme.primaryLight),
                  title: const Text('Weakness Radar'),
                  subtitle: const Text('Tactical, calculation, and psychological diagnosis'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateTo('weakness');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.explore, color: ChessTheme.primaryLight),
                  title: const Text('Opening Explorer'),
                  subtitle: const Text('72 ECO master variations and master win-rates'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateTo('openings');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.shield_outlined, color: ChessTheme.primaryLight),
                  title: const Text('Endgame Workspace'),
                  subtitle: const Text('Theoretical positions and engine win/draw drills'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateTo('endgame');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.auto_stories, color: ChessTheme.primaryLight),
                  title: const Text('Model Games'),
                  subtitle: const Text('60 annotated master games throughout history'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateTo('models');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: ChessTheme.primaryLight),
                  title: const Text('Settings & Storage'),
                  subtitle: const Text('Theme, pieces, board sizing, engine & backups'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _navigateTo('settings');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStudyHub() {
    Widget content;
    switch (_activeScreen) {
      case 'openings':
        content = OpeningExplorerScreen(onNavigate: _navigateTo);
        break;
      case 'endgame':
        content = const EndgameWorkspaceScreen();
        break;
      case 'models':
        content = ModelGamesScreen(onNavigate: _navigateTo);
        break;
      case 'analysis':
      default:
        content = AnalysisScreen(
          repository: _repository,
          initialArgs: _navigationArgs,
          engine: widget.engine,
          onNavigate: _navigateTo,
        );
        break;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSubTabButton(
                  icon: Icons.analytics,
                  label: 'Analysis',
                  isSelected: _activeScreen == 'analysis',
                  onTap: () => _navigateTo('analysis'),
                ),
                const SizedBox(width: 8),
                _buildSubTabButton(
                  icon: Icons.explore,
                  label: 'Openings',
                  isSelected: _activeScreen == 'openings',
                  onTap: () => _navigateTo('openings'),
                ),
                const SizedBox(width: 8),
                _buildSubTabButton(
                  icon: Icons.shield_outlined,
                  label: 'Endgame',
                  isSelected: _activeScreen == 'endgame',
                  onTap: () => _navigateTo('endgame'),
                ),
                const SizedBox(width: 8),
                _buildSubTabButton(
                  icon: Icons.auto_stories,
                  label: 'Model Games',
                  isSelected: _activeScreen == 'models',
                  onTap: () => _navigateTo('models'),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildAnalyticsHub() {
    Widget content;
    switch (_activeScreen) {
      case 'weakness':
        content = WeaknessAnalyticsScreen(
          repository: _repository,
          onNavigate: _navigateTo,
        );
        break;
      case 'cert':
      default:
        content = CertificationScreen(repository: _repository);
        break;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSubTabButton(
                  icon: Icons.workspace_premium,
                  label: 'Mastery Report',
                  isSelected: _activeScreen == 'cert',
                  onTap: () => _navigateTo('cert'),
                ),
                const SizedBox(width: 8),
                _buildSubTabButton(
                  icon: Icons.troubleshoot,
                  label: 'Weakness Radar',
                  isSelected: _activeScreen == 'weakness',
                  onTap: () => _navigateTo('weakness'),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1),
        Expanded(child: content),
      ],
    );
  }

  Widget _buildSubTabButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? ChessTheme.primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? ChessTheme.primaryLight : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? ChessTheme.primaryLight : context.txtSec),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? ChessTheme.primaryLight : context.txtSec,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    // Check if in Study hub (analysis, openings, endgame, models)
    if (['analysis', 'openings', 'endgame', 'models'].contains(_activeScreen)) {
      return _buildStudyHub();
    }

    // Check if in Analytics hub (cert, weakness)
    if (['cert', 'weakness'].contains(_activeScreen)) {
      return _buildAnalyticsHub();
    }

    switch (_activeScreen) {
      case 'daily':
        return DailyJourneyScreen(
          repository: _repository,
          onNavigate: _navigateTo,
        );
      case 'curriculum':
        return CurriculumScreen(
          repository: _repository,
          onNavigate: _navigateTo,
        );
      case 'academy':
        return AcademyScreen(
          repository: _repository,
          onNavigate: _navigateTo,
        );
      case 'labs':
        return LabsScreen(
          repository: _repository,
          initialArgs: _navigationArgs,
          onNavigate: _navigateTo,
        );
      case 'play':
        return PlayScreen(
          repository: _repository,
          onNavigate: _navigateTo,
          initialArgs: _navigationArgs,
          engine: widget.engine,
        );
      case 'video':
        return VideoStudioScreen(
          repository: _repository,
          initialArgs: _navigationArgs,
        );
      case 'settings':
        return SettingsStorageScreen(
          repository: _repository,
          onToggleTheme: widget.onToggleTheme,
        );
      default:
        return DailyJourneyScreen(
          repository: _repository,
          onNavigate: _navigateTo,
        );
    }
  }
}
