import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool hasAction;
  final VoidCallback? onActionTap; // '지우기' 버튼 클릭 시 실행할 함수

  const SectionHeader({
    super.key,
    required this.title,
    this.hasAction = false,
    this.onActionTap, // 생성자에 추가
});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        ),
        if (hasAction)
          GestureDetector(
            onTap: onActionTap, // 텍스트 클릭 시 함수 호출
            behavior: HitTestBehavior.opaque, // 터치 영역 확장
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                '지우기',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          )
      ],
    );
  }
}

class RecentSearchChip extends StatelessWidget {
  final String text;
  final VoidCallback onDelete; // X 아이콘 클릭 시 실행할 함수

  const RecentSearchChip({
    super.key,
    required this.text,
    required this.onDelete, // 생성자에 추가
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563))),
          const SizedBox(width: 6),
          // x 아이콘을 GestureDetector로 감싸서 클릭
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close,
              size: 14,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}

class KeywordChip extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // 키워드 클릭 시 검색 실행을 위해 추가

  const KeywordChip({
   super.key,
   required this.text,
   this.onTap,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Text(text, style: const TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600)),
    );
  }
}