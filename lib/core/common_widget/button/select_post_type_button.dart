import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

class SelectPostTypeButton extends StatelessWidget {
  const SelectPostTypeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: InkWell(
        onTap: () async {
          // IconButtonの位置を取得
          final box =
              globalKey.currentContext?.findRenderObject() as RenderBox?;
          final position =
              box!.localToGlobal(Offset.zero) & const Size(200, 40);

          if (!context.mounted) {
            return;
          }

          await showPullDownMenu(
            context: context,
            position: position,
            items: [
              PullDownMenuItem(
                onTap: () {
                  // TODO(me): 定義編集画面へ遷移させる
                },
                title: '全体に公開',
                icon: CupertinoIcons.person_3,
              ),
              PullDownMenuItem(
                onTap: () {
                  // TODO(me): 定義編集画面へ遷移させる
                },
                title: '非公開',
                icon: CupertinoIcons.lock_fill,
              ),
            ],
          );
        },
        child: Row(
          key: globalKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.person_3,
              color: Theme.of(context).colorScheme.onSurface,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              '全体に公開',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.arrowtriangle_down_fill,
              color: Theme.of(context).colorScheme.onSurface,
              size: 8,
            ),
          ],
        ),
      ),
    );
  }
}
