//////////////////////////////////////////////////////////
//                 SETTINGS MODEL
//////////////////////////////////////////////////////////
library;

class SettingsModel {
  final String language;
  final bool notifications;
  final String theme;

  SettingsModel({
    required this.language,
    required this.notifications,
    required this.theme,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
      language: map["language"] ?? "en",
      notifications: map["notifications"] ?? true,
      theme: map["theme"] ?? "light",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "language": language,
      "notifications": notifications,
      "theme": theme,
    };
  }
}
