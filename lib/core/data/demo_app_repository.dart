import 'dart:typed_data';

import 'package:uuid/uuid.dart';

import '../errors/app_exception.dart';
import '../models/app_models.dart';
import 'app_repository.dart';

/// A deterministic local repository used when no Supabase environment is
/// supplied. It keeps the app runnable for design review and widget tests;
/// production builds use [SupabaseAppRepository] instead.
class DemoAppRepository implements AppRepository {
  DemoAppRepository() {
    _seed();
  }

  final Uuid _uuid = const Uuid();
  final Map<String, Space> _spaces = {};
  final Map<String, SpaceMember> _members = {};
  final Map<String, SpaceInvite> _invites = {};
  final Map<String, FloorPlan> _floorPlans = {};
  final Map<String, Location> _locations = {};
  final Map<String, Item> _items = {};
  final Map<String, Category> _categories = {};
  final Map<String, ShoppingItem> _shoppingItems = {};
  final Map<String, Checklist> _checklists = {};
  final Map<String, ChecklistItem> _checklistItems = {};
  final Map<String, ChecklistTemplate> _templates = {};
  final Map<String, List<ChecklistTemplateItem>> _templateItems = {};
  final Map<String, ChecklistMemberCheck> _memberChecks = {};
  final List<ItemLocationHistory> _history = [];
  final Map<String, DateTime> _lastAccessed = {};
  final Map<String, List<String>> _locationRecovery = {};
  List<String> _homeShortcuts = const [
    'floor_plan',
    'items',
    'shopping',
    'checklist',
  ];

  final AppUser _user = const AppUser(
    id: 'demo-user',
    email: 'demo@example.com',
    nickname: '나',
  );

  @override
  bool get isDemoMode => true;

  @override
  AppUser get signedInUser => _user;

  DateTime _now() => DateTime.now().toUtc();

  void _seed() {
    final now = _now();
    const spaceId = 'demo-space';
    const floorPlanId = 'demo-floor-plan';
    const locationId = 'demo-location-kitchen';
    const categoryId = 'demo-category-household';

    _spaces[spaceId] = Space(
      id: spaceId,
      name: '우리집',
      iconKey: 'home',
      iconColor: '#2563EB',
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
      memberCount: 1,
    );
    _lastAccessed[spaceId] = now;
    _members['demo-member'] = SpaceMember(
      id: 'demo-member',
      spaceId: spaceId,
      userId: _user.id,
      role: 'admin',
      displayName: '나',
      joinedAt: now,
      lastAccessedAt: now,
    );
    _floorPlans[floorPlanId] = FloorPlan(
      id: floorPlanId,
      spaceId: spaceId,
      name: '1층',
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
      layoutData: {
        'grid': {'rows': 20, 'cols': 20},
        'activeCells': <String>[],
        'walls': <Map<String, dynamic>>[],
        'rooms': [
          {
            'id': 'living-room',
            'name': '거실',
            'color': '#DBEAFE',
            'cells': <String>[],
          },
        ],
      },
    );
    _locations[locationId] = Location(
      id: locationId,
      spaceId: spaceId,
      floorPlanId: floorPlanId,
      roomKey: 'living-room',
      name: '주방 수납장',
      locationType: 'cabinet',
      iconKey: 'shelf',
      iconColor: '#2563EB',
      xRatio: 0.72,
      yRatio: 0.34,
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
    );
    _categories[categoryId] = const Category(
      id: categoryId,
      spaceId: null,
      name: '생활용품',
      isSystem: true,
    );
    _items['demo-item-filter'] = Item(
      id: 'demo-item-filter',
      spaceId: spaceId,
      locationId: locationId,
      categoryId: categoryId,
      name: '샤워기 필터',
      quantity: 2,
      unit: '개',
      detailLocation: '두 번째 칸',
      memo: '여분을 함께 보관해요.',
      visibility: 'shared',
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
      isFavorite: true,
      photos: const [],
    );
    _items['demo-item-battery'] = Item(
      id: 'demo-item-battery',
      spaceId: spaceId,
      name: 'AA 건전지',
      quantity: 8,
      unit: '개',
      visibility: 'shared',
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
      photos: const [],
    );
    _shoppingItems['demo-shopping'] = ShoppingItem(
      id: 'demo-shopping',
      shoppingListId: 'demo-shopping-list',
      spaceId: spaceId,
      name: '종량제 봉투',
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
    );
    _checklists['demo-checklist'] = Checklist(
      id: 'demo-checklist',
      spaceId: spaceId,
      createdBy: _user.id,
      name: '캠핑 준비',
      visibility: 'shared',
      createdAt: now,
      updatedAt: now,
    );
    _checklistItems['demo-checklist-item'] = const ChecklistItem(
      id: 'demo-checklist-item',
      checklistId: 'demo-checklist',
      name: '랜턴',
      sortOrder: 0,
    );
    const templateNames = <String>['해외여행', '국내여행', '캠핑', '출장', '입원'];
    for (var index = 0; index < templateNames.length; index++) {
      final id = 'demo-template-$index';
      _templates[id] = ChecklistTemplate(id: id, name: templateNames[index]);
      _templateItems[id] = [
        ChecklistTemplateItem(
          id: '$id-item-0',
          templateId: id,
          name: index == 2 ? '랜턴' : '신분증',
        ),
        ChecklistTemplateItem(
          id: '$id-item-1',
          templateId: id,
          name: index == 2 ? '충전기' : '충전기',
          sortOrder: 1,
        ),
      ];
    }
  }

  @override
  Future<AppUser?> currentUser() async => _user;

  @override
  Stream<AppUser?> watchAuthState() async* {
    yield _user;
  }

  @override
  Future<void> signIn(SocialProvider provider) async {}

  @override
  Future<void> linkIdentity(SocialProvider provider) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<bool> isAccountDeletionPending() async => false;

  @override
  Future<void> restoreAccount() async {}

  @override
  Future<void> registerDevice({
    required String platform,
    required String token,
    String? appVersion,
  }) async {}

  @override
  Future<List<String>> getHomeShortcuts() async =>
      List<String>.from(_homeShortcuts);

  @override
  Future<void> saveHomeShortcuts(List<String> shortcuts) async {
    _homeShortcuts = List<String>.from(shortcuts.take(4));
  }

  @override
  Future<String?> getMinimumSupportedVersion() async => null;

  @override
  Future<List<AppNotice>> listNotices() async => const [
    AppNotice(
      id: 'demo-notice',
      title: '데모 모드 안내',
      body: 'Supabase 환경 변수를 설정하면 실제 계정과 공간 데이터를 사용할 수 있습니다.',
    ),
  ];

  @override
  Future<String> acceptInvite(String code) async {
    if (code.trim().isEmpty) {
      throw const AppException('초대 코드가 필요합니다.');
    }
    return 'demo-space';
  }

  @override
  Future<List<Space>> listSpaces() async {
    final spaces = _spaces.values
        .where(
          (space) =>
              space.deletedAt == null &&
              _members.values.any(
                (member) =>
                    member.spaceId == space.id && member.userId == _user.id,
              ),
        )
        .toList();
    spaces.sort(
      (a, b) => (_lastAccessed[b.id] ?? DateTime(1970)).compareTo(
        _lastAccessed[a.id] ?? DateTime(1970),
      ),
    );
    return spaces;
  }

  @override
  Future<List<Space>> listDeletedSpaces() async => _spaces.values
      .where(
        (space) =>
            space.deletedAt != null &&
            _members.values.any(
              (member) =>
                  member.spaceId == space.id && member.userId == _user.id,
            ),
      )
      .toList();

  @override
  Future<Space> createSpace({
    required String name,
    required String iconKey,
    String? iconColor,
  }) async {
    final now = _now();
    final spaceId = _uuid.v4();
    final space = Space(
      id: spaceId,
      name: name,
      iconKey: iconKey,
      iconColor: iconColor,
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
      memberCount: 1,
    );
    _spaces[spaceId] = space;
    _lastAccessed[spaceId] = now;
    final memberId = _uuid.v4();
    _members[memberId] = SpaceMember(
      id: memberId,
      spaceId: spaceId,
      userId: _user.id,
      role: 'admin',
      displayName: _user.nickname,
      joinedAt: now,
      lastAccessedAt: now,
    );
    await createFloorPlan(spaceId: spaceId, name: '1층');
    return space;
  }

  @override
  Future<void> updateSpace(Space space) async {
    _spaces[space.id] = space.copyWith(updatedAt: _now());
  }

  @override
  Future<void> softDeleteSpace(Space space) async {
    final now = _now();
    _spaces[space.id] = space.copyWith(
      deletedAt: now,
      deletePurgeAt: now.add(const Duration(days: 30)),
      updatedAt: now,
    );
  }

  @override
  Future<void> restoreSpace(Space space) async {
    _spaces[space.id] = space.copyWith(
      deletedAt: null,
      deletePurgeAt: null,
      updatedAt: _now(),
    );
  }

  @override
  Future<List<SpaceMember>> listMembers(String spaceId) async =>
      _members.values.where((member) => member.spaceId == spaceId).toList();

  @override
  Future<void> updateMemberRole(SpaceMember member, String role) async {
    _members[member.id] = member.copyWith(role: role);
  }

  @override
  Future<void> updateMemberDisplayName(
    SpaceMember member,
    String displayName,
  ) async {
    if (member.userId == _user.id) {
      _members[member.id] = member.copyWith(displayName: displayName.trim());
    }
  }

  @override
  Future<SpaceInvite> createInvite(String spaceId, Duration validity) async {
    final invite = SpaceInvite(
      id: _uuid.v4(),
      spaceId: spaceId,
      code: 'DEMO-${_uuid.v4().substring(0, 6).toUpperCase()}',
      expiresAt: _now().add(validity),
    );
    _invites[invite.id] = invite;
    return invite;
  }

  @override
  Future<List<SpaceInvite>> listInvites(String spaceId) async =>
      _invites.values.where((invite) => invite.spaceId == spaceId).toList()
        ..sort((a, b) => b.expiresAt.compareTo(a.expiresAt));

  @override
  Future<void> revokeInvite(SpaceInvite invite) async {
    _invites[invite.id] = invite.copyWith(revokedAt: _now());
  }

  @override
  Future<void> leaveSpace(
    String spaceId, {
    String personalDataAction = 'keep',
    String? targetSpaceId,
  }) async {
    final member = _members.values
        .where((item) => item.spaceId == spaceId && item.userId == _user.id)
        .firstOrNull;
    if (member == null) return;
    if (member.role == 'admin' &&
        !_members.values.any(
          (item) =>
              item.spaceId == spaceId &&
              item.role == 'admin' &&
              item.userId != _user.id,
        )) {
      throw const AppException('마지막 관리자는 다른 멤버를 관리자로 지정한 뒤 탈퇴해야 합니다.');
    }
    if (personalDataAction == 'delete') {
      final now = _now();
      for (final item in _items.values.where(
        (item) =>
            item.spaceId == spaceId &&
            item.createdBy == _user.id &&
            item.visibility == 'private' &&
            item.deletedAt == null,
      )) {
        _items[item.id] = item.copyWith(
          deletedAt: now,
          deletePurgeAt: now.add(const Duration(days: 30)),
          version: item.version + 1,
          updatedAt: now,
        );
      }
    } else if (personalDataAction == 'move') {
      if (targetSpaceId == null || !_spaces.containsKey(targetSpaceId)) {
        throw const AppException('개인 데이터를 옮길 공간을 선택해 주세요.');
      }
      final now = _now();
      for (final item in _items.values.where(
        (item) =>
            item.spaceId == spaceId &&
            item.createdBy == _user.id &&
            item.visibility == 'private' &&
            item.deletedAt == null,
      )) {
        _items[item.id] = item.copyWith(
          spaceId: targetSpaceId,
          locationId: null,
          categoryId: null,
          version: item.version + 1,
          updatedAt: now,
        );
      }
    }
    _members.remove(member.id);
    final space = _spaces[spaceId];
    if (space != null) {
      _spaces[spaceId] = space.copyWith(
        memberCount: _members.values
            .where((entry) => entry.spaceId == spaceId)
            .length,
        updatedAt: _now(),
      );
    }
  }

  @override
  Future<void> updateLastAccessed(String spaceId) async {
    _lastAccessed[spaceId] = _now();
  }

  @override
  Future<List<FloorPlan>> listFloorPlans(String spaceId) async => _floorPlans
      .values
      .where((plan) => plan.spaceId == spaceId && plan.deletedAt == null)
      .toList();

  @override
  Future<List<FloorPlan>> listDeletedFloorPlans(String spaceId) async =>
      _floorPlans.values
          .where((plan) => plan.spaceId == spaceId && plan.deletedAt != null)
          .toList();

  @override
  Future<FloorPlan> createFloorPlan({
    required String spaceId,
    required String name,
  }) async {
    final now = _now();
    final plan = FloorPlan(
      id: _uuid.v4(),
      spaceId: spaceId,
      name: name,
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
      layoutData: {
        'grid': {'rows': 20, 'cols': 20},
        'activeCells': <String>[],
        'walls': <Map<String, dynamic>>[],
        'rooms': <Map<String, dynamic>>[],
      },
    );
    _floorPlans[plan.id] = plan;
    return plan;
  }

  @override
  Future<FloorPlan> saveFloorPlan(
    FloorPlan floorPlan, {
    required int version,
  }) async {
    final current = _floorPlans[floorPlan.id];
    if (current == null || current.version != version) {
      throw const ConflictException();
    }
    final saved = floorPlan.copyWith(version: version + 1, updatedAt: _now());
    _floorPlans[floorPlan.id] = saved;
    return saved;
  }

  @override
  Future<void> softDeleteFloorPlan(FloorPlan floorPlan) async {
    final current = _floorPlans[floorPlan.id];
    if (current == null ||
        current.deletedAt != null ||
        current.spaceId != floorPlan.spaceId) {
      throw const ConflictException();
    }
    final active = await listFloorPlans(current.spaceId);
    if (active.length <= 1) {
      throw const AppException('공간에는 최소 한 개의 평면도가 필요합니다.');
    }
    final now = _now();
    final purgeAt = now.add(const Duration(days: 30));
    final locations = _locations.values
        .where(
          (location) =>
              location.floorPlanId == current.id && location.deletedAt == null,
        )
        .toList();

    // Keep the demo repository's relationship behavior aligned with the
    // database trigger: only active locations/items in this deletion batch
    // are disconnected and eligible for restoration.
    for (final location in locations) {
      final items = _items.values
          .where(
            (item) => item.locationId == location.id && item.deletedAt == null,
          )
          .toList();
      _locationRecovery[location.id] = _items.values
          .where(
            (item) => item.locationId == location.id && item.deletedAt == null,
          )
          .map((item) => item.id)
          .toList();
      _locations[location.id] = location.copyWith(
        deletedAt: now,
        deletePurgeAt: purgeAt,
        updatedAt: now,
      );
      for (final item in items) {
        _items[item.id] = item.copyWith(locationId: null, updatedAt: now);
      }
    }
    _floorPlans[current.id] = current.copyWith(
      deletedAt: now,
      deletePurgeAt: purgeAt,
      updatedAt: now,
    );
  }

  @override
  Future<void> restoreFloorPlan(FloorPlan floorPlan) async {
    final current = _floorPlans[floorPlan.id];
    if (current == null || current.deletedAt == null) {
      throw const ConflictException();
    }
    final deletionAt = current.deletedAt;
    final purgeAt = current.deletePurgeAt;
    final now = _now();
    if (purgeAt == null || !purgeAt.isAfter(now)) {
      throw const AppException('복구 가능 기간이 지났습니다.');
    }
    final locations = _locations.values
        .where(
          (location) =>
              location.floorPlanId == current.id &&
              location.deletedAt == deletionAt &&
              location.deletePurgeAt == purgeAt,
        )
        .toList();

    _floorPlans[current.id] = current.copyWith(
      deletedAt: null,
      deletePurgeAt: null,
      updatedAt: now,
    );
    for (final location in locations) {
      _locations[location.id] = location.copyWith(
        deletedAt: null,
        deletePurgeAt: null,
        updatedAt: now,
      );
      for (final itemId in _locationRecovery[location.id] ?? const <String>[]) {
        final item = _items[itemId];
        if (item != null &&
            item.spaceId == current.spaceId &&
            item.locationId == null &&
            item.deletedAt == null) {
          _items[item.id] = item.copyWith(
            locationId: location.id,
            updatedAt: now,
          );
        }
      }
    }
  }

  @override
  Future<List<Location>> listLocations(String floorPlanId) async => _locations
      .values
      .where(
        (location) =>
            location.floorPlanId == floorPlanId && location.deletedAt == null,
      )
      .toList();

  @override
  Future<List<Location>> listDeletedLocations(String spaceId) async =>
      _locations.values
          .where(
            (location) =>
                location.spaceId == spaceId && location.deletedAt != null,
          )
          .toList();

  @override
  Future<Location> saveLocation(
    Location location, {
    required bool isNew,
  }) async {
    _validateLocationTarget(location);
    final now = _now();
    final saved = isNew
        ? location.copyWith(
            id: location.id.isEmpty ? _uuid.v4() : location.id,
            createdAt: now,
            updatedAt: now,
          )
        : _saveExistingLocation(location, now);
    _locations[saved.id] = saved;
    return saved;
  }

  Location _saveExistingLocation(Location location, DateTime now) {
    final current = _locations[location.id];
    if (current == null || current.version != location.version) {
      throw const ConflictException();
    }
    return location.copyWith(version: location.version + 1, updatedAt: now);
  }

  void _validateLocationTarget(Location location) {
    final floorPlan = _floorPlans[location.floorPlanId];
    if (floorPlan == null ||
        floorPlan.deletedAt != null ||
        floorPlan.spaceId != location.spaceId) {
      throw const AppException('위치를 저장할 평면도를 찾을 수 없습니다.');
    }
  }

  @override
  Future<void> softDeleteLocation(Location location) async {
    final current = _locations[location.id];
    if (current == null ||
        current.deletedAt != null ||
        current.spaceId != location.spaceId) {
      throw const ConflictException();
    }
    final now = _now();
    final purgeAt = now.add(const Duration(days: 30));
    final items = _items.values
        .where(
          (item) => item.locationId == current.id && item.deletedAt == null,
        )
        .toList();
    _locationRecovery[current.id] = items.map((item) => item.id).toList();
    _locations[current.id] = current.copyWith(
      deletedAt: now,
      deletePurgeAt: purgeAt,
      updatedAt: now,
    );
    for (final item in items) {
      _items[item.id] = item.copyWith(locationId: null, updatedAt: now);
    }
  }

  @override
  Future<void> restoreLocation(Location location) async {
    final current = _locations[location.id];
    if (current == null || current.deletedAt == null) {
      throw const ConflictException();
    }
    final purgeAt = current.deletePurgeAt;
    final now = _now();
    if (purgeAt == null || !purgeAt.isAfter(now)) {
      throw const AppException('복구 가능 기간이 지났습니다.');
    }
    final floorPlan = _floorPlans[current.floorPlanId];
    if (floorPlan == null || floorPlan.deletedAt != null) {
      throw const AppException('평면도가 삭제된 상태입니다.');
    }
    _locations[current.id] = current.copyWith(
      deletedAt: null,
      deletePurgeAt: null,
      updatedAt: now,
    );
    for (final itemId in _locationRecovery[current.id] ?? const <String>[]) {
      final item = _items[itemId];
      if (item != null &&
          item.spaceId == current.spaceId &&
          item.locationId == null &&
          item.deletedAt == null) {
        _items[item.id] = item.copyWith(locationId: current.id, updatedAt: now);
      }
    }
  }

  @override
  Future<List<Category>> listCategories(String spaceId) async => _categories
      .values
      .where(
        (category) => category.spaceId == null || category.spaceId == spaceId,
      )
      .toList();

  @override
  Future<Category> createCategory({
    required String spaceId,
    required String name,
  }) async {
    final category = Category(
      id: _uuid.v4(),
      spaceId: spaceId,
      name: name.trim(),
    );
    _categories[category.id] = category;
    return category;
  }

  @override
  Future<void> deleteCategory(Category category) async {
    if (!category.isSystem) _categories.remove(category.id);
  }

  @override
  Future<List<Item>> listItems(String spaceId, {String? search}) async {
    final locations = _locations.values.toList();
    final categories = _categories.values.toList();
    final normalized = search?.trim().toLowerCase();
    final result = _items.values.where((item) {
      if (item.spaceId != spaceId || item.deletedAt != null) return false;
      if (normalized == null || normalized.isEmpty) return true;
      final locationName = locations
          .where((location) => location.id == item.locationId)
          .map((location) => location.name)
          .firstOrNull;
      final categoryName = categories
          .where((category) => category.id == item.categoryId)
          .map((category) => category.name)
          .firstOrNull;
      return item.name.toLowerCase().contains(normalized) ||
          (locationName?.toLowerCase().contains(normalized) ?? false) ||
          (categoryName?.toLowerCase().contains(normalized) ?? false);
    }).toList();
    result.sort((a, b) {
      if (normalized == null || normalized.isEmpty) {
        final aLocation = locations
            .where((location) => location.id == a.locationId)
            .map((location) => location.name)
            .firstOrNull;
        final bLocation = locations
            .where((location) => location.id == b.locationId)
            .map((location) => location.name)
            .firstOrNull;
        final locationComparison = (aLocation ?? '\uffff').compareTo(
          bLocation ?? '\uffff',
        );
        return locationComparison == 0
            ? a.name.compareTo(b.name)
            : locationComparison;
      }
      int rank(Item item) {
        final name = item.name.toLowerCase();
        if (name == normalized) return 0;
        if (name.startsWith(normalized)) return 1;
        if (name.contains(normalized)) return 2;
        return 3;
      }

      final rankComparison = rank(a).compareTo(rank(b));
      return rankComparison == 0 ? a.name.compareTo(b.name) : rankComparison;
    });
    return result;
  }

  @override
  Future<List<Item>> listDeletedItems(String spaceId) async => _items.values
      .where((item) => item.spaceId == spaceId && item.deletedAt != null)
      .toList();

  @override
  Future<Item> saveItem(Item item, {required bool isNew}) async {
    final now = _now();
    final current = _items[item.id];
    if (!isNew &&
        (current == null ||
            current.deletedAt != null ||
            current.version != item.version)) {
      throw const ConflictException();
    }
    final targetSpace = _spaces[item.spaceId];
    if (targetSpace == null || targetSpace.deletedAt != null) {
      throw const AppException('물건을 저장할 공간을 찾을 수 없습니다.');
    }
    final locationId = item.locationId;
    if (locationId != null) {
      final location = _locations[locationId];
      if (location == null ||
          location.deletedAt != null ||
          location.spaceId != item.spaceId) {
        throw const AppException('물건을 저장할 위치를 찾을 수 없습니다.');
      }
    }
    final saved = isNew
        ? item.copyWith(
            id: item.id.isEmpty ? _uuid.v4() : item.id,
            createdAt: now,
            updatedAt: now,
          )
        : item.copyWith(version: item.version + 1, updatedAt: now);
    _items[saved.id] = saved;
    return saved;
  }

  @override
  Future<void> softDeleteItem(Item item) async {
    final current = _items[item.id];
    if (current == null ||
        current.deletedAt != null ||
        current.version != item.version) {
      throw const ConflictException();
    }
    final now = _now();
    _items[item.id] = current.copyWith(
      deletedAt: now,
      deletePurgeAt: now.add(const Duration(days: 30)),
      version: current.version + 1,
      updatedAt: now,
    );
  }

  @override
  Future<void> restoreItem(Item item) async {
    final current = _items[item.id];
    if (current == null || current.deletedAt == null) {
      throw const ConflictException();
    }
    final purgeAt = current.deletePurgeAt;
    final now = _now();
    if (purgeAt == null || !purgeAt.isAfter(now)) {
      throw const AppException('복구 가능 기간이 지났습니다.');
    }
    final oldLocationId = current.locationId;
    final location = oldLocationId == null ? null : _locations[oldLocationId];
    final validLocationId =
        location != null &&
            location.deletedAt == null &&
            location.spaceId == current.spaceId
        ? location.id
        : null;
    _items[item.id] = current.copyWith(
      locationId: validLocationId,
      deletedAt: null,
      deletePurgeAt: null,
      version: current.version + 1,
      updatedAt: now,
    );
  }

  @override
  Future<void> toggleFavorite(Item item) async {
    final current = _items[item.id];
    if (current == null) return;
    _items[item.id] = current.copyWith(isFavorite: !current.isFavorite);
  }

  @override
  Future<Item> moveItem(
    Item item, {
    required String targetSpaceId,
    String? targetLocationId,
  }) async {
    final targetSpace = _spaces[targetSpaceId];
    if (targetSpace == null || targetSpace.deletedAt != null) {
      throw const AppException('이동할 공간을 찾을 수 없습니다.');
    }
    final current = _items[item.id];
    if (current == null ||
        current.deletedAt != null ||
        current.version != item.version) {
      throw const ConflictException();
    }
    if (targetLocationId != null) {
      final targetLocation = _locations[targetLocationId];
      if (targetLocation == null ||
          targetLocation.deletedAt != null ||
          targetLocation.spaceId != targetSpaceId) {
        throw const AppException('이동할 위치를 찾을 수 없습니다.');
      }
    }
    final category = current.categoryId == null
        ? null
        : _categories[current.categoryId!];
    final targetCategoryId =
        category == null ||
            (category.spaceId != null && category.spaceId != targetSpaceId)
        ? null
        : current.categoryId;
    final now = _now();
    final moved = current.copyWith(
      spaceId: targetSpaceId,
      locationId: targetLocationId,
      categoryId: targetCategoryId,
      version: current.version + 1,
      updatedAt: now,
    );
    _items[item.id] = moved;
    _history.add(
      ItemLocationHistory(
        id: _uuid.v4(),
        itemId: item.id,
        fromSpaceId: item.spaceId,
        fromLocationId: item.locationId,
        toSpaceId: targetSpaceId,
        toLocationId: targetLocationId,
        movedBy: _user.id,
        movedAt: now,
        reason: 'space_move',
      ),
    );
    return moved;
  }

  @override
  Future<List<ItemLocationHistory>> listItemLocationHistory(
    String itemId,
  ) async => _history.where((entry) => entry.itemId == itemId).toList();

  @override
  Future<ItemPhoto> uploadItemPhoto({
    required Item item,
    required Uint8List bytes,
    required String extension,
  }) async {
    final current = _items[item.id] ?? item;
    if (current.photos.length >= 3) {
      throw const AppException('물건 사진은 최대 3장까지 추가할 수 있습니다.');
    }
    final photo = ItemPhoto(
      id: _uuid.v4(),
      itemId: current.id,
      storagePath: '${_user.id}/${current.id}/${_uuid.v4()}.$extension',
      isPrimary: current.photos.every((photo) => !photo.isPrimary),
      sortOrder: current.photos.length,
    );
    _items[current.id] = current.copyWith(photos: [...current.photos, photo]);
    return photo;
  }

  @override
  Future<void> deleteItemPhoto(Item item, ItemPhoto photo) async {
    final current = _items[item.id];
    if (current == null) throw const AppException('물건을 찾을 수 없습니다.');
    if (!current.photos.any((entry) => entry.id == photo.id)) {
      throw const AppException('사진을 찾을 수 없습니다.');
    }
    _items[item.id] = current.copyWith(
      photos: current.photos.where((entry) => entry.id != photo.id).toList(),
    );
  }

  @override
  Future<void> setPrimaryItemPhoto(Item item, ItemPhoto photo) async {
    final current = _items[item.id];
    if (current == null ||
        !current.photos.any((entry) => entry.id == photo.id)) {
      throw const AppException('사진을 찾을 수 없습니다.');
    }
    _items[item.id] = current.copyWith(
      photos: current.photos
          .map((entry) => entry.copyWith(isPrimary: entry.id == photo.id))
          .toList(),
    );
  }

  @override
  Future<String> createItemPhotoSignedUrl(ItemPhoto photo) async => '';

  @override
  Future<List<ShoppingItem>> listShoppingItems(String spaceId) async =>
      _shoppingItems.values.where((item) => item.spaceId == spaceId).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  @override
  Future<ShoppingItem> addShoppingItem({
    required String spaceId,
    required String name,
  }) async {
    final now = _now();
    final items = await listShoppingItems(spaceId);
    final item = ShoppingItem(
      id: _uuid.v4(),
      shoppingListId: 'demo-shopping-list',
      spaceId: spaceId,
      name: name,
      sortOrder: items.length.toDouble(),
      createdBy: _user.id,
      createdAt: now,
      updatedAt: now,
    );
    _shoppingItems[item.id] = item;
    return item;
  }

  @override
  Future<void> updateShoppingItem(ShoppingItem item) async =>
      _shoppingItems[item.id] = item.copyWith(updatedAt: _now());

  @override
  Future<void> deleteShoppingItem(ShoppingItem item) async =>
      _shoppingItems.remove(item.id);

  @override
  Future<List<Checklist>> listChecklists({String? spaceId}) async => _checklists
      .values
      .where(
        (item) =>
            spaceId == null ||
            item.spaceId == spaceId ||
            (item.spaceId == null && item.createdBy == _user.id),
      )
      .toList();

  @override
  Future<List<ChecklistTemplate>> listChecklistTemplates() async =>
      _templates.values.toList()..sort((a, b) => a.name.compareTo(b.name));

  @override
  Future<List<ChecklistTemplateItem>> listChecklistTemplateItems(
    String templateId,
  ) async =>
      List<ChecklistTemplateItem>.from(_templateItems[templateId] ?? const []);

  @override
  Future<ChecklistTemplate> createChecklistTemplate({
    required String name,
  }) async {
    final template = ChecklistTemplate(
      id: _uuid.v4(),
      name: name.trim(),
      templateType: 'user',
    );
    _templates[template.id] = template;
    _templateItems[template.id] = [];
    return template;
  }

  @override
  Future<ChecklistTemplateItem> saveChecklistTemplateItem({
    required String templateId,
    required String name,
    required double sortOrder,
  }) async {
    final item = ChecklistTemplateItem(
      id: _uuid.v4(),
      templateId: templateId,
      name: name.trim(),
      sortOrder: sortOrder,
    );
    _templateItems.putIfAbsent(templateId, () => []).add(item);
    return item;
  }

  @override
  Future<List<ChecklistItem>> listChecklistItems(String checklistId) async =>
      _checklistItems.values
          .where((item) => item.checklistId == checklistId)
          .toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  @override
  Future<Checklist> createChecklist({
    String? spaceId,
    required String name,
    required String visibility,
  }) async {
    final now = _now();
    final checklist = Checklist(
      id: _uuid.v4(),
      spaceId: spaceId,
      createdBy: _user.id,
      name: name,
      visibility: visibility,
      createdAt: now,
      updatedAt: now,
    );
    _checklists[checklist.id] = checklist;
    return checklist;
  }

  @override
  Future<ChecklistItem> saveChecklistItem(
    ChecklistItem item, {
    required bool isNew,
  }) async {
    final saved = isNew && item.id.isEmpty
        ? item.copyWith(id: _uuid.v4())
        : item;
    _checklistItems[saved.id] = saved;
    return saved;
  }

  @override
  Future<void> deleteChecklistItem(ChecklistItem item) async {
    _checklistItems.remove(item.id);
  }

  @override
  Future<void> toggleChecklistItem(ChecklistItem item) async {
    _checklistItems[item.id] = item.copyWith(
      isFinalCompleted: !item.isFinalCompleted,
      finalCompletedBy: !item.isFinalCompleted ? _user.id : null,
      finalCompletedAt: !item.isFinalCompleted ? _now() : null,
    );
  }

  @override
  Future<List<ChecklistMemberCheck>> listMemberChecks(
    String checklistItemId,
  ) async => _memberChecks.values
      .where((check) => check.checklistItemId == checklistItemId)
      .toList();

  @override
  Future<void> toggleMemberCheck(ChecklistMemberCheck check) async {
    _memberChecks['${check.checklistItemId}:${check.userId}'] = check.copyWith(
      isChecked: !check.isChecked,
      checkedAt: !check.isChecked ? _now() : null,
    );
  }

  @override
  Future<void> completeChecklist(
    Checklist checklist, {
    required bool complete,
  }) async {
    _checklists[checklist.id] = checklist.copyWith(
      isCompleted: complete,
      completedBy: complete ? _user.id : null,
      completedAt: complete ? _now() : null,
      updatedAt: _now(),
    );
  }

  @override
  Stream<List<ShoppingItem>> watchShoppingItems(String spaceId) async* {
    yield await listShoppingItems(spaceId);
  }

  @override
  Stream<List<ChecklistItem>> watchChecklistItems(String checklistId) async* {
    yield await listChecklistItems(checklistId);
  }

  @override
  Stream<List<ChecklistMemberCheck>> watchMemberChecks(
    String checklistItemId,
  ) async* {
    yield await listMemberChecks(checklistItemId);
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
