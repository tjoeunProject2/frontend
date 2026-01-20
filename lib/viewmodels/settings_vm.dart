import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth/logoutService.dart';
import '../views/mypageView/termsOfServiceView.dart';
import '../views/mypageView/privacyPolicyView.dart';
import '../views/mypageView/reportBugView.dart';
import '../models/settingsModel.dart';

final settingsViewModelProvider =
    ChangeNotifierProvider<SettingsViewModel>((ref) {
  return SettingsViewModel();
});

class SettingsViewModel extends ChangeNotifier {
  final _logoutService = LogoutService();
  SettingsModel _settings = SettingsModel();

  // Getters
  bool get pushNotificationEnabled => _settings.pushNotificationEnabled;
  bool get flowerRecommendationEnabled => _settings.flowerRecommendationEnabled;
  bool get shopNewsEnabled => _settings.shopNewsEnabled;
  String get appVersion => _settings.appVersion;

  // 알림 토글
  void togglePushNotification(bool value) {
    _settings = _settings.copyWith(pushNotificationEnabled: value);
    notifyListeners();
    // TODO: API 호출하여 서버에 저장
    if (kDebugMode) debugPrint('푸시 알림: $value');
  }

  void setFlowerRecommendation(bool value) {
    _settings = _settings.copyWith(flowerRecommendationEnabled: value);
    notifyListeners();
    if (kDebugMode) debugPrint('꽃 추천 알림: $value');
  }

  void setShopNews(bool value) {
    _settings = _settings.copyWith(shopNewsEnabled: value);
    notifyListeners();
    if (kDebugMode) debugPrint('꽃집 소식: $value');
  }

  // 개인정보
  void openPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyView()),
    );
  }

  void openTermsOfService(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsOfServiceView()),
    );
  }

  // 앱 정보
  void checkForUpdates() {
    if (kDebugMode) debugPrint('업데이트 확인');
    // TODO: 앱 업데이트 확인 로직
  }

  void reportBug(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportBugView()),
    );
  }

  void rateApp() {
    if (kDebugMode) debugPrint('앱 평가하기');
    // TODO: 앱스토어/플레이스토어 평가 페이지 열기
  }

  // 계정
  Future<bool> logout() async {
    try {
      final response = await _logoutService.logout();
      if (response.success) {
        if (kDebugMode) debugPrint('로그아웃 성공');
        return true;
      } else {
        if (kDebugMode) debugPrint('로그아웃 실패: ${response.message}');
        return false;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('로그아웃 에러: $e');
      return false;
    }
  }

  void deleteAccount() {
    if (kDebugMode) debugPrint('회원 탈퇴');
    // TODO: 계정 삭제 API 호출
  }
}
