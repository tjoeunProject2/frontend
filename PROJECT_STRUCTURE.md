# 프로젝트 파일 구조

## 📁 루트 디렉토리

```
frontend/
├── lib/                          # 앱 소스 코드
├── android/                      # Android 네이티브 설정
├── ios/                          # iOS 네이티브 설정
├── build/                        # 빌드 산출물 (자동 생성)
├── pubspec.yaml                  # Flutter 프로젝트 설정 및 의존성
├── flowerApi.yaml                # 백엔드 API 명세서 (OpenAPI 3.0.3)
├── analysis_options.yaml         # Dart 린트 규칙
└── README.md                     # 프로젝트 설명
```

---

## 📱 lib/ - 앱 소스 코드

### 🎯 app/
```
app/
├── app.dart                      # 앱 메인 위젯 (MaterialApp 설정)
└── routes.dart                   # 앱 라우팅 설정
```

### 🎨 views/ - UI 화면
```
views/
├── rootShell.dart                # 하단 네비게이션 바 (홈/지도/검색/보관함/마이페이지)
├── startView.dart                # 앱 시작 화면
│
├── user/                         # 사용자 인증
│   ├── loginView.dart            # 로그인 화면
│   └── registerView.dart         # 회원가입 화면
│
├── homeView/                     # 홈 화면
│   ├── homeView.dart             # 메인 홈 화면
│   ├── homeHeader.dart           # 상단 헤더
│   ├── homeTitle.dart            # 타이틀 위젯
│   ├── seasonalFlowerCard.dart   # 계절별 꽃 카드
│   └── todayFlowerBanner.dart    # 오늘의 꽃 배너
│
├── mapView/                      # 지도 화면 (리팩토링됨)
│   ├── mapView.dart              # 메인 지도 화면
│   ├── mapSearchBar.dart         # 상단 검색바
│   ├── mapErrorMessage.dart      # 에러 메시지
│   ├── myLocationButton.dart     # 내 위치 버튼
│   ├── shopBottomSheet.dart      # 간략 꽃집 정보 시트
│   └── expandedShopSheet.dart    # 확장 꽃집 정보 시트
│
├── searchView/                   # 검색 화면
│   ├── searchView.dart           # 메인 검색 화면 (초기/결과 화면)
│   ├── categoryCard.dart         # 카테고리 카드 (분위기별/꽃말별)
│   ├── searchBackground.dart     # 검색 화면 배경 그라데이션
│   ├── searchChips.dart          # 최근 검색어/인기 키워드 칩
│   └── searchHeader.dart         # 검색 헤더
│
├── storageView/                  # 보관함 화면
│   ├── storageView.dart          # 메인 보관함 화면
│   ├── storageCard.dart          # 보관함 아이템 카드
│   ├── storageFilterTab.dart     # 필터 탭
│   └── storageHeader.dart        # 보관함 헤더
│
└── mypageView/                   # 마이페이지
    ├── mypageView.dart           # 메인 마이페이지
    ├── profileCard.dart          # 프로필 카드
    ├── profileView.dart          # 프로필 상세/수정
    ├── menuItem.dart             # 메뉴 아이템
    ├── notificationView.dart     # 알림 설정 (오후 6시 알림)
    ├── likedShopsView.dart       # 좋아요한 꽃집 목록
    ├── likedFlowersView.dart     # 좋아요한 꽃 목록
    ├── privacyPolicyView.dart    # 개인정보 처리방침
    ├── reportBugView.dart        # 버그 신고
    ├── termsOfServiceView.dart   # 서비스 이용약관
    └── settingsView/             # 설정
        ├── settingsView.dart         # 설정 메인 화면
        ├── settingMenuItem.dart      # 설정 메뉴 아이템
        ├── settingSectionTitle.dart  # 설정 섹션 타이틀
        ├── settingSwitchItem.dart    # 설정 스위치 아이템
        └── settingsDialogs.dart      # 설정 다이얼로그들
```

### 🧠 viewmodels/ - 상태 관리 (Riverpod)
```
viewmodels/
├── find_email_vm.dart            # 이메일 찾기 상태 관리
├── home_vm.dart                  # 홈 화면 상태 관리
├── liked_flowers_vm.dart         # 좋아요한 꽃 상태
├── liked_shops_vm.dart           # 좋아요한 꽃집 상태
├── login_vm.dart                 # 로그인 상태 관리
├── map_vm.dart                   # 지도 및 꽃집 데이터 관리
├── mypage_vm.dart                # 마이페이지 네비게이션
├── navigation_vm.dart            # 전역 하단 네비게이션 상태
├── notification_settings_vm.dart # 알림 설정 상태
├── profile_vm.dart               # 프로필 상태 관리
├── register_vm.dart              # 회원가입 상태 관리
├── search_vm.dart                # 검색 상태 및 결과 관리
├── settings_vm.dart              # 설정 상태 관리
└── storage_vm.dart               # 보관함 상태 관리
```

### 📦 models/ - 데이터 모델
```
models/
├── bugReport.dart                # 버그 신고 모델
├── favorite.dart                 # 즐겨찾기 모델
├── flower.dart                   # 꽃 모델
├── flowerShop.dart               # 꽃집 모델
├── settingsModel.dart            # 설정 모델
├── user.dart                     # 사용자 모델
└── viewHistory.dart              # 조회 기록 모델
```

### 🔧 services/ - 비즈니스 로직 & API
```
services/
├── notification_service.dart     # 로컬 알림 서비스 (매일 오후 6시)
│
├── auth/                         # 인증 관련 API
│   ├── authInterceptor.dart      # HTTP 인터셉터 (토큰 자동 추가)
│   ├── loginService.dart         # 로그인 API
│   ├── signupService.dart        # 회원가입 API
│   ├── logoutService.dart        # 로그아웃 API
│   ├── refreshService.dart       # 토큰 갱신 API
│   ├── findEmailService.dart     # 이메일 찾기 API
│   ├── checkEmailService.dart    # 이메일 중복 확인 API
│   └── checkNicknameService.dart # 닉네임 중복 확인 API
│
├── flowers/                      # 꽃 정보 관련 API
│   ├── getAllFlowersService.dart        # 전체 꽃 목록 조회 API
│   ├── getTodayFlowerService.dart       # 오늘의 꽃 조회 API
│   ├── getSeasonFlowersService.dart     # 계절별 꽃 조회 API
│   ├── getFlowerDetailService.dart      # 꽃 상세 정보 조회 API
│   ├── searchFlowerByKeywordService.dart # 키워드로 꽃 검색 API
│   └── searchFlowerByNameService.dart   # 이름으로 꽃 검색 API
│
├── search/                       # 검색 관련 API
│   ├── semanticSearchService.dart       # 시맨틱 검색 API
│   ├── getRecentSearchService.dart      # 최근 검색어 조회 API
│   ├── deleteSearchService.dart         # 검색어 삭제 API
│   ├── deleteAllSearchService.dart      # 검색어 전체 삭제 API
│   └── embeddingService.dart            # 검색어 임베딩 생성 API
│
├── favorites/                    # 즐겨찾기 관련 API
│   ├── getFavoritesService.dart         # 즐겨찾기 목록 조회 API
│   ├── addFavoriteService.dart          # 즐겨찾기 추가 API
│   ├── deleteFavoriteService.dart       # 즐겨찾기 삭제 API
│   └── checkFavoriteService.dart        # 즐겨찾기 여부 확인 API
│
├── viewHistory/                  # 조회 기록 관련 API
│   ├── getViewHistoryService.dart       # 조회 기록 목록 API
│   ├── addViewHistoryService.dart       # 조회 기록 저장 API
│   ├── deleteViewHistoryService.dart    # 조회 기록 삭제 API
│   └── deleteAllViewHistoryService.dart # 조회 기록 전체 삭제 API
│
├── cards/                        # 카드 메시지 관련 API
│   └── generateCardMessageService.dart  # AI 카드 메시지 생성 API
│
├── location/                     # 위치 서비스
│   └── location_service.dart     # 현재 위치 가져오기
│
├── shops/                        # 꽃집 관련 API
│   └── nearbyService.dart        # 주변 꽃집 검색 API
│
└── storage/                      # 로컬 저장소
    └── token_storage.dart        # JWT 토큰 저장 (flutter_secure_storage)
```

### 🧩 common/ - 공통 컴포넌트
```
common/
├── app_colors.dart               # 앱 색상 정의
│
├── errors/                       # 에러 처리
│   ├── api_error.dart            # API 에러 모델
│   ├── app_error.dart            # 앱 에러 모델
│   └── error_mapper.dart         # 에러 매핑 유틸
│
└── widgets/                      # 공통 위젯
    ├── error_widget.dart         # 공통 에러 위젯
    ├── navigate.dart             # 네비게이션 유틸
    ├── navigation_app_selector.dart # 길찾기 앱 선택 시트
    ├── notification_widget.dart  # 공통 알림 위젯
    ├── search_widget.dart        # 검색 입력 위젯 (재사용)
    └── textField.dart            # 공통 텍스트 필드
```

---

## 📄 문서 파일

```
lib/
├── TODO.md                       # 전체 프로젝트 TODO 리스트
└── MOCK_TODO.md                  # Mock 데이터 처리 목록 (백엔드 연결 대기)
```

---

## 🔑 주요 기능별 파일 위치

### 🔐 사용자 인증
- `views/user/loginView.dart` - 로그인 UI
- `views/user/registerView.dart` - 회원가입 UI
- `viewmodels/login_vm.dart` - 로그인 상태 관리
- `viewmodels/register_vm.dart` - 회원가입 상태 관리
- `viewmodels/find_email_vm.dart` - 이메일 찾기 상태 관리
- `services/auth/loginService.dart` - 로그인 API
- `services/auth/signupService.dart` - 회원가입 API
- `services/auth/findEmailService.dart` - 이메일 찾기 API
- `services/storage/token_storage.dart` - JWT 토큰 저장

### 🌸 꽃 검색 기능
- `views/searchView/searchView.dart` - UI
- `viewmodels/search_vm.dart` - 상태 관리
- `models/flower.dart` - 꽃 모델

### 🗺️ 지도 & 꽃집 기능
- `views/mapView/mapView.dart` - 지도 UI
- `viewmodels/map_vm.dart` - 지도 상태 관리
- `models/flower_shop.dart` - 꽃집 모델
- `services/shops/nearbyService.dart` - 주변 꽃집 API
- `services/location/location_service.dart` - 위치 서비스
- `viewmodels/liked_shops_vm.dart` - 좋아요한 꽃집

### 💖 좋아요 기능
- `viewmodels/liked_flowers_vm.dart` - 좋아요한 꽃
- `viewmodels/liked_shops_vm.dart` - 좋아요한 꽃집
- `views/mypageView/likedFlowersView.dart` - 좋아요한 꽃 목록
- `views/mypageView/likedShopsView.dart` - 좋아요한 꽃집 목록

### 🔔 알림 기능
- `services/notification_service.dart` - 로컬 알림 (매일 오후 6시)
- `viewmodels/notification_settings_vm.dart` - 알림 설정 상태
- `views/mypageView/notificationView.dart` - 알림 설정 UI

### 🏠 홈 화면
- `views/homeView/homeView.dart` - 홈 메인 UI
- `viewmodels/home_vm.dart` - 홈 상태 관리
- `views/homeView/todayFlowerBanner.dart` - 오늘의 꽃 배너

### 📦 보관함
- `views/storageView/storageView.dart` - 보관함 UI
- `viewmodels/storage_vm.dart` - 보관함 상태 관리

### ⚙️ 설정 & 마이페이지
- `views/mypageView/mypageView.dart` - 마이페이지 메인
- `views/mypageView/profileView.dart` - 프로필 수정
- `views/mypageView/settingsView/settingsView.dart` - 설정 화면
- `viewmodels/profile_vm.dart` - 프로필 상태
- `viewmodels/settings_vm.dart` - 설정 상태
- `models/settingsModel.dart` - 설정 모델

---

## 🔄 상태 관리 구조 (Riverpod)

```
Provider 종류:
- ChangeNotifierProvider: 대부분의 ViewModel에서 사용
- StateProvider: 간단한 상태 (필요시)
- FutureProvider: 비동기 데이터 (필요시)

주요 Provider:
- findEmailViewModelProvider
- homeViewModelProvider
- likedFlowersViewModelProvider
- likedShopsViewModelProvider
- loginViewModelProvider
- mapViewModelProvider
- myPageViewModelProvider
- navigationViewModelProvider
- notificationSettingsProvider
- profileViewModelProvider
- registerViewModelProvider
- searchViewModelProvider
- settingsViewModelProvider
- storageViewModelProvider
```
## 🎯 API 엔드포인트 (swagger.yaml)

```
인증 (Auth):
- POST /api/auth/signup              # 회원가입
- POST /api/auth/login               # 로그인
- POST /api/auth/refresh             # 토큰 갱신
- POST /api/auth/logout              # 로그아웃
- POST /api/auth/find-email          # 이메일 찾기
- POST /api/auth/reset-password      # 비밀번호 재설정
- POST /api/auth/check-email         # 이메일 중복 확인
- POST /api/auth/check-nickname      # 닉네임 중복 확인

꽃 정보 (Flowers):
- GET  /api/flowers                  # 전체 꽃 목록 조회
- GET  /api/flowers/today            # 오늘의 꽃 조회
- GET  /api/flowers/season           # 계절별 꽃 조회
- GET  /api/flowers/{flowerId}       # 꽃 상세 정보 조회
- GET  /api/flowers/keyword          # 키워드로 꽃 검색
- GET  /api/flowers/search           # 꽃 이름 검색

검색 (Search):
- POST /api/search                   # 시맨틱 검색
- GET  /api/search/recent            # 최근 검색어 조회
- DELETE /api/search/recent          # 검색어 삭제
- DELETE /api/search/recent/all      # 검색어 전체 삭제
- POST /api/test/deepseek/embedding  # 검색어 임베딩 생성

즐겨찾기 (Favorites):
- GET  /api/favorites                # 즐겨찾기 목록 조회
- POST /api/favorites                # 즐겨찾기 추가
- DELETE /api/favorites/{flowerId}   # 즐겨찾기 삭제
- GET  /api/favorites/check/{flowerId} # 즐겨찾기 여부 확인

조회 기록 (View History):
- GET  /api/view-history             # 조회 기록 목록
- POST /api/view-history             # 조회 기록 저장
- DELETE /api/view-history/{viewId}  # 조회 기록 삭제
- DELETE /api/view-history           # 조회 기록 전체 삭제

꽃집 (Shops):
- GET  /api/shops/nearby             # 주변 꽃집 검색

카드 메시지 (Cards):
- POST /api/cards/message            # AI 카드 메시지 생성
```
꽃집:
- GET  /api/shops/nearby          # 주변 꽃집 검색
```

---

## 📱 네비게이션 구조

```
RootShell (하단 네비게이션)
├── HomeView          # 홈
├── MapView           # 지도
├── SearchView        # 검색
├── StorageView       # 보관함
└── MyPageView        # 마이페이지
    ├── ProfileView
    ├── NotificationView
    ├── LikedShopsView
    ├── LikedFlowersView
    └── SettingsView
```

---

## 🎨 디자인 시스템

```
주요 색상:
- Primary: #7C4DFF (보라색)
- Background: #F8F9FA (연한 회색)
- White: #FFFFFF
- Error: Red[700]

아이콘:
- Material Icons 사용
- 주요: local_florist, favorite, map, search, person
```

---

**마지막 업데이트**: 2026-01-19
