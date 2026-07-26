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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UserProfile {
  String get id => throw _privateConstructorUsedError;
  String get publicId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;

  /// アバター画像の URL。未設定の場合は null
  String? get avatarUrl => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  bool get isFollowedByMe => throw _privateConstructorUsedError;

  /// アップロード用にユーザーが指定したファイル（画像）を保持する
  CroppedFile? get croppedFile => throw _privateConstructorUsedError;

  /// [croppedFile] のバイト列。UI 表示用に一度だけ読み込む。
  Uint8List? get croppedImageBytes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
    UserProfile value,
    $Res Function(UserProfile) then,
  ) = _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call({
    String id,
    String publicId,
    String name,
    String bio,
    String? avatarUrl,
    int followingCount,
    int followerCount,
    bool isFollowedByMe,
    CroppedFile? croppedFile,
    Uint8List? croppedImageBytes,
  });
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
    Object? avatarUrl = freezed,
    Object? followingCount = null,
    Object? followerCount = null,
    Object? isFollowedByMe = null,
    Object? croppedFile = freezed,
    Object? croppedImageBytes = freezed,
  }) {
    return _then(
      _value.copyWith(
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
            avatarUrl: freezed == avatarUrl
                ? _value.avatarUrl
                : avatarUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            followingCount: null == followingCount
                ? _value.followingCount
                : followingCount // ignore: cast_nullable_to_non_nullable
                      as int,
            followerCount: null == followerCount
                ? _value.followerCount
                : followerCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isFollowedByMe: null == isFollowedByMe
                ? _value.isFollowedByMe
                : isFollowedByMe // ignore: cast_nullable_to_non_nullable
                      as bool,
            croppedFile: freezed == croppedFile
                ? _value.croppedFile
                : croppedFile // ignore: cast_nullable_to_non_nullable
                      as CroppedFile?,
            croppedImageBytes: freezed == croppedImageBytes
                ? _value.croppedImageBytes
                : croppedImageBytes // ignore: cast_nullable_to_non_nullable
                      as Uint8List?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
    _$UserProfileImpl value,
    $Res Function(_$UserProfileImpl) then,
  ) = __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String publicId,
    String name,
    String bio,
    String? avatarUrl,
    int followingCount,
    int followerCount,
    bool isFollowedByMe,
    CroppedFile? croppedFile,
    Uint8List? croppedImageBytes,
  });
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
    _$UserProfileImpl _value,
    $Res Function(_$UserProfileImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? publicId = null,
    Object? name = null,
    Object? bio = null,
    Object? avatarUrl = freezed,
    Object? followingCount = null,
    Object? followerCount = null,
    Object? isFollowedByMe = null,
    Object? croppedFile = freezed,
    Object? croppedImageBytes = freezed,
  }) {
    return _then(
      _$UserProfileImpl(
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
        avatarUrl: freezed == avatarUrl
            ? _value.avatarUrl
            : avatarUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        followingCount: null == followingCount
            ? _value.followingCount
            : followingCount // ignore: cast_nullable_to_non_nullable
                  as int,
        followerCount: null == followerCount
            ? _value.followerCount
            : followerCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isFollowedByMe: null == isFollowedByMe
            ? _value.isFollowedByMe
            : isFollowedByMe // ignore: cast_nullable_to_non_nullable
                  as bool,
        croppedFile: freezed == croppedFile
            ? _value.croppedFile
            : croppedFile // ignore: cast_nullable_to_non_nullable
                  as CroppedFile?,
        croppedImageBytes: freezed == croppedImageBytes
            ? _value.croppedImageBytes
            : croppedImageBytes // ignore: cast_nullable_to_non_nullable
                  as Uint8List?,
      ),
    );
  }
}

/// @nodoc

class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl({
    required this.id,
    required this.publicId,
    required this.name,
    required this.bio,
    required this.avatarUrl,
    required this.followingCount,
    required this.followerCount,
    required this.isFollowedByMe,
    required this.croppedFile,
    this.croppedImageBytes,
  }) : super._();

  @override
  final String id;
  @override
  final String publicId;
  @override
  final String name;
  @override
  final String bio;

  /// アバター画像の URL。未設定の場合は null
  @override
  final String? avatarUrl;
  @override
  final int followingCount;
  @override
  final int followerCount;
  @override
  final bool isFollowedByMe;

  /// アップロード用にユーザーが指定したファイル（画像）を保持する
  @override
  final CroppedFile? croppedFile;

  /// [croppedFile] のバイト列。UI 表示用に一度だけ読み込む。
  @override
  final Uint8List? croppedImageBytes;

  @override
  String toString() {
    return 'UserProfile(id: $id, publicId: $publicId, name: $name, bio: $bio, avatarUrl: $avatarUrl, followingCount: $followingCount, followerCount: $followerCount, isFollowedByMe: $isFollowedByMe, croppedFile: $croppedFile, croppedImageBytes: $croppedImageBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.publicId, publicId) ||
                other.publicId == publicId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.isFollowedByMe, isFollowedByMe) ||
                other.isFollowedByMe == isFollowedByMe) &&
            (identical(other.croppedFile, croppedFile) ||
                other.croppedFile == croppedFile) &&
            const DeepCollectionEquality().equals(
              other.croppedImageBytes,
              croppedImageBytes,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    publicId,
    name,
    bio,
    avatarUrl,
    followingCount,
    followerCount,
    isFollowedByMe,
    croppedFile,
    const DeepCollectionEquality().hash(croppedImageBytes),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile({
    required final String id,
    required final String publicId,
    required final String name,
    required final String bio,
    required final String? avatarUrl,
    required final int followingCount,
    required final int followerCount,
    required final bool isFollowedByMe,
    required final CroppedFile? croppedFile,
    final Uint8List? croppedImageBytes,
  }) = _$UserProfileImpl;
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
  /// アバター画像の URL。未設定の場合は null
  String? get avatarUrl;
  @override
  int get followingCount;
  @override
  int get followerCount;
  @override
  bool get isFollowedByMe;
  @override
  /// アップロード用にユーザーが指定したファイル（画像）を保持する
  CroppedFile? get croppedFile;
  @override
  /// [croppedFile] のバイト列。UI 表示用に一度だけ読み込む。
  Uint8List? get croppedImageBytes;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
