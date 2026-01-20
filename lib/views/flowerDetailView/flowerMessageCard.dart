import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlowerMessageCard extends StatelessWidget {
  const FlowerMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    const String message = '프리지아의 향기처럼 당신의 존재는 늘 주변을 밝게 비춰주네요. 우리의 소중한 인연이 오랫동안 지속되길 바랍니다.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
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
              '"$message"',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            _buildCopyButton(context, message),
          ],
        ),
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context, String text) {
    return ElevatedButton.icon(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text)).then((_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('문구가 클립보드에 복사되었습니다.'), duration: Duration(seconds: 2)),
            );
          }
        });
      },
      icon: const Icon(Icons.copy, size: 18),
      label: const Text('문구 복사하기'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C4DFF),
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}