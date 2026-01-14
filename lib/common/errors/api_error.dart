class ApiError implements Exception {
  final int? statusCode;
  final String message;
  final bool success;

  ApiError({
    this.statusCode,
    required this.message,
    this.success = false,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    final statusCode = json['status'] as int?;
    final message = json['message'] as String?;
    
    return ApiError(
      statusCode: statusCode,
      message: message ?? _getDefaultMessage(statusCode),
      success: json['success'] as bool? ?? false,
    );
  }

  static String _getDefaultMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다. 입력값을 확인해주세요.';
      case 401:
        return '로그인이 필요하거나 토큰이 만료되었습니다.';
      case 403:
        return '접근 권한이 없습니다.';
      case 404:
        return '요청한 데이터를 찾을 수 없습니다.';
      case 409:
        return '중복된 데이터가 존재합니다.';
      case 422:
        return '입력값 검증에 실패했습니다.';
      case 429:
        return '너무 많은 요청을 보냈습니다. 잠시 후 다시 시도해주세요.';
      case 500:
        return '서버 내부 오류가 발생했습니다.';
      case 502:
        return '게이트웨이 오류가 발생했습니다.';
      case 503:
        return '서버를 일시적으로 사용할 수 없습니다.';
      case 504:
        return '서버 응답 시간이 초과되었습니다.';
      default:
        return '네트워크 오류가 발생했습니다. 연결 상태를 확인해주세요.';
    }
  }

  @override
  String toString() => message;

  // 에러 타입별 분류
  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isBadRequest => statusCode == 400;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isValidationError => statusCode == 422;
  bool get isTooManyRequests => statusCode == 429;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isNetworkError => statusCode == null;
}
