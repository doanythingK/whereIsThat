import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_models.freezed.dart';
part 'app_models.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    String? email,
    String? nickname,
    @JsonKey(name: 'profile_image_path') String? profileImagePath,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}

@freezed
abstract class Space with _$Space {
  const factory Space({
    required String id,
    required String name,
    @JsonKey(name: 'icon_key') @Default('home') String iconKey,
    @JsonKey(name: 'icon_color') String? iconColor,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'delete_purge_at') DateTime? deletePurgeAt,
    @Default(0) int memberCount,
  }) = _Space;

  factory Space.fromJson(Map<String, dynamic> json) => _$SpaceFromJson(json);
}

@freezed
abstract class SpaceMember with _$SpaceMember {
  const factory SpaceMember({
    required String id,
    @JsonKey(name: 'space_id') required String spaceId,
    @JsonKey(name: 'user_id') required String userId,
    @Default('member') String role,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'joined_at') required DateTime joinedAt,
    @JsonKey(name: 'last_accessed_at') DateTime? lastAccessedAt,
  }) = _SpaceMember;

  factory SpaceMember.fromJson(Map<String, dynamic> json) =>
      _$SpaceMemberFromJson(json);
}

@freezed
abstract class SpaceInvite with _$SpaceInvite {
  const factory SpaceInvite({
    required String id,
    @JsonKey(name: 'space_id') required String spaceId,
    required String code,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'revoked_at') DateTime? revokedAt,
    @JsonKey(name: 'max_uses') int? maxUses,
    @JsonKey(name: 'use_count') @Default(0) int useCount,
  }) = _SpaceInvite;

  factory SpaceInvite.fromJson(Map<String, dynamic> json) =>
      _$SpaceInviteFromJson(json);
}

class FloorPlan {
  const FloorPlan({
    required this.id,
    required this.spaceId,
    required this.name,
    required this.layoutData,
    this.version = 1,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deletePurgeAt,
  });

  final String id;
  final String spaceId;
  final String name;
  final Map<String, dynamic> layoutData;
  final int version;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? deletePurgeAt;

  factory FloorPlan.fromJson(Map<String, dynamic> json) => FloorPlan(
    id: json['id'] as String,
    spaceId: json['space_id'] as String,
    name: json['name'] as String,
    layoutData: Map<String, dynamic>.from(
      (json['layout_data'] as Map?) ?? const {},
    ),
    version: (json['version'] as num?)?.toInt() ?? 1,
    createdBy: json['created_by'] as String,
    createdAt: DateTime.parse(json['created_at'].toString()),
    updatedAt: DateTime.parse(json['updated_at'].toString()),
    deletedAt: json['deleted_at'] == null
        ? null
        : DateTime.parse(json['deleted_at'].toString()),
    deletePurgeAt: json['delete_purge_at'] == null
        ? null
        : DateTime.parse(json['delete_purge_at'].toString()),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'space_id': spaceId,
    'name': name,
    'layout_data': layoutData,
    'version': version,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    'delete_purge_at': deletePurgeAt?.toIso8601String(),
  };

  FloorPlan copyWith({
    String? id,
    String? spaceId,
    String? name,
    Map<String, dynamic>? layoutData,
    int? version,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _unset,
    Object? deletePurgeAt = _unset,
  }) => FloorPlan(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    name: name ?? this.name,
    layoutData: layoutData ?? this.layoutData,
    version: version ?? this.version,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: identical(deletedAt, _unset)
        ? this.deletedAt
        : deletedAt as DateTime?,
    deletePurgeAt: identical(deletePurgeAt, _unset)
        ? this.deletePurgeAt
        : deletePurgeAt as DateTime?,
  );
}

@freezed
abstract class Location with _$Location {
  const factory Location({
    required String id,
    @JsonKey(name: 'space_id') required String spaceId,
    @JsonKey(name: 'floor_plan_id') required String floorPlanId,
    @JsonKey(name: 'room_key') String? roomKey,
    required String name,
    @JsonKey(name: 'location_type') String? locationType,
    @JsonKey(name: 'icon_key') @Default('shelf') String iconKey,
    @JsonKey(name: 'icon_color') String? iconColor,
    @JsonKey(name: 'show_label') @Default(true) bool showLabel,
    @JsonKey(name: 'x_ratio') required double xRatio,
    @JsonKey(name: 'y_ratio') required double yRatio,
    @JsonKey(name: 'z_index') @Default(0) int zIndex,
    @Default(1) int version,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'delete_purge_at') DateTime? deletePurgeAt,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    @JsonKey(name: 'space_id') String? spaceId,
    required String name,
    @JsonKey(name: 'is_system') @Default(false) bool isSystem,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
abstract class ItemPhoto with _$ItemPhoto {
  const factory ItemPhoto({
    required String id,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'storage_path') required String storagePath,
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _ItemPhoto;

  factory ItemPhoto.fromJson(Map<String, dynamic> json) =>
      _$ItemPhotoFromJson(json);
}

class Item {
  const Item({
    required this.id,
    required this.spaceId,
    this.locationId,
    this.categoryId,
    required this.name,
    this.quantity = 1,
    this.unit,
    this.detailLocation,
    this.memo,
    this.isFood = false,
    this.visibility = 'shared',
    this.ownerUserId,
    required this.createdBy,
    this.version = 1,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.deletePurgeAt,
    this.isFavorite = false,
    required this.photos,
  });

  final String id;
  final String spaceId;
  final String? locationId;
  final String? categoryId;
  final String name;
  final double quantity;
  final String? unit;
  final String? detailLocation;
  final String? memo;
  final bool isFood;
  final String visibility;
  final String? ownerUserId;
  final String createdBy;
  final int version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final DateTime? deletePurgeAt;
  final bool isFavorite;
  final List<ItemPhoto> photos;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'] as String,
    spaceId: json['space_id'] as String,
    locationId: json['location_id'] as String?,
    categoryId: json['category_id'] as String?,
    name: json['name'] as String,
    quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
    unit: json['unit'] as String?,
    detailLocation: json['detail_location'] as String?,
    memo: json['memo'] as String?,
    isFood: json['is_food'] as bool? ?? false,
    visibility: json['visibility'] as String? ?? 'shared',
    ownerUserId: json['owner_user_id'] as String?,
    createdBy: json['created_by'] as String,
    version: (json['version'] as num?)?.toInt() ?? 1,
    createdAt: DateTime.parse(json['created_at'].toString()),
    updatedAt: DateTime.parse(json['updated_at'].toString()),
    deletedAt: json['deleted_at'] == null
        ? null
        : DateTime.parse(json['deleted_at'].toString()),
    deletePurgeAt: json['delete_purge_at'] == null
        ? null
        : DateTime.parse(json['delete_purge_at'].toString()),
    isFavorite: json['isFavorite'] as bool? ?? false,
    photos: ((json['photos'] as List?) ?? const [])
        .map(
          (photo) =>
              ItemPhoto.fromJson(Map<String, dynamic>.from(photo as Map)),
        )
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'space_id': spaceId,
    'location_id': locationId,
    'category_id': categoryId,
    'name': name,
    'quantity': quantity,
    'unit': unit,
    'detail_location': detailLocation,
    'memo': memo,
    'is_food': isFood,
    'visibility': visibility,
    'owner_user_id': ownerUserId,
    'created_by': createdBy,
    'version': version,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'deleted_at': deletedAt?.toIso8601String(),
    'delete_purge_at': deletePurgeAt?.toIso8601String(),
    'isFavorite': isFavorite,
    'photos': photos.map((photo) => photo.toJson()).toList(),
  };

  Item copyWith({
    Object? locationId = _unset,
    Object? categoryId = _unset,
    String? name,
    double? quantity,
    Object? unit = _unset,
    Object? detailLocation = _unset,
    Object? memo = _unset,
    bool? isFood,
    String? visibility,
    Object? ownerUserId = _unset,
    String? createdBy,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? deletedAt = _unset,
    Object? deletePurgeAt = _unset,
    bool? isFavorite,
    List<ItemPhoto>? photos,
    String? id,
    String? spaceId,
  }) => Item(
    id: id ?? this.id,
    spaceId: spaceId ?? this.spaceId,
    locationId: identical(locationId, _unset)
        ? this.locationId
        : locationId as String?,
    categoryId: identical(categoryId, _unset)
        ? this.categoryId
        : categoryId as String?,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: identical(unit, _unset) ? this.unit : unit as String?,
    detailLocation: identical(detailLocation, _unset)
        ? this.detailLocation
        : detailLocation as String?,
    memo: identical(memo, _unset) ? this.memo : memo as String?,
    isFood: isFood ?? this.isFood,
    visibility: visibility ?? this.visibility,
    ownerUserId: identical(ownerUserId, _unset)
        ? this.ownerUserId
        : ownerUserId as String?,
    createdBy: createdBy ?? this.createdBy,
    version: version ?? this.version,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: identical(deletedAt, _unset)
        ? this.deletedAt
        : deletedAt as DateTime?,
    deletePurgeAt: identical(deletePurgeAt, _unset)
        ? this.deletePurgeAt
        : deletePurgeAt as DateTime?,
    isFavorite: isFavorite ?? this.isFavorite,
    photos: photos ?? this.photos,
  );
}

const _unset = Object();

@freezed
abstract class ItemLocationHistory with _$ItemLocationHistory {
  const factory ItemLocationHistory({
    required String id,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'from_space_id') String? fromSpaceId,
    @JsonKey(name: 'from_location_id') String? fromLocationId,
    @JsonKey(name: 'to_space_id') String? toSpaceId,
    @JsonKey(name: 'to_location_id') String? toLocationId,
    @JsonKey(name: 'moved_by') String? movedBy,
    @JsonKey(name: 'moved_at') required DateTime movedAt,
    String? reason,
  }) = _ItemLocationHistory;

  factory ItemLocationHistory.fromJson(Map<String, dynamic> json) =>
      _$ItemLocationHistoryFromJson(json);
}

@freezed
abstract class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    required String id,
    @JsonKey(name: 'shopping_list_id') required String shoppingListId,
    @JsonKey(name: 'space_id') required String spaceId,
    required String name,
    @JsonKey(name: 'assignee_user_id') String? assigneeUserId,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'completed_by') String? completedBy,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'sort_order') @Default(0) double sortOrder,
    @JsonKey(name: 'created_by') required String createdBy,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ShoppingItem;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);
}

@freezed
abstract class Checklist with _$Checklist {
  const factory Checklist({
    required String id,
    @JsonKey(name: 'space_id') String? spaceId,
    @JsonKey(name: 'created_by') required String createdBy,
    required String name,
    @Default('personal') String visibility,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'completed_by') String? completedBy,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Checklist;

  factory Checklist.fromJson(Map<String, dynamic> json) =>
      _$ChecklistFromJson(json);
}

@freezed
abstract class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String id,
    @JsonKey(name: 'checklist_id') required String checklistId,
    required String name,
    @JsonKey(name: 'linked_item_id') String? linkedItemId,
    @JsonKey(name: 'is_final_completed') @Default(false) bool isFinalCompleted,
    @JsonKey(name: 'final_completed_by') String? finalCompletedBy,
    @JsonKey(name: 'final_completed_at') DateTime? finalCompletedAt,
    @JsonKey(name: 'sort_order') @Default(0) double sortOrder,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemFromJson(json);
}

@freezed
abstract class ChecklistMemberCheck with _$ChecklistMemberCheck {
  const factory ChecklistMemberCheck({
    @JsonKey(name: 'checklist_item_id') required String checklistItemId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'is_checked') @Default(false) bool isChecked,
    @JsonKey(name: 'checked_at') DateTime? checkedAt,
  }) = _ChecklistMemberCheck;

  factory ChecklistMemberCheck.fromJson(Map<String, dynamic> json) =>
      _$ChecklistMemberCheckFromJson(json);
}
