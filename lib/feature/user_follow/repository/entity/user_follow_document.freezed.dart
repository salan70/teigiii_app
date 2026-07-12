// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_follow_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserFollowDocument {
  String get id => throw _privateConstructorUsedError;
  String get followerId => throw _privateConstructorUsedError;
  String get followingId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserFollowDocumentCopyWith<UserFollowDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFollowDocumentCopyWith<$Res> {
  factory $UserFollowDocumentCopyWith(
          UserFollowDocument value, $Res Function(UserFollowDocument) then) =
      _$UserFollowDocumentCopyWithImpl<$Res, UserFollowDocument>;
  @useResult
  $Res call(
      {String id,
      String followerId,
      String followingId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserFollowDocumentCopyWithImpl<$Res, $Val extends UserFollowDocument>
    implements $UserFollowDocumentCopyWith<$Res> {
  _$UserFollowDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? followerId = null,
    Object? followingId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      followerId: null == followerId
          ? _value.followerId
          : followerId // ignore: cast_nullable_to_non_nullable
              as String,
      followingId: null == followingId
          ? _value.followingId
          : followingId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserFollowDocumentImplCopyWith<$Res>
    implements $UserFollowDocumentCopyWith<$Res> {
  factory _$$UserFollowDocumentImplCopyWith(_$UserFollowDocumentImpl value,
          $Res Function(_$UserFollowDocumentImpl) then) =
      __$$UserFollowDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String followerId,
      String followingId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserFollowDocumentImplCopyWithImpl<$Res>
    extends _$UserFollowDocumentCopyWithImpl<$Res, _$UserFollowDocumentImpl>
    implements _$$UserFollowDocumentImplCopyWith<$Res> {
  __$$UserFollowDocumentImplCopyWithImpl(_$UserFollowDocumentImpl _value,
      $Res Function(_$UserFollowDocumentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? followerId = null,
    Object? followingId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserFollowDocumentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      followerId: null == followerId
          ? _value.followerId
          : followerId // ignore: cast_nullable_to_non_nullable
              as String,
      followingId: null == followingId
          ? _value.followingId
          : followingId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$UserFollowDocumentImpl implements _UserFollowDocument {
  const _$UserFollowDocumentImpl(
      {required this.id,
      required this.followerId,
      required this.followingId,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String id;
  @override
  final String followerId;
  @override
  final String followingId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserFollowDocument(id: $id, followerId: $followerId, followingId: $followingId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserFollowDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.followerId, followerId) ||
                other.followerId == followerId) &&
            (identical(other.followingId, followingId) ||
                other.followingId == followingId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, followerId, followingId, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserFollowDocumentImplCopyWith<_$UserFollowDocumentImpl> get copyWith =>
      __$$UserFollowDocumentImplCopyWithImpl<_$UserFollowDocumentImpl>(
          this, _$identity);
}

abstract class _UserFollowDocument implements UserFollowDocument {
  const factory _UserFollowDocument(
      {required final String id,
      required final String followerId,
      required final String followingId,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserFollowDocumentImpl;

  @override
  String get id;
  @override
  String get followerId;
  @override
  String get followingId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserFollowDocumentImplCopyWith<_$UserFollowDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
