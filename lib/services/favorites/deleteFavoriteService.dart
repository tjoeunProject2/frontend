import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DeleteFavoriteService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<DeleteFavoriteResponse> deleteFavorite({
    required String accessToken,
    required int flowerId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/$flowerId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DeleteFavoriteResponse(
          success: true,
          message: data['message'] ?? '즐겨찾기에서 삭제되었습니다.',
        );
      } else {
        final error = jsonDecode(response.body);
        return DeleteFavoriteResponse(
          success: false,
          message: error['message'] ?? '즐겨찾기 삭제에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Delete favorite error: $e');
      return DeleteFavoriteResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class DeleteFavoriteResponse {
  final bool success;
  final String? message;

  DeleteFavoriteResponse({
    required this.success,
    this.message,
  });
}
