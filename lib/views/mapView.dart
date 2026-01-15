import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../viewmodels/map_vm.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

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
                ),

          // 상단 검색바
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      vm.isLoading ? '주변 꽃집 검색 중...' : '주변 꽃집 ${vm.shops.length}개',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 에러 메시지
          if (vm.errorMessage != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  vm.errorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),

          // 하단 꽃집 리스트 (선택 시)
          if (vm.selectedShop != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            vm.selectedShop!.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => vm.clearSelectedShop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            vm.selectedShop!.address,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          vm.selectedShop!.phone,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.directions_walk, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          vm.selectedShop!.formattedDistance,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: 길찾기 또는 상세 페이지로 이동
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C4DFF),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '길찾기',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 내 위치로 이동 버튼
          Positioned(
            bottom: vm.selectedShop != null ? 280 : 100,
            right: 16,
            child: FloatingActionButton(
              onPressed: () async {
                // 현재 위치 다시 불러오기
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
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Color(0xFF7C4DFF)),
            ),
          ),
        ],
      ),
    );
  }
}
