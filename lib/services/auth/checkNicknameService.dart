import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckNicknameService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<CheckExistsResponse> checkNickname(String nickname) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/check-nickname'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nickname': nickname}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CheckExistsResponse(
          success: true,
          exists: data['exists'] as bool,
          message: data['message'] as String,
        );
      } else {
        final error = jsonDecode(response.body);
        return CheckExistsResponse(
          success: false,
          message: error['message'] ?? '닉네임 확인에 실패했습니다.',
        );
      }
    } catch (e) {
      return CheckExistsResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class CheckExistsResponse {
  final bool success;
  final bool? exists;
  final String? message;

  CheckExistsResponse({
    required this.success,
    this.exists,
    this.message,
  });
}
