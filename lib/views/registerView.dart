import 'package:flutter/material.dart';
import '../app/routes.dart';
import '../../common/widgets/textField.dart'; // 공통 위젯 경로 확인 필수

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  // 텍스트 제어를 위한 컨트롤러
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // 에러 메시지 상태를 저장할 변수
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    // 메모리 누수 방지를 위해 컨트롤러 해제
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 비밀번호 일치 확인 로직
  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = null;
      } else if (_passwordController.text != value) {
        _confirmPasswordError = "비밀번호가 같지 않습니다";
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 160.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. 배경 레이어: 타이틀 텍스트 영역까지만 그라데이션
          Container(
            height: headerHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD1C4FF), // 상단 진한 보라
                  Colors.white,       // 텍스트가 끝나는 지점에서 흰색으로 전환
                ],
              ),
            ),
          ),

          // 2. 콘텐츠 레이어
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30), // 상단 여백 최소화

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- 상단 텍스트 섹션 ---
                        const Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),

                        const SizedBox(height: 60), // 입력 폼과의 간격

                        // --- 입력 필드 섹션 ---
                        const Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const FloritTextField(hintText: '이름을 입력해 주세요'),
                        const SizedBox(height: 24),

                        const Text('이메일', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            const FloritTextField(hintText: '이메일을 입력해 주세요'),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9E7AFF),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  minimumSize: const Size(0, 32),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation: 0,
                                ),
                                child: const Text('중복 확인', style: TextStyle(fontSize: 12, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        const Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        FloritTextField(
                          controller: _passwordController,
                          hintText: '비밀번호 (8자 이상)',
                          obscureText: _isPasswordObscure,
                          errorText: _passwordError,
                          onChanged: (value) {
                            setState(() {
                              // 8자 미만일 경우 에러 메시지
                              if(value.isNotEmpty && value.length < 8) {
                                _passwordError = "8자리 이상을 입력하세요";
                              } else {
                                _passwordError = null;
                              }
                            });
                            // 비밀번호가 바뀔 때 확인란과 다시 비교
                            _validateConfirmPassword(_confirmPasswordController.text);
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                                _isPasswordObscure ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFF9E7AFF)
                            ),
                            onPressed: () => setState(() => _isPasswordObscure = !_isPasswordObscure),
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text('비밀번호 확인', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        FloritTextField(
                          controller: _confirmPasswordController,
                          hintText: '비밀번호 확인',
                          obscureText: _isConfirmPasswordObscure,
                          errorText: _confirmPasswordError, // 에러 메시지 표시
                          onChanged: (value) {
                            _validateConfirmPassword(value); // 실시간 일치 확인
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                                _isConfirmPasswordObscure ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFF9E7AFF)
                            ),
                            onPressed: () => setState(() => _isConfirmPasswordObscure = !_isConfirmPasswordObscure),
                          ),
                        ),
                        const SizedBox(height: 60),

                        // 가입 완료 버튼
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9E7AFF),
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          child: const Text('가입완료', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 24),

                        // 하단 로그인 링크
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('이미 계정이 있으신가요? ', style: TextStyle(color: Colors.grey)),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                              child: const Text(
                                  '로그인',
                                  style: TextStyle(color: Color(0xFF9E7AFF), fontWeight: FontWeight.bold)
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}