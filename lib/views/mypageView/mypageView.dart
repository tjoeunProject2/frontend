import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/mypage_vm.dart';
import '../user/loginView.dart';
import 'profileCard.dart';
import 'menuItem.dart';

class MyPageView extends ConsumerWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(myPageViewModelProvider);
    const purpleTheme = Color(0xFF9E7AFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(purpleTheme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),


            // 1. 프로필 카드 분리
            ProfileCard(
              name: viewModel.userName,
              bio: viewModel.userBio,
              primaryColor: purpleTheme,
            ),

            const SizedBox(height: 40),
            _buildSectionLabel('나의 활동'),
            const SizedBox(height: 12),

            // 2. 메뉴 아이템 분리 적용
            MyPageMenuItem(
              icon: Icons.favorite,
              title: '좋아요 표시한 꽃',
              iconColor: purpleTheme,
              onTap: viewModel.navigateToLikedFlowers,
            ),
            MyPageMenuItem(
              icon: Icons.local_florist,
              title: '가고 싶은 꽃집',
              iconColor: purpleTheme,
              onTap: viewModel.navigateToStoreList,
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('서비스안내'),
            const SizedBox(height: 12),

            MyPageMenuItem(
              icon: Icons.notifications_none,
              title: '알림 설정',
              iconColor: purpleTheme,
              onTap: viewModel.navigateToNotificationSettings,
            ),
            MyPageMenuItem(
              icon: Icons.help_outline,
              title: '고객 센터',
              iconColor: purpleTheme,
              onTap: viewModel.navigateToCustomerService,
            ),

            const SizedBox(height: 20),
            _buildLogoutButton(
              context,
              onTap: () {
                // 1. ViewModel의 로그아웃 처리 (데이터 초기화 등)
                viewModel.logout();

                // 2. 로그인 페이지로 이동
                // pushAndRemoveUntil을 써야 뒤로가기를 눌러도 마이페이지로 안 돌아옵니다.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()), // 로그인 페이지 클래스명
                      (route) => false,
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 간단한 내부 헬퍼 위젯들
  AppBar _buildAppBar(Color color) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('마이 페이지', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      actions: [
        IconButton(
          icon: CircleAvatar(
            backgroundColor: const Color(0xFFF3EFFF),
            child: Icon(Icons.settings, color: color, size: 20),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 14, color: Color(0xFFD1C4FF), fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLogoutButton(BuildContext context, {required VoidCallback onTap}) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: const Text('로그아웃', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
    );
  }
}