// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$WordDocument {
  String get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get reading => throw _privateConstructorUsedError;
  String get initialLetter => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WordDocumentCopyWith<WordDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordDocumentCopyWith<$Res> {
  factory $WordDocumentCopyWith(
          WordDocument value, $Res Function(WordDocument) then) =
      _$WordDocumentCopyWithImpl<$Res, WordDocument>;
  @useResult
  $Res call(
      {String id,
      String word,
      String reading,
      String initialLetter,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$WordDocumentCopyWithImpl<$Res, $Val extends WordDocument>
    implements $WordDocumentCopyWith<$Res> {
  _$WordDocumentCopyWithImpl(this._value, this._then);

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
    Object? createdAt = null,
    Object? updatedAt = null,
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordDocumentImplCopyWith<$Res>
    implements $WordDocumentCopyWith<$Res> {
  factory _$$WordDocumentImplCopyWith(
          _$WordDocumentImpl value, $Res Function(_$WordDocumentImpl) then) =
      __$$WordDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String word,
      String reading,
      String initialLetter,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$WordDocumentImplCopyWithImpl<$Res>
    extends _$WordDocumentCopyWithImpl<$Res, _$WordDocumentImpl>
    implements _$$WordDocumentImplCopyWith<$Res> {
  __$$WordDocumentImplCopyWithImpl(
      _$WordDocumentImpl _value, $Res Function(_$WordDocumentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? reading = null,
    Object? initialLetter = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$WordDocumentImpl(
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
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$WordDocumentImpl implements _WordDocument {
  const _$WordDocumentImpl(
      {required this.id,
      required this.word,
      required this.reading,
      required this.initialLetter,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String id;
  @override
  final String word;
  @override
  final String reading;
  @override
  final String initialLetter;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'WordDocument(id: $id, word: $word, reading: $reading, initialLetter: $initialLetter, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.reading, reading) || other.reading == reading) &&
            (identical(other.initialLetter, initialLetter) ||
                other.initialLetter == initialLetter) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, word, reading, initialLetter, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WordDocumentImplCopyWith<_$WordDocumentImpl> get copyWith =>
      __$$WordDocumentImplCopyWithImpl<_$WordDocumentImpl>(this, _$identity);
}

abstract class _WordDocument implements WordDocument {
  const factory _WordDocument(
      {required final String id,
      required final String word,
      required final String reading,
      required final String initialLetter,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$WordDocumentImpl;

  @override
  String get id;
  @override
  String get word;
  @override
  String get reading;
  @override
  String get initialLetter;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$WordDocumentImplCopyWith<_$WordDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
