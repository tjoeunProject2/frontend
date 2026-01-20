import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../auth/refreshService.dart';

class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  factory TokenStorage() => _instance;
  TokenStorage._internal();

  final _storage = const FlutterSecureStorage();
  final _refreshService = RefreshService();

  // 키 상수
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  // Access Token 저장
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // Refresh Token 저장
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  // 두 토큰 한번에 저장
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  // Access Token 읽기
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Refresh Token 읽기
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Access Token 삭제
  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  // Refresh Token 삭제
  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  // 모든 토큰 삭제 (로그아웃 시)
  Future<void> deleteAllTokens() async {
    await Future.wait([
      deleteAccessToken(),
      deleteRefreshToken(),
    ]);
  }

  // 토큰 존재 여부 확인
  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  // 유효한 Access Token 가져오기 (만료 시 자동 갱신)
  Future<String?> getValidAccessToken() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    // 만료되지 않았으면 그대로 반환
    if (!(await isAccessTokenExpired())) {
      return accessToken;
    }

    // 만료되었으면 refresh token으로 갱신 시도
    return await refreshAccessToken();
  }

  // Access Token 갱신
  Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return null;

    // Refresh Token도 만료되었으면 null 반환
    if (await isRefreshTokenExpired()) {
      await deleteAllTokens();
      return null;
    }

    try {
      final response = await _refreshService.refreshToken(refreshToken);
      
      if (response.success && 
          response.accessToken != null && 
          response.refreshToken != null) {
        // 새 토큰 저장
        await saveTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken!,
        );
        return response.accessToken;
      } else {
        // 갱신 실패 시 토큰 삭제
        await deleteAllTokens();
        return null;
      }
    } catch (e) {
      await deleteAllTokens();
      return null;
    }
  }
}
