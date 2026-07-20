import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../feature/definition_list/presentation/definition_list.dart';
import '../../feature/definition_list/util/definition_feed_type.dart';
import '../../feature/user_profile/application/user_profile_state.dart';
import '../../feature/word/application/word_state.dart';
import '../../feature/word/presentation/word_edit_dialog.dart';
import '../../feature/word/presentation/word_my_definitions_preview.dart';
import '../../feature/word/presentation/word_page_shimmer.dart';
import '../../feature/word/presentation/word_widget.dart';
import '../../util/constant/url.dart';
import '../../util/extension/scroll_controller_extension.dart';
import '../../util/logger.dart';
import '../common_provider/launch_url_controller.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../common_widget/stickey_tab_bar_deligate.dart';

@RoutePage()
/// @doc doc/specs/mobile-app-functional-spec.md#8-言葉ページ
class WordTopPage extends ConsumerWidget {
  const WordTopPage({super.key, required this.wordId});

  final String wordId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncWord = ref.watch(wordProvider(wordId));

    return DefaultTabController(
      length: 2,
      child: asyncWord.when(
        data: (word) {
          if (word == null) {
            // * 該当するWordがない場合
            // [WordTopPage] から [DefinitionDetailPage] に遷移し、投稿削除/編集して
            // 戻ってきた場合にnullになる想定
            return Scaffold(
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_circle_fill,
                      color: Theme.of(context).colorScheme.error,
                      size: 24,
                    ),
                    const Gap(16),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        '対象の語句が見つかりませんでした。',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Gap(8),
                    const Text('投稿が0件になり、語句が削除された可能性があります。'),
                  ],
                ),
              ),
            );
          }

          // * 該当するWordがある場合
          return Scaffold(
            body: SafeArea(
              child: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool _) {
                  return <Widget>[
                    SliverAppBar(
                      forceElevated: true,
                      floating: true,
                      title: Text(word.word, overflow: TextOverflow.ellipsis),
                      actions: [
                        PopupMenuButton<_WordAction>(
                          key: const Key('word-actions-button'),
                          onSelected: (action) async {
                            if (action == _WordAction.edit) {
                              final updated = await showDialog<bool>(
                                context: context,
                                builder: (_) => WordEditDialog(word: word),
                              );
                              if (updated == true && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('言葉を修正しました。')),
                                );
                              }
                              return;
                            }

                            final currentUserId = ref.read(userIdProvider)!;
                            final currentUserProfile = await ref.read(
                              userProfileProvider(currentUserId).future,
                            );
                            final url = contentReportFormUrl(
                              targetType: ReportTargetType.word,
                              targetId: word.id,
                              currentUserPublicId: currentUserProfile.publicId,
                              initialReason: action == _WordAction.proposeEdit
                                  ? '修正提案: '
                                  : null,
                            );
                            await ref
                                .read(launchUrlControllerProvider)
                                .launchURL(url);
                          },
                          itemBuilder: (_) => [
                            if (word.isEditableByMe)
                              const PopupMenuItem(
                                value: _WordAction.edit,
                                child: Text('言葉を修正'),
                              )
                            else
                              const PopupMenuItem(
                                value: _WordAction.proposeEdit,
                                child: Text('修正を提案'),
                              ),
                            const PopupMenuItem(
                              value: _WordAction.report,
                              child: Text('通報'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        WordWidget(word: word),
                        WordMyDefinitionsPreview(wordId: wordId),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                          child: Text(
                            'みんなの定義',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ]),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: StickyTabBarDelegate(
                        tabBar: TabBar(
                          labelStyle: Theme.of(context).textTheme.titleMedium,
                          indicatorWeight: 3,
                          tabs: const [
                            Tab(text: '新着順'),
                            Tab(text: 'リアクション順'),
                          ],
                          onTap: (_) {
                            if (DefaultTabController.of(
                              context,
                            ).indexIsChanging) {
                              // * タブを切り替えた場合
                              return;
                            }

                            // * 同じタブをタップした場合
                            PrimaryScrollController.of(context).scrollToTop();
                          },
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    DefinitionList(
                      definitionFeedType: DefinitionFeedType.wordOthersNewest,
                      wordId: wordId,
                      shimmerTileNumber: 2,
                      emptyWidget: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 32),
                          child: Text('みんなの定義はまだありません'),
                        ),
                      ),
                      // TODO(me): スワイプリフレッシュ時、インジケータの表示がなめらかじゃないの直したい。
                      additionalOnRefresh: () =>
                          ref.invalidate(wordProvider(wordId)),
                    ),
                    DefinitionList(
                      definitionFeedType:
                          DefinitionFeedType.wordOthersReactions,
                      wordId: wordId,
                      shimmerTileNumber: 2,
                      emptyWidget: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 32),
                          child: Text('みんなの定義はまだありません'),
                        ),
                      ),
                      additionalOnRefresh: () =>
                          ref.invalidate(wordProvider(wordId)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => Scaffold(
          appBar: AppBar(),
          body: const Column(children: [WordPageShimmer()]),
        ),
        error: (error, stackTrace) {
          logger.e(
            '語句[$wordId]の取得に失敗しました。'
            'error: $error, stackTrace: $stackTrace',
          );

          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: asyncWord.isRefreshing
                    ? // エラー発生後の再読み込み中の場合
                      const CupertinoActivityIndicator()
                    : ErrorAndRetryWidget.cannotInquire(
                        onRetry: () => ref.invalidate(wordProvider(wordId)),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _WordAction { edit, proposeEdit, report }
