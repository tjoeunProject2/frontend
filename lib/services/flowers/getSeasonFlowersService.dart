import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/flower.dart';

class GetSeasonFlowersService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<GetSeasonFlowersResponse> getSeasonFlowers({
    required String accessToken,
    required String season,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/flowers/season')
          .replace(queryParameters: {'season': season});

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final flowers = data
            .map((json) => Flower.fromJson(json as Map<String, dynamic>))
            .toList();

        return GetSeasonFlowersResponse(
          success: true,
          flowers: flowers,
        );
      } else {
        final error = jsonDecode(response.body);
        return GetSeasonFlowersResponse(
          success: false,
          message: error['message'] ?? '계절별 꽃 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      return GetSeasonFlowersResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class GetSeasonFlowersResponse {
  final bool success;
  final List<Flower>? flowers;
  final String? message;

  GetSeasonFlowersResponse({
    required this.success,
    this.flowers,
    this.message,
  });
}
