import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/flower_detail_vm.dart';

class DetailAppBar extends ConsumerWidget {
  final String flowerId;
  
  const DetailAppBar({super.key, required this.flowerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(flowerDetailViewModelProvider(flowerId));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  vm.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: vm.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () => vm.toggleFavorite(),
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}