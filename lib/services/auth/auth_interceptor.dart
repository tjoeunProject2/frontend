import 'package:http/http.dart' as http;
import 'dart:convert';
import '../storage/token_storage.dart';
import 'refreshService.dart';

class AuthInterceptor {
  static final AuthInterceptor _instance = AuthInterceptor._internal();
  factory AuthInterceptor() => _instance;
  AuthInterceptor._internal();

  final _tokenStorage = TokenStorage();
  final _refreshService = RefreshService();

  // 토큰이 필요한 요청에 자동으로 Authorization 헤더 추가
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _tokenStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // API 호출 시 토큰 만료 자동 갱신
  Future<http.Response> authenticatedRequest({
    required Future<http.Response> Function(Map<String, String> headers) request,
  }) async {
    // 첫 번째 시도
    var headers = await getAuthHeaders();
    var response = await request(headers);

    // 401 에러 시 토큰 갱신 후 재시도
    if (response.statusCode == 401) {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        final refreshResponse = await _refreshService.refreshToken(refreshToken);
        
        if (refreshResponse.success && 
            refreshResponse.accessToken != null && 
            refreshResponse.refreshToken != null) {
          // 새 토큰 저장
          await _tokenStorage.saveTokens(
            accessToken: refreshResponse.accessToken!,
            refreshToken: refreshResponse.refreshToken!,
          );
          
          // 새 토큰으로 재시도
          headers = await getAuthHeaders();
          response = await request(headers);
        }
      }
    }

    return response;
  }
}
