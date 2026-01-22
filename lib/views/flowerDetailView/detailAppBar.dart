import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/views/user/loginView.dart';
import '../../viewmodels/flower_detail_vm.dart';
import '../../viewmodels/storage_vm.dart';
import '../../services/kakao_share_service.dart';
import '../../common/widgets/flower_custom_dialog.dart';

class DetailAppBar extends ConsumerWidget {
  final String flowerId;
  final bool isGuest; // 부모로부터 전달받은 게스트 상태
  final VoidCallback? onSavePressed; // 콜백 추가
  
  const DetailAppBar({
    super.key,
    required this.flowerId,
    required this.isGuest,
    this.onSavePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(flowerDetailViewModelProvider(flowerId));
    final storageVm = ref.read(storageViewModelProvider);

    // 현재 보관함에 저장되어 있는지 확인
    final bool isSavedInStorage = storageVm.isSaved(flowerId);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 28,
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Row(
            children: [
              IconButton(
                iconSize: 33,
                icon: Icon(
                  // StorageViewModel의 상태에 따라 아이콘 변경
                  isSavedInStorage ? Icons.bookmark : Icons.bookmark_border,
                  color: isSavedInStorage ? Color(0xFF7C4DFF) : Colors.white,
                ),
                onPressed: () async {
                  if(!isGuest) {
                    // 상세 페이지의 꽃 데이터가 로드되었는지 확인
                    final flower = vm.flower;
                    if (flower != null) {
                      if (isSavedInStorage) {
                        // 저장 취소 로직 (다이얼로그 포함 X)
                        await storageVm.deleteFavorite(flower);
                        await vm.toggleFavorite();
                      } else {
                        // 저장 로직 (다이얼로그 포함)
                        await storageVm.saveFlower(flower);
                        await vm.toggleFavorite();


                        // 저장이 완료 되었을 때만 수채화 다이얼로그 띄우기
                        if (context.mounted) {
                          FlowerCustomDialog.show(
                            context,
                            title: '보관함 저장 완료!',
                            content: '선택하신 꽃 정보가\n나의 보관함에 안전하게 담겼습니다.',
                            icon: Icons.bookmark_add,
                          );
                        }
                      }
                    }
                    // (필요 시) 서버 상태 동기화도 함께 수행
                    await vm.toggleFavorite();
                  } else {
                    // 로그인 안 된 경우(게스트): 알림창 띄우기
                    if(context.mounted) {
                      _showLoginDialog(context);
                    }
                  }
                }
              ),
              IconButton(
                iconSize: 28,
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () async {
                  // 공유 버튼 클릭 시 서비스 호출
                  await KakaoShareService.shareFlower(
                      flowerId: flowerId,
                      name: "프리지아",
                      description: '"당신의 시작을 응원합니다. 변치 않는 우정과 순결한 마음을 전해보세요."',
                      imageUrl: "https://images.unsplash.com/photo-1597848212624-a19eb35e2e47?auto=format&fit=crop&q=80&w=500",
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }


// 다이얼로그
void _showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("로그인 필요"),
      content: const Text("로그인 이후 이용 가능합니다.\n 로그인 하시겠습니까?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("아니오"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginView()));
          },
          child: const Text('예'),
        ),
      ],
    ),
  );
  }
}