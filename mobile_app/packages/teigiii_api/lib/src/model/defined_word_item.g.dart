// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defined_word_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DefinedWordItemCWProxy {
  DefinedWordItem word(WordSummary word);

  DefinedWordItem publicCount(int publicCount);

  DefinedWordItem privateCount(int privateCount);

  DefinedWordItem draftCount(int draftCount);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DefinedWordItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DefinedWordItem(...).copyWith(id: 12, name: "My name")
  /// ````
  DefinedWordItem call({
    WordSummary word,
    int publicCount,
    int privateCount,
    int draftCount,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDefinedWordItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDefinedWordItem.copyWith.fieldName(...)`
class _$DefinedWordItemCWProxyImpl implements _$DefinedWordItemCWProxy {
  const _$DefinedWordItemCWProxyImpl(this._value);

  final DefinedWordItem _value;

  @override
  DefinedWordItem word(WordSummary word) => this(word: word);

  @override
  DefinedWordItem publicCount(int publicCount) =>
      this(publicCount: publicCount);

  @override
  DefinedWordItem privateCount(int privateCount) =>
      this(privateCount: privateCount);

  @override
  DefinedWordItem draftCount(int draftCount) => this(draftCount: draftCount);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DefinedWordItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DefinedWordItem(...).copyWith(id: 12, name: "My name")
  /// ````
  DefinedWordItem call({
    Object? word = const $CopyWithPlaceholder(),
    Object? publicCount = const $CopyWithPlaceholder(),
    Object? privateCount = const $CopyWithPlaceholder(),
    Object? draftCount = const $CopyWithPlaceholder(),
  }) {
    return DefinedWordItem(
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as WordSummary,
      publicCount: publicCount == const $CopyWithPlaceholder()
          ? _value.publicCount
          // ignore: cast_nullable_to_non_nullable
          : publicCount as int,
      privateCount: privateCount == const $CopyWithPlaceholder()
          ? _value.privateCount
          // ignore: cast_nullable_to_non_nullable
          : privateCount as int,
      draftCount: draftCount == const $CopyWithPlaceholder()
          ? _value.draftCount
          // ignore: cast_nullable_to_non_nullable
          : draftCount as int,
    );
  }
}

extension $DefinedWordItemCopyWith on DefinedWordItem {
  /// Returns a callable class that can be used as follows: `instanceOfDefinedWordItem.copyWith(...)` or like so:`instanceOfDefinedWordItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DefinedWordItemCWProxy get copyWith => _$DefinedWordItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefinedWordItem _$DefinedWordItemFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('DefinedWordItem', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const ['word', 'publicCount', 'privateCount', 'draftCount'],
  );
  final val = DefinedWordItem(
    word: $checkedConvert(
      'word',
      (v) => WordSummary.fromJson(v as Map<String, dynamic>),
    ),
    publicCount: $checkedConvert('publicCount', (v) => (v as num).toInt()),
    privateCount: $checkedConvert('privateCount', (v) => (v as num).toInt()),
    draftCount: $checkedConvert('draftCount', (v) => (v as num).toInt()),
  );
  return val;
});

Map<String, dynamic> _$DefinedWordItemToJson(DefinedWordItem instance) =>
    <String, dynamic>{
      'word': instance.word.toJson(),
      'publicCount': instance.publicCount,
      'privateCount': instance.privateCount,
      'draftCount': instance.draftCount,
    };
