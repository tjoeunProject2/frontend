import 'package:flutter/material.dart';

/// 지도 에러 메시지 위젯
class MapErrorMessage extends StatelessWidget {
  final String errorMessage;

  const MapErrorMessage({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[700],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        errorMessage,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
