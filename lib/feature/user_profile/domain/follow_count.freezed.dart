// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FollowCount {
  String get userId => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FollowCountCopyWith<FollowCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowCountCopyWith<$Res> {
  factory $FollowCountCopyWith(
          FollowCount value, $Res Function(FollowCount) then) =
      _$FollowCountCopyWithImpl<$Res, FollowCount>;
  @useResult
  $Res call({String userId, int followerCount, int followingCount});
}

/// @nodoc
class _$FollowCountCopyWithImpl<$Res, $Val extends FollowCount>
    implements $FollowCountCopyWith<$Res> {
  _$FollowCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? followerCount = null,
    Object? followingCount = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FollowCountCopyWith<$Res>
    implements $FollowCountCopyWith<$Res> {
  factory _$$_FollowCountCopyWith(
          _$_FollowCount value, $Res Function(_$_FollowCount) then) =
      __$$_FollowCountCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, int followerCount, int followingCount});
}

/// @nodoc
class __$$_FollowCountCopyWithImpl<$Res>
    extends _$FollowCountCopyWithImpl<$Res, _$_FollowCount>
    implements _$$_FollowCountCopyWith<$Res> {
  __$$_FollowCountCopyWithImpl(
      _$_FollowCount _value, $Res Function(_$_FollowCount) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? followerCount = null,
    Object? followingCount = null,
  }) {
    return _then(_$_FollowCount(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      followerCount: null == followerCount
          ? _value.followerCount
          : followerCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_FollowCount implements _FollowCount {
  const _$_FollowCount(
      {required this.userId,
      required this.followerCount,
      required this.followingCount});

  @override
  final String userId;
  @override
  final int followerCount;
  @override
  final int followingCount;

  @override
  String toString() {
    return 'FollowCount(userId: $userId, followerCount: $followerCount, followingCount: $followingCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FollowCount &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, followerCount, followingCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FollowCountCopyWith<_$_FollowCount> get copyWith =>
      __$$_FollowCountCopyWithImpl<_$_FollowCount>(this, _$identity);
}

abstract class _FollowCount implements FollowCount {
  const factory _FollowCount(
      {required final String userId,
      required final int followerCount,
      required final int followingCount}) = _$_FollowCount;

  @override
  String get userId;
  @override
  int get followerCount;
  @override
  int get followingCount;
  @override
  @JsonKey(ignore: true)
  _$$_FollowCountCopyWith<_$_FollowCount> get copyWith =>
      throw _privateConstructorUsedError;
}
