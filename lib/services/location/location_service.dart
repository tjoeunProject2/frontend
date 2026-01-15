import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // 위치 권한 확인 및 요청
  Future<bool> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.locationWhenInUse.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      // 설정으로 이동 안내
      await openAppSettings();
      return false;
    }

    return false;
  }

  // 현재 위치 가져오기
  Future<Position?> getCurrentLocation() async {
    try {
      // 위치 서비스 활성화 확인
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationServiceDisabledException();
      }

      // 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationPermissionDeniedException();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationPermissionPermanentlyDeniedException();
      }

      // 현재 위치 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      rethrow;
    }
  }

  // 위치 스트림 (실시간 위치 추적)
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // 10미터 이동 시 업데이트
      ),
    );
  }

  // 두 좌표 사이의 거리 계산 (미터)
  double getDistanceBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}

// 커스텀 예외
class LocationServiceDisabledException implements Exception {
  @override
  String toString() => '위치 서비스가 비활성화되어 있습니다. 설정에서 활성화해주세요.';
}

class LocationPermissionDeniedException implements Exception {
  @override
  String toString() => '위치 권한이 거부되었습니다.';
}

class LocationPermissionPermanentlyDeniedException implements Exception {
  @override
  String toString() => '위치 권한이 영구적으로 거부되었습니다. 설정에서 권한을 허용해주세요.';
}
