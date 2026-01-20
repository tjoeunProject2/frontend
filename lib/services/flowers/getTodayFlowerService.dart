import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/flower.dart';
import '../cache/cache_service.dart';

class GetTodayFlowerService {
  static const String baseUrl = 'http://localhost:8080/api';
  final _cache = CacheService();

  Future<GetTodayFlowerResponse> getTodayFlower(String accessToken) async {
    const cacheKey = 'today_flower';
    
    // 캐시 확인
    final cached = _cache.get<Flower>(cacheKey);
    if (cached != null) {
      return GetTodayFlowerResponse(
        success: true,
        flower: cached,
      );
    }

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
        final flower = Flower.fromJson(data);
        
        // 24시간 캐시 저장
        _cache.set(cacheKey, flower, const Duration(hours: 24));
        
        return GetTodayFlowerResponse(
          success: true,
          flower: flower,
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
