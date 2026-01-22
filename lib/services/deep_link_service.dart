import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import '../views/flowerDetailView/flowerDetailView.dart';
import '../services/storage/token_storage.dart'; // 토큰 확인을 위해 임포트

class DeepLinkService {
  // context 없이 이동하기 위한 GlobalKey
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> handleDeepLink() async {
    // receiveKakaoScheme()은 String?을 반환하므로 String 변수로 받음
    String? link = await receiveKakaoScheme();

    if (link != null) {
      // 받은 문자열을 Uri 객체로 변환하여 파라미터를 추출
      Uri url = Uri.parse(link);

      if (url.queryParameters.containsKey('flowerId')) {
        String flowerId = url.queryParameters['flowerId']!;

        // 딥링크로 진입할 때 사용자의 로그인 상태를 미리 체크
        // 공유를 받은 사람은 토큰이 없으므로 isGuest = true가 되고
        // 본인이 공유한 링크를 눌렀거나 이미 로그인된 사용자는 isGuest = false가 됨
        final bool isLoggedIn = await TokenStorage().hasTokens();

        // 해당 상세 페이지로 이동
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => FlowerDetailView(
                flowerId: flowerId,
                isGuest: !isLoggedIn,
            ),
          ),
        );
      }
    }
  }
}