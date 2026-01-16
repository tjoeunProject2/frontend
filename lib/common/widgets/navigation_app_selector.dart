import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationAppSelector extends StatelessWidget {
  final double destinationLat;
  final double destinationLng;
  final String destinationName;

  const NavigationAppSelector({
    super.key,
    required this.destinationLat,
    required this.destinationLng,
    required this.destinationName,
  });

  Future<void> _launchNaverMap() async {
    final url = Uri.parse(
      'nmap://route/car?dlat=$destinationLat&dlng=$destinationLng&dname=$destinationName&appname=com.example.frontend',
    );
    final webUrl = Uri.parse(
      'https://map.naver.com/v5/directions/-/-/-/car?c=$destinationLng,$destinationLat,15,0,0,0,dh',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchKakaoMap() async {
    final url = Uri.parse(
      'kakaomap://route?ep=$destinationLat,$destinationLng&by=CAR',
    );
    final webUrl = Uri.parse(
      'https://map.kakao.com/link/to/$destinationName,$destinationLat,$destinationLng',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchGoogleMap() async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 드래그 핸들
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const Text(
            '길찾기 앱 선택',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // 네이버 지도
          _buildAppOption(
            context: context,
            icon: Icons.map,
            iconColor: const Color(0xFF03C75A),
            title: '네이버 지도',
            onTap: () {
              Navigator.pop(context);
              _launchNaverMap();
            },
          ),
          const SizedBox(height: 12),

          // 카카오맵
          _buildAppOption(
            context: context,
            icon: Icons.location_on,
            iconColor: const Color(0xFFFFE812),
            title: '카카오맵',
            onTap: () {
              Navigator.pop(context);
              _launchKakaoMap();
            },
          ),
          const SizedBox(height: 12),

          // 구글 지도
          _buildAppOption(
            context: context,
            icon: Icons.public,
            iconColor: const Color(0xFF4285F4),
            title: '구글 지도',
            onTap: () {
              Navigator.pop(context);
              _launchGoogleMap();
            },
          ),

          const SizedBox(height: 12),

          // 취소 버튼
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '취소',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
