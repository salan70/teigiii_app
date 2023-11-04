import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/select_post_type_button.dart';
import '../../../application/definition_for_write_notifier.dart';

@RoutePage()
class PostDefinitionPage extends ConsumerWidget {
  const PostDefinitionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDefinitionForWrite =
        ref.watch(definitionForWriteNotifierProvider(null));
    final definitionForWriteNotifier =
        ref.watch(definitionForWriteNotifierProvider(null).notifier);

    return asyncDefinitionForWrite.when(
      data: (definitionForWrite) {
        final canPost = definitionForWrite.canPost();
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const SelectPostTypeButton(),
            actions: [
              Center(
                child: InkWell(
                  onTap: canPost
                      ? () async {
                          await definitionForWriteNotifier.post();
                        }
                      : null,
                  child: Text(
                    '投稿',
                    style: canPost
                        ? Theme.of(context).textTheme.titleLarge
                        : Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.3),
                            ),
                  ),
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
                      onChanged: definitionForWriteNotifier.changeWord,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                        hintText: '例: 二日目のカレー',
                        labelText: '投稿する言葉',
                        errorText: definitionForWrite.outputWordError(),
                        border: InputBorder.none,
                      ),
                    ),
                    TextField(
                      maxLength: 50,
                      maxLines: null,
                      textInputAction: TextInputAction.next,
                      onChanged: definitionForWriteNotifier.changeWordReading,
                      style: Theme.of(context).textTheme.titleMedium,
                      decoration: InputDecoration(
                        hintText: '例: ふつかめのかれー',
                        labelText: '言葉のよみ',
                        errorText: definitionForWrite.outputWordReadingError(),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      maxLength: 500,
                      maxLines: null,
                      onChanged: definitionForWriteNotifier.changeDefinition,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        hintText: '例: ばり美味い',
                        labelText: '定義',
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
      },
      loading: () => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const SelectPostTypeButton(),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const SelectPostTypeButton(),
        ),
        body: Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}
