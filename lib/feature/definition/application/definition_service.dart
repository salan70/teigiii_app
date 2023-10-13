import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/common_provider.dart';
import '../domain/definition.dart';
import '../repository/definition_repository.dart';
import '../util/definition_feed_type.dart';
import 'definition_state.dart';

part 'definition_service.g.dart';

@riverpod
class DefinitionService extends _$DefinitionService {
  @override
  FutureOr<void> build() {}

  /// いいねをタップした際の処理
  Future<void> tapLike(Definition definition) async {
    // 二度押し防止とUX向上のため、オーバーレイローディングを表示させる
    // そのため、state = AsyncLoadingをしない
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier)..startLoading();

    state = await AsyncValue.guard(() async {
      await _updateLikeStatus(definition);
    });

    // いいね登録/解除したDefinitionを保持するProviderを再生成
    ref.invalidate(definitionProvider(definition.id));

    isLoadingOverlayNotifier.finishLoading();
  }

  /// definitionIdListProviderと全てのdefinitionProviderを再生成する
  Future<void> refreshAll(DefinitionFeedType definitionFeedType) async {
    await _invalidateAllDefinitionFamilies();

    ref.invalidate(definitionIdListProvider(definitionFeedType));
    await ref.read(definitionIdListProvider(definitionFeedType).future);
  }

  /// 全てのdefinitionProviderを再生成する
  ///
  /// 同じタイミングでdefinitionIdListProviderも再生成する場合、
  /// この関数を実行してから、definitionIdListProviderを再生成すること
  ///
  /// そうしない場合、definitionIdListProvider生成時にあって、再生成時にない
  /// definitionProviderは再生成されないと思われる
  Future<void> _invalidateAllDefinitionFamilies() async {
    for (final feedType in DefinitionFeedType.values) {
      final definitionIdList =
          await ref.read(definitionIdListProvider(feedType).future);

      for (final definitionId in definitionIdList) {
        ref.invalidate(definitionProvider(definitionId));
      }
    }
  }

  /// いいね登録/解除を行う
  Future<void> _updateLikeStatus(Definition definition) async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const userId = 'xE9Je2LljHXIPORKyDnk';

    if (definition.isLikedByUser) {
      // いいね解除
      await ref.read(definitionRepositoryProvider).unlikeDefinition(
            definition.id,
            userId,
          );
      return;
    }

    // いいね登録
    await ref.read(definitionRepositoryProvider).likeDefinition(
          definition.id,
          userId,
        );
  }
}
