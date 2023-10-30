// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WordListState {
  List<Word> get wordList => throw _privateConstructorUsedError;

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もwordを取得していない（[wordList]が空）
  QueryDocumentSnapshot<Object?>? get lastReadQueryDocumentSnapshot =>
      throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WordListStateCopyWith<WordListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordListStateCopyWith<$Res> {
  factory $WordListStateCopyWith(
          WordListState value, $Res Function(WordListState) then) =
      _$WordListStateCopyWithImpl<$Res, WordListState>;
  @useResult
  $Res call(
      {List<Word> wordList,
      QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot,
      bool hasMore});
}

/// @nodoc
class _$WordListStateCopyWithImpl<$Res, $Val extends WordListState>
    implements $WordListStateCopyWith<$Res> {
  _$WordListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordList = null,
    Object? lastReadQueryDocumentSnapshot = freezed,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      wordList: null == wordList
          ? _value.wordList
          : wordList // ignore: cast_nullable_to_non_nullable
              as List<Word>,
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
abstract class _$$_WordListStateCopyWith<$Res>
    implements $WordListStateCopyWith<$Res> {
  factory _$$_WordListStateCopyWith(
          _$_WordListState value, $Res Function(_$_WordListState) then) =
      __$$_WordListStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Word> wordList,
      QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot,
      bool hasMore});
}

/// @nodoc
class __$$_WordListStateCopyWithImpl<$Res>
    extends _$WordListStateCopyWithImpl<$Res, _$_WordListState>
    implements _$$_WordListStateCopyWith<$Res> {
  __$$_WordListStateCopyWithImpl(
      _$_WordListState _value, $Res Function(_$_WordListState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordList = null,
    Object? lastReadQueryDocumentSnapshot = freezed,
    Object? hasMore = null,
  }) {
    return _then(_$_WordListState(
      wordList: null == wordList
          ? _value._wordList
          : wordList // ignore: cast_nullable_to_non_nullable
              as List<Word>,
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

class _$_WordListState implements _WordListState {
  const _$_WordListState(
      {required final List<Word> wordList,
      required this.lastReadQueryDocumentSnapshot,
      required this.hasMore})
      : _wordList = wordList;

  final List<Word> _wordList;
  @override
  List<Word> get wordList {
    if (_wordList is EqualUnmodifiableListView) return _wordList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wordList);
  }

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もwordを取得していない（[wordList]が空）
  @override
  final QueryDocumentSnapshot<Object?>? lastReadQueryDocumentSnapshot;
  @override
  final bool hasMore;

  @override
  String toString() {
    return 'WordListState(wordList: $wordList, lastReadQueryDocumentSnapshot: $lastReadQueryDocumentSnapshot, hasMore: $hasMore)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_WordListState &&
            const DeepCollectionEquality().equals(other._wordList, _wordList) &&
            (identical(other.lastReadQueryDocumentSnapshot,
                    lastReadQueryDocumentSnapshot) ||
                other.lastReadQueryDocumentSnapshot ==
                    lastReadQueryDocumentSnapshot) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_wordList),
      lastReadQueryDocumentSnapshot,
      hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WordListStateCopyWith<_$_WordListState> get copyWith =>
      __$$_WordListStateCopyWithImpl<_$_WordListState>(this, _$identity);
}

abstract class _WordListState implements WordListState {
  const factory _WordListState(
      {required final List<Word> wordList,
      required final QueryDocumentSnapshot<Object?>?
          lastReadQueryDocumentSnapshot,
      required final bool hasMore}) = _$_WordListState;

  @override
  List<Word> get wordList;
  @override

  /// 最後に読み取られたQueryDocumentSnapshot
  /// これがnullの場合、1件もwordを取得していない（[wordList]が空）
  QueryDocumentSnapshot<Object?>? get lastReadQueryDocumentSnapshot;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$_WordListStateCopyWith<_$_WordListState> get copyWith =>
      throw _privateConstructorUsedError;
}
