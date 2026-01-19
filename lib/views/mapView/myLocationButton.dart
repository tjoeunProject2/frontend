import 'package:flutter/material.dart';

/// 내 위치로 이동하는 플로팅 버튼
class MyLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyLocationButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      child: const Icon(Icons.my_location, color: Color(0xFF7C4DFF)),
    );
  }
}
