import 'package:http/http.dart' as http;
import 'dart:convert';
import '../storage/token_storage.dart';
import 'refreshService.dart';

class AuthInterceptor {
  static final AuthInterceptor _instance = AuthInterceptor._internal();
  factory AuthInterceptor() => _instance;
  AuthInterceptor._internal();

  static const String baseUrl = 'http://localhost:8080/api';
  
  final _tokenStorage = TokenStorage();
  final _refreshService = RefreshService();
  bool _isRefreshing = false;

  // 토큰이 필요한 요청에 자동으로 Authorization 헤더 추가
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _tokenStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // GET 요청
  Future<http.Response> get(String endpoint) async {
    return authenticatedRequest(
      request: (headers) => http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ),
    );
  }

  // POST 요청
  Future<http.Response> post(String endpoint, {dynamic body}) async {
    return authenticatedRequest(
      request: (headers) => http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  // PUT 요청
  Future<http.Response> put(String endpoint, {dynamic body}) async {
    return authenticatedRequest(
      request: (headers) => http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ),
    );
  }

  // DELETE 요청
  Future<http.Response> delete(String endpoint) async {
    return authenticatedRequest(
      request: (headers) => http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      ),
    );
  }

  // API 호출 시 토큰 만료 자동 갱신
  Future<http.Response> authenticatedRequest({
    required Future<http.Response> Function(Map<String, String> headers) request,
  }) async {
    // 토큰 만료 여부 미리 체크
    final isExpired = await _tokenStorage.isAccessTokenExpired();
    if (isExpired && !_isRefreshing) {
      await _tryRefreshToken();
    }

    // 첫 번째 시도
    var headers = await getAuthHeaders();
    var response = await request(headers);

    // 401 에러 시 토큰 갱신 후 재시도
    if (response.statusCode == 401 && !_isRefreshing) {
      final refreshed = await _tryRefreshToken();
      
      if (refreshed) {
        // 새 토큰으로 재시도
        headers = await getAuthHeaders();
        response = await request(headers);
      }
    }

    return response;
  }

  // 토큰 재발급 시도
  Future<bool> _tryRefreshToken() async {
    if (_isRefreshing) return false;
    
    _isRefreshing = true;
    
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      
      if (refreshToken == null) {
        await _tokenStorage.deleteTokens();
        return false;
      }

      // Refresh Token도 만료되었는지 확인
      if (await _tokenStorage.isRefreshTokenExpired()) {
        await _tokenStorage.deleteTokens();
        return false;
      }

      final refreshResponse = await _refreshService.refreshToken(refreshToken);
      
      if (refreshResponse.success && 
          refreshResponse.accessToken != null && 
          refreshResponse.refreshToken != null) {
        // 새 토큰 저장
        await _tokenStorage.saveTokens(
          accessToken: refreshResponse.accessToken!,
          refreshToken: refreshResponse.refreshToken!,
        );
        return true;
      } else {
        // 토큰 재발급 실패 → 로그아웃 처리
        await _tokenStorage.deleteTokens();
        return false;
      }
    } catch (e) {
      // 에러 발생 시 조용히 실패 처리 (보안)
      await _tokenStorage.deleteTokens();
      return false;
    } finally {
      _isRefreshing = false;
    }
  }
}
