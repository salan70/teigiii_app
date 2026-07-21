import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../feature/word_list/presentation/dictionary_word_index_list.dart';
import '../../feature/word_list/presentation/search_word_text_field.dart';
import '../common_widget/button/to_profile_button.dart';
import '../common_widget/button/to_setting_button.dart';
import '../router/app_router.dart';

@RoutePage()
class DictionaryEveryoneRouterPage extends AutoRouter {
  const DictionaryEveryoneRouterPage({super.key});
}

@RoutePage()
class DictionaryEveryonePage extends StatelessWidget {
  const DictionaryEveryonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('みんなの辞書'),
          leading: const ToSettingButton(),
          actions: [
            TextButton(
              onPressed: () => context.pushRoute(const WordRegistrationRoute()),
              child: const Text('言葉を登録'),
            ),
            const ToProfileButton(),
          ],
        ),
        body: const Column(
          children: [
            Gap(16),
            SizedBox(
              height: 80,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SearchWordTextField(),
              ),
            ),
            Expanded(child: DictionaryWordIndexList(targetUserId: null)),
          ],
        ),
      ),
    );
  }
}
