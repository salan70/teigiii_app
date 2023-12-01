import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../util/constant/initial_main_group.dart';
import '../util/dictionary_page_type.dart';
import 'index_tile.dart';

class InitialMainGroupList extends StatelessWidget {
  const InitialMainGroupList({
    super.key,
    required this.dictionaryPageType,
    required this.targetUserId,
  });

  final DictionaryPageType dictionaryPageType;

  /// [dictionaryPageType]が[DictionaryPageType.everyone]の場合、nullを渡す。
  /// [DictionaryPageType.individual]の場合、表示対象のユーザーidを渡す
  final String? targetUserId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: InitialMainGroup.values.length,
      itemBuilder: (BuildContext context, int index) {
        final initialMainGroup = InitialMainGroup.values[index];
        return InkWell(
          onTap: () async {
            await context.pushRoute(
              InitialSubGroupIndexRoute(
                selectedInitialMainGroup: initialMainGroup,
                dictionaryPageType: dictionaryPageType,
                targetUserId: targetUserId,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IndexTile(label: initialMainGroup.label),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
