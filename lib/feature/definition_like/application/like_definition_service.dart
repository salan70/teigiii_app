import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_state.dart';
import '../../definition/application/definition_state.dart';
import '../../definition/domain/definition.dart';
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

    // いいね登録/解除した Definition を保持する Provider を再生成する。
    ref.invalidate(definitionProvider(definition.id));
  }

  /// いいね登録/解除を行う。
  Future<void> _updateLikeStatus(Definition definition) async {
    final userId = ref.read(userIdProvider)!;

    if (definition.isLikedByUser) {
      // いいね解除
      await ref.read(likeDefinitionRepositoryProvider).unlikeDefinition(
            definition.id,
            userId,
          );
      return;
    }

    // いいね登録
    await ref.read(likeDefinitionRepositoryProvider).likeDefinition(
          definition.id,
          userId,
        );
  }
}
