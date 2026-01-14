import 'dart:convert';
import 'package:http/http.dart' as http;

class RefreshService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return RefreshTokenResponse(
          success: true,
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String,
        );
      } else {
        final error = jsonDecode(response.body);
        return RefreshTokenResponse(
          success: false,
          message: error['message'] ?? '토큰 재발급에 실패했습니다.',
        );
      }
    } catch (e) {
      return RefreshTokenResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class RefreshTokenResponse {
  final bool success;
  final String? accessToken;
  final String? refreshToken;
  final String? message;

  RefreshTokenResponse({
    required this.success,
    this.accessToken,
    this.refreshToken,
    this.message,
  });
}
