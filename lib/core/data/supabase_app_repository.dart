import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../errors/app_exception.dart';
import '../models/app_models.dart';
import 'app_repository.dart';

class SupabaseAppRepository implements AppRepository {
  SupabaseAppRepository(this._client);

  final SupabaseClient _client;
  final Uuid _uuid = const Uuid();

  @override
  bool get isDemoMode => false;

  @override
  AppUser? get signedInUser {
    final user = _client.auth.currentUser;
    return user == null ? null : _userFromAuth(user);
  }

  AppUser _userFromAuth(User user) => AppUser(
    id: user.id,
    email: user.email,
    nickname:
        user.userMetadata?['nickname'] as String? ??
        user.userMetadata?['name'] as String?,
    profileImagePath: user.userMetadata?['avatar_url'] as String?,
  );

  DateTime _now() => DateTime.now().toUtc();

  @override
  Future<AppUser?> currentUser() async {
    final user = _client.auth.currentUser;
    return user == null ? null : _userFromAuth(user);
  }

  @override
  Future<void> signIn(SocialProvider provider) async {
    final oauthProvider = switch (provider) {
      SocialProvider.google => OAuthProvider.google,
      SocialProvider.apple => OAuthProvider.apple,
      SocialProvider.kakao => OAuthProvider.kakao,
      // Configure a Supabase custom OIDC provider named `custom:naver` in
      // the dev/prod projects. Naver is not a built-in GoTrue provider.
      SocialProvider.naver => const OAuthProvider('custom:naver'),
    };
    await _client.auth.signInWithOAuth(
      oauthProvider,
      redirectTo: 'whereisthat://auth-callback',
    );
  }

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<void> deleteAccount() async {
    await _client.rpc('request_account_deletion');
  }

  @override
  Future<String> acceptInvite(String code) async {
    final result = await _client.rpc(
      'accept_space_invite',
      params: {'invite_code': code},
    );
    return result as String;
  }

  @override
  Future<List<Space>> listSpaces() async {
    final rows = await _client
        .from('spaces')
        .select()
        .isFilter('deleted_at', null)
        .order('updated_at', ascending: false);
    return (rows as List).map((row) => Space.fromJson(row)).toList();
  }

  @override
  Future<Space> createSpace({
    required String name,
    required String iconKey,
  }) async {
    final userId = _requireUserId();
    final row = await _client
        .from('spaces')
        .insert({'name': name, 'icon_key': iconKey, 'created_by': userId})
        .select()
        .single();
    return Space.fromJson(row);
  }

  @override
  Future<void> updateSpace(Space space) async {
    await _client
        .from('spaces')
        .update({
          'name': space.name,
          'icon_key': space.iconKey,
          'icon_color': space.iconColor,
          'updated_at': _now().toIso8601String(),
        })
        .eq('id', space.id);
  }

  @override
  Future<void> softDeleteSpace(Space space) async {
    final now = _now();
    await _client
        .from('spaces')
        .update({
          'deleted_at': now.toIso8601String(),
          'delete_purge_at': now
              .add(const Duration(days: 30))
              .toIso8601String(),
        })
        .eq('id', space.id);
  }

  @override
  Future<void> restoreSpace(Space space) async {
    await _client
        .from('spaces')
        .update({'deleted_at': null, 'delete_purge_at': null})
        .eq('id', space.id);
  }

  @override
  Future<List<SpaceMember>> listMembers(String spaceId) async {
    final rows = await _client
        .from('space_members')
        .select()
        .eq('space_id', spaceId)
        .isFilter('deleted_at', null)
        .order('joined_at');
    return (rows as List).map((row) => SpaceMember.fromJson(row)).toList();
  }

  @override
  Future<void> updateMemberRole(SpaceMember member, String role) async {
    await _client
        .from('space_members')
        .update({'role': role})
        .eq('id', member.id);
  }

  @override
  Future<SpaceInvite> createInvite(String spaceId, Duration validity) async {
    final userId = _requireUserId();
    final now = _now();
    final row = await _client
        .from('space_invites')
        .insert({
          'space_id': spaceId,
          'code': _uuid.v4().substring(0, 8).toUpperCase(),
          'token_hash': _uuid.v4(),
          'created_by': userId,
          'expires_at': now.add(validity).toIso8601String(),
        })
        .select()
        .single();
    return SpaceInvite.fromJson(row);
  }

  @override
  Future<void> revokeInvite(SpaceInvite invite) async {
    await _client
        .from('space_invites')
        .update({'revoked_at': _now().toIso8601String()})
        .eq('id', invite.id);
  }

  @override
  Future<void> leaveSpace(String spaceId) async {
    await _client.rpc('leave_space', params: {'target_space_id': spaceId});
  }

  @override
  Future<void> updateLastAccessed(String spaceId) async {
    await _client
        .from('space_members')
        .update({'last_accessed_at': _now().toIso8601String()})
        .eq('space_id', spaceId)
        .eq('user_id', _requireUserId());
  }

  @override
  Future<List<FloorPlan>> listFloorPlans(String spaceId) async {
    final rows = await _client
        .from('floor_plans')
        .select()
        .eq('space_id', spaceId)
        .isFilter('deleted_at', null)
        .order('created_at');
    return (rows as List).map((row) => FloorPlan.fromJson(row)).toList();
  }

  @override
  Future<FloorPlan> createFloorPlan({
    required String spaceId,
    required String name,
  }) async {
    final row = await _client
        .from('floor_plans')
        .insert({
          'space_id': spaceId,
          'name': name,
          'layout_data': {
            'grid': {'rows': 20, 'cols': 20},
            'activeCells': <String>[],
            'walls': <Map<String, dynamic>>[],
            'rooms': <Map<String, dynamic>>[],
          },
          'created_by': _requireUserId(),
        })
        .select()
        .single();
    return FloorPlan.fromJson(row);
  }

  @override
  Future<FloorPlan> saveFloorPlan(
    FloorPlan floorPlan, {
    required int version,
  }) async {
    final row = await _client
        .from('floor_plans')
        .update({
          'layout_data': floorPlan.layoutData,
          'name': floorPlan.name,
          'version': version + 1,
          'updated_at': _now().toIso8601String(),
        })
        .eq('id', floorPlan.id)
        .eq('version', version)
        .isFilter('deleted_at', null)
        .select()
        .maybeSingle();
    if (row == null) throw const ConflictException();
    return FloorPlan.fromJson(row);
  }

  @override
  Future<void> softDeleteFloorPlan(FloorPlan floorPlan) async {
    await _client.rpc(
      'soft_delete_floor_plan',
      params: {'target_floor_plan_id': floorPlan.id},
    );
  }

  @override
  Future<void> restoreFloorPlan(FloorPlan floorPlan) async {
    await _client
        .from('floor_plans')
        .update({'deleted_at': null, 'delete_purge_at': null})
        .eq('id', floorPlan.id);
    await _client.rpc(
      'restore_floor_plan',
      params: {'target_floor_plan_id': floorPlan.id},
    );
  }

  @override
  Future<List<Location>> listLocations(String floorPlanId) async {
    final rows = await _client
        .from('locations')
        .select()
        .eq('floor_plan_id', floorPlanId)
        .isFilter('deleted_at', null);
    return (rows as List).map((row) => Location.fromJson(row)).toList();
  }

  @override
  Future<Location> saveLocation(
    Location location, {
    required bool isNew,
  }) async {
    final payload = {
      'space_id': location.spaceId,
      'floor_plan_id': location.floorPlanId,
      'room_key': location.roomKey,
      'name': location.name,
      'location_type': location.locationType,
      'icon_key': location.iconKey,
      'icon_color': location.iconColor,
      'show_label': location.showLabel,
      'x_ratio': location.xRatio,
      'y_ratio': location.yRatio,
      'z_index': location.zIndex,
      'created_by': _requireUserId(),
    };
    if (isNew) {
      final row = await _client
          .from('locations')
          .insert(payload)
          .select()
          .single();
      return Location.fromJson(row);
    }
    final row = await _client
        .from('locations')
        .update(payload..remove('created_by'))
        .eq('id', location.id)
        .eq('version', location.version)
        .select()
        .maybeSingle();
    if (row == null) throw const ConflictException();
    return Location.fromJson(row);
  }

  @override
  Future<void> softDeleteLocation(Location location) async {
    await _client.rpc(
      'soft_delete_location',
      params: {'target_location_id': location.id},
    );
  }

  @override
  Future<void> restoreLocation(Location location) async {
    await _client.rpc(
      'restore_location',
      params: {'target_location_id': location.id},
    );
  }

  @override
  Future<List<Category>> listCategories(String spaceId) async {
    final rows = await _client
        .from('categories')
        .select()
        .or('space_id.is.null,space_id.eq.$spaceId')
        .isFilter('deleted_at', null)
        .order('name');
    return (rows as List).map((row) => Category.fromJson(row)).toList();
  }

  @override
  Future<List<Item>> listItems(String spaceId, {String? search}) async {
    final rows = await _client
        .from('items')
        .select()
        .eq('space_id', spaceId)
        .isFilter('deleted_at', null)
        .order('name');
    final locationRows = await _client
        .from('locations')
        .select('id,name')
        .eq('space_id', spaceId)
        .isFilter('deleted_at', null);
    final categoryRows = await _client
        .from('categories')
        .select('id,name')
        .or('space_id.is.null,space_id.eq.$spaceId')
        .isFilter('deleted_at', null);
    final locationNames = {
      for (final row in (locationRows as List))
        row['id'] as String: row['name'] as String,
    };
    final categoryNames = {
      for (final row in (categoryRows as List))
        row['id'] as String: row['name'] as String,
    };
    final favoriteRows = await _client
        .from('item_favorites')
        .select('item_id')
        .eq('user_id', _requireUserId());
    final favorites = (favoriteRows as List)
        .map((row) => row['item_id'] as String)
        .toSet();
    final normalizedSearch = search?.trim().toLowerCase();
    final result = <Item>[];
    for (final row in (rows as List)) {
      final locationName = locationNames[row['location_id'] as String?];
      final categoryName = categoryNames[row['category_id'] as String?];
      final matches =
          normalizedSearch == null ||
          normalizedSearch.isEmpty ||
          (row['name'] as String).toLowerCase().contains(normalizedSearch) ||
          (locationName?.toLowerCase().contains(normalizedSearch) ?? false) ||
          (categoryName?.toLowerCase().contains(normalizedSearch) ?? false);
      if (!matches) continue;
      final photoRows = await _client
          .from('item_photos')
          .select()
          .eq('item_id', row['id'])
          .order('sort_order');
      result.add(
        Item.fromJson({
          ...row,
          'isFavorite': favorites.contains(row['id']),
          'photos': photoRows,
        }),
      );
    }
    return result;
  }

  Map<String, dynamic> _itemPayload(Item item) => {
    'space_id': item.spaceId,
    'location_id': item.locationId,
    'category_id': item.categoryId,
    'name': item.name,
    'quantity': item.quantity,
    'unit': item.unit,
    'detail_location': item.detailLocation,
    'memo': item.memo,
    'is_food': item.isFood,
    'visibility': item.visibility,
    'owner_user_id': item.ownerUserId,
    'created_by': _requireUserId(),
  };

  @override
  Future<Item> saveItem(Item item, {required bool isNew}) async {
    if (isNew) {
      final row = await _client
          .from('items')
          .insert(_itemPayload(item))
          .select()
          .single();
      return Item.fromJson({...row, 'photos': <Map<String, dynamic>>[]});
    }
    final row = await _client
        .from('items')
        .update(_itemPayload(item)..remove('created_by'))
        .eq('id', item.id)
        .eq('version', item.version)
        .isFilter('deleted_at', null)
        .select()
        .maybeSingle();
    if (row == null) throw const ConflictException();
    return Item.fromJson({...row, 'photos': <Map<String, dynamic>>[]});
  }

  @override
  Future<void> softDeleteItem(Item item) async {
    await _client
        .from('items')
        .update({
          'deleted_at': _now().toIso8601String(),
          'delete_purge_at': _now()
              .add(const Duration(days: 30))
              .toIso8601String(),
        })
        .eq('id', item.id);
  }

  @override
  Future<void> restoreItem(Item item) async => _client
      .from('items')
      .update({'deleted_at': null, 'delete_purge_at': null})
      .eq('id', item.id);

  @override
  Future<void> toggleFavorite(Item item) async {
    final userId = _requireUserId();
    if (item.isFavorite) {
      await _client
          .from('item_favorites')
          .delete()
          .eq('item_id', item.id)
          .eq('user_id', userId);
    } else {
      await _client.from('item_favorites').insert({
        'item_id': item.id,
        'user_id': userId,
      });
    }
  }

  @override
  Future<Item> moveItem(
    Item item, {
    required String targetSpaceId,
    String? targetLocationId,
  }) async {
    final row = await _client
        .from('items')
        .update({
          'space_id': targetSpaceId,
          'location_id': targetLocationId,
          'version': item.version + 1,
        })
        .eq('id', item.id)
        .eq('version', item.version)
        .isFilter('deleted_at', null)
        .select()
        .maybeSingle();
    if (row == null) throw const ConflictException();
    return Item.fromJson({...row, 'photos': <Map<String, dynamic>>[]});
  }

  @override
  Future<List<ItemLocationHistory>> listItemLocationHistory(
    String itemId,
  ) async {
    final rows = await _client
        .from('item_location_history')
        .select()
        .eq('item_id', itemId)
        .order('moved_at', ascending: false);
    return (rows as List)
        .map((row) => ItemLocationHistory.fromJson(row))
        .toList();
  }

  @override
  Future<ItemPhoto> uploadItemPhoto({
    required Item item,
    required Uint8List bytes,
    required String extension,
  }) async {
    if (item.photos.length >= 3) {
      throw const AppException('물건 사진은 최대 3장까지 추가할 수 있습니다.');
    }
    final path = '${_requireUserId()}/${item.id}/${_uuid.v4()}.$extension';
    await _client.storage
        .from('item-photos')
        .uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: extension == 'png' ? 'image/png' : 'image/jpeg',
            upsert: false,
          ),
        );
    final row = await _client
        .from('item_photos')
        .insert({
          'item_id': item.id,
          'storage_path': path,
          'is_primary': item.photos.isEmpty,
          'sort_order': item.photos.length,
        })
        .select()
        .single();
    return ItemPhoto.fromJson(row);
  }

  @override
  Future<void> deleteItemPhoto(Item item, ItemPhoto photo) async {
    await _client.storage.from('item-photos').remove([photo.storagePath]);
    await _client.from('item_photos').delete().eq('id', photo.id);
  }

  @override
  Future<String> createItemPhotoSignedUrl(ItemPhoto photo) {
    return _client.storage
        .from('item-photos')
        .createSignedUrl(photo.storagePath, 3600);
  }

  Future<String> _shoppingListId(String spaceId) async {
    final rows = await _client
        .from('shopping_lists')
        .select('id')
        .eq('space_id', spaceId)
        .limit(1);
    if ((rows as List).isNotEmpty) return rows.first['id'] as String;
    final row = await _client
        .from('shopping_lists')
        .insert({'space_id': spaceId})
        .select('id')
        .single();
    return row['id'] as String;
  }

  @override
  Future<List<ShoppingItem>> listShoppingItems(String spaceId) async {
    final rows = await _client
        .from('shopping_items')
        .select()
        .eq('space_id', spaceId)
        .isFilter('deleted_at', null)
        .order('sort_order');
    return (rows as List).map((row) => ShoppingItem.fromJson(row)).toList();
  }

  @override
  Future<ShoppingItem> addShoppingItem({
    required String spaceId,
    required String name,
  }) async {
    final rows = await listShoppingItems(spaceId);
    final row = await _client
        .from('shopping_items')
        .insert({
          'shopping_list_id': await _shoppingListId(spaceId),
          'space_id': spaceId,
          'name': name,
          'sort_order': rows.length,
          'created_by': _requireUserId(),
        })
        .select()
        .single();
    return ShoppingItem.fromJson(row);
  }

  @override
  Future<void> updateShoppingItem(ShoppingItem item) async {
    await _client
        .from('shopping_items')
        .update({
          'name': item.name,
          'assignee_user_id': item.assigneeUserId,
          'is_completed': item.isCompleted,
          'completed_by': item.completedBy,
          'completed_at': item.completedAt?.toIso8601String(),
          'sort_order': item.sortOrder,
        })
        .eq('id', item.id);
  }

  @override
  Future<void> deleteShoppingItem(ShoppingItem item) async => _client
      .from('shopping_items')
      .update({'deleted_at': _now().toIso8601String()})
      .eq('id', item.id);

  @override
  Future<List<Checklist>> listChecklists({String? spaceId}) async {
    var query = _client.from('checklists').select();
    if (spaceId != null) query = query.eq('space_id', spaceId);
    final rows = await query
        .isFilter('deleted_at', null)
        .order('created_at', ascending: false);
    return (rows as List).map((row) => Checklist.fromJson(row)).toList();
  }

  @override
  Future<List<ChecklistItem>> listChecklistItems(String checklistId) async {
    final rows = await _client
        .from('checklist_items')
        .select()
        .eq('checklist_id', checklistId)
        .order('sort_order');
    return (rows as List).map((row) => ChecklistItem.fromJson(row)).toList();
  }

  @override
  Future<Checklist> createChecklist({
    String? spaceId,
    required String name,
    required String visibility,
  }) async {
    final row = await _client
        .from('checklists')
        .insert({
          'space_id': spaceId,
          'created_by': _requireUserId(),
          'name': name,
          'visibility': visibility,
        })
        .select()
        .single();
    return Checklist.fromJson(row);
  }

  @override
  Future<ChecklistItem> saveChecklistItem(
    ChecklistItem item, {
    required bool isNew,
  }) async {
    final payload = {
      'checklist_id': item.checklistId,
      'name': item.name,
      'linked_item_id': item.linkedItemId,
      'is_final_completed': item.isFinalCompleted,
      'final_completed_by': item.finalCompletedBy,
      'final_completed_at': item.finalCompletedAt?.toIso8601String(),
      'sort_order': item.sortOrder,
    };
    final row = isNew
        ? await _client
              .from('checklist_items')
              .insert(payload)
              .select()
              .single()
        : await _client
              .from('checklist_items')
              .update(payload)
              .eq('id', item.id)
              .select()
              .single();
    return ChecklistItem.fromJson(row);
  }

  @override
  Future<void> toggleChecklistItem(ChecklistItem item) async {
    final complete = !item.isFinalCompleted;
    await _client
        .from('checklist_items')
        .update({
          'is_final_completed': complete,
          'final_completed_by': complete ? _requireUserId() : null,
          'final_completed_at': complete ? _now().toIso8601String() : null,
        })
        .eq('id', item.id);
  }

  @override
  Future<List<ChecklistMemberCheck>> listMemberChecks(
    String checklistItemId,
  ) async {
    final rows = await _client
        .from('checklist_member_checks')
        .select()
        .eq('checklist_item_id', checklistItemId);
    return (rows as List)
        .map((row) => ChecklistMemberCheck.fromJson(row))
        .toList();
  }

  @override
  Future<void> toggleMemberCheck(ChecklistMemberCheck check) async {
    await _client.from('checklist_member_checks').upsert({
      'checklist_item_id': check.checklistItemId,
      'user_id': check.userId,
      'is_checked': !check.isChecked,
      'checked_at': !check.isChecked ? _now().toIso8601String() : null,
    }, onConflict: 'checklist_item_id,user_id');
  }

  @override
  Future<void> completeChecklist(
    Checklist checklist, {
    required bool complete,
  }) async {
    await _client
        .from('checklists')
        .update({
          'is_completed': complete,
          'completed_by': complete ? _requireUserId() : null,
          'completed_at': complete ? _now().toIso8601String() : null,
        })
        .eq('id', checklist.id);
  }

  @override
  Stream<List<ShoppingItem>> watchShoppingItems(String spaceId) {
    return _client
        .from('shopping_items')
        .stream(primaryKey: ['id'])
        .eq('space_id', spaceId)
        .order('sort_order')
        .map((rows) => rows.map(ShoppingItem.fromJson).toList());
  }

  @override
  Stream<List<ChecklistItem>> watchChecklistItems(String checklistId) {
    return _client
        .from('checklist_items')
        .stream(primaryKey: ['id'])
        .eq('checklist_id', checklistId)
        .order('sort_order')
        .map((rows) => rows.map(ChecklistItem.fromJson).toList());
  }

  String _requireUserId() =>
      _client.auth.currentUser?.id ?? (throw const AppException('로그인이 필요합니다.'));
}
