import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../feature/definition/presentation/post_definition_fab.dart';
import '../../feature/word_list/presentation/dictionary_word_index_list.dart';
import '../../feature/word_list/presentation/search_word_text_field.dart';
import '../common_widget/button/to_profile_button.dart';
import '../common_widget/button/to_setting_button.dart';
import '../design_system/design_system.dart';

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
          actions: const [ToProfileButton()],
        ),
        body: const Column(
          children: [
            Gap(DsSpacing.item),
            // ignore: ds_hardcoded_spacing
            // 理由: 検索欄の高さと左右余白は画面ごとに異なる（この画面は 80 / 40、
            // word_search_result_page は高さ指定なし / 36）。DsSearchField へ
            // 閉じ込めると他画面の見た目が変わるため、呼び出し側に残す。
            // 追跡: #280
            SizedBox(
              height: 80,
              // ignore: ds_hardcoded_spacing
              // 理由: 上と同じ。検索欄の左右余白は画面ごとに異なる。
              // 追跡: #280
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: SearchWordTextField(),
              ),
            ),
            Expanded(child: DictionaryWordIndexList(targetUserId: null)),
          ],
        ),
        floatingActionButton: const PostDefinitionFAB(),
      ),
    );
  }
}
