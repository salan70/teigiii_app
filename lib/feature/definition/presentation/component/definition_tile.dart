import 'package:flutter/material.dart';

import '../../domain/definition.dart';

class DefinitionTile extends StatelessWidget {
  const DefinitionTile({
    super.key,
    required this.definition,
  });

  final Definition definition;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // TODO(me): プロフィール画像を表示する
        Container(),
        Column(
          children: [
            Row(
              children: [
                Text(definition.authorName),
                // TODO(me): 投稿が何分前にされたかを表示する（DateTimeのextension使うのが良さげ）
                Text(definition.updatedAt.toString()),
              ],
            ),
            Text(definition.word),
            Text(definition.definition),
            Row(
              children: [
                // TODO(me): タップでいいねの登録/解除する
                const Icon(Icons.favorite),
                Text(definition.likesCount.toString()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
