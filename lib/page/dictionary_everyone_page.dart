import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../core/common_widget/button/to_setting_button.dart';
import '../feature/word/presentation/initial_main_group_list.dart';
import '../feature/word/presentation/search_word_text_field.dart';
import '../feature/word/util/dictionary_page_type.dart';

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
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: ListView(
            children: const [
              SizedBox(height: 24),
              SizedBox(
                height: 80,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: SearchWordTextField(),
                ),
              ),
              InitialMainGroupList(
                dictionaryPageType: DictionaryPageType.everyone,
                targetUserId: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
