// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_feed_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DiscoverFeedItemCWProxy {
  DiscoverFeedItem type(DiscoverFeedItemTypeEnum type);

  DiscoverFeedItem occurredAt(DateTime occurredAt);

  DiscoverFeedItem definition(DefinitionResponse definition);

  DiscoverFeedItem word(WordSummary word);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DiscoverFeedItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DiscoverFeedItem(...).copyWith(id: 12, name: "My name")
  /// ````
  DiscoverFeedItem call({
    DiscoverFeedItemTypeEnum type,
    DateTime occurredAt,
    DefinitionResponse definition,
    WordSummary word,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDiscoverFeedItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDiscoverFeedItem.copyWith.fieldName(...)`
class _$DiscoverFeedItemCWProxyImpl implements _$DiscoverFeedItemCWProxy {
  const _$DiscoverFeedItemCWProxyImpl(this._value);

  final DiscoverFeedItem _value;

  @override
  DiscoverFeedItem type(DiscoverFeedItemTypeEnum type) => this(type: type);

  @override
  DiscoverFeedItem occurredAt(DateTime occurredAt) =>
      this(occurredAt: occurredAt);

  @override
  DiscoverFeedItem definition(DefinitionResponse definition) =>
      this(definition: definition);

  @override
  DiscoverFeedItem word(WordSummary word) => this(word: word);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DiscoverFeedItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DiscoverFeedItem(...).copyWith(id: 12, name: "My name")
  /// ````
  DiscoverFeedItem call({
    Object? type = const $CopyWithPlaceholder(),
    Object? occurredAt = const $CopyWithPlaceholder(),
    Object? definition = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
  }) {
    return DiscoverFeedItem(
      type: type == const $CopyWithPlaceholder()
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as DiscoverFeedItemTypeEnum,
      occurredAt: occurredAt == const $CopyWithPlaceholder()
          ? _value.occurredAt
          // ignore: cast_nullable_to_non_nullable
          : occurredAt as DateTime,
      definition: definition == const $CopyWithPlaceholder()
          ? _value.definition
          // ignore: cast_nullable_to_non_nullable
          : definition as DefinitionResponse,
      word: word == const $CopyWithPlaceholder()
          ? _value.word
          // ignore: cast_nullable_to_non_nullable
          : word as WordSummary,
    );
  }
}

extension $DiscoverFeedItemCopyWith on DiscoverFeedItem {
  /// Returns a callable class that can be used as follows: `instanceOfDiscoverFeedItem.copyWith(...)` or like so:`instanceOfDiscoverFeedItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DiscoverFeedItemCWProxy get copyWith => _$DiscoverFeedItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoverFeedItem _$DiscoverFeedItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('DiscoverFeedItem', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['type', 'occurredAt', 'definition', 'word'],
      );
      final val = DiscoverFeedItem(
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$DiscoverFeedItemTypeEnumEnumMap, v),
        ),
        occurredAt: $checkedConvert(
          'occurredAt',
          (v) => DateTime.parse(v as String),
        ),
        definition: $checkedConvert(
          'definition',
          (v) => DefinitionResponse.fromJson(v as Map<String, dynamic>),
        ),
        word: $checkedConvert(
          'word',
          (v) => WordSummary.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$DiscoverFeedItemToJson(DiscoverFeedItem instance) =>
    <String, dynamic>{
      'type': _$DiscoverFeedItemTypeEnumEnumMap[instance.type]!,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'definition': instance.definition.toJson(),
      'word': instance.word.toJson(),
    };

const _$DiscoverFeedItemTypeEnumEnumMap = {
  DiscoverFeedItemTypeEnum.definition: 'definition',
  DiscoverFeedItemTypeEnum.wordRegistered: 'wordRegistered',
};
