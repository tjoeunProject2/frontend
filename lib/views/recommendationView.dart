import 'package:flutter/material.dart';
import 'flowerDetailView.dart'; // 상세 화면 임포트

class RecommendationView extends StatelessWidget {
  final String keyword;

  const RecommendationView({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D3142)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$keyword 추천 꽃',
          style: const TextStyle(color: Color(0xFF2D3142), fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 클릭 시 상세 화면으로 이동
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FlowerDetailView()),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=500&auto=format', // 예시 이미지
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildTag('#새로운시작'),
                const SizedBox(width: 8),
                _buildTag('#응원'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              '응원과 시작의 상징',
              style: TextStyle(color: Color(0xFF7C4DFF), fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              '프리지아',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 16),
            const Text(
              '졸업은 끝이 아닌 새로운 시작이죠. 친구의 앞날을 응원하는 가장 대표적인 꽃이에요. 향긋한 내음과 밝은 노란색은 새로운 출발에 설렘을 더해줍니다.',
              style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.6),
            ),
            const SizedBox(height: 60),
            Center(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF7C4DFF)),
                  padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('다시 검색하기 🔍', style: TextStyle(color: Color(0xFF7C4DFF))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF7C4DFF), fontSize: 12)),
    );
  }
}