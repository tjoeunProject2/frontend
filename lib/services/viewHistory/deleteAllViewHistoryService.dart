import 'dart:convert';
import 'package:http/http.dart' as http;

class DeleteAllViewHistoryService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<DeleteAllViewHistoryResponse> deleteAllViewHistory(
      String accessToken) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/view-history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DeleteAllViewHistoryResponse(
          success: true,
          message: data['message'] ?? '모든 조회 기록이 삭제되었습니다.',
        );
      } else {
        final error = jsonDecode(response.body);
        return DeleteAllViewHistoryResponse(
          success: false,
          message: error['message'] ?? '조회 기록 전체 삭제에 실패했습니다.',
        );
      }
    } catch (e) {
      return DeleteAllViewHistoryResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class DeleteAllViewHistoryResponse {
  final bool success;
  final String? message;

  DeleteAllViewHistoryResponse({
    required this.success,
    this.message,
  });
}
