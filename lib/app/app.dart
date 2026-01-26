import 'package:flutter/material.dart';
import 'routes.dart';

class FloritApp extends StatelessWidget {
  // 딥링크 서비스의 전역 키를 전달받음
  final GlobalKey<NavigatorState> navigatorKey;

  const FloritApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 딥링크 서비스의 키를 여기에 연결함
      navigatorKey: navigatorKey,
      title: 'Florit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // 기본 테마를 연보라색으로 설정
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9E7AFF),
          primary: const Color(0xFF9E7AFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F5FF), // 피그마 배경색 반영
        // fontFamily: 'Pretendard', // 나중에 폰트 추가 시 활성화
      ),
      // initialRoute: AppRoutes.home,
      // onGenerateRoute: AppRoutes.generateRoute,
      

      initialRoute: AppRoutes.root,
      routes: AppRoutes.routes,
    );
  }
}