import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class KakaoShareService {
  static Future<void> shareFlower({
    required String flowerId,
    required String name,
    required String description,
    required String imageUrl,
}) async {
    // 카카오톡 실행 가능 여부 확인
    bool isKakaoTalkSharingAvailable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    // 공유할 메시지 템플릿 정의
    final FeedTemplate defaultFeed = FeedTemplate(
        content: Content(
          title: '🌸 Florit 추천: $name',
          description: description,
          imageUrl: Uri.parse(imageUrl),
          link: Link(
            androidExecutionParams: {'flowerId':flowerId}, // 딥링크용 파라미터
          ),
        ),
        buttons: [
          Button(
              title: '꽃 정보 확인하기',
              link: Link(
                androidExecutionParams: {'flowerId': flowerId},
              ),
          ),
        ],
    );
    
    // 카카오톡 공유 실행
    try {
      if (isKakaoTalkSharingAvailable) {
        Uri uri = await ShareClient.instance.shareDefault(template: defaultFeed);
        await ShareClient.instance.launchKakaoTalk(uri);
      } else {
        // 카카오톡 미설치 시 웹 브라우저로 공유
        Uri shareUrl = await WebSharerClient.instance.makeDefaultUrl(template: defaultFeed);
        await launchBrowserTab(shareUrl);
      }
    } catch (e) {
      print('카카오톡 공유 에러 : $e');
    }
  }
}