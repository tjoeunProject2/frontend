import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteAllSearchService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<DeleteAllSearchResponse> deleteAllSearch(String accessToken) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/search/recent/all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        return DeleteAllSearchResponse(
          success: true,
          message: '모든 검색어가 삭제되었습니다.',
        );
      } else {
        final error = jsonDecode(response.body);
        return DeleteAllSearchResponse(
          success: false,
          message: error['message'] ?? '검색어 전체 삭제에 실패했습니다.',
        );
      }
    } catch (e) {
      return DeleteAllSearchResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class DeleteAllSearchResponse {
  final bool success;
  final String? message;

  DeleteAllSearchResponse({
    required this.success,
    this.message,
  });
}
