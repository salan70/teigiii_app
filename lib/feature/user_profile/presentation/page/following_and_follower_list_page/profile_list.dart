import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../util/logger.dart';
import '../../../../definition/presentation/component/definition_tile_shimmer.dart';
import '../../../application/user_id_list_state.dart';
import '../../../util/profile_feed_type.dart';
import 'profile_tile.dart';

class ProfileList extends ConsumerWidget {
  ProfileList({
    super.key,
    required this.userListType,
    required this.targetUserId,
  });

  final String targetUserId;

  final UserListType userListType;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserIdListState =
        ref.watch(UserIdListStateNotifierProvider(userListType, targetUserId));

    return asyncUserIdListState.when(
      data: (userIdListState) {
        final userIdList = userIdListState.userIdList;

        return SingleChildScrollView(
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userIdList.length,
            itemBuilder: (context, index) {
              return ProfileTile(
                targetUserId: userIdList[index],
              );
            },
          ),
        );
      },
      error: (error, _) {
        logger.e('$error');

        // 取得済みのデータがない（初回読み込みが失敗した）場合のエラー表示
        // TODO(me): エラー画面を表示させる
        return Center(
          child: Text(
            error.toString(),
          ),
        );
      },
      loading: () {
        return ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var i = 0; i < 4; i++) const DefinitionTileShimmer(),
          ],
        );
      },
    );
  }
}
