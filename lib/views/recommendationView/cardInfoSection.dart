import 'package:flutter/material.dart';
import '../../app/routes.dart';

class CardInfoSection extends StatelessWidget {
  final dynamic flower;
  const CardInfoSection({super.key, required this.flower});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            flower.occasion ?? '특별한 날의 시작',
            style: const TextStyle(color: Color(0xFF7C4DFF), fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Text(
            flower.description ?? '꽃에 대한 아름다운 이야기가 준비 중입니다.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
          ),

        ],
      ),
    );
  }

}