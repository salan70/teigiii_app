// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'definition_for_write.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DefinitionForWrite {
  /// 更新時のみ使用する。新規投稿時はnull
  String? get id => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get wordReading => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  String get definition => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DefinitionForWriteCopyWith<DefinitionForWrite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefinitionForWriteCopyWith<$Res> {
  factory $DefinitionForWriteCopyWith(
          DefinitionForWrite value, $Res Function(DefinitionForWrite) then) =
      _$DefinitionForWriteCopyWithImpl<$Res, DefinitionForWrite>;
  @useResult
  $Res call(
      {String? id,
      String authorId,
      String word,
      String wordReading,
      bool isPublic,
      String definition});
}

/// @nodoc
class _$DefinitionForWriteCopyWithImpl<$Res, $Val extends DefinitionForWrite>
    implements $DefinitionForWriteCopyWith<$Res> {
  _$DefinitionForWriteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? authorId = null,
    Object? word = null,
    Object? wordReading = null,
    Object? isPublic = null,
    Object? definition = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DefinitionForWriteCopyWith<$Res>
    implements $DefinitionForWriteCopyWith<$Res> {
  factory _$$_DefinitionForWriteCopyWith(_$_DefinitionForWrite value,
          $Res Function(_$_DefinitionForWrite) then) =
      __$$_DefinitionForWriteCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String authorId,
      String word,
      String wordReading,
      bool isPublic,
      String definition});
}

/// @nodoc
class __$$_DefinitionForWriteCopyWithImpl<$Res>
    extends _$DefinitionForWriteCopyWithImpl<$Res, _$_DefinitionForWrite>
    implements _$$_DefinitionForWriteCopyWith<$Res> {
  __$$_DefinitionForWriteCopyWithImpl(
      _$_DefinitionForWrite _value, $Res Function(_$_DefinitionForWrite) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? authorId = null,
    Object? word = null,
    Object? wordReading = null,
    Object? isPublic = null,
    Object? definition = null,
  }) {
    return _then(_$_DefinitionForWrite(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc

class _$_DefinitionForWrite extends _DefinitionForWrite {
  const _$_DefinitionForWrite(
      {required this.id,
      required this.authorId,
      required this.word,
      required this.wordReading,
      required this.isPublic,
      required this.definition})
      : super._();

  /// 更新時のみ使用する。新規投稿時はnull
  @override
  final String? id;
  @override
  final String authorId;
  @override
  final String word;
  @override
  final String wordReading;
  @override
  final bool isPublic;
  @override
  final String definition;

  @override
  String toString() {
    return 'DefinitionForWrite(id: $id, authorId: $authorId, word: $word, wordReading: $wordReading, isPublic: $isPublic, definition: $definition)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DefinitionForWrite &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.wordReading, wordReading) ||
                other.wordReading == wordReading) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.definition, definition) ||
                other.definition == definition));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, authorId, word, wordReading, isPublic, definition);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DefinitionForWriteCopyWith<_$_DefinitionForWrite> get copyWith =>
      __$$_DefinitionForWriteCopyWithImpl<_$_DefinitionForWrite>(
          this, _$identity);
}

abstract class _DefinitionForWrite extends DefinitionForWrite {
  const factory _DefinitionForWrite(
      {required final String? id,
      required final String authorId,
      required final String word,
      required final String wordReading,
      required final bool isPublic,
      required final String definition}) = _$_DefinitionForWrite;
  const _DefinitionForWrite._() : super._();

  @override

  /// 更新時のみ使用する。新規投稿時はnull
  String? get id;
  @override
  String get authorId;
  @override
  String get word;
  @override
  String get wordReading;
  @override
  bool get isPublic;
  @override
  String get definition;
  @override
  @JsonKey(ignore: true)
  _$$_DefinitionForWriteCopyWith<_$_DefinitionForWrite> get copyWith =>
      throw _privateConstructorUsedError;
}
