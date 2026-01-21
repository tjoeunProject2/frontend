import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/routes.dart';
import '../../viewmodels/login_vm.dart';
import '../../../common/widgets/textField.dart'; // 공통 위젯 경로

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModel 상태 감시
    final vm = ref.watch(loginViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF9E7AFF)),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.root),
        ),
        title: const Text('로그인',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                decoration: const BoxDecoration(color: Color(0xFFF3EFFF), shape: BoxShape.circle),
                child: const Icon(Icons.local_florist, color: Color(0xFF9E7AFF), size: 60),
              ),
            ),
            const SizedBox(height: 24),
            const Text('꽃으로 전하는 진심',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
            const Text('나만의 이야기를 담은 꽃을 찾아보세요!',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),

            // 1. 이메일 입력창 (공통 위젯 활용)
            const Align(alignment: Alignment.centerLeft, child: Text('이메일', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            FloritTextField(
              controller: vm.emailController,
              hintText: '이메일을 입력해주세요',
              onChanged: (_) => vm.updateUI(),
            ),
            const SizedBox(height: 20),

            // 2. 비밀번호 입력창 (공통 위젯 활용)
            const Align(alignment: Alignment.centerLeft, child: Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            FloritTextField(
              controller: vm.passwordController,
              hintText: '비밀번호를 입력해주세요',
              obscureText: vm.isObscure,
              onChanged: (_) => vm.updateUI(),
              suffixIcon: IconButton(
                icon: Icon(
                  vm.isObscure ? Icons.visibility : Icons.visibility_off,
                  color: const Color(0xFF9E7AFF),
                ),
                onPressed: vm.toggleObscure,
              ),
            ),
            const SizedBox(height: 32),

            // 3. 로그인 버튼
            ElevatedButton(
              onPressed: vm.isFormValid && !vm.isLoading
                  ? () async {
                      final response = await vm.login();
                      // TODO: 개발 완료 후 success 체크 로직 복구 필요 
                      // if (response.success && context.mounted) {
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, AppRoutes.rootshell);
                      }
                      if (vm.errorMessage != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(vm.errorMessage!),
                            backgroundColor: Colors.red[700],
                          ),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: vm.isFormValid && !vm.isLoading ? const Color(0xFF9E7AFF) : Colors.grey[300],
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: vm.isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('로그인',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),

            // 하단 보조 메뉴
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.resetPassword);
                }, child: const Text('비밀번호 재설정', style: TextStyle(color: Colors.grey))),
                const Text(' | ', style: TextStyle(color: Colors.grey)),
                TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
                    child: const Text('회원가입하기', style: TextStyle(color: Color(0xFF9E7AFF)))
                ),
              ],
            ),
            const SizedBox(height: 40),

            // SNS 로그인 구분선
            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('SNS 계정으로 간편 로그인', style: TextStyle(color: Colors.grey, fontSize: 12))),
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
              child: const Text('카카오로 시작하기',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}