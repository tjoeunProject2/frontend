import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/profile_vm.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final vm = ref.read(profileViewModelProvider);
    _nameController = TextEditingController(text: vm.userName);
    _bioController = TextEditingController(text: vm.userBio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(profileViewModelProvider);
    const purpleTheme = Color(0xFF7C4DFF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '프로필',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_isEditing) {
                // 저장
                vm.updateProfile(
                  name: _nameController.text,
                  bio: _bioController.text,
                );
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            child: Text(
              _isEditing ? '저장' : '수정',
              style: const TextStyle(
                color: purpleTheme,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 프로필 이미지
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: purpleTheme.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        // TODO: 이미지 선택 기능
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('프로필 이미지 변경 기능 준비 중')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: purpleTheme,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 40),

            // 이름 입력
            _buildInputField(
              label: '이름',
              controller: _nameController,
              enabled: _isEditing,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            // 소개 입력
            _buildInputField(
              label: '소개',
              controller: _bioController,
              enabled: _isEditing,
              icon: Icons.info_outline,
              maxLines: 3,
            ),

            const SizedBox(height: 40),

            // 계정 정보
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '계정 정보',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    icon: Icons.email_outlined,
                    label: '이메일',
                    value: vm.userEmail,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: '가입일',
                    value: vm.joinDate,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 비밀번호 변경 버튼
            if (!_isEditing)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: 비밀번호 변경 화면으로 이동
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('비밀번호 변경 기능 준비 중')),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: purpleTheme),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '비밀번호 변경',
                    style: TextStyle(
                      color: purpleTheme,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF7C4DFF)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            enabled: enabled,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 16,
              color: enabled ? Colors.black : Colors.black87,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
