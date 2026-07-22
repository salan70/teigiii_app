// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_word_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SavedWordItemCWProxy {
  SavedWordItem word(WordSummary word);

  SavedWordItem isDefinedByMe(bool isDefinedByMe);

  SavedWordItem publicCount(int publicCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SavedWordItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SavedWordItem(...).copyWith(id: 12, name: "My name")
  /// ````
  SavedWordItem call({WordSummary word, bool isDefinedByMe, int publicCount});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSavedWordItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSavedWordItem.copyWith.fieldName(...)`
class _$SavedWordItemCWProxyImpl implements _$SavedWordItemCWProxy {
  const _$SavedWordItemCWProxyImpl(this._value);

  final SavedWordItem _value;

  @override
  SavedWordItem word(WordSummary word) => this(word: word);

  @override
  SavedWordItem isDefinedByMe(bool isDefinedByMe) =>
      this(isDefinedByMe: isDefinedByMe);

  @override
  SavedWordItem publicCount(int publicCount) => this(publicCount: publicCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `SavedWordItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// SavedWordItem(...).copyWith(id: 12, name: "My name")
  /// ````
  SavedWordItem call({
    Object? word = const $CopyWithPlaceholder(),
    Object? isDefinedByMe = const $CopyWithPlaceholder(),
    Object? publicCount = const $CopyWithPlaceholder(),
  }) {
    return SavedWordItem(
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as WordSummary,
      isDefinedByMe: isDefinedByMe == const $CopyWithPlaceholder()
          ? _value.isDefinedByMe
          // ignore: cast_nullable_to_non_nullable
          : isDefinedByMe as bool,
      publicCount: publicCount == const $CopyWithPlaceholder()
          ? _value.publicCount
          // ignore: cast_nullable_to_non_nullable
          : publicCount as int,
    );
  }
}

extension $SavedWordItemCopyWith on SavedWordItem {
  /// Returns a callable class that can be used as follows: `instanceOfSavedWordItem.copyWith(...)` or like so:`instanceOfSavedWordItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SavedWordItemCWProxy get copyWith => _$SavedWordItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedWordItem _$SavedWordItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SavedWordItem', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['word', 'isDefinedByMe', 'publicCount'],
      );
      final val = SavedWordItem(
        word: $checkedConvert(
          'word',
          (v) => WordSummary.fromJson(v as Map<String, dynamic>),
        ),
        isDefinedByMe: $checkedConvert('isDefinedByMe', (v) => v as bool),
        publicCount: $checkedConvert('publicCount', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$SavedWordItemToJson(SavedWordItem instance) =>
    <String, dynamic>{
      'word': instance.word.toJson(),
      'isDefinedByMe': instance.isDefinedByMe,
      'publicCount': instance.publicCount,
    };
