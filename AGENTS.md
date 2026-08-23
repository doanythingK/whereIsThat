# AGENTS.md

## 목적
이 문서는 AI 코딩 에이전트가 **“엄마 이거 어딨어?”** 프로젝트에서 반드시 따라야 하는 작업 규칙을 정의한다.

> 충돌 시 우선순위: **현재 사용자 요청 > 이 문서 > PRODUCT_REQUIREMENTS.md > ARCHITECTURE.md > DATABASE.md > MVP_SCOPE.md > ROADMAP.md**

---

## 1. 프로젝트 기본 원칙

- 모바일 앱은 **Flutter**로 개발한다.
- 상태관리는 **Riverpod**을 사용한다.
- 라우팅은 **go_router**를 사용한다.
- 백엔드는 별도 Spring 서버 없이 **Supabase 중심**으로 구성한다.
- 기본 CRUD는 `Flutter -> Repository -> Supabase` 구조로 처리한다.
- 민감 로직, 서버 스케줄링, 푸시 발송 등 필요한 경우에만 Supabase Edge Functions를 사용한다.
- 데이터 접근 권한은 반드시 **Supabase RLS**로 서버 레벨에서 강제한다.
- 프로젝트는 **Feature-first** 구조를 유지한다.
- 화면 또는 Provider에서 Supabase 클라이언트를 직접 호출하지 않는다.
- 데이터 모델은 `freezed + json_serializable`을 기본으로 한다.
- 화면 문자열은 하드코딩하지 않고 Flutter Localization 리소스로 관리한다.

---

## 2. AI 작업 규칙

### 작업 전
1. 관련 문서를 먼저 읽는다.
2. 기존 구조를 확인한다.
3. 이미 존재하는 구현을 재사용할 수 있는지 확인한다.
4. DB 스키마 또는 RLS 변경이 필요한 경우 `DATABASE.md`와 migration을 함께 갱신한다.
5. 기능 범위가 MVP인지 후속 기능인지 `MVP_SCOPE.md`에서 확인한다.

### 작업 중
- 임의로 새로운 아키텍처 패턴을 도입하지 않는다.
- 기능 하나를 구현하기 위해 불필요하게 전역 구조를 리팩터링하지 않는다.
- 임의의 패키지 추가를 최소화한다.
- 새 패키지를 추가하는 경우 실제 필요성과 유지보수 가능성을 먼저 확인한다.
- UI 코드에 DB 쿼리를 작성하지 않는다.
- Repository 밖에서 Supabase 테이블 CRUD를 직접 호출하지 않는다.
- 서비스 비밀키, Service Role Key, 스토어 키 등 비밀정보를 클라이언트에 넣지 않는다.
- RLS 우회 목적으로 클라이언트에서 Service Role Key를 사용하지 않는다.
- 삭제는 해당 도메인의 Soft Delete 정책을 확인한 뒤 구현한다.
- 사용자 콘텐츠(물건명, 검색어, 메모 등)를 Analytics 이벤트 파라미터로 전송하지 않는다.

### 작업 후
- 변경된 기능에 대응하는 테스트를 추가하거나 수정한다.
- 최소한 핵심 로직, 권한, RLS 관련 테스트를 검토한다.
- 관련 문서가 구현과 달라졌다면 같은 작업에서 문서도 업데이트한다.
- migration이 있으면 dev 환경에서 검증한 뒤 main에 반영한다.

---

## 3. 브랜치 및 배포 규칙

- GitHub 사용.
- 기본 작업 브랜치: `dev`
- 운영 브랜치: `main`
- 검증된 변경만 `main`에 병합한다.
- `main`을 기준으로 운영 배포를 준비한다.
- GitHub Actions에서 테스트 및 migration 검증을 수행한다.
- 운영 Supabase DB를 직접 실험용으로 사용하지 않는다.
- Supabase 프로젝트는 `dev` / `prod`로 분리한다.

---

## 4. Flutter 구조 규칙

권장 디렉터리 예시:

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

각 feature 내부는 필요에 따라 다음 정도로 나눈다.

```text
feature_name/
  data/
    models/
    repositories/
  application/
    providers/
  presentation/
    pages/
    widgets/
```

규칙:
- 과도한 Clean Architecture 계층 분리는 피한다.
- Repository는 실제 데이터 접근 책임을 가진다.
- Riverpod Provider는 상태/유스케이스 조합을 담당한다.
- UI는 표시와 사용자 입력 처리에 집중한다.

---

## 5. Supabase 규칙

- PK는 UUID를 기본으로 한다.
- Auth 사용자 ID도 UUID로 연결한다.
- 공간 공유 데이터는 `space_id`를 가진다.
- 공간 접근 가능 여부는 `space_members`를 기준으로 RLS에서 검사한다.
- 관리자 기능은 `space_members.role = 'admin'`을 추가 확인한다.
- 개인 물건 등 private 데이터는 작성자/소유자의 Auth UID를 추가 확인한다.
- Storage는 Private Bucket을 사용한다.
- 파일 접근은 권한 검증 후 Signed URL 또는 적절한 Storage 정책으로 처리한다.
- 평면도 구조 데이터는 JSONB를 사용할 수 있으나, 물건/위치/체크리스트/레시피 등 주요 도메인은 정규 테이블로 관리한다.

---

## 6. 동시 수정 규칙

- 주요 엔터티는 `updated_at` 또는 `version`으로 충돌을 감지한다.
- 사용자가 편집을 시작한 뒤 다른 사용자가 먼저 수정했다면 무조건 덮어쓰지 않는다.
- 충돌 시 최신 데이터 확인/재시도 흐름을 제공한다.
- 특히 평면도와 물건 정보는 마지막 저장 우선 방식만으로 처리하지 않는다.

---

## 7. 삭제 규칙

주요 도메인은 Soft Delete를 기본으로 한다.

- 물건: 30일 휴지통 후 영구 삭제
- 공간: 30일 복구 가능 후 영구 삭제
- 평면도: 30일 복구 가능
- 위치 아이콘: 30일 복구 가능
- 사진을 사용자가 개별 삭제: 즉시 Storage에서도 영구 삭제
- 물건 자체가 휴지통에 들어간 경우: 사진도 30일 유지 후 물건 영구 삭제 시 함께 삭제

삭제/복구 시 관계 무결성을 반드시 지킨다.

---

## 8. 위치/평면도 핵심 불변조건

- 공간에는 최소 1개의 평면도가 존재해야 실제 사용을 시작할 수 있다.
- 모든 `Location`은 반드시 하나의 `FloorPlan`에 속한다.
- `Item.location_id`는 nullable이다.
- 위치가 없는 물건은 `위치 미지정` 상태로 유지한다.
- 위치 삭제 시 물건은 삭제하지 않고 위치 미지정으로 전환한다.
- 평면도 삭제 시 그 평면도의 위치도 삭제 처리되며 연결 물건은 위치 미지정으로 전환한다.
- 위치/평면도를 30일 이내 복구할 경우, 안전하게 복원 가능한 기존 물건 연결도 복원한다.

---

## 9. 테스트 규칙

자동 테스트 우선 대상:
- 로그인/인증 상태
- 공간 생성/초대/멤버 권한
- 관리자 권한
- 물건 CRUD
- 개인/공용 데이터 접근
- RLS
- 장보기 주요 로직
- 체크리스트 주요 로직
- 삭제/복구
- 동시수정 충돌

세부 UI 스타일은 수동 테스트 비중이 높아도 된다.

---

## 10. 금지 사항

- 사용자 확인 없이 핵심 정책 변경 금지
- 화면에서 Supabase 직접 호출 금지
- RLS 없이 공간 데이터 공개 금지
- Public Storage Bucket에 사용자 물건 사진 저장 금지
- Service Role Key를 Flutter 앱에 포함 금지
- Analytics에 사용자 콘텐츠 원문 전송 금지
- 기존 Feature-first 구조를 임의로 Layer-first로 변경 금지
- MVP 외 기능을 이유 없이 선행 구현 금지
- 평면도 전체를 셀별 DB Row로 분해 저장 금지

---

## 11. 개발 스타일

- 단순하고 명시적인 구현을 선호한다.
- 미래 확장성을 이유로 현재 필요 이상의 추상화를 만들지 않는다.
- 단, 외부 레시피 연동은 향후 공급자 변경을 위해 `RecipeProvider` 인터페이스를 둔다.
- 주석은 "무엇"보다 "왜"가 필요한 부분에만 작성한다.
- 바이브코딩 에이전트가 이해하기 쉬운 이름과 작은 함수 단위를 유지한다.
