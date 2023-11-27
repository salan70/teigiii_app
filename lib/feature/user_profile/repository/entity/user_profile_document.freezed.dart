// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserProfileDocument {
  String get id => throw _privateConstructorUsedError;
  String get publicId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserProfileDocumentCopyWith<UserProfileDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileDocumentCopyWith<$Res> {
  factory $UserProfileDocumentCopyWith(
          UserProfileDocument value, $Res Function(UserProfileDocument) then) =
      _$UserProfileDocumentCopyWithImpl<$Res, UserProfileDocument>;
  @useResult
  $Res call(
      {String id,
      String publicId,
      String name,
      String bio,
      String profileImageUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserProfileDocumentCopyWithImpl<$Res, $Val extends UserProfileDocument>
    implements $UserProfileDocumentCopyWith<$Res> {
  _$UserProfileDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicId = null,
    Object? name = null,
    Object? bio = null,
    Object? profileImageUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      publicId: null == publicId
          ? _value.publicId
          : publicId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_UserProfileDocumentCopyWith<$Res>
    implements $UserProfileDocumentCopyWith<$Res> {
  factory _$$_UserProfileDocumentCopyWith(_$_UserProfileDocument value,
          $Res Function(_$_UserProfileDocument) then) =
      __$$_UserProfileDocumentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String publicId,
      String name,
      String bio,
      String profileImageUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$_UserProfileDocumentCopyWithImpl<$Res>
    extends _$UserProfileDocumentCopyWithImpl<$Res, _$_UserProfileDocument>
    implements _$$_UserProfileDocumentCopyWith<$Res> {
  __$$_UserProfileDocumentCopyWithImpl(_$_UserProfileDocument _value,
      $Res Function(_$_UserProfileDocument) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicId = null,
    Object? name = null,
    Object? bio = null,
    Object? profileImageUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$_UserProfileDocument(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      publicId: null == publicId
          ? _value.publicId
          : publicId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
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

class _$_UserProfileDocument extends _UserProfileDocument {
  const _$_UserProfileDocument(
      {required this.id,
      required this.publicId,
      required this.name,
      required this.bio,
      required this.profileImageUrl,
      required this.createdAt,
      required this.updatedAt})
      : super._();

  @override
  final String id;
  @override
  final String publicId;
  @override
  final String name;
  @override
  final String bio;
  @override
  final String profileImageUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserProfileDocument(id: $id, publicId: $publicId, name: $name, bio: $bio, profileImageUrl: $profileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserProfileDocument &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, publicId, name, bio,
      profileImageUrl, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserProfileDocumentCopyWith<_$_UserProfileDocument> get copyWith =>
      __$$_UserProfileDocumentCopyWithImpl<_$_UserProfileDocument>(
          this, _$identity);
}

abstract class _UserProfileDocument extends UserProfileDocument {
  const factory _UserProfileDocument(
      {required final String id,
      required final String publicId,
      required final String name,
      required final String bio,
      required final String profileImageUrl,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$_UserProfileDocument;
  const _UserProfileDocument._() : super._();

  @override
  String get id;
  @override
  String get publicId;
  @override
  String get name;
  @override
  String get bio;
  @override
  String get profileImageUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_UserProfileDocumentCopyWith<_$_UserProfileDocument> get copyWith =>
      throw _privateConstructorUsedError;
}
