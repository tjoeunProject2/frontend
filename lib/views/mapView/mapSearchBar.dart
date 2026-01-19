import 'package:flutter/material.dart';

/// 지도 상단 검색바 위젯
class MapSearchBar extends StatelessWidget {
  final bool isLoading;
  final int shopCount;

  const MapSearchBar({
    super.key,
    required this.isLoading,
    required this.shopCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isLoading ? '주변 꽃집 검색 중...' : '주변 꽃집 $shopCount개',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
