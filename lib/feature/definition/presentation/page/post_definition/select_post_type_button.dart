import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../../application/definition_for_write_notifier.dart';
import '../../../util/definition_post_type.dart';

class SelectPostTypeButton extends ConsumerWidget {
  const SelectPostTypeButton({super.key, required this.definitionId});

  final String? definitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinitionForWrite =
        ref.watch(definitionForWriteNotifierProvider(definitionId));
    final globalKey = GlobalKey();

    return asyncDefinitionForWrite.maybeWhen(
      data: (definitionForWrite) {
        final postType = definitionForWrite.isPublic
            ? DefinitionPostType.public
            : DefinitionPostType.private;

        final definitionForWriteNotifier = ref
            .watch(definitionForWriteNotifierProvider(definitionId).notifier);

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
                      definitionForWriteNotifier.changePublicState(
                        isPublic: true,
                      );
                    },
                    title: DefinitionPostType.public.label,
                    icon: DefinitionPostType.public.icon,
                  ),
                  PullDownMenuItem(
                    onTap: () {
                      definitionForWriteNotifier.changePublicState(
                        isPublic: false,
                      );
                    },
                    title: DefinitionPostType.private.label,
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
                  size: postType.lergeIconSize,
                ),
                const SizedBox(width: 8),
                Text(
                  postType.label,
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
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
