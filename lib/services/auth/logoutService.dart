import 'dart:convert';
import 'package:http/http.dart' as http;

class LogoutService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<LogoutResponse> logout(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return LogoutResponse(success: true);
      } else {
        final error = jsonDecode(response.body);
        return LogoutResponse(
          success: false,
          message: error['message'] ?? '로그아웃에 실패했습니다.',
        );
      }
    } catch (e) {
      return LogoutResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class LogoutResponse {
  final bool success;
  final String? message;

  LogoutResponse({
    required this.success,
    this.message,
  });
}
