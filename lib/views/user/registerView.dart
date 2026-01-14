import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/routes.dart';
import '../../viewmodels/register_vm.dart';
import '../../../common/widgets/textField.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModel 인스턴스 참조
    final vm = ref.watch(registerViewModelProvider);
    double headerHeight = 160.0;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. 배경 레이어: 그라데이션
          Container(
            height: headerHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD1C4FF), Colors.white],
              ),
            ),
          ),

          // 2. 콘텐츠 레이어
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('회원가입',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                        const SizedBox(height: 60),

                        // --- 이름 입력 ---
                        const Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        FloritTextField(
                          controller: vm.nameController,
                          hintText: '이름을 입력해 주세요',
                        ),
                        const SizedBox(height: 24),

                        // --- 이메일 입력 + 중복 확인 ---
                        const Text('이메일', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            FloritTextField(
                              controller: vm.emailController,
                              hintText: '이메일을 입력해 주세요',
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ElevatedButton(
                                onPressed: () {}, // 중복 확인 로직
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

                        // --- 생년월일 입력 ---
                        const Text('생년월일', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        FloritTextField(
                          controller: vm.dobController,
                          hintText: '생년월일 8자리를 입력해 주세요 (ex: 20000101)',
                          keyboardType: TextInputType.number, // 숫자 패드 노출
                          errorText: vm.dobError,
                          onChanged: (value) => vm.validateDob(value),
                        ),
                        const SizedBox(height: 24),

                        // --- 비밀번호 입력 ---
                        const Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        FloritTextField(
                          controller: vm.passwordController,
                          hintText: '비밀번호 (8자 이상)',
                          obscureText: vm.isPasswordObscure,
                          errorText: vm.passwordError,
                          onChanged: vm.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(vm.isPasswordObscure ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF9E7AFF)),
                            onPressed: vm.togglePasswordObscure,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- 비밀번호 확인 입력 ---
                        const Text('비밀번호 확인', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        FloritTextField(
                          controller: vm.confirmPasswordController,
                          hintText: '비밀번호 확인',
                          obscureText: vm.isConfirmPasswordObscure,
                          errorText: vm.confirmPasswordError,
                          onChanged: vm.validateConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(vm.isConfirmPasswordObscure ? Icons.visibility : Icons.visibility_off, color: const Color(0xFF9E7AFF)),
                            onPressed: vm.toggleConfirmPasswordObscure,
                          ),
                        ),
                        const SizedBox(height: 60),

                        // 가입 완료 버튼
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
                          child: const Text('가입 완료', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 24),

                        // 하단 로그인 링크
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('이미 계정이 있으신가요? ', style: TextStyle(color: Colors.grey)),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                              child: const Text('로그인', style: TextStyle(color: Color(0xFF9E7AFF), fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
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