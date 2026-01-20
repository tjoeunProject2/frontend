import 'package:flutter/material.dart';

class FlowerDetailView extends StatelessWidget {
  const FlowerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 그라데이션 (이미지가 있을 경우 Image.network 등으로 대체 가능)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD1C4E9), Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 상단 커스텀 앱바
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Row(
                          children: [
                            IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
                            IconButton(icon: const Icon(Icons.share_outlined, color: Colors.white), onPressed: () {}),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), borderRadius: BorderRadius.circular(15)),
                          child: const Text('신뢰의 상징', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                        const SizedBox(height: 12),
                        const Text('프리지아 이야기', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 60),
                        const Text('꽃말과 유래', style: TextStyle(color: Color(0xFF7C4DFF), fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: const BoxDecoration(border: Border(left: BorderSide(color: Color(0xFF7C4DFF), width: 3))),
                          child: const Text(
                            '"당신의 시작을 응원합니다. 변치 않는 우정과 순결한 마음을 전해보세요."',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '남아프리카가 원산지인 프리지아는 우아한 종 모양의 꽃과 달콤하고 상큼한 시트러스 향으로 잘 알려져 있습니다. 식물학자 에클론이 자신의 절친한 친구인 프레제(Freese)의 이름을 따서 명명하며...',
                          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.6),
                        ),
                        const SizedBox(height: 40),
                        // 추천 메시지 카드
                        _buildMessageCard(),
                        const SizedBox(height: 50),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          const Icon(Icons.format_quote, color: Color(0xFFD1C4E9), size: 40),
          const Text(
            '"프리지아의 향기처럼 당신의 존재는 늘 주변을 밝게 비춰주네요. 우리의 소중한 인연이 오랫동안 지속되길 바랍니다."',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('문구 복사하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C4DFF),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }
}