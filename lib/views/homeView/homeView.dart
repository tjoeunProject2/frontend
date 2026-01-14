import 'package:flutter/material.dart';
import '../../common/widgets/search_widget.dart';
import 'homeHeader.dart';
import 'homeTitle.dart';
import 'seasonalFlowerCard.dart';
import 'todayFlowerBanner.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              HomeHeader(
                userName: '송예림님',
                hasNotification: true,
                onNotificationTap: () {},
              ),
              const SizedBox(height: 24),

              // 타이틀
              const HomeTitle(),
              const SizedBox(height: 24),

              // 검색바
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SearchWidget(
                  hintText: '어떤 상황인가요? (예: 친구 결혼식)',
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 32),

              // 계절의 꽃 섹션
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '계절의 꽃',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '전체보기',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7C4DFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 꽃 카드 리스트
              SizedBox(
                height: 280,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: const [
                    SeasonalFlowerCard(
                      image: 'assets/flower1.jpg',
                      tag: '클래식',
                      title: '새로운 시작',
                      occasion: '졸업식',
                    ),
                    SizedBox(width: 16),
                    SeasonalFlowerCard(
                      image: 'assets/flower2.jpg',
                      tag: '큐레이션',
                      title: '영원한 사랑',
                      occasion: '기념일',
                      isDark: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 오늘의 꽃 배너
              TodayFlowerBanner(
                flowerName: '해바라기',
                message: '"언제나 환한 미소로 능력을 밝혀주는\n친구에게"',
                imageAsset: 'assets/sunflower.jpg',
                onReadStory: () {},
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}