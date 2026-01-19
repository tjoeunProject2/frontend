class SettingsModel {
  // 알림 설정
  bool pushNotificationEnabled;
  bool flowerRecommendationEnabled;
  bool shopNewsEnabled;

  // 앱 정보
  String appVersion;

  SettingsModel({
    this.pushNotificationEnabled = true,
    this.flowerRecommendationEnabled = true,
    this.shopNewsEnabled = false,
    this.appVersion = '1.0.0',
  });

  SettingsModel copyWith({
    bool? pushNotificationEnabled,
    bool? flowerRecommendationEnabled,
    bool? shopNewsEnabled,
    String? appVersion,
  }) {
    return SettingsModel(
      pushNotificationEnabled: pushNotificationEnabled ?? this.pushNotificationEnabled,
      flowerRecommendationEnabled: flowerRecommendationEnabled ?? this.flowerRecommendationEnabled,
      shopNewsEnabled: shopNewsEnabled ?? this.shopNewsEnabled,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}
