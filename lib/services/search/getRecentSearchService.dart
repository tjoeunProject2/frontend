import 'dart:convert';
import 'package:http/http.dart' as http;

class GetRecentSearchService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<GetRecentSearchResponse> getRecentSearch(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/recent'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final recentSearches = data.map((e) => e as String).toList();

        return GetRecentSearchResponse(
          success: true,
          recentSearches: recentSearches,
        );
      } else {
        final error = jsonDecode(response.body);
        return GetRecentSearchResponse(
          success: false,
          message: error['message'] ?? '최근 검색어 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      return GetRecentSearchResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class GetRecentSearchResponse {
  final bool success;
  final List<String>? recentSearches;
  final String? message;

  GetRecentSearchResponse({
    required this.success,
    this.recentSearches,
    this.message,
  });
}
