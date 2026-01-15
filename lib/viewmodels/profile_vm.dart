import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileViewModelProvider =
    ChangeNotifierProvider<ProfileViewModel>((ref) {
  return ProfileViewModel();
});

class ProfileViewModel extends ChangeNotifier {
  // 사용자 정보
  String userName = "송예림";
  String userBio = "꽃과 향기를 사랑하는 수집가";
  String userEmail = "example@email.com";
  String joinDate = "2024.01.15";
  String? profileImageUrl;

  // 프로필 업데이트
  void updateProfile({required String name, required String bio}) {
    userName = name;
    userBio = bio;
    notifyListeners();
    // TODO: API 호출하여 서버에 저장
    print("프로필 업데이트: $name, $bio");
  }

  // 프로필 이미지 업데이트
  void updateProfileImage(String imagePath) {
    profileImageUrl = imagePath;
    notifyListeners();
    // TODO: API 호출하여 서버에 저장
    print("프로필 이미지 업데이트: $imagePath");
  }

  // 비밀번호 변경
  void changePassword(String currentPassword, String newPassword) {
    // TODO: API 호출하여 비밀번호 변경
    print("비밀번호 변경 요청");
  }
}
