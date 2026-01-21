import 'package:flutter/material.dart';
import 'dart:math' as math;

class MapScaleBar extends StatelessWidget {
  final double zoomLevel;
  final double screenWidth;

  const MapScaleBar({
    super.key,
    required this.zoomLevel,
    required this.screenWidth,
  });

  // 줌 레벨에 따른 거리 계산
  Map<String, dynamic> _calculateScale() {
    // Google Maps 공식: 적도에서 1픽셀당 거리 = 156543.03392 미터 / 2^zoomLevel
    // 위도에 따른 보정: 실제 거리 = 적도 거리 * cos(latitude)
    // 한국 중앙(서울) 위도 37.5도 기준
    const latitude = 37.5;
    const equatorMetersPerPixel = 156543.03392;
    
    // 현재 줌 레벨에서 1픽셀당 미터 계산
    final metersPerPixel = equatorMetersPerPixel * math.cos(latitude * math.pi / 180) / math.pow(2, zoomLevel);
    
    // 화면 너비의 1/4을 스케일바 최대 길이로 사용
    final maxBarWidthPixels = screenWidth / 4;
    final maxDistanceMeters = metersPerPixel * maxBarWidthPixels;
    
    // 적절한 단위와 길이 선택
    if (maxDistanceMeters < 1000) {
      // 1km 미만: m 단위
      final roundedDistance = _roundDistance(maxDistanceMeters);
      final actualBarWidth = (roundedDistance / maxDistanceMeters) * maxBarWidthPixels;
      return {
        'distance': roundedDistance.toInt(),
        'unit': 'm',
        'width': actualBarWidth,
      };
    } else {
      // 1km 이상: km 단위
      final distanceKm = maxDistanceMeters / 1000;
      final roundedDistance = _roundDistance(distanceKm);
      final actualBarWidth = (roundedDistance / distanceKm) * maxBarWidthPixels;
      return {
        'distance': roundedDistance >= 10 ? roundedDistance.toInt() : roundedDistance,
        'unit': 'km',
        'width': actualBarWidth,
      };
    }
  }

  // 거리를 보기 좋은 숫자로 반올림
  double _roundDistance(double distance) {
    if (distance < 10) {
      return (distance * 2).round() / 2; // 0.5 단위
    } else if (distance < 100) {
      return (distance / 10).round() * 10.0; // 10 단위
    } else if (distance < 1000) {
      return (distance / 50).round() * 50.0; // 50 단위
    } else {
      return (distance / 100).round() * 100.0; // 100 단위
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = _calculateScale();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 텍스트 레이블
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              '${scale['distance']} ${scale['unit']}',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 2),
          // 스케일 바
          Container(
            width: scale['width'],
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black87, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
