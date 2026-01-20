import 'package:flutter/material.dart';

class FlowerInfoSection extends StatelessWidget {
  const FlowerInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTag('신뢰의 상징'),
          const SizedBox(height: 12),
          const Text('프리지아 이야기', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 60),
          const Text('꽃말과 유래', style: TextStyle(color: Color(0xFF7C4DFF), fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildQuoteSection('"당신의 시작을 응원합니다. 변치 않는 우정과 순결한 마음을 전해보세요."'),
          const SizedBox(height: 20),
          const Text(
            '남아프리카가 원산지인 프리지아는 우아한 종 모양의 꽃과 달콤하고 상큼한 시트러스 향으로 잘 알려져 있습니다...',
            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(15)),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildQuoteSection(String quote) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color(0xFF7C4DFF), width: 3))),
      child: Text(
        quote,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
      ),
    );
  }
}