import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/flower.dart';

class GetTodayFlowerService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<GetTodayFlowerResponse> getTodayFlower(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/flowers/today'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GetTodayFlowerResponse(
          success: true,
          flower: Flower.fromJson(data),
        );
      } else {
        final error = jsonDecode(response.body);
        return GetTodayFlowerResponse(
          success: false,
          message: error['message'] ?? '오늘의 꽃 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      return GetTodayFlowerResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class GetTodayFlowerResponse {
  final bool success;
  final Flower? flower;
  final String? message;

  GetTodayFlowerResponse({
    required this.success,
    this.flower,
    this.message,
  });
}
