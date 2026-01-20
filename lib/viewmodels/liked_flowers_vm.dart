import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flower.dart';
import '../services/favorites/addFavoriteService.dart';
import '../services/favorites/deleteFavoriteService.dart';
import '../services/favorites/checkFavoriteService.dart';
import '../services/storage/token_storage.dart';

final likedFlowersViewModelProvider =
    ChangeNotifierProvider<LikedFlowersViewModel>((ref) {
  final vm = LikedFlowersViewModel();
  vm.loadLikedFlowers();
  return vm;
});

class LikedFlowersViewModel extends ChangeNotifier {
  static const String _storageKey = 'liked_flowers';
  final _addFavoriteService = AddFavoriteService();
  final _deleteFavoriteService = DeleteFavoriteService();
  final _checkFavoriteService = CheckFavoriteService();
  final _tokenStorage = TokenStorage();
  
  final List<Flower> _likedFlowers = [];

  List<Flower> get likedFlowers => List.unmodifiable(_likedFlowers);

  // SharedPreferences에서 데이터 로드
  Future<void> loadLikedFlowers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _likedFlowers.clear();
        _likedFlowers.addAll(
          jsonList.map((json) => Flower.fromJson(json)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('좋아요 로드 오류: $e');
    }
  }

  // SharedPreferences에 데이터 저장
  Future<void> _saveLikedFlowers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(
        _likedFlowers.map((flower) => flower.toJson()).toList(),
      );
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      if (kDebugMode) debugPrint('좋아요 저장 오류: $e');
    }
  }

  // 좋아요 토글
  Future<void> toggleLike(Flower flower) async {
    final index = _likedFlowers.indexWhere((f) => f.id == flower.id);
    
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      
      if (index >= 0) {
        // 이미 좋아요한 꽃이면 제거
        _likedFlowers.removeAt(index);
        if (kDebugMode) debugPrint('좋아요 취소: ${flower.koreanName}');
        
        // 서버에 삭제 요청
        if (accessToken != null) {
          await _deleteFavoriteService.deleteFavorite(
            accessToken: accessToken,
            flowerId: int.parse(flower.id),
          );
        }
      } else {
        // 좋아요 추가
        _likedFlowers.add(flower.copyWith(isLiked: true));
        if (kDebugMode) debugPrint('좋아요 추가: ${flower.koreanName}');
        
        // 서버에 추가 요청
        if (accessToken != null) {
          await _addFavoriteService.addFavorite(
            accessToken: accessToken,
            flowerId: int.parse(flower.id),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) debugPrint('좋아요 API 오류: $e');
    }
    
    notifyListeners();
    await _saveLikedFlowers();
  }

  // 좋아요 상태 확인 (로컬)
  bool isLiked(String flowerId) {
    return _likedFlowers.any((flower) => flower.id == flowerId);
  }

  // 좋아요 상태 확인 (서버)
  Future<bool> checkLikedFromServer(String flowerId) async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) return false;

      final response = await _checkFavoriteService.checkFavorite(
        accessToken: accessToken,
        flowerId: int.parse(flowerId),
      );
      
      return response.success && (response.isFavorite ?? false);
    } catch (e) {
      if (kDebugMode) debugPrint('좋아요 확인 오류: $e');
      return false;
    }
  }

  // 좋아요 제거
  Future<void> removeLike(String flowerId) async {
    _likedFlowers.removeWhere((flower) => flower.id == flowerId);
    notifyListeners();
    if (kDebugMode) debugPrint('좋아요 제거: $flowerId');
    await _saveLikedFlowers();
  }

  // 좋아요 개수
  int get likedCount => _likedFlowers.length;

  // 계절별 필터
  List<Flower> getFlowersBySeason(String season) {
    return _likedFlowers.where((f) => f.season == season).toList();
  }

  // 상황별 필터
  List<Flower> getFlowersByOccasion(String occasion) {
    return _likedFlowers.where((f) => f.occasion == occasion).toList();
  }
}
