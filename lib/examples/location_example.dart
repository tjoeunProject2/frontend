import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location/location_service.dart';

// 사용 예시 위젯
class LocationExample extends StatefulWidget {
  const LocationExample({super.key});

  @override
  State<LocationExample> createState() => _LocationExampleState();
}

class _LocationExampleState extends State<LocationExample> {
  final _locationService = LocationService();
  Position? _currentPosition;
  String? _error;
  bool _isLoading = false;

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('위치 정보')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_currentPosition != null)
              Column(
                children: [
                  Text('위도: ${_currentPosition!.latitude}'),
                  Text('경도: ${_currentPosition!.longitude}'),
                  Text('정확도: ${_currentPosition!.accuracy}m'),
                ],
              )
            else
              const Text('위치 버튼을 눌러주세요'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('현재 위치 가져오기'),
            ),
          ],
        ),
      ),
    );
  }
}
