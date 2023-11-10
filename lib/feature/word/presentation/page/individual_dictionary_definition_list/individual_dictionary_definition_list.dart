import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../util/constant/initial_main_group.dart';
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
      appBar: AppBar(
        title: Text(initialSubGroup.label),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          DictionaryAuthorWidget(targetUserId: targetUserId),
          const SizedBox(height: 24),
          Expanded(
            child: DefinitionList(
              definitionFeedType: DefinitionFeedType.individualIndex,
              targetUserId: targetUserId,
              initialSubGroup: initialSubGroup,
            ),
          ),
        ],
      ),
    );
  }
}
