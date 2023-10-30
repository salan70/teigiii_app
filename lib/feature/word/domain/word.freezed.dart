// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Word {
  String get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get reading => throw _privateConstructorUsedError;
  String get initialLetter => throw _privateConstructorUsedError;
  int get postedDefinitionCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WordCopyWith<Word> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordCopyWith<$Res> {
  factory $WordCopyWith(Word value, $Res Function(Word) then) =
      _$WordCopyWithImpl<$Res, Word>;
  @useResult
  $Res call(
      {String id,
      String word,
      String reading,
      String initialLetter,
      int postedDefinitionCount});
}

/// @nodoc
class _$WordCopyWithImpl<$Res, $Val extends Word>
    implements $WordCopyWith<$Res> {
  _$WordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? reading = null,
    Object? initialLetter = null,
    Object? postedDefinitionCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      reading: null == reading
          ? _value.reading
          : reading // ignore: cast_nullable_to_non_nullable
              as String,
      initialLetter: null == initialLetter
          ? _value.initialLetter
          : initialLetter // ignore: cast_nullable_to_non_nullable
              as String,
      postedDefinitionCount: null == postedDefinitionCount
          ? _value.postedDefinitionCount
          : postedDefinitionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_WordCopyWith<$Res> implements $WordCopyWith<$Res> {
  factory _$$_WordCopyWith(_$_Word value, $Res Function(_$_Word) then) =
      __$$_WordCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String word,
      String reading,
      String initialLetter,
      int postedDefinitionCount});
}

/// @nodoc
class __$$_WordCopyWithImpl<$Res> extends _$WordCopyWithImpl<$Res, _$_Word>
    implements _$$_WordCopyWith<$Res> {
  __$$_WordCopyWithImpl(_$_Word _value, $Res Function(_$_Word) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? reading = null,
    Object? initialLetter = null,
    Object? postedDefinitionCount = null,
  }) {
    return _then(_$_Word(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      reading: null == reading
          ? _value.reading
          : reading // ignore: cast_nullable_to_non_nullable
              as String,
      initialLetter: null == initialLetter
          ? _value.initialLetter
          : initialLetter // ignore: cast_nullable_to_non_nullable
              as String,
      postedDefinitionCount: null == postedDefinitionCount
          ? _value.postedDefinitionCount
          : postedDefinitionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_Word implements _Word {
  const _$_Word(
      {required this.id,
      required this.word,
      required this.reading,
      required this.initialLetter,
      required this.postedDefinitionCount});

  @override
  final String id;
  @override
  final String word;
  @override
  final String reading;
  @override
  final String initialLetter;
  @override
  final int postedDefinitionCount;

  @override
  String toString() {
    return 'Word(id: $id, word: $word, reading: $reading, initialLetter: $initialLetter, postedDefinitionCount: $postedDefinitionCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Word &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.reading, reading) || other.reading == reading) &&
            (identical(other.initialLetter, initialLetter) ||
                other.initialLetter == initialLetter) &&
            (identical(other.postedDefinitionCount, postedDefinitionCount) ||
                other.postedDefinitionCount == postedDefinitionCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, word, reading, initialLetter, postedDefinitionCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_WordCopyWith<_$_Word> get copyWith =>
      __$$_WordCopyWithImpl<_$_Word>(this, _$identity);
}

abstract class _Word implements Word {
  const factory _Word(
      {required final String id,
      required final String word,
      required final String reading,
      required final String initialLetter,
      required final int postedDefinitionCount}) = _$_Word;

  @override
  String get id;
  @override
  String get word;
  @override
  String get reading;
  @override
  String get initialLetter;
  @override
  int get postedDefinitionCount;
  @override
  @JsonKey(ignore: true)
  _$$_WordCopyWith<_$_Word> get copyWith => throw _privateConstructorUsedError;
}
