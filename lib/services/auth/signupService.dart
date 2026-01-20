import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/user.dart';

class SignupService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<SignupResponse> signup({
    required String email,
    required String password,
    required String nickname,
    required String userName,
    required String userBirth,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'nickname': nickname,
          'userName': userName,
          'userBirth': userBirth,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return SignupResponse(
          success: true,
          user: User.fromJson(data),
        );
      } else {
        final error = jsonDecode(response.body);
        return SignupResponse(
          success: false,
          message: error['message'] ?? '회원가입에 실패했습니다.',
        );
      }
    } catch (e) {
      // 보안: 에러 상세 정보는 로그에만 출력
      print('Signup error: $e');
      return SignupResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class SignupResponse {
  final bool success;
  final User? user;
  final String? message;

  SignupResponse({
    required this.success,
    this.user,
    this.message,
  });
}
