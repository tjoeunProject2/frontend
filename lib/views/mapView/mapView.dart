import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
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
  KakaoMapController? _mapController;
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mapViewModelProvider).loadCurrentLocation();
    });
  }

  Future<void> _moveToCurrentLocation() async {
    final vm = ref.read(mapViewModelProvider);
    await vm.loadCurrentLocation();
    if (_mapController != null && vm.currentLocation != null) {
      _mapController!.panTo(
        LatLng(
          vm.currentLocation!.latitude,
          vm.currentLocation!.longitude,
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
    final markers = vm.shops
        .map(
          (shop) => Marker(
        markerId: shop.id,
        latLng: LatLng(shop.lat, shop.lng),
        infoWindowContent: shop.name,
      ),
    )
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          vm.currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : KakaoMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onMarkerTap: (markerId, _, __) {
              final matches =
              vm.shops.where((item) => item.id == markerId);
              if (matches.isNotEmpty) {
                vm.selectShop(matches.first);
              }
            },
            onZoomChangeCallback: (level, _) {
              setState(() {
                _currentZoom = level.toDouble();
              });
            },
            center: LatLng(
              vm.currentLocation!.latitude,
              vm.currentLocation!.longitude,
            ),
            markers: markers,
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: MapSearchBar(
              isLoading: vm.isLoading,
              shopCount: vm.shops.length,
            ),
          ),

          if (vm.errorMessage != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: MapErrorMessage(errorMessage: vm.errorMessage!),
            ),

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

          Positioned(
            bottom: vm.selectedShop != null ? 280 : 100,
            right: 16,
            child: MyLocationButton(onPressed: _moveToCurrentLocation),
          ),

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
