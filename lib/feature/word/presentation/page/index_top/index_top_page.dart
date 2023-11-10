import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget/button/to_setting_button.dart';
import '../../component/initial_main_group_list.dart';
import '../../component/word_search_text_field.dart';

@RoutePage()
class IndexTopRouterPage extends AutoRouter {
  const IndexTopRouterPage({super.key});
}

@RoutePage()
class IndexTopPage extends StatelessWidget {
  const IndexTopPage({super.key});

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
                child: WordSearchTextField(),
              ),
              SizedBox(height: 8),
              InitialMainGroupList(),
            ],
          ),
        ),
      ),
    );
  }
}
