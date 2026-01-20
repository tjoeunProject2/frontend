import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class EmbeddingService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<EmbeddingResponse> getEmbedding({
    required String accessToken,
    required String query,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/test/deepseek/embedding')
          .replace(queryParameters: {'query': query});

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EmbeddingResponse(
          success: true,
          semanticQuery: data['semanticQuery'] as String,
          vectorLength: data['vectorLength'] as int,
          vectorPreview: (data['vectorPreview'] as List<dynamic>)
              .map((e) => e as double)
              .toList(),
        );
      } else {
        final error = jsonDecode(response.body);
        return EmbeddingResponse(
          success: false,
          message: error['message'] ?? '임베딩 생성에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Embedding error: $e');
      return EmbeddingResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class EmbeddingResponse {
  final bool success;
  final String? semanticQuery;
  final int? vectorLength;
  final List<double>? vectorPreview;
  final String? message;

  EmbeddingResponse({
    required this.success,
    this.semanticQuery,
    this.vectorLength,
    this.vectorPreview,
    this.message,
  });
}
