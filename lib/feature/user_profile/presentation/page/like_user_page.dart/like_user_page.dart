import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/simple_widget_for_empty.dart';
import '../../../../../util/extension/scroll_controller_extension.dart';
import '../../../util/user_list_type.dart';
import '../../component/profile_list.dart';

@RoutePage()
class LikeUserPage extends ConsumerWidget {
  const LikeUserPage({
    super.key,
    required this.definitionId,
  });
  final String definitionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool _) {
            return [
              SliverAppBar(
                pinned: true,
                title: InkWell(
                  child: const Text('いいね！したユーザー'),
                  onTap: () =>
                      PrimaryScrollController.of(context).scrollToTop(),
                ),
                leading: const BackButton(),
                flexibleSpace: InkWell(
                  onTap: () =>
                      PrimaryScrollController.of(context).scrollToTop(),
                ),
              ),
            ];
          },
          body: ProfileList(
            userListType: UserListType.liked,
            targetUserId: null,
            targetDefinitionId: definitionId,
            // いいねが0件の場合、[LikeUserPage] には遷移しない想定だが念のため設定しておく
            emptyWidget: const SimpleWidgetForEmpty(
              message: 'まだいいね！されていません',
            ),
          ),
        ),
      ),
    );
  }
}
