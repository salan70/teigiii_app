import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/to_setting_button.dart';
import '../../../../../core/common_widget/error_and_retry_widget.dart';
import '../../../../../util/logger.dart';
import '../../../../user_profile/application/user_profile_state.dart';
import '../../../util/dictionary_page_type.dart';
import '../../component/dictionary_author_widget.dart';
import '../../component/initial_main_group_list.dart';

@RoutePage()
class IndividualDictionaryRouterPage extends AutoRouter {
  const IndividualDictionaryRouterPage({super.key});
}

@RoutePage()
class IndividualDictionaryPage extends ConsumerWidget {
  const IndividualDictionaryPage({
    super.key,
    required this.targetUserId,
    this.isTopRoute = false,
  });

  final String targetUserId;
  final bool isTopRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTargetUserProfile = ref.watch(userProfileProvider(targetUserId));

    return asyncTargetUserProfile.when(
      data: (targetUserProfile) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${targetUserProfile.name}の辞書'),
            leading: isTopRoute ? const ToSettingButton() : const BackButton(),
            leadingWidth: 48,
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 80,
                child: DictionaryAuthorWidget(targetUserId: targetUserId),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: InitialMainGroupList(
                  dictionaryPageType: DictionaryPageType.individual,
                  targetUserId: targetUserId,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
      error: (error, stackTrace) {
        // エラー発生後の再読み込み中の場合、trueになる
        if (asyncTargetUserProfile.isRefreshing) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('辞書'),
            ),
            body: const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: CupertinoActivityIndicator(),
              ),
            ),
          );
        }

        logger.e('ユーザー[$targetUserId]のプロフィールの取得に失敗しました。'
            'error: $error, stackTrace: $stackTrace');
        return Scaffold(
          appBar: AppBar(
            title: const Text('辞書'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: ErrorAndRetryWidget(
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
