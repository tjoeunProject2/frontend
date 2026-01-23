import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:frontend/services/deep_link_service.dart';
import 'app/app.dart';
import 'services/notification_service.dart';
import 'package:frontend/config/env_config.dart';

void main() async {
  // 위젯 바인딩 초기화 (안정성)
  WidgetsFlutterBinding.ensureInitialized();

  // 카카오 SDK 초기화
  KakaoSdk.init(nativeAppKey: EnvConfig.kakaoNativeAppKey);
  
  // 카카오 맵 초기화
  AuthRepository.initialize(appKey: EnvConfig.kakaoNativeAppKey);

  // 알림 서비스 초기화
  final notificationService = NotificationService();
  await notificationService.initialize();

  // 매일 오후 6시 알림 예약
  await notificationService.scheduleDailyFlowerShopReminder();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override 
  void initState() {
    super.initState();
    // 분리된 딥링크 서비스를 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DeepLinkService.handleDeepLink();
    });
  }

  @override
  Widget build(BuildContext context) {
    // app/app.dart의 화면 설정을 불러오면서 딥링크 키 전달
    return FloritApp(
        navigatorKey: DeepLinkService.navigatorKey,);
  }

}
