import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/flower.dart';

class GetAllFlowersService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<GetAllFlowersResponse> getAllFlowers(String accessToken) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/flowers'),
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

        return GetAllFlowersResponse(
          success: true,
          flowers: flowers,
        );
      } else {
        final error = jsonDecode(response.body);
        return GetAllFlowersResponse(
          success: false,
          message: error['message'] ?? '꽃 목록 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      return GetAllFlowersResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다: $e',
      );
    }
  }
}

class GetAllFlowersResponse {
  final bool success;
  final List<Flower>? flowers;
  final String? message;

  GetAllFlowersResponse({
    required this.success,
    this.flowers,
    this.message,
  });
}
