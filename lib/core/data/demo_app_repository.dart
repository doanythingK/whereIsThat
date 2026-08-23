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
  final Map<String, ChecklistMemberCheck> _memberChecks = {};
  final List<ItemLocationHistory> _history = [];
  final Map<String, DateTime> _lastAccessed = {};
  final Map<String, String?> _locationRecovery = {};

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
  }

  @override
  Future<AppUser?> currentUser() async => _user;

  @override
  Future<void> signIn(SocialProvider provider) async {}

  @override
  Future<void> signOut() async {}

  @override
  Future<void> deleteAccount() async {}

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
        .where((space) => space.deletedAt == null)
        .toList();
    spaces.sort(
      (a, b) => (_lastAccessed[b.id] ?? DateTime(1970)).compareTo(
        _lastAccessed[a.id] ?? DateTime(1970),
      ),
    );
    return spaces;
  }

  @override
  Future<Space> createSpace({
    required String name,
    required String iconKey,
  }) async {
    final now = _now();
    final spaceId = _uuid.v4();
    final space = Space(
      id: spaceId,
      name: name,
      iconKey: iconKey,
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
  Future<void> revokeInvite(SpaceInvite invite) async {
    _invites[invite.id] = invite.copyWith(revokedAt: _now());
  }

  @override
  Future<void> leaveSpace(String spaceId) async {
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
    _members[member.id] = member.copyWith(lastAccessedAt: null);
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
    final active = await listFloorPlans(floorPlan.spaceId);
    if (active.length <= 1) {
      throw const AppException('공간에는 최소 한 개의 평면도가 필요합니다.');
    }
    final now = _now();
    _floorPlans[floorPlan.id] = floorPlan.copyWith(
      deletedAt: now,
      deletePurgeAt: now.add(const Duration(days: 30)),
      updatedAt: now,
    );
    for (final location in _locations.values.where(
      (item) => item.floorPlanId == floorPlan.id,
    )) {
      _locationRecovery[location.id] = _items.values
          .firstWhere(
            (item) => item.locationId == location.id,
            orElse: () => _items.values.first,
          )
          .id;
      _locations[location.id] = location.copyWith(
        deletedAt: now,
        deletePurgeAt: now.add(const Duration(days: 30)),
      );
      for (final item in _items.values.where(
        (item) => item.locationId == location.id,
      )) {
        _items[item.id] = item.copyWith(locationId: null, updatedAt: now);
      }
    }
  }

  @override
  Future<void> restoreFloorPlan(FloorPlan floorPlan) async {
    _floorPlans[floorPlan.id] = floorPlan.copyWith(
      deletedAt: null,
      deletePurgeAt: null,
    );
    for (final location in _locations.values.where(
      (item) => item.floorPlanId == floorPlan.id,
    )) {
      _locations[location.id] = location.copyWith(
        deletedAt: null,
        deletePurgeAt: null,
      );
      final itemId = _locationRecovery[location.id];
      final item = itemId == null ? null : _items[itemId];
      if (item != null && item.locationId == null) {
        _items[item.id] = item.copyWith(locationId: location.id);
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
  Future<Location> saveLocation(
    Location location, {
    required bool isNew,
  }) async {
    final now = _now();
    final saved = isNew
        ? location.copyWith(
            id: location.id.isEmpty ? _uuid.v4() : location.id,
            createdAt: now,
            updatedAt: now,
          )
        : location.copyWith(version: location.version + 1, updatedAt: now);
    _locations[saved.id] = saved;
    return saved;
  }

  @override
  Future<void> softDeleteLocation(Location location) async {
    final now = _now();
    _locations[location.id] = location.copyWith(
      deletedAt: now,
      deletePurgeAt: now.add(const Duration(days: 30)),
    );
    for (final item in _items.values.where(
      (item) => item.locationId == location.id,
    )) {
      _locationRecovery[location.id] = item.id;
      _items[item.id] = item.copyWith(locationId: null, updatedAt: now);
    }
  }

  @override
  Future<void> restoreLocation(Location location) async {
    _locations[location.id] = location.copyWith(
      deletedAt: null,
      deletePurgeAt: null,
    );
    final itemId = _locationRecovery[location.id];
    final item = itemId == null ? null : _items[itemId];
    if (item != null && item.locationId == null) {
      _items[item.id] = item.copyWith(locationId: location.id);
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
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  @override
  Future<Item> saveItem(Item item, {required bool isNew}) async {
    final now = _now();
    final current = _items[item.id];
    if (!isNew && current != null && current.version != item.version) {
      throw const ConflictException();
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
    final now = _now();
    _items[item.id] = item.copyWith(
      deletedAt: now,
      deletePurgeAt: now.add(const Duration(days: 30)),
      updatedAt: now,
    );
  }

  @override
  Future<void> restoreItem(Item item) async => _items[item.id] = item.copyWith(
    deletedAt: null,
    deletePurgeAt: null,
    updatedAt: _now(),
  );

  @override
  Future<void> toggleFavorite(Item item) async =>
      _items[item.id] = item.copyWith(isFavorite: !item.isFavorite);

  @override
  Future<Item> moveItem(
    Item item, {
    required String targetSpaceId,
    String? targetLocationId,
  }) async {
    if (!_spaces.containsKey(targetSpaceId)) {
      throw const AppException('이동할 공간을 찾을 수 없습니다.');
    }
    final now = _now();
    final moved = item.copyWith(
      spaceId: targetSpaceId,
      locationId: targetLocationId,
      version: item.version + 1,
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
    if (item.photos.length >= 3) {
      throw const AppException('물건 사진은 최대 3장까지 추가할 수 있습니다.');
    }
    final photo = ItemPhoto(
      id: _uuid.v4(),
      itemId: item.id,
      storagePath: '${_user.id}/${item.id}/${_uuid.v4()}.$extension',
      isPrimary: item.photos.isEmpty,
      sortOrder: item.photos.length,
    );
    _items[item.id] = item.copyWith(photos: [...item.photos, photo]);
    return photo;
  }

  @override
  Future<void> deleteItemPhoto(Item item, ItemPhoto photo) async {
    _items[item.id] = item.copyWith(
      photos: item.photos.where((entry) => entry.id != photo.id).toList(),
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
      .where((item) => spaceId == null || item.spaceId == spaceId)
      .toList();

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
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
