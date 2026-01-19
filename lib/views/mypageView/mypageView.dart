import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/mypage_vm.dart';
import '../../viewmodels/profile_vm.dart';
import '../user/loginView.dart';
import 'profileCard.dart';
import 'profileView.dart';
import 'settingsView/settingsView.dart';
import 'notificationView.dart';
import 'menuItem.dart';

class MyPageView extends ConsumerWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPageViewModel = ref.watch(myPageViewModelProvider);
    final profileViewModel = ref.watch(profileViewModelProvider);
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
                );
              },
              child: ProfileCard(
                name: profileViewModel.userName,
                bio: profileViewModel.userBio,
                primaryColor: purpleTheme,
              ),
            ),

            const SizedBox(height: 40),
            _buildSectionLabel('나의 활동'),
            const SizedBox(height: 12),

            // 2. 메뉴 아이템 분리 적용
            MyPageMenuItem(
              icon: Icons.favorite,
              title: '좋아요 표시한 꽃',
              iconColor: purpleTheme,
              onTap: () => myPageViewModel.navigateToLikedFlowers(context),
            ),
            MyPageMenuItem(
              icon: Icons.local_florist,
              title: '가고 싶은 꽃집',
              iconColor: purpleTheme,
              onTap: () => myPageViewModel.navigateToStoreList(context),
            ),

            const SizedBox(height: 32),
            _buildSectionLabel('서비스안내'),
            const SizedBox(height: 12),

            MyPageMenuItem(
              icon: Icons.notifications_none,
              title: '알림 목록',
              iconColor: purpleTheme,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationView()),
                );
              },
            ),
            MyPageMenuItem(
              icon: Icons.settings_outlined,
              title: '설정',
              iconColor: purpleTheme,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsView()),
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
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 14, color: Color(0xFFD1C4FF), fontWeight: FontWeight.bold),
    );
  }
}