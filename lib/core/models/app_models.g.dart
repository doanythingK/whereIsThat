// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  email: json['email'] as String?,
  nickname: json['nickname'] as String?,
  profileImagePath: json['profile_image_path'] as String?,
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'nickname': instance.nickname,
  'profile_image_path': instance.profileImagePath,
};

_Space _$SpaceFromJson(Map<String, dynamic> json) => _Space(
  id: json['id'] as String,
  name: json['name'] as String,
  iconKey: json['icon_key'] as String? ?? 'home',
  iconColor: json['icon_color'] as String?,
  createdBy: json['created_by'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  deletePurgeAt: json['delete_purge_at'] == null
      ? null
      : DateTime.parse(json['delete_purge_at'] as String),
  memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SpaceToJson(_Space instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'icon_key': instance.iconKey,
  'icon_color': instance.iconColor,
  'created_by': instance.createdBy,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'delete_purge_at': instance.deletePurgeAt?.toIso8601String(),
  'memberCount': instance.memberCount,
};

_SpaceMember _$SpaceMemberFromJson(Map<String, dynamic> json) => _SpaceMember(
  id: json['id'] as String,
  spaceId: json['space_id'] as String,
  userId: json['user_id'] as String,
  role: json['role'] as String? ?? 'member',
  displayName: json['display_name'] as String?,
  joinedAt: DateTime.parse(json['joined_at'] as String),
  lastAccessedAt: json['last_accessed_at'] == null
      ? null
      : DateTime.parse(json['last_accessed_at'] as String),
);

Map<String, dynamic> _$SpaceMemberToJson(_SpaceMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'space_id': instance.spaceId,
      'user_id': instance.userId,
      'role': instance.role,
      'display_name': instance.displayName,
      'joined_at': instance.joinedAt.toIso8601String(),
      'last_accessed_at': instance.lastAccessedAt?.toIso8601String(),
    };

_SpaceInvite _$SpaceInviteFromJson(Map<String, dynamic> json) => _SpaceInvite(
  id: json['id'] as String,
  spaceId: json['space_id'] as String,
  code: json['code'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
  revokedAt: json['revoked_at'] == null
      ? null
      : DateTime.parse(json['revoked_at'] as String),
  maxUses: (json['max_uses'] as num?)?.toInt(),
  useCount: (json['use_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SpaceInviteToJson(_SpaceInvite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'space_id': instance.spaceId,
      'code': instance.code,
      'expires_at': instance.expiresAt.toIso8601String(),
      'revoked_at': instance.revokedAt?.toIso8601String(),
      'max_uses': instance.maxUses,
      'use_count': instance.useCount,
    };

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  id: json['id'] as String,
  spaceId: json['space_id'] as String,
  floorPlanId: json['floor_plan_id'] as String,
  roomKey: json['room_key'] as String?,
  name: json['name'] as String,
  locationType: json['location_type'] as String?,
  iconKey: json['icon_key'] as String? ?? 'shelf',
  iconColor: json['icon_color'] as String?,
  showLabel: json['show_label'] as bool? ?? true,
  xRatio: (json['x_ratio'] as num).toDouble(),
  yRatio: (json['y_ratio'] as num).toDouble(),
  zIndex: (json['z_index'] as num?)?.toInt() ?? 0,
  version: (json['version'] as num?)?.toInt() ?? 1,
  createdBy: json['created_by'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  deletePurgeAt: json['delete_purge_at'] == null
      ? null
      : DateTime.parse(json['delete_purge_at'] as String),
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'id': instance.id,
  'space_id': instance.spaceId,
  'floor_plan_id': instance.floorPlanId,
  'room_key': instance.roomKey,
  'name': instance.name,
  'location_type': instance.locationType,
  'icon_key': instance.iconKey,
  'icon_color': instance.iconColor,
  'show_label': instance.showLabel,
  'x_ratio': instance.xRatio,
  'y_ratio': instance.yRatio,
  'z_index': instance.zIndex,
  'version': instance.version,
  'created_by': instance.createdBy,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'deleted_at': instance.deletedAt?.toIso8601String(),
  'delete_purge_at': instance.deletePurgeAt?.toIso8601String(),
};

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  spaceId: json['space_id'] as String?,
  name: json['name'] as String,
  isSystem: json['is_system'] as bool? ?? false,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'space_id': instance.spaceId,
  'name': instance.name,
  'is_system': instance.isSystem,
};

_ItemPhoto _$ItemPhotoFromJson(Map<String, dynamic> json) => _ItemPhoto(
  id: json['id'] as String,
  itemId: json['item_id'] as String,
  storagePath: json['storage_path'] as String,
  isPrimary: json['is_primary'] as bool? ?? false,
  sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ItemPhotoToJson(_ItemPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'storage_path': instance.storagePath,
      'is_primary': instance.isPrimary,
      'sort_order': instance.sortOrder,
    };

_ItemLocationHistory _$ItemLocationHistoryFromJson(Map<String, dynamic> json) =>
    _ItemLocationHistory(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      fromSpaceId: json['from_space_id'] as String?,
      fromLocationId: json['from_location_id'] as String?,
      toSpaceId: json['to_space_id'] as String?,
      toLocationId: json['to_location_id'] as String?,
      movedBy: json['moved_by'] as String?,
      movedAt: DateTime.parse(json['moved_at'] as String),
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ItemLocationHistoryToJson(
  _ItemLocationHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'item_id': instance.itemId,
  'from_space_id': instance.fromSpaceId,
  'from_location_id': instance.fromLocationId,
  'to_space_id': instance.toSpaceId,
  'to_location_id': instance.toLocationId,
  'moved_by': instance.movedBy,
  'moved_at': instance.movedAt.toIso8601String(),
  'reason': instance.reason,
};

_ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) =>
    _ShoppingItem(
      id: json['id'] as String,
      shoppingListId: json['shopping_list_id'] as String,
      spaceId: json['space_id'] as String,
      name: json['name'] as String,
      assigneeUserId: json['assignee_user_id'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      completedBy: json['completed_by'] as String?,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      sortOrder: (json['sort_order'] as num?)?.toDouble() ?? 0,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ShoppingItemToJson(_ShoppingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shopping_list_id': instance.shoppingListId,
      'space_id': instance.spaceId,
      'name': instance.name,
      'assignee_user_id': instance.assigneeUserId,
      'is_completed': instance.isCompleted,
      'completed_by': instance.completedBy,
      'completed_at': instance.completedAt?.toIso8601String(),
      'sort_order': instance.sortOrder,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_Checklist _$ChecklistFromJson(Map<String, dynamic> json) => _Checklist(
  id: json['id'] as String,
  spaceId: json['space_id'] as String?,
  createdBy: json['created_by'] as String,
  name: json['name'] as String,
  visibility: json['visibility'] as String? ?? 'personal',
  isCompleted: json['is_completed'] as bool? ?? false,
  completedBy: json['completed_by'] as String?,
  completedAt: json['completed_at'] == null
      ? null
      : DateTime.parse(json['completed_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ChecklistToJson(_Checklist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'space_id': instance.spaceId,
      'created_by': instance.createdBy,
      'name': instance.name,
      'visibility': instance.visibility,
      'is_completed': instance.isCompleted,
      'completed_by': instance.completedBy,
      'completed_at': instance.completedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_ChecklistItem _$ChecklistItemFromJson(Map<String, dynamic> json) =>
    _ChecklistItem(
      id: json['id'] as String,
      checklistId: json['checklist_id'] as String,
      name: json['name'] as String,
      linkedItemId: json['linked_item_id'] as String?,
      isFinalCompleted: json['is_final_completed'] as bool? ?? false,
      finalCompletedBy: json['final_completed_by'] as String?,
      finalCompletedAt: json['final_completed_at'] == null
          ? null
          : DateTime.parse(json['final_completed_at'] as String),
      sortOrder: (json['sort_order'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ChecklistItemToJson(_ChecklistItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'checklist_id': instance.checklistId,
      'name': instance.name,
      'linked_item_id': instance.linkedItemId,
      'is_final_completed': instance.isFinalCompleted,
      'final_completed_by': instance.finalCompletedBy,
      'final_completed_at': instance.finalCompletedAt?.toIso8601String(),
      'sort_order': instance.sortOrder,
    };

_ChecklistMemberCheck _$ChecklistMemberCheckFromJson(
  Map<String, dynamic> json,
) => _ChecklistMemberCheck(
  checklistItemId: json['checklist_item_id'] as String,
  userId: json['user_id'] as String,
  isChecked: json['is_checked'] as bool? ?? false,
  checkedAt: json['checked_at'] == null
      ? null
      : DateTime.parse(json['checked_at'] as String),
);

Map<String, dynamic> _$ChecklistMemberCheckToJson(
  _ChecklistMemberCheck instance,
) => <String, dynamic>{
  'checklist_item_id': instance.checklistItemId,
  'user_id': instance.userId,
  'is_checked': instance.isChecked,
  'checked_at': instance.checkedAt?.toIso8601String(),
};
