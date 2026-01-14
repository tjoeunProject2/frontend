import 'package:flutter/material.dart';
import 'package:frontend/app/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // 비밀번호 가림 상태 관리 (기본값: true - 가려짐)
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF9E7AFF)),
          onPressed: () {Navigator.pushReplacementNamed(context, AppRoutes.root);} ,
        ),
        title: const Text('로그인', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // 로고 이미지 섹션
            Center(
              child: Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: const Color(0xFFF3EFFF), shape: BoxShape.circle),
                child: const Icon(Icons.local_florist, color: Color(0xFF9E7AFF), size: 60),
              ),
            ),
            const SizedBox(height: 24),
            const Text('꽃으로 전하는 진심', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
            const Text('나만의 이야기를 담은 꽃을 찾아보세요!', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),

            // 이메일 입력창
            const Align(alignment: Alignment.centerLeft, child: Text('이메일', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '이메일을 입력해주세요',
                filled: true, fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE0D7FF))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Color(0xFFE0D7FF))),
              ),
            ),
            const SizedBox(height: 20),

            // 비밀번호 입력창
            const Align(alignment: Alignment.centerLeft, child: Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextField(
              obscureText: _isObscure,
              decoration: InputDecoration(
                hintText: '비밀번호를 입력해주세요',
                // 접미사 아이콘 클릭 시 상태 변경
                suffixIcon: IconButton(
                  icon: Icon(
                    // _isObscure가 true(숨김)면 눈 모양, false(보임)면 눈+슬래시 모양
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFF9E7AFF),
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure; // 상태 반전
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFE0D7FF)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Color(0xFFE0D7FF)),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.rootshell);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9E7AFF),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: const Text('로그인', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),

            // 하단 보조 메뉴
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {}, child: const Text('비밀번호찾기', style: TextStyle(color: Colors.grey))),
                const Text(' | ', style: TextStyle(color: Colors.grey)),
                TextButton(onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.register);
                }, child: const Text('회원가입하기', style: TextStyle(color: Color(0xFF9E7AFF)))),
              ],
            ),
            const SizedBox(height: 40),

            // SNS 로그인 구분선
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('SNS 계정으로 간편 로그인', style: TextStyle(color: Colors.grey, fontSize: 12))),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 40),

            // 카카오 로그인 버튼
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEE500),
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('카카오로 시작하기', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}