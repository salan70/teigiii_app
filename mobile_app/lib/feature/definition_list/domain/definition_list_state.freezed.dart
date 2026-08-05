// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'definition_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DefinitionListState {
  List<Definition> get list => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Create a copy of DefinitionListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DefinitionListStateCopyWith<DefinitionListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefinitionListStateCopyWith<$Res> {
  factory $DefinitionListStateCopyWith(
    DefinitionListState value,
    $Res Function(DefinitionListState) then,
  ) = _$DefinitionListStateCopyWithImpl<$Res, DefinitionListState>;
  @useResult
  $Res call({List<Definition> list, String? nextCursor, bool hasMore});
}

/// @nodoc
class _$DefinitionListStateCopyWithImpl<$Res, $Val extends DefinitionListState>
    implements $DefinitionListStateCopyWith<$Res> {
  _$DefinitionListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DefinitionListState
  /// with the given fields replaced by the non-null parameter values.
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
                      as List<Definition>,
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
abstract class _$$DefinitionListStateImplCopyWith<$Res>
    implements $DefinitionListStateCopyWith<$Res> {
  factory _$$DefinitionListStateImplCopyWith(
    _$DefinitionListStateImpl value,
    $Res Function(_$DefinitionListStateImpl) then,
  ) = __$$DefinitionListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Definition> list, String? nextCursor, bool hasMore});
}

/// @nodoc
class __$$DefinitionListStateImplCopyWithImpl<$Res>
    extends _$DefinitionListStateCopyWithImpl<$Res, _$DefinitionListStateImpl>
    implements _$$DefinitionListStateImplCopyWith<$Res> {
  __$$DefinitionListStateImplCopyWithImpl(
    _$DefinitionListStateImpl _value,
    $Res Function(_$DefinitionListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DefinitionListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? nextCursor = freezed,
    Object? hasMore = null,
  }) {
    return _then(
      _$DefinitionListStateImpl(
        list: null == list
            ? _value._list
            : list // ignore: cast_nullable_to_non_nullable
                  as List<Definition>,
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

class _$DefinitionListStateImpl implements _DefinitionListState {
  const _$DefinitionListStateImpl({
    required final List<Definition> list,
    required this.nextCursor,
    required this.hasMore,
  }) : _list = list;

  final List<Definition> _list;
  @override
  List<Definition> get list {
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
    return 'DefinitionListState(list: $list, nextCursor: $nextCursor, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefinitionListStateImpl &&
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

  /// Create a copy of DefinitionListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DefinitionListStateImplCopyWith<_$DefinitionListStateImpl> get copyWith =>
      __$$DefinitionListStateImplCopyWithImpl<_$DefinitionListStateImpl>(
        this,
        _$identity,
      );
}

abstract class _DefinitionListState implements DefinitionListState {
  const factory _DefinitionListState({
    required final List<Definition> list,
    required final String? nextCursor,
    required final bool hasMore,
  }) = _$DefinitionListStateImpl;

  @override
  List<Definition> get list;
  @override
  String? get nextCursor;
  @override
  bool get hasMore;

  /// Create a copy of DefinitionListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DefinitionListStateImplCopyWith<_$DefinitionListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
