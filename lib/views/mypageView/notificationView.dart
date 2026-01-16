import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/profile_vm.dart';

class NotificationSettingsView extends ConsumerWidget {
  const NotificationSettingsView({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(profileViewModelProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${viewModel.userName} 님의 알림'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Text('알림'),
      ),
    );
  }

}


