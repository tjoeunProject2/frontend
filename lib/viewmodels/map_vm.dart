import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import '../services/location/location_service.dart';
import '../services/shops/nearbyService.dart';
import '../models/flowerShop.dart';

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
  String? currentKeyword; // 현재 검색 키워드

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
      currentLocation = LatLng(gangnamLat, gangnamLng); // 임시

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
  Future<void> loadNearbyShops(double lat, double lng, {int radius = 1000, String? keyword}) async {
    try {
      final response = await _nearbyService.getNearbyShops(
        latitude: lat,
        longitude: lng,
        radius: radius,
        keyword: keyword,
      );

      if (response.success && response.shops != null) {
        shops = response.shops!;
        currentKeyword = keyword;
        if (kDebugMode) {
          debugPrint('Loaded ${shops.length} shops at ($lat, $lng).');
        }
      } else {
        errorMessage = response.message;
      }

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
  Future<void> searchLocation(double lat, double lng, {int radius = 1000}) async {
    currentLocation = LatLng(lat, lng);
    await loadNearbyShops(lat, lng, radius: radius);
  }

  // 키워드로 꽃집 검색
  Future<void> searchShopsByKeyword(String keyword) async {
    if (currentLocation == null) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await loadNearbyShops(
        currentLocation!.latitude,
        currentLocation!.longitude,
        radius: 1000, // 검색 시 반경 확대
        keyword: keyword,
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = '꽃집 검색에 실패했습니다: $e';
      notifyListeners();
    }
  }

  // 검색 초기화
  Future<void> clearSearch() async {
    if (currentLocation == null) return;

    currentKeyword = null;
    await loadNearbyShops(
      currentLocation!.latitude,
      currentLocation!.longitude,
    );
  }

  // 카메라 위치로 꽃집 검색 (지도 이동 시 사용)
  Future<void> searchShopsAtCameraPosition(double lat, double lng, {int radius = 1000}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await loadNearbyShops(lat, lng, radius: radius);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = '주변 꽃집 검색에 실패했습니다: $e';
      notifyListeners();
    }
  }

  // 특정 꽃집으로 이동 (마이페이지에서 위치보기)
  void moveToShop(FlowerShop shop) {
    currentLocation = LatLng(shop.lat, shop.lng);
    selectedShop = shop;
    // shops에 해당 꽃집이 없으면 추가
    if (!shops.any((s) => s.id == shop.id)) {
      shops.add(shop);
    }
    notifyListeners();
  }
}
