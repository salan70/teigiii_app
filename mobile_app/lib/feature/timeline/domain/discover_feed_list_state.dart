import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';
import 'discover_feed_entry.dart';

part 'discover_feed_list_state.freezed.dart';

/// おすすめタイムライン（mixed: 定義 + 言葉登録）の一覧 state。
@freezed
class DiscoverFeedListState
    with _$DiscoverFeedListState
    implements ListState<DiscoverFeedEntry> {
  const factory DiscoverFeedListState({
    required List<DiscoverFeedEntry> list,
    required String? nextCursor,
    required bool hasMore,
  }) = _DiscoverFeedListState;
}
