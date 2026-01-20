import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../viewmodels/settings_vm.dart';
import '../../../viewmodels/notification_settings_vm.dart';
import '../termsOfServiceView.dart';
import '../../user/loginView.dart';
import 'settingSectionTitle.dart';
import 'settingSwitchItem.dart';
import 'settingMenuItem.dart';
import 'settingsDialogs.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(settingsViewModelProvider);
    final notificationSettings = ref.watch(notificationSettingsProvider);
    const purpleTheme = Color(0xFF7C4DFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '설정',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // 알림 설정
            const SettingSectionTitle('푸시 알림'),
            const SizedBox(height: 12),
            SettingSwitchItem(
              icon: Icons.notifications_outlined,
              title: '푸시 알림',
              subtitle: '새로운 소식과 알림을 받습니다',
              value: vm.pushNotificationEnabled,
              onChanged: (value) async {
                vm.togglePushNotification(value);
                // 푸시 알림과 함께 퇴근길 꽃집, 오늘의 꽃 알림도 제어
                await notificationSettings.toggleDailyReminder(value);
                vm.setFlowerRecommendation(value);
              },
              activeColor: purpleTheme,
            ),
            SettingSwitchItem(
              icon: Icons.store_outlined,
              title: '꽃집 소식',
              subtitle: '가고 싶은 꽃집의 새로운 소식을 받습니다',
              value: vm.shopNewsEnabled,
              onChanged: (value) => vm.setShopNews(value),
              activeColor: purpleTheme,
            ),

            const SizedBox(height: 32),

            // 개인정보
            const SettingSectionTitle('개인정보'),
            const SizedBox(height: 12),
            SettingMenuItem(
              icon: Icons.lock_outline,
              title: '개인정보 처리방침', 
              onTap: () => vm.openPrivacyPolicy(context),
            ),
            SettingMenuItem(
              icon: Icons.description_outlined,
              title: '서비스 이용약관',
              onTap: () => vm.openTermsOfService(context),
            ),

            const SizedBox(height: 32),

            // 앱 정보
            const SettingSectionTitle('앱 정보'),
            const SizedBox(height: 12),
            SettingMenuItem(
              icon: Icons.info_outline,
              title: '버전 정보',
              value: vm.appVersion,
              onTap: () => vm.checkForUpdates(),
            ),
            SettingMenuItem(
              icon: Icons.bug_report_outlined,
              title: '문제 신고',
              onTap: () => vm.reportBug(context),
            ),
            SettingMenuItem(
              icon: Icons.star_outline,
              title: '앱 평가하기',
              onTap: () => vm.rateApp(),
            ),

            const SizedBox(height: 32),

            // 계정
            const SettingSectionTitle('계정'),
            const SizedBox(height: 12),
            SettingMenuItem(
              icon: Icons.logout,
              title: '로그아웃',
              textColor: Colors.red,
              onTap: () => SettingsDialogs.showLogoutDialog(
                context,
                vm,
                () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                ),
              ),
            ),
            SettingMenuItem(
              icon: Icons.delete_outline,
              title: '회원 탈퇴',
              textColor: Colors.red,
              onTap: () => SettingsDialogs.showDeleteAccountDialog(
                context,
                vm,
                () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}