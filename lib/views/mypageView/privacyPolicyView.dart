import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 처리방침'),
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
              '제1조 (개인정보의 처리 목적)',
              '꽃향기(이하 "회사")는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 관련 법령에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n\n'
              '1. 회원 가입 및 관리\n회원 가입 의사 확인, 회원제 서비스 제공, 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지, 각종 고지·통지 목적으로 개인정보를 처리합니다.\n\n'
              '2. 서비스 제공\n꽃 정보 제공, 꽃집 검색 및 위치 서비스, 맞춤형 서비스 제공, 본인인증을 목적으로 개인정보를 처리합니다.\n\n'
              '3. 마케팅 및 광고 활용\n신규 서비스 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여 기회 제공, 인구통계학적 특성에 따른 서비스 제공 및 광고 게재 등을 목적으로 개인정보를 처리합니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제2조 (처리하는 개인정보의 항목)',
              '회사는 다음의 개인정보 항목을 처리하고 있습니다.\n\n'
              '1. 필수 항목\n'
              '   - 이메일 주소, 비밀번호, 닉네임\n'
              '   - 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보\n\n'
              '2. 선택 항목\n'
              '   - 프로필 이미지, 생년월일\n'
              '   - 위치정보 (서비스 이용 시)\n\n'
              '3. 자동 수집 항목\n'
              '   - 서비스 이용 기록, 접속 로그, IP 주소, 쿠키, 기기 정보',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제3조 (개인정보의 처리 및 보유 기간)',
              '1. 회사는 법령에 따른 개인정보 보유·이용 기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용 기간 내에서 개인정보를 처리·보유합니다.\n\n'
              '2. 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.\n'
              '   - 회원 가입 및 관리: 회원 탈퇴 시까지\n'
              '   - 서비스 제공: 서비스 종료 시까지\n'
              '   - 부정 이용 기록: 회원 탈퇴 후 1년\n\n'
              '3. 관계 법령에 따라 보존할 필요가 있는 경우\n'
              '   - 계약 또는 청약철회 등에 관한 기록: 5년 (전자상거래법)\n'
              '   - 대금결제 및 재화 등의 공급에 관한 기록: 5년 (전자상거래법)\n'
              '   - 소비자의 불만 또는 분쟁처리에 관한 기록: 3년 (전자상거래법)\n'
              '   - 웹사이트 방문 기록: 3개월 (통신비밀보호법)',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제4조 (개인정보의 제3자 제공)',
              '회사는 정보주체의 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 개인정보 보호법 제17조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.\n\n'
              '현재 회사는 개인정보를 제3자에게 제공하지 않습니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제5조 (개인정보 처리의 위탁)',
              '회사는 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.\n\n'
              '현재 회사는 개인정보 처리를 위탁하지 않습니다. 향후 위탁이 필요한 경우 사전에 고지하겠습니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제6조 (정보주체의 권리·의무 및 행사방법)',
              '1. 정보주체는 회사에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.\n'
              '   - 개인정보 열람 요구\n'
              '   - 오류 등이 있을 경우 정정 요구\n'
              '   - 삭제 요구\n'
              '   - 처리정지 요구\n\n'
              '2. 제1항에 따른 권리 행사는 회사에 대해 서면, 전화, 전자우편 등을 통하여 하실 수 있으며 회사는 이에 대해 지체없이 조치하겠습니다.\n\n'
              '3. 정보주체가 개인정보의 오류 등에 대한 정정 또는 삭제를 요구한 경우에는 회사는 정정 또는 삭제를 완료할 때까지 당해 개인정보를 이용하거나 제공하지 않습니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제7조 (개인정보의 파기)',
              '1. 회사는 개인정보 보유 기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n\n'
              '2. 개인정보 파기의 절차 및 방법은 다음과 같습니다.\n'
              '   - 파기절차: 불필요하게 된 개인정보를 선정하고, 개인정보 보호책임자의 승인을 받아 파기합니다.\n'
              '   - 파기방법: 전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제하고, 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각합니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제8조 (개인정보의 안전성 확보조치)',
              '회사는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.\n\n'
              '1. 관리적 조치: 내부관리계획 수립·시행, 정기적 직원 교육 등\n'
              '2. 기술적 조치: 개인정보처리시스템 등의 접근권한 관리, 접근통제시스템 설치, 고유식별정보 등의 암호화, 보안프로그램 설치\n'
              '3. 물리적 조치: 전산실, 자료보관실 등의 접근통제',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제9조 (개인정보 보호책임자)',
              '회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.\n\n'
              '개인정보 보호책임자\n'
              '- 성명: 홍길동\n'
              '- 직책: 개인정보보호팀장\n'
              '- 연락처: privacy@flowerhyang.com\n\n'
              '정보주체는 회사의 서비스를 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자에게 문의하실 수 있습니다.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              '제10조 (개인정보 처리방침의 변경)',
              '이 개인정보 처리방침은 2026년 1월 1일부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.',
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
            '시행일자',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4EFF),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '본 개인정보 처리방침은 2026년 1월 1일부터 시행됩니다.',
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
