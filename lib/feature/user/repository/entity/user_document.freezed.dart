// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserDocument {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserDocumentCopyWith<UserDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDocumentCopyWith<$Res> {
  factory $UserDocumentCopyWith(
          UserDocument value, $Res Function(UserDocument) then) =
      _$UserDocumentCopyWithImpl<$Res, UserDocument>;
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String profileImageUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserDocumentCopyWithImpl<$Res, $Val extends UserDocument>
    implements $UserDocumentCopyWith<$Res> {
  _$UserDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? profileImageUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
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
abstract class _$$UserDocumentImplCopyWith<$Res>
    implements $UserDocumentCopyWith<$Res> {
  factory _$$UserDocumentImplCopyWith(
          _$UserDocumentImpl value, $Res Function(_$UserDocumentImpl) then) =
      __$$UserDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String profileImageUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$UserDocumentImplCopyWithImpl<$Res>
    extends _$UserDocumentCopyWithImpl<$Res, _$UserDocumentImpl>
    implements _$$UserDocumentImplCopyWith<$Res> {
  __$$UserDocumentImplCopyWithImpl(
      _$UserDocumentImpl _value, $Res Function(_$UserDocumentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? profileImageUrl = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserDocumentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
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

class _$UserDocumentImpl implements _UserDocument {
  const _$UserDocumentImpl(
      {required this.id,
      required this.name,
      required this.email,
      required this.profileImageUrl,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String profileImageUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserDocument(id: $id, name: $name, email: $email, profileImageUrl: $profileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, email, profileImageUrl, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDocumentImplCopyWith<_$UserDocumentImpl> get copyWith =>
      __$$UserDocumentImplCopyWithImpl<_$UserDocumentImpl>(this, _$identity);
}

abstract class _UserDocument implements UserDocument {
  const factory _UserDocument(
      {required final String id,
      required final String name,
      required final String email,
      required final String profileImageUrl,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserDocumentImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get profileImageUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserDocumentImplCopyWith<_$UserDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
