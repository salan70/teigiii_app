// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'definition_response.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DefinitionResponseCWProxy {
  DefinitionResponse id(String id);

  DefinitionResponse word(WordSummary word);

  DefinitionResponse author(UserSummary author);

  DefinitionResponse body(String body);

  DefinitionResponse status(DefinitionStatus status);

  DefinitionResponse isEdited(bool isEdited);

  DefinitionResponse likesCount(int likesCount);

  DefinitionResponse isLikedByMe(bool isLikedByMe);

  DefinitionResponse finalizedAt(DateTime? finalizedAt);

  DefinitionResponse editableUntil(DateTime? editableUntil);

  DefinitionResponse createdAt(DateTime createdAt);

  DefinitionResponse updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DefinitionResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DefinitionResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  DefinitionResponse call({
    String id,
    WordSummary word,
    UserSummary author,
    String body,
    DefinitionStatus status,
    bool isEdited,
    int likesCount,
    bool isLikedByMe,
    DateTime? finalizedAt,
    DateTime? editableUntil,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDefinitionResponse.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDefinitionResponse.copyWith.fieldName(...)`
class _$DefinitionResponseCWProxyImpl implements _$DefinitionResponseCWProxy {
  const _$DefinitionResponseCWProxyImpl(this._value);

  final DefinitionResponse _value;

  @override
  DefinitionResponse id(String id) => this(id: id);

  @override
  DefinitionResponse word(WordSummary word) => this(word: word);

  @override
  DefinitionResponse author(UserSummary author) => this(author: author);

  @override
  DefinitionResponse body(String body) => this(body: body);

  @override
  DefinitionResponse status(DefinitionStatus status) => this(status: status);

  @override
  DefinitionResponse isEdited(bool isEdited) => this(isEdited: isEdited);

  @override
  DefinitionResponse likesCount(int likesCount) => this(likesCount: likesCount);

  @override
  DefinitionResponse isLikedByMe(bool isLikedByMe) =>
      this(isLikedByMe: isLikedByMe);

  @override
  DefinitionResponse finalizedAt(DateTime? finalizedAt) =>
      this(finalizedAt: finalizedAt);

  @override
  DefinitionResponse editableUntil(DateTime? editableUntil) =>
      this(editableUntil: editableUntil);

  @override
  DefinitionResponse createdAt(DateTime createdAt) =>
      this(createdAt: createdAt);

  @override
  DefinitionResponse updatedAt(DateTime updatedAt) =>
      this(updatedAt: updatedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DefinitionResponse(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DefinitionResponse(...).copyWith(id: 12, name: "My name")
  /// ````
  DefinitionResponse call({
    Object? id = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
    Object? author = const $CopyWithPlaceholder(),
    Object? body = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? isEdited = const $CopyWithPlaceholder(),
    Object? likesCount = const $CopyWithPlaceholder(),
    Object? isLikedByMe = const $CopyWithPlaceholder(),
    Object? finalizedAt = const $CopyWithPlaceholder(),
    Object? editableUntil = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return DefinitionResponse(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as WordSummary,
      author: author == const $CopyWithPlaceholder()
          ? _value.author
          // ignore: cast_nullable_to_non_nullable
          : author as UserSummary,
      body: body == const $CopyWithPlaceholder()
          ? _value.body
          // ignore: cast_nullable_to_non_nullable
          : body as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as DefinitionStatus,
      isEdited: isEdited == const $CopyWithPlaceholder()
          ? _value.isEdited
          // ignore: cast_nullable_to_non_nullable
          : isEdited as bool,
      likesCount: likesCount == const $CopyWithPlaceholder()
          ? _value.likesCount
          // ignore: cast_nullable_to_non_nullable
          : likesCount as int,
      isLikedByMe: isLikedByMe == const $CopyWithPlaceholder()
          ? _value.isLikedByMe
          // ignore: cast_nullable_to_non_nullable
          : isLikedByMe as bool,
      finalizedAt: finalizedAt == const $CopyWithPlaceholder()
          ? _value.finalizedAt
          // ignore: cast_nullable_to_non_nullable
          : finalizedAt as DateTime?,
      editableUntil: editableUntil == const $CopyWithPlaceholder()
          ? _value.editableUntil
          // ignore: cast_nullable_to_non_nullable
          : editableUntil as DateTime?,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder()
          ? _value.updatedAt
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $DefinitionResponseCopyWith on DefinitionResponse {
  /// Returns a callable class that can be used as follows: `instanceOfDefinitionResponse.copyWith(...)` or like so:`instanceOfDefinitionResponse.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DefinitionResponseCWProxy get copyWith =>
      _$DefinitionResponseCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefinitionResponse _$DefinitionResponseFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DefinitionResponse', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'word',
      'author',
      'body',
      'status',
      'isEdited',
      'likesCount',
      'isLikedByMe',
      'finalizedAt',
      'editableUntil',
      'createdAt',
      'updatedAt',
    ],
  );
  final val = DefinitionResponse(
    id: $checkedConvert('id', (v) => v as String),
    word: $checkedConvert(
      'word',
      (v) => WordSummary.fromJson(v as Map<String, dynamic>),
    ),
    author: $checkedConvert(
      'author',
      (v) => UserSummary.fromJson(v as Map<String, dynamic>),
    ),
    body: $checkedConvert('body', (v) => v as String),
    status: $checkedConvert(
      'status',
      (v) => $enumDecode(_$DefinitionStatusEnumMap, v),
    ),
    isEdited: $checkedConvert('isEdited', (v) => v as bool),
    likesCount: $checkedConvert('likesCount', (v) => (v as num).toInt()),
    isLikedByMe: $checkedConvert('isLikedByMe', (v) => v as bool),
    finalizedAt: $checkedConvert(
      'finalizedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    editableUntil: $checkedConvert(
      'editableUntil',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$DefinitionResponseToJson(DefinitionResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word.toJson(),
      'author': instance.author.toJson(),
      'body': instance.body,
      'status': _$DefinitionStatusEnumMap[instance.status]!,
      'isEdited': instance.isEdited,
      'likesCount': instance.likesCount,
      'isLikedByMe': instance.isLikedByMe,
      'finalizedAt': instance.finalizedAt?.toIso8601String(),
      'editableUntil': instance.editableUntil?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$DefinitionStatusEnumMap = {
  DefinitionStatus.public: 'public',
  DefinitionStatus.private: 'private',
};
