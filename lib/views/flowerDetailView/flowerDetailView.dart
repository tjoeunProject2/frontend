import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/flower_detail_vm.dart';
import 'detailAppBar.dart';
import 'flowerInfoSection.dart';
import 'flowerMessageCard.dart';

class FlowerDetailView extends ConsumerStatefulWidget {
  final String flowerId;
  
  const FlowerDetailView({super.key, required this.flowerId});

  @override
  ConsumerState<FlowerDetailView> createState() => _FlowerDetailViewState();
}

class _FlowerDetailViewState extends ConsumerState<FlowerDetailView> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 페이지가 다시 보일 때마다 좋아요 상태 새로고침
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(flowerDetailViewModelProvider(widget.flowerId)).refreshFavoriteStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. 배경 그라데이션 영역
          _buildBackground(),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailAppBar(flowerId: widget.flowerId),         // 2. 상단 앱바 위젯
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