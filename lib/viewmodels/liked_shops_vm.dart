import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flower_shop.dart';

final likedShopsViewModelProvider =
    ChangeNotifierProvider<LikedShopsViewModel>((ref) {
  return LikedShopsViewModel();
});

class LikedShopsViewModel extends ChangeNotifier {
  final List<FlowerShop> _likedShops = [];

  List<FlowerShop> get likedShops => List.unmodifiable(_likedShops);

  // 좋아요 토글
  void toggleLike(FlowerShop shop) {
    final index = _likedShops.indexWhere((s) => s.id == shop.id);
    
    if (index >= 0) {
      // 이미 좋아요한 가게면 제거
      _likedShops.removeAt(index);
      print('좋아요 취소: ${shop.name}');
    } else {
      // 좋아요 추가
      _likedShops.add(shop.copyWith(isLiked: true));
      print('좋아요 추가: ${shop.name}');
    }
    
    notifyListeners();
    // TODO: API 호출하여 서버에 저장
  }

  // 좋아요 상태 확인
  bool isLiked(String shopId) {
    return _likedShops.any((shop) => shop.id == shopId);
  }

  // 좋아요 제거
  void removeLike(String shopId) {
    _likedShops.removeWhere((shop) => shop.id == shopId);
    notifyListeners();
    print('좋아요 제거: $shopId');
    // TODO: API 호출하여 서버에서 제거
  }

  // 좋아요 개수
  int get likedCount => _likedShops.length;
}
