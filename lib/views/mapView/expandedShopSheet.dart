import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/flowerShop.dart';
import '../../viewmodels/liked_shops_vm.dart';
import '../../common/widgets/navigation_app_selector.dart';

/// 확장된 꽃집 정보 시트
class ExpandedShopSheet extends ConsumerWidget {
  final FlowerShop shop;

  const ExpandedShopSheet({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likedVm = ref.watch(likedShopsViewModelProvider);

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
              // 드래그 핸들
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

              // 헤더
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
                      color: likedVm.isLiked(shop.id) ? Colors.pink : Colors.grey,
                    ),
                    onPressed: () {
                      likedVm.toggleLike(shop);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 정보 섹션
              _ShopInfoRow(
                icon: Icons.location_on,
                label: '주소',
                value: shop.address,
              ),
              const SizedBox(height: 12),
              _ShopInfoRow(
                icon: Icons.phone,
                label: '전화번호',
                value: shop.phone,
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

              // 설명 섹션
              const Text(
                '소개',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${shop.name}은(는) 다양한 꽃과 화환을 제공하는 전문 꽃집입니다. 고객의 특별한 순간을 아름답게 만들어 드립니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // 버튼들
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final phoneNumber =
                            shop.phone.replaceAll(RegExp(r'[^0-9]'), '');
                        final url = Uri.parse('tel:$phoneNumber');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('전화를 걸 수 없습니다')),
                            );
                          }
                        }
                      },
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

/// 꽃집 정보 행 위젯
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
