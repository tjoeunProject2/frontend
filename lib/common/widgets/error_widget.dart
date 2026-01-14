import 'package:flutter/material.dart';
import '../errors/api_error.dart';

class AppErrorWidget extends StatelessWidget {
  final ApiError error;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _getErrorTitle(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getErrorIcon() {
    if (error.isUnauthorized) {
      return Icons.lock_outline;
    } else if (error.isForbidden) {
      return Icons.block;
    } else if (error.isNotFound) {
      return Icons.search_off;
    } else if (error.isConflict) {
      return Icons.content_copy;
    } else if (error.isValidationError) {
      return Icons.error_outline;
    } else if (error.isTooManyRequests) {
      return Icons.speed;
    } else if (error.isServerError) {
      return Icons.cloud_off;
    } else if (error.isNetworkError) {
      return Icons.wifi_off;
    } else {
      return Icons.error_outline;
    }
  }

  String _getErrorTitle() {
    if (error.isUnauthorized) {
      return '인증이 필요합니다';
    } else if (error.isForbidden) {
      return '접근 권한이 없습니다';
    } else if (error.isNotFound) {
      return '데이터를 찾을 수 없습니다';
    } else if (error.isConflict) {
      return '중복된 데이터가 있습니다';
    } else if (error.isValidationError) {
      return '입력값을 확인해주세요';
    } else if (error.isTooManyRequests) {
      return '요청이 너무 많습니다';
    } else if (error.isServerError) {
      return '서버 오류가 발생했습니다';
    } else if (error.isNetworkError) {
      return '네트워크 연결을 확인해주세요';
    } else {
      return '오류가 발생했습니다';
    }
  }
}

// 스낵바용 에러 표시
class ErrorSnackBar {
  static void show(BuildContext context, ApiError error) {
    IconData icon;
    Color backgroundColor;

    if (error.isUnauthorized) {
      icon = Icons.lock_outline;
      backgroundColor = Colors.orange[700]!;
    } else if (error.isForbidden) {
      icon = Icons.block;
      backgroundColor = Colors.red[700]!;
    } else if (error.isServerError) {
      icon = Icons.cloud_off;
      backgroundColor = Colors.red[800]!;
    } else if (error.isNetworkError) {
      icon = Icons.wifi_off;
      backgroundColor = Colors.grey[700]!;
    } else if (error.isTooManyRequests) {
      icon = Icons.speed;
      backgroundColor = Colors.amber[700]!;
    } else if (error.isValidationError || error.isBadRequest) {
      icon = Icons.error_outline;
      backgroundColor = Colors.orange[600]!;
    } else {
      icon = Icons.info_outline;
      backgroundColor = Colors.blue[700]!;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(error.message),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
