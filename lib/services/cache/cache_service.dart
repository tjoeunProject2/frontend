class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  final Map<String, CacheItem> _cache = {};

  // 캐시에 데이터 저장
  void set<T>(String key, T data, Duration duration) {
    final expiryTime = DateTime.now().add(duration);
    _cache[key] = CacheItem(data: data, expiryTime: expiryTime);
  }

  // 캐시에서 데이터 가져오기
  T? get<T>(String key) {
    final item = _cache[key];
    if (item == null) return null;

    // 만료 확인
    if (DateTime.now().isAfter(item.expiryTime)) {
      _cache.remove(key);
      return null;
    }

    return item.data as T?;
  }

  // 특정 키 삭제
  void remove(String key) {
    _cache.remove(key);
  }

  // 전체 캐시 삭제
  void clear() {
    _cache.clear();
  }

  // 만료된 항목만 삭제
  void clearExpired() {
    final now = DateTime.now();
    _cache.removeWhere((key, item) => now.isAfter(item.expiryTime));
  }
}

class CacheItem {
  final dynamic data;
  final DateTime expiryTime;

  CacheItem({required this.data, required this.expiryTime});
}
