import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widget/cupertino_refresh_indicator.dart';
import '../../../core/common_widget/error_and_retry_widget.dart';
import '../../../util/interface/list_state.dart';
import '../../../util/logger.dart';
import '../../feature/admob/presentation/banner_ad_widget.dart';

class InfinityScrollWidget extends ConsumerWidget {
  InfinityScrollWidget({
    super.key,
    required this.listStateNotifierProvider,
    required this.fetchMore,
    required this.tileBuilder,
    required this.contentPadding,
    required this.shimmerTile,
    required this.shimmerTileNumber,
    required this.emptyWidget,
    this.showBannerAd = false,
  });

  /// 扱う state ([ListState]型)を保持する Provider。
  final AsyncNotifierProvider<dynamic, ListState> listStateNotifierProvider;
  final VoidCallback fetchMore;

  /// [ListState] の中身（tile）を作成するための関数。
  final Widget Function(dynamic item) tileBuilder;

  /// [tileBuilder] で作成した tile を表示する ListView の padding。
  final EdgeInsetsGeometry contentPadding;

  /// 初回読み込み時に表示させる Shimmer。
  final Widget shimmerTile;

  /// [shimmerTile] を表示させる数。
  final int shimmerTileNumber;

  /// 扱う state ([ListState]型) の中身が空の場合に表示させる Widget。
  final Widget? emptyWidget;

  /// バナー広告を表示させるかどうか。
  ///
  /// true の場合、 [tileBuilder] で作成した tile 7件ごとにバナー広告を表示させる。
  final bool showBannerAd;

  final scrollController = ScrollController();
  // エラーが発生してリビルドした際、スクロール位置を保持するためのキー。
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
            contentPadding: contentPadding,
            bottomWidget: listState.hasMore
                ? const Column(
                    children: [
                      CupertinoActivityIndicator(),
                      SizedBox(height: 40),
                    ],
                  )
                : const SizedBox(),
            emptyWidget: emptyWidget,
            showBannerAd: showBannerAd,
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
            contentPadding: contentPadding,
            bottomWidget: _BottomWidgetWhenError(
              fetchMore: fetchMore,
              asyncListState: asyncListState,
            ),
            emptyWidget: emptyWidget,
            showBannerAd: showBannerAd,
          );
        }

        // 取得済みのデータがない（初回読み込みが失敗した）場合を想定したエラー表示
        return Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Center(
            child: ErrorAndRetryWidget(
              onRetry: () => ref.invalidate(listStateNotifierProvider),
            ),
          ),
        );
      },
      // 初回読み込み時
      loading: () {
        return Padding(
          padding: contentPadding,
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: shimmerTileNumber,
            itemBuilder: (context, index) {
              return shimmerTile;
            },
          ),
        );
      },
    );
  }
}

/// [ListState] を無限スクロールで表示するWidget。
///
/// スワイプリフレッシュ, ListView , ListView の一番下に表示する Widget ([bottomWidget]) 
/// を内包している。
class _StateScrollBar extends StatelessWidget {
  const _StateScrollBar({
    required this.globalKey,
    required this.scrollController,
    required this.onRefresh,
    required this.asyncListState,
    required this.tileBuilder,
    required this.contentPadding,
    required this.bottomWidget,
    required this.emptyWidget,
    required this.showBannerAd,
  });

  final GlobalKey globalKey;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;
  final AsyncValue<ListState?> asyncListState;
  final Widget Function(dynamic item) tileBuilder;
  final EdgeInsetsGeometry contentPadding;
  final Widget bottomWidget;
  final Widget? emptyWidget;

  /// バナー広告を表示させるかどうか。
  final bool showBannerAd;

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
          SliverPadding(
            padding: contentPadding,
            sliver: SliverToBoxAdapter(
              child: asyncListState.value!.list.isEmpty
                  ? emptyWidget ?? const SizedBox.shrink()
                  : ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: asyncListState.value!.list.length,
                      itemBuilder: (context, index) {
                        // バナー広告を表示させる場合
                        if (showBannerAd) {
                          return Column(
                            children: [
                              // 7件ごとにバナー広告を表示させる
                              (index % 7 == 0 && index != 0)
                                  ? const _BannerAdTile()
                                  : const SizedBox.shrink(),
                              tileBuilder(asyncListState.value!.list[index]),
                            ],
                          );
                        }

                        // バナー広告を表示させない場合
                        return tileBuilder(asyncListState.value!.list[index]);
                      },
                    ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 8, bottom: 40),
            sliver: SliverToBoxAdapter(
              child: bottomWidget,
            ),
          ),
        ],
      ),
    );
  }
}

/// 無限スクロールにて、エラー発生時にListの下部に表示させる Widget
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
                  const SizedBox(height: 4),
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

/// 無限スクロールにて、表示させるバナー広告
class _BannerAdTile extends StatelessWidget {
  const _BannerAdTile();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 64,
          width: double.infinity,
          color: Theme.of(context).colorScheme.surface,
          child: const BannerAdWidget(),
        ),
        const Divider(),
      ],
    );
  }
}
