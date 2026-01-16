import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationViewModelProvider = ChangeNotifierProvider<NavigationViewModel>((ref) {
  return NavigationViewModel();
});

class NavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // 홈으로 이동
  void goToHome() => setIndex(0);

  // 지도로 이동
  void goToMap() => setIndex(1);

  // 검색으로 이동
  void goToSearch() => setIndex(2);

  // 보관함으로 이동
  void goToStorage() => setIndex(3);

  // 마이페이지로 이동
  void goToMyPage() => setIndex(4);
}
