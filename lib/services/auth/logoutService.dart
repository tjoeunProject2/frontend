import 'dart:convert';
import 'package:http/http.dart' as http;
import 'authInterceptor.dart';
import '../storage/token_storage.dart';

class LogoutService {
  static const String baseUrl = 'http://localhost:8080/api';
  final _interceptor = AuthInterceptor();
  final _tokenStorage = TokenStorage();

  Future<LogoutResponse> logout() async {
    try {
      final response = await _interceptor.authenticatedRequest(
        request: (headers) => http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        // 로그아웃 성공 시 로컬 토큰 삭제
        await _tokenStorage.deleteAllTokens();
        return LogoutResponse(success: true);
      } else {
        final error = jsonDecode(response.body);
        return LogoutResponse(
          success: false,
          message: error['message'] ?? '로그아웃에 실패했습니다.',
        );
      }
    } catch (e) {
      // 보안: 에러 상세 정보는 로그에만 출력
      print('Logout error: $e');
      return LogoutResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
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
