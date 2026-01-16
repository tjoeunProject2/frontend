import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../viewmodels/map_vm.dart';
import '../viewmodels/liked_shops_vm.dart';
import '../models/flower_shop.dart';
import '../common/widgets/navigation_app_selector.dart';

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
    final likedShopsVm = ref.watch(likedShopsViewModelProvider);

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

          // 하단 꽃집 리스트 (선택 시) - 드래그 가능한 하단 시트
          if (vm.selectedShop != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  // 위로 드래그 감지
                  if (details.primaryDelta! < -5) {
                    // 위로 스와이프 시 더 많은 정보 표시 (BottomSheet 열기)
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => _buildExpandedShopInfo(vm.selectedShop!, likedShopsVm),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 드래그 핸들
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
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
                          // 좋아요 아이콘
                          IconButton(
                            icon: Icon(
                              likedShopsVm.isLiked(vm.selectedShop!.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: likedShopsVm.isLiked(vm.selectedShop!.id)
                                  ? Colors.pink
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              likedShopsVm.toggleLike(vm.selectedShop!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    likedShopsVm.isLiked(vm.selectedShop!.id)
                                        ? '${vm.selectedShop!.name}을(를) 가고 싶은 꽃집에 추가했습니다'
                                        : '${vm.selectedShop!.name}을(를) 가고 싶은 꽃집에서 제거했습니다',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
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
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final phoneNumber = vm.selectedShop!.phone.replaceAll(RegExp(r'[^0-9]'), '');
                                final url = Uri.parse('tel:$phoneNumber');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('전화를 걸 수 없습니다')),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.phone, size: 20),
                              label: const Text('전화하기'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF7C4DFF),
                                side: const BorderSide(color: Color(0xFF7C4DFF)),
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => NavigationAppSelector(
                                    destinationLat: vm.selectedShop!.lat,
                                    destinationLng: vm.selectedShop!.lng,
                                    destinationName: vm.selectedShop!.name,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7C4DFF),
                                minimumSize: const Size(0, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                '길찾기',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

  // 확장된 꽃집 정보 시트
  Widget _buildExpandedShopInfo(FlowerShop shop, LikedShopsViewModel likedShopsVm) {
    return Consumer(
      builder: (context, ref, child) {
        final likedVm = ref.watch(likedShopsViewModelProvider);
        
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  // 드래그 핸들
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  // 헤더
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          likedVm.isLiked(shop.id) ? Icons.favorite : Icons.favorite_border,
                          color: likedVm.isLiked(shop.id) ? Colors.pink : Colors.grey,
                        ),
                        onPressed: () {
                          likedVm.toggleLike(shop);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 정보 섹션
                  _buildInfoRow(Icons.location_on, '주소', shop.address),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.phone, '전화번호', shop.phone),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.directions_walk, '거리', shop.formattedDistance),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // 설명 섹션
                  const Text(
                    '소개',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${shop.name}은(는) 다양한 꽃과 화환을 제공하는 전문 꽃집입니다. 고객의 특별한 순간을 아름답게 만들어 드립니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final phoneNumber = shop.phone.replaceAll(RegExp(r'[^0-9]'), '');
                            final url = Uri.parse('tel:$phoneNumber');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('전화를 걸 수 없습니다')),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.phone, size: 20),
                          label: const Text('전화하기'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF7C4DFF),
                            side: const BorderSide(color: Color(0xFF7C4DFF)),
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => NavigationAppSelector(
                                destinationLat: shop.lat,
                                destinationLng: shop.lng,
                                destinationName: shop.name,
                              ),
                            );
                          },
                          icon: const Icon(Icons.directions, size: 20),
                          label: const Text('길찾기'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7C4DFF),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF7C4DFF)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
