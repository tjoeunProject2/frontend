import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'services/notification_service.dart';

void main() async {
  // 위젯 바인딩 초기화 (안정성)
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 서비스 초기화
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  // 매일 오후 6시 알림 예약
  await notificationService.scheduleDailyFlowerShopReminder();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
