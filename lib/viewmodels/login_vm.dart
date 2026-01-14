import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// LoginViewModel을 관리할 Provider 선언
final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel();
});

class LoginViewModel extends ChangeNotifier {
  // 컨트롤러 관리
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 상태 변수 (비밀번호 가림 여부)
  bool isObscure = true;

  // 비밀번호 가림 토글 로직
  void toggleObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  // 유효성 검사 (로그인 버튼 활성화용)
  bool get isFormValid {
    return emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
  }

  void updateUI() {
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}