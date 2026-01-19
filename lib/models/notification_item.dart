import 'package:flutter/material.dart';

/// 알림 아이템 모델
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'flower', 'shop', 'system'
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    String? type,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
    );
  }

  IconData get icon {
    switch (type) {
      case 'flower':
        return Icons.local_florist;
      case 'shop':
        return Icons.store;
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  Color get color {
    switch (type) {
      case 'flower':
        return const Color(0xFF7C4DFF);
      case 'shop':
        return const Color(0xFFFF6B6B);
      case 'system':
        return const Color(0xFF4ECDC4);
      default:
        return Colors.grey;
    }
  }
}
