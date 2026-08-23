# ARCHITECTURE.md

## 1. 기술 스택

### Client
- Flutter
- Dart
- Riverpod
- go_router
- freezed
- json_serializable
- SharedPreferences

### Backend / BaaS
- Supabase
  - PostgreSQL
  - Auth
  - Storage
  - Realtime
  - Edge Functions
  - Cron

### Firebase
- FCM
- Crashlytics
- Analytics
- Android 테스트 배포: Firebase App Distribution

### iOS 테스트 배포
- TestFlight

### 광고/결제
- Google AdMob
- RevenueCat (정식 출시 시 광고 제거 결제)

### CI/CD
- GitHub
- GitHub Actions

---

## 2. 전체 구성

```text
Flutter App
   |
   +-- Riverpod
   |
   +-- Repository Layer
   |      |
   |      +-- Supabase Auth
   |      +-- PostgreSQL + RLS
   |      +-- Supabase Storage
   |      +-- Supabase Realtime
   |
   +-- FCM
   +-- Crashlytics
   +-- Analytics
   +-- AdMob
   +-- RevenueCat (launch stage)

Supabase
   |
   +-- Edge Functions
   |      +-- Push delivery
   |      +-- Sensitive/server-only operations
   |
   +-- Cron
          +-- Expiration reminder scheduler
```

별도의 Spring Boot 서버는 두지 않는다.

---

## 3. Flutter 아키텍처

### Feature-first

```text
lib/
  app/
    router/
    theme/
    localization/
  core/
    constants/
    errors/
    utils/
    widgets/
  features/
    auth/
    space/
    floor_plan/
    location/
    item/
    shopping/
    checklist/
    recipe/
    notification/
    settings/
```

### 데이터 흐름

```text
UI
 ↓
Riverpod Provider / Controller
 ↓
Repository
 ↓
Supabase
```

UI 또는 Provider에서 Supabase 쿼리를 직접 작성하지 않는다.

---

## 4. Repository 패턴

예:

```text
SpaceRepository
FloorPlanRepository
LocationRepository
ItemRepository
ShoppingRepository
ChecklistRepository
RecipeRepository
NotificationRepository
```

Repository 책임:
- Supabase 쿼리
- DTO/model 변환
- pagination/filter/search
- storage upload/delete
- 오류 변환

Provider 책임:
- 화면 상태
- 비동기 상태 조합
- 사용자 액션 처리
- Repository 호출

---

## 5. 모델

- `freezed + json_serializable`
- immutable model
- `copyWith`
- JSON 직렬화 자동 생성

DB Row와 화면 전용 ViewModel을 필요 이상으로 동일 객체로 강제하지 않는다.

---

## 6. 라우팅

`go_router` 사용.

필수 지원:
- 인증 상태 리다이렉트
- 소셜 로그인 callback
- 초대 링크 딥링크
- 공간 선택
- 공간 내부 ShellRoute
- 하단 탭

공간 내부 기본 탭:
1. Home
2. Floor Plan
3. Shopping
4. Checklist
5. More

---

## 7. 인증

MVP 로그인:
- Kakao
- Naver
- Google
- Apple

Supabase Auth를 기본으로 사용.
네이버는 Supabase 기본 Provider 지원 여부와 실제 구현 시점의 최신 OAuth/OIDC 지원 방식을 확인 후 Custom OAuth/OIDC 방식으로 연동한다.

계정 연결:
- 가능한 범위에서 자동 identity linking
- 사용자가 수동 연결 가능

---

## 8. 로컬 저장

SharedPreferences 사용.

역할:
- 마지막 UI 상태 캐시
- 테마 캐시
- 홈 바로가기 캐시
- 사용자 설정 빠른 로딩

권위 있는 원본(source of truth)은 Supabase.

오프라인 편집/동기화는 MVP에서 지원하지 않는다.

---

## 9. 평면도 구현

### Flutter 렌더링
- `CustomPainter`
- `InteractiveViewer`
- Gesture handling
- Drag & drop

### 저장
`floor_plans.layout_data JSONB`

예시 개념:

```json
{
  "grid": {"rows": 20, "cols": 20},
  "activeCells": [],
  "walls": [],
  "rooms": [
    {
      "id": "...",
      "name": "욕실",
      "color": "...",
      "cells": []
    }
  ]
}
```

Location은 JSONB 내부가 아니라 별도 테이블.

### Undo / Redo
저장 전 편집 command/state history로 구현.

---

## 10. 이미지

### 업로드 흐름

```text
Camera/Gallery
  ↓
Client resize/compress
  ↓
Supabase Private Storage Bucket
  ↓
item_photos row
```

- 물건당 최대 3장
- 대표 사진 지정 가능
- 원본 대용량 그대로 저장하지 않음
- 사진 개별 삭제는 즉시 Storage 삭제
- 물건 Soft Delete 시 사진은 30일 유지

---

## 11. Realtime

Realtime 적용 대상:
- 장보기 목록
- 공유 체크리스트
- 공간 멤버 변경

MVP에서 Realtime 비적용:
- 일반 물건 CRUD
- 평면도
- 레시피

이들은 저장 후 refresh 방식.

---

## 12. 동시 수정

주요 데이터에 `updated_at` 또는 `version` 사용.

권장 방식:

```text
1. 사용자가 편집 시작 시 version 기억
2. UPDATE ... WHERE id = ? AND version = ?
3. 성공 시 version + 1
4. 0 row updated면 conflict
```

또는 updated_at optimistic concurrency 방식.

우선 적용 대상:
- floor_plans
- items
- locations
- shared checklists

---

## 13. 푸시 알림

FCM 사용.

### 즉시 알림
예:
- 장보기 항목 할당
- 공간 초대
- 관리자 변경

### 예약 알림
Supabase Cron + Edge Function:

```text
Cron
 ↓
Reminder query
 ↓
Edge Function
 ↓
FCM
```

기한 알림은 앱 로컬 알림에 의존하지 않는다.

---

## 14. Analytics / Crash

### Firebase Analytics
수집 가능한 이벤트 예:
- space_created
- item_created
- item_searched
- floor_plan_opened
- shopping_item_added
- checklist_completed

금지:
- 실제 item_name
- search_keyword
- memo
- private user content

### Crashlytics
- uncaught Flutter errors
- async errors
- custom non-PII diagnostics

---

## 15. 광고

AdMob:
- Banner
- Interstitial

전면광고는 큰 작업 완료 후 제한적으로만 표시.
광고 빈도 제한 로직을 공통 서비스로 관리한다.

예:
```text
AdPolicyService
- lastInterstitialAt
- completedMajorActionCount
- canShowInterstitial()
```

---

## 16. 결제

MVP에는 실제 결제 구현 제외.
정식 출시 단계에서 RevenueCat 도입.

- entitlement: `ad_free`
- account-level access
- 동일 계정 Android/iOS 광고 제거 공유

구매 상태는 RevenueCat + 서버 측 상태 캐시를 조합할 수 있다.
스토어 정책상 플랫폼 간 entitlement 처리 방식은 출시 시점의 Apple/Google/RevenueCat 정책을 다시 확인한다.

---

## 17. 다국어

Flutter Localization 사용.
한국어만 실제 제공하더라도 모든 사용자 노출 문자열은 ARB 등에 둔다.

예:
```text
lib/l10n/app_ko.arb
```

하드코딩 금지.

---

## 18. 환경 분리

Supabase:
- dev
- prod

Firebase도 개발/운영 분리를 권장한다.

환경 변수:
```text
SUPABASE_URL
SUPABASE_ANON_KEY
FIREBASE_OPTIONS
ADMOB_IDS
REVENUECAT_PUBLIC_KEY
```

Service Role Key는 앱에 포함하지 않는다.

---

## 19. CI/CD

GitHub Actions 예시:

### dev PR/push
- `flutter analyze`
- `flutter test`
- code generation check
- migration lint/check

### main merge
- test
- Android build
- iOS build preparation
- release artifact generation

운영 배포 자동화 수준은 스토어 서명/정책에 맞춰 단계적으로 적용한다.

---

## 20. 테스트 배포

Android:
- Firebase App Distribution

iOS:
- TestFlight

팀원 실제 기기에서 로그인/딥링크/푸시/광고/결제를 플랫폼별로 검증한다.

---

## 21. 운영

MVP에서는 별도 관리자 웹을 개발하지 않는다.
Supabase Dashboard로 관리:
- 공지
- 최소 지원 버전
- 데이터 점검

관리 UI가 실제로 필요해지면 후속 개발.
