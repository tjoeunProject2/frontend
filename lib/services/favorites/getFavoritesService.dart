import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/favorite.dart';

class GetFavoritesService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<GetFavoritesResponse> getFavorites(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final favorites = data
            .map((json) => Favorite.fromJson(json as Map<String, dynamic>))
            .toList();

        return GetFavoritesResponse(
          success: true,
          favorites: favorites,
        );
      } else {
        final error = jsonDecode(response.body);
        return GetFavoritesResponse(
          success: false,
          message: error['message'] ?? '즐겨찾기 목록 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      return GetFavoritesResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class GetFavoritesResponse {
  final bool success;
  final List<Favorite>? favorites;
  final String? message;

  GetFavoritesResponse({
    required this.success,
    this.favorites,
    this.message,
  });
}
