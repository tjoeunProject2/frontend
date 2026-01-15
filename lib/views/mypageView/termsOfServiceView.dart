import 'package:flutter/material.dart';

class TermsOfServiceView extends StatelessWidget {
  const TermsOfServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 이용약관'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '제1조 (목적)',
              '본 약관은 꽃향기(이하 "회사")가 제공하는 꽃 정보 및 꽃집 검색 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제2조 (정의)',
              '1. "서비스"란 회사가 제공하는 꽃 정보 제공, 꽃집 검색, 위치 기반 서비스 등 일체의 서비스를 의미합니다.\n'
              '2. "이용자"란 본 약관에 따라 회사가 제공하는 서비스를 이용하는 회원 및 비회원을 말합니다.\n'
              '3. "회원"이란 회사와 서비스 이용계약을 체결하고 회원 아이디를 부여받은 자를 말합니다.\n'
              '4. "콘텐츠"란 서비스 내에서 제공되는 꽃 이미지, 설명, 꽃집 정보 등 정보 일체를 의미합니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제3조 (약관의 효력 및 변경)',
              '1. 본 약관은 서비스를 이용하고자 하는 모든 이용자에게 그 효력이 발생합니다.\n'
              '2. 회사는 필요한 경우 관련 법령을 위배하지 않는 범위 내에서 본 약관을 변경할 수 있으며, 변경된 약관은 서비스 내 공지사항을 통해 공지합니다.\n'
              '3. 회원이 변경된 약관에 동의하지 않는 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제4조 (회원가입 및 계정)',
              '1. 회원가입은 이용자가 본 약관의 내용에 동의하고, 회사가 정한 가입 양식에 따라 회원정보를 기입하여 신청합니다.\n'
              '2. 회사는 다음 각 호의 경우 회원가입을 거부하거나 사후에 회원자격을 상실시킬 수 있습니다.\n'
              '   - 타인의 명의를 사용하여 신청한 경우\n'
              '   - 허위 정보를 기재한 경우\n'
              '   - 관련 법령을 위반한 경우\n'
              '3. 회원은 자신의 계정 정보를 안전하게 관리할 책임이 있으며, 타인에게 양도 또는 대여할 수 없습니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제5조 (개인정보 보호)',
              '1. 회사는 이용자의 개인정보를 보호하기 위해 개인정보처리방침을 수립하고 이를 준수합니다.\n'
              '2. 회사는 서비스 제공을 위해 필요한 최소한의 개인정보만을 수집하며, 수집된 정보는 서비스 제공 목적 외에는 사용되지 않습니다.\n'
              '3. 개인정보의 수집, 이용, 제공 등에 관한 상세한 내용은 개인정보처리방침을 참조하시기 바랍니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제6조 (서비스의 제공 및 변경)',
              '1. 회사는 다음과 같은 서비스를 제공합니다.\n'
              '   - 꽃 정보 및 이미지 제공\n'
              '   - 주변 꽃집 검색 및 위치 정보 제공\n'
              '   - 꽃 추천 및 개인화 서비스\n'
              '   - 기타 회사가 추가 개발하거나 제휴를 통해 제공하는 서비스\n'
              '2. 회사는 운영상, 기술상의 필요에 따라 제공하는 서비스를 변경할 수 있으며, 변경 전 서비스 내 공지사항을 통해 공지합니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제7조 (서비스의 중단)',
              '1. 회사는 다음 각 호의 경우 서비스의 전부 또는 일부를 일시적으로 중단할 수 있습니다.\n'
              '   - 정보통신설비의 보수점검, 교체, 고장 등의 경우\n'
              '   - 서비스 제공을 위한 시스템 점검이나 업그레이드가 필요한 경우\n'
              '   - 천재지변, 국가비상사태 등 불가항력적인 사유가 있는 경우\n'
              '2. 회사는 사전에 서비스 중단 사실을 공지하며, 불가피한 경우 사후에 통지할 수 있습니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제8조 (이용자의 의무)',
              '1. 이용자는 다음 행위를 하여서는 안 됩니다.\n'
              '   - 타인의 정보를 도용하는 행위\n'
              '   - 회사의 저작권, 제3자의 지적재산권 등 권리를 침해하는 행위\n'
              '   - 공공질서 및 미풍양속에 위반되는 내용을 유포하는 행위\n'
              '   - 서비스의 안정적 운영을 방해하는 행위\n'
              '   - 허위 정보를 게시하거나 부정한 방법으로 서비스를 이용하는 행위\n'
              '2. 이용자는 관련 법령, 본 약관, 서비스 이용안내 및 공지사항 등을 준수하여야 합니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제9조 (손해배상 및 면책)',
              '1. 회사는 무료로 제공되는 서비스와 관련하여 이용자에게 발생한 손해에 대해서는 책임을 지지 않습니다.\n'
              '2. 회사는 천재지변, 전쟁, 기간통신사업자의 서비스 중지 등 불가항력으로 인하여 서비스를 제공할 수 없는 경우 책임이 면제됩니다.\n'
              '3. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여 책임을 지지 않습니다.\n'
              '4. 이용자가 본 약관을 위반하여 회사에 손해가 발생한 경우, 이용자는 그 손해를 배상할 책임이 있습니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제10조 (분쟁 해결)',
              '1. 회사와 이용자 간 발생한 분쟁에 관한 소송은 민사소송법상의 관할법원에 제기합니다.\n'
              '2. 회사와 이용자 간 제기된 소송에는 대한민국 법을 적용합니다.',
            ),
            const SizedBox(height: 24),
            _buildEffectiveDate(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B4EFF),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildEffectiveDate() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '부칙',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4EFF),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '본 약관은 2026년 1월 1일부터 시행됩니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
