import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// 알림 서비스 초기화
  Future<void> initialize() async {
    // 타임존 초기화
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    // Android 설정
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Android 13+ 알림 권한 요청
    await _requestPermissions();
  }

  /// 알림 권한 요청
  Future<void> _requestPermissions() async {
    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final iosPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// 알림 탭 시 처리
  void _onNotificationTap(NotificationResponse response) {
    // TODO: 알림 탭 시 특정 화면으로 이동 (예: 지도 화면)
    print('알림 탭: ${response.payload}');
  }

  /// 매일 오후 6시 알림 예약
  Future<void> scheduleDailyFlowerShopReminder() async {
    // 오후 6시 설정
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      18, // 오후 6시
      0,
    );

    // 이미 오후 6시가 지났다면 다음 날로 설정
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_flower_shop',
      '꽃집 방문 알림',
      channelDescription: '퇴근 시간에 꽃집 방문을 권유하는 알림',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      0, // 알림 ID
      '퇴근길 꽃 한 송이 어떠세요? 🌸',
      '오늘 하루도 수고하셨어요. 가까운 꽃집에서 특별한 순간을 만들어보세요.',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
    );

    print('매일 오후 6시 알림이 예약되었습니다: $scheduledDate');
  }

  /// 즉시 테스트 알림 보내기
  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      '테스트 알림',
      channelDescription: '알림 테스트용',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999,
      '퇴근길 꽃 한 송이 어떠세요? 🌸',
      '오늘 하루도 수고하셨어요. 가까운 꽃집에서 특별한 순간을 만들어보세요.',
      details,
    );
  }

  /// 알림 취소
  Future<void> cancelDailyReminder() async {
    await _notifications.cancel(0);
    print('매일 알림이 취소되었습니다.');
  }

  /// 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// 예약된 알림 목록 확인
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
