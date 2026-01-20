import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flower.dart';

final likedFlowersViewModelProvider =
    ChangeNotifierProvider<LikedFlowersViewModel>((ref) {
  return LikedFlowersViewModel();
});

class LikedFlowersViewModel extends ChangeNotifier {
  final List<Flower> _likedFlowers = [];

  List<Flower> get likedFlowers => List.unmodifiable(_likedFlowers);

  // 좋아요 토글
  void toggleLike(Flower flower) {
    final index = _likedFlowers.indexWhere((f) => f.id == flower.id);
    
    if (index >= 0) {
      // 이미 좋아요한 꽃이면 제거
      _likedFlowers.removeAt(index);
      if (kDebugMode) debugPrint('좋아요 취소: ${flower.koreanName}');
    } else {
      // 좋아요 추가
      _likedFlowers.add(flower.copyWith(isLiked: true));
      if (kDebugMode) debugPrint('좋아요 추가: ${flower.koreanName}');
    }
    
    notifyListeners();
    // TODO: API 호출하여 서버에 저장
  }

  // 좋아요 상태 확인
  bool isLiked(String flowerId) {
    return _likedFlowers.any((flower) => flower.id == flowerId);
  }

  // 좋아요 제거
  void removeLike(String flowerId) {
    _likedFlowers.removeWhere((flower) => flower.id == flowerId);
    notifyListeners();
    if (kDebugMode) debugPrint('좋아요 제거: $flowerId');
    // TODO: API 호출하여 서버에서 제거
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
