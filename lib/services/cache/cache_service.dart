class CacheItem<T> {
  final T data;
  final DateTime expiry;

  CacheItem(this.data, this.expiry);

  bool get isExpired => DateTime.now().isAfter(expiry);
}

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  final Map<String, CacheItem> _cache = {};

  // 데이터 저장
  void set<T>(String key, T data, Duration duration) {
    final expiry = DateTime.now().add(duration);
    _cache[key] = CacheItem<T>(data, expiry);
  }

  // 데이터 가져오기
  T? get<T>(String key) {
    final item = _cache[key];
    if (item == null) return null;
    
    if (item.isExpired) {
      _cache.remove(key);
      return null;
    }
    
    return item.data as T;
  }

  // 특정 키 삭제
  void remove(String key) {
    _cache.remove(key);
  }

  // 모든 캐시 삭제
  void clear() {
    _cache.clear();
  }

  // 만료된 캐시만 삭제
  void clearExpired() {
    _cache.removeWhere((key, item) => item.isExpired);
  }
}
