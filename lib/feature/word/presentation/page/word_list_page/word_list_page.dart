import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../application/word_list_state.dart';
import '../../../util/initial_main_group.dart';
import 'word_tile.dart';

@RoutePage()
class WordListPage extends ConsumerWidget {
  const WordListPage({
    super.key,
    required this.selectedInitialSubGroup,
  });

  final InitialSubGroup selectedInitialSubGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWordListState = ref.watch(
      wordListStateNotifierProvider(selectedInitialSubGroup.label),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedInitialSubGroup.label),
        leading: const BackIconButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: asyncWordListState.when(
          data: (wordListState) {
            final wordList = wordListState.wordList;
            return ListView.builder(
              itemCount: wordList.length,
              itemBuilder: (context, index) {
                return WordTile(word: wordList[index]);
              },
            );
          },
          loading: () {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          },
        ),
      ),
    );
  }
}
