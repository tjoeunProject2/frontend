import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flower.dart';
import '../services/flowers/getTodayFlowerService.dart';
import '../services/flowers/getSeasonFlowersService.dart';
import '../services/storage/token_storage.dart';

final homeViewModelProvider = ChangeNotifierProvider<HomeViewModel>((ref) {
  return HomeViewModel();
});

class HomeViewModel extends ChangeNotifier {
  final _todayFlowerService = GetTodayFlowerService();
  final _seasonFlowerService = GetSeasonFlowersService();
  final _tokenStorage = TokenStorage();

  Flower? _todayFlower;
  List<Flower> _seasonFlowers = [];
  bool _isLoading = false;
  String? _errorMessage;

  Flower? get todayFlower => _todayFlower;
  List<Flower> get seasonFlowers => _seasonFlowers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 오늘의 꽃 조회
  Future<void> loadTodayFlower() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) {
        _errorMessage = '로그인이 필요합니다.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _todayFlowerService.getTodayFlower(accessToken);
      
      if (response.success && response.flower != null) {
        _todayFlower = response.flower;
      } else {
        _errorMessage = response.message ?? '오늘의 꽃을 불러올 수 없습니다.';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('오늘의 꽃 로드 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 계절별 꽃 조회
  Future<void> loadSeasonFlowers(String season) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) {
        _errorMessage = '로그인이 필요합니다.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _seasonFlowerService.getSeasonFlowers(
        accessToken: accessToken,
        season: season,
      );
      
      if (response.success && response.flowers != null) {
        _seasonFlowers = response.flowers!;
      } else {
        _errorMessage = response.message ?? '계절별 꽃을 불러올 수 없습니다.';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('계절별 꽃 로드 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 현재 계절 가져오기
  String getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return '봄';
    if (month >= 6 && month <= 8) return '여름';
    if (month >= 9 && month <= 11) return '가을';
    return '겨울';
  }

  // 초기 데이터 로드
  Future<void> initialize() async {
    await loadTodayFlower();
    await loadSeasonFlowers(getCurrentSeason());
  }
}
