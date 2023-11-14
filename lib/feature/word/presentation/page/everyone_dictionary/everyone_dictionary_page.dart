import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget/button/to_setting_button.dart';
import '../../../util/dictionary_page_type.dart';
import '../../component/initial_main_group_list.dart';
import '../../component/search_word_text_field.dart';

@RoutePage()
class EveryoneDictionaryRouterPage extends AutoRouter {
  const EveryoneDictionaryRouterPage({super.key});
}

@RoutePage()
class EveryoneDictionaryPage extends StatelessWidget {
  const EveryoneDictionaryPage({super.key});

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
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 36,
                ),
                child: SearchWordTextField(),
              ),
              SizedBox(height: 8),
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
