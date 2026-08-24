# 엄마 이거 어딨어?

가족·룸메이트가 공간의 평면도와 보관 위치를 공유하고, 물건 검색·장보기·체크리스트를 함께 사용하는 Flutter MVP입니다.

## 문서 읽는 순서

작업을 시작할 때는 아래 순서를 지킵니다.

1. `AGENTS.md`
2. `PRODUCT_REQUIREMENTS.md`
3. `MVP_SCOPE.md`
4. `ARCHITECTURE.md`
5. `DATABASE.md`
6. `ROADMAP.md`

문서 간 정책 충돌은 임의로 해결하지 않고 먼저 보고합니다.

## 기술 구조

- Flutter / Riverpod / go_router
- Feature-first 디렉터리
- `UI → Provider/Action → Repository → Supabase`
- Supabase Auth, PostgreSQL RLS, Storage Private Bucket, Realtime
- 모델은 `freezed + json_serializable`을 사용합니다.
- Supabase 키가 없는 로컬 실행은 `DemoAppRepository`를 사용해 UI와 핵심 흐름을 검토할 수 있습니다.

## 로컬 실행

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

실제 Supabase dev 프로젝트로 실행할 때는 publishable/anon key만 주입합니다.

```bash
flutter run \
  --dart-define=APP_ENV=dev \
  --dart-define=APP_VERSION=1.0.0 \
  --dart-define=SUPABASE_URL=https://<dev-project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<publishable-or-anon-key>
```

Service Role Key, DB 비밀번호, FCM 서버 키, 스토어 키는 앱이나 저장소에 넣지 않습니다.

## Supabase

`supabase/migrations/202608230001_mvp.sql`을 dev 프로젝트에 먼저 적용하고, 이미 적용한 환경에는 이어서 `supabase/migrations/202608240001_mvp_hardening.sql`도 적용한 뒤 RLS와 OAuth provider 설정을 확인합니다. 운영 프로젝트에는 dev 검증 후 같은 migration 순서를 승격합니다.

30일 Soft Delete purge는 `supabase/functions/purge_deleted_data` Edge Function을 Supabase Cron에서 하루 한 번 호출하도록 설정합니다. Edge Function에만 `SUPABASE_SERVICE_ROLE_KEY`를 secret으로 등록합니다.

공간 멤버·장보기·공유 체크리스트 변경 알림은 `supabase/functions/dispatch_notifications`를 Cron으로 호출합니다. `FCM_PROJECT_ID`, `FCM_CLIENT_EMAIL`, `FCM_PRIVATE_KEY`도 Edge Function secret으로만 등록합니다. 최소 지원 버전은 `app_config`의 `minimum_supported_version` 키에 문자열 또는 `{ "version": "1.0.0" }` JSON으로 설정합니다.

필수 OAuth/플랫폼 설정:

- Kakao, Google, Apple: Supabase Auth provider와 redirect URL `whereisthat://auth-callback`
- Naver: Supabase custom OIDC provider `custom:naver`
- Android/iOS 딥링크: `whereisthat` scheme
- Firebase를 켜려면 각 환경의 `google-services.json`, `GoogleService-Info.plist`와 `FIREBASE_ENABLED=true`
- AdMob 운영 App ID/Ad Unit ID는 테스트 ID를 교체한 뒤 `ADS_ENABLED=true`

## 품질 명령

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build apk --debug
```

GitHub Actions가 `dev`와 `main`의 분석·테스트·Android debug build를 실행합니다. iOS archive/build는 macOS + Xcode + CocoaPods 환경에서 실행합니다.

## 휴대폰에서 APK 받기

1. GitHub 저장소의 **Actions → Flutter CI**로 이동합니다.
2. **Run workflow**를 누르고 브랜치 `dev`를 선택한 뒤 실행합니다.
3. 실행이 끝나면 해당 실행 화면 하단 **Artifacts → where-is-that-debug-apk**를 눌러 다운로드합니다.
4. 휴대폰에서 ZIP 압축을 풀고 `app-debug.apk`를 설치합니다. Android 설정에서 브라우저/파일 앱의 알 수 없는 앱 설치를 허용해야 할 수 있습니다.

## 현재 검증 범위와 제약

- 데모 저장소에서 공간/평면도/위치/물건/사진 선택/검색/장보기/체크리스트 주요 흐름을 실행할 수 있습니다.
- Supabase 실서비스 동작은 migration 적용, OAuth provider, Firebase 설정을 각 환경에서 완료해야 합니다.
- 현재 개발 머신은 Linux/WSL이므로 iOS 실제 빌드·서명·TestFlight 검증은 수행할 수 없습니다.
- release signing, 실제 FCM 서버 발송, 운영 AdMob ID는 배포 환경에서 별도로 설정해야 합니다.
