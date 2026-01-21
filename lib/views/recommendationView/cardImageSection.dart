import 'package:flutter/material.dart';
import '../../app/routes.dart'; // 라우트 경로 임포트

class CardImageSection extends StatelessWidget {
  final dynamic flower;

  const CardImageSection({super.key, required this.flower});

  @override
  Widget build(BuildContext context) {
    // 이미지 영역 전체에 클릭 리스너 추가
    return GestureDetector(
      onTap: () {
        // 이미지 클릭 시 상세 페이지로 이동하며 데이터 전달
        Navigator.pushNamed(
          context,
          AppRoutes.flowerDetail, // AppRoutes에 등록된 상세 페이지 경로
          arguments: flower.id.toString(),      // flowerId를 문자열로 전달
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            // 상세 페이지와 연결되는 애니메이션 태그
            tag: 'flower_${flower.id}',
            child: Image.network(
              flower.imageUrl, // 서버에서 받아온 이미지 경로
              fit: BoxFit.cover,
            ),
          ),
          _buildGradientOverlay(),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardTag(flower.tag ?? '#추천'),
                const SizedBox(height: 8),
                Text(
                  flower.koreanName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
          ),
        ),
      ),
    );
  }

  Widget _buildCardTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 12)
      ),
    );
  }
}