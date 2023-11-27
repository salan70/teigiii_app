// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get publicId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String get profileImageUrl => throw _privateConstructorUsedError;

  /// アップロード用にユーザーが指定したファイル（画像）を保持する
  CroppedFile? get croppedFile => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String id,
      String publicId,
      String name,
      String bio,
      String profileImageUrl,
      CroppedFile? croppedFile});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

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
    Object? croppedFile = freezed,
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
      croppedFile: freezed == croppedFile
          ? _value.croppedFile
          : croppedFile // ignore: cast_nullable_to_non_nullable
              as CroppedFile?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserProfileCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$_UserProfileCopyWith(
          _$_UserProfile value, $Res Function(_$_UserProfile) then) =
      __$$_UserProfileCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String publicId,
      String name,
      String bio,
      String profileImageUrl,
      CroppedFile? croppedFile});
}

/// @nodoc
class __$$_UserProfileCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$_UserProfile>
    implements _$$_UserProfileCopyWith<$Res> {
  __$$_UserProfileCopyWithImpl(
      _$_UserProfile _value, $Res Function(_$_UserProfile) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicId = null,
    Object? name = null,
    Object? bio = null,
    Object? profileImageUrl = null,
    Object? croppedFile = freezed,
  }) {
    return _then(_$_UserProfile(
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
      croppedFile: freezed == croppedFile
          ? _value.croppedFile
          : croppedFile // ignore: cast_nullable_to_non_nullable
              as CroppedFile?,
    ));
  }
}

/// @nodoc

class _$_UserProfile extends _UserProfile {
  const _$_UserProfile(
      {required this.id,
      required this.publicId,
      required this.name,
      required this.bio,
      required this.profileImageUrl,
      required this.croppedFile})
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

  /// アップロード用にユーザーが指定したファイル（画像）を保持する
  @override
  final CroppedFile? croppedFile;

  @override
  String toString() {
    return 'UserProfile(id: $id, publicId: $publicId, name: $name, bio: $bio, profileImageUrl: $profileImageUrl, croppedFile: $croppedFile)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.croppedFile, croppedFile) ||
                other.croppedFile == croppedFile));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, publicId, name, bio, profileImageUrl, croppedFile);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserProfileCopyWith<_$_UserProfile> get copyWith =>
      __$$_UserProfileCopyWithImpl<_$_UserProfile>(this, _$identity);
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {required final String id,
      required final String publicId,
      required final String name,
      required final String bio,
      required final String profileImageUrl,
      required final CroppedFile? croppedFile}) = _$_UserProfile;
  const _UserProfile._() : super._();

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

  /// アップロード用にユーザーが指定したファイル（画像）を保持する
  CroppedFile? get croppedFile;
  @override
  @JsonKey(ignore: true)
  _$$_UserProfileCopyWith<_$_UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}
