import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../definition/application/definition_state.dart';
import '../../definition/domain/definition.dart';
import '../../definition_list/appication/definition_id_list_state.dart';
import '../../definition_list/util/definition_feed_type.dart';
import '../../user_list/application/user_id_list_state_notifier.dart';
import '../../user_list/util/user_list_type.dart';
import '../repository/like_definition_repository.dart';

part 'like_definition_service.g.dart';

@riverpod
LikeDefinitionService likeDefinitionService(LikeDefinitionServiceRef ref) =>
    LikeDefinitionService(ref);

class LikeDefinitionService {
  LikeDefinitionService(this.ref);

  final Ref ref;

  /// いいねをタップした際の処理。
  Future<void> tapLike(Definition definition) async {
    await _updateLikeStatus(definition);

    final currentUserId = ref.read(userIdProvider)!;
    ref
      ..invalidate(definitionProvider(definition.id))
      ..invalidate(
        definitionIdListStateNotifierProvider(
          DefinitionFeedType.profileLiked,
          targetUserId: currentUserId,
        ),
      )
      ..invalidate(
        definitionIdListStateNotifierProvider(
          DefinitionFeedType.wordOthersReactions,
          wordId: definition.wordId,
        ),
      )
      ..invalidate(
        userIdListStateNotifierProvider(
          UserListType.liked,
          targetUserId: null,
          targetDefinitionId: definition.id,
        ),
      );
  }

  /// いいね登録/解除を行う。
  Future<void> _updateLikeStatus(Definition definition) async {
    if (definition.isLikedByUser) {
      // いいね解除
      await ref
          .read(likeDefinitionRepositoryProvider)
          .unlikeDefinition(definition.id);
      return;
    }

    // いいね登録
    await ref
        .read(likeDefinitionRepositoryProvider)
        .likeDefinition(definition.id);
  }
}
