import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flower.dart';
import '../services/viewHistory/getViewHistoryService.dart';
import '../services/viewHistory/deleteViewHistoryService.dart';
import '../services/viewHistory/deleteAllViewHistoryService.dart';
import '../services/favorites/getFavoritesService.dart';
import '../services/storage/token_storage.dart';

// ViewModel
class StorageViewModel extends ChangeNotifier {
  final _viewHistoryService = GetViewHistoryService();
  final _deleteViewHistoryService = DeleteViewHistoryService();
  final _deleteAllViewHistoryService = DeleteAllViewHistoryService();
  final _favoritesService = GetFavoritesService();
  final _tokenStorage = TokenStorage();

  int selectedTabIndex = 0;

  // 검색 관련 상태
  bool isSearching = false;
  String searchQuery = "";

  // 데이터
  List<Flower> _viewHistory = [];
  List<Flower> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Flower> get viewHistory => _viewHistory;
  List<Flower> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 탭 + 검색어 필터링된 리스트 getter
  List<Flower> get filteredFlowers {
    List<Flower> list = selectedTabIndex == 1 ? _favorites : _viewHistory;

    // 검색어 필터링
    if (searchQuery.isNotEmpty) {
      list = list.where((f) =>
        f.koreanName.contains(searchQuery) || 
        (f.description?.contains(searchQuery) ?? false)
      ).toList();
    }
    return list;
  }

  // 조회 기록 불러오기
  Future<void> loadViewHistory() async {
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

      final response = await _viewHistoryService.getViewHistory(accessToken);
      
      if (response.success && response.viewHistory != null) {
        // ViewHistory를 Flower로 변환
        _viewHistory = response.viewHistory!.map((vh) => Flower(
          id: vh.flowerId.toString(),
          name: vh.flowerName,
          koreanName: vh.flowerName,
          season: '',
          occasion: '',
          tag: '',
          imageUrl: vh.imageUrl,
          description: '',
        )).toList();
      } else {
        _errorMessage = response.message ?? '조회 기록을 불러올 수 없습니다.';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('조회 기록 로드 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 즐겨찾기 불러오기
  Future<void> loadFavorites() async {
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

      final response = await _favoritesService.getFavorites(accessToken);
      
      if (response.success && response.favorites != null) {
        // Favorite를 Flower로 변환
        _favorites = response.favorites!.map((fav) => Flower(
          id: fav.flowerId.toString(),
          name: fav.flowerName,
          koreanName: fav.flowerName,
          season: '',
          occasion: '',
          tag: fav.floriography.join(', '),
          imageUrl: fav.imageUrl,
          description: fav.floriography.join(', '),
        )).toList();
      } else {
        _errorMessage = response.message ?? '즐겨찾기를 불러올 수 없습니다.';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('즐겨찾기 로드 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 조회 기록 삭제
  Future<void> deleteViewHistory(String viewId) async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) return;

      final response = await _deleteViewHistoryService.deleteViewHistory(
        accessToken: accessToken,
        viewId: int.parse(viewId),
      );

      if (response.success) {
        _viewHistory.removeWhere((f) => f.id == viewId);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('조회 기록 삭제 오류: $e');
    }
  }

  // 모든 조회 기록 삭제
  Future<void> deleteAllViewHistory() async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) return;

      final response = await _deleteAllViewHistoryService.deleteAllViewHistory(accessToken);

      if (response.success) {
        _viewHistory.clear();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('전체 조회 기록 삭제 오류: $e');
    }
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
    
    // 탭 변경 시 데이터 로드
    if (index == 0) {
      loadViewHistory();
    } else if (index == 1) {
      loadFavorites();
    }
  }

  // 초기 데이터 로드
  Future<void> initialize() async {
    await loadViewHistory();
  }
}

final storageViewModelProvider = ChangeNotifierProvider<StorageViewModel>((ref) => StorageViewModel());