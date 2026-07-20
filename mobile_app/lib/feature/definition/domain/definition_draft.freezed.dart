// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'definition_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DefinitionDraft {
  String get id => throw _privateConstructorUsedError;
  String? get wordId => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get wordReading => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  String get definition => throw _privateConstructorUsedError;
  bool get isPersisted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DefinitionDraftCopyWith<DefinitionDraft> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefinitionDraftCopyWith<$Res> {
  factory $DefinitionDraftCopyWith(
          DefinitionDraft value, $Res Function(DefinitionDraft) then) =
      _$DefinitionDraftCopyWithImpl<$Res, DefinitionDraft>;
  @useResult
  $Res call(
      {String id,
      String? wordId,
      String word,
      String wordReading,
      bool isPublic,
      String definition,
      bool isPersisted});
}

/// @nodoc
class _$DefinitionDraftCopyWithImpl<$Res, $Val extends DefinitionDraft>
    implements $DefinitionDraftCopyWith<$Res> {
  _$DefinitionDraftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? wordId = freezed,
    Object? word = null,
    Object? wordReading = null,
    Object? isPublic = null,
    Object? definition = null,
    Object? isPersisted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      wordId: freezed == wordId
          ? _value.wordId
          : wordId // ignore: cast_nullable_to_non_nullable
              as String?,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      wordReading: null == wordReading
          ? _value.wordReading
          : wordReading // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      definition: null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      isPersisted: null == isPersisted
          ? _value.isPersisted
          : isPersisted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DefinitionDraftImplCopyWith<$Res>
    implements $DefinitionDraftCopyWith<$Res> {
  factory _$$DefinitionDraftImplCopyWith(_$DefinitionDraftImpl value,
          $Res Function(_$DefinitionDraftImpl) then) =
      __$$DefinitionDraftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? wordId,
      String word,
      String wordReading,
      bool isPublic,
      String definition,
      bool isPersisted});
}

/// @nodoc
class __$$DefinitionDraftImplCopyWithImpl<$Res>
    extends _$DefinitionDraftCopyWithImpl<$Res, _$DefinitionDraftImpl>
    implements _$$DefinitionDraftImplCopyWith<$Res> {
  __$$DefinitionDraftImplCopyWithImpl(
      _$DefinitionDraftImpl _value, $Res Function(_$DefinitionDraftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? wordId = freezed,
    Object? word = null,
    Object? wordReading = null,
    Object? isPublic = null,
    Object? definition = null,
    Object? isPersisted = null,
  }) {
    return _then(_$DefinitionDraftImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      wordId: freezed == wordId
          ? _value.wordId
          : wordId // ignore: cast_nullable_to_non_nullable
              as String?,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      wordReading: null == wordReading
          ? _value.wordReading
          : wordReading // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      definition: null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      isPersisted: null == isPersisted
          ? _value.isPersisted
          : isPersisted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DefinitionDraftImpl extends _DefinitionDraft {
  const _$DefinitionDraftImpl(
      {required this.id,
      required this.wordId,
      required this.word,
      required this.wordReading,
      required this.isPublic,
      required this.definition,
      required this.isPersisted})
      : super._();

  @override
  final String id;
  @override
  final String? wordId;
  @override
  final String word;
  @override
  final String wordReading;
  @override
  final bool isPublic;
  @override
  final String definition;
  @override
  final bool isPersisted;

  @override
  String toString() {
    return 'DefinitionDraft(id: $id, wordId: $wordId, word: $word, wordReading: $wordReading, isPublic: $isPublic, definition: $definition, isPersisted: $isPersisted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefinitionDraftImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.wordReading, wordReading) ||
                other.wordReading == wordReading) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            (identical(other.isPersisted, isPersisted) ||
                other.isPersisted == isPersisted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, wordId, word, wordReading,
      isPublic, definition, isPersisted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DefinitionDraftImplCopyWith<_$DefinitionDraftImpl> get copyWith =>
      __$$DefinitionDraftImplCopyWithImpl<_$DefinitionDraftImpl>(
          this, _$identity);
}

abstract class _DefinitionDraft extends DefinitionDraft {
  const factory _DefinitionDraft(
      {required final String id,
      required final String? wordId,
      required final String word,
      required final String wordReading,
      required final bool isPublic,
      required final String definition,
      required final bool isPersisted}) = _$DefinitionDraftImpl;
  const _DefinitionDraft._() : super._();

  @override
  String get id;
  @override
  String? get wordId;
  @override
  String get word;
  @override
  String get wordReading;
  @override
  bool get isPublic;
  @override
  String get definition;
  @override
  bool get isPersisted;
  @override
  @JsonKey(ignore: true)
  _$$DefinitionDraftImplCopyWith<_$DefinitionDraftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
