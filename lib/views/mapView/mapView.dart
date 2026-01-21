import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/map_vm.dart';
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
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    // 초기 위치 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapViewModelProvider).loadCurrentLocation();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // 화면 크기에 따른 반지름 계산 (km)
  double _calculateRadius(double latDiff, double lngDiff) {
    // 위도 1도 ≈ 111km, 경도는 위도에 따라 다르지만 평균 약 88km (한국 기준)
    const kmPerLatDegree = 111.0;
    const kmPerLngDegree = 88.0;
    
    final latDistance = latDiff * kmPerLatDegree;
    final lngDistance = lngDiff * kmPerLngDegree;
    
    // 대각선 거리의 절반을 반지름으로 사용
    final diagonal = (latDistance * latDistance + lngDistance * lngDistance);
    final radius = (diagonal / 2).clamp(1.0, 50.0); // 최소 1km, 최대 50km
    
    return radius;
  }

  void _updateMarkers() {
    final vm = ref.read(mapViewModelProvider);
    _markers = vm.shops.map((shop) {
      return Marker(
        markerId: MarkerId(shop.name),
        position: LatLng(shop.lat, shop.lng),
        onTap: () {
          vm.selectShop(shop);
        },
      );
    }).toSet();
  }

  Future<void> _moveToCurrentLocation() async {
    final vm = ref.read(mapViewModelProvider);
    await vm.loadCurrentLocation();
    if (_mapController != null && vm.currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            vm.currentLocation!.latitude,
            vm.currentLocation!.longitude,
          ),
        ),
      );
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
    if (vm.shops.isNotEmpty) {
      _updateMarkers();
    }

    return Scaffold(
      body: Stack(
        children: [
          // Google Maps
          vm.currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      vm.currentLocation!.latitude,
                      vm.currentLocation!.longitude,
                    ),
                    zoom: 15,
                  ),
                  markers: _markers,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  buildingsEnabled: false,
                  trafficEnabled: false,
                  onCameraIdle: () async {
                    // 카메라 이동이 완료되면 해당 위치의 꽃집 검색
                    if (_mapController != null) {
                      final bounds = await _mapController!.getVisibleRegion();
                      final lat = (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
                      final lng = (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
                      
                      // 화면에 보이는 영역의 반지름 계산 (km 단위)
                      final latDiff = bounds.northeast.latitude - bounds.southwest.latitude;
                      final lngDiff = bounds.northeast.longitude - bounds.southwest.longitude;
                      final radius = _calculateRadius(latDiff, lngDiff);
                      
                      await ref.read(mapViewModelProvider).searchShopsAtCameraPosition(lat, lng, radius: radius);
                    }
                  },
                  onCameraMove: (position) {
                    setState(() {
                      _currentZoom = position.zoom;
                    });
                  },
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
