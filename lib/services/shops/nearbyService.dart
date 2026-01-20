import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/flowerShop.dart';

class NearbyService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<NearbyShopsResponse> getNearbyShops({
    required double latitude,
    required double longitude,
    double radius = 5.0,
    String? keyword,
  }) async {
    try {
      final queryParams = {
        'lat': latitude.toString(),
        'lng': longitude.toString(),
        'radius': radius.toString(),
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      };

      final uri = Uri.parse('$baseUrl/shops/nearby')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final shops = data
            .map((json) => FlowerShop.fromJson(json as Map<String, dynamic>))
            .toList();

        return NearbyShopsResponse(
          success: true,
          shops: shops,
        );
      } else {
        final error = jsonDecode(response.body);
        return NearbyShopsResponse(
          success: false,
          message: error['message'] ?? '주변 꽃집 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Nearby shops error: $e');
      return NearbyShopsResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
      );
    }
  }
}

class NearbyShopsResponse {
  final bool success;
  final List<FlowerShop>? shops;
  final String? message;

  NearbyShopsResponse({
    required this.success,
    this.shops,
    this.message,
  });
}
