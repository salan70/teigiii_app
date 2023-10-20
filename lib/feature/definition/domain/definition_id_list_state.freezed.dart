// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'definition_id_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DefinitionIdListState {
  List<String> get definitionIdList => throw _privateConstructorUsedError;

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もDefinitionIdを取得していない（[definitionIdList]が空）
  QueryDocumentSnapshot<Object?>? get lastReadQueryDocumentSnapshot =>
      throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DefinitionIdListStateCopyWith<DefinitionIdListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefinitionIdListStateCopyWith<$Res> {
  factory $DefinitionIdListStateCopyWith(DefinitionIdListState value,
          $Res Function(DefinitionIdListState) then) =
      _$DefinitionIdListStateCopyWithImpl<$Res, DefinitionIdListState>;
  @useResult
  $Res call(
      {List<String> definitionIdList,
      QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot,
      bool hasMore});
}

/// @nodoc
class _$DefinitionIdListStateCopyWithImpl<$Res,
        $Val extends DefinitionIdListState>
    implements $DefinitionIdListStateCopyWith<$Res> {
  _$DefinitionIdListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? definitionIdList = null,
    Object? lastReadQueryDocumentSnapshot = freezed,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      definitionIdList: null == definitionIdList
          ? _value.definitionIdList
          : definitionIdList // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_DefinitionIdListStateCopyWith<$Res>
    implements $DefinitionIdListStateCopyWith<$Res> {
  factory _$$_DefinitionIdListStateCopyWith(_$_DefinitionIdListState value,
          $Res Function(_$_DefinitionIdListState) then) =
      __$$_DefinitionIdListStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> definitionIdList,
      QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot,
      bool hasMore});
}

/// @nodoc
class __$$_DefinitionIdListStateCopyWithImpl<$Res>
    extends _$DefinitionIdListStateCopyWithImpl<$Res, _$_DefinitionIdListState>
    implements _$$_DefinitionIdListStateCopyWith<$Res> {
  __$$_DefinitionIdListStateCopyWithImpl(_$_DefinitionIdListState _value,
      $Res Function(_$_DefinitionIdListState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? definitionIdList = null,
    Object? lastReadQueryDocumentSnapshot = freezed,
    Object? hasMore = null,
  }) {
    return _then(_$_DefinitionIdListState(
      definitionIdList: null == definitionIdList
          ? _value._definitionIdList
          : definitionIdList // ignore: cast_nullable_to_non_nullable
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

class _$_DefinitionIdListState implements _DefinitionIdListState {
  const _$_DefinitionIdListState(
      {required final List<String> definitionIdList,
      required this.lastReadQueryDocumentSnapshot,
      required this.hasMore})
      : _definitionIdList = definitionIdList;

  final List<String> _definitionIdList;
  @override
  List<String> get definitionIdList {
    if (_definitionIdList is EqualUnmodifiableListView)
      return _definitionIdList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_definitionIdList);
  }

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もDefinitionIdを取得していない（[definitionIdList]が空）
  @override
  final QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'DefinitionIdListState(definitionIdList: $definitionIdList, lastReadQueryDocumentSnapshot: $lastReadQueryDocumentSnapshot, hasMore: $hasMore)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DefinitionIdListState &&
            const DeepCollectionEquality()
                .equals(other._definitionIdList, _definitionIdList) &&
            (identical(other.lastReadQueryDocumentSnapshot,
                    lastReadQueryDocumentSnapshot) ||
                other.lastReadQueryDocumentSnapshot ==
                    lastReadQueryDocumentSnapshot) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_definitionIdList),
      lastReadQueryDocumentSnapshot,
      hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DefinitionIdListStateCopyWith<_$_DefinitionIdListState> get copyWith =>
      __$$_DefinitionIdListStateCopyWithImpl<_$_DefinitionIdListState>(
          this, _$identity);
}

abstract class _DefinitionIdListState implements DefinitionIdListState {
  const factory _DefinitionIdListState(
      {required final List<String> definitionIdList,
      required final QueryDocumentSnapshot<Object?>?
          lastReadQueryDocumentSnapshot,
      required final bool hasMore}) = _$_DefinitionIdListState;

  @override
  List<String> get definitionIdList;
  @override

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もDefinitionIdを取得していない（[definitionIdList]が空）
  QueryDocumentSnapshot<Object?>? get lastReadQueryDocumentSnapshot;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$_DefinitionIdListStateCopyWith<_$_DefinitionIdListState> get copyWith =>
      throw _privateConstructorUsedError;
}
