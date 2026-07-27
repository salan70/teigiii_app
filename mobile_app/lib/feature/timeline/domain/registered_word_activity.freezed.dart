// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'registered_word_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RegisteredWordActivity {
  String get wordId => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get reading => throw _privateConstructorUsedError;
  DateTime get occurredAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisteredWordActivityCopyWith<RegisteredWordActivity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisteredWordActivityCopyWith<$Res> {
  factory $RegisteredWordActivityCopyWith(
    RegisteredWordActivity value,
    $Res Function(RegisteredWordActivity) then,
  ) = _$RegisteredWordActivityCopyWithImpl<$Res, RegisteredWordActivity>;
  @useResult
  $Res call({String wordId, String word, String reading, DateTime occurredAt});
}

/// @nodoc
class _$RegisteredWordActivityCopyWithImpl<
  $Res,
  $Val extends RegisteredWordActivity
>
    implements $RegisteredWordActivityCopyWith<$Res> {
  _$RegisteredWordActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordId = null,
    Object? word = null,
    Object? reading = null,
    Object? occurredAt = null,
  }) {
    return _then(
      _value.copyWith(
            wordId: null == wordId
                ? _value.wordId
                : wordId // ignore: cast_nullable_to_non_nullable
                      as String,
            word: null == word
                ? _value.word
                : word // ignore: cast_nullable_to_non_nullable
                      as String,
            reading: null == reading
                ? _value.reading
                : reading // ignore: cast_nullable_to_non_nullable
                      as String,
            occurredAt: null == occurredAt
                ? _value.occurredAt
                : occurredAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisteredWordActivityImplCopyWith<$Res>
    implements $RegisteredWordActivityCopyWith<$Res> {
  factory _$$RegisteredWordActivityImplCopyWith(
    _$RegisteredWordActivityImpl value,
    $Res Function(_$RegisteredWordActivityImpl) then,
  ) = __$$RegisteredWordActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String wordId, String word, String reading, DateTime occurredAt});
}

/// @nodoc
class __$$RegisteredWordActivityImplCopyWithImpl<$Res>
    extends
        _$RegisteredWordActivityCopyWithImpl<$Res, _$RegisteredWordActivityImpl>
    implements _$$RegisteredWordActivityImplCopyWith<$Res> {
  __$$RegisteredWordActivityImplCopyWithImpl(
    _$RegisteredWordActivityImpl _value,
    $Res Function(_$RegisteredWordActivityImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wordId = null,
    Object? word = null,
    Object? reading = null,
    Object? occurredAt = null,
  }) {
    return _then(
      _$RegisteredWordActivityImpl(
        wordId: null == wordId
            ? _value.wordId
            : wordId // ignore: cast_nullable_to_non_nullable
                  as String,
        word: null == word
            ? _value.word
            : word // ignore: cast_nullable_to_non_nullable
                  as String,
        reading: null == reading
            ? _value.reading
            : reading // ignore: cast_nullable_to_non_nullable
                  as String,
        occurredAt: null == occurredAt
            ? _value.occurredAt
            : occurredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$RegisteredWordActivityImpl implements _RegisteredWordActivity {
  const _$RegisteredWordActivityImpl({
    required this.wordId,
    required this.word,
    required this.reading,
    required this.occurredAt,
  });

  @override
  final String wordId;
  @override
  final String word;
  @override
  final String reading;
  @override
  final DateTime occurredAt;

  @override
  String toString() {
    return 'RegisteredWordActivity(wordId: $wordId, word: $word, reading: $reading, occurredAt: $occurredAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisteredWordActivityImpl &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.reading, reading) || other.reading == reading) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, wordId, word, reading, occurredAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisteredWordActivityImplCopyWith<_$RegisteredWordActivityImpl>
  get copyWith =>
      __$$RegisteredWordActivityImplCopyWithImpl<_$RegisteredWordActivityImpl>(
        this,
        _$identity,
      );
}

abstract class _RegisteredWordActivity implements RegisteredWordActivity {
  const factory _RegisteredWordActivity({
    required final String wordId,
    required final String word,
    required final String reading,
    required final DateTime occurredAt,
  }) = _$RegisteredWordActivityImpl;

  @override
  String get wordId;
  @override
  String get word;
  @override
  String get reading;
  @override
  DateTime get occurredAt;
  @override
  @JsonKey(ignore: true)
  _$$RegisteredWordActivityImplCopyWith<_$RegisteredWordActivityImpl>
  get copyWith => throw _privateConstructorUsedError;
}
