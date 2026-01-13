import 'package:flutter/material.dart';

class FloritTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller; // 입력을 제어할 컨트롤러 추가 가능
  final String? errorText; // 에러 메시지 추가
  final ValueChanged<String>? onChanged; // 입력값 변경 이벤트 추가

  const FloritTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(color: Color(0xFFD1C4E9), fontSize: 14),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // 기본 테두리
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFE0D7FF)),
        ),
        // 활성화된 상태의 테두리
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFFE0D7FF)),
        ),
        // 클릭 시 강조되는 테두리
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF9E7AFF), width: 1.5),
        ),
      ),
    );
  }
}