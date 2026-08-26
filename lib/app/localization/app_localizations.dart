import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('ko'));
  }

  bool get _isKorean => locale.languageCode == 'ko';

  String _text(String korean, String english) => _isKorean ? korean : english;

  String get appTitle => '엄마 이거 어딨어?';
  String get spaces => _text('공간', 'Spaces');
  String get home => _text('홈', 'Home');
  String get floorPlan => _text('평면도', 'Floor plan');
  String get shopping => _text('장보기', 'Shopping');
  String get checklist => _text('체크리스트', 'Checklist');
  String get more => _text('전체 메뉴', 'More');
  String get search =>
      _text('물건, 위치, 카테고리 검색', 'Search items, locations, or categories');
  String get add => _text('추가', 'Add');
  String get save => _text('저장', 'Save');
  String get cancel => _text('취소', 'Cancel');
  String get continueLabel => _text('계속', 'Continue');
  String get delete => _text('삭제', 'Delete');
  String get restore => _text('복구', 'Restore');
  String get close => _text('닫기', 'Close');
  String get createSpace => _text('공간 만들기', 'Create space');
  String get spaceName => _text('공간 이름', 'Space name');
  String get chooseSpace => _text('사용할 공간을 선택하세요', 'Choose a space');
  String get noSpaces =>
      _text('아직 참여한 공간이 없습니다.', 'You have not joined a space yet.');
  String get createFirstFloorPlan => _text(
    '평면도를 만들면 공간을 사용할 수 있어요.',
    'Create a floor plan to start using this space.',
  );
  String get addItem => _text('물건 등록', 'Add item');
  String get itemName => _text('물건명', 'Item name');
  String get quantity => _text('수량', 'Quantity');
  String get invalidQuantity =>
      _text('수량을 0 이상으로 입력해 주세요.', 'Enter a quantity of 0 or more.');
  String get unit => _text('단위', 'Unit');
  String get location => _text('보관 위치', 'Storage location');
  String get unassignedLocation => _text('위치 미지정', 'Unassigned');
  String get memo => _text('메모', 'Memo');
  String get privateItem => _text('개인', 'Private');
  String get sharedItem => _text('공용', 'Shared');
  String get owner => _text('소유자', 'Owner');
  String get favorites => _text('즐겨찾기', 'Favorites');
  String get editShortcuts => _text('바로가기 편집', 'Edit shortcuts');
  String get shortcutLimit => _text('최대 4개까지 선택할 수 있습니다.', 'Choose up to 4.');
  String get noItems => _text('등록된 물건이 없습니다.', 'No items yet.');
  String get addLocation => _text('보관 위치 추가', 'Add storage location');
  String get locationName => _text('위치 이름', 'Location name');
  String get locationType => _text('위치 유형', 'Location type');
  String get locationIcon => _text('위치 아이콘', 'Location icon');
  String get showLabel => _text('이름 표시', 'Show label');
  String get shelfType => _text('선반', 'Shelf');
  String get cabinetType => _text('수납장', 'Cabinet');
  String get closetType => _text('옷장', 'Closet');
  String get boxType => _text('상자', 'Box');
  String get noLocations =>
      _text('평면도에 위치를 추가해 보세요.', 'Add a location to the floor plan.');
  String get shoppingEmpty => _text('장보기 항목을 추가해 보세요.', 'Add a shopping item.');
  String get checklistEmpty => _text('체크리스트를 만들어 보세요.', 'Create a checklist.');
  String get signIn => _text('로그인', 'Sign in');
  String get signOut => _text('로그아웃', 'Sign out');
  String get accountDeletionScheduled =>
      _text('탈퇴가 예약되었습니다', 'Account deletion is scheduled');
  String get accountRecoveryBody => _text(
    '30일 이내에 복구하면 계정과 접근 권한을 되돌릴 수 있습니다.',
    'Restore your account within 30 days to recover access and data.',
  );
  String get restoreAccount => _text('계정 복구', 'Restore account');
  String get continueAfterSignOut =>
      _text('로그아웃하고 나중에 복구하기', 'Sign out and restore later');
  String get demoMode => _text('데모 모드', 'Demo mode');
  String get settings => _text('설정', 'Settings');
  String get members => _text('멤버 관리', 'Members');
  String get invite => _text('멤버 초대', 'Invite members');
  String get addChecklist => _text('체크리스트 추가', 'Add checklist');
  String get addShoppingItem => _text('장보기 항목 추가', 'Add shopping item');
  String get errorTitle => _text('문제가 발생했습니다', 'Something went wrong');
  String get retry => _text('다시 시도', 'Retry');
  String get conflictTitle =>
      _text('최신 변경사항이 있습니다', 'Newer changes are available');
  String get conflictBody => _text(
    '다른 사용자가 먼저 수정했습니다. 최신 내용을 다시 불러오면 현재 편집 내용은 버려집니다.',
    'Someone else edited this first. Reloading will discard your current edits.',
  );
  String get reloadLatest => _text('최신 내용 불러오기', 'Reload latest');
  String get updateRequired => _text('업데이트가 필요합니다', 'Update required');
  String get updateRequiredBody => _text(
    '최신 버전으로 업데이트한 뒤 계속 이용해 주세요.',
    'Please update to the latest version to continue.',
  );
  String get loginTagline =>
      _text('가족과 함께 물건의 위치를 찾아보세요.', 'Find where things are with your family.');
  String socialLogin(String provider) =>
      _isKorean ? '$provider로 로그인' : 'Sign in with $provider';
  String providerName(String key) {
    if (_isKorean) {
      return switch (key) {
        'kakao' => '카카오',
        'naver' => '네이버',
        'google' => 'Google',
        'apple' => 'Apple',
        _ => key,
      };
    }
    return switch (key) {
      'kakao' => 'Kakao',
      'naver' => 'Naver',
      'google' => 'Google',
      'apple' => 'Apple',
      _ => key,
    };
  }

  String get itemList => _text('물건 목록', 'Items');
  String favoriteAction(bool isFavorite) =>
      isFavorite ? _text('즐겨찾기 해제', 'Remove from favorites') : favorites;
  String get inviteCode => _text('초대 코드', 'Invite code');
  String get inviteLink => _text('초대 링크', 'Invite link');
  String expiry(DateTime value) =>
      _isKorean ? '만료: ${value.toLocal()}' : 'Expires: ${value.toLocal()}';
  String get copyLink => _text('링크 복사', 'Copy link');
  String get linkCopied => _text('초대 링크를 복사했습니다.', 'Invite link copied.');
  String get inviteReceived =>
      _text('공간 초대가 도착했어요.', 'You have been invited to a space.');
  String get acceptInvite => _text('초대 수락', 'Accept invite');
  String get spaceIcon => _text('대표 아이콘', 'Space icon');
  String get homeSpace => _text('집', 'Home');
  String get officeSpace => _text('회사', 'Office');
  String get storageSpace => _text('창고', 'Storage');
  String get noDeletedSpace => _text('복구할 공간이 없습니다.', 'No spaces to restore.');
  String get thirtyDayRetention => _text('30일 보관', 'Kept for 30 days');
  String scheduledDeletion(DateTime value) => _isKorean
      ? '영구 삭제 예정 ${value.toLocal()}'
      : 'Permanent deletion scheduled ${value.toLocal()}';
  String get renameLocation => _text('위치 이름 수정', 'Rename location');
  String get addItemAtLocation => _text('이 위치에 물건 등록', 'Add an item here');
  String get defaultLocationName => _text('수납장', 'Storage cabinet');
  String get floorPlanAdd => _text('평면도 추가', 'Add floor plan');
  String get floorPlanName => _text('평면도 이름', 'Floor plan name');
  String get newFloorPlan => _text('새 평면도', 'New floor plan');
  String get roomAreaPrompt => _text(
    '영역 모드에서 방으로 만들 셀을 먼저 선택해 주세요.',
    'Select cells in area mode before creating a room.',
  );
  String get roomOverlap => _text(
    '이미 다른 방에 포함된 셀은 다시 사용할 수 없습니다.',
    'Cells already assigned to another room cannot be reused.',
  );
  String get gridSize => _text('그리드 크기', 'Grid size');
  String get rows => _text('세로', 'Rows');
  String get columns => _text('가로', 'Columns');
  String get floorPlanSaved => _text('평면도를 저장했습니다.', 'Floor plan saved.');
  String get unsavedChanges =>
      _text('저장하지 않은 변경사항이 있어요', 'You have unsaved changes');
  String get discardChangesQuestion =>
      _text('변경사항을 저장하지 않고 이동할까요?', 'Leave without saving changes?');
  String get discardAndLeave => _text('버리고 이동', 'Discard and leave');
  String deleteFloorPlanMessage(String name) => _isKorean
      ? '$name을(를) 삭제하면 30일 동안 복구할 수 있습니다. 연결된 물건은 위치 미지정으로 바뀝니다.'
      : 'After deleting $name, it can be restored for 30 days. Linked items become unassigned.';
  String get roomAdd => _text('방 추가', 'Add room');
  String get defaultRoomName => _text('거실', 'Living room');
  String get roomName => _text('방 이름', 'Room name');
  String get locationMode => _text('위치', 'Location');
  String get areaMode => _text('영역', 'Area');
  String get wallMode => _text('벽', 'Wall');
  String get undo => _text('실행 취소', 'Undo');
  String get redo => _text('다시 실행', 'Redo');
  String get itemEdit => _text('물건 수정', 'Edit item');
  String get moveItem =>
      _text('다른 공간/위치로 이동', 'Move to another space/location');
  String get showOnFloorPlan => _text('평면도에서 위치 보기', 'Show on floor plan');
  String get itemLocationHistory => _text('위치 이동 이력', 'Location history');
  String get noItemLocationHistory =>
      _text('아직 위치 이동 이력이 없습니다.', 'No location history yet.');
  String get chooseMoveLocation => _text('이동할 위치 선택', 'Choose destination');
  String get categoryOptional => _text('카테고리 (선택)', 'Category (optional)');
  String get none => _text('없음', 'None');
  String get categoryAdd => _text('카테고리 추가', 'Add category');
  String get categoryName => _text('카테고리 이름', 'Category name');
  String get detailLocationOptional =>
      _text('상세 위치 (선택)', 'Detailed location (optional)');
  String photoCount(int count) =>
      _isKorean ? '사진 ($count/3)' : 'Photos ($count/3)';
  String get camera => _text('카메라', 'Camera');
  String get gallery => _text('갤러리', 'Gallery');
  String get photoHint =>
      _text('필요할 때 사진을 최대 3장까지 추가할 수 있어요.', 'Add up to 3 photos when needed.');
  String get photoLimit =>
      _text('물건 사진은 최대 3장까지 추가할 수 있습니다.', 'Up to 3 photos per item.');
  String get checklistDirectCreate => _text('직접 만들기', 'Create manually');
  String get checklistName => _text('이름', 'Name');
  String get defaultTemplateOptional =>
      _text('기본 템플릿 (선택)', 'Default template (optional)');
  String get checklistItemAdd => _text('항목 추가', 'Add item');
  String get checklistItemEdit => _text('항목 수정', 'Edit item');
  String get duplicateChecklistItem =>
      _text('중복 항목이 있어요', 'Duplicate checklist item');
  String duplicateChecklistMessage(String name) => _isKorean
      ? '이미 "$name" 항목이 있습니다. 그래도 추가할까요?'
      : '"$name" already exists. Add it anyway?';
  String get prepareItem => _text('준비할 물건', 'Item to prepare');
  String get linkedItemOptional =>
      _text('연결할 물건 (선택)', 'Linked item (optional)');
  String get notLinked => _text('연결하지 않음', 'No linked item');
  String get templateSaved => _text('내 템플릿으로 저장했습니다.', 'Saved as my template.');
  String get checklistList => _text('목록', 'List');
  String get sharedChecklist => _text('공간 공유 목록', 'Shared list');
  String get personalChecklist => _text('개인 목록', 'Personal list');
  String get checklistComplete => _text('목록 완료', 'Complete list');
  String get checklistCompleteCancel => _text('완료 취소', 'Undo completion');
  String get saveAsTemplate => _text('내 템플릿으로 저장', 'Save as my template');
  String get noLinkedItem => _text('연결된 물건 없음', 'No linked item');
  String get myPreparation => _text('내 준비 상태', 'My preparation');
  String get memberPreparation => _text('멤버 준비 상태', 'Member preparation');
  String get purchaseItem => _text('구매할 항목', 'Item to buy');
  String get duplicateShoppingItem => _text('중복 항목이 있어요', 'Duplicate item');
  String duplicateShoppingMessage(String name) => _isKorean
      ? '이미 "$name" 항목이 있습니다. 그래도 추가할까요?'
      : '"$name" already exists. Add it anyway?';
  String get registerAtHome => _text('집에 등록하기', 'Register at home');
  String get completeOnly => _text('그냥 완료', 'Complete only');
  String get chooseAssignee => _text('담당자 선택', 'Choose assignee');
  String get noAssignee => _text('담당자 없음', 'No assignee');
  String get assigned => _text('담당자 지정됨', 'Assigned');
  String get assign => _text('담당자 지정', 'Assign');
  String get leaveSpace => _text('이 공간에서 탈퇴', 'Leave this space');
  String get deleteSpace => _text('공간 삭제', 'Delete space');
  String get deleteAccount => _text('회원 탈퇴', 'Delete account');
  String get trash => _text('휴지통', 'Trash');
  String get trashSubtitle =>
      _text('30일 이내 삭제한 데이터 복구', 'Restore data deleted within 30 days');
  String get noRestorableData => _text('복구할 데이터가 없습니다.', 'No data to restore.');
  String trashEntry(String type, DateTime? date) => _isKorean
      ? '$type · ${date == null ? '30일 보관' : '영구 삭제 예정 ${date.toLocal()}'}'
      : '$type · ${date == null ? 'Kept for 30 days' : 'Permanent deletion scheduled ${date.toLocal()}'}';
  String get notice => _text('공지', 'Notices');
  String get noticeSubtitle =>
      _text('새로운 소식을 확인하세요.', 'Check the latest updates.');
  String get noNotices => _text('새로운 공지가 없습니다.', 'No new notices.');
  String get displayNameTitle => _text('공간별 표시 이름', 'Space display name');
  String get displayName => _text('표시 이름', 'Display name');
  String get theme => _text('테마', 'Theme');
  String get systemTheme => _text('시스템', 'System');
  String get lightTheme => _text('라이트', 'Light');
  String get darkTheme => _text('다크', 'Dark');
  String get linkIdentity => _text('로그인 수단 연결', 'Link sign-in method');
  String identityLink(String provider) =>
      _isKorean ? '$provider 계정 연결' : 'Link $provider';
  String get deleteSpaceQuestion => _text('공간을 삭제할까요?', 'Delete this space?');
  String deleteNamed(String name) => _isKorean ? '$name 삭제' : 'Delete $name';
  String get deleteSpaceDescription => _text(
    '삭제 후 30일 동안 복구할 수 있습니다. 확인하려면 공간 이름을 입력하세요.',
    'You can restore it for 30 days. Enter the space name to confirm.',
  );
  String get leaveSpaceQuestion => _text('공간에서 탈퇴할까요?', 'Leave this space?');
  String get leaveSpaceDescription => _text(
    '공용 데이터는 공간에 남습니다. 개인 물건 처리 방법을 선택하세요.',
    'Shared data stays in the space. Choose what to do with your private items.',
  );
  String get keepData => _text('보관', 'Keep');
  String get moveData => _text('다른 공간으로 이동', 'Move to another space');
  String get deleteData => _text('삭제', 'Delete');
  String get targetSpace => _text('이동할 공간', 'Destination space');
  String get noOtherSpace =>
      _text('이동할 다른 공간이 없습니다.', 'No other space is available.');
  String get leave => _text('탈퇴', 'Leave');
  String get deleteAccountQuestion => _text('회원 탈퇴', 'Delete account');
  String get deleteAccountDescription => _text(
    '30일 유예 기간 동안 복구할 수 있습니다. 계속할까요?',
    'You can restore your account during the 30-day grace period. Continue?',
  );
  String get requestDeletion => _text('탈퇴 신청', 'Request deletion');
  String get inviteUnavailable =>
      _text('사용 가능한 초대가 없습니다.', 'No available invites.');
  String get revoked => _text('폐기됨', 'Revoked');
  String get expired => _text('만료됨', 'Expired');
  String get demoRepositoryMessage => _text(
    '현재 데모 저장소를 사용 중입니다. Supabase URL과 anon key를 주입하면 dev/prod 서버로 전환됩니다.',
    'The demo repository is active. Provide a Supabase URL and anon key to use dev/prod data.',
  );
  String get promoteAdmin => _text('관리자로 승격', 'Promote to admin');
  String get demoteMember => _text('일반 멤버로 변경', 'Change to member');
  String get neighbor => _text('이웃', 'Neighbor');
  String requiredField(String field) =>
      _isKorean ? '$field을 입력해 주세요.' : 'Please enter $field.';

  String greeting(String name) =>
      _isKorean ? '$name님, 무엇을 찾고 있나요?' : 'What are you looking for, $name?';
  String itemCount(int count) => _isKorean ? '$count개' : '$count items';
  String memberCount(int count) => _isKorean ? '$count명' : '$count members';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ko' || locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
