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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FollowCount {
  String get userId => throw _privateConstructorUsedError;
  int get followerCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;

  /// Create a copy of FollowCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowCountCopyWith<FollowCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowCountCopyWith<$Res> {
  factory $FollowCountCopyWith(
    FollowCount value,
    $Res Function(FollowCount) then,
  ) = _$FollowCountCopyWithImpl<$Res, FollowCount>;
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

  /// Create a copy of FollowCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? followerCount = null,
    Object? followingCount = null,
  }) {
    return _then(
      _value.copyWith(
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FollowCountImplCopyWith<$Res>
    implements $FollowCountCopyWith<$Res> {
  factory _$$FollowCountImplCopyWith(
    _$FollowCountImpl value,
    $Res Function(_$FollowCountImpl) then,
  ) = __$$FollowCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, int followerCount, int followingCount});
}

/// @nodoc
class __$$FollowCountImplCopyWithImpl<$Res>
    extends _$FollowCountCopyWithImpl<$Res, _$FollowCountImpl>
    implements _$$FollowCountImplCopyWith<$Res> {
  __$$FollowCountImplCopyWithImpl(
    _$FollowCountImpl _value,
    $Res Function(_$FollowCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FollowCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? followerCount = null,
    Object? followingCount = null,
  }) {
    return _then(
      _$FollowCountImpl(
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
      ),
    );
  }
}

/// @nodoc

class _$FollowCountImpl implements _FollowCount {
  const _$FollowCountImpl({
    required this.userId,
    required this.followerCount,
    required this.followingCount,
  });

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowCountImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.followerCount, followerCount) ||
                other.followerCount == followerCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, followerCount, followingCount);

  /// Create a copy of FollowCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowCountImplCopyWith<_$FollowCountImpl> get copyWith =>
      __$$FollowCountImplCopyWithImpl<_$FollowCountImpl>(this, _$identity);
}

abstract class _FollowCount implements FollowCount {
  const factory _FollowCount({
    required final String userId,
    required final int followerCount,
    required final int followingCount,
  }) = _$FollowCountImpl;

  @override
  String get userId;
  @override
  int get followerCount;
  @override
  int get followingCount;

  /// Create a copy of FollowCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowCountImplCopyWith<_$FollowCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
