import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/flower.dart';

class SearchFlowerByNameService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<SearchFlowerByNameResponse> searchFlowerByName({
    required String accessToken,
    required String name,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/flowers/search')
          .replace(queryParameters: {'name': name});

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

        return SearchFlowerByNameResponse(
          success: true,
          flowers: flowers,
        );
      } else {
        final error = jsonDecode(response.body);
        return SearchFlowerByNameResponse(
          success: false,
          message: error['message'] ?? '이름 검색에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Search flower by name error: $e');
      return SearchFlowerByNameResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class SearchFlowerByNameResponse {
  final bool success;
  final List<Flower>? flowers;
  final String? message;

  SearchFlowerByNameResponse({
    required this.success,
    this.flowers,
    this.message,
  });
}
