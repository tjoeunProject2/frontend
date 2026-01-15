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
  String get languageCode => _settings.languageCode;
  String get theme => _settings.theme;
  bool get autoDownloadEnabled => _settings.autoDownloadEnabled;
  String get appVersion => _settings.appVersion;
  String get language => _settings.language;

  // 알림 토글
  void togglePushNotification(bool value) {
    _settings = _settings.copyWith(pushNotificationEnabled: value);
    notifyListeners();
    // TODO: API 호출하여 서버에 저장
    print('푸시 알림: $value');
  }

  void toggleFlowerRecommendation(bool value) {
    _settings = _settings.copyWith(flowerRecommendationEnabled: value);
    notifyListeners();
    print('꽃 추천 알림: $value');
  }

  void toggleShopNews(bool value) {
    _settings = _settings.copyWith(shopNewsEnabled: value);
    notifyListeners();
    print('꽃집 소식: $value');
  }

  void toggleAutoDownload(bool value) {
    _settings = _settings.copyWith(autoDownloadEnabled: value);
    notifyListeners();
    print('자동 다운로드: $value');
  }

  // 언어 설정
  void setLanguage(String code) {
    _settings = _settings.copyWith(languageCode: code);
    notifyListeners();
    // TODO: 앱 언어 변경 적용
    print('언어 변경: $code');
  }

  // 테마 설정
  void setTheme(String themeMode) {
    _settings = _settings.copyWith(theme: themeMode);
    notifyListeners();
    // TODO: 테마 변경 적용
    print('테마 변경: $themeMode');
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

  void clearCache() {
    print('캐시 삭제');
    // TODO: 실제 캐시 삭제 로직
  }

  // 앱 정보
  void checkForUpdates() {
    print('업데이트 확인');
    // TODO: 앱 업데이트 확인 로직
  }

  void reportBug(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportBugView()),
    );
  }

  void rateApp() {
    print('앱 평가하기');
    // TODO: 앱스토어/플레이스토어 평가 페이지 열기
  }

  // 계정
  Future<bool> logout() async {
    try {
      final response = await _logoutService.logout();
      if (response.success) {
        print('로그아웃 성공');
        return true;
      } else {
        print('로그아웃 실패: ${response.message}');
        return false;
      }
    } catch (e) {
      print('로그아웃 에러: $e');
      return false;
    }
  }

  void deleteAccount() {
    print('회원 탈퇴');
    // TODO: 계정 삭제 API 호출
  }
}
