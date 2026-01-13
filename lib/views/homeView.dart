import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('홈')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const _DummyDetail(),
              ),
            );
          },
          child: const Text('예시: 상세보기 push'),
        ),
      ),
    );
  }
}

class _DummyDetail extends StatelessWidget {
  const _DummyDetail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('상세보기(더미)')),
      body: const Center(child: Text('여기에 꽃 상세 페이지 붙이면 됨')),
    );
  }
}
