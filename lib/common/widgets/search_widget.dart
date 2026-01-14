import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  // 검색 버튼이나 엔터를 눌렀을 때 실행될 콜백 추가
  final Function(String)? onSearch;

  const SearchWidget({
    super.key,
    this.hintText = '어떤 생활인지요? (예. 꽃말)',
    this.onTap,
    this.controller,
    this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            color: const Color(0xFF7C4DFF),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: const Color(0xFF9E9E9E),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF212121),
              ),
              onTap: onTap,
              // 키보드 엔터키를 '검색' 모양으로 변경
              textInputAction: TextInputAction.search,
              // 엔터키 눌렀을 때 동작
              onSubmitted: (value) {
                if (onSearch != null) onSearch!(value);
              },
            ),
          ),
          const SizedBox(width: 8),
          // 버튼에 클릭 피드백(터치 효과) 추가
          Material(
            color: const Color(0xFF7C4DFF),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (onSearch != null && controller != null) {
                  onSearch!(controller!.text);
                }
              },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF7C4DFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '찾기',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
            ),
          ),
        ],
      ),
    );
  }
}
