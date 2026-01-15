import 'package:flutter/material.dart';
import '../../../viewmodels/settings_vm.dart';

class SettingsDialogs {
  static void showLanguageDialog(BuildContext context, SettingsViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('언어 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadioOption(context, vm, '한국어', 'ko'),
            _buildRadioOption(context, vm, 'English', 'en'),
            _buildRadioOption(context, vm, '日本語', 'ja'),
          ],
        ),
      ),
    );
  }

  static Widget _buildRadioOption(
    BuildContext context,
    SettingsViewModel vm,
    String label,
    String value,
  ) {
    return RadioListTile<String>(
      title: Text(label),
      value: value,
      groupValue: vm.languageCode,
      onChanged: (val) {
        if (val != null) {
          vm.setLanguage(val);
          Navigator.pop(context);
        }
      },
    );
  }

  static void showThemeDialog(BuildContext context, SettingsViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('테마 선택'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('라이트 모드'),
              leading: const Icon(Icons.light_mode),
              onTap: () {
                vm.setTheme('라이트');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('다크 모드'),
              leading: const Icon(Icons.dark_mode),
              onTap: () {
                vm.setTheme('다크');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('시스템 설정'),
              leading: const Icon(Icons.settings_suggest),
              onTap: () {
                vm.setTheme('시스템');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showDataManagementDialog(BuildContext context, SettingsViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('데이터 관리'),
        content: const Text('캐시와 임시 파일을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              vm.clearCache();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('데이터가 삭제되었습니다')),
              );
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  static void showLogoutDialog(BuildContext context, SettingsViewModel vm, VoidCallback onSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final success = await vm.logout();
              if (success && context.mounted) {
                Navigator.pop(context);
                onSuccess();
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
  }

  static void showDeleteAccountDialog(BuildContext context, SettingsViewModel vm, VoidCallback onSuccess) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('회원 탈퇴'),
        content: const Text(
          '회원 탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.\n정말 탈퇴하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              vm.deleteAccount();
              Navigator.pop(context);
              onSuccess();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('탈퇴'),
          ),
        ],
      ),
    );
  }
}
