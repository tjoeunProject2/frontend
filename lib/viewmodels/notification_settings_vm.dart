import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/notification_service.dart';

/// 알림 설정 ViewModel
class NotificationSettingsViewModel extends ChangeNotifier {
  bool _isDailyReminderEnabled = true;

  bool get isDailyReminderEnabled => _isDailyReminderEnabled;

  final NotificationService _notificationService = NotificationService();

  /// 매일 알림 토글
  Future<void> toggleDailyReminder(bool value) async {
    _isDailyReminderEnabled = value;
    notifyListeners();

    if (value) {
      await _notificationService.scheduleDailyFlowerShopReminder();
    } else {
      await _notificationService.cancelDailyReminder();
    }
  }

  /// 테스트 알림 보내기
  Future<void> sendTestNotification() async {
    await _notificationService.showTestNotification();
  }

  /// 예약된 알림 개수 확인
  Future<int> getPendingNotificationCount() async {
    final pending = await _notificationService.getPendingNotifications();
    return pending.length;
  }
}

final notificationSettingsProvider =
    ChangeNotifierProvider((ref) => NotificationSettingsViewModel());
