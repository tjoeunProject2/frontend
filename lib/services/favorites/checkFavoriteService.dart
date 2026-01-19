import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckFavoriteService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<CheckFavoriteResponse> checkFavorite({
    required String accessToken,
    required int flowerId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorites/check/$flowerId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CheckFavoriteResponse(
          success: true,
          isFavorite: data['isFavorite'] as bool,
          favoriteId: data['favoriteId'] as int?,
        );
      } else {
        final error = jsonDecode(response.body);
        return CheckFavoriteResponse(
          success: false,
          message: error['message'] ?? '즐겨찾기 확인에 실패했습니다.',
        );
      }
    } catch (e) {
      return CheckFavoriteResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class CheckFavoriteResponse {
  final bool success;
  final bool? isFavorite;
  final int? favoriteId;
  final String? message;

  CheckFavoriteResponse({
    required this.success,
    this.isFavorite,
    this.favoriteId,
    this.message,
  });
}
