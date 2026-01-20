import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/flower.dart';
import '../cache/cache_service.dart';

class GetFlowerDetailService {
  static const String baseUrl = 'http://localhost:8080/api';
  final _cache = CacheService();

  Future<GetFlowerDetailResponse> getFlowerDetail({
    required String accessToken,
    required int flowerId,
  }) async {
    final cacheKey = 'flower_detail_$flowerId';
    
    // 캐시 확인
    final cached = _cache.get<Flower>(cacheKey);
    if (cached != null) {
      return GetFlowerDetailResponse(
        success: true,
        flower: cached,
      );
    }

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
        final flower = Flower.fromJson(data);
        
        // 30분 캐시 저장
        _cache.set(cacheKey, flower, const Duration(minutes: 30));
        
        return GetFlowerDetailResponse(
          success: true,
          flower: flower,
        );
      } else {
        final error = jsonDecode(response.body);
        return GetFlowerDetailResponse(
          success: false,
          message: error['message'] ?? '꽃 상세 정보 조회에 실패했습니다.',
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Get flower detail error: $e');
      return GetFlowerDetailResponse(
        success: false,
        message: '네트워크 오류가 발생했습니다.',
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
