import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth/logoutService.dart';

final myPageViewModelProvider = ChangeNotifierProvider<MyPageViewModel>((ref) {
  return MyPageViewModel();
});

class MyPageViewModel extends ChangeNotifier {
  final _logoutService = LogoutService();
  
  // 사용자 정보 (실제 데이터는 API 등을 통해 가져오게 됩니다)
  String userName = "송예림";
  String userBio = "꽃과 향기를 사랑하는 수집가";
  String profileImageUrl = "assets/images/profile.png"; // 실제 이미지 경로로 수정 필요

  // 로그아웃 로직
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

  // 메뉴 클릭 시 이동 로직들
  void navigateToLikedFlowers() => print("좋아요 표시한 꽃으로 이동");
  void navigateToStoreList() => print("가고 싶은 꽃집으로 이동");
  void navigateToCustomerService() => print("고객 센터로 이동");
}