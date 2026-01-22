import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/flower_detail_vm.dart';
import 'detailAppBar.dart';
import 'flowerInfoSection.dart';
import 'flowerMessageCard.dart';
import '../../viewmodels/storage_vm.dart';

class FlowerDetailView extends ConsumerStatefulWidget {
  final String flowerId;
  final bool isGuest; // 게스트 여부
  
  const FlowerDetailView(
      {super.key,
        required this.flowerId,
        // 기본값은 false로 설정하여, 일반적인 앱 네비게이션 시에는 별도 설정 없이 '로그인 유저'로 동작하게 함
        // 딥링크를 통해 들어올 때만 이 값을 true로 설정하여 전달함
        this.isGuest = false,
      });

  @override
  ConsumerState<FlowerDetailView> createState() => _FlowerDetailViewState();
}

class _FlowerDetailViewState extends ConsumerState<FlowerDetailView> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 게스트가 아닐 때(로그인 상태)만 상태를 새로고침 함
    if (!widget.isGuest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(flowerDetailViewModelProvider(widget.flowerId))
            .refreshFavoriteStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 현재 상세 페이지의 꽃 데이터를 가져옴
    final detailVm = ref.watch(flowerDetailViewModelProvider(widget.flowerId));
    final storageVm = ref.read(storageViewModelProvider);
    return Scaffold(
      body: Stack(
        children: [
          // 1. 배경 그라데이션 영역
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DetailAppBar(
                      flowerId: widget.flowerId,
                      isGuest: widget.isGuest, // 게스트 여부 전달
                      onSavePressed: () {
                      if (detailVm.flower != null) {
                        storageVm.saveFlower(detailVm.flower!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('보관함의 "저장한 꽃"에 추가되었습니다.')),
                        );
                      }
                    },
                  ),         // 2. 상단 앱바 위젯
                  const SizedBox(height: 100),
                  const FlowerInfoSection(),    // 3. 꽃 스토리 섹션 위젯
                  const SizedBox(height: 20),
                  const FlowerMessageCard(),    // 4. 메시지 복사 카드 위젯
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD1C4E9), Colors.white],
        ),
      ),
    );
  }
}