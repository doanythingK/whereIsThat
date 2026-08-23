# DATABASE.md

## 1. 기본 원칙

- DB: Supabase PostgreSQL
- 주요 PK: UUID
- 공간 공유 데이터는 `space_id` 보유
- 시간 컬럼은 `timestamptz`
- 주요 엔터티는 `created_at`, `updated_at` 보유
- Soft Delete 대상은 `deleted_at` 보유
- RLS 필수
- 평면도 레이아웃만 JSONB 중심
- 나머지 주요 도메인은 정규 테이블

---

## 2. 권장 핵심 테이블

> 실제 migration 작성 시 이름은 snake_case로 통일한다.

### 2.1 profiles
Supabase Auth 사용자 프로필.

```text
profiles
- id uuid PK -> auth.users.id
- nickname text
- profile_image_path text nullable
- theme_mode text
- marketing_opt_in boolean
- created_at timestamptz
- updated_at timestamptz
- deleted_at timestamptz nullable
```

소셜 identity 자체는 Supabase Auth가 관리.

---

### 2.2 spaces

```text
spaces
- id uuid PK
- name text
- icon_key text
- icon_color text nullable
- created_by uuid
- created_at timestamptz
- updated_at timestamptz
- deleted_at timestamptz nullable
- delete_purge_at timestamptz nullable
```

공간 삭제 후 30일 복구.

---

### 2.3 space_members

```text
space_members
- id uuid PK
- space_id uuid FK
- user_id uuid FK
- role text -- admin/member
- display_name text nullable
- joined_at timestamptz
- last_accessed_at timestamptz nullable
- deleted_at timestamptz nullable
```

제약:
- `(space_id, user_id)` unique for active membership
- active member 최대 20명
- role enum/check

공간 목록 정렬은 `last_accessed_at DESC`.

---

### 2.4 space_invites

```text
space_invites
- id uuid PK
- space_id uuid FK
- code text unique
- token_hash text unique
- created_by uuid
- expires_at timestamptz
- revoked_at timestamptz nullable
- max_uses int nullable
- use_count int default 0
- created_at timestamptz
```

초대 참여 기본 role은 member.

---

## 3. 평면도

### 3.1 floor_plans

```text
floor_plans
- id uuid PK
- space_id uuid FK
- name text
- layout_data jsonb
- version bigint default 1
- created_by uuid
- created_at timestamptz
- updated_at timestamptz
- deleted_at timestamptz nullable
- delete_purge_at timestamptz nullable
```

`layout_data` 예:
- grid size
- active cells
- rooms
- room colors
- walls

공간 생성 후 최소 1개 active floor_plan 필요.

---

### 3.2 locations

```text
locations
- id uuid PK
- space_id uuid FK
- floor_plan_id uuid FK
- room_key text nullable
- name text
- location_type text nullable
- icon_key text
- icon_color text nullable
- show_label boolean default true
- x_ratio numeric
- y_ratio numeric
- z_index int default 0
- version bigint default 1
- created_by uuid
- created_at timestamptz
- updated_at timestamptz
- deleted_at timestamptz nullable
- delete_purge_at timestamptz nullable
```

Room은 floor_plan JSONB 내부 구조를 기준으로 자동 판정 가능.
`room_key`는 편의상 캐시할 수 있으나 진실의 원본 여부는 구현에서 명확히 한다.

---

## 4. 카테고리

### categories

```text
categories
- id uuid PK
- space_id uuid nullable
- name text
- is_system boolean default false
- created_by uuid nullable
- created_at timestamptz
- deleted_at timestamptz nullable
```

- system category: 전체 공통
- custom category: 특정 space 소속 가능
- 카테고리는 1단계만 지원

---

## 5. 물건

### 5.1 items

```text
items
- id uuid PK
- space_id uuid FK
- location_id uuid nullable FK
- category_id uuid nullable FK
- name text
- quantity numeric default 1
- unit text nullable
- detail_location text nullable
- memo text nullable
- is_food boolean default false
- visibility text -- shared/private
- owner_user_id uuid nullable
- created_by uuid
- version bigint default 1
- created_at timestamptz
- updated_at timestamptz
- deleted_at timestamptz nullable
- delete_purge_at timestamptz nullable
```

정책:
- `name` 필수
- `location_id` nullable
- `memo` 최대 500자
- quantity default 1
- visibility default는 제품 정책에서 명확히 선택 가능하나, private/shared 조건은 RLS에 반영

---

### 5.2 item_photos

```text
item_photos
- id uuid PK
- item_id uuid FK
- storage_path text
- is_primary boolean default false
- sort_order int
- created_at timestamptz
```

제약:
- item당 최대 3개
- primary 최대 1개

사진 개별 삭제는 row + storage file 즉시 삭제.
Item soft delete 시 row/file은 유지.
Item purge 시 실제 file도 삭제.

---

### 5.3 item_location_history

```text
item_location_history
- id uuid PK
- item_id uuid
- from_space_id uuid nullable
- from_location_id uuid nullable
- to_space_id uuid nullable
- to_location_id uuid nullable
- moved_by uuid nullable
- moved_at timestamptz
- reason text nullable
```

이력은 무기한 보존.
공간 간 이동도 기록.

---

## 6. 장보기

공간당 하나의 active shopping list를 기본으로 설계하거나, history가 필요하면 리스트를 복수로 둘 수 있다.
MVP에서는 단순화를 위해 공간별 active list + items 구조 권장.

### 6.1 shopping_lists

```text
shopping_lists
- id uuid PK
- space_id uuid FK
- created_at timestamptz
- updated_at timestamptz
```

### 6.2 shopping_items

```text
shopping_items
- id uuid PK
- shopping_list_id uuid FK
- space_id uuid FK
- name text
- assignee_user_id uuid nullable
- is_completed boolean default false
- completed_by uuid nullable
- completed_at timestamptz nullable
- sort_order numeric
- source_type text nullable -- manual/recipe/checklist
- source_id uuid nullable
- created_by uuid
- created_at timestamptz
- updated_at timestamptz
- deleted_at timestamptz nullable
```

중복 name은 DB에서 unique로 막지 않는다.
UI에서 경고만 한다.

Realtime 대상.

---

## 7. 체크리스트

### 7.1 checklist_templates

```text
checklist_templates
- id uuid PK
- owner_user_id uuid nullable
- template_type text -- system/user
- name text
- created_at timestamptz
- updated_at timestamptz
```

### 7.2 checklist_template_items

```text
checklist_template_items
- id uuid PK
- template_id uuid FK
- name text
- category_id uuid nullable
- sort_order numeric
```

### 7.3 checklists

```text
checklists
- id uuid PK
- space_id uuid nullable
- created_by uuid
- name text
- visibility text -- personal/shared
- is_completed boolean default false
- completed_by uuid nullable
- completed_at timestamptz nullable
- created_at timestamptz
- updated_at timestamptz
- deleted_at timestamptz nullable
```

personal이면 `space_id`는 사용 편의를 위해 유지할 수도 있으나 접근은 created_by만.

### 7.4 checklist_items

```text
checklist_items
- id uuid PK
- checklist_id uuid FK
- name text
- linked_item_id uuid nullable
- is_final_completed boolean default false
- final_completed_by uuid nullable
- final_completed_at timestamptz nullable
- sort_order numeric
- created_at timestamptz
- updated_at timestamptz
```

### 7.5 checklist_member_checks

```text
checklist_member_checks
- id uuid PK
- checklist_item_id uuid FK
- user_id uuid
- is_checked boolean
- checked_at timestamptz nullable
```

unique:
- `(checklist_item_id, user_id)`

Realtime 대상.

---

## 8. 식재료 / 기한 (출시 후)

Item의 `is_food = true`를 사용.
추가 정보는 별도 테이블을 권장.

### food_details

```text
food_details
- item_id uuid PK/FK
- date_type text nullable -- expiration/consumption
- target_date date nullable
- created_at timestamptz
- updated_at timestamptz
```

기한 초과라고 Item을 자동 삭제하지 않는다.

---

## 9. 기한 알림 (출시 후)

### item_reminders

```text
item_reminders
- id uuid PK
- item_id uuid FK
- days_before int
- target_user_id uuid nullable
- is_enabled boolean default true
- last_sent_for_date date nullable
- created_at timestamptz
```

또는 사용자 기본 설정을 profile/settings로 분리하고 item 단위 override만 저장할 수 있다.

---

## 10. 레시피 (출시 후)

### recipes

```text
recipes
- id uuid PK
- created_by uuid nullable
- space_id uuid nullable
- source_type text -- system/user/external-cache
- external_provider text nullable
- external_id text nullable
- visibility text -- personal/shared/system
- name text
- steps jsonb or normalized child table
- created_at timestamptz
- updated_at timestamptz
- deleted_at timestamptz nullable
```

### recipe_ingredients

```text
recipe_ingredients
- id uuid PK
- recipe_id uuid FK
- ingredient_name text
- quantity numeric nullable
- unit text nullable
- sort_order numeric
```

### recipe_favorites

```text
recipe_favorites
- user_id uuid
- recipe_id uuid
- created_at timestamptz
PK(user_id, recipe_id)
```

즐겨찾기는 계정 단위.

공유 사용자 레시피 수정은 `created_by`만 허용.

---

## 11. 사용자 설정

### user_settings

```text
user_settings
- user_id uuid PK
- theme_mode text
- shortcut_config jsonb
- notification_config jsonb
- marketing_opt_in boolean
- updated_at timestamptz
```

SharedPreferences는 캐시.

---

## 12. 디바이스/푸시

### user_devices

```text
user_devices
- id uuid PK
- user_id uuid FK
- platform text -- android/ios
- fcm_token text
- app_version text
- is_active boolean
- last_seen_at timestamptz
- created_at timestamptz
- updated_at timestamptz
```

로그아웃/토큰 갱신 시 관리.

---

## 13. 공지/버전

### app_notices

```text
app_notices
- id uuid PK
- title text
- body text
- importance text
- starts_at timestamptz nullable
- ends_at timestamptz nullable
- is_active boolean
- created_at timestamptz
```

### app_config

```text
app_config
- key text PK
- value jsonb
- updated_at timestamptz
```

예:
- `min_supported_version_android`
- `min_supported_version_ios`
- `latest_version_android`
- `latest_version_ios`

---

## 14. RLS 정책 모델

### 공통 helper 개념
SQL function을 사용해 정책 중복을 줄일 수 있다.

예시 개념:

```sql
is_space_member(space_id uuid, user_id uuid)
is_space_admin(space_id uuid, user_id uuid)
```

주의:
- helper function은 SECURITY DEFINER 사용 시 search_path와 권한을 엄격히 설정한다.

### 일반 공간 데이터
SELECT/INSERT/UPDATE/DELETE 조건:
- active `space_members`에 auth.uid()가 존재

### 관리자 기능
- `role = admin`

### private item
공간 멤버 조건 + `created_by = auth.uid()`

다른 사용자는:
- row 조회 불가
- count에 포함되지 않도록 query 설계
- 사진도 접근 불가

### shared recipe
- 조회: 공간 멤버
- 수정/삭제: `created_by = auth.uid()`

### personal checklist/recipe
- `created_by = auth.uid()`

---

## 15. Soft Delete / Purge

### 30일 복구 대상
- spaces
- floor_plans
- locations
- items

삭제 시:
```text
deleted_at = now()
delete_purge_at = now() + interval '30 days'
```

Cron/Edge Function으로 purge 가능.

### 관계 처리
#### Location 삭제
- 연결 Item.location_id → null
- 과거 연결 정보는 history 또는 recovery mapping으로 보존

#### FloorPlan 삭제
- 하위 Location soft delete
- 연결 Item.location_id → null

#### 복구
복구 전에:
- 대상 Item이 이미 다른 Location으로 이동했는지 확인
- 사용자가 이후 새 위치를 지정했다면 자동 덮어쓰지 않음
- 여전히 위치 미지정이고 복구 대상 관계가 유효할 때만 자동 복원 권장

---

## 16. 검색 인덱스

MVP 기본 인덱스:
- `items(space_id, deleted_at)`
- `items(name)`
- `locations(space_id, name)`
- `categories(name)`
- `space_members(user_id, deleted_at)`
- `shopping_items(space_id, is_completed)`
- `checklists(space_id, visibility)`

초기에는 pg_trgm 전문검색을 사용하지 않는다.
데이터가 커지고 부분검색 성능이 실제 문제가 될 때 추가.

---

## 17. 무결성 체크

- 한 공간 active member 최대 20명
- 한 Item 사진 최대 3장
- 한 Item 대표사진 최대 1장
- 방 셀 겹침은 앱 레이아웃 검증에서 차단
- Location은 반드시 active FloorPlan을 참조
- Item.location_id는 nullable
- private Item은 created_by 기준 보안
- 관리자 0명 상태가 되지 않도록 탈퇴/권한 변경 로직에서 검증

---

## 18. 동시성

`version bigint` 사용 권장.

Update 예시 개념:

```sql
UPDATE items
SET
  name = :name,
  version = version + 1,
  updated_at = now()
WHERE id = :id
  AND version = :expected_version
  AND deleted_at IS NULL;
```

0 rows이면 충돌 처리.

---

## 19. Migration 규칙

- 모든 스키마 변경은 migration으로 관리
- dev에서 먼저 적용/검증
- prod Dashboard에서 수동 테이블 구조 수정 금지 원칙
- RLS 변경도 migration에 포함
- seed/system categories/system checklist templates는 별도 seed script로 관리
