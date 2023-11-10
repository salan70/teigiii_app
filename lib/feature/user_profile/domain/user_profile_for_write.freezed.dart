// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_for_write.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserProfileForWrite {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserProfileForWriteCopyWith<UserProfileForWrite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileForWriteCopyWith<$Res> {
  factory $UserProfileForWriteCopyWith(
          UserProfileForWrite value, $Res Function(UserProfileForWrite) then) =
      _$UserProfileForWriteCopyWithImpl<$Res, UserProfileForWrite>;
  @useResult
  $Res call({String id, String name, String bio, String profileImageUrl});
}

/// @nodoc
class _$UserProfileForWriteCopyWithImpl<$Res, $Val extends UserProfileForWrite>
    implements $UserProfileForWriteCopyWith<$Res> {
  _$UserProfileForWriteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? bio = null,
    Object? profileImageUrl = null,
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
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: null == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserProfileForWriteCopyWith<$Res>
    implements $UserProfileForWriteCopyWith<$Res> {
  factory _$$_UserProfileForWriteCopyWith(_$_UserProfileForWrite value,
          $Res Function(_$_UserProfileForWrite) then) =
      __$$_UserProfileForWriteCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String bio, String profileImageUrl});
}

/// @nodoc
class __$$_UserProfileForWriteCopyWithImpl<$Res>
    extends _$UserProfileForWriteCopyWithImpl<$Res, _$_UserProfileForWrite>
    implements _$$_UserProfileForWriteCopyWith<$Res> {
  __$$_UserProfileForWriteCopyWithImpl(_$_UserProfileForWrite _value,
      $Res Function(_$_UserProfileForWrite) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? bio = null,
    Object? profileImageUrl = null,
  }) {
    return _then(_$_UserProfileForWrite(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc

class _$_UserProfileForWrite extends _UserProfileForWrite {
  const _$_UserProfileForWrite(
      {required this.id,
      required this.name,
      required this.bio,
      required this.profileImageUrl})
      : super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String bio;
  @override
  final String profileImageUrl;

  @override
  String toString() {
    return 'UserProfileForWrite(id: $id, name: $name, bio: $bio, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserProfileForWrite &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, bio, profileImageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserProfileForWriteCopyWith<_$_UserProfileForWrite> get copyWith =>
      __$$_UserProfileForWriteCopyWithImpl<_$_UserProfileForWrite>(
          this, _$identity);
}

abstract class _UserProfileForWrite extends UserProfileForWrite {
  const factory _UserProfileForWrite(
      {required final String id,
      required final String name,
      required final String bio,
      required final String profileImageUrl}) = _$_UserProfileForWrite;
  const _UserProfileForWrite._() : super._();

  @override
  String get id;
  @override
  String get name;
  @override
  String get bio;
  @override
  String get profileImageUrl;
  @override
  @JsonKey(ignore: true)
  _$$_UserProfileForWriteCopyWith<_$_UserProfileForWrite> get copyWith =>
      throw _privateConstructorUsedError;
}
