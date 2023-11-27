// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'like_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LikeDocument {
  String get id => throw _privateConstructorUsedError;
  String get definitionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LikeDocumentCopyWith<LikeDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LikeDocumentCopyWith<$Res> {
  factory $LikeDocumentCopyWith(
          LikeDocument value, $Res Function(LikeDocument) then) =
      _$LikeDocumentCopyWithImpl<$Res, LikeDocument>;
  @useResult
  $Res call(
      {String id,
      String definitionId,
      String userId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$LikeDocumentCopyWithImpl<$Res, $Val extends LikeDocument>
    implements $LikeDocumentCopyWith<$Res> {
  _$LikeDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? definitionId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      definitionId: null == definitionId
          ? _value.definitionId
          : definitionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_LikeDocumentCopyWith<$Res>
    implements $LikeDocumentCopyWith<$Res> {
  factory _$$_LikeDocumentCopyWith(
          _$_LikeDocument value, $Res Function(_$_LikeDocument) then) =
      __$$_LikeDocumentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String definitionId,
      String userId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$_LikeDocumentCopyWithImpl<$Res>
    extends _$LikeDocumentCopyWithImpl<$Res, _$_LikeDocument>
    implements _$$_LikeDocumentCopyWith<$Res> {
  __$$_LikeDocumentCopyWithImpl(
      _$_LikeDocument _value, $Res Function(_$_LikeDocument) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? definitionId = null,
    Object? userId = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$_LikeDocument(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      definitionId: null == definitionId
          ? _value.definitionId
          : definitionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
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

class _$_LikeDocument implements _LikeDocument {
  const _$_LikeDocument(
      {required this.id,
      required this.definitionId,
      required this.userId,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String id;
  @override
  final String definitionId;
  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'LikeDocument(id: $id, definitionId: $definitionId, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LikeDocument &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.definitionId, definitionId) ||
                other.definitionId == definitionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, definitionId, userId, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LikeDocumentCopyWith<_$_LikeDocument> get copyWith =>
      __$$_LikeDocumentCopyWithImpl<_$_LikeDocument>(this, _$identity);
}

abstract class _LikeDocument implements LikeDocument {
  const factory _LikeDocument(
      {required final String id,
      required final String definitionId,
      required final String userId,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$_LikeDocument;

  @override
  String get id;
  @override
  String get definitionId;
  @override
  String get userId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_LikeDocumentCopyWith<_$_LikeDocument> get copyWith =>
      throw _privateConstructorUsedError;
}
