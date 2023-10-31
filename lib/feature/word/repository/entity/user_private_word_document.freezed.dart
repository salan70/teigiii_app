// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_private_word_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserPrivateWordDocument {
  Map<String, Map<String, int>> get privateWordMap =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserPrivateWordDocumentCopyWith<UserPrivateWordDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPrivateWordDocumentCopyWith<$Res> {
  factory $UserPrivateWordDocumentCopyWith(UserPrivateWordDocument value,
          $Res Function(UserPrivateWordDocument) then) =
      _$UserPrivateWordDocumentCopyWithImpl<$Res, UserPrivateWordDocument>;
  @useResult
  $Res call(
      {Map<String, Map<String, int>> privateWordMap,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserPrivateWordDocumentCopyWithImpl<$Res,
        $Val extends UserPrivateWordDocument>
    implements $UserPrivateWordDocumentCopyWith<$Res> {
  _$UserPrivateWordDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privateWordMap = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      privateWordMap: null == privateWordMap
          ? _value.privateWordMap
          : privateWordMap // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, int>>,
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
abstract class _$$_UserPrivateWordDocumentCopyWith<$Res>
    implements $UserPrivateWordDocumentCopyWith<$Res> {
  factory _$$_UserPrivateWordDocumentCopyWith(_$_UserPrivateWordDocument value,
          $Res Function(_$_UserPrivateWordDocument) then) =
      __$$_UserPrivateWordDocumentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, Map<String, int>> privateWordMap,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$_UserPrivateWordDocumentCopyWithImpl<$Res>
    extends _$UserPrivateWordDocumentCopyWithImpl<$Res,
        _$_UserPrivateWordDocument>
    implements _$$_UserPrivateWordDocumentCopyWith<$Res> {
  __$$_UserPrivateWordDocumentCopyWithImpl(_$_UserPrivateWordDocument _value,
      $Res Function(_$_UserPrivateWordDocument) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? privateWordMap = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$_UserPrivateWordDocument(
      privateWordMap: null == privateWordMap
          ? _value._privateWordMap
          : privateWordMap // ignore: cast_nullable_to_non_nullable
              as Map<String, Map<String, int>>,
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

class _$_UserPrivateWordDocument implements _UserPrivateWordDocument {
  const _$_UserPrivateWordDocument(
      {required final Map<String, Map<String, int>> privateWordMap,
      required this.createdAt,
      required this.updatedAt})
      : _privateWordMap = privateWordMap;

  final Map<String, Map<String, int>> _privateWordMap;
  @override
  Map<String, Map<String, int>> get privateWordMap {
    if (_privateWordMap is EqualUnmodifiableMapView) return _privateWordMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_privateWordMap);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserPrivateWordDocument(privateWordMap: $privateWordMap, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserPrivateWordDocument &&
            const DeepCollectionEquality()
                .equals(other._privateWordMap, _privateWordMap) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_privateWordMap),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserPrivateWordDocumentCopyWith<_$_UserPrivateWordDocument>
      get copyWith =>
          __$$_UserPrivateWordDocumentCopyWithImpl<_$_UserPrivateWordDocument>(
              this, _$identity);
}

abstract class _UserPrivateWordDocument implements UserPrivateWordDocument {
  const factory _UserPrivateWordDocument(
      {required final Map<String, Map<String, int>> privateWordMap,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$_UserPrivateWordDocument;

  @override
  Map<String, Map<String, int>> get privateWordMap;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_UserPrivateWordDocumentCopyWith<_$_UserPrivateWordDocument>
      get copyWith => throw _privateConstructorUsedError;
}
