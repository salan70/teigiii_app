import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common_widget/button/to_setting_button.dart';
import '../../../../user_profile/application/user_profile_state.dart';
import '../../component/initial_main_group_list.dart';

@RoutePage()
class MyDictionaryRouterPage extends AutoRouter {
  const MyDictionaryRouterPage({super.key});
}

@RoutePage()
class MyDictionaryPage extends ConsumerWidget {
  const MyDictionaryPage({
    super.key,
    required this.targetUserId,
  });

  final String targetUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTargetUserProfile = ref.watch(userProfileProvider(targetUserId));

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: asyncTargetUserProfile.maybeWhen(
            data: (targetUserProfile) {
              return Text('${targetUserProfile.name}の辞書');
            },
            orElse: () => const Text(''),
          ),
          leading: const ToSettingButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: ListView(
            children: const [
              InitialMainGroupList(),
            ],
          ),
        ),
      ),
    );
  }
}
