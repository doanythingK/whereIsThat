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
  String get unit => _text('단위', 'Unit');
  String get location => _text('보관 위치', 'Storage location');
  String get unassignedLocation => _text('위치 미지정', 'Unassigned');
  String get memo => _text('메모', 'Memo');
  String get privateItem => _text('개인', 'Private');
  String get sharedItem => _text('공용', 'Shared');
  String get favorites => _text('즐겨찾기', 'Favorites');
  String get noItems => _text('등록된 물건이 없습니다.', 'No items yet.');
  String get addLocation => _text('보관 위치 추가', 'Add storage location');
  String get locationName => _text('위치 이름', 'Location name');
  String get noLocations =>
      _text('평면도에 위치를 추가해 보세요.', 'Add a location to the floor plan.');
  String get shoppingEmpty => _text('장보기 항목을 추가해 보세요.', 'Add a shopping item.');
  String get checklistEmpty => _text('체크리스트를 만들어 보세요.', 'Create a checklist.');
  String get signIn => _text('로그인', 'Sign in');
  String get signOut => _text('로그아웃', 'Sign out');
  String get demoMode => _text('데모 모드', 'Demo mode');
  String get settings => _text('설정', 'Settings');
  String get members => _text('멤버 관리', 'Members');
  String get invite => _text('멤버 초대', 'Invite members');
  String get addChecklist => _text('체크리스트 추가', 'Add checklist');
  String get addShoppingItem => _text('장보기 항목 추가', 'Add shopping item');
  String get errorTitle => _text('문제가 발생했습니다', 'Something went wrong');
  String get retry => _text('다시 시도', 'Retry');

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
