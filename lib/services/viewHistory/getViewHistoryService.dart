import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/viewHistory.dart';

class GetViewHistoryService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<GetViewHistoryResponse> getViewHistory(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/view-history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final viewHistory = data
            .map((json) => ViewHistory.fromJson(json as Map<String, dynamic>))
            .toList();

        return GetViewHistoryResponse(
          success: true,
          viewHistory: viewHistory,
        );
      } else {
        final error = jsonDecode(response.body);
        return GetViewHistoryResponse(
          success: false,
          message: error['message'] ?? '조회 기록 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      return GetViewHistoryResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class GetViewHistoryResponse {
  final bool success;
  final List<ViewHistory>? viewHistory;
  final String? message;

  GetViewHistoryResponse({
    required this.success,
    this.viewHistory,
    this.message,
  });
}
