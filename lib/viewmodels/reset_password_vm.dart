import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final resetPasswordViewModelProvider = ChangeNotifierProvider((ref) => ResetPasswordViewModel());

class ResetPasswordViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // 이메일 정규 표현식
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]{3,}$',
  );

  bool isLoading = false;
  String? errorMessage;
  String message = '';

  // 실시간 이메일 유효성 검사 결과
  bool get isEmailValid => _emailRegExp.hasMatch(emailController.text);

  // 이메일이 비어있지 않은데 유효하지 않은 경우 (경고문 출력 조건)
  bool get showEmailError => emailController.text.isNotEmpty && !isEmailValid;

  // 폼 유효성 검사 (이름이 있고 이메일 형식이 맞아야 버튼 활성화)
  bool get isFormValid => nameController.text.isNotEmpty && isEmailValid;

  void updateUI() => notifyListeners();

  Future<bool> resetPassword() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // TODO: 실제 API 호출 로직 (auth/reset-password)
      // final response = await _authService.resetPassword(
      //   userName: nameController.text,
      //   email: emailController.text,
      // );

      await Future.delayed(const Duration(seconds: 1)); // 통신 시뮬레이션
      message = '임시 비밀번호가 이메일로 발송되었습니다.';
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = '발송에 실패했습니다. 다시 시도해 주세요.';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }
}