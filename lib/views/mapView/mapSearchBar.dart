import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/map_vm.dart';

/// 지도 상단 검색바 위젯
class MapSearchBar extends ConsumerStatefulWidget {
  final bool isLoading;
  final int shopCount;

  const MapSearchBar({
    super.key,
    required this.isLoading,
    required this.shopCount,
  });

  @override
  ConsumerState<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends ConsumerState<MapSearchBar> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String keyword) {
    if (keyword.trim().isEmpty) return;

    _focusNode.unfocus();
    ref.read(mapViewModelProvider).searchShopsByKeyword(keyword.trim());
  }

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
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: widget.isLoading
                    ? '주변 꽃집 검색 중...'
                    : '꽃집 검색 (주변 ${widget.shopCount}개)',
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16),
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearchSubmitted,
              onTap: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                _searchController.clear();
                ref.read(mapViewModelProvider).clearSearch();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
