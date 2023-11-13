// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_id_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserIdListState {
  List<String> get list => throw _privateConstructorUsedError;

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もuserIdを取得していない（[userIdList]が空）
  QueryDocumentSnapshot<Object?>? get lastReadQueryDocumentSnapshot =>
      throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserIdListStateCopyWith<UserIdListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserIdListStateCopyWith<$Res> {
  factory $UserIdListStateCopyWith(
          UserIdListState value, $Res Function(UserIdListState) then) =
      _$UserIdListStateCopyWithImpl<$Res, UserIdListState>;
  @useResult
  $Res call(
      {List<String> list,
      QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot,
      bool hasMore});
}

/// @nodoc
class _$UserIdListStateCopyWithImpl<$Res, $Val extends UserIdListState>
    implements $UserIdListStateCopyWith<$Res> {
  _$UserIdListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? lastReadQueryDocumentSnapshot = freezed,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      list: null == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastReadQueryDocumentSnapshot: freezed == lastReadQueryDocumentSnapshot
          ? _value.lastReadQueryDocumentSnapshot
          : lastReadQueryDocumentSnapshot // ignore: cast_nullable_to_non_nullable
              as QueryDocumentSnapshot<Object?>?,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserIdListStateCopyWith<$Res>
    implements $UserIdListStateCopyWith<$Res> {
  factory _$$_UserIdListStateCopyWith(
          _$_UserIdListState value, $Res Function(_$_UserIdListState) then) =
      __$$_UserIdListStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> list,
      QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot,
      bool hasMore});
}

/// @nodoc
class __$$_UserIdListStateCopyWithImpl<$Res>
    extends _$UserIdListStateCopyWithImpl<$Res, _$_UserIdListState>
    implements _$$_UserIdListStateCopyWith<$Res> {
  __$$_UserIdListStateCopyWithImpl(
      _$_UserIdListState _value, $Res Function(_$_UserIdListState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? lastReadQueryDocumentSnapshot = freezed,
    Object? hasMore = null,
  }) {
    return _then(_$_UserIdListState(
      list: null == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastReadQueryDocumentSnapshot: freezed == lastReadQueryDocumentSnapshot
          ? _value.lastReadQueryDocumentSnapshot
          : lastReadQueryDocumentSnapshot // ignore: cast_nullable_to_non_nullable
              as QueryDocumentSnapshot<Object?>?,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_UserIdListState implements _UserIdListState {
  const _$_UserIdListState(
      {required final List<String> list,
      required this.lastReadQueryDocumentSnapshot,
      required this.hasMore})
      : _list = list;

  final List<String> _list;
  @override
  List<String> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もuserIdを取得していない（[userIdList]が空）
  @override
  final QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'UserIdListState(list: $list, lastReadQueryDocumentSnapshot: $lastReadQueryDocumentSnapshot, hasMore: $hasMore)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserIdListState &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.lastReadQueryDocumentSnapshot,
                    lastReadQueryDocumentSnapshot) ||
                other.lastReadQueryDocumentSnapshot ==
                    lastReadQueryDocumentSnapshot) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_list),
      lastReadQueryDocumentSnapshot,
      hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserIdListStateCopyWith<_$_UserIdListState> get copyWith =>
      __$$_UserIdListStateCopyWithImpl<_$_UserIdListState>(this, _$identity);
}

abstract class _UserIdListState implements UserIdListState {
  const factory _UserIdListState(
      {required final List<String> list,
      required final QueryDocumentSnapshot<Object?>?
          lastReadQueryDocumentSnapshot,
      required final bool hasMore}) = _$_UserIdListState;

  @override
  List<String> get list;
  @override

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もuserIdを取得していない（[userIdList]が空）
  QueryDocumentSnapshot<Object?>? get lastReadQueryDocumentSnapshot;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$_UserIdListStateCopyWith<_$_UserIdListState> get copyWith =>
      throw _privateConstructorUsedError;
}
