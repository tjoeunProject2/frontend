import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/flower.dart';
import '../../viewmodels/liked_flowers_vm.dart';
import 'seasonalFlowerCard.dart';

class SeasonalFlowerListView extends ConsumerWidget {
  final List<Flower> flowers;

  const SeasonalFlowerListView({super.key, required this.flowers});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedFlowersVm = ref.watch(likedFlowersViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '계절의 꽃',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: flowers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2열로 배치
          childAspectRatio: 0.75, // 카드의 세로 비율 조절
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final flower = flowers[index];
          return SeasonalFlowerCard(
            flowerId: flower.id,
            image: flower.imageUrl,
            tag: flower.tag,
            title: flower.koreanName,
            occasion: flower.occasion,
            isLiked: likedFlowersVm.isLiked(flower.id),
            onLikeTap: () => likedFlowersVm.toggleLike(flower),
            isFullWidth: true, // 격자 크기에 맞추기 위한 옵션 추가
          );
        },
      ),
    );
  }
}