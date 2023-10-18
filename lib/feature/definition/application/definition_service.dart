import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/common_provider.dart';
import '../../../util/snack_bar.dart';
import '../domain/definition.dart';
import '../domain/definition_id_list_state.dart';
import '../repository/definition_repository.dart';
import '../util/definition_feed_type.dart';
import 'definition_id_list_state.dart';
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

    try {
      await _updateLikeStatus(definition);
    } on Exception catch (e) {
      debugPrint('error: $e');
      ref
          .read(snackBarControllerProvider.notifier)
          .showSnackBar('失敗しました。もう一度お試しください。');

      isLoadingOverlayNotifier.finishLoading();
      // 例外が発生したことをpresentationに伝えるため、rethrowする
      rethrow;
    }

    // いいね登録/解除したDefinitionを保持するProviderを再生成
    ref.invalidate(definitionProvider(definition.id));
    isLoadingOverlayNotifier.finishLoading();
  }

  /// definitionIdListProviderと全てのdefinitionProviderを再生成する
  Future<void> refreshAll(DefinitionFeedType definitionFeedType) async {
    await _invalidateAllDefinitionFamilies();

    ref.invalidate(DefinitionIdListStateNotifierProvider(definitionFeedType));
    await ref
        .read(DefinitionIdListStateNotifierProvider(definitionFeedType).future);
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
      final asyncDefinitionIdListState =
          ref.read(DefinitionIdListStateNotifierProvider(feedType));

      late final DefinitionIdListState definitionIdListState;

      // エラーが発生している場合、「ref.read(Provider).future」時にエラーになるため、
      // エラーが発生しているかどうかで分岐させている

      // エラーが発生している場合
      if (asyncDefinitionIdListState.hasError) {
        definitionIdListState = asyncDefinitionIdListState.value!;
      }
      // エラーが発生していない場合
      else {
        definitionIdListState = await ref
            .read(DefinitionIdListStateNotifierProvider(feedType).future);
      }

      for (final definitionId in definitionIdListState.definitionIdList) {
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
