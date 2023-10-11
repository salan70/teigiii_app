import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../util/common_provider.dart';
import '../../user/repository/user_repository.dart';
import '../../word/repository/word_repository.dart';
import '../domain/definition.dart';
import '../repository/definition_repository.dart';
import '../repository/entity/definition_document.dart';
import '../util/definition_feed_type.dart';

part 'definition_list_notifier.g.dart';

@Riverpod(keepAlive: true)
class DefinitionListNotifier extends _$DefinitionListNotifier {
  @override
  FutureOr<List<Definition>> build(
    DefinitionFeedType definitionFeedType,
  ) async {
    switch (definitionFeedType) {
      case DefinitionFeedType.homeRecommend:
        return _fetchHomeRecommendDefinitionList();
      case DefinitionFeedType.homeFollowing:
        return _fetchHomeFollowingDefinitionList();
    }
  }

  /// ミュートしていないユーザーと
  /// 自分が投稿した公開中のDefinitionを取得する
  Future<List<Definition>> _fetchHomeRecommendDefinitionList() async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const currentUserId = 'xE9Je2LljHXIPORKyDnk';
    final mutedUserIdList = await _fetchMutedUserIdList(currentUserId);

    final definitionDocList = await ref
        .read(definitionRepositoryProvider)
        .fetchHomeRecommendDefinitionList(
          definitionFeedType,
          mutedUserIdList,
        );

    return _fetchDefinitionList(currentUserId, definitionDocList);
  }

  /// フォローしている、かつミュートしていないユーザーと
  /// 自分が投稿した公開中のDefinitionを取得する
  Future<List<Definition>> _fetchHomeFollowingDefinitionList() async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const currentUserId = 'xE9Je2LljHXIPORKyDnk';
    final targetUserIdList = await _fetchHomeFollowingUserIdList(currentUserId);

    final definitionDocList = await ref
        .read(definitionRepositoryProvider)
        .fetchHomeFollowingDefinitionList(
          definitionFeedType,
          targetUserIdList,
        );
    return _fetchDefinitionList(currentUserId, definitionDocList);
  }

  /// いいねをタップした際の処理
  Future<void> tapLike(Definition definition) async {
    // 二度押しの防止とUX向上のため、オーバーレイローディングを表示させる
    // そのため、stateをAsyncLoadingにしない
    final isLoadingOverlayNotifier =
        ref.read(isLoadingOverlayNotifierProvider.notifier);
    await isLoadingOverlayNotifier.startLoading();

    late List<Definition> updatedDefinitionList;
    if (definition.isLikedByUser) {
      // いいねを解除
      updatedDefinitionList = await _unlikeDefinition(definition);
    } else {
      // いいねを登録
      updatedDefinitionList = await _likeDefinition(definition);
    }

    await isLoadingOverlayNotifier.finishLoading();

    // stateへ反映させる値は、クライアント側で設定する（repositoryを使用しない）
    state = AsyncValue.data(updatedDefinitionList);
  }

  /// いいねを登録する
  ///
  /// いいねを登録後、stateの値を修正したリストを返す
  Future<List<Definition>> _likeDefinition(Definition definition) async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const userId = 'xE9Je2LljHXIPORKyDnk';
    // データを更新
    await ref.read(definitionRepositoryProvider).likeDefinition(
          definition.id,
          userId,
        );

    // stateの値を用いて、データ更新後の値に対応するListを作成する
    final index = state.value!.indexWhere(
      (currentDefinition) => currentDefinition.id == definition.id,
    );
    final updatedDefinition = state.value![index].copyWith(
      likesCount: state.value![index].likesCount + 1,
      isLikedByUser: true,
    );

    final updatedList = List<Definition>.from(state.value!);
    updatedList[index] = updatedDefinition;

    return updatedList;
  }

  /// いいねを解除する
  ///
  /// いいねを解除後、stateの値を修正したリストを返す
  Future<List<Definition>> _unlikeDefinition(Definition definition) async {
    // TODO(me): auth系の実装したらFirebaseからuserIdを取得する
    const userId = 'xE9Je2LljHXIPORKyDnk';
    // データを更新
    await ref.read(definitionRepositoryProvider).unlikeDefinition(
          definition.id,
          userId,
        );

    // stateの値を用いて、データ更新後の値に対応するListを作成する
    final index = state.value!.indexWhere(
      (currentDefinition) => currentDefinition.id == definition.id,
    );
    final updatedDefinition = state.value![index].copyWith(
      likesCount: state.value![index].likesCount - 1,
      isLikedByUser: false,
    );

    final updatedList = List<Definition>.from(state.value!);
    updatedList[index] = updatedDefinition;

    return updatedList;
  }

  Future<List<String>> _fetchHomeFollowingUserIdList(
    String currentUserId,
  ) async {
    final followingTabUserIdList = <String>[];

    // フォローしているユーザーのIDリストを取得
    final followingIdList = await ref
        .read(userRepositoryProvider)
        .fetchFollowingIdList(currentUserId);

    // フォローしているユーザーと自分のIDを追加
    followingTabUserIdList
      ..addAll(followingIdList)
      ..add(currentUserId);

    // ミュートしているユーザーIDを除外
    final mutedUserIdList = await _fetchMutedUserIdList(currentUserId);
    followingTabUserIdList.removeWhere(mutedUserIdList.contains);

    return followingTabUserIdList;
  }

  Future<List<String>> _fetchMutedUserIdList(String currentUserId) async {
    final currentUserDoc =
        await ref.read(userRepositoryProvider).fetchUser(currentUserId);

    return currentUserDoc.mutedUserIdList;
  }

  Future<List<Definition>> _fetchDefinitionList(
    String currentUserId,
    List<DefinitionDocument> definitionDocList,
  ) async {
    final definitionList = <Definition>[];
    for (final definitionDoc in definitionDocList) {
      final definition = await _fetchDefinitionByDoc(
        currentUserId,
        definitionDoc,
      );
      definitionList.add(definition);
    }

    return definitionList;
  }

  /// DefinitionDocumentからDefinitionを取得する
  Future<Definition> _fetchDefinitionByDoc(
    String currentUserId,
    DefinitionDocument definitionDoc,
  ) async {
    final wordDoc =
        await ref.read(wordRepositoryProvider).fetchWord(definitionDoc.wordId);

    final authorDoc = await ref
        .read(userRepositoryProvider)
        .fetchUser(definitionDoc.authorId);

    final isLikedByUser = await ref
        .read(definitionRepositoryProvider)
        .isLikedByUser(currentUserId, definitionDoc.id);

    // TODO(me): DefinitionクラスにfromDocuments的な関数作りたい
    return Definition(
      id: definitionDoc.id,
      wordId: wordDoc.id,
      authorId: authorDoc.id,
      word: wordDoc.word,
      definition: definitionDoc.content,
      updatedAt: definitionDoc.updatedAt,
      authorName: authorDoc.name,
      authorImageUrl: authorDoc.profileImageUrl,
      likesCount: definitionDoc.likesCount,
      isLikedByUser: isLikedByUser,
    );
  }
}
