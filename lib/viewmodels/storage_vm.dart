import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/flower.dart';
import '../services/viewHistory/getViewHistoryService.dart';
import '../services/viewHistory/deleteViewHistoryService.dart';
import '../services/viewHistory/deleteAllViewHistoryService.dart';
import '../services/favorites/getFavoritesService.dart';
import '../services/storage/token_storage.dart';

// ViewModel
class StorageViewModel extends ChangeNotifier {
  static const String _storageKey = 'liked_flowers';
  static const String _viewHistoryKey = 'view_history_flowers';
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
    List<Flower> list;
    
    // 탭에 따라 리스트 선택
    if (selectedTabIndex == 0) {
      // 저장한 꽃: 즐겨찾기만
      list = _favorites;
    } else {
      // 관심있는 꽃: 조회 기록
      list = _viewHistory;
    }

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
      // SharedPreferences에서 읽기
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_viewHistoryKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _viewHistory = jsonList.map((json) => Flower.fromJson(json)).toList();
        if (kDebugMode) debugPrint('관심있는 꽃에서 로드: ${_viewHistory.length}개');
      } else {
        _viewHistory = [];
        if (kDebugMode) debugPrint('관심있는 꽃 비어있음');
      }
      
      // TODO: 로그인 구현 후 API 호출 활성화
      // final accessToken = await _tokenStorage.getAccessToken();
      // if (accessToken == null) {
      //   _errorMessage = '로그인이 필요합니다.';
      //   _isLoading = false;
      //   notifyListeners();
      //   return;
      // }

      // final response = await _viewHistoryService.getViewHistory(accessToken);
      // 
      // if (response.success && response.viewHistory != null) {
      //   // ViewHistory를 Flower로 변환
      //   _viewHistory = response.viewHistory!.map((vh) => Flower(
      //     id: vh.flowerId.toString(),
      //     name: vh.flowerName,
      //     koreanName: vh.flowerName,
      //     season: '',
      //     occasion: '',
      //     tag: '',
      //     imageUrl: vh.imageUrl,
      //     description: '',
      //   )).toList();
      // } else {
      //   _errorMessage = response.message ?? '조회 기록을 불러올 수 없습니다.';
      // }
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
      // SharedPreferences에서 읽기
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _favorites = jsonList.map((json) => Flower.fromJson(json)).toList();
        if (kDebugMode) debugPrint('보관함에서 로드: ${_favorites.length}개');
      } else {
        _favorites = [];
        if (kDebugMode) debugPrint('보관함 비어있음');
      }
      
      // TODO: 로그인 구현 후 API 호출 활성화
      // final accessToken = await _tokenStorage.getAccessToken();
      // if (accessToken != null) {
      //   final response = await _favoritesService.getFavorites(accessToken);
      //   if (response.success && response.favorites != null) {
      //     _favorites = response.favorites!.map((fav) => Flower(
      //       id: fav.flowerId.toString(),
      //       name: fav.flowerName,
      //       koreanName: fav.flowerName,
      //       season: '',
      //       occasion: '',
      //       tag: '',
      //       imageUrl: fav.imageUrl,
      //       description: '',
      //     )).toList();
      //   }
      // }
    } catch (e) {
      if (kDebugMode) debugPrint('즐겨찾기 로드 오류: $e');
      _errorMessage = '저장소를 불러올 수 없습니다.';
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
      loadFavorites();
    } else if (index == 1) {
      loadViewHistory();
    }
  }

  // 초기 데이터 로드
  Future<void> initialize() async {
    await loadViewHistory();
  }

  // 즐겨찾기에서 삭제
  Future<void> deleteFavorite(Flower flower) async {
    try {
      // favorites에서 제거
      _favorites.removeWhere((f) => f.id == flower.id);
      
      // viewHistory에서도 제거 (관심있는 꽃에서도 사라지게)
      _viewHistory.removeWhere((f) => f.id == flower.id);
      
      // SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      final updatedJsonString = jsonEncode(
        _favorites.map((f) => f.toJson()).toList(),
      );
      await prefs.setString(_storageKey, updatedJsonString);
      
      if (kDebugMode) debugPrint('즐겨찾기에서 삭제: ${flower.koreanName}');
      
      // TODO: 로그인 구현 후 API 호출 활성화
      // final accessToken = await _tokenStorage.getAccessToken();
      // if (accessToken != null) {
      //   await deleteFavoriteService.deleteFavorite(accessToken, flower.id);
      // }
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('즐겨찾기 삭제 오류: $e');
    }
  }

  // 저장한 꽃을 관심있는 꽃에도 추가 (저장한 꽃은 유지)
  Future<void> toggleLikeStatus(Flower flower) async {
    try {
      // 현재 상태의 반대로 변경
      final newLikedStatus = !flower.isLiked;
      
      // isLiked를 토글한 새 Flower 객체 생성
      final updatedFlower = Flower(
        id: flower.id,
        name: flower.name,
        koreanName: flower.koreanName,
        season: flower.season,
        occasion: flower.occasion,
        tag: flower.tag,
        imageUrl: flower.imageUrl,
        description: flower.description,
        isLiked: newLikedStatus,
      );
      
      // SharedPreferences 가져오기
      final prefs = await SharedPreferences.getInstance();
      
      // "저장한 꽃" 탭(index 0)에서만 favorites 업데이트
      if (selectedTabIndex == 0) {
        // favorites에서 업데이트
        final index = _favorites.indexWhere((f) => f.id == flower.id);
        if (index != -1) {
          _favorites[index] = updatedFlower;
          
          // SharedPreferences에 저장
          final updatedJsonString = jsonEncode(
            _favorites.map((f) => f.toJson()).toList(),
          );
          await prefs.setString(_storageKey, updatedJsonString);
        }
        
        // viewHistory에서도 업데이트 또는 추가/제거
        final viewIndex = _viewHistory.indexWhere((f) => f.id == flower.id);
        if (newLikedStatus) {
          // 하트 활성화: viewHistory에 추가
          if (viewIndex == -1) {
            _viewHistory.insert(0, updatedFlower);
            if (kDebugMode) debugPrint('"관심있는 꽃"에 추가: ${flower.koreanName}');
          } else {
            _viewHistory[viewIndex] = updatedFlower;
          }
        } else {
          // 하트 비활성화: viewHistory에서 제거
          if (viewIndex != -1) {
            _viewHistory.removeAt(viewIndex);
            if (kDebugMode) debugPrint('"관심있는 꽃"에서 제거: ${flower.koreanName}');
          }
        }
        
        // viewHistory를 SharedPreferences에 저장
        final viewHistoryJsonString = jsonEncode(
          _viewHistory.map((f) => f.toJson()).toList(),
        );
        await prefs.setString(_viewHistoryKey, viewHistoryJsonString);
      } else {
        // "관심있는 꽃" 탭(index 1)에서는 viewHistory만 제거
        _viewHistory.removeWhere((f) => f.id == flower.id);
        if (kDebugMode) debugPrint('"관심있는 꽃"에서 제거: ${flower.koreanName}');
        
        // viewHistory를 SharedPreferences에 저장
        final viewHistoryJsonString = jsonEncode(
          _viewHistory.map((f) => f.toJson()).toList(),
        );
        await prefs.setString(_viewHistoryKey, viewHistoryJsonString);
      }
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) debugPrint('좋아요 토글 오류: $e');
    }
  }
}

final storageViewModelProvider = ChangeNotifierProvider<StorageViewModel>((ref) => StorageViewModel());