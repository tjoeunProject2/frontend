import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final profileViewModelProvider =
    ChangeNotifierProvider<ProfileViewModel>((ref) {
  return ProfileViewModel();
});

class ProfileViewModel extends ChangeNotifier {
  // 사용자 모델
  User _user = User(
    email: "example@email.com",
    nickname: "송예림",
    userName: "송예림",
    userBirth: "2000-01-15",
  );

  // Getters
  User get user => _user;
  String get userName => _user.userName;
  String get nickname => _user.nickname;
  String get userEmail => _user.email;
  String get userBirth => _user.userBirth;
  
  String userBio = "꽃과 향기를 사랑하는 수집가";
  String joinDate = "2024.01.15";
  String? profileImageUrl;

  // 프로필 업데이트
  void updateProfile({required String name, required String bio}) {
    _user = _user.copyWith(
      userName: name,
      nickname: name,
    );
    userBio = bio;
    notifyListeners();
    // TODO: API 호출하여 서버에 저장
    print("프로필 업데이트: $name, $bio");
    print("업데이트된 User 모델: $_user");
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
