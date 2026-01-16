import 'package:flutter/material.dart';
// 공통 위젯 임포트
import '../../common/widgets/search_widget.dart';
// 동일 폴더 내 위젯들 임포트
import 'categoryCard.dart';
import 'searchBackground.dart';
import 'searchChips.dart';
import 'searchHeader.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  // 최근 검색어 리스트 상태
  List<String> recentSearches = [];

  // 검색어 추가 함수
  void _addSearch(String text) {
    setState(() {
      // 중복 제거 후 맨 앞에 추가
      recentSearches.remove(text);
      recentSearches.insert(0, text);
    });
  }

  // 개별 삭제 함수
  void _deleteSearch(String text) {
    setState(() {
      recentSearches.remove(text);
    });
  }

  // 전체 삭제 함수
  void _clearAll() {
    setState(() {
      recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    onSearch: (value) => _addSearch(value),
                  ),

                  const SizedBox(height: 40),

                  SectionHeader(
                      title: '최근 검색어',
                      hasAction: true,
                      onActionTap: _clearAll,
                  ),
                  const SizedBox(height: 12),

                  // 리스트 기반으로 칩 생성
                  recentSearches.isEmpty
                    ? const Text('최근 검색어가 없습니다.', style: TextStyle(color: Colors.grey),)
                    : Wrap(
                        spacing: 8, runSpacing: 8,
                        children: recentSearches.map((text) => RecentSearchChip(
                            text: text,
                            onDelete: () => _deleteSearch(text),
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