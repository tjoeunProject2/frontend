import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/bugReport.dart';

final reportBugViewModelProvider =
    ChangeNotifierProvider<ReportBugViewModel>((ref) {
  return ReportBugViewModel();
});

class ReportBugViewModel extends ChangeNotifier {
  final List<String> categories = [
    '버그 신고',
    '기능 개선 제안',
    '사용 문의',
    '기타',
  ];

  String _selectedCategory = '버그 신고';
  bool _isLoading = false;
  String? _errorMessage;

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<bool> submitReport(BugReport report) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // mailto URL 생성
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'yysi00558800@gmail.com',
        queryParameters: {
          'subject': '[${report.category}] ${report.title}',
          'body': report.toEmailBody(),
        },
      );

      // 메일 앱 실행
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = '메일 앱을 열 수 없습니다. 이메일 앱이 설치되어 있는지 확인해주세요.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = '문제 신고 제출에 실패했습니다. 다시 시도해주세요.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
