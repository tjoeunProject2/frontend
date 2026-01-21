import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/flower.dart';
import '../services/flowers/getFlowerDetailService.dart';
import '../services/viewHistory/addViewHistoryService.dart';
import '../services/favorites/addFavoriteService.dart';
import '../services/favorites/deleteFavoriteService.dart';
import '../services/favorites/checkFavoriteService.dart';
import '../services/storage/token_storage.dart';

final flowerDetailViewModelProvider = ChangeNotifierProvider.family<FlowerDetailViewModel, String>((ref, flowerId) {
  return FlowerDetailViewModel(flowerId);
});

class FlowerDetailViewModel extends ChangeNotifier {
  static const String _storageKey = 'liked_flowers';
  static const String _viewHistoryKey = 'view_history_flowers';
  final String flowerId;
  final _flowerDetailService = GetFlowerDetailService();
  final _addViewHistoryService = AddViewHistoryService();
  final _addFavoriteService = AddFavoriteService();
  final _deleteFavoriteService = DeleteFavoriteService();
  final _checkFavoriteService = CheckFavoriteService();
  final _tokenStorage = TokenStorage();

  Flower? _flower;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFavorite = false;

  Flower? get flower => _flower;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isFavorite => _isFavorite;

  FlowerDetailViewModel(this.flowerId) {
    loadFlowerDetail();
  }

  // 꽃 상세 정보 조회
  Future<void> loadFlowerDetail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: 로그인 구현 후 API 호출 활성화
      // final accessToken = await _tokenStorage.getAccessToken();
      // if (accessToken == null) {
      //   _errorMessage = '로그인이 필요합니다.';
      //   _isLoading = false;
      //   notifyListeners();
      //   return;
      // }

      // final response = await _flowerDetailService.getFlowerDetail(
      //   accessToken: accessToken,
      //   flowerId: int.parse(flowerId),
      // );
      // 
      // if (response.success && response.flower != null) {
      //   _flower = response.flower;
      //   
      //   // 조회 기록 추가
      //   await _addViewHistory();
      //   
      //   // 좋아요 상태 확인
      //   await _checkFavorite();
      // } else {
      //   _errorMessage = response.message ?? '꽃 정보를 불러올 수 없습니다.';
      // }
      
      // 임시 더미 데이터
      _flower = Flower(
        id: flowerId,
        name: 'Freesia',
        koreanName: '프리지아',
        season: '봄',
        occasion: '졸업식',
        tag: '클래식',
        imageUrl: 'https://via.placeholder.com/400',
        description: '남아프리카가 원산지인 프리지아는 우아한 종 모양의 꽃과 달콤하고 상큼한 시트러스 향으로 잘 알려져 있습니다.',
        isLiked: false,
      );
      
      // 좋아요 상태 확인
      await _checkFavorite();
      
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

  // 좋아요 상태 확인
  Future<void> _checkFavorite() async {
    try {
      // SharedPreferences에서 확인
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        final likedFlowers = jsonList.map((json) => Flower.fromJson(json)).toList();
        _isFavorite = likedFlowers.any((f) => f.id.toString() == flowerId);
        notifyListeners();
        if (kDebugMode) debugPrint('좋아요 상태 확인: $_isFavorite');
      }
      
      // TODO: 로그인 구현 후 API 확인 활성화
      // final accessToken = await _tokenStorage.getAccessToken();
      // if (accessToken != null) {
      //   final response = await _checkFavoriteService.checkFavorite(
      //     accessToken: accessToken,
      //     flowerId: int.parse(flowerId),
      //   );
      //   
      //   if (response.success) {
      //     _isFavorite = response.isFavorite ?? false;
      //     notifyListeners();
      //   }
      // }
    } catch (e) {
      if (kDebugMode) debugPrint('좋아요 상태 확인 오류: $e');
    }
  }

  // 좋아요 토글
  Future<void> toggleFavorite() async {
    if (kDebugMode) debugPrint('좋아요 토글 시작: isFavorite=$_isFavorite');
    
    if (_flower == null) {
      if (kDebugMode) debugPrint('꽃 정보가 없음');
      return;
    }
    
    try {
      // 상태 토글
      final newFavoriteStatus = !_isFavorite;
      
      // SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      List<Flower> likedFlowers = [];
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        likedFlowers = jsonList.map((json) => Flower.fromJson(json)).toList();
      }
      
      if (newFavoriteStatus) {
        // 좋아요 추가
        if (!likedFlowers.any((f) => f.id == _flower!.id)) {
          likedFlowers.add(_flower!);
          if (kDebugMode) debugPrint('보관함에 추가: ${_flower!.koreanName}');
        }
      } else {
        // 좋아요 제거
        likedFlowers.removeWhere((f) => f.id == _flower!.id);
        if (kDebugMode) debugPrint('보관함에서 제거: ${_flower!.koreanName}');
        
        // "관심있는 꽃"에서도 제거
        final viewHistoryString = prefs.getString(_viewHistoryKey);
        if (viewHistoryString != null) {
          final List<dynamic> viewHistoryList = jsonDecode(viewHistoryString);
          List<Flower> viewHistory = viewHistoryList.map((json) => Flower.fromJson(json)).toList();
          viewHistory.removeWhere((f) => f.id == _flower!.id);
          
          final updatedViewHistoryString = jsonEncode(
            viewHistory.map((f) => f.toJson()).toList(),
          );
          await prefs.setString(_viewHistoryKey, updatedViewHistoryString);
          if (kDebugMode) debugPrint('"관심있는 꽃"에서도 제거: ${_flower!.koreanName}');
        }
      }
      
      // 저장
      final updatedJsonString = jsonEncode(
        likedFlowers.map((f) => f.toJson()).toList(),
      );
      await prefs.setString(_storageKey, updatedJsonString);
      
      // UI 업데이트
      _isFavorite = newFavoriteStatus;
      notifyListeners();
      
      if (kDebugMode) debugPrint('좋아요 상태 저장 완료: $_isFavorite');
      
      // TODO: 로그인 구현 후 API 호출 활성화
      // final accessToken = await _tokenStorage.getAccessToken();
      // if (accessToken != null) {
      //   if (_isFavorite) {
      //     await _addFavoriteService.addFavorite(
      //       accessToken: accessToken,
      //       flowerId: int.parse(flowerId),
      //     );
      //   } else {
      //     await _deleteFavoriteService.deleteFavorite(
      //       accessToken: accessToken,
      //       flowerId: int.parse(flowerId),
      //     );
      //   }
      // }
    } catch (e) {
      if (kDebugMode) debugPrint('좋아요 토글 오류: $e');
      _errorMessage = '저장 중 오류가 발생했습니다.';
      notifyListeners();
    }
  }
  
  // 외부에서 좋아요 상태 강제 새로고침 (보관함에서 삭제 시 호출용)
  Future<void> refreshFavoriteStatus() async {
    await _checkFavorite();
  }

  // 새로고침
  Future<void> refresh() async {
    await loadFlowerDetail();
  }
}
