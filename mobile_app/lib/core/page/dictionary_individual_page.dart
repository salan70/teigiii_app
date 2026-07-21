import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/application/auth_state.dart';
import '../../feature/user_profile/application/user_profile_state.dart';
import '../../feature/user_profile/presentation/dictionary_author_widget.dart';
import '../../feature/word_list/presentation/dictionary_word_index_list.dart';
import '../../util/logger.dart';
import '../common_widget/button/to_profile_button.dart';
import '../common_widget/button/to_setting_button.dart';
import '../common_widget/error_and_retry_widget.dart';
import '../router/app_router.dart';

@RoutePage()
class DictionaryIndividualRouterPage extends AutoRouter {
  const DictionaryIndividualRouterPage({super.key});
}

@RoutePage()
class DictionaryIndividualPage extends ConsumerWidget {
  const DictionaryIndividualPage({
    super.key,
    required this.targetUserId,
    this.isTopRoute = false,
  });

  final String targetUserId;
  final bool isTopRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTargetUserProfile = ref.watch(userProfileProvider(targetUserId));
    final isMe = ref.watch(userIdProvider) == targetUserId;

    return asyncTargetUserProfile.when(
      data: (targetUserProfile) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${targetUserProfile.name}の辞書'),
            leading: isTopRoute ? const ToSettingButton() : const BackButton(),
            actions: [if (isTopRoute) const ToProfileButton()],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 80,
                child: DictionaryAuthorWidget(targetUserId: targetUserId),
              ),
              if (isTopRoute && isMe)
                ListTile(
                  title: const Text('保存した言葉'),
                  trailing: const Icon(CupertinoIcons.chevron_forward),
                  onTap: () => context.pushRoute(const SavedWordListRoute()),
                ),
              Expanded(
                child: DictionaryWordIndexList(targetUserId: targetUserId),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CupertinoActivityIndicator())),
      error: (error, stackTrace) {
        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncTargetUserProfile.isRefreshing) {
          return Scaffold(
            appBar: AppBar(title: const Text('辞書')),
            body: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        }

        logger.e(
          'ユーザー[$targetUserId]のプロフィールの取得に失敗しました。'
          'error: $error, stackTrace: $stackTrace',
        );
        return Scaffold(
          appBar: AppBar(title: const Text('辞書')),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: ErrorAndRetryWidget.cannotInquire(
                onRetry: () =>
                    ref.invalidate(userProfileProvider(targetUserId)),
              ),
            ),
          ),
        );
      },
    );
  }
}
