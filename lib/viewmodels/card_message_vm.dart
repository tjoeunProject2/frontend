import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cards/generateCardMessageService.dart';
import '../services/storage/token_storage.dart';

final cardMessageViewModelProvider = ChangeNotifierProvider<CardMessageViewModel>((ref) {
  return CardMessageViewModel();
});

class CardMessageViewModel extends ChangeNotifier {
  final _generateCardService = GenerateCardMessageService();
  final _tokenStorage = TokenStorage();

  String? _generatedMessage;
  bool _isLoading = false;
  String? _errorMessage;

  String? get generatedMessage => _generatedMessage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // AI 카드 메시지 생성
  Future<void> generateCardMessage({
    required String flowerName,
    required List<String> floriography,
    required String query,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _generatedMessage = null;
    notifyListeners();

    try {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null) {
        _errorMessage = '로그인이 필요합니다.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      final response = await _generateCardService.generateCardMessage(
        accessToken: accessToken,
        flowerName: flowerName,
        floriography: floriography,
        query: query,
      );
      
      if (response.success && response.message != null) {
        _generatedMessage = response.message;
      } else {
        _errorMessage = response.message ?? '메시지 생성에 실패했습니다.';
      }
    } catch (e) {
      if (kDebugMode) debugPrint('카드 메시지 생성 오류: $e');
      _errorMessage = '네트워크 오류가 발생했습니다.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // 메시지 초기화
  void clearMessage() {
    _generatedMessage = null;
    _errorMessage = null;
    notifyListeners();
  }

  // 메시지 복사
  String? copyMessage() {
    return _generatedMessage;
  }
}
