import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GenerateCardMessageService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<GenerateCardMessageResponse> generateCardMessage({
    required String accessToken,
    required String flowerName,
    required List<String> floriography,
    required String query,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cards/message'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'flowerName': flowerName,
          'floriography': floriography,
          'query': query,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GenerateCardMessageResponse(
          success: true,
          message: data['message'] as String,
        );
      } else {
        final error = jsonDecode(response.body);
        return GenerateCardMessageResponse(
          success: false,
          message: error['message'] ?? '카드 메시지 생성에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Generate card message error: $e');
      return GenerateCardMessageResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class GenerateCardMessageResponse {
  final bool success;
  final String? message;

  GenerateCardMessageResponse({
    required this.success,
    this.message,
  });
}
