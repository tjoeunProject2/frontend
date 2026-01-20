import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/storage_vm.dart';
import 'storageHeader.dart';
import 'storageFilterTab.dart';
import 'storageCard.dart';

class StorageView extends ConsumerStatefulWidget {
  const StorageView({super.key});

  @override
  ConsumerState<StorageView> createState() => _StorageViewState();
}

class _StorageViewState extends ConsumerState<StorageView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storageViewModelProvider);
    const purpleTheme = Color(0xFF9E7AFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 1. 검색 모드에 따라 헤더 또는 검색창 표시
            viewModel.isSearching
                ? _buildSearchBar(viewModel, purpleTheme)
            : StorageHeader(
              title: '나의 꽃 보관함',
              subtitle: '소중하게 간직한 당신의 꽃 이야기',
              primaryColor: purpleTheme,
              onSearchTap: () => viewModel.toggleSearch(),
            ),

            // 2. 탭 위젯
            StorageFilterTabs(
              tabs: const ['전체 꽃', '저장한 꽃', '관심있는 꽃'],
              selectedIndex: viewModel.selectedTabIndex,
              onTabSelected: (index) => viewModel.setTab(index),
              primaryColor: purpleTheme,
            ),

            const SizedBox(height: 20),

            // 3. 그리드 영역
            Expanded(
              child: viewModel.filteredFlowers.isEmpty
                ? const Center(child: Text("보관함에 해당하는 꽃이 없습니다."))
                : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: viewModel.filteredFlowers.length,
                itemBuilder: (context, index) {
                  final flower = viewModel.filteredFlowers[index];

                  return FlowerStorageCard(
                    flower: flower,
                    primaryColor: purpleTheme,
                    onFavoriteToggle: () {
                      // 좋아요는 liked_flowers_vm에서 처리
                      // TODO: liked_flowers_vm 연결 필요
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//  검색바 위젯 정의
Widget _buildSearchBar(StorageViewModel viewModel, Color purpleTheme) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: TextField(
        autofocus: true,
        onChanged: (value) => viewModel.updateSearchQuery(value),
        decoration: InputDecoration(
          hintText: '꽃 이름이나 꽃말을 검색하세요',
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(Icons.search, color: purpleTheme),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => viewModel.toggleSearch(),
          ),
        ),
      ),
    ),
  );
}
