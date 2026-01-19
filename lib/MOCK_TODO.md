# 임시 Mock 데이터 처리 목록

> 백엔드 API 연결 전 임시로 Mock 데이터를 사용하는 부분들입니다.  
> 백엔드 준비 완료 시 주석 해제하고 Mock 코드를 제거하세요.

---

## 📌 Services

### 1. 꽃 검색 임베딩 서비스
**파일**: `lib/services/flower/embeddingService.dart`

- **API 엔드포인트**: `POST /api/test/deepseek/embedding`
- **현재 상태**: Mock 구현
- **Mock 내용**:
  - 1초 딜레이로 API 호출 시뮬레이션
  - `_extractSemanticQuery()` 함수로 간단한 의미 추출 (실제는 백엔드 AI 처리)
  - 768차원 벡터 프리뷰 생성 (임시 값)
- **TODO**:
  - [ ] 17~31번 줄 주석 해제 (실제 API 호출 코드)
  - [ ] 34~40번 줄 Mock 코드 삭제
  - [ ] `_extractSemanticQuery()` 메서드 삭제

---

### 2. 꽃 검색 결과 서비스
**파일**: `lib/services/flower/flower_search_service.dart`

- **API 엔드포인트**: `POST /api/test/deepseek/embedding` (임베딩) + 꽃 검색 API (미정의)
- **현재 상태**: Mock 구현
- **Mock 내용**:
  - 임베딩 API: 1초 딜레이 + 간단한 의미 추출
  - `getMockFlowerResults()`: "졸업" 검색 시 3개 꽃 반환 (프리지아, 해바라기, 백합)
  - 이미지 URL은 빈 문자열 (placeholder 아이콘 표시)
- **TODO**:
  - [ ] 17~31번 줄 주석 해제 (임베딩 API)
  - [ ] 34~40번 줄 Mock 코드 삭제
  - [ ] `getMockFlowerResults()` 메서드를 실제 꽃 검색 API로 교체
  - [ ] 60~108번 줄 Mock 데이터 삭제

---

### 3. 카드 메시지 생성 서비스
**파일**: `lib/services/flower/messageService.dart`

- **API 엔드포인트**: `POST /api/cards/message`
- **현재 상태**: Mock 구현
- **Mock 내용**:
  - 1초 딜레이로 API 호출 시뮬레이션
  - 간단한 템플릿 문자열로 메시지 생성: `"{꽃말}을 상징하는 {꽃이름}처럼, 앞으로의 길도 맑고 빛나길 바랍니다. {상황}을 진심으로 축하합니다."`
- **TODO**:
  - [ ] 20~39번 줄 주석 해제 (실제 API 호출 코드)
  - [ ] 41~47번 줄 Mock 코드 삭제

---

## 📌 UI/UX

### 4. 홈 화면 - 오늘의 꽃 배너
**파일**: `lib/views/homeView/todayFlowerBanner.dart`

- **현재 상태**: 이미지 대신 그라데이션 배경 + 아이콘
- **Mock 내용**:
  - AssetImage 대신 노란색 그라데이션 배경 사용
  - 중앙에 `Icons.local_florist` 아이콘 배치
- **TODO**:
  - [ ] 백엔드에서 실제 꽃 이미지 URL 받아서 `Image.network()` 사용
  - [ ] 또는 assets 폴더에 이미지 추가 후 `Image.asset()` 사용

---

### 5. 검색 결과 - 꽃 카드 이미지
**파일**: `lib/views/searchView/flowerResultCard.dart`

- **현재 상태**: 보라색 그라데이션 배경 + 아이콘
- **Mock 내용**:
  - `flower.imageUrl`이 빈 문자열이면 그라데이션 + 아이콘 표시
  - `Image.network()` errorBuilder로 로드 실패 시 대체 UI 표시
- **TODO**:
  - [ ] 백엔드에서 실제 꽃 이미지 URL 받으면 자동으로 표시됨
  - [ ] Mock 데이터의 `imageUrl`을 빈 문자열에서 실제 URL로 변경

---

## 🔧 Mock 데이터 예시

### 검색 결과 꽃 목록 (졸업 검색 시)
```dart
[
  Flower(
    id: 'flower_1',
    name: 'Freesia',
    koreanName: '프리지아',
    season: '봄',
    occasion: '졸업식',
    tag: '새로운시작',
    imageUrl: '', // ⚠️ 임시: 빈 문자열
    description: '졸업은 끝이 아닌 새로운 시작이죠. ...',
    isLiked: false,
  ),
  // ... 해바라기, 백합
]
```

### 카드 메시지 생성
```
입력:
- flowerName: "프리지아"
- floriography: ["순수", "우정"]
- query: "졸업 축하"

출력:
"순수, 우정을 상징하는 프리지아처럼, 앞으로의 길도 맑고 빛나길 바랍니다. 졸업 축하을 진심으로 축하합니다."
```

---

## 📋 작업 우선순위

1. **높음**: 꽃 검색 API 연결 (임베딩 + 검색 결과)
2. **높음**: 카드 메시지 생성 API 연결
3. **중간**: 실제 꽃 이미지 URL 제공
4. **낮음**: 오늘의 꽃 배너 이미지 추가

---

## ✅ 완료 체크리스트

- [ ] `embeddingService.dart` - 실제 API 연결
- [ ] `flower_search_service.dart` - 실제 API 연결
- [ ] `messageService.dart` - 실제 API 연결
- [ ] 꽃 이미지 URL 제공
- [ ] Mock 코드 제거 완료

---

**마지막 업데이트**: 2026-01-16
