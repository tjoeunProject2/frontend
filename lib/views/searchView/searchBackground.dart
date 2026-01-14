import 'package:flutter/material.dart';

class SearchBackground extends StatelessWidget {
  const SearchBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF8F6FF), // 피그마와 유사한 연보라색
            Colors.white,
          ],
        ),
      ),
    );
  }
}