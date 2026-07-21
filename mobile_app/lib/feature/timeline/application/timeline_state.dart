import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/timeline.dart';
import '../repository/timeline_repository.dart';

part 'timeline_state.g.dart';

@riverpod
class DiscoverTimeline extends _$DiscoverTimeline {
  @override
  Future<TimelinePage> build() =>
      ref.read(timelineRepositoryProvider).fetchDiscover();

  Future<void> fetchMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || state.isLoading) {
      return;
    }
    state = const AsyncLoading<TimelinePage>().copyWithPrevious(state);
    try {
      final next = await ref
          .read(timelineRepositoryProvider)
          .fetchDiscover(cursor: current.nextCursor);
      state = AsyncData(
        TimelinePage(
          items: [...current.items, ...next.items],
          nextCursor: next.nextCursor,
        ),
      );
    } on Object catch (error, stackTrace) {
      state = AsyncError<TimelinePage>(
        error,
        stackTrace,
      ).copyWithPrevious(state);
    }
  }
}
