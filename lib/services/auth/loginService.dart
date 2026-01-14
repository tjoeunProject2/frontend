import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return LoginResponse(
          success: true,
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
      } else {
        final error = jsonDecode(response.body);
        return LoginResponse(
          success: false,
          message: error['message'] ?? '로그인에 실패했습니다.',
        );
      }
    } catch (e) {
      return LoginResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class LoginResponse {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final String? message;

  LoginResponse({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.message,
  });
}
