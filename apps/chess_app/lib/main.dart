import 'package:chess_engine/chess_engine.dart';
import 'package:chess_storage/chess_storage.dart';
import 'package:flutter/material.dart';
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
                                icon: Icon(Icons.explore),
                                label: Text('Openings'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.shield_outlined),
                                label: Text('Endgame'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.auto_stories),
                                label: Text('Model Games'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(Icons.troubleshoot),
                                label: Text('Weakness'),
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
                _navigateTo(_mobileScreenKeyForNavIndex(idx));
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
      case 'labs':
        return 2;
      case 'play':
        return 3;
      case 'analysis':
        return 4;
      case 'openings':
        return 5;
      case 'endgame':
        return 6;
      case 'models':
        return 7;
      case 'weakness':
        return 8;
      case 'video':
        return 9;
      case 'cert':
        return 10;
      case 'settings':
        return 11;
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
        return 'labs';
      case 3:
        return 'play';
      case 4:
        return 'analysis';
      case 5:
        return 'openings';
      case 6:
        return 'endgame';
      case 7:
        return 'models';
      case 8:
        return 'weakness';
      case 9:
        return 'video';
      case 10:
        return 'cert';
      case 11:
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

  Widget _buildCurrentScreen() {
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
      case 'labs':
        return LabsScreen(
          repository: _repository,
          initialArgs: _navigationArgs,
        );
      case 'play':
        return PlayScreen(
          repository: _repository,
          onNavigate: _navigateTo,
          initialArgs: _navigationArgs,
          engine: widget.engine,
        );
      case 'analysis':
        return AnalysisScreen(
          repository: _repository,
          initialArgs: _navigationArgs,
          engine: widget.engine,
        );
      case 'openings':
        return OpeningExplorerScreen(
          onNavigate: _navigateTo,
        );
      case 'endgame':
        return const EndgameWorkspaceScreen();
      case 'models':
        return ModelGamesScreen(
          onNavigate: _navigateTo,
        );
      case 'weakness':
        return WeaknessAnalyticsScreen(
          repository: _repository,
          onNavigate: _navigateTo,
        );
      case 'video':
        return VideoStudioScreen(
          initialArgs: _navigationArgs,
        );
      case 'cert':
        return CertificationScreen(
          repository: _repository,
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
