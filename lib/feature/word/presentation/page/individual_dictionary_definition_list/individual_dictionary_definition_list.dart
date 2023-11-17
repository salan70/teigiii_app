import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/post_definition_fab.dart';
import '../../../../../util/constant/initial_main_group.dart';
import '../../../../../util/extension/scroll_controller_extension.dart';
import '../../../../definition/presentation/component/definition_list.dart';
import '../../../../definition/util/definition_feed_type.dart';
import '../../component/dictionary_author_widget.dart';

@RoutePage()
class IndividualDictionaryDefinitionListPage extends ConsumerWidget {
  const IndividualDictionaryDefinitionListPage({
    super.key,
    required this.targetUserId,
    required this.initialSubGroup,
  });

  final String targetUserId;
  final InitialSubGroup initialSubGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool _) {
          return <Widget>[
            SliverAppBar(
              forceElevated: true,
              pinned: true,
              title: InkWell(
                child: Text(initialSubGroup.label),
                onTap: () => PrimaryScrollController.of(context).scrollToTop(),
              ),
              flexibleSpace: InkWell(
                onTap: () => PrimaryScrollController.of(context).scrollToTop(),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            const SizedBox(height: 16),
            DictionaryAuthorWidget(targetUserId: targetUserId),
            Expanded(
              child: DefinitionList(
                definitionFeedType: DefinitionFeedType.individualIndex,
                targetUserId: targetUserId,
                initialSubGroup: initialSubGroup,
                shimmerTileNumber: 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const PostDefinitionFAB(),
    );
  }
}
