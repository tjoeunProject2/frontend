import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/app/routes.dart';
// 공통 위젯 임포트
import '../../common/widgets/search_widget.dart';
// 동일 폴더 내 위젯들 임포트
import 'categoryCard.dart';
import 'searchBackground.dart';
import 'searchChips.dart';
import 'searchHeader.dart';
import '../recommendationView/recommendationView.dart';
import '../../viewmodels/search_vm.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {

  @override
  void initState() {
    super.initState();
    // 화면 진입 시 최근 검색어 불러오기
    Future.microtask(() => ref.read(searchViewModelProvider).loadRecentSearches());
  }

  @override
  Widget build(BuildContext context) {
    // ViewModel 상태 구독
    final searchVm = ref.watch(searchViewModelProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const SearchBackground(), // 배경 그라데이션
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const SearchHeader(), // 헤더 섹션
                  const SizedBox(height: 30),

                  // 검색바 : 검색시 _addSearch 실행
                  SearchWidget(
                    controller: TextEditingController(),
                    onSearch: (value) async {
                      await searchVm.search(value);

                      // 컨텍스트가 여전히 유효한지 확인
                      if (!context.mounted) return;
                      // 결과 화면으로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecommendationView(keyword: value),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  SectionHeader(
                      title: '최근 검색어',
                      hasAction: true,
                      onActionTap: () => searchVm.deleteAllSearches(),
                  ),
                  const SizedBox(height: 12),

                  // 리스트 기반으로 칩 생성
                  searchVm.recentSearches.isEmpty
                    ? const Text('최근 검색어가 없습니다.', style: TextStyle(color: Colors.grey),)
                    : Wrap(
                        spacing: 8, runSpacing: 8,
                        children: searchVm.recentSearches.map((text) => GestureDetector(
                            onTap: () async {
                              await searchVm.search(text);

                              if(context.mounted) {
                                Navigator.pushNamed(
                                    context,
                                    AppRoutes.recommendation,
                                    arguments: text,
                                );
                              }
                            },
                          child: RecentSearchChip(
                              text: text,
                              onDelete: () => searchVm.deleteSearch(text)
                          ),
                        )).toList(),
                      ),

                  const SizedBox(height: 32),

                  const SectionHeader(title: '인기 키워드'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8, runSpacing: 10,
                    children: const [
                      KeywordChip(text: '#졸업식'),
                      KeywordChip(text: '#기념일'),
                      KeywordChip(text: '#생일축하'),
                      KeywordChip(text: '#입사선물'),
                      KeywordChip(text: '#첫만남'),
                    ],
                  ),

                  const SizedBox(height: 40),

                  Row(
                    children: const [
                      Expanded(
                        child: CategoryCard(
                          icon: Icons.sentiment_satisfied_alt,
                          title: '분위기별 검색',
                          subtitle: '따뜻한, 시크한, 발랄한',
                          bgColor: Color(0xFFF5F3FF),
                          iconColor: Color(0xFF7C3AED),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CategoryCard(
                          icon: Icons.local_florist,
                          title: '꽃말별 검색',
                          subtitle: '영원한 사랑, 감사, 존경',
                          bgColor: Color(0xFFFFF1F2),
                          iconColor: Color(0xFFF43F5E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}