import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

class ShowPullDownIconButton extends StatelessWidget {
  const ShowPullDownIconButton({
    super.key,
    required this.icon,
    required this.items,
  });

  final IconData icon;
  final List<PullDownMenuEntry> items;

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey();

    return IconButton(
      key: globalKey,
      icon: Icon(icon),
      onPressed: () async {
        // IconButtonの位置を取得
        final box = globalKey.currentContext?.findRenderObject() as RenderBox?;
        final position = box!.localToGlobal(Offset.zero) & const Size(40, 48);

        if (!context.mounted) {
          return;
        }

        await showPullDownMenu(
          context: context,
          position: position,
          items: items,
        );
      },
    );
  }
}
