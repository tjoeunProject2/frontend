import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckEmailService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<CheckExistsResponse> checkEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/check-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
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
          message: error['message'] ?? '이메일 확인에 실패했습니다.',
        );
      }
    } catch (e) {
      // 보안: 에러 상세 정보는 로그에만 출력
      print('Check email error: $e');
      return CheckExistsResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
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
