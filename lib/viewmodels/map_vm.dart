import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location/location_service.dart';
import '../services/shops/nearbyService.dart';
import '../models/flower_shop.dart';

final mapViewModelProvider = ChangeNotifierProvider<MapViewModel>((ref) {
  return MapViewModel();
});

class MapViewModel extends ChangeNotifier {
  final _locationService = LocationService();
  final _nearbyService = NearbyService();

  LatLng? currentLocation;
  List<FlowerShop> shops = [];
  FlowerShop? selectedShop;
  bool isLoading = false;
  String? errorMessage;

  // 현재 위치 가져오기 및 주변 꽃집 검색
  Future<void> loadCurrentLocation() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // TODO: 개발 완료 후 실제 GPS 위치로 변경
      // final position = await _locationService.getCurrentLocation();
      // if (position == null) {
      //   throw Exception('위치 정보를 가져올 수 없습니다.');
      // }
      // currentLocation = LatLng(position.latitude, position.longitude);
      
      // 임시 하드코딩: 강남역 위치
      const gangnamLat = 37.498095; // 임시
      const gangnamLng = 127.027610; // 임시
      currentLocation = const LatLng(gangnamLat, gangnamLng); // 임시

      // 주변 꽃집 검색
      // await loadNearbyShops(position.latitude, position.longitude);
      await loadNearbyShops(gangnamLat, gangnamLng); // 임시

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // 주변 꽃집 검색
  Future<void> loadNearbyShops(double lat, double lng) async {
    try {
      // TODO: 개발 완료 후 실제 API 호출로 변경
      // final response = await _nearbyService.getNearbyShops(
      //   latitude: lat,
      //   longitude: lng,
      //   radius: 5000, // 5km
      // );
      // if (response.success && response.shops != null) {
      //   shops = response.shops!;
      //   _createMarkers();
      // } else {
      //   errorMessage = response.message;
      // }
      
      // 임시 하드코딩: 강남역 주변 꽃집 샘플 데이터
      shops = [
        FlowerShop(
          name: '강남 플라워샵',
          address: '서울 강남구 강남대로 396',
          lat: 37.498500,
          lng: 127.028000,
          distance: 100,
          phone: '02-1234-5678',
          placeUrl: 'http://place.map.kakao.com/example1',
        ),
        FlowerShop(
          name: '신논현 꽃집',
          address: '서울 강남구 강남대로 지하 396',
          lat: 37.504500,
          lng: 127.025000,
          distance: 720,
          phone: '02-2345-6789',
          placeUrl: 'http://place.map.kakao.com/example2',
        ),
        FlowerShop(
          name: '논현동 플라워',
          address: '서울 강남구 논현로 507',
          lat: 37.510000,
          lng: 127.022000,
          distance: 1350,
          phone: '02-3456-7890',
          placeUrl: 'http://place.map.kakao.com/example3',
        ),
      ];
      
      notifyListeners();
    } catch (e) {
      errorMessage = '주변 꽃집 검색에 실패했습니다: $e';
      notifyListeners();
    }
  }

  // 꽃집 선택
  void selectShop(FlowerShop shop) {
    selectedShop = shop;
    notifyListeners();
  }

  // 선택된 꽃집 초기화
  void clearSelectedShop() {
    selectedShop = null;
    notifyListeners();
  }

  // 특정 위치로 검색 (검색 기능에서 사용)
  Future<void> searchLocation(double lat, double lng) async {
    currentLocation = LatLng(lat, lng);
    await loadNearbyShops(lat, lng);
  }
}
