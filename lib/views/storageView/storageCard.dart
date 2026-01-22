import 'package:flutter/material.dart';
import '../../models/flower.dart';

class FlowerStorageCard extends StatelessWidget {
  final Flower flower;
  final Color primaryColor;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onDelete;
  final bool isFavorite;

  const FlowerStorageCard({
    super.key,
    required this.flower,
    required this.primaryColor,
    required this.onFavoriteToggle,
    this.onDelete,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                // 배경 이미지 또는 색상 영역
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: flower.imageUrl.isNotEmpty
                      ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      flower.imageUrl,
                      fit: BoxFit.cover,
                      // 실제 파일이 없을 때 빨간 에러창 대신 아이콘을 표시합니다.
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(Icons.image, color: Colors.grey.withOpacity(0.5)),
                      ),
                    ),
                  )
                      : Center(
                    child: Icon(Icons.image, color: Colors.grey.withOpacity(0.5)),
                  ),
                ),
                // X 아이콘 (삭제 버튼)
                if (onDelete != null)
                  Positioned(
                    top: 5,
                    left: 5,
                    child: IconButton(
                      onPressed: onDelete,
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                // 하트 아이콘
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      // 상태에 따라 아이콘 모양 변경
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? const Color(0xFFFF4D4D) : Colors.white,
                      size: 24,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(8), // 터치 영역 확보
                    style: IconButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  flower.occasion ?? '',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  flower.koreanName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  flower.season,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}