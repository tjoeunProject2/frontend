import 'package:flutter/material.dart';

class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 아이콘 (우측 정렬)
        Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: const Icon(Icons.dark_mode_outlined, size: 20),
          ),
        ),
        const SizedBox(height: 10),
        // 중앙 타이틀
        const Center(
          child: Column(
            children: [
              Text(
                '어떤 꽃을 찾으시나요?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '특별한 순간을 위한 가장 완벽한 선물',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}