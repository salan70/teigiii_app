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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Word {
  String get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get reading => throw _privateConstructorUsedError;
  String get initialSubGroupLabel => throw _privateConstructorUsedError;
  int get postedDefinitionCount => throw _privateConstructorUsedError;
  bool get isSavedByMe => throw _privateConstructorUsedError;

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
      String initialSubGroupLabel,
      int postedDefinitionCount,
      bool isSavedByMe});
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
    Object? initialSubGroupLabel = null,
    Object? postedDefinitionCount = null,
    Object? isSavedByMe = null,
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
      initialSubGroupLabel: null == initialSubGroupLabel
          ? _value.initialSubGroupLabel
          : initialSubGroupLabel // ignore: cast_nullable_to_non_nullable
              as String,
      postedDefinitionCount: null == postedDefinitionCount
          ? _value.postedDefinitionCount
          : postedDefinitionCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSavedByMe: null == isSavedByMe
          ? _value.isSavedByMe
          : isSavedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordImplCopyWith<$Res> implements $WordCopyWith<$Res> {
  factory _$$WordImplCopyWith(
          _$WordImpl value, $Res Function(_$WordImpl) then) =
      __$$WordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String word,
      String reading,
      String initialSubGroupLabel,
      int postedDefinitionCount,
      bool isSavedByMe});
}

/// @nodoc
class __$$WordImplCopyWithImpl<$Res>
    extends _$WordCopyWithImpl<$Res, _$WordImpl>
    implements _$$WordImplCopyWith<$Res> {
  __$$WordImplCopyWithImpl(_$WordImpl _value, $Res Function(_$WordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? reading = null,
    Object? initialSubGroupLabel = null,
    Object? postedDefinitionCount = null,
    Object? isSavedByMe = null,
  }) {
    return _then(_$WordImpl(
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
      initialSubGroupLabel: null == initialSubGroupLabel
          ? _value.initialSubGroupLabel
          : initialSubGroupLabel // ignore: cast_nullable_to_non_nullable
              as String,
      postedDefinitionCount: null == postedDefinitionCount
          ? _value.postedDefinitionCount
          : postedDefinitionCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSavedByMe: null == isSavedByMe
          ? _value.isSavedByMe
          : isSavedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$WordImpl implements _Word {
  const _$WordImpl(
      {required this.id,
      required this.word,
      required this.reading,
      required this.initialSubGroupLabel,
      required this.postedDefinitionCount,
      this.isSavedByMe = false});

  @override
  final String id;
  @override
  final String word;
  @override
  final String reading;
  @override
  final String initialSubGroupLabel;
  @override
  final int postedDefinitionCount;
  @override
  @JsonKey()
  final bool isSavedByMe;

  @override
  String toString() {
    return 'Word(id: $id, word: $word, reading: $reading, initialSubGroupLabel: $initialSubGroupLabel, postedDefinitionCount: $postedDefinitionCount, isSavedByMe: $isSavedByMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.reading, reading) || other.reading == reading) &&
            (identical(other.initialSubGroupLabel, initialSubGroupLabel) ||
                other.initialSubGroupLabel == initialSubGroupLabel) &&
            (identical(other.postedDefinitionCount, postedDefinitionCount) ||
                other.postedDefinitionCount == postedDefinitionCount) &&
            (identical(other.isSavedByMe, isSavedByMe) ||
                other.isSavedByMe == isSavedByMe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, word, reading,
      initialSubGroupLabel, postedDefinitionCount, isSavedByMe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WordImplCopyWith<_$WordImpl> get copyWith =>
      __$$WordImplCopyWithImpl<_$WordImpl>(this, _$identity);
}

abstract class _Word implements Word {
  const factory _Word(
      {required final String id,
      required final String word,
      required final String reading,
      required final String initialSubGroupLabel,
      required final int postedDefinitionCount,
      final bool isSavedByMe}) = _$WordImpl;

  @override
  String get id;
  @override
  String get word;
  @override
  String get reading;
  @override
  String get initialSubGroupLabel;
  @override
  int get postedDefinitionCount;
  @override
  bool get isSavedByMe;
  @override
  @JsonKey(ignore: true)
  _$$WordImplCopyWith<_$WordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
