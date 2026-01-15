class SettingsModel {
  // 알림 설정
  bool pushNotificationEnabled;
  bool flowerRecommendationEnabled;
  bool shopNewsEnabled;

  // 앱 설정
  String languageCode;
  String theme;
  bool autoDownloadEnabled;

  // 앱 정보
  String appVersion;

  SettingsModel({
    this.pushNotificationEnabled = true,
    this.flowerRecommendationEnabled = true,
    this.shopNewsEnabled = false,
    this.languageCode = 'ko',
    this.theme = '라이트',
    this.autoDownloadEnabled = true,
    this.appVersion = '1.0.0',
  });

  // 언어 표시용
  String get language {
    switch (languageCode) {
      case 'ko':
        return '한국어';
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      default:
        return '한국어';
    }
  }

  SettingsModel copyWith({
    bool? pushNotificationEnabled,
    bool? flowerRecommendationEnabled,
    bool? shopNewsEnabled,
    String? languageCode,
    String? theme,
    bool? autoDownloadEnabled,
    String? appVersion,
  }) {
    return SettingsModel(
      pushNotificationEnabled: pushNotificationEnabled ?? this.pushNotificationEnabled,
      flowerRecommendationEnabled: flowerRecommendationEnabled ?? this.flowerRecommendationEnabled,
      shopNewsEnabled: shopNewsEnabled ?? this.shopNewsEnabled,
      languageCode: languageCode ?? this.languageCode,
      theme: theme ?? this.theme,
      autoDownloadEnabled: autoDownloadEnabled ?? this.autoDownloadEnabled,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}
