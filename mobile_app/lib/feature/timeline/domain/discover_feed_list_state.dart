import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../util/interface/list_state.dart';

part 'discover_feed_list_state.freezed.dart';

/// おすすめタイムライン（mixed: 定義 + 言葉登録）の一覧 state。
///
/// [list] の各要素は Definition または WordRegisteredActivity。
@freezed
class DiscoverFeedListState with _$DiscoverFeedListState implements ListState {
  const factory DiscoverFeedListState({
    required List<dynamic> list,
    required String? nextCursor,
    required bool hasMore,
  }) = _DiscoverFeedListState;
}
