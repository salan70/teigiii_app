// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dictionary_index_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DictionaryIndexEntry {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String label) sectionHeader,
    required TResult Function(Word word) word,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String label)? sectionHeader,
    TResult? Function(Word word)? word,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String label)? sectionHeader,
    TResult Function(Word word)? word,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DictionaryIndexSectionHeader value) sectionHeader,
    required TResult Function(DictionaryIndexWordEntry value) word,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DictionaryIndexSectionHeader value)? sectionHeader,
    TResult? Function(DictionaryIndexWordEntry value)? word,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DictionaryIndexSectionHeader value)? sectionHeader,
    TResult Function(DictionaryIndexWordEntry value)? word,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DictionaryIndexEntryCopyWith<$Res> {
  factory $DictionaryIndexEntryCopyWith(
    DictionaryIndexEntry value,
    $Res Function(DictionaryIndexEntry) then,
  ) = _$DictionaryIndexEntryCopyWithImpl<$Res, DictionaryIndexEntry>;
}

/// @nodoc
class _$DictionaryIndexEntryCopyWithImpl<
  $Res,
  $Val extends DictionaryIndexEntry
>
    implements $DictionaryIndexEntryCopyWith<$Res> {
  _$DictionaryIndexEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DictionaryIndexEntry
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DictionaryIndexSectionHeaderImplCopyWith<$Res> {
  factory _$$DictionaryIndexSectionHeaderImplCopyWith(
    _$DictionaryIndexSectionHeaderImpl value,
    $Res Function(_$DictionaryIndexSectionHeaderImpl) then,
  ) = __$$DictionaryIndexSectionHeaderImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String label});
}

/// @nodoc
class __$$DictionaryIndexSectionHeaderImplCopyWithImpl<$Res>
    extends
        _$DictionaryIndexEntryCopyWithImpl<
          $Res,
          _$DictionaryIndexSectionHeaderImpl
        >
    implements _$$DictionaryIndexSectionHeaderImplCopyWith<$Res> {
  __$$DictionaryIndexSectionHeaderImplCopyWithImpl(
    _$DictionaryIndexSectionHeaderImpl _value,
    $Res Function(_$DictionaryIndexSectionHeaderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DictionaryIndexEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null}) {
    return _then(
      _$DictionaryIndexSectionHeaderImpl(
        null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DictionaryIndexSectionHeaderImpl
    implements DictionaryIndexSectionHeader {
  const _$DictionaryIndexSectionHeaderImpl(this.label);

  @override
  final String label;

  @override
  String toString() {
    return 'DictionaryIndexEntry.sectionHeader(label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DictionaryIndexSectionHeaderImpl &&
            (identical(other.label, label) || other.label == label));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label);

  /// Create a copy of DictionaryIndexEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DictionaryIndexSectionHeaderImplCopyWith<
    _$DictionaryIndexSectionHeaderImpl
  >
  get copyWith =>
      __$$DictionaryIndexSectionHeaderImplCopyWithImpl<
        _$DictionaryIndexSectionHeaderImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String label) sectionHeader,
    required TResult Function(Word word) word,
  }) {
    return sectionHeader(label);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String label)? sectionHeader,
    TResult? Function(Word word)? word,
  }) {
    return sectionHeader?.call(label);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String label)? sectionHeader,
    TResult Function(Word word)? word,
    required TResult orElse(),
  }) {
    if (sectionHeader != null) {
      return sectionHeader(label);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DictionaryIndexSectionHeader value) sectionHeader,
    required TResult Function(DictionaryIndexWordEntry value) word,
  }) {
    return sectionHeader(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DictionaryIndexSectionHeader value)? sectionHeader,
    TResult? Function(DictionaryIndexWordEntry value)? word,
  }) {
    return sectionHeader?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DictionaryIndexSectionHeader value)? sectionHeader,
    TResult Function(DictionaryIndexWordEntry value)? word,
    required TResult orElse(),
  }) {
    if (sectionHeader != null) {
      return sectionHeader(this);
    }
    return orElse();
  }
}

abstract class DictionaryIndexSectionHeader implements DictionaryIndexEntry {
  const factory DictionaryIndexSectionHeader(final String label) =
      _$DictionaryIndexSectionHeaderImpl;

  String get label;

  /// Create a copy of DictionaryIndexEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DictionaryIndexSectionHeaderImplCopyWith<
    _$DictionaryIndexSectionHeaderImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DictionaryIndexWordEntryImplCopyWith<$Res> {
  factory _$$DictionaryIndexWordEntryImplCopyWith(
    _$DictionaryIndexWordEntryImpl value,
    $Res Function(_$DictionaryIndexWordEntryImpl) then,
  ) = __$$DictionaryIndexWordEntryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Word word});

  $WordCopyWith<$Res> get word;
}

/// @nodoc
class __$$DictionaryIndexWordEntryImplCopyWithImpl<$Res>
    extends
        _$DictionaryIndexEntryCopyWithImpl<$Res, _$DictionaryIndexWordEntryImpl>
    implements _$$DictionaryIndexWordEntryImplCopyWith<$Res> {
  __$$DictionaryIndexWordEntryImplCopyWithImpl(
    _$DictionaryIndexWordEntryImpl _value,
    $Res Function(_$DictionaryIndexWordEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DictionaryIndexEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? word = null}) {
    return _then(
      _$DictionaryIndexWordEntryImpl(
        null == word
            ? _value.word
            : word // ignore: cast_nullable_to_non_nullable
                  as Word,
      ),
    );
  }

  /// Create a copy of DictionaryIndexEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WordCopyWith<$Res> get word {
    return $WordCopyWith<$Res>(_value.word, (value) {
      return _then(_value.copyWith(word: value));
    });
  }
}

/// @nodoc

class _$DictionaryIndexWordEntryImpl implements DictionaryIndexWordEntry {
  const _$DictionaryIndexWordEntryImpl(this.word);

  @override
  final Word word;

  @override
  String toString() {
    return 'DictionaryIndexEntry.word(word: $word)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DictionaryIndexWordEntryImpl &&
            (identical(other.word, word) || other.word == word));
  }

  @override
  int get hashCode => Object.hash(runtimeType, word);

  /// Create a copy of DictionaryIndexEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DictionaryIndexWordEntryImplCopyWith<_$DictionaryIndexWordEntryImpl>
  get copyWith =>
      __$$DictionaryIndexWordEntryImplCopyWithImpl<
        _$DictionaryIndexWordEntryImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String label) sectionHeader,
    required TResult Function(Word word) word,
  }) {
    return word(this.word);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String label)? sectionHeader,
    TResult? Function(Word word)? word,
  }) {
    return word?.call(this.word);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String label)? sectionHeader,
    TResult Function(Word word)? word,
    required TResult orElse(),
  }) {
    if (word != null) {
      return word(this.word);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DictionaryIndexSectionHeader value) sectionHeader,
    required TResult Function(DictionaryIndexWordEntry value) word,
  }) {
    return word(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DictionaryIndexSectionHeader value)? sectionHeader,
    TResult? Function(DictionaryIndexWordEntry value)? word,
  }) {
    return word?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DictionaryIndexSectionHeader value)? sectionHeader,
    TResult Function(DictionaryIndexWordEntry value)? word,
    required TResult orElse(),
  }) {
    if (word != null) {
      return word(this);
    }
    return orElse();
  }
}

abstract class DictionaryIndexWordEntry implements DictionaryIndexEntry {
  const factory DictionaryIndexWordEntry(final Word word) =
      _$DictionaryIndexWordEntryImpl;

  Word get word;

  /// Create a copy of DictionaryIndexEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DictionaryIndexWordEntryImplCopyWith<_$DictionaryIndexWordEntryImpl>
  get copyWith => throw _privateConstructorUsedError;
}
