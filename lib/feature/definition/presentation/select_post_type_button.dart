import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../application/definition_for_write_notifier.dart';
import '../domain/definition_for_write.dart';
import '../util/definition_post_type.dart';

class SelectPostTypeButton extends ConsumerWidget {
  SelectPostTypeButton({
    super.key,
    required this.definitionForWrite,
    required this.notifier,
  });

  final DefinitionForWrite definitionForWrite;
  final DefinitionForWriteNotifier notifier;
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postType = definitionForWrite.isPublic
        ? DefinitionPostType.public
        : DefinitionPostType.private;

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
                  notifier.changePublicState(
                    isPublic: true,
                  );
                },
                title: DefinitionPostType.public.labelForWrite,
                icon: DefinitionPostType.public.icon,
              ),
              PullDownMenuItem(
                onTap: () {
                  notifier.changePublicState(
                    isPublic: false,
                  );
                },
                title: DefinitionPostType.private.labelForWrite,
                icon: DefinitionPostType.private.icon,
              ),
            ],
          );
        },
        child: Row(
          key: globalKey,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              postType.icon,
              color: Theme.of(context).colorScheme.onSurface,
              size: postType.largeIconSize,
            ),
            const Gap(8),
            Text(
              postType.labelForWrite,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(8),
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
