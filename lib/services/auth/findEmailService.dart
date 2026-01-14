import 'dart:convert';
import 'package:http/http.dart' as http;

class FindEmailService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<FindEmailResponse> findEmail({
    required String userName,
    required String userBirth,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/find-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': userName,
          'userBirth': userBirth,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return FindEmailResponse(
          success: true,
          email: data['email'] as String,
        );
      } else {
        final error = jsonDecode(response.body);
        return FindEmailResponse(
          success: false,
          message: error['message'] ?? '이메일 찾기에 실패했습니다.',
        );
      }
    } catch (e) {
      return FindEmailResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class FindEmailResponse {
  final bool success;
  final String? email;
  final String? message;

  FindEmailResponse({
    required this.success,
    this.email,
    this.message,
  });
}
