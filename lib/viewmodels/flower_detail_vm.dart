import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flower.dart';
import '../services/flowers/getFlowerDetailService.dart';
import '../services/viewHistory/addViewHistoryService.dart';
import '../services/storage/token_storage.dart';

final flowerDetailViewModelProvider = ChangeNotifierProvider.family<FlowerDetailViewModel, String>((ref, flowerId) {
  return FlowerDetailViewModel(flowerId);
});

class FlowerDetailViewModel extends ChangeNotifier {
  final String flowerId;
  final _flowerDetailService = GetFlowerDetailService();
  final _addViewHistoryService = AddViewHistoryService();
  final _tokenStorage = TokenStorage();

  Flower? _flower;
  bool _isLoading = false;
  String? _errorMessage;

  Flower? get flower => _flower;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FlowerDetailViewModel(this.flowerId) {
    loadFlowerDetail();
  }

  // 꽃 상세 정보 조회
  Future<void> loadFlowerDetail() async {
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

      final response = await _flowerDetailService.getFlowerDetail(
        accessToken: accessToken,
        flowerId: int.parse(flowerId),
      );
      
      if (response.success && response.flower != null) {
        _flower = response.flower;
        
        // 조회 기록 추가
        await _addViewHistory();
      } else {
        _errorMessage = response.message ?? '꽃 정보를 불러올 수 없습니다.';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('꽃 상세 조회 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 조회 기록 추가 (백그라운드)
  Future<void> _addViewHistory() async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) return;

      await _addViewHistoryService.addViewHistory(
        accessToken: accessToken,
        flowerId: int.parse(flowerId),
      );
      
      if (kDebugMode) debugPrint('조회 기록 추가: $flowerId');
    } catch (e) {
      if (kDebugMode) debugPrint('조회 기록 추가 오류: $e');
    }
  }

  // 새로고침
  Future<void> refresh() async {
    await loadFlowerDetail();
  }
}
