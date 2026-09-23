/// User profile and curriculum progress record.
class UserProfile {
  final String id;
  String username;
  int currentDay; // 1 to 90
  int dailyTimeBudgetMinutes;
  List<int> passedExams; // list of passed exam days (e.g. [7, 14, 21])
  bool isCertified;
  bool isDarkMode;
  String boardThemeName;
  String pieceThemeName;
  String boardSizeMode; // 'auto', 'small', 'medium', 'large', 'extraLarge'
  double boardScaleMultiplier; // 0.70 to 1.50 multiplier
  bool sidePanelCollapsed;
  bool showCoordinates;
  bool showMoveHighlights;
  bool showLegalMoveHints;
  bool showMovementArrows;
  String animationSpeed; // 'off', 'fast', 'normal', 'learning'
  bool soundEnabled;
  bool hasCompletedDiagnostic;
  List<int> completedDays;
  DateTime createdDate;
  DateTime lastActiveDate;

  UserProfile({
    required this.id,
    required this.username,
    this.currentDay = 1,
    this.dailyTimeBudgetMinutes = 480, // Default intensive 8h
    this.passedExams = const [],
    this.isCertified = false,
    this.isDarkMode = true,
    this.boardThemeName = 'tournamentGreen',
    this.pieceThemeName = 'standard',
    this.boardSizeMode = 'auto',
    this.boardScaleMultiplier = 1.0,
    this.sidePanelCollapsed = false,
    this.showCoordinates = true,
    this.showMoveHighlights = true,
    this.showLegalMoveHints = true,
    this.showMovementArrows = true,
    this.animationSpeed = 'normal',
    this.soundEnabled = true,
    this.hasCompletedDiagnostic = false,
    List<int>? completedDays,
    DateTime? createdDate,
    DateTime? lastActiveDate,
  })  : completedDays = completedDays ?? [],
        createdDate = createdDate ?? DateTime.now(),
        lastActiveDate = lastActiveDate ?? DateTime.now();

  static UserProfile createDefault() => UserProfile(
        id: 'user_master',
        username: 'Candidate Master',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'currentDay': currentDay,
        'dailyTimeBudgetMinutes': dailyTimeBudgetMinutes,
        'passedExams': passedExams,
        'isCertified': isCertified,
        'isDarkMode': isDarkMode,
        'boardThemeName': boardThemeName,
        'pieceThemeName': pieceThemeName,
        'boardSizeMode': boardSizeMode,
        'boardScaleMultiplier': boardScaleMultiplier,
        'sidePanelCollapsed': sidePanelCollapsed,
        'showCoordinates': showCoordinates,
        'showMoveHighlights': showMoveHighlights,
        'showLegalMoveHints': showLegalMoveHints,
        'showMovementArrows': showMovementArrows,
        'animationSpeed': animationSpeed,
        'soundEnabled': soundEnabled,
        'hasCompletedDiagnostic': hasCompletedDiagnostic,
        'completedDays': completedDays,
        'createdDate': createdDate.toIso8601String(),
        'lastActiveDate': lastActiveDate.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'user_default',
      username: json['username'] as String? ?? 'Candidate Master',
      currentDay: json['currentDay'] as int? ?? 1,
      dailyTimeBudgetMinutes: json['dailyTimeBudgetMinutes'] as int? ?? 480,
      passedExams: (json['passedExams'] as List<dynamic>?)?.cast<int>() ?? [],
      isCertified: json['isCertified'] as bool? ?? false,
      isDarkMode: json['isDarkMode'] as bool? ?? true,
      boardThemeName: json['boardThemeName'] as String? ?? 'tournamentGreen',
      pieceThemeName: json['pieceThemeName'] as String? ?? 'standard',
      boardSizeMode: json['boardSizeMode'] as String? ?? 'auto',
      boardScaleMultiplier: (json['boardScaleMultiplier'] as num?)?.toDouble() ?? 1.0,
      sidePanelCollapsed: json['sidePanelCollapsed'] as bool? ?? false,
      showCoordinates: json['showCoordinates'] as bool? ?? true,
      showMoveHighlights: json['showMoveHighlights'] as bool? ?? true,
      showLegalMoveHints: json['showLegalMoveHints'] as bool? ?? true,
      showMovementArrows: json['showMovementArrows'] as bool? ?? true,
      animationSpeed: json['animationSpeed'] as String? ?? 'normal',
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      hasCompletedDiagnostic: json['hasCompletedDiagnostic'] as bool? ?? false,
      completedDays: (json['completedDays'] as List<dynamic>?)?.cast<int>() ?? [],
      createdDate: DateTime.tryParse(json['createdDate'] as String? ?? '') ?? DateTime.now(),
      lastActiveDate: DateTime.tryParse(json['lastActiveDate'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
