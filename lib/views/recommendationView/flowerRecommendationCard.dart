import 'package:flutter/material.dart';
import '../../models/flower.dart';
import 'cardImageSection.dart';
import 'cardInfoSection.dart';

class FlowerRecommendationCard extends StatelessWidget {
  final Flower flower; // 부모로부터 정확한 타입을 전달받음

  const FlowerRecommendationCard({super.key, required this.flower});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            // 이미지 영역: 클릭 시 상세 페이지 이동 로직 포함
            Expanded(flex: 3, child: CardImageSection(flower: flower)),
            // 정보 영역: 텍스트 및 버튼 포함
            Expanded(flex: 2, child: CardInfoSection(flower: flower)),
          ],
        ),
      ),
    );
  }
}