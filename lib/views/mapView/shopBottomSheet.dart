import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/flowerShop.dart';
import '../../viewmodels/liked_shops_vm.dart';
import '../../common/widgets/navigation_app_selector.dart';

class ShopBottomSheet extends ConsumerWidget {
  final FlowerShop shop;
  final VoidCallback onClose;
  final VoidCallback onExpand;

  const ShopBottomSheet({
    super.key,
    required this.shop,
    required this.onClose,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedShopsVm = ref.watch(likedShopsViewModelProvider);
    final phoneNumber = shop.phone.trim();
    final hasPhoneNumber = phoneNumber.isNotEmpty;
    final address = shop.address.trim();
    final hasAddress = address.isNotEmpty;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! < -5) {
          onExpand();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    shop.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    likedShopsVm.isLiked(shop.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: likedShopsVm.isLiked(shop.id)
                        ? Colors.pink
                        : Colors.grey,
                  ),
                  onPressed: () {
                    likedShopsVm.toggleLike(shop);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          likedShopsVm.isLiked(shop.id)
                              ? '${shop.name}을(를) 관심 꽃집에 추가했습니다'
                              : '${shop.name}을(를) 관심 꽃집에서 제거했습니다',
                        ),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    hasAddress ? address : '주소 정보 없음',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  hasPhoneNumber ? phoneNumber : '전화번호 없음',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.directions_walk, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  shop.formattedDistance,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: hasPhoneNumber
                        ? () async {
                      final digitsOnly =
                      phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
                      final url = Uri.parse('tel:$digitsOnly');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('전화 앱을 열 수 없습니다'),
                            ),
                          );
                        }
                      }
                    }
                        : null,
                    icon: const Icon(Icons.phone, size: 20),
                    label: const Text('전화하기'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF7C4DFF),
                      side: const BorderSide(color: Color(0xFF7C4DFF)),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => NavigationAppSelector(
                          destinationLat: shop.lat,
                          destinationLng: shop.lng,
                          destinationName: shop.name,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C4DFF),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '길찾기',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
