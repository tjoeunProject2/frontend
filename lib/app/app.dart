import 'package:flutter/material.dart';
import 'routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}