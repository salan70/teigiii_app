// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WordRegistration {
  Word get word => throw _privateConstructorUsedError;
  WordRegistrationOutcome get outcome => throw _privateConstructorUsedError;

  /// Create a copy of WordRegistration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordRegistrationCopyWith<WordRegistration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordRegistrationCopyWith<$Res> {
  factory $WordRegistrationCopyWith(
    WordRegistration value,
    $Res Function(WordRegistration) then,
  ) = _$WordRegistrationCopyWithImpl<$Res, WordRegistration>;
  @useResult
  $Res call({Word word, WordRegistrationOutcome outcome});

  $WordCopyWith<$Res> get word;
}

/// @nodoc
class _$WordRegistrationCopyWithImpl<$Res, $Val extends WordRegistration>
    implements $WordRegistrationCopyWith<$Res> {
  _$WordRegistrationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordRegistration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? word = null, Object? outcome = null}) {
    return _then(
      _value.copyWith(
            word: null == word
                ? _value.word
                : word // ignore: cast_nullable_to_non_nullable
                      as Word,
            outcome: null == outcome
                ? _value.outcome
                : outcome // ignore: cast_nullable_to_non_nullable
                      as WordRegistrationOutcome,
          )
          as $Val,
    );
  }

  /// Create a copy of WordRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WordCopyWith<$Res> get word {
    return $WordCopyWith<$Res>(_value.word, (value) {
      return _then(_value.copyWith(word: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WordRegistrationImplCopyWith<$Res>
    implements $WordRegistrationCopyWith<$Res> {
  factory _$$WordRegistrationImplCopyWith(
    _$WordRegistrationImpl value,
    $Res Function(_$WordRegistrationImpl) then,
  ) = __$$WordRegistrationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Word word, WordRegistrationOutcome outcome});

  @override
  $WordCopyWith<$Res> get word;
}

/// @nodoc
class __$$WordRegistrationImplCopyWithImpl<$Res>
    extends _$WordRegistrationCopyWithImpl<$Res, _$WordRegistrationImpl>
    implements _$$WordRegistrationImplCopyWith<$Res> {
  __$$WordRegistrationImplCopyWithImpl(
    _$WordRegistrationImpl _value,
    $Res Function(_$WordRegistrationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WordRegistration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? word = null, Object? outcome = null}) {
    return _then(
      _$WordRegistrationImpl(
        word: null == word
            ? _value.word
            : word // ignore: cast_nullable_to_non_nullable
                  as Word,
        outcome: null == outcome
            ? _value.outcome
            : outcome // ignore: cast_nullable_to_non_nullable
                  as WordRegistrationOutcome,
      ),
    );
  }
}

/// @nodoc

class _$WordRegistrationImpl implements _WordRegistration {
  const _$WordRegistrationImpl({required this.word, required this.outcome});

  @override
  final Word word;
  @override
  final WordRegistrationOutcome outcome;

  @override
  String toString() {
    return 'WordRegistration(word: $word, outcome: $outcome)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordRegistrationImpl &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.outcome, outcome) || other.outcome == outcome));
  }

  @override
  int get hashCode => Object.hash(runtimeType, word, outcome);

  /// Create a copy of WordRegistration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordRegistrationImplCopyWith<_$WordRegistrationImpl> get copyWith =>
      __$$WordRegistrationImplCopyWithImpl<_$WordRegistrationImpl>(
        this,
        _$identity,
      );
}

abstract class _WordRegistration implements WordRegistration {
  const factory _WordRegistration({
    required final Word word,
    required final WordRegistrationOutcome outcome,
  }) = _$WordRegistrationImpl;

  @override
  Word get word;
  @override
  WordRegistrationOutcome get outcome;

  /// Create a copy of WordRegistration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordRegistrationImplCopyWith<_$WordRegistrationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
