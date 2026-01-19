import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_item.dart';

/// 알림 목록 관리 ViewModel
class NotificationListViewModel extends ChangeNotifier {
  final List<NotificationItem> _notifications = [
    // Mock 데이터
    NotificationItem(
      id: '1',
      title: '퇴근길 꽃 한 송이 어떠세요? 🌸',
      message: '오늘 하루도 수고하셨어요. 가까운 꽃집에서 특별한 순간을 만들어보세요.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'flower',
    ),
    NotificationItem(
      id: '2',
      title: '가까운 꽃집에 신상품이 들어왔어요!',
      message: '플라워샵 서울점에 봄 신상 꽃다발이 입고되었습니다.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'shop',
      isRead: true,
    ),
    NotificationItem(
      id: '3',
      title: '오늘의 꽃: 튤립',
      message: '사랑의 고백을 상징하는 튤립을 추천드려요.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      type: 'flower',
      isRead: true,
    ),
  ];

  List<NotificationItem> get notifications => _notifications;
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// 알림을 읽음 처리
  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  /// 알림 삭제
  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  /// 모든 알림 읽음 처리
  void markAllAsRead() {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  /// 모든 알림 삭제
  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  /// 새 알림 추가 (로컬 알림이 왔을 때 호출)
  void addNotification(NotificationItem notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
}

final notificationListProvider =
    ChangeNotifierProvider((ref) => NotificationListViewModel());
