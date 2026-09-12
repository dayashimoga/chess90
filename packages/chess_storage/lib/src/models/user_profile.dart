/// User profile and curriculum progress record.
class UserProfile {
  final String id;
  String username;
  int currentDay; // 1 to 90
  int dailyTimeBudgetMinutes;
  List<int> passedExams; // list of passed exam days (e.g. [7, 14, 21])
  bool isCertified;
  bool isDarkMode;
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
    DateTime? createdDate,
    DateTime? lastActiveDate,
  })  : createdDate = createdDate ?? DateTime.now(),
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
      createdDate: DateTime.tryParse(json['createdDate'] as String? ?? '') ?? DateTime.now(),
      lastActiveDate: DateTime.tryParse(json['lastActiveDate'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
