import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth/findEmailService.dart';

final findEmailViewModelProvider = ChangeNotifierProvider<FindEmailViewModel>((ref) {
  return FindEmailViewModel();
});

class FindEmailViewModel extends ChangeNotifier {
  final _findEmailService = FindEmailService();

  final nameController = TextEditingController();
  final birthController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;
  String? foundEmail;

  bool get isFormValid {
    return nameController.text.isNotEmpty && birthController.text.length == 8;
  }

  Future<void> findEmail() async {
    if (!isFormValid) return;

    isLoading = true;
    errorMessage = null;
    foundEmail = null;
    notifyListeners();

    final response = await _findEmailService.findEmail(
      userName: nameController.text.trim(),
      userBirth: birthController.text,
    );

    isLoading = false;

    if (response.success && response.email != null) {
      foundEmail = response.email;
    } else {
      errorMessage = response.message ?? '이메일을 찾을 수 없습니다.';
    }

    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    super.dispose();
  }
}
