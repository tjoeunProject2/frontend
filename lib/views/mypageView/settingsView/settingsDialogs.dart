import 'package:flutter/material.dart';
import '../../../viewmodels/settings_vm.dart';

class SettingsDialogs {
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

  // 캐시 데이터 삭제 다이얼로그
  static void showClearCacheDialog(BuildContext context, SettingsViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('캐시 데이터 삭제'),
        content: const Text('임시 저장된 꽃 정보를 삭제합니다.\n(좋아요 목록은 유지됩니다)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await vm.clearCache();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('캐시 데이터가 삭제되었습니다')),
                );
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  // 보관함 초기화 다이얼로그
  static void showClearStorageDialog(BuildContext context, SettingsViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('보관함 초기화'),
        content: const Text(
          '좋아요한 꽃과 꽃집이 모두 삭제됩니다.\n삭제된 데이터는 복구할 수 없습니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              await vm.clearAllLocalData();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('보관함이 초기화되었습니다')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
