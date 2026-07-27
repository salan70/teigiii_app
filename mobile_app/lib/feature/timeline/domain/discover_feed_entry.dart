import 'package:freezed_annotation/freezed_annotation.dart';

import '../../definition/domain/definition.dart';
import 'registered_word_activity.dart';

part 'discover_feed_entry.freezed.dart';

/// おすすめタイムラインに並ぶ要素。
///
/// 定義と言葉登録が混在するため sealed class で表現する。
@freezed
sealed class DiscoverFeedEntry with _$DiscoverFeedEntry {
  const factory DiscoverFeedEntry.definition(Definition definition) =
      DiscoverFeedDefinitionEntry;

  const factory DiscoverFeedEntry.wordRegistered(
    RegisteredWordActivity activity,
  ) = DiscoverFeedWordRegisteredEntry;
}
