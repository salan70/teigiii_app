// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dictionary_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserDictionaryItemCWProxy {
  UserDictionaryItem word(WordSummary word);

  UserDictionaryItem publicCount(int publicCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserDictionaryItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserDictionaryItem(...).copyWith(id: 12, name: "My name")
  /// ````
  UserDictionaryItem call({WordSummary word, int publicCount});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserDictionaryItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserDictionaryItem.copyWith.fieldName(...)`
class _$UserDictionaryItemCWProxyImpl implements _$UserDictionaryItemCWProxy {
  const _$UserDictionaryItemCWProxyImpl(this._value);

  final UserDictionaryItem _value;

  @override
  UserDictionaryItem word(WordSummary word) => this(word: word);

  @override
  UserDictionaryItem publicCount(int publicCount) =>
      this(publicCount: publicCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserDictionaryItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserDictionaryItem(...).copyWith(id: 12, name: "My name")
  /// ````
  UserDictionaryItem call({
    Object? word = const $CopyWithPlaceholder(),
    Object? publicCount = const $CopyWithPlaceholder(),
  }) {
    return UserDictionaryItem(
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as WordSummary,
      publicCount: publicCount == const $CopyWithPlaceholder()
          ? _value.publicCount
          // ignore: cast_nullable_to_non_nullable
          : publicCount as int,
    );
  }
}

extension $UserDictionaryItemCopyWith on UserDictionaryItem {
  /// Returns a callable class that can be used as follows: `instanceOfUserDictionaryItem.copyWith(...)` or like so:`instanceOfUserDictionaryItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserDictionaryItemCWProxy get copyWith =>
      _$UserDictionaryItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDictionaryItem _$UserDictionaryItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserDictionaryItem', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['word', 'publicCount']);
      final val = UserDictionaryItem(
        word: $checkedConvert(
          'word',
          (v) => WordSummary.fromJson(v as Map<String, dynamic>),
        ),
        publicCount: $checkedConvert('publicCount', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$UserDictionaryItemToJson(UserDictionaryItem instance) =>
    <String, dynamic>{
      'word': instance.word.toJson(),
      'publicCount': instance.publicCount,
    };
