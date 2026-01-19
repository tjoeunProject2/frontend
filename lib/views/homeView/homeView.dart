import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/search_widget.dart';
import '../../viewmodels/profile_vm.dart';
import '../../viewmodels/liked_flowers_vm.dart';
import '../../models/flower.dart';
import 'homeHeader.dart';
import 'homeTitle.dart';
import 'seasonalFlowerCard.dart';
import 'todayFlowerBanner.dart';
import '../mypageView/notificationView.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileViewModelProvider);
    final likedFlowersVm = ref.watch(likedFlowersViewModelProvider);
    
    // 샘플 꽃 데이터
    final flower1 = Flower(
      id: 'flower_1',
      name: 'Chrysanthemum',
      koreanName: '국화',
      season: '가을',
      occasion: '졸업식',
      tag: '클래식',
      imageUrl: 'assets/flower1.jpg',
      description: '새로운 시작을 축하하는 꽃',
    );
    
    final flower2 = Flower(
      id: 'flower_2',
      name: 'Rose',
      koreanName: '장미',
      season: '사계절',
      occasion: '기념일',
      tag: '큐레이션',
      imageUrl: 'assets/flower2.jpg',
      description: '영원한 사랑을 상징하는 꽃',
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              HomeHeader(
                userName: '${viewModel.userName}님',
                hasNotification: true,
                onNotificationTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationView()),
                  );
                },
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
                  children: [
                    SeasonalFlowerCard(
                      flowerId: flower1.id,
                      image: flower1.imageUrl,
                      tag: flower1.tag,
                      title: flower1.koreanName,
                      occasion: flower1.occasion,
                      isLiked: likedFlowersVm.isLiked(flower1.id),
                      onLikeTap: () => likedFlowersVm.toggleLike(flower1),
                    ),
                    const SizedBox(width: 16),
                    SeasonalFlowerCard(
                      flowerId: flower2.id,
                      image: flower2.imageUrl,
                      tag: flower2.tag,
                      title: flower2.koreanName,
                      occasion: flower2.occasion,
                      isDark: true,
                      isLiked: likedFlowersVm.isLiked(flower2.id),
                      onLikeTap: () => likedFlowersVm.toggleLike(flower2),
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