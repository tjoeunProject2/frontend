import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'detailAppBar.dart';
import 'flowerInfoSection.dart';
import 'flowerMessageCard.dart';

class FlowerDetailView extends StatelessWidget {
  const FlowerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. 배경 그라데이션 영역
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  DetailAppBar(),         // 2. 상단 앱바 위젯
                  SizedBox(height: 100),
                  FlowerInfoSection(),    // 3. 꽃 스토리 섹션 위젯
                  SizedBox(height: 20),
                  FlowerMessageCard(),    // 4. 메시지 복사 카드 위젯
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD1C4E9), Colors.white],
        ),
      ),
    );
  }
}