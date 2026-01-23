import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import '../../viewmodels/map_vm.dart';
import '../../config/env_config.dart';
import 'mapSearchBar.dart';
import 'mapErrorMessage.dart';
import 'myLocationButton.dart';
import 'shopBottomSheet.dart';
import 'expandedShopSheet.dart';
import 'mapScaleBar.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  KakaoMapController? _mapController;
  double _currentZoom = 3.0;

  @override
  void initState() {
    super.initState();
    // 초기 위치 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapViewModelProvider).loadCurrentLocation();
    });
  }

  void _onMapCreated(KakaoMapController controller) {
    _mapController = controller;
    // 마커 초기화
    _updateMarkers();
  }

  Future<void> _updateMarkers() async {
    if (_mapController == null) return;
    
    final vm = ref.read(mapViewModelProvider);
    final markers = <Marker>[];
    
    for (var shop in vm.shops) {
      markers.add(
        Marker(
          markerId: shop.id.toString(),
          latLng: LatLng(shop.lat, shop.lng),
          width: 30,
          height: 40,
        ),
      );
    }
    
    if (markers.isNotEmpty) {
      await _mapController!.addMarker(markers: markers);
    }
  }

  Future<void> _moveToCurrentLocation() async {
    final vm = ref.read(mapViewModelProvider);
    await vm.loadCurrentLocation();
    if (_mapController != null && vm.currentLatitude != null && vm.currentLongitude != null) {
      _mapController!.setCenter(LatLng(vm.currentLatitude!, vm.currentLongitude!));
    }
  }

  void _showExpandedShopInfo() {
    final vm = ref.read(mapViewModelProvider);
    if (vm.selectedShop != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ExpandedShopSheet(shop: vm.selectedShop!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(mapViewModelProvider);

    // 마커 업데이트
    if (vm.shops.isNotEmpty && _mapController != null) {
      _updateMarkers();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Kakao Map
          vm.currentLatitude == null || vm.currentLongitude == null
              ? const Center(child: CircularProgressIndicator())
              : KakaoMap(
                  onMapCreated: (controller) async {
                    _onMapCreated(controller);
                    // 초기 꽃집 검색
                    final center = await controller.getCenter();
                    await ref.read(mapViewModelProvider).searchShopsAtCameraPosition(
                      center.latitude,
                      center.longitude,
                      radius: 5.0,
                    );
                  },
                  center: LatLng(vm.currentLatitude!, vm.currentLongitude!),
                ),

          // 상단 검색바
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: MapSearchBar(
              isLoading: vm.isLoading,
              shopCount: vm.shops.length,
            ),
          ),

          // 에러 메시지
          if (vm.errorMessage != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: MapErrorMessage(errorMessage: vm.errorMessage!),
            ),

          // 하단 꽃집 정보 시트
          if (vm.selectedShop != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ShopBottomSheet(
                shop: vm.selectedShop!,
                onClose: () => vm.clearSelectedShop(),
                onExpand: _showExpandedShopInfo,
              ),
            ),

          // 내 위치로 이동 버튼
          Positioned(
            bottom: vm.selectedShop != null ? 280 : 100,
            right: 16,
            child: MyLocationButton(onPressed: _moveToCurrentLocation),
          ),

          // 축척(스케일) 표시
          Positioned(
            bottom: vm.selectedShop != null ? 310 : 130,
            left: 16,
            child: MapScaleBar(
              zoomLevel: _currentZoom,
              screenWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}
