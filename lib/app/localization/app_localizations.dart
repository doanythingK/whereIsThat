import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('ko'));
  }

  String get appTitle => '엄마 이거 어딨어?';
  String get spaces => '공간';
  String get home => '홈';
  String get floorPlan => '평면도';
  String get shopping => '장보기';
  String get checklist => '체크리스트';
  String get more => '전체 메뉴';
  String get search => '물건, 위치, 카테고리 검색';
  String get add => '추가';
  String get save => '저장';
  String get cancel => '취소';
  String get delete => '삭제';
  String get restore => '복구';
  String get close => '닫기';
  String get createSpace => '공간 만들기';
  String get spaceName => '공간 이름';
  String get chooseSpace => '사용할 공간을 선택하세요';
  String get noSpaces => '아직 참여한 공간이 없습니다.';
  String get createFirstFloorPlan => '평면도를 만들면 공간을 사용할 수 있어요.';
  String get addItem => '물건 등록';
  String get itemName => '물건명';
  String get quantity => '수량';
  String get unit => '단위';
  String get location => '보관 위치';
  String get unassignedLocation => '위치 미지정';
  String get memo => '메모';
  String get privateItem => '개인';
  String get sharedItem => '공용';
  String get favorites => '즐겨찾기';
  String get noItems => '등록된 물건이 없습니다.';
  String get addLocation => '보관 위치 추가';
  String get locationName => '위치 이름';
  String get noLocations => '평면도에 위치를 추가해 보세요.';
  String get shoppingEmpty => '장보기 항목을 추가해 보세요.';
  String get checklistEmpty => '체크리스트를 만들어 보세요.';
  String get signIn => '로그인';
  String get signOut => '로그아웃';
  String get demoMode => '데모 모드';
  String get settings => '설정';
  String get members => '멤버 관리';
  String get invite => '멤버 초대';
  String get addChecklist => '체크리스트 추가';
  String get addShoppingItem => '장보기 항목 추가';
  String get errorTitle => '문제가 발생했습니다';
  String get retry => '다시 시도';

  String greeting(String name) => '$name님, 무엇을 찾고 있나요?';
  String itemCount(int count) => '$count개';
  String memberCount(int count) => '$count명';
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
