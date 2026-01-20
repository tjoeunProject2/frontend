import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/favorite.dart';

class AddFavoriteService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<AddFavoriteResponse> addFavorite({
    required String accessToken,
    required int flowerId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'flowerId': flowerId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AddFavoriteResponse(
          success: true,
          favorite: Favorite.fromJson(data),
        );
      } else {
        final error = jsonDecode(response.body);
        return AddFavoriteResponse(
          success: false,
          message: error['message'] ?? '즐겨찾기 추가에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Add favorite error: $e');
      return AddFavoriteResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class AddFavoriteResponse {
  final bool success;
  final Favorite? favorite;
  final String? message;

  AddFavoriteResponse({
    required this.success,
    this.favorite,
    this.message,
  });
}
