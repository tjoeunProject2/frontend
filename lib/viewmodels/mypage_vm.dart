import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final myPageViewModelProvider = ChangeNotifierProvider<MyPageViewModel>((ref) {
  return MyPageViewModel();
});

class MyPageViewModel extends ChangeNotifier {
  // 사용자 정보 (실제 데이터는 API 등을 통해 가져오게 됩니다)
  String userName = "송예림";
  String userBio = "꽃과 향기를 사랑하는 수집가";
  String profileImageUrl = "assets/images/profile.png"; // 실제 이미지 경로로 수정 필요

  // 로그아웃 로직
  void logout() {
    // 로그아웃 처리 로직 작성
    print("로그아웃 되었습니다.");
  }

  // 메뉴 클릭 시 이동 로직들
  void navigateToLikedFlowers() => print("좋아요 표시한 꽃으로 이동");
  void navigateToStoreList() => print("가고 싶은 꽃집으로 이동");
  void navigateToNotificationSettings() => print("알림 설정으로 이동");
  void navigateToCustomerService() => print("고객 센터로 이동");
}