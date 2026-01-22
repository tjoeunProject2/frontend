import 'package:flutter/material.dart';

class FlowerCustomDialog extends StatefulWidget {
  final String title;
  final String content;
  final IconData icon;
  final String buttonText;

  const FlowerCustomDialog({
    super.key,
    required this.title,
    required this.content,
    // 기본 아이콘을 '꽃' 모양으로 변경
    this.icon = Icons.local_florist_sharp,
    this.buttonText = '확인',
  });

  // static 메소드는 그대로 유지
  static void show(BuildContext context, {
    required String title,
    required String content,
    IconData? icon,
    String? buttonText,
  }) {
    showDialog(
      context: context,
      builder: (context) => FlowerCustomDialog(
        title: title,
        content: content,
        icon: icon ?? Icons.local_florist,
        buttonText: buttonText ?? '확인',
      ),
    );
  }

  @override
  State<FlowerCustomDialog> createState() => _FlowerCustomDialogState();
}

// 애니메이션을 위한 TickerProviderStateMixin 추가
class _FlowerCustomDialogState extends State<FlowerCustomDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 살랑거리는 애니메이션 컨트롤러 설정
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true); // 앞뒤로 반복

    _animation = Tween<double>(begin: -0.06, end: 0.06).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic, // 부드러운 움직임
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 수채화 느낌의 파스텔 컬러 정의
    const Color softLavender = Color(0xFFD1C4E9);
    const Color palePink = Color(0xFFF8BBD0);
    const Color deepPastelPurple = Color(0xFF9575CD);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      backgroundColor: Colors.white,
      elevation: 0, // 다이얼로그 자체 그림자 제거로 깔끔함 강조
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 물감이 번진 듯한 은은한 배경
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [softLavender.withOpacity(0.5), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value,
                    // 아이콘에 수채화 그라데이션 적용 (ShaderMask)
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [deepPastelPurple, palePink],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: Icon(
                        widget.icon,
                        size: 48, // 아이콘 크기를 키워 디테일 강조
                        color: Colors.white, // ShaderMask를 위해 기본색은 흰색으로 설정
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF673AB7), // 타이틀은 조금 더 명확한 보라색
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black.withOpacity(0.55), // 본문은 부드러운 회색
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            // [변경] 진하지 않은 파스텔톤 수채화 버튼
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                // 너무 진하지 않은 은은한 그라데이션
                gradient: const LinearGradient(
                  colors: [Color(0xFFB39DDB), Color(0xFFCE93D8)], // Deep Purple 200, Purple 200
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB39DDB).withOpacity(0.3), // 그림자도 은은하게
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Text(
                  widget.buttonText,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}