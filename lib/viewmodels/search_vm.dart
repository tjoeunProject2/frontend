import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/flower.dart';
import '../services/flowers/searchFlowerByNameService.dart';
import '../services/flowers/searchFlowerByKeywordService.dart';
import '../services/search/semanticSearchService.dart';
import '../services/search/getRecentSearchService.dart';
import '../services/search/deleteSearchService.dart';
import '../services/search/deleteAllSearchService.dart';
import '../services/storage/token_storage.dart';

final searchViewModelProvider = ChangeNotifierProvider<SearchViewModel>((ref) {
  return SearchViewModel();
});

class SearchViewModel extends ChangeNotifier {
  final _searchByNameService = SearchFlowerByNameService();
  final _searchByKeywordService = SearchFlowerByKeywordService();
  final _semanticSearchService = SemanticSearchService();
  final _recentSearchService = GetRecentSearchService();
  final _deleteSearchService = DeleteSearchService();
  final _deleteAllSearchService = DeleteAllSearchService();
  final _tokenStorage = TokenStorage();

  final TextEditingController searchController = TextEditingController();

  List<Flower> _searchResults = [];
  List<String> _recentSearches = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchMode = 'name'; // 'name', 'keyword', 'semantic'

  List<Flower> get searchResults => _searchResults;
  List<String> get recentSearches => _recentSearches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchMode => _searchMode;

  // 최근 검색어 불러오기
  Future<void> loadRecentSearches() async {
    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) return;

      final response = await _recentSearchService.getRecentSearch(accessToken);
      
      if (response.success && response.recentSearches != null) {
        _recentSearches = response.recentSearches!;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('최근 검색어 로드 오류: $e');
    }
  }

  // 이름으로 검색
  Future<void> searchByName(String query) async {
    if (query.trim().isEmpty) return;

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

      final response = await _searchByNameService.searchFlowerByName(
        accessToken: accessToken,
        name: query,
      );
      
      if (response.success && response.flowers != null) {
        _searchResults = response.flowers!;
      } else {
        _errorMessage = response.message ?? '검색 결과가 없습니다.';
        _searchResults = [];
      }
    } catch (e) {
      if (kDebugMode) debugPrint('검색 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // 키워드로 검색
  Future<void> searchByKeyword(String query) async {
    if (query.trim().isEmpty) return;

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

      final response = await _searchByKeywordService.searchFlowerByKeyword(
        accessToken: accessToken,
        keyword: query,
      );
      
      if (response.success && response.flowers != null) {
        _searchResults = response.flowers!;
      } else {
        _errorMessage = response.message ?? '검색 결과가 없습니다.';
        _searchResults = [];
      }
    } catch (e) {
      if (kDebugMode) debugPrint('검색 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // 시맨틱 검색
  Future<void> semanticSearch(String query) async {
    if (query.trim().isEmpty) return;

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

      // 시맨틱 검색은 임베딩 벡터를 반환하므로
      // 실제 구현 시 벡터 기반 검색 로직이 필요합니다.
      // 임시로 키워드 검색 사용
      await searchByKeyword(query);
      
    } catch (e) {
      if (kDebugMode) debugPrint('검색 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
      _searchResults = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // 검색 실행 (모드에 따라)
  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    // UI 즉시 반영 (중복 제거 후 맨 위로 추가)
    _recentSearches.remove(query);
    _recentSearches.insert(0, query);
    notifyListeners();

    try {
      // 검색 실행
      switch (_searchMode) {
        case 'keyword':
          await searchByKeyword(query);
          break;
        case 'semantic':
          await semanticSearch(query);
          break;
        default:
          await searchByName(query);
      }
    } catch(e) {
      if (kDebugMode) debugPrint('검색 중 오류 발생 : $e');
    }

  }

  // 검색 모드 변경
  void setSearchMode(String mode) {
    _searchMode = mode;
    notifyListeners();
  }

  // 검색어 삭제(로컬 즉시 제거 후 서버 동기화)
  Future<void> deleteSearch(String search) async {
    // 로컬 리스트에서 먼저 제거
    _recentSearches.remove(search);
    notifyListeners();

    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) return;

      // 서버에서 실제 삭제 요청
      final response = await _deleteSearchService.deleteSearch(
        accessToken: accessToken,
        query: search,
      );

      // 서버 응답이 실패한 경우에만 다시 로드하여 UI 복구
      if (response.success) {
        debugPrint('서버 삭제 실패 : ${response.message}');
        await loadRecentSearches();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('검색어 삭제 오류: $e');
      await loadRecentSearches();
    }
  }

  // 검색 결과 초기화
  void clearResults() {
    _searchResults = [];
    _errorMessage = null;
    notifyListeners();
  }

  // 모든 검색 기록 삭제(로컬 즉시 초기화 후 서버 동기화)
  Future<void> deleteAllSearches() async {
    // 로컬 리스트 즉시 비우기
    _recentSearches.clear();
    notifyListeners();

    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) return;

      // 서버에 전체 삭제 요청
      final response = await _deleteAllSearchService.deleteAllSearch(accessToken);

      // 실패 시 복구
      if (!response.success) {
        debugPrint('서버 전체 삭제 실패: ${response.message}');
        await loadRecentSearches();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('전체 검색 기록 삭제 오류: $e');
      await loadRecentSearches();
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
