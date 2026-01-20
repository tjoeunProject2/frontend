import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DeleteViewHistoryService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<DeleteViewHistoryResponse> deleteViewHistory({
    required String accessToken,
    required int viewId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/view-history/$viewId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DeleteViewHistoryResponse(
          success: true,
          message: data['message'] ?? '조회 기록이 삭제되었습니다.',
        );
      } else {
        final error = jsonDecode(response.body);
        return DeleteViewHistoryResponse(
          success: false,
          message: error['message'] ?? '조회 기록 삭제에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Delete view history error: $e');
      return DeleteViewHistoryResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class DeleteViewHistoryResponse {
  final bool success;
  final String? message;

  DeleteViewHistoryResponse({
    required this.success,
    this.message,
  });
}
