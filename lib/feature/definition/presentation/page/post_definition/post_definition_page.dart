import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/select_post_type_button.dart';

@RoutePage()
class PostDefinitionPage extends ConsumerWidget {
  const PostDefinitionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: InkWell(
          onTap: () {},
          child: const SelectPostTypeButton(),
        ),
        actions: [
          Center(
            child: Text(
              '投稿',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: GestureDetector(
        onTap: () => primaryFocus?.unfocus(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                const SizedBox(height: 8),
                TextField(
                  autofocus: true,
                  maxLength: 30,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    hintText: '例: 二日目のカレー',
                    label: Text('投稿する言葉'),
                    border: InputBorder.none,
                  ),
                ),
                TextField(
                  maxLength: 50,
                  maxLines: null,
                  textInputAction: TextInputAction.next,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: const InputDecoration(
                    hintText: '例: ふつかめのかれー',
                    label: Text('言葉のよみ'),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLength: 500,
                  maxLines: null,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    hintText: '例: ばり美味い',
                    label: Text('定義'),
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
