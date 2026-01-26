import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/flowerShop.dart';
import '../../viewmodels/liked_shops_vm.dart';
import '../../common/widgets/navigation_app_selector.dart';

class ExpandedShopSheet extends ConsumerWidget {
  final FlowerShop shop;

  const ExpandedShopSheet({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedVm = ref.watch(likedShopsViewModelProvider);
    final phoneNumber = shop.phone.trim();
    final hasPhoneNumber = phoneNumber.isNotEmpty;
    final address = shop.address.trim();
    final hasAddress = address.isNotEmpty;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      likedVm.isLiked(shop.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: likedVm.isLiked(shop.id)
                          ? Colors.pink
                          : Colors.grey,
                    ),
                    onPressed: () {
                      likedVm.toggleLike(shop);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _ShopInfoRow(
                icon: Icons.location_on,
                label: '주소',
                value: hasAddress ? address : '주소 정보 없음',
              ),
              const SizedBox(height: 12),
              _ShopInfoRow(
                icon: Icons.phone,
                label: '전화번호',
                value: hasPhoneNumber ? phoneNumber : '전화번호 없음',
              ),
              const SizedBox(height: 12),
              _ShopInfoRow(
                icon: Icons.directions_walk,
                label: '거리',
                value: shop.formattedDistance,
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),

              const Text(
                '소개',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${shop.name}은(는) 다양한 꽃과 화환을 제공하는 전문 꽃집입니다. '
                    '고객의 특별한 순간을 아름답게 만들어 드립니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

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
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
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
                      icon: const Icon(Icons.directions, size: 20),
                      label: const Text('길찾기'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C4DFF),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _ShopInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ShopInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF7C4DFF)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
