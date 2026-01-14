import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// RegisterViewModel을 위한 Provider
final registerViewModelProvider = ChangeNotifierProvider<RegisterViewModel>((ref) {
  return RegisterViewModel();
});

class RegisterViewModel extends ChangeNotifier {
  // 컨트롤러 관리 (이름, 이메일, 생년월일, 비밀번호, 비밀번호 확인)
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController(); // 생년월일
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 상태 변수
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  String? dobError;
  String? passwordError;
  String? confirmPasswordError;

  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        dobController.text.length == 8 && // 생년월일 8자리 필수
        dobError == null &&
        passwordController.text.isNotEmpty &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  void validateDob(String value) {
    if (value.isNotEmpty && value.length != 8) {
      dobError = "생년월일 8자리를 입력해 주세요 (예: 20000101)";
    } else {
      dobError = null;
    }
    notifyListeners();
  }

  void updateUI() => notifyListeners();

  // 비밀번호 가림 토글 로직
  void togglePasswordObscure() {
    isPasswordObscure = !isPasswordObscure;
    notifyListeners();
  }

  void toggleConfirmPasswordObscure() {
    isConfirmPasswordObscure = !isConfirmPasswordObscure;
    notifyListeners();
  }

  // 비밀번호 유효성 검사 (8자 이상)
  void validatePassword(String value) {
    if (value.isNotEmpty && value.length < 8) {
      passwordError = "8자리 이상을 입력하세요";
    } else {
      passwordError = null;
    }
    // 비밀번호가 수정되면 일치 여부도 다시 확인
    validateConfirmPassword(confirmPasswordController.text);
    notifyListeners();
  }

  // 비밀번호 일치 확인 로직
  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError = null;
    } else if (passwordController.text != value) {
      confirmPasswordError = "비밀번호가 같지 않습니다";
    } else {
      confirmPasswordError = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}