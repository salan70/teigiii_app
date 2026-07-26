// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_feed_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DiscoverFeedListState {
  List<dynamic> get list => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiscoverFeedListStateCopyWith<DiscoverFeedListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscoverFeedListStateCopyWith<$Res> {
  factory $DiscoverFeedListStateCopyWith(
    DiscoverFeedListState value,
    $Res Function(DiscoverFeedListState) then,
  ) = _$DiscoverFeedListStateCopyWithImpl<$Res, DiscoverFeedListState>;
  @useResult
  $Res call({List<dynamic> list, String? nextCursor, bool hasMore});
}

/// @nodoc
class _$DiscoverFeedListStateCopyWithImpl<
  $Res,
  $Val extends DiscoverFeedListState
>
    implements $DiscoverFeedListStateCopyWith<$Res> {
  _$DiscoverFeedListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? nextCursor = freezed,
    Object? hasMore = null,
  }) {
    return _then(
      _value.copyWith(
            list: null == list
                ? _value.list
                : list // ignore: cast_nullable_to_non_nullable
                      as List<dynamic>,
            nextCursor: freezed == nextCursor
                ? _value.nextCursor
                : nextCursor // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiscoverFeedListStateImplCopyWith<$Res>
    implements $DiscoverFeedListStateCopyWith<$Res> {
  factory _$$DiscoverFeedListStateImplCopyWith(
    _$DiscoverFeedListStateImpl value,
    $Res Function(_$DiscoverFeedListStateImpl) then,
  ) = __$$DiscoverFeedListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<dynamic> list, String? nextCursor, bool hasMore});
}

/// @nodoc
class __$$DiscoverFeedListStateImplCopyWithImpl<$Res>
    extends
        _$DiscoverFeedListStateCopyWithImpl<$Res, _$DiscoverFeedListStateImpl>
    implements _$$DiscoverFeedListStateImplCopyWith<$Res> {
  __$$DiscoverFeedListStateImplCopyWithImpl(
    _$DiscoverFeedListStateImpl _value,
    $Res Function(_$DiscoverFeedListStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? nextCursor = freezed,
    Object? hasMore = null,
  }) {
    return _then(
      _$DiscoverFeedListStateImpl(
        list: null == list
            ? _value._list
            : list // ignore: cast_nullable_to_non_nullable
                  as List<dynamic>,
        nextCursor: freezed == nextCursor
            ? _value.nextCursor
            : nextCursor // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$DiscoverFeedListStateImpl implements _DiscoverFeedListState {
  const _$DiscoverFeedListStateImpl({
    required final List<dynamic> list,
    required this.nextCursor,
    required this.hasMore,
  }) : _list = list;

  final List<dynamic> _list;
  @override
  List<dynamic> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  @override
  final String? nextCursor;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'DiscoverFeedListState(list: $list, nextCursor: $nextCursor, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscoverFeedListStateImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_list),
    nextCursor,
    hasMore,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscoverFeedListStateImplCopyWith<_$DiscoverFeedListStateImpl>
  get copyWith =>
      __$$DiscoverFeedListStateImplCopyWithImpl<_$DiscoverFeedListStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DiscoverFeedListState implements DiscoverFeedListState {
  const factory _DiscoverFeedListState({
    required final List<dynamic> list,
    required final String? nextCursor,
    required final bool hasMore,
  }) = _$DiscoverFeedListStateImpl;

  @override
  List<dynamic> get list;
  @override
  String? get nextCursor;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$DiscoverFeedListStateImplCopyWith<_$DiscoverFeedListStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
