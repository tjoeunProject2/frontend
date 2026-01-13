import 'dart:async';
import 'package:flutter/material.dart';
import '../app/routes.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  void initState() {
    super.initState();
    // 2초 뒤에 로그인 화면으로 이동
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 중앙 콘텐츠 (로고 + 텍스트)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 로고 원형 배경
                  Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.local_florist_rounded,
                        color: Color(0xFF9E7AFF),
                        size: 80,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 앱 타이틀
                  const Text(
                    '플로릿',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF9E7AFF),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 슬로건
                  const Text(
                    '나만의 꽃 이야기를 찾아보세요!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFA19BA9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // 하단 콘텐츠 (브랜드명)
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // 하단 문구 및 아이콘
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.eco_rounded, size: 16, color: Color(0xFFA19BA9)),
                      SizedBox(width: 8),
                      Text(
                        'Florit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFA19BA9),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
