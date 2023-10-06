// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FollowDocument {
  String get id => throw _privateConstructorUsedError;
  String get followerId => throw _privateConstructorUsedError;
  String get followingId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FollowDocumentCopyWith<FollowDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowDocumentCopyWith<$Res> {
  factory $FollowDocumentCopyWith(
          FollowDocument value, $Res Function(FollowDocument) then) =
      _$FollowDocumentCopyWithImpl<$Res, FollowDocument>;
  @useResult
  $Res call(
      {String id, String followerId, String followingId, DateTime createdAt});
}

/// @nodoc
class _$FollowDocumentCopyWithImpl<$Res, $Val extends FollowDocument>
    implements $FollowDocumentCopyWith<$Res> {
  _$FollowDocumentCopyWithImpl(this._value, this._then);

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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowDocumentImplCopyWith<$Res>
    implements $FollowDocumentCopyWith<$Res> {
  factory _$$FollowDocumentImplCopyWith(_$FollowDocumentImpl value,
          $Res Function(_$FollowDocumentImpl) then) =
      __$$FollowDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String followerId, String followingId, DateTime createdAt});
}

/// @nodoc
class __$$FollowDocumentImplCopyWithImpl<$Res>
    extends _$FollowDocumentCopyWithImpl<$Res, _$FollowDocumentImpl>
    implements _$$FollowDocumentImplCopyWith<$Res> {
  __$$FollowDocumentImplCopyWithImpl(
      _$FollowDocumentImpl _value, $Res Function(_$FollowDocumentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? followerId = null,
    Object? followingId = null,
    Object? createdAt = null,
  }) {
    return _then(_$FollowDocumentImpl(
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
    ));
  }
}

/// @nodoc

class _$FollowDocumentImpl implements _FollowDocument {
  const _$FollowDocumentImpl(
      {required this.id,
      required this.followerId,
      required this.followingId,
      required this.createdAt});

  @override
  final String id;
  @override
  final String followerId;
  @override
  final String followingId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'FollowDocument(id: $id, followerId: $followerId, followingId: $followingId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.followerId, followerId) ||
                other.followerId == followerId) &&
            (identical(other.followingId, followingId) ||
                other.followingId == followingId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, followerId, followingId, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowDocumentImplCopyWith<_$FollowDocumentImpl> get copyWith =>
      __$$FollowDocumentImplCopyWithImpl<_$FollowDocumentImpl>(
          this, _$identity);
}

abstract class _FollowDocument implements FollowDocument {
  const factory _FollowDocument(
      {required final String id,
      required final String followerId,
      required final String followingId,
      required final DateTime createdAt}) = _$FollowDocumentImpl;

  @override
  String get id;
  @override
  String get followerId;
  @override
  String get followingId;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$FollowDocumentImplCopyWith<_$FollowDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
