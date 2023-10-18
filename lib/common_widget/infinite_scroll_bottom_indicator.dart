import 'package:flutter/cupertino.dart';

/// 無限スクロールの一番下に表示するインジケータ
///
/// [hasMore]がtrueの場合、インジケータを表示する
class InfiniteScrollBottomIndicator extends StatelessWidget {
  const InfiniteScrollBottomIndicator({
    super.key,
    required this.hasMore,
  });

  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 40),
      sliver: SliverToBoxAdapter(
        child: hasMore
            ? const CupertinoActivityIndicator()
            : const SizedBox.shrink(),
      ),
    );
  }
}
