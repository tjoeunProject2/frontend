import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth/signupService.dart';
import '../services/auth/checkEmailService.dart';
import '../services/auth/checkNicknameService.dart';

// RegisterViewModel을 위한 Provider
final registerViewModelProvider = ChangeNotifierProvider<RegisterViewModel>((ref) {
  return RegisterViewModel();
});

class RegisterViewModel extends ChangeNotifier {
  final _signupService = SignupService();
  final _checkEmailService = CheckEmailService();
  final _checkNicknameService = CheckNicknameService();

  // 컨트롤러 관리
  final nameController = TextEditingController();
  final nicknameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 상태 변수
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;
  bool isLoading = false;
  bool isEmailChecked = false;
  bool isNicknameChecked = false;

  String? dobError;
  String? passwordError;
  String? confirmPasswordError;
  String? emailError;
  String? nicknameError;
  String? errorMessage;

  bool get isFormValid {
    return nameController.text.isNotEmpty &&
        nicknameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        isEmailChecked &&
        isNicknameChecked &&
        dobController.text.length == 8 &&
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

  void togglePasswordObscure() {
    isPasswordObscure = !isPasswordObscure;
    notifyListeners();
  }

  void toggleConfirmPasswordObscure() {
    isConfirmPasswordObscure = !isConfirmPasswordObscure;
    notifyListeners();
  }

  void validatePassword(String value) {
    if (value.isNotEmpty && value.length < 8) {
      passwordError = "8자리 이상을 입력하세요";
    } else {
      passwordError = null;
    }
    validateConfirmPassword(confirmPasswordController.text);
    notifyListeners();
  }

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

  // 이메일 중복 확인
  Future<void> checkEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      emailError = "이메일을 입력해주세요";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    final response = await _checkEmailService.checkEmail(email);
    isLoading = false;

    if (response.success && response.exists != null) {
      if (response.exists!) {
        emailError = "이미 사용 중인 이메일입니다.";
        isEmailChecked = false;
      } else {
        emailError = null;
        isEmailChecked = true;
      }
    } else {
      emailError = response.message ?? "이메일 확인에 실패했습니다.";
      isEmailChecked = false;
    }
    notifyListeners();
  }

  // 닉네임 중복 확인
  Future<void> checkNickname() async {
    final nickname = nicknameController.text.trim();
    if (nickname.isEmpty) {
      nicknameError = "닉네임을 입력해주세요";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    final response = await _checkNicknameService.checkNickname(nickname);
    isLoading = false;

    if (response.success && response.exists != null) {
      if (response.exists!) {
        nicknameError = "이미 사용 중인 닉네임입니다.";
        isNicknameChecked = false;
      } else {
        nicknameError = null;
        isNicknameChecked = true;
      }
    } else {
      nicknameError = response.message ?? "닉네임 확인에 실패했습니다.";
      isNicknameChecked = false;
    }
    notifyListeners();
  }

  // 회원가입
  Future<SignupResponse> signup() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _signupService.signup(
      email: emailController.text.trim(),
      password: passwordController.text,
      nickname: nicknameController.text.trim(),
      userName: nameController.text.trim(),
      userBirth: dobController.text,
    );

    isLoading = false;
    if (!response.success) {
      errorMessage = response.message;
    }
    notifyListeners();

    return response;
  }

  @override
  void dispose() {
    nameController.dispose();
    nicknameController.dispose();
    emailController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}