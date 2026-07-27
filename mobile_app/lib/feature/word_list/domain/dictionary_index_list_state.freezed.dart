// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dictionary_index_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DictionaryIndexListState {
  List<DictionaryIndexEntry> get list => throw _privateConstructorUsedError;
  List<Word> get allWords => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DictionaryIndexListStateCopyWith<DictionaryIndexListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DictionaryIndexListStateCopyWith<$Res> {
  factory $DictionaryIndexListStateCopyWith(
    DictionaryIndexListState value,
    $Res Function(DictionaryIndexListState) then,
  ) = _$DictionaryIndexListStateCopyWithImpl<$Res, DictionaryIndexListState>;
  @useResult
  $Res call({
    List<DictionaryIndexEntry> list,
    List<Word> allWords,
    String? nextCursor,
    bool hasMore,
  });
}

/// @nodoc
class _$DictionaryIndexListStateCopyWithImpl<
  $Res,
  $Val extends DictionaryIndexListState
>
    implements $DictionaryIndexListStateCopyWith<$Res> {
  _$DictionaryIndexListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? allWords = null,
    Object? nextCursor = freezed,
    Object? hasMore = null,
  }) {
    return _then(
      _value.copyWith(
            list: null == list
                ? _value.list
                : list // ignore: cast_nullable_to_non_nullable
                      as List<DictionaryIndexEntry>,
            allWords: null == allWords
                ? _value.allWords
                : allWords // ignore: cast_nullable_to_non_nullable
                      as List<Word>,
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
abstract class _$$DictionaryIndexListStateImplCopyWith<$Res>
    implements $DictionaryIndexListStateCopyWith<$Res> {
  factory _$$DictionaryIndexListStateImplCopyWith(
    _$DictionaryIndexListStateImpl value,
    $Res Function(_$DictionaryIndexListStateImpl) then,
  ) = __$$DictionaryIndexListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<DictionaryIndexEntry> list,
    List<Word> allWords,
    String? nextCursor,
    bool hasMore,
  });
}

/// @nodoc
class __$$DictionaryIndexListStateImplCopyWithImpl<$Res>
    extends
        _$DictionaryIndexListStateCopyWithImpl<
          $Res,
          _$DictionaryIndexListStateImpl
        >
    implements _$$DictionaryIndexListStateImplCopyWith<$Res> {
  __$$DictionaryIndexListStateImplCopyWithImpl(
    _$DictionaryIndexListStateImpl _value,
    $Res Function(_$DictionaryIndexListStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? list = null,
    Object? allWords = null,
    Object? nextCursor = freezed,
    Object? hasMore = null,
  }) {
    return _then(
      _$DictionaryIndexListStateImpl(
        list: null == list
            ? _value._list
            : list // ignore: cast_nullable_to_non_nullable
                  as List<DictionaryIndexEntry>,
        allWords: null == allWords
            ? _value._allWords
            : allWords // ignore: cast_nullable_to_non_nullable
                  as List<Word>,
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

class _$DictionaryIndexListStateImpl implements _DictionaryIndexListState {
  const _$DictionaryIndexListStateImpl({
    required final List<DictionaryIndexEntry> list,
    required final List<Word> allWords,
    required this.nextCursor,
    required this.hasMore,
  }) : _list = list,
       _allWords = allWords;

  final List<DictionaryIndexEntry> _list;
  @override
  List<DictionaryIndexEntry> get list {
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_list);
  }

  final List<Word> _allWords;
  @override
  List<Word> get allWords {
    if (_allWords is EqualUnmodifiableListView) return _allWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allWords);
  }

  @override
  final String? nextCursor;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'DictionaryIndexListState(list: $list, allWords: $allWords, nextCursor: $nextCursor, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DictionaryIndexListStateImpl &&
            const DeepCollectionEquality().equals(other._list, _list) &&
            const DeepCollectionEquality().equals(other._allWords, _allWords) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_list),
    const DeepCollectionEquality().hash(_allWords),
    nextCursor,
    hasMore,
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DictionaryIndexListStateImplCopyWith<_$DictionaryIndexListStateImpl>
  get copyWith =>
      __$$DictionaryIndexListStateImplCopyWithImpl<
        _$DictionaryIndexListStateImpl
      >(this, _$identity);
}

abstract class _DictionaryIndexListState implements DictionaryIndexListState {
  const factory _DictionaryIndexListState({
    required final List<DictionaryIndexEntry> list,
    required final List<Word> allWords,
    required final String? nextCursor,
    required final bool hasMore,
  }) = _$DictionaryIndexListStateImpl;

  @override
  List<DictionaryIndexEntry> get list;
  @override
  List<Word> get allWords;
  @override
  String? get nextCursor;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$DictionaryIndexListStateImplCopyWith<_$DictionaryIndexListStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}
