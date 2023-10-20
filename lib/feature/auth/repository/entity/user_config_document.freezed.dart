// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_config_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserConfigDocument {
  String get id => throw _privateConstructorUsedError;
  String get appVersion => throw _privateConstructorUsedError;
  String get deviceOs => throw _privateConstructorUsedError;
  List<String> get mutedUserIdList => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserConfigDocumentCopyWith<UserConfigDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserConfigDocumentCopyWith<$Res> {
  factory $UserConfigDocumentCopyWith(
          UserConfigDocument value, $Res Function(UserConfigDocument) then) =
      _$UserConfigDocumentCopyWithImpl<$Res, UserConfigDocument>;
  @useResult
  $Res call(
      {String id,
      String appVersion,
      String deviceOs,
      List<String> mutedUserIdList,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$UserConfigDocumentCopyWithImpl<$Res, $Val extends UserConfigDocument>
    implements $UserConfigDocumentCopyWith<$Res> {
  _$UserConfigDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appVersion = null,
    Object? deviceOs = null,
    Object? mutedUserIdList = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      deviceOs: null == deviceOs
          ? _value.deviceOs
          : deviceOs // ignore: cast_nullable_to_non_nullable
              as String,
      mutedUserIdList: null == mutedUserIdList
          ? _value.mutedUserIdList
          : mutedUserIdList // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
abstract class _$$_UserConfigDocumentCopyWith<$Res>
    implements $UserConfigDocumentCopyWith<$Res> {
  factory _$$_UserConfigDocumentCopyWith(_$_UserConfigDocument value,
          $Res Function(_$_UserConfigDocument) then) =
      __$$_UserConfigDocumentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String appVersion,
      String deviceOs,
      List<String> mutedUserIdList,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$_UserConfigDocumentCopyWithImpl<$Res>
    extends _$UserConfigDocumentCopyWithImpl<$Res, _$_UserConfigDocument>
    implements _$$_UserConfigDocumentCopyWith<$Res> {
  __$$_UserConfigDocumentCopyWithImpl(
      _$_UserConfigDocument _value, $Res Function(_$_UserConfigDocument) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? appVersion = null,
    Object? deviceOs = null,
    Object? mutedUserIdList = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$_UserConfigDocument(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      appVersion: null == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      deviceOs: null == deviceOs
          ? _value.deviceOs
          : deviceOs // ignore: cast_nullable_to_non_nullable
              as String,
      mutedUserIdList: null == mutedUserIdList
          ? _value._mutedUserIdList
          : mutedUserIdList // ignore: cast_nullable_to_non_nullable
              as List<String>,
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

class _$_UserConfigDocument implements _UserConfigDocument {
  const _$_UserConfigDocument(
      {required this.id,
      required this.appVersion,
      required this.deviceOs,
      required final List<String> mutedUserIdList,
      required this.createdAt,
      required this.updatedAt})
      : _mutedUserIdList = mutedUserIdList;

  @override
  final String id;
  @override
  final String appVersion;
  @override
  final String deviceOs;
  final List<String> _mutedUserIdList;
  @override
  List<String> get mutedUserIdList {
    if (_mutedUserIdList is EqualUnmodifiableListView) return _mutedUserIdList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mutedUserIdList);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserConfigDocument(id: $id, appVersion: $appVersion, deviceOs: $deviceOs, mutedUserIdList: $mutedUserIdList, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserConfigDocument &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.deviceOs, deviceOs) ||
                other.deviceOs == deviceOs) &&
            const DeepCollectionEquality()
                .equals(other._mutedUserIdList, _mutedUserIdList) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      appVersion,
      deviceOs,
      const DeepCollectionEquality().hash(_mutedUserIdList),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserConfigDocumentCopyWith<_$_UserConfigDocument> get copyWith =>
      __$$_UserConfigDocumentCopyWithImpl<_$_UserConfigDocument>(
          this, _$identity);
}

abstract class _UserConfigDocument implements UserConfigDocument {
  const factory _UserConfigDocument(
      {required final String id,
      required final String appVersion,
      required final String deviceOs,
      required final List<String> mutedUserIdList,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$_UserConfigDocument;

  @override
  String get id;
  @override
  String get appVersion;
  @override
  String get deviceOs;
  @override
  List<String> get mutedUserIdList;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_UserConfigDocumentCopyWith<_$_UserConfigDocument> get copyWith =>
      throw _privateConstructorUsedError;
}
