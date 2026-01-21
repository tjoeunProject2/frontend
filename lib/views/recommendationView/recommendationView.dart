import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/search_vm.dart';
import '../../models/flower.dart';
import 'flowerRecommendationCard.dart'; // 위젯 분리 임포트

class RecommendationView extends ConsumerStatefulWidget {
  final String keyword;

  const RecommendationView({super.key, required this.keyword});

  @override
  ConsumerState<RecommendationView> createState() => _RecommendationViewState();
}

class _RecommendationViewState extends ConsumerState<RecommendationView> {
  late PageController _pageController;
  double _currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    // 뷰포트 비율 설정
    _pageController = PageController(viewportFraction: 0.85);

    // 스크롤 리스너 등록: 스크롤 할 때마다 현재 페이지 값 업데이트하고 화면을 다시 그림
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 서버 결과 가져오기
    final serverResults = ref
        .watch(searchViewModelProvider)
        .searchResults;

    // 더미 데이터 (Flower 모델 객체로 생성)
    final List<Flower> dummyResults = [
      Flower(
        id: '1',
        name: 'Freesia',
        season: '봄',
        koreanName: '프리지아',
        tag: '#새로운시작',
        occasion: '졸업과 입학을 축하할 때',
        description: '졸업은 끝이 아닌 새로운 시작이죠. 친구의 앞날을 응원하는 가장 대표적인 꽃이에요. 향긋한 내음과 밝은 노란색은 설렘을 더해줍니다.',
        imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500',
      ),
      Flower(
        id: '2',
        name: 'Tulip',
        season: '봄',
        koreanName: '튤립',
        tag: '#영원한사랑',
        occasion: '연인에게 고백할 때',
        description: '망설이고 있다면 튤립으로 마음을 전해보세요. 붉은 튤립은 사랑의 고백이라는 꽃말을 담고 있어 진심을 전하기에 완벽합니다.',
        imageUrl: 'https://images.unsplash.com/photo-1582794543139-8ac9cb0f7b11?w=500',
      ),
      Flower(
        id: '3',
        name: 'Gypsophila',
        season: '사계절',
        koreanName: '안개꽃',
        tag: '#맑은마음',
        occasion: '감사한 마음을 전할 때',
        description: '은은하게 주변을 빛내주는 안개꽃처럼, 당신의 따뜻한 배려에 감사드립니다. 다른 꽃들과 함께 있을 때 더욱 빛나는 매력을 가졌어요.',
        imageUrl: 'https://images.unsplash.com/photo-1508784411316-02b8cd4d3a3a?w=500',
      ),
    ];

    final displayResults = serverResults.isEmpty ? dummyResults : serverResults;


    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(context),
      body: displayResults.isEmpty
          ? const Center(child: Text('추천 결과가 없습니다.'))
          : PageView.builder(
        controller: _pageController,
        itemCount: displayResults.length,
        itemBuilder: (context, index) {
          // 애니메이션 값 계산 로직
          // 현재 인덱스와 스크롤 위치 사이의 거리 절댓값 계산 (0이면 중앙, 커질수록 멀어짐)
          double value = (_currentPageValue - index).abs();
          // 스케일 계산 : 중앙(0)일 때 1.0, 멀어질수록 0.9까지 작아짐
          double scale = (1 - (value * 0.1)).clamp(0.9, 1.0);
          // 투명도 계산 : 중앙(0)일 때 1.0, 멀어질수록 0.5까지 흐려짐
          double opacity = (1 - (value * 0.5)).clamp(0.5, 1.0);

          return Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: FlowerRecommendationCard(flower: displayResults[index]),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
            Icons.arrow_back_ios, color: Color(0xFF2D3142), size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '${widget.keyword} 추천 결과',
        style: const TextStyle(color: Color(0xFF2D3142),
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }
}