import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../feature/definition_list/presentation/definition_list.dart';
import '../../feature/definition_list/util/definition_feed_type.dart';
import '../common_widget/simple_empty_widget.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#12-公開プロフィール
@RoutePage()
class LikedDefinitionListPage extends StatelessWidget {
  const LikedDefinitionListPage({super.key, required this.targetUserId});

  final String targetUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('いいねした投稿')),
      body: DefinitionList(
        definitionFeedType: DefinitionFeedType.profileLiked,
        targetUserId: targetUserId,
        emptyWidget: const SimpleEmptyWidget(message: 'いいねした投稿がありません。'),
      ),
    );
  }
}
