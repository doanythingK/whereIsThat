// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get id; String? get email; String? get nickname;@JsonKey(name: 'profile_image_path') String? get profileImagePath;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImagePath, profileImagePath) || other.profileImagePath == profileImagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,nickname,profileImagePath);

@override
String toString() {
  return 'AppUser(id: $id, email: $email, nickname: $nickname, profileImagePath: $profileImagePath)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String id, String? email, String? nickname,@JsonKey(name: 'profile_image_path') String? profileImagePath
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = freezed,Object? nickname = freezed,Object? profileImagePath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,profileImagePath: freezed == profileImagePath ? _self.profileImagePath : profileImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? email,  String? nickname, @JsonKey(name: 'profile_image_path')  String? profileImagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.email,_that.nickname,_that.profileImagePath);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? email,  String? nickname, @JsonKey(name: 'profile_image_path')  String? profileImagePath)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.email,_that.nickname,_that.profileImagePath);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? email,  String? nickname, @JsonKey(name: 'profile_image_path')  String? profileImagePath)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.email,_that.nickname,_that.profileImagePath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({required this.id, this.email, this.nickname, @JsonKey(name: 'profile_image_path') this.profileImagePath});
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String id;
@override final  String? email;
@override final  String? nickname;
@override@JsonKey(name: 'profile_image_path') final  String? profileImagePath;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.profileImagePath, profileImagePath) || other.profileImagePath == profileImagePath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,nickname,profileImagePath);

@override
String toString() {
  return 'AppUser(id: $id, email: $email, nickname: $nickname, profileImagePath: $profileImagePath)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String? email, String? nickname,@JsonKey(name: 'profile_image_path') String? profileImagePath
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = freezed,Object? nickname = freezed,Object? profileImagePath = freezed,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,profileImagePath: freezed == profileImagePath ? _self.profileImagePath : profileImagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Space {

 String get id; String get name;@JsonKey(name: 'icon_key') String get iconKey;@JsonKey(name: 'icon_color') String? get iconColor;@JsonKey(name: 'created_by') String get createdBy;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;@JsonKey(name: 'delete_purge_at') DateTime? get deletePurgeAt; int get memberCount;
/// Create a copy of Space
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceCopyWith<Space> get copyWith => _$SpaceCopyWithImpl<Space>(this as Space, _$identity);

  /// Serializes this Space to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Space&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.iconColor, iconColor) || other.iconColor == iconColor)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletePurgeAt, deletePurgeAt) || other.deletePurgeAt == deletePurgeAt)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,iconKey,iconColor,createdBy,createdAt,updatedAt,deletedAt,deletePurgeAt,memberCount);

@override
String toString() {
  return 'Space(id: $id, name: $name, iconKey: $iconKey, iconColor: $iconColor, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, deletePurgeAt: $deletePurgeAt, memberCount: $memberCount)';
}


}

/// @nodoc
abstract mixin class $SpaceCopyWith<$Res>  {
  factory $SpaceCopyWith(Space value, $Res Function(Space) _then) = _$SpaceCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'icon_key') String iconKey,@JsonKey(name: 'icon_color') String? iconColor,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'delete_purge_at') DateTime? deletePurgeAt, int memberCount
});




}
/// @nodoc
class _$SpaceCopyWithImpl<$Res>
    implements $SpaceCopyWith<$Res> {
  _$SpaceCopyWithImpl(this._self, this._then);

  final Space _self;
  final $Res Function(Space) _then;

/// Create a copy of Space
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? iconKey = null,Object? iconColor = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? deletePurgeAt = freezed,Object? memberCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,iconColor: freezed == iconColor ? _self.iconColor : iconColor // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletePurgeAt: freezed == deletePurgeAt ? _self.deletePurgeAt : deletePurgeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Space].
extension SpacePatterns on Space {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Space value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Space() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Space value)  $default,){
final _that = this;
switch (_that) {
case _Space():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Space value)?  $default,){
final _that = this;
switch (_that) {
case _Space() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'icon_key')  String iconKey, @JsonKey(name: 'icon_color')  String? iconColor, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'delete_purge_at')  DateTime? deletePurgeAt,  int memberCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Space() when $default != null:
return $default(_that.id,_that.name,_that.iconKey,_that.iconColor,_that.createdBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.deletePurgeAt,_that.memberCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'icon_key')  String iconKey, @JsonKey(name: 'icon_color')  String? iconColor, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'delete_purge_at')  DateTime? deletePurgeAt,  int memberCount)  $default,) {final _that = this;
switch (_that) {
case _Space():
return $default(_that.id,_that.name,_that.iconKey,_that.iconColor,_that.createdBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.deletePurgeAt,_that.memberCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'icon_key')  String iconKey, @JsonKey(name: 'icon_color')  String? iconColor, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'delete_purge_at')  DateTime? deletePurgeAt,  int memberCount)?  $default,) {final _that = this;
switch (_that) {
case _Space() when $default != null:
return $default(_that.id,_that.name,_that.iconKey,_that.iconColor,_that.createdBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.deletePurgeAt,_that.memberCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Space implements Space {
  const _Space({required this.id, required this.name, @JsonKey(name: 'icon_key') this.iconKey = 'home', @JsonKey(name: 'icon_color') this.iconColor, @JsonKey(name: 'created_by') required this.createdBy, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt, @JsonKey(name: 'delete_purge_at') this.deletePurgeAt, this.memberCount = 0});
  factory _Space.fromJson(Map<String, dynamic> json) => _$SpaceFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'icon_key') final  String iconKey;
@override@JsonKey(name: 'icon_color') final  String? iconColor;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
@override@JsonKey(name: 'delete_purge_at') final  DateTime? deletePurgeAt;
@override@JsonKey() final  int memberCount;

/// Create a copy of Space
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceCopyWith<_Space> get copyWith => __$SpaceCopyWithImpl<_Space>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Space&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.iconColor, iconColor) || other.iconColor == iconColor)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletePurgeAt, deletePurgeAt) || other.deletePurgeAt == deletePurgeAt)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,iconKey,iconColor,createdBy,createdAt,updatedAt,deletedAt,deletePurgeAt,memberCount);

@override
String toString() {
  return 'Space(id: $id, name: $name, iconKey: $iconKey, iconColor: $iconColor, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, deletePurgeAt: $deletePurgeAt, memberCount: $memberCount)';
}


}

/// @nodoc
abstract mixin class _$SpaceCopyWith<$Res> implements $SpaceCopyWith<$Res> {
  factory _$SpaceCopyWith(_Space value, $Res Function(_Space) _then) = __$SpaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'icon_key') String iconKey,@JsonKey(name: 'icon_color') String? iconColor,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'delete_purge_at') DateTime? deletePurgeAt, int memberCount
});




}
/// @nodoc
class __$SpaceCopyWithImpl<$Res>
    implements _$SpaceCopyWith<$Res> {
  __$SpaceCopyWithImpl(this._self, this._then);

  final _Space _self;
  final $Res Function(_Space) _then;

/// Create a copy of Space
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? iconKey = null,Object? iconColor = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? deletePurgeAt = freezed,Object? memberCount = null,}) {
  return _then(_Space(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,iconColor: freezed == iconColor ? _self.iconColor : iconColor // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletePurgeAt: freezed == deletePurgeAt ? _self.deletePurgeAt : deletePurgeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SpaceMember {

 String get id;@JsonKey(name: 'space_id') String get spaceId;@JsonKey(name: 'user_id') String get userId; String get role;@JsonKey(name: 'display_name') String? get displayName;@JsonKey(name: 'joined_at') DateTime get joinedAt;@JsonKey(name: 'last_accessed_at') DateTime? get lastAccessedAt;
/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceMemberCopyWith<SpaceMember> get copyWith => _$SpaceMemberCopyWithImpl<SpaceMember>(this as SpaceMember, _$identity);

  /// Serializes this SpaceMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceMember&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastAccessedAt, lastAccessedAt) || other.lastAccessedAt == lastAccessedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,role,displayName,joinedAt,lastAccessedAt);

@override
String toString() {
  return 'SpaceMember(id: $id, spaceId: $spaceId, userId: $userId, role: $role, displayName: $displayName, joinedAt: $joinedAt, lastAccessedAt: $lastAccessedAt)';
}


}

/// @nodoc
abstract mixin class $SpaceMemberCopyWith<$Res>  {
  factory $SpaceMemberCopyWith(SpaceMember value, $Res Function(SpaceMember) _then) = _$SpaceMemberCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String spaceId,@JsonKey(name: 'user_id') String userId, String role,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'joined_at') DateTime joinedAt,@JsonKey(name: 'last_accessed_at') DateTime? lastAccessedAt
});




}
/// @nodoc
class _$SpaceMemberCopyWithImpl<$Res>
    implements $SpaceMemberCopyWith<$Res> {
  _$SpaceMemberCopyWithImpl(this._self, this._then);

  final SpaceMember _self;
  final $Res Function(SpaceMember) _then;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? userId = null,Object? role = null,Object? displayName = freezed,Object? joinedAt = null,Object? lastAccessedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastAccessedAt: freezed == lastAccessedAt ? _self.lastAccessedAt : lastAccessedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceMember].
extension SpaceMemberPatterns on SpaceMember {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceMember value)  $default,){
final _that = this;
switch (_that) {
case _SpaceMember():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceMember value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String spaceId, @JsonKey(name: 'user_id')  String userId,  String role, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'joined_at')  DateTime joinedAt, @JsonKey(name: 'last_accessed_at')  DateTime? lastAccessedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that.id,_that.spaceId,_that.userId,_that.role,_that.displayName,_that.joinedAt,_that.lastAccessedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String spaceId, @JsonKey(name: 'user_id')  String userId,  String role, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'joined_at')  DateTime joinedAt, @JsonKey(name: 'last_accessed_at')  DateTime? lastAccessedAt)  $default,) {final _that = this;
switch (_that) {
case _SpaceMember():
return $default(_that.id,_that.spaceId,_that.userId,_that.role,_that.displayName,_that.joinedAt,_that.lastAccessedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'space_id')  String spaceId, @JsonKey(name: 'user_id')  String userId,  String role, @JsonKey(name: 'display_name')  String? displayName, @JsonKey(name: 'joined_at')  DateTime joinedAt, @JsonKey(name: 'last_accessed_at')  DateTime? lastAccessedAt)?  $default,) {final _that = this;
switch (_that) {
case _SpaceMember() when $default != null:
return $default(_that.id,_that.spaceId,_that.userId,_that.role,_that.displayName,_that.joinedAt,_that.lastAccessedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpaceMember implements SpaceMember {
  const _SpaceMember({required this.id, @JsonKey(name: 'space_id') required this.spaceId, @JsonKey(name: 'user_id') required this.userId, this.role = 'member', @JsonKey(name: 'display_name') this.displayName, @JsonKey(name: 'joined_at') required this.joinedAt, @JsonKey(name: 'last_accessed_at') this.lastAccessedAt});
  factory _SpaceMember.fromJson(Map<String, dynamic> json) => _$SpaceMemberFromJson(json);

@override final  String id;
@override@JsonKey(name: 'space_id') final  String spaceId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  String role;
@override@JsonKey(name: 'display_name') final  String? displayName;
@override@JsonKey(name: 'joined_at') final  DateTime joinedAt;
@override@JsonKey(name: 'last_accessed_at') final  DateTime? lastAccessedAt;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceMemberCopyWith<_SpaceMember> get copyWith => __$SpaceMemberCopyWithImpl<_SpaceMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceMember&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.lastAccessedAt, lastAccessedAt) || other.lastAccessedAt == lastAccessedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,userId,role,displayName,joinedAt,lastAccessedAt);

@override
String toString() {
  return 'SpaceMember(id: $id, spaceId: $spaceId, userId: $userId, role: $role, displayName: $displayName, joinedAt: $joinedAt, lastAccessedAt: $lastAccessedAt)';
}


}

/// @nodoc
abstract mixin class _$SpaceMemberCopyWith<$Res> implements $SpaceMemberCopyWith<$Res> {
  factory _$SpaceMemberCopyWith(_SpaceMember value, $Res Function(_SpaceMember) _then) = __$SpaceMemberCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String spaceId,@JsonKey(name: 'user_id') String userId, String role,@JsonKey(name: 'display_name') String? displayName,@JsonKey(name: 'joined_at') DateTime joinedAt,@JsonKey(name: 'last_accessed_at') DateTime? lastAccessedAt
});




}
/// @nodoc
class __$SpaceMemberCopyWithImpl<$Res>
    implements _$SpaceMemberCopyWith<$Res> {
  __$SpaceMemberCopyWithImpl(this._self, this._then);

  final _SpaceMember _self;
  final $Res Function(_SpaceMember) _then;

/// Create a copy of SpaceMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? userId = null,Object? role = null,Object? displayName = freezed,Object? joinedAt = null,Object? lastAccessedAt = freezed,}) {
  return _then(_SpaceMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastAccessedAt: freezed == lastAccessedAt ? _self.lastAccessedAt : lastAccessedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SpaceInvite {

 String get id;@JsonKey(name: 'space_id') String get spaceId; String get code;@JsonKey(name: 'expires_at') DateTime get expiresAt;@JsonKey(name: 'revoked_at') DateTime? get revokedAt;@JsonKey(name: 'max_uses') int? get maxUses;@JsonKey(name: 'use_count') int get useCount;
/// Create a copy of SpaceInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpaceInviteCopyWith<SpaceInvite> get copyWith => _$SpaceInviteCopyWithImpl<SpaceInvite>(this as SpaceInvite, _$identity);

  /// Serializes this SpaceInvite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpaceInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.code, code) || other.code == code)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.revokedAt, revokedAt) || other.revokedAt == revokedAt)&&(identical(other.maxUses, maxUses) || other.maxUses == maxUses)&&(identical(other.useCount, useCount) || other.useCount == useCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,code,expiresAt,revokedAt,maxUses,useCount);

@override
String toString() {
  return 'SpaceInvite(id: $id, spaceId: $spaceId, code: $code, expiresAt: $expiresAt, revokedAt: $revokedAt, maxUses: $maxUses, useCount: $useCount)';
}


}

/// @nodoc
abstract mixin class $SpaceInviteCopyWith<$Res>  {
  factory $SpaceInviteCopyWith(SpaceInvite value, $Res Function(SpaceInvite) _then) = _$SpaceInviteCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String spaceId, String code,@JsonKey(name: 'expires_at') DateTime expiresAt,@JsonKey(name: 'revoked_at') DateTime? revokedAt,@JsonKey(name: 'max_uses') int? maxUses,@JsonKey(name: 'use_count') int useCount
});




}
/// @nodoc
class _$SpaceInviteCopyWithImpl<$Res>
    implements $SpaceInviteCopyWith<$Res> {
  _$SpaceInviteCopyWithImpl(this._self, this._then);

  final SpaceInvite _self;
  final $Res Function(SpaceInvite) _then;

/// Create a copy of SpaceInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? code = null,Object? expiresAt = null,Object? revokedAt = freezed,Object? maxUses = freezed,Object? useCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,revokedAt: freezed == revokedAt ? _self.revokedAt : revokedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,maxUses: freezed == maxUses ? _self.maxUses : maxUses // ignore: cast_nullable_to_non_nullable
as int?,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SpaceInvite].
extension SpaceInvitePatterns on SpaceInvite {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpaceInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpaceInvite() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpaceInvite value)  $default,){
final _that = this;
switch (_that) {
case _SpaceInvite():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpaceInvite value)?  $default,){
final _that = this;
switch (_that) {
case _SpaceInvite() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String spaceId,  String code, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'revoked_at')  DateTime? revokedAt, @JsonKey(name: 'max_uses')  int? maxUses, @JsonKey(name: 'use_count')  int useCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpaceInvite() when $default != null:
return $default(_that.id,_that.spaceId,_that.code,_that.expiresAt,_that.revokedAt,_that.maxUses,_that.useCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String spaceId,  String code, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'revoked_at')  DateTime? revokedAt, @JsonKey(name: 'max_uses')  int? maxUses, @JsonKey(name: 'use_count')  int useCount)  $default,) {final _that = this;
switch (_that) {
case _SpaceInvite():
return $default(_that.id,_that.spaceId,_that.code,_that.expiresAt,_that.revokedAt,_that.maxUses,_that.useCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'space_id')  String spaceId,  String code, @JsonKey(name: 'expires_at')  DateTime expiresAt, @JsonKey(name: 'revoked_at')  DateTime? revokedAt, @JsonKey(name: 'max_uses')  int? maxUses, @JsonKey(name: 'use_count')  int useCount)?  $default,) {final _that = this;
switch (_that) {
case _SpaceInvite() when $default != null:
return $default(_that.id,_that.spaceId,_that.code,_that.expiresAt,_that.revokedAt,_that.maxUses,_that.useCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SpaceInvite implements SpaceInvite {
  const _SpaceInvite({required this.id, @JsonKey(name: 'space_id') required this.spaceId, required this.code, @JsonKey(name: 'expires_at') required this.expiresAt, @JsonKey(name: 'revoked_at') this.revokedAt, @JsonKey(name: 'max_uses') this.maxUses, @JsonKey(name: 'use_count') this.useCount = 0});
  factory _SpaceInvite.fromJson(Map<String, dynamic> json) => _$SpaceInviteFromJson(json);

@override final  String id;
@override@JsonKey(name: 'space_id') final  String spaceId;
@override final  String code;
@override@JsonKey(name: 'expires_at') final  DateTime expiresAt;
@override@JsonKey(name: 'revoked_at') final  DateTime? revokedAt;
@override@JsonKey(name: 'max_uses') final  int? maxUses;
@override@JsonKey(name: 'use_count') final  int useCount;

/// Create a copy of SpaceInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpaceInviteCopyWith<_SpaceInvite> get copyWith => __$SpaceInviteCopyWithImpl<_SpaceInvite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SpaceInviteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpaceInvite&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.code, code) || other.code == code)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.revokedAt, revokedAt) || other.revokedAt == revokedAt)&&(identical(other.maxUses, maxUses) || other.maxUses == maxUses)&&(identical(other.useCount, useCount) || other.useCount == useCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,code,expiresAt,revokedAt,maxUses,useCount);

@override
String toString() {
  return 'SpaceInvite(id: $id, spaceId: $spaceId, code: $code, expiresAt: $expiresAt, revokedAt: $revokedAt, maxUses: $maxUses, useCount: $useCount)';
}


}

/// @nodoc
abstract mixin class _$SpaceInviteCopyWith<$Res> implements $SpaceInviteCopyWith<$Res> {
  factory _$SpaceInviteCopyWith(_SpaceInvite value, $Res Function(_SpaceInvite) _then) = __$SpaceInviteCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String spaceId, String code,@JsonKey(name: 'expires_at') DateTime expiresAt,@JsonKey(name: 'revoked_at') DateTime? revokedAt,@JsonKey(name: 'max_uses') int? maxUses,@JsonKey(name: 'use_count') int useCount
});




}
/// @nodoc
class __$SpaceInviteCopyWithImpl<$Res>
    implements _$SpaceInviteCopyWith<$Res> {
  __$SpaceInviteCopyWithImpl(this._self, this._then);

  final _SpaceInvite _self;
  final $Res Function(_SpaceInvite) _then;

/// Create a copy of SpaceInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? code = null,Object? expiresAt = null,Object? revokedAt = freezed,Object? maxUses = freezed,Object? useCount = null,}) {
  return _then(_SpaceInvite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,revokedAt: freezed == revokedAt ? _self.revokedAt : revokedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,maxUses: freezed == maxUses ? _self.maxUses : maxUses // ignore: cast_nullable_to_non_nullable
as int?,useCount: null == useCount ? _self.useCount : useCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Location {

 String get id;@JsonKey(name: 'space_id') String get spaceId;@JsonKey(name: 'floor_plan_id') String get floorPlanId;@JsonKey(name: 'room_key') String? get roomKey; String get name;@JsonKey(name: 'location_type') String? get locationType;@JsonKey(name: 'icon_key') String get iconKey;@JsonKey(name: 'icon_color') String? get iconColor;@JsonKey(name: 'show_label') bool get showLabel;@JsonKey(name: 'x_ratio') double get xRatio;@JsonKey(name: 'y_ratio') double get yRatio;@JsonKey(name: 'z_index') int get zIndex; int get version;@JsonKey(name: 'created_by') String get createdBy;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt;@JsonKey(name: 'delete_purge_at') DateTime? get deletePurgeAt;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.floorPlanId, floorPlanId) || other.floorPlanId == floorPlanId)&&(identical(other.roomKey, roomKey) || other.roomKey == roomKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.locationType, locationType) || other.locationType == locationType)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.iconColor, iconColor) || other.iconColor == iconColor)&&(identical(other.showLabel, showLabel) || other.showLabel == showLabel)&&(identical(other.xRatio, xRatio) || other.xRatio == xRatio)&&(identical(other.yRatio, yRatio) || other.yRatio == yRatio)&&(identical(other.zIndex, zIndex) || other.zIndex == zIndex)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletePurgeAt, deletePurgeAt) || other.deletePurgeAt == deletePurgeAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,floorPlanId,roomKey,name,locationType,iconKey,iconColor,showLabel,xRatio,yRatio,zIndex,version,createdBy,createdAt,updatedAt,deletedAt,deletePurgeAt);

@override
String toString() {
  return 'Location(id: $id, spaceId: $spaceId, floorPlanId: $floorPlanId, roomKey: $roomKey, name: $name, locationType: $locationType, iconKey: $iconKey, iconColor: $iconColor, showLabel: $showLabel, xRatio: $xRatio, yRatio: $yRatio, zIndex: $zIndex, version: $version, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, deletePurgeAt: $deletePurgeAt)';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String spaceId,@JsonKey(name: 'floor_plan_id') String floorPlanId,@JsonKey(name: 'room_key') String? roomKey, String name,@JsonKey(name: 'location_type') String? locationType,@JsonKey(name: 'icon_key') String iconKey,@JsonKey(name: 'icon_color') String? iconColor,@JsonKey(name: 'show_label') bool showLabel,@JsonKey(name: 'x_ratio') double xRatio,@JsonKey(name: 'y_ratio') double yRatio,@JsonKey(name: 'z_index') int zIndex, int version,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'delete_purge_at') DateTime? deletePurgeAt
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = null,Object? floorPlanId = null,Object? roomKey = freezed,Object? name = null,Object? locationType = freezed,Object? iconKey = null,Object? iconColor = freezed,Object? showLabel = null,Object? xRatio = null,Object? yRatio = null,Object? zIndex = null,Object? version = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? deletePurgeAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,floorPlanId: null == floorPlanId ? _self.floorPlanId : floorPlanId // ignore: cast_nullable_to_non_nullable
as String,roomKey: freezed == roomKey ? _self.roomKey : roomKey // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,locationType: freezed == locationType ? _self.locationType : locationType // ignore: cast_nullable_to_non_nullable
as String?,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,iconColor: freezed == iconColor ? _self.iconColor : iconColor // ignore: cast_nullable_to_non_nullable
as String?,showLabel: null == showLabel ? _self.showLabel : showLabel // ignore: cast_nullable_to_non_nullable
as bool,xRatio: null == xRatio ? _self.xRatio : xRatio // ignore: cast_nullable_to_non_nullable
as double,yRatio: null == yRatio ? _self.yRatio : yRatio // ignore: cast_nullable_to_non_nullable
as double,zIndex: null == zIndex ? _self.zIndex : zIndex // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletePurgeAt: freezed == deletePurgeAt ? _self.deletePurgeAt : deletePurgeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Location value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Location value)  $default,){
final _that = this;
switch (_that) {
case _Location():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Location value)?  $default,){
final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String spaceId, @JsonKey(name: 'floor_plan_id')  String floorPlanId, @JsonKey(name: 'room_key')  String? roomKey,  String name, @JsonKey(name: 'location_type')  String? locationType, @JsonKey(name: 'icon_key')  String iconKey, @JsonKey(name: 'icon_color')  String? iconColor, @JsonKey(name: 'show_label')  bool showLabel, @JsonKey(name: 'x_ratio')  double xRatio, @JsonKey(name: 'y_ratio')  double yRatio, @JsonKey(name: 'z_index')  int zIndex,  int version, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'delete_purge_at')  DateTime? deletePurgeAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.spaceId,_that.floorPlanId,_that.roomKey,_that.name,_that.locationType,_that.iconKey,_that.iconColor,_that.showLabel,_that.xRatio,_that.yRatio,_that.zIndex,_that.version,_that.createdBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.deletePurgeAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String spaceId, @JsonKey(name: 'floor_plan_id')  String floorPlanId, @JsonKey(name: 'room_key')  String? roomKey,  String name, @JsonKey(name: 'location_type')  String? locationType, @JsonKey(name: 'icon_key')  String iconKey, @JsonKey(name: 'icon_color')  String? iconColor, @JsonKey(name: 'show_label')  bool showLabel, @JsonKey(name: 'x_ratio')  double xRatio, @JsonKey(name: 'y_ratio')  double yRatio, @JsonKey(name: 'z_index')  int zIndex,  int version, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'delete_purge_at')  DateTime? deletePurgeAt)  $default,) {final _that = this;
switch (_that) {
case _Location():
return $default(_that.id,_that.spaceId,_that.floorPlanId,_that.roomKey,_that.name,_that.locationType,_that.iconKey,_that.iconColor,_that.showLabel,_that.xRatio,_that.yRatio,_that.zIndex,_that.version,_that.createdBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.deletePurgeAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'space_id')  String spaceId, @JsonKey(name: 'floor_plan_id')  String floorPlanId, @JsonKey(name: 'room_key')  String? roomKey,  String name, @JsonKey(name: 'location_type')  String? locationType, @JsonKey(name: 'icon_key')  String iconKey, @JsonKey(name: 'icon_color')  String? iconColor, @JsonKey(name: 'show_label')  bool showLabel, @JsonKey(name: 'x_ratio')  double xRatio, @JsonKey(name: 'y_ratio')  double yRatio, @JsonKey(name: 'z_index')  int zIndex,  int version, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt, @JsonKey(name: 'delete_purge_at')  DateTime? deletePurgeAt)?  $default,) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.spaceId,_that.floorPlanId,_that.roomKey,_that.name,_that.locationType,_that.iconKey,_that.iconColor,_that.showLabel,_that.xRatio,_that.yRatio,_that.zIndex,_that.version,_that.createdBy,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.deletePurgeAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Location implements Location {
  const _Location({required this.id, @JsonKey(name: 'space_id') required this.spaceId, @JsonKey(name: 'floor_plan_id') required this.floorPlanId, @JsonKey(name: 'room_key') this.roomKey, required this.name, @JsonKey(name: 'location_type') this.locationType, @JsonKey(name: 'icon_key') this.iconKey = 'shelf', @JsonKey(name: 'icon_color') this.iconColor, @JsonKey(name: 'show_label') this.showLabel = true, @JsonKey(name: 'x_ratio') required this.xRatio, @JsonKey(name: 'y_ratio') required this.yRatio, @JsonKey(name: 'z_index') this.zIndex = 0, this.version = 1, @JsonKey(name: 'created_by') required this.createdBy, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt, @JsonKey(name: 'delete_purge_at') this.deletePurgeAt});
  factory _Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

@override final  String id;
@override@JsonKey(name: 'space_id') final  String spaceId;
@override@JsonKey(name: 'floor_plan_id') final  String floorPlanId;
@override@JsonKey(name: 'room_key') final  String? roomKey;
@override final  String name;
@override@JsonKey(name: 'location_type') final  String? locationType;
@override@JsonKey(name: 'icon_key') final  String iconKey;
@override@JsonKey(name: 'icon_color') final  String? iconColor;
@override@JsonKey(name: 'show_label') final  bool showLabel;
@override@JsonKey(name: 'x_ratio') final  double xRatio;
@override@JsonKey(name: 'y_ratio') final  double yRatio;
@override@JsonKey(name: 'z_index') final  int zIndex;
@override@JsonKey() final  int version;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
@override@JsonKey(name: 'delete_purge_at') final  DateTime? deletePurgeAt;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationCopyWith<_Location> get copyWith => __$LocationCopyWithImpl<_Location>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Location&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.floorPlanId, floorPlanId) || other.floorPlanId == floorPlanId)&&(identical(other.roomKey, roomKey) || other.roomKey == roomKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.locationType, locationType) || other.locationType == locationType)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.iconColor, iconColor) || other.iconColor == iconColor)&&(identical(other.showLabel, showLabel) || other.showLabel == showLabel)&&(identical(other.xRatio, xRatio) || other.xRatio == xRatio)&&(identical(other.yRatio, yRatio) || other.yRatio == yRatio)&&(identical(other.zIndex, zIndex) || other.zIndex == zIndex)&&(identical(other.version, version) || other.version == version)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletePurgeAt, deletePurgeAt) || other.deletePurgeAt == deletePurgeAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,floorPlanId,roomKey,name,locationType,iconKey,iconColor,showLabel,xRatio,yRatio,zIndex,version,createdBy,createdAt,updatedAt,deletedAt,deletePurgeAt);

@override
String toString() {
  return 'Location(id: $id, spaceId: $spaceId, floorPlanId: $floorPlanId, roomKey: $roomKey, name: $name, locationType: $locationType, iconKey: $iconKey, iconColor: $iconColor, showLabel: $showLabel, xRatio: $xRatio, yRatio: $yRatio, zIndex: $zIndex, version: $version, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, deletePurgeAt: $deletePurgeAt)';
}


}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) = __$LocationCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String spaceId,@JsonKey(name: 'floor_plan_id') String floorPlanId,@JsonKey(name: 'room_key') String? roomKey, String name,@JsonKey(name: 'location_type') String? locationType,@JsonKey(name: 'icon_key') String iconKey,@JsonKey(name: 'icon_color') String? iconColor,@JsonKey(name: 'show_label') bool showLabel,@JsonKey(name: 'x_ratio') double xRatio,@JsonKey(name: 'y_ratio') double yRatio,@JsonKey(name: 'z_index') int zIndex, int version,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt,@JsonKey(name: 'delete_purge_at') DateTime? deletePurgeAt
});




}
/// @nodoc
class __$LocationCopyWithImpl<$Res>
    implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = null,Object? floorPlanId = null,Object? roomKey = freezed,Object? name = null,Object? locationType = freezed,Object? iconKey = null,Object? iconColor = freezed,Object? showLabel = null,Object? xRatio = null,Object? yRatio = null,Object? zIndex = null,Object? version = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? deletePurgeAt = freezed,}) {
  return _then(_Location(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,floorPlanId: null == floorPlanId ? _self.floorPlanId : floorPlanId // ignore: cast_nullable_to_non_nullable
as String,roomKey: freezed == roomKey ? _self.roomKey : roomKey // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,locationType: freezed == locationType ? _self.locationType : locationType // ignore: cast_nullable_to_non_nullable
as String?,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,iconColor: freezed == iconColor ? _self.iconColor : iconColor // ignore: cast_nullable_to_non_nullable
as String?,showLabel: null == showLabel ? _self.showLabel : showLabel // ignore: cast_nullable_to_non_nullable
as bool,xRatio: null == xRatio ? _self.xRatio : xRatio // ignore: cast_nullable_to_non_nullable
as double,yRatio: null == yRatio ? _self.yRatio : yRatio // ignore: cast_nullable_to_non_nullable
as double,zIndex: null == zIndex ? _self.zIndex : zIndex // ignore: cast_nullable_to_non_nullable
as int,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletePurgeAt: freezed == deletePurgeAt ? _self.deletePurgeAt : deletePurgeAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Category {

 String get id;@JsonKey(name: 'space_id') String? get spaceId; String get name;@JsonKey(name: 'is_system') bool get isSystem;
/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryCopyWith<Category> get copyWith => _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Category&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,name,isSystem);

@override
String toString() {
  return 'Category(id: $id, spaceId: $spaceId, name: $name, isSystem: $isSystem)';
}


}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res>  {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) = _$CategoryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String? spaceId, String name,@JsonKey(name: 'is_system') bool isSystem
});




}
/// @nodoc
class _$CategoryCopyWithImpl<$Res>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = freezed,Object? name = null,Object? isSystem = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Category value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Category value)  $default,){
final _that = this;
switch (_that) {
case _Category():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Category value)?  $default,){
final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String? spaceId,  String name, @JsonKey(name: 'is_system')  bool isSystem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.spaceId,_that.name,_that.isSystem);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String? spaceId,  String name, @JsonKey(name: 'is_system')  bool isSystem)  $default,) {final _that = this;
switch (_that) {
case _Category():
return $default(_that.id,_that.spaceId,_that.name,_that.isSystem);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'space_id')  String? spaceId,  String name, @JsonKey(name: 'is_system')  bool isSystem)?  $default,) {final _that = this;
switch (_that) {
case _Category() when $default != null:
return $default(_that.id,_that.spaceId,_that.name,_that.isSystem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Category implements Category {
  const _Category({required this.id, @JsonKey(name: 'space_id') this.spaceId, required this.name, @JsonKey(name: 'is_system') this.isSystem = false});
  factory _Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'space_id') final  String? spaceId;
@override final  String name;
@override@JsonKey(name: 'is_system') final  bool isSystem;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryCopyWith<_Category> get copyWith => __$CategoryCopyWithImpl<_Category>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Category&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,name,isSystem);

@override
String toString() {
  return 'Category(id: $id, spaceId: $spaceId, name: $name, isSystem: $isSystem)';
}


}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res> implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) = __$CategoryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String? spaceId, String name,@JsonKey(name: 'is_system') bool isSystem
});




}
/// @nodoc
class __$CategoryCopyWithImpl<$Res>
    implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

/// Create a copy of Category
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = freezed,Object? name = null,Object? isSystem = null,}) {
  return _then(_Category(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ItemPhoto {

 String get id;@JsonKey(name: 'item_id') String get itemId;@JsonKey(name: 'storage_path') String get storagePath;@JsonKey(name: 'is_primary') bool get isPrimary;@JsonKey(name: 'sort_order') int get sortOrder;
/// Create a copy of ItemPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemPhotoCopyWith<ItemPhoto> get copyWith => _$ItemPhotoCopyWithImpl<ItemPhoto>(this as ItemPhoto, _$identity);

  /// Serializes this ItemPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,storagePath,isPrimary,sortOrder);

@override
String toString() {
  return 'ItemPhoto(id: $id, itemId: $itemId, storagePath: $storagePath, isPrimary: $isPrimary, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ItemPhotoCopyWith<$Res>  {
  factory $ItemPhotoCopyWith(ItemPhoto value, $Res Function(ItemPhoto) _then) = _$ItemPhotoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'storage_path') String storagePath,@JsonKey(name: 'is_primary') bool isPrimary,@JsonKey(name: 'sort_order') int sortOrder
});




}
/// @nodoc
class _$ItemPhotoCopyWithImpl<$Res>
    implements $ItemPhotoCopyWith<$Res> {
  _$ItemPhotoCopyWithImpl(this._self, this._then);

  final ItemPhoto _self;
  final $Res Function(ItemPhoto) _then;

/// Create a copy of ItemPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? storagePath = null,Object? isPrimary = null,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemPhoto].
extension ItemPhotoPatterns on ItemPhoto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemPhoto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemPhoto value)  $default,){
final _that = this;
switch (_that) {
case _ItemPhoto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _ItemPhoto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'is_primary')  bool isPrimary, @JsonKey(name: 'sort_order')  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemPhoto() when $default != null:
return $default(_that.id,_that.itemId,_that.storagePath,_that.isPrimary,_that.sortOrder);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'is_primary')  bool isPrimary, @JsonKey(name: 'sort_order')  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ItemPhoto():
return $default(_that.id,_that.itemId,_that.storagePath,_that.isPrimary,_that.sortOrder);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'storage_path')  String storagePath, @JsonKey(name: 'is_primary')  bool isPrimary, @JsonKey(name: 'sort_order')  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ItemPhoto() when $default != null:
return $default(_that.id,_that.itemId,_that.storagePath,_that.isPrimary,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemPhoto implements ItemPhoto {
  const _ItemPhoto({required this.id, @JsonKey(name: 'item_id') required this.itemId, @JsonKey(name: 'storage_path') required this.storagePath, @JsonKey(name: 'is_primary') this.isPrimary = false, @JsonKey(name: 'sort_order') this.sortOrder = 0});
  factory _ItemPhoto.fromJson(Map<String, dynamic> json) => _$ItemPhotoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey(name: 'storage_path') final  String storagePath;
@override@JsonKey(name: 'is_primary') final  bool isPrimary;
@override@JsonKey(name: 'sort_order') final  int sortOrder;

/// Create a copy of ItemPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemPhotoCopyWith<_ItemPhoto> get copyWith => __$ItemPhotoCopyWithImpl<_ItemPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,storagePath,isPrimary,sortOrder);

@override
String toString() {
  return 'ItemPhoto(id: $id, itemId: $itemId, storagePath: $storagePath, isPrimary: $isPrimary, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ItemPhotoCopyWith<$Res> implements $ItemPhotoCopyWith<$Res> {
  factory _$ItemPhotoCopyWith(_ItemPhoto value, $Res Function(_ItemPhoto) _then) = __$ItemPhotoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'storage_path') String storagePath,@JsonKey(name: 'is_primary') bool isPrimary,@JsonKey(name: 'sort_order') int sortOrder
});




}
/// @nodoc
class __$ItemPhotoCopyWithImpl<$Res>
    implements _$ItemPhotoCopyWith<$Res> {
  __$ItemPhotoCopyWithImpl(this._self, this._then);

  final _ItemPhoto _self;
  final $Res Function(_ItemPhoto) _then;

/// Create a copy of ItemPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? storagePath = null,Object? isPrimary = null,Object? sortOrder = null,}) {
  return _then(_ItemPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ItemLocationHistory {

 String get id;@JsonKey(name: 'item_id') String get itemId;@JsonKey(name: 'from_space_id') String? get fromSpaceId;@JsonKey(name: 'from_location_id') String? get fromLocationId;@JsonKey(name: 'to_space_id') String? get toSpaceId;@JsonKey(name: 'to_location_id') String? get toLocationId;@JsonKey(name: 'moved_by') String? get movedBy;@JsonKey(name: 'moved_at') DateTime get movedAt; String? get reason;
/// Create a copy of ItemLocationHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemLocationHistoryCopyWith<ItemLocationHistory> get copyWith => _$ItemLocationHistoryCopyWithImpl<ItemLocationHistory>(this as ItemLocationHistory, _$identity);

  /// Serializes this ItemLocationHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemLocationHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.fromSpaceId, fromSpaceId) || other.fromSpaceId == fromSpaceId)&&(identical(other.fromLocationId, fromLocationId) || other.fromLocationId == fromLocationId)&&(identical(other.toSpaceId, toSpaceId) || other.toSpaceId == toSpaceId)&&(identical(other.toLocationId, toLocationId) || other.toLocationId == toLocationId)&&(identical(other.movedBy, movedBy) || other.movedBy == movedBy)&&(identical(other.movedAt, movedAt) || other.movedAt == movedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,fromSpaceId,fromLocationId,toSpaceId,toLocationId,movedBy,movedAt,reason);

@override
String toString() {
  return 'ItemLocationHistory(id: $id, itemId: $itemId, fromSpaceId: $fromSpaceId, fromLocationId: $fromLocationId, toSpaceId: $toSpaceId, toLocationId: $toLocationId, movedBy: $movedBy, movedAt: $movedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ItemLocationHistoryCopyWith<$Res>  {
  factory $ItemLocationHistoryCopyWith(ItemLocationHistory value, $Res Function(ItemLocationHistory) _then) = _$ItemLocationHistoryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'from_space_id') String? fromSpaceId,@JsonKey(name: 'from_location_id') String? fromLocationId,@JsonKey(name: 'to_space_id') String? toSpaceId,@JsonKey(name: 'to_location_id') String? toLocationId,@JsonKey(name: 'moved_by') String? movedBy,@JsonKey(name: 'moved_at') DateTime movedAt, String? reason
});




}
/// @nodoc
class _$ItemLocationHistoryCopyWithImpl<$Res>
    implements $ItemLocationHistoryCopyWith<$Res> {
  _$ItemLocationHistoryCopyWithImpl(this._self, this._then);

  final ItemLocationHistory _self;
  final $Res Function(ItemLocationHistory) _then;

/// Create a copy of ItemLocationHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? fromSpaceId = freezed,Object? fromLocationId = freezed,Object? toSpaceId = freezed,Object? toLocationId = freezed,Object? movedBy = freezed,Object? movedAt = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,fromSpaceId: freezed == fromSpaceId ? _self.fromSpaceId : fromSpaceId // ignore: cast_nullable_to_non_nullable
as String?,fromLocationId: freezed == fromLocationId ? _self.fromLocationId : fromLocationId // ignore: cast_nullable_to_non_nullable
as String?,toSpaceId: freezed == toSpaceId ? _self.toSpaceId : toSpaceId // ignore: cast_nullable_to_non_nullable
as String?,toLocationId: freezed == toLocationId ? _self.toLocationId : toLocationId // ignore: cast_nullable_to_non_nullable
as String?,movedBy: freezed == movedBy ? _self.movedBy : movedBy // ignore: cast_nullable_to_non_nullable
as String?,movedAt: null == movedAt ? _self.movedAt : movedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemLocationHistory].
extension ItemLocationHistoryPatterns on ItemLocationHistory {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemLocationHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemLocationHistory() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemLocationHistory value)  $default,){
final _that = this;
switch (_that) {
case _ItemLocationHistory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemLocationHistory value)?  $default,){
final _that = this;
switch (_that) {
case _ItemLocationHistory() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'from_space_id')  String? fromSpaceId, @JsonKey(name: 'from_location_id')  String? fromLocationId, @JsonKey(name: 'to_space_id')  String? toSpaceId, @JsonKey(name: 'to_location_id')  String? toLocationId, @JsonKey(name: 'moved_by')  String? movedBy, @JsonKey(name: 'moved_at')  DateTime movedAt,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemLocationHistory() when $default != null:
return $default(_that.id,_that.itemId,_that.fromSpaceId,_that.fromLocationId,_that.toSpaceId,_that.toLocationId,_that.movedBy,_that.movedAt,_that.reason);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'from_space_id')  String? fromSpaceId, @JsonKey(name: 'from_location_id')  String? fromLocationId, @JsonKey(name: 'to_space_id')  String? toSpaceId, @JsonKey(name: 'to_location_id')  String? toLocationId, @JsonKey(name: 'moved_by')  String? movedBy, @JsonKey(name: 'moved_at')  DateTime movedAt,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _ItemLocationHistory():
return $default(_that.id,_that.itemId,_that.fromSpaceId,_that.fromLocationId,_that.toSpaceId,_that.toLocationId,_that.movedBy,_that.movedAt,_that.reason);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'item_id')  String itemId, @JsonKey(name: 'from_space_id')  String? fromSpaceId, @JsonKey(name: 'from_location_id')  String? fromLocationId, @JsonKey(name: 'to_space_id')  String? toSpaceId, @JsonKey(name: 'to_location_id')  String? toLocationId, @JsonKey(name: 'moved_by')  String? movedBy, @JsonKey(name: 'moved_at')  DateTime movedAt,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _ItemLocationHistory() when $default != null:
return $default(_that.id,_that.itemId,_that.fromSpaceId,_that.fromLocationId,_that.toSpaceId,_that.toLocationId,_that.movedBy,_that.movedAt,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemLocationHistory implements ItemLocationHistory {
  const _ItemLocationHistory({required this.id, @JsonKey(name: 'item_id') required this.itemId, @JsonKey(name: 'from_space_id') this.fromSpaceId, @JsonKey(name: 'from_location_id') this.fromLocationId, @JsonKey(name: 'to_space_id') this.toSpaceId, @JsonKey(name: 'to_location_id') this.toLocationId, @JsonKey(name: 'moved_by') this.movedBy, @JsonKey(name: 'moved_at') required this.movedAt, this.reason});
  factory _ItemLocationHistory.fromJson(Map<String, dynamic> json) => _$ItemLocationHistoryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'item_id') final  String itemId;
@override@JsonKey(name: 'from_space_id') final  String? fromSpaceId;
@override@JsonKey(name: 'from_location_id') final  String? fromLocationId;
@override@JsonKey(name: 'to_space_id') final  String? toSpaceId;
@override@JsonKey(name: 'to_location_id') final  String? toLocationId;
@override@JsonKey(name: 'moved_by') final  String? movedBy;
@override@JsonKey(name: 'moved_at') final  DateTime movedAt;
@override final  String? reason;

/// Create a copy of ItemLocationHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemLocationHistoryCopyWith<_ItemLocationHistory> get copyWith => __$ItemLocationHistoryCopyWithImpl<_ItemLocationHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemLocationHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemLocationHistory&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.fromSpaceId, fromSpaceId) || other.fromSpaceId == fromSpaceId)&&(identical(other.fromLocationId, fromLocationId) || other.fromLocationId == fromLocationId)&&(identical(other.toSpaceId, toSpaceId) || other.toSpaceId == toSpaceId)&&(identical(other.toLocationId, toLocationId) || other.toLocationId == toLocationId)&&(identical(other.movedBy, movedBy) || other.movedBy == movedBy)&&(identical(other.movedAt, movedAt) || other.movedAt == movedAt)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,itemId,fromSpaceId,fromLocationId,toSpaceId,toLocationId,movedBy,movedAt,reason);

@override
String toString() {
  return 'ItemLocationHistory(id: $id, itemId: $itemId, fromSpaceId: $fromSpaceId, fromLocationId: $fromLocationId, toSpaceId: $toSpaceId, toLocationId: $toLocationId, movedBy: $movedBy, movedAt: $movedAt, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ItemLocationHistoryCopyWith<$Res> implements $ItemLocationHistoryCopyWith<$Res> {
  factory _$ItemLocationHistoryCopyWith(_ItemLocationHistory value, $Res Function(_ItemLocationHistory) _then) = __$ItemLocationHistoryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'item_id') String itemId,@JsonKey(name: 'from_space_id') String? fromSpaceId,@JsonKey(name: 'from_location_id') String? fromLocationId,@JsonKey(name: 'to_space_id') String? toSpaceId,@JsonKey(name: 'to_location_id') String? toLocationId,@JsonKey(name: 'moved_by') String? movedBy,@JsonKey(name: 'moved_at') DateTime movedAt, String? reason
});




}
/// @nodoc
class __$ItemLocationHistoryCopyWithImpl<$Res>
    implements _$ItemLocationHistoryCopyWith<$Res> {
  __$ItemLocationHistoryCopyWithImpl(this._self, this._then);

  final _ItemLocationHistory _self;
  final $Res Function(_ItemLocationHistory) _then;

/// Create a copy of ItemLocationHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? fromSpaceId = freezed,Object? fromLocationId = freezed,Object? toSpaceId = freezed,Object? toLocationId = freezed,Object? movedBy = freezed,Object? movedAt = null,Object? reason = freezed,}) {
  return _then(_ItemLocationHistory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,fromSpaceId: freezed == fromSpaceId ? _self.fromSpaceId : fromSpaceId // ignore: cast_nullable_to_non_nullable
as String?,fromLocationId: freezed == fromLocationId ? _self.fromLocationId : fromLocationId // ignore: cast_nullable_to_non_nullable
as String?,toSpaceId: freezed == toSpaceId ? _self.toSpaceId : toSpaceId // ignore: cast_nullable_to_non_nullable
as String?,toLocationId: freezed == toLocationId ? _self.toLocationId : toLocationId // ignore: cast_nullable_to_non_nullable
as String?,movedBy: freezed == movedBy ? _self.movedBy : movedBy // ignore: cast_nullable_to_non_nullable
as String?,movedAt: null == movedAt ? _self.movedAt : movedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ShoppingItem {

 String get id;@JsonKey(name: 'shopping_list_id') String get shoppingListId;@JsonKey(name: 'space_id') String get spaceId; String get name;@JsonKey(name: 'assignee_user_id') String? get assigneeUserId;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'completed_by') String? get completedBy;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'sort_order') double get sortOrder;@JsonKey(name: 'created_by') String get createdBy;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of ShoppingItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingItemCopyWith<ShoppingItem> get copyWith => _$ShoppingItemCopyWithImpl<ShoppingItem>(this as ShoppingItem, _$identity);

  /// Serializes this ShoppingItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingItem&&(identical(other.id, id) || other.id == id)&&(identical(other.shoppingListId, shoppingListId) || other.shoppingListId == shoppingListId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.assigneeUserId, assigneeUserId) || other.assigneeUserId == assigneeUserId)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedBy, completedBy) || other.completedBy == completedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shoppingListId,spaceId,name,assigneeUserId,isCompleted,completedBy,completedAt,sortOrder,createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'ShoppingItem(id: $id, shoppingListId: $shoppingListId, spaceId: $spaceId, name: $name, assigneeUserId: $assigneeUserId, isCompleted: $isCompleted, completedBy: $completedBy, completedAt: $completedAt, sortOrder: $sortOrder, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ShoppingItemCopyWith<$Res>  {
  factory $ShoppingItemCopyWith(ShoppingItem value, $Res Function(ShoppingItem) _then) = _$ShoppingItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'shopping_list_id') String shoppingListId,@JsonKey(name: 'space_id') String spaceId, String name,@JsonKey(name: 'assignee_user_id') String? assigneeUserId,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'completed_by') String? completedBy,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'sort_order') double sortOrder,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$ShoppingItemCopyWithImpl<$Res>
    implements $ShoppingItemCopyWith<$Res> {
  _$ShoppingItemCopyWithImpl(this._self, this._then);

  final ShoppingItem _self;
  final $Res Function(ShoppingItem) _then;

/// Create a copy of ShoppingItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shoppingListId = null,Object? spaceId = null,Object? name = null,Object? assigneeUserId = freezed,Object? isCompleted = null,Object? completedBy = freezed,Object? completedAt = freezed,Object? sortOrder = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shoppingListId: null == shoppingListId ? _self.shoppingListId : shoppingListId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,assigneeUserId: freezed == assigneeUserId ? _self.assigneeUserId : assigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedBy: freezed == completedBy ? _self.completedBy : completedBy // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as double,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ShoppingItem].
extension ShoppingItemPatterns on ShoppingItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingItem value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingItem value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'shopping_list_id')  String shoppingListId, @JsonKey(name: 'space_id')  String spaceId,  String name, @JsonKey(name: 'assignee_user_id')  String? assigneeUserId, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completed_by')  String? completedBy, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'sort_order')  double sortOrder, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingItem() when $default != null:
return $default(_that.id,_that.shoppingListId,_that.spaceId,_that.name,_that.assigneeUserId,_that.isCompleted,_that.completedBy,_that.completedAt,_that.sortOrder,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'shopping_list_id')  String shoppingListId, @JsonKey(name: 'space_id')  String spaceId,  String name, @JsonKey(name: 'assignee_user_id')  String? assigneeUserId, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completed_by')  String? completedBy, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'sort_order')  double sortOrder, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ShoppingItem():
return $default(_that.id,_that.shoppingListId,_that.spaceId,_that.name,_that.assigneeUserId,_that.isCompleted,_that.completedBy,_that.completedAt,_that.sortOrder,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'shopping_list_id')  String shoppingListId, @JsonKey(name: 'space_id')  String spaceId,  String name, @JsonKey(name: 'assignee_user_id')  String? assigneeUserId, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completed_by')  String? completedBy, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'sort_order')  double sortOrder, @JsonKey(name: 'created_by')  String createdBy, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingItem() when $default != null:
return $default(_that.id,_that.shoppingListId,_that.spaceId,_that.name,_that.assigneeUserId,_that.isCompleted,_that.completedBy,_that.completedAt,_that.sortOrder,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShoppingItem implements ShoppingItem {
  const _ShoppingItem({required this.id, @JsonKey(name: 'shopping_list_id') required this.shoppingListId, @JsonKey(name: 'space_id') required this.spaceId, required this.name, @JsonKey(name: 'assignee_user_id') this.assigneeUserId, @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'completed_by') this.completedBy, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'sort_order') this.sortOrder = 0, @JsonKey(name: 'created_by') required this.createdBy, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _ShoppingItem.fromJson(Map<String, dynamic> json) => _$ShoppingItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'shopping_list_id') final  String shoppingListId;
@override@JsonKey(name: 'space_id') final  String spaceId;
@override final  String name;
@override@JsonKey(name: 'assignee_user_id') final  String? assigneeUserId;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'completed_by') final  String? completedBy;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'sort_order') final  double sortOrder;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of ShoppingItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingItemCopyWith<_ShoppingItem> get copyWith => __$ShoppingItemCopyWithImpl<_ShoppingItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShoppingItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingItem&&(identical(other.id, id) || other.id == id)&&(identical(other.shoppingListId, shoppingListId) || other.shoppingListId == shoppingListId)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.assigneeUserId, assigneeUserId) || other.assigneeUserId == assigneeUserId)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedBy, completedBy) || other.completedBy == completedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,shoppingListId,spaceId,name,assigneeUserId,isCompleted,completedBy,completedAt,sortOrder,createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'ShoppingItem(id: $id, shoppingListId: $shoppingListId, spaceId: $spaceId, name: $name, assigneeUserId: $assigneeUserId, isCompleted: $isCompleted, completedBy: $completedBy, completedAt: $completedAt, sortOrder: $sortOrder, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ShoppingItemCopyWith<$Res> implements $ShoppingItemCopyWith<$Res> {
  factory _$ShoppingItemCopyWith(_ShoppingItem value, $Res Function(_ShoppingItem) _then) = __$ShoppingItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'shopping_list_id') String shoppingListId,@JsonKey(name: 'space_id') String spaceId, String name,@JsonKey(name: 'assignee_user_id') String? assigneeUserId,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'completed_by') String? completedBy,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'sort_order') double sortOrder,@JsonKey(name: 'created_by') String createdBy,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$ShoppingItemCopyWithImpl<$Res>
    implements _$ShoppingItemCopyWith<$Res> {
  __$ShoppingItemCopyWithImpl(this._self, this._then);

  final _ShoppingItem _self;
  final $Res Function(_ShoppingItem) _then;

/// Create a copy of ShoppingItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shoppingListId = null,Object? spaceId = null,Object? name = null,Object? assigneeUserId = freezed,Object? isCompleted = null,Object? completedBy = freezed,Object? completedAt = freezed,Object? sortOrder = null,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ShoppingItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shoppingListId: null == shoppingListId ? _self.shoppingListId : shoppingListId // ignore: cast_nullable_to_non_nullable
as String,spaceId: null == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,assigneeUserId: freezed == assigneeUserId ? _self.assigneeUserId : assigneeUserId // ignore: cast_nullable_to_non_nullable
as String?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedBy: freezed == completedBy ? _self.completedBy : completedBy // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as double,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Checklist {

 String get id;@JsonKey(name: 'space_id') String? get spaceId;@JsonKey(name: 'created_by') String get createdBy; String get name; String get visibility;@JsonKey(name: 'is_completed') bool get isCompleted;@JsonKey(name: 'completed_by') String? get completedBy;@JsonKey(name: 'completed_at') DateTime? get completedAt;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;
/// Create a copy of Checklist
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistCopyWith<Checklist> get copyWith => _$ChecklistCopyWithImpl<Checklist>(this as Checklist, _$identity);

  /// Serializes this Checklist to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Checklist&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.name, name) || other.name == name)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedBy, completedBy) || other.completedBy == completedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,createdBy,name,visibility,isCompleted,completedBy,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Checklist(id: $id, spaceId: $spaceId, createdBy: $createdBy, name: $name, visibility: $visibility, isCompleted: $isCompleted, completedBy: $completedBy, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ChecklistCopyWith<$Res>  {
  factory $ChecklistCopyWith(Checklist value, $Res Function(Checklist) _then) = _$ChecklistCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String? spaceId,@JsonKey(name: 'created_by') String createdBy, String name, String visibility,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'completed_by') String? completedBy,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class _$ChecklistCopyWithImpl<$Res>
    implements $ChecklistCopyWith<$Res> {
  _$ChecklistCopyWithImpl(this._self, this._then);

  final Checklist _self;
  final $Res Function(Checklist) _then;

/// Create a copy of Checklist
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? spaceId = freezed,Object? createdBy = null,Object? name = null,Object? visibility = null,Object? isCompleted = null,Object? completedBy = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedBy: freezed == completedBy ? _self.completedBy : completedBy // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Checklist].
extension ChecklistPatterns on Checklist {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Checklist value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Checklist() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Checklist value)  $default,){
final _that = this;
switch (_that) {
case _Checklist():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Checklist value)?  $default,){
final _that = this;
switch (_that) {
case _Checklist() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String? spaceId, @JsonKey(name: 'created_by')  String createdBy,  String name,  String visibility, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completed_by')  String? completedBy, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Checklist() when $default != null:
return $default(_that.id,_that.spaceId,_that.createdBy,_that.name,_that.visibility,_that.isCompleted,_that.completedBy,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'space_id')  String? spaceId, @JsonKey(name: 'created_by')  String createdBy,  String name,  String visibility, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completed_by')  String? completedBy, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Checklist():
return $default(_that.id,_that.spaceId,_that.createdBy,_that.name,_that.visibility,_that.isCompleted,_that.completedBy,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'space_id')  String? spaceId, @JsonKey(name: 'created_by')  String createdBy,  String name,  String visibility, @JsonKey(name: 'is_completed')  bool isCompleted, @JsonKey(name: 'completed_by')  String? completedBy, @JsonKey(name: 'completed_at')  DateTime? completedAt, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Checklist() when $default != null:
return $default(_that.id,_that.spaceId,_that.createdBy,_that.name,_that.visibility,_that.isCompleted,_that.completedBy,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Checklist implements Checklist {
  const _Checklist({required this.id, @JsonKey(name: 'space_id') this.spaceId, @JsonKey(name: 'created_by') required this.createdBy, required this.name, this.visibility = 'personal', @JsonKey(name: 'is_completed') this.isCompleted = false, @JsonKey(name: 'completed_by') this.completedBy, @JsonKey(name: 'completed_at') this.completedAt, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt});
  factory _Checklist.fromJson(Map<String, dynamic> json) => _$ChecklistFromJson(json);

@override final  String id;
@override@JsonKey(name: 'space_id') final  String? spaceId;
@override@JsonKey(name: 'created_by') final  String createdBy;
@override final  String name;
@override@JsonKey() final  String visibility;
@override@JsonKey(name: 'is_completed') final  bool isCompleted;
@override@JsonKey(name: 'completed_by') final  String? completedBy;
@override@JsonKey(name: 'completed_at') final  DateTime? completedAt;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;

/// Create a copy of Checklist
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistCopyWith<_Checklist> get copyWith => __$ChecklistCopyWithImpl<_Checklist>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChecklistToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Checklist&&(identical(other.id, id) || other.id == id)&&(identical(other.spaceId, spaceId) || other.spaceId == spaceId)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.name, name) || other.name == name)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.completedBy, completedBy) || other.completedBy == completedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,spaceId,createdBy,name,visibility,isCompleted,completedBy,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Checklist(id: $id, spaceId: $spaceId, createdBy: $createdBy, name: $name, visibility: $visibility, isCompleted: $isCompleted, completedBy: $completedBy, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ChecklistCopyWith<$Res> implements $ChecklistCopyWith<$Res> {
  factory _$ChecklistCopyWith(_Checklist value, $Res Function(_Checklist) _then) = __$ChecklistCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'space_id') String? spaceId,@JsonKey(name: 'created_by') String createdBy, String name, String visibility,@JsonKey(name: 'is_completed') bool isCompleted,@JsonKey(name: 'completed_by') String? completedBy,@JsonKey(name: 'completed_at') DateTime? completedAt,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt
});




}
/// @nodoc
class __$ChecklistCopyWithImpl<$Res>
    implements _$ChecklistCopyWith<$Res> {
  __$ChecklistCopyWithImpl(this._self, this._then);

  final _Checklist _self;
  final $Res Function(_Checklist) _then;

/// Create a copy of Checklist
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? spaceId = freezed,Object? createdBy = null,Object? name = null,Object? visibility = null,Object? isCompleted = null,Object? completedBy = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Checklist(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,spaceId: freezed == spaceId ? _self.spaceId : spaceId // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,completedBy: freezed == completedBy ? _self.completedBy : completedBy // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChecklistItem {

 String get id;@JsonKey(name: 'checklist_id') String get checklistId; String get name;@JsonKey(name: 'linked_item_id') String? get linkedItemId;@JsonKey(name: 'is_final_completed') bool get isFinalCompleted;@JsonKey(name: 'final_completed_by') String? get finalCompletedBy;@JsonKey(name: 'final_completed_at') DateTime? get finalCompletedAt;@JsonKey(name: 'sort_order') double get sortOrder;
/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistItemCopyWith<ChecklistItem> get copyWith => _$ChecklistItemCopyWithImpl<ChecklistItem>(this as ChecklistItem, _$identity);

  /// Serializes this ChecklistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.checklistId, checklistId) || other.checklistId == checklistId)&&(identical(other.name, name) || other.name == name)&&(identical(other.linkedItemId, linkedItemId) || other.linkedItemId == linkedItemId)&&(identical(other.isFinalCompleted, isFinalCompleted) || other.isFinalCompleted == isFinalCompleted)&&(identical(other.finalCompletedBy, finalCompletedBy) || other.finalCompletedBy == finalCompletedBy)&&(identical(other.finalCompletedAt, finalCompletedAt) || other.finalCompletedAt == finalCompletedAt)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,checklistId,name,linkedItemId,isFinalCompleted,finalCompletedBy,finalCompletedAt,sortOrder);

@override
String toString() {
  return 'ChecklistItem(id: $id, checklistId: $checklistId, name: $name, linkedItemId: $linkedItemId, isFinalCompleted: $isFinalCompleted, finalCompletedBy: $finalCompletedBy, finalCompletedAt: $finalCompletedAt, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ChecklistItemCopyWith<$Res>  {
  factory $ChecklistItemCopyWith(ChecklistItem value, $Res Function(ChecklistItem) _then) = _$ChecklistItemCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'checklist_id') String checklistId, String name,@JsonKey(name: 'linked_item_id') String? linkedItemId,@JsonKey(name: 'is_final_completed') bool isFinalCompleted,@JsonKey(name: 'final_completed_by') String? finalCompletedBy,@JsonKey(name: 'final_completed_at') DateTime? finalCompletedAt,@JsonKey(name: 'sort_order') double sortOrder
});




}
/// @nodoc
class _$ChecklistItemCopyWithImpl<$Res>
    implements $ChecklistItemCopyWith<$Res> {
  _$ChecklistItemCopyWithImpl(this._self, this._then);

  final ChecklistItem _self;
  final $Res Function(ChecklistItem) _then;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? checklistId = null,Object? name = null,Object? linkedItemId = freezed,Object? isFinalCompleted = null,Object? finalCompletedBy = freezed,Object? finalCompletedAt = freezed,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,checklistId: null == checklistId ? _self.checklistId : checklistId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,linkedItemId: freezed == linkedItemId ? _self.linkedItemId : linkedItemId // ignore: cast_nullable_to_non_nullable
as String?,isFinalCompleted: null == isFinalCompleted ? _self.isFinalCompleted : isFinalCompleted // ignore: cast_nullable_to_non_nullable
as bool,finalCompletedBy: freezed == finalCompletedBy ? _self.finalCompletedBy : finalCompletedBy // ignore: cast_nullable_to_non_nullable
as String?,finalCompletedAt: freezed == finalCompletedAt ? _self.finalCompletedAt : finalCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistItem].
extension ChecklistItemPatterns on ChecklistItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistItem value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistItem value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'checklist_id')  String checklistId,  String name, @JsonKey(name: 'linked_item_id')  String? linkedItemId, @JsonKey(name: 'is_final_completed')  bool isFinalCompleted, @JsonKey(name: 'final_completed_by')  String? finalCompletedBy, @JsonKey(name: 'final_completed_at')  DateTime? finalCompletedAt, @JsonKey(name: 'sort_order')  double sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.id,_that.checklistId,_that.name,_that.linkedItemId,_that.isFinalCompleted,_that.finalCompletedBy,_that.finalCompletedAt,_that.sortOrder);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'checklist_id')  String checklistId,  String name, @JsonKey(name: 'linked_item_id')  String? linkedItemId, @JsonKey(name: 'is_final_completed')  bool isFinalCompleted, @JsonKey(name: 'final_completed_by')  String? finalCompletedBy, @JsonKey(name: 'final_completed_at')  DateTime? finalCompletedAt, @JsonKey(name: 'sort_order')  double sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem():
return $default(_that.id,_that.checklistId,_that.name,_that.linkedItemId,_that.isFinalCompleted,_that.finalCompletedBy,_that.finalCompletedAt,_that.sortOrder);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'checklist_id')  String checklistId,  String name, @JsonKey(name: 'linked_item_id')  String? linkedItemId, @JsonKey(name: 'is_final_completed')  bool isFinalCompleted, @JsonKey(name: 'final_completed_by')  String? finalCompletedBy, @JsonKey(name: 'final_completed_at')  DateTime? finalCompletedAt, @JsonKey(name: 'sort_order')  double sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistItem() when $default != null:
return $default(_that.id,_that.checklistId,_that.name,_that.linkedItemId,_that.isFinalCompleted,_that.finalCompletedBy,_that.finalCompletedAt,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistItem implements ChecklistItem {
  const _ChecklistItem({required this.id, @JsonKey(name: 'checklist_id') required this.checklistId, required this.name, @JsonKey(name: 'linked_item_id') this.linkedItemId, @JsonKey(name: 'is_final_completed') this.isFinalCompleted = false, @JsonKey(name: 'final_completed_by') this.finalCompletedBy, @JsonKey(name: 'final_completed_at') this.finalCompletedAt, @JsonKey(name: 'sort_order') this.sortOrder = 0});
  factory _ChecklistItem.fromJson(Map<String, dynamic> json) => _$ChecklistItemFromJson(json);

@override final  String id;
@override@JsonKey(name: 'checklist_id') final  String checklistId;
@override final  String name;
@override@JsonKey(name: 'linked_item_id') final  String? linkedItemId;
@override@JsonKey(name: 'is_final_completed') final  bool isFinalCompleted;
@override@JsonKey(name: 'final_completed_by') final  String? finalCompletedBy;
@override@JsonKey(name: 'final_completed_at') final  DateTime? finalCompletedAt;
@override@JsonKey(name: 'sort_order') final  double sortOrder;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistItemCopyWith<_ChecklistItem> get copyWith => __$ChecklistItemCopyWithImpl<_ChecklistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChecklistItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistItem&&(identical(other.id, id) || other.id == id)&&(identical(other.checklistId, checklistId) || other.checklistId == checklistId)&&(identical(other.name, name) || other.name == name)&&(identical(other.linkedItemId, linkedItemId) || other.linkedItemId == linkedItemId)&&(identical(other.isFinalCompleted, isFinalCompleted) || other.isFinalCompleted == isFinalCompleted)&&(identical(other.finalCompletedBy, finalCompletedBy) || other.finalCompletedBy == finalCompletedBy)&&(identical(other.finalCompletedAt, finalCompletedAt) || other.finalCompletedAt == finalCompletedAt)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,checklistId,name,linkedItemId,isFinalCompleted,finalCompletedBy,finalCompletedAt,sortOrder);

@override
String toString() {
  return 'ChecklistItem(id: $id, checklistId: $checklistId, name: $name, linkedItemId: $linkedItemId, isFinalCompleted: $isFinalCompleted, finalCompletedBy: $finalCompletedBy, finalCompletedAt: $finalCompletedAt, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ChecklistItemCopyWith<$Res> implements $ChecklistItemCopyWith<$Res> {
  factory _$ChecklistItemCopyWith(_ChecklistItem value, $Res Function(_ChecklistItem) _then) = __$ChecklistItemCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'checklist_id') String checklistId, String name,@JsonKey(name: 'linked_item_id') String? linkedItemId,@JsonKey(name: 'is_final_completed') bool isFinalCompleted,@JsonKey(name: 'final_completed_by') String? finalCompletedBy,@JsonKey(name: 'final_completed_at') DateTime? finalCompletedAt,@JsonKey(name: 'sort_order') double sortOrder
});




}
/// @nodoc
class __$ChecklistItemCopyWithImpl<$Res>
    implements _$ChecklistItemCopyWith<$Res> {
  __$ChecklistItemCopyWithImpl(this._self, this._then);

  final _ChecklistItem _self;
  final $Res Function(_ChecklistItem) _then;

/// Create a copy of ChecklistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? checklistId = null,Object? name = null,Object? linkedItemId = freezed,Object? isFinalCompleted = null,Object? finalCompletedBy = freezed,Object? finalCompletedAt = freezed,Object? sortOrder = null,}) {
  return _then(_ChecklistItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,checklistId: null == checklistId ? _self.checklistId : checklistId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,linkedItemId: freezed == linkedItemId ? _self.linkedItemId : linkedItemId // ignore: cast_nullable_to_non_nullable
as String?,isFinalCompleted: null == isFinalCompleted ? _self.isFinalCompleted : isFinalCompleted // ignore: cast_nullable_to_non_nullable
as bool,finalCompletedBy: freezed == finalCompletedBy ? _self.finalCompletedBy : finalCompletedBy // ignore: cast_nullable_to_non_nullable
as String?,finalCompletedAt: freezed == finalCompletedAt ? _self.finalCompletedAt : finalCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ChecklistMemberCheck {

@JsonKey(name: 'checklist_item_id') String get checklistItemId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'is_checked') bool get isChecked;@JsonKey(name: 'checked_at') DateTime? get checkedAt;
/// Create a copy of ChecklistMemberCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChecklistMemberCheckCopyWith<ChecklistMemberCheck> get copyWith => _$ChecklistMemberCheckCopyWithImpl<ChecklistMemberCheck>(this as ChecklistMemberCheck, _$identity);

  /// Serializes this ChecklistMemberCheck to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChecklistMemberCheck&&(identical(other.checklistItemId, checklistItemId) || other.checklistItemId == checklistItemId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checklistItemId,userId,isChecked,checkedAt);

@override
String toString() {
  return 'ChecklistMemberCheck(checklistItemId: $checklistItemId, userId: $userId, isChecked: $isChecked, checkedAt: $checkedAt)';
}


}

/// @nodoc
abstract mixin class $ChecklistMemberCheckCopyWith<$Res>  {
  factory $ChecklistMemberCheckCopyWith(ChecklistMemberCheck value, $Res Function(ChecklistMemberCheck) _then) = _$ChecklistMemberCheckCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'checklist_item_id') String checklistItemId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'is_checked') bool isChecked,@JsonKey(name: 'checked_at') DateTime? checkedAt
});




}
/// @nodoc
class _$ChecklistMemberCheckCopyWithImpl<$Res>
    implements $ChecklistMemberCheckCopyWith<$Res> {
  _$ChecklistMemberCheckCopyWithImpl(this._self, this._then);

  final ChecklistMemberCheck _self;
  final $Res Function(ChecklistMemberCheck) _then;

/// Create a copy of ChecklistMemberCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checklistItemId = null,Object? userId = null,Object? isChecked = null,Object? checkedAt = freezed,}) {
  return _then(_self.copyWith(
checklistItemId: null == checklistItemId ? _self.checklistItemId : checklistItemId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChecklistMemberCheck].
extension ChecklistMemberCheckPatterns on ChecklistMemberCheck {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChecklistMemberCheck value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChecklistMemberCheck() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChecklistMemberCheck value)  $default,){
final _that = this;
switch (_that) {
case _ChecklistMemberCheck():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChecklistMemberCheck value)?  $default,){
final _that = this;
switch (_that) {
case _ChecklistMemberCheck() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'checklist_item_id')  String checklistItemId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'is_checked')  bool isChecked, @JsonKey(name: 'checked_at')  DateTime? checkedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChecklistMemberCheck() when $default != null:
return $default(_that.checklistItemId,_that.userId,_that.isChecked,_that.checkedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'checklist_item_id')  String checklistItemId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'is_checked')  bool isChecked, @JsonKey(name: 'checked_at')  DateTime? checkedAt)  $default,) {final _that = this;
switch (_that) {
case _ChecklistMemberCheck():
return $default(_that.checklistItemId,_that.userId,_that.isChecked,_that.checkedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'checklist_item_id')  String checklistItemId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'is_checked')  bool isChecked, @JsonKey(name: 'checked_at')  DateTime? checkedAt)?  $default,) {final _that = this;
switch (_that) {
case _ChecklistMemberCheck() when $default != null:
return $default(_that.checklistItemId,_that.userId,_that.isChecked,_that.checkedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChecklistMemberCheck implements ChecklistMemberCheck {
  const _ChecklistMemberCheck({@JsonKey(name: 'checklist_item_id') required this.checklistItemId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'is_checked') this.isChecked = false, @JsonKey(name: 'checked_at') this.checkedAt});
  factory _ChecklistMemberCheck.fromJson(Map<String, dynamic> json) => _$ChecklistMemberCheckFromJson(json);

@override@JsonKey(name: 'checklist_item_id') final  String checklistItemId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'is_checked') final  bool isChecked;
@override@JsonKey(name: 'checked_at') final  DateTime? checkedAt;

/// Create a copy of ChecklistMemberCheck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChecklistMemberCheckCopyWith<_ChecklistMemberCheck> get copyWith => __$ChecklistMemberCheckCopyWithImpl<_ChecklistMemberCheck>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChecklistMemberCheckToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChecklistMemberCheck&&(identical(other.checklistItemId, checklistItemId) || other.checklistItemId == checklistItemId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isChecked, isChecked) || other.isChecked == isChecked)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checklistItemId,userId,isChecked,checkedAt);

@override
String toString() {
  return 'ChecklistMemberCheck(checklistItemId: $checklistItemId, userId: $userId, isChecked: $isChecked, checkedAt: $checkedAt)';
}


}

/// @nodoc
abstract mixin class _$ChecklistMemberCheckCopyWith<$Res> implements $ChecklistMemberCheckCopyWith<$Res> {
  factory _$ChecklistMemberCheckCopyWith(_ChecklistMemberCheck value, $Res Function(_ChecklistMemberCheck) _then) = __$ChecklistMemberCheckCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'checklist_item_id') String checklistItemId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'is_checked') bool isChecked,@JsonKey(name: 'checked_at') DateTime? checkedAt
});




}
/// @nodoc
class __$ChecklistMemberCheckCopyWithImpl<$Res>
    implements _$ChecklistMemberCheckCopyWith<$Res> {
  __$ChecklistMemberCheckCopyWithImpl(this._self, this._then);

  final _ChecklistMemberCheck _self;
  final $Res Function(_ChecklistMemberCheck) _then;

/// Create a copy of ChecklistMemberCheck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checklistItemId = null,Object? userId = null,Object? isChecked = null,Object? checkedAt = freezed,}) {
  return _then(_ChecklistMemberCheck(
checklistItemId: null == checklistItemId ? _self.checklistItemId : checklistItemId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isChecked: null == isChecked ? _self.isChecked : isChecked // ignore: cast_nullable_to_non_nullable
as bool,checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
