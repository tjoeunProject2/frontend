import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth/loginService.dart';
import '../services/storage/token_storage.dart';

// LoginViewModel을 관리할 Provider 선언
final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel();
});

class LoginViewModel extends ChangeNotifier {
  final _loginService = LoginService();
  final _tokenStorage = TokenStorage();

  // 컨트롤러 관리
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 상태 변수
  bool isObscure = true;
  bool isLoading = false;
  String? errorMessage;

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

  // 로그인 (서비스 직접 호출)
  Future<LoginResponse> login() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final response = await _loginService.login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    isLoading = false;
    
    if (response.success && response.accessToken != null && response.refreshToken != null) {
      // 토큰 저장
      await _tokenStorage.saveTokens(
        accessToken: response.accessToken!,
        refreshToken: response.refreshToken!,
      );
    } else {
      errorMessage = response.message;
    }
    
    notifyListeners();
    return response;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}