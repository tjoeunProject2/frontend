import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flowerShop.dart';
import '../services/storage/token_storage.dart';

final likedShopsViewModelProvider =
    ChangeNotifierProvider<LikedShopsViewModel>((ref) {
  final vm = LikedShopsViewModel();
  vm.loadLikedShops();
  return vm;
});

class LikedShopsViewModel extends ChangeNotifier {
  static const String _storageKey = 'liked_shops';
  final _tokenStorage = TokenStorage();
  
  final List<FlowerShop> _likedShops = [];

  List<FlowerShop> get likedShops => List.unmodifiable(_likedShops);

  // SharedPreferences에서 데이터 로드
  Future<void> loadLikedShops() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _likedShops.clear();
        _likedShops.addAll(
          jsonList.map((json) => FlowerShop.fromJson(json)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('꽃집 좋아요 로드 오류: $e');
    }
  }

  // SharedPreferences에 데이터 저장
  Future<void> _saveLikedShops() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(
        _likedShops.map((shop) => shop.toJson()).toList(),
      );
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      if (kDebugMode) debugPrint('꽃집 좋아요 저장 오류: $e');
    }
  }

  // 좋아요 토글
  Future<void> toggleLike(FlowerShop shop) async {
    final index = _likedShops.indexWhere((s) => s.id == shop.id);
    
    if (index >= 0) {
      // 이미 좋아요한 꽃집이면 제거
      _likedShops.removeAt(index);
      if (kDebugMode) debugPrint('좋아요 취소: ${shop.name}');
    } else {
      // 좋아요 추가
      _likedShops.add(shop.copyWith(isLiked: true));
      if (kDebugMode) debugPrint('좋아요 추가: ${shop.name}');
    }
    
    notifyListeners();
    await _saveLikedShops();
  }

  // 좋아요 상태 확인
  bool isLiked(String shopId) {
    return _likedShops.any((shop) => shop.id == shopId);
  }

  // 좋아요 제거
  Future<void> removeLike(String shopId) async {
    _likedShops.removeWhere((shop) => shop.id == shopId);
    notifyListeners();
    if (kDebugMode) debugPrint('좋아요 제거: $shopId');
    await _saveLikedShops();
  }

  // 좋아요 개수
  int get likedCount => _likedShops.length;
}
