// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_summary.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$WordSummaryCWProxy {
  WordSummary id(String id);

  WordSummary word(String word);

  WordSummary reading(String reading);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  WordSummary call({String id, String word, String reading});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfWordSummary.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfWordSummary.copyWith.fieldName(...)`
class _$WordSummaryCWProxyImpl implements _$WordSummaryCWProxy {
  const _$WordSummaryCWProxyImpl(this._value);

  final WordSummary _value;

  @override
  WordSummary id(String id) => this(id: id);

  @override
  WordSummary word(String word) => this(word: word);

  @override
  WordSummary reading(String reading) => this(reading: reading);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `WordSummary(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// WordSummary(...).copyWith(id: 12, name: "My name")
  /// ````
  WordSummary call({
    Object? id = const $CopyWithPlaceholder(),
    Object? word = const $CopyWithPlaceholder(),
    Object? reading = const $CopyWithPlaceholder(),
  }) {
    return WordSummary(
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
    );
  }
}

extension $WordSummaryCopyWith on WordSummary {
  /// Returns a callable class that can be used as follows: `instanceOfWordSummary.copyWith(...)` or like so:`instanceOfWordSummary.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$WordSummaryCWProxy get copyWith => _$WordSummaryCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordSummary _$WordSummaryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WordSummary', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'word', 'reading']);
      final val = WordSummary(
        id: $checkedConvert('id', (v) => v as String),
        word: $checkedConvert('word', (v) => v as String),
        reading: $checkedConvert('reading', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$WordSummaryToJson(WordSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'reading': instance.reading,
    };
