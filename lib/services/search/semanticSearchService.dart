import 'dart:convert';
import 'package:http/http.dart' as http;

class SemanticSearchService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<SemanticSearchResponse> semanticSearch({
    required String accessToken,
    required String query,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/search')
          .replace(queryParameters: {'query': query});

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final embeddingVector = data.map((e) => e as double).toList();

        return SemanticSearchResponse(
          success: true,
          embeddingVector: embeddingVector,
        );
      } else {
        final error = jsonDecode(response.body);
        return SemanticSearchResponse(
          success: false,
          message: error['message'] ?? '시맨틱 검색에 실패했습니다.',
        );
      }
    } catch (e) {
      return SemanticSearchResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class SemanticSearchResponse {
  final bool success;
  final List<double>? embeddingVector;
  final String? message;

  SemanticSearchResponse({
    required this.success,
    this.embeddingVector,
    this.message,
  });
}
