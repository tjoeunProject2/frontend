import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flower.dart';
import '../services/flowers/getAllFlowersService.dart';
import '../services/storage/token_storage.dart';

final allFlowersViewModelProvider = ChangeNotifierProvider<AllFlowersViewModel>((ref) {
  return AllFlowersViewModel();
});

class AllFlowersViewModel extends ChangeNotifier {
  final _allFlowersService = GetAllFlowersService();
  final _tokenStorage = TokenStorage();

  List<Flower> _flowers = [];
  List<Flower> _filteredFlowers = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedSeason;
  String? _selectedOccasion;

  List<Flower> get flowers => _filteredFlowers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get selectedSeason => _selectedSeason;
  String? get selectedOccasion => _selectedOccasion;

  // 모든 꽃 불러오기
  Future<void> loadAllFlowers() async {
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

      final response = await _allFlowersService.getAllFlowers(accessToken);
      
      if (response.success && response.flowers != null) {
        _flowers = response.flowers!;
        _applyFilters();
      } else {
        _errorMessage = response.message ?? '꽃 목록을 불러올 수 없습니다.';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('전체 꽃 목록 로드 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 검색어로 필터링
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // 계절로 필터링
  void setSeasonFilter(String? season) {
    _selectedSeason = season;
    _applyFilters();
  }

  // 상황으로 필터링
  void setOccasionFilter(String? occasion) {
    _selectedOccasion = occasion;
    _applyFilters();
  }

  // 필터 초기화
  void clearFilters() {
    _searchQuery = '';
    _selectedSeason = null;
    _selectedOccasion = null;
    _applyFilters();
  }

  // 필터 적용
  void _applyFilters() {
    _filteredFlowers = _flowers.where((flower) {
      // 검색어 필터
      if (_searchQuery.isNotEmpty) {
        final matchesSearch = flower.koreanName.contains(_searchQuery) ||
            flower.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (flower.description?.contains(_searchQuery) ?? false);
        if (!matchesSearch) return false;
      }

      // 계절 필터
      if (_selectedSeason != null && flower.season != _selectedSeason) {
        return false;
      }

      // 상황 필터
      if (_selectedOccasion != null && flower.occasion != _selectedOccasion) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  // 초기화
  Future<void> initialize() async {
    await loadAllFlowers();
  }
}
