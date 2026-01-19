import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/flower.dart';

class GetFlowerDetailService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<GetFlowerDetailResponse> getFlowerDetail({
    required String accessToken,
    required int flowerId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/flowers/$flowerId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GetFlowerDetailResponse(
          success: true,
          flower: Flower.fromJson(data),
        );
      } else {
        final error = jsonDecode(response.body);
        return GetFlowerDetailResponse(
          success: false,
          message: error['message'] ?? '꽃 상세 정보 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      return GetFlowerDetailResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class GetFlowerDetailResponse {
  final bool success;
  final Flower? flower;
  final String? message;

  GetFlowerDetailResponse({
    required this.success,
    this.flower,
    this.message,
  });
}
