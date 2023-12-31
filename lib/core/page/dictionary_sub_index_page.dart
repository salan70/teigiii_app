import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/user_profile/presentation/dictionary_author_widget.dart';
import '../../feature/word/presentation/index_tile.dart';
import '../../feature/word/util/dictionary_page_type.dart';
import '../../util/constant/initial_main_group.dart';
import '../router/app_router.dart';

@RoutePage()
class DictionarySubIndexPage extends ConsumerWidget {
  const DictionarySubIndexPage({
    super.key,
    required this.selectedInitialMainGroup,
    required this.dictionaryPageType,
    required this.targetUserId,
  });

  final InitialMainGroup selectedInitialMainGroup;
  final DictionaryPageType dictionaryPageType;

  /// [dictionaryPageType] が [DictionaryPageType.everyone] の場合、nullを渡す。
  /// [DictionaryPageType.individual] の場合、表示対象のユーザーidを渡す。
  final String? targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialSubGroups = initialMapping[selectedInitialMainGroup]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedInitialMainGroup.label),
        leading: const BackButton(),
      ),
      body: ListView(
        children: [
          dictionaryPageType == DictionaryPageType.individual
              ? Column(
                  children: [
                    const Gap(16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child:
                          DictionaryAuthorWidget(targetUserId: targetUserId!),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: initialSubGroups.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    switch (dictionaryPageType) {
                      case DictionaryPageType.everyone:
                        context.pushRoute(
                          WordListRoute(
                            selectedInitialSubGroup: initialSubGroups[index],
                          ),
                        );
                        return;
                      case DictionaryPageType.individual:
                        context.pushRoute(
                          IndividualDictionaryDefinitionListRoute(
                            targetUserId: targetUserId!,
                            initialSubGroup: initialSubGroups[index],
                          ),
                        );
                        return;
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IndexTile(label: initialSubGroups[index].label),
                      const Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
