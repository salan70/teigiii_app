import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common_widget/cupertino_refresh_indicator.dart';
import '../../../core/common_widget/error_and_retry_widget.dart';
import '../../../util/interface/list_state.dart';
import '../../../util/logger.dart';

class InfinityScrollWidget extends ConsumerWidget {
  InfinityScrollWidget({
    super.key,
    required this.listStateNotifierProvider,
    required this.fetchMore,
    required this.tileBuilder,
    required this.shimmerTile,
    required this.shimmerTileNumber,
  });

  /// 扱うstate ([ListState]型)を保持するProvider
  final AsyncNotifierProvider<dynamic, ListState> listStateNotifierProvider;
  final VoidCallback fetchMore;

  /// [ListState] の中身（tile）を作成するための関数
  final Widget Function(dynamic item) tileBuilder;

  /// 初回読み込み時に表示させるShimmer
  final Widget shimmerTile;

  /// [shimmerTile]を表示させる数
  final int shimmerTileNumber;

  final scrollController = ScrollController();
  // エラーが発生してリビルドした際、スクロール位置を保持するためのキー
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncListState = ref.watch(listStateNotifierProvider);

    Future<void> onRefresh() async {
      ref.invalidate(listStateNotifierProvider);
      // indicatorを表示し続けるため、取得が完了するまで待つ
      await ref.read(listStateNotifierProvider.future);
    }

    return asyncListState.when(
      data: (listState) {
        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            // 画面の一番下までスクロールしたかどうかを判定
            if (notification.metrics.extentAfter == 0) {
              fetchMore();
              return true;
            }
            return false;
          },
          child: _StateScrollBar(
            globalKey: globalKey,
            scrollController: scrollController,
            onRefresh: onRefresh,
            asyncListState: asyncListState,
            tileBuilder: tileBuilder,
            bottomWidget: listState.hasMore
                ? Column(
                    children: [
                      const CupertinoActivityIndicator(),
                      SizedBox(height: 40.h),
                    ],
                  )
                : const SizedBox(),
          ),
        );
      },
      error: (error, stackTrace) {
        logger.e('error: $error, stackTrace: $stackTrace');

        // 初回読み込み時にエラーが発生し、再読み込みしている場合
        if (asyncListState.isRefreshing && !asyncListState.hasValue) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        // 取得済みのデータがある場合、それを表示する
        if (asyncListState.hasValue) {
          return _StateScrollBar(
            globalKey: globalKey,
            scrollController: scrollController,
            onRefresh: onRefresh,
            asyncListState: asyncListState,
            tileBuilder: tileBuilder,
            bottomWidget: _BottomWidgetWhenError(
              fetchMore: fetchMore,
              asyncListState: asyncListState,
            ),
          );
        }

        // 取得済みのデータがない（初回読み込みが失敗した）場合を想定したエラー表示
        return Padding(
          padding: REdgeInsets.only(top: 32),
          child: Center(
            child: ErrorAndRetryWidget(
              onRetry: () => ref.invalidate(listStateNotifierProvider),
            ),
          ),
        );
      },
      // 初回読み込み時
      loading: () {
        return ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shimmerTileNumber,
          itemBuilder: (context, index) {
            return shimmerTile;
          },
        );
      },
    );
  }
}

/// [ListState] を無限スクロールで表示するWidget
///
/// スワイプリフレッシュ, ListView,
/// ListViewの一番下に表示するWidget ([bottomWidget]) を内包している
class _StateScrollBar extends StatelessWidget {
  const _StateScrollBar({
    required this.globalKey,
    required this.scrollController,
    required this.onRefresh,
    required this.asyncListState,
    required this.tileBuilder,
    required this.bottomWidget,
  });

  final GlobalKey globalKey;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final AsyncValue<ListState?> asyncListState;
  final Widget Function(dynamic item) tileBuilder;
  final Widget bottomWidget;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      key: globalKey,
      controller: scrollController,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(
            builder: buildCustomRefreshIndicator,
            onRefresh: onRefresh,
          ),
          SliverToBoxAdapter(
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: asyncListState.value!.list.length,
              itemBuilder: (context, index) {
                return tileBuilder(asyncListState.value!.list[index]);
              },
            ),
          ),
          SliverPadding(
            padding: REdgeInsets.only(top: 8, bottom: 40),
            sliver: SliverToBoxAdapter(
              child: bottomWidget,
            ),
          ),
        ],
      ),
    );
  }
}

/// 無限スクロールにて、エラー発生時にListの下部に表示させるWidget
class _BottomWidgetWhenError extends StatelessWidget {
  const _BottomWidgetWhenError({
    required this.fetchMore,
    required this.asyncListState,
  });

  /// 再読み込みで行う処理
  ///
  /// 無限スクロールの追加読み込みでエラーが発生した場合に、
  /// 再読み込みとして行う処理のため、fetchMore（追加読み込み）を想定している
  final VoidCallback fetchMore;
  final AsyncValue<ListState?> asyncListState;

  @override
  Widget build(BuildContext context) {
    return asyncListState.value!.hasMore
        ? Center(
            child: InkWell(
              onTap: fetchMore,
              child: Column(
                children: [
                  asyncListState.isRefreshing
                      ? const CupertinoActivityIndicator()
                      : Icon(
                          CupertinoIcons.exclamationmark_circle_fill,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  SizedBox(height: 4.h),
                  asyncListState.isRefreshing
                      ? Text(
                          '読み込み中...',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        )
                      : Text(
                          'タップで再読み込み',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
