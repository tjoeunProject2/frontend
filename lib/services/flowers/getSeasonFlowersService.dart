import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/flower.dart';
import '../cache/cache_service.dart';

class GetSeasonFlowersService {
  static const String baseUrl = 'http://localhost:8080/api';
  final _cache = CacheService();

  Future<GetSeasonFlowersResponse> getSeasonFlowers({
    required String accessToken,
    required String season,
  }) async {
    final cacheKey = 'season_flowers_$season';
    
    // 캐시 확인
    final cached = _cache.get<List<Flower>>(cacheKey);
    if (cached != null) {
      return GetSeasonFlowersResponse(
        success: true,
        flowers: cached,
      );
    }

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

        // 1시간 캐시 저장
        _cache.set(cacheKey, flowers, const Duration(hours: 1));

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
      if (kDebugMode) debugPrint('Get season flowers error: $e');
      return GetSeasonFlowersResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
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
