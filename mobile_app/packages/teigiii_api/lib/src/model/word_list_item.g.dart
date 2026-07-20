// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_list_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WordListItemCWProxy {
  WordListItem id(String id);

  WordListItem word(String word);

  WordListItem reading(String reading);

  WordListItem readingSubGroup(String readingSubGroup);

  WordListItem publicDefinitionCount(int publicDefinitionCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordListItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordListItem(...).copyWith(id: 12, name: "My name")
  /// ````
  WordListItem call({
    String id,
    String word,
    String reading,
    String readingSubGroup,
    int publicDefinitionCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWordListItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWordListItem.copyWith.fieldName(...)`
class _$WordListItemCWProxyImpl implements _$WordListItemCWProxy {
  const _$WordListItemCWProxyImpl(this._value);

  final WordListItem _value;

  @override
  WordListItem id(String id) => this(id: id);

  @override
  WordListItem word(String word) => this(word: word);

  @override
  WordListItem reading(String reading) => this(reading: reading);

  @override
  WordListItem readingSubGroup(String readingSubGroup) =>
      this(readingSubGroup: readingSubGroup);

  @override
  WordListItem publicDefinitionCount(int publicDefinitionCount) =>
      this(publicDefinitionCount: publicDefinitionCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordListItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordListItem(...).copyWith(id: 12, name: "My name")
  /// ````
  WordListItem call({
    Object? id = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
    Object? reading = const $CopyWithPlaceholder(),
    Object? readingSubGroup = const $CopyWithPlaceholder(),
    Object? publicDefinitionCount = const $CopyWithPlaceholder(),
  }) {
    return WordListItem(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as String,
      reading: reading == const $CopyWithPlaceholder()
          ? _value.reading
          // ignore: cast_nullable_to_non_nullable
          : reading as String,
      readingSubGroup: readingSubGroup == const $CopyWithPlaceholder()
          ? _value.readingSubGroup
          // ignore: cast_nullable_to_non_nullable
          : readingSubGroup as String,
      publicDefinitionCount:
          publicDefinitionCount == const $CopyWithPlaceholder()
          ? _value.publicDefinitionCount
          // ignore: cast_nullable_to_non_nullable
          : publicDefinitionCount as int,
    );
  }
}

extension $WordListItemCopyWith on WordListItem {
  /// Returns a callable class that can be used as follows: `instanceOfWordListItem.copyWith(...)` or like so:`instanceOfWordListItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WordListItemCWProxy get copyWith => _$WordListItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordListItem _$WordListItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WordListItem', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'word',
          'reading',
          'readingSubGroup',
          'publicDefinitionCount',
        ],
      );
      final val = WordListItem(
        id: $checkedConvert('id', (v) => v as String),
        word: $checkedConvert('word', (v) => v as String),
        reading: $checkedConvert('reading', (v) => v as String),
        readingSubGroup: $checkedConvert('readingSubGroup', (v) => v as String),
        publicDefinitionCount: $checkedConvert(
          'publicDefinitionCount',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$WordListItemToJson(WordListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'reading': instance.reading,
      'readingSubGroup': instance.readingSubGroup,
      'publicDefinitionCount': instance.publicDefinitionCount,
    };
