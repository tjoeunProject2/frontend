import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AddViewHistoryService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<AddViewHistoryResponse> addViewHistory({
    required String accessToken,
    required int flowerId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/view-history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'flowerId': flowerId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AddViewHistoryResponse(
          success: true,
          message: data['message'] ?? '조회 기록이 저장되었습니다.',
        );
      } else {
        final error = jsonDecode(response.body);
        return AddViewHistoryResponse(
          success: false,
          message: error['message'] ?? '조회 기록 저장에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Add view history error: $e');
      return AddViewHistoryResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class AddViewHistoryResponse {
  final bool success;
  final String? message;

  AddViewHistoryResponse({
    required this.success,
    this.message,
  });
}
