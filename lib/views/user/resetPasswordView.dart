import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/widgets/textField.dart'; // 기존 공통 위젯 사용
import '../../viewmodels/reset_password_vm.dart';

class ResetPasswordView extends ConsumerWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ViewModel 상태 구독
    final vm = ref.watch(resetPasswordViewModelProvider);

    double headerHeight = 250.0;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF9E7AFF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('비밀번호 재설정',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 배경 레이어: 높이가 조정된 그라데이션
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

          // 콘텐츠 레이어
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text('비밀번호를 잊으셨나요?',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                  const SizedBox(height: 8),
                  const Text('가입하신 이름과 이메일을 입력하시면\n임시 비밀번호를 보내드립니다.',
                      style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5)),

                  // 이 아래부터 흰색 배경
                  const SizedBox(height: 48),

                  const Text('이름', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  FloritTextField(
                    controller: vm.nameController,
                    hintText: '이름을 입력해 주세요',
                    onChanged: (_) => vm.updateUI(),
                  ),
                  const SizedBox(height: 28),

                  const Text('이메일', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  FloritTextField(
                    controller: vm.emailController,
                    hintText: '이메일을 입력해 주세요',
                    onChanged: (_) => vm.updateUI(),
                  ),

                  if (vm.showEmailError)
                    const Padding(
                      padding: EdgeInsets.only(top: 8, left: 4),
                      child: Text(
                        '올바른 이메일 형식이 아닙니다.',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 48),

                  ElevatedButton(
                    onPressed: vm.isFormValid && !vm.isLoading
                        ? () async {
                      final success = await vm.resetPassword();
                      if (success && context.mounted) {
                        _showSuccessDialog(context, vm.message);
                      } else if (vm.errorMessage != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(vm.errorMessage!), backgroundColor: Colors.red[700]),
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
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('임시 비밀번호 발송',
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('발송 완료', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('확인', style: TextStyle(color: Color(0xFF9E7AFF), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}