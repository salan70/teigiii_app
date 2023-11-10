import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/avatar_icon_widget.dart';
import '../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../../../core/common_widget/button/to_setting_button.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../user_profile/application/user_profile_state.dart';
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
            leading:
                isTopRoute ? const ToSettingButton() : const BackIconButton(),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
            ),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TODO(me): 「Written by」いる？
                    Text(
                      'Written by',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        context.pushRoute(
                          ProfileRoute(
                            targetUserId: targetUserProfile.id,
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          AvatarIconWidget(
                            imageUrl: targetUserProfile.profileImageUrl,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            targetUserProfile.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const InitialMainGroupList(),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
      error: (error, stackTrace) => const Scaffold(
        body: Center(
          child: Text('エラーが発生しました'),
        ),
      ),
    );
  }
}
