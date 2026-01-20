import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DeleteSearchService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<DeleteSearchResponse> deleteSearch({
    required String accessToken,
    required String query,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/search/recent')
          .replace(queryParameters: {'query': query});

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return DeleteSearchResponse(
          success: true,
          message: '검색어가 삭제되었습니다.',
        );
      } else {
        final error = jsonDecode(response.body);
        return DeleteSearchResponse(
          success: false,
          message: error['message'] ?? '검색어 삭제에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Delete search error: $e');
      return DeleteSearchResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class DeleteSearchResponse {
  final bool success;
  final String? message;

  DeleteSearchResponse({
    required this.success,
    this.message,
  });
}
