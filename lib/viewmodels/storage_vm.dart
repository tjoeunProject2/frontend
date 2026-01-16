import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 꽃 데이터 모델
class FlowerItem {
  final String title;
  final String description;
  final String date;
  final String? imageUrl;
  final Color? color; // 이미지가 없을 경우 디자인처럼 그라데이션용
  bool isFavorite; // '좋아요' 상태 (기본값 false)

  FlowerItem({
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
    this.color,
    this.isFavorite = false, // 생성자에서 초기화
  });
}

// ViewModel
class StorageViewModel extends ChangeNotifier {
  int selectedTabIndex = 0;

  // 검색 관련 상태
  bool isSearching = false;
  String searchQuery = "";

  // 더미 데이터
  final List<FlowerItem> flowers = [
    FlowerItem(title: "프리지아", description: "신뢰와 우정", date: "2024.03.15 보관", color: const Color(0xFFFDE68A)),
    FlowerItem(title: "빨간 튤립", description: "사랑의 고백", date: "2024.03.10 보관", imageUrl: "assets/images/tulip.png"),
    FlowerItem(title: "보라 수국", description: "변치 않는 진심", date: "2024.02.28 보관", color: const Color(0xFFEDE9FE)),
    FlowerItem(title: "해바라기", description: "일편단심", date: "2024.02.14 보관", imageUrl: "assets/images/sunflower.png"),
  ];

  // 탭 + 검색어 필터링된 리스트 getter
  List<FlowerItem> get filteredFlowers {
    List<FlowerItem> list = flowers;

    // 탭 필터링
    if (selectedTabIndex == 2) {
      list = list.where((f) => f.isFavorite).toList();
    }

    // 검색어 필터링
    if (searchQuery.isNotEmpty) {
      list = list.where((f) =>
      f.title.contains(searchQuery)|| f.description.contains(searchQuery)
      ).toList();
    }
    return list;
  }

  // 검색 모드 토글
  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) searchQuery = ""; // 검색 끌 때 검색어 초기화
    notifyListeners();
  }

  // 검색어 업데이트
  void updateSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void setTab(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  // 특정 인덱스의 꽃 좋아요 상태를 반전시키는 함수
  void toggleFavorite(int index) {
    flowers[index].isFavorite = !flowers[index].isFavorite;
    notifyListeners();
  }
}

final storageViewModelProvider = ChangeNotifierProvider<StorageViewModel>((ref) => StorageViewModel());