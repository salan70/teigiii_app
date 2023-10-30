import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget/button/to_setting_button.dart';
import '../../../../../core/common_widget/search_text_field.dart';
import '../../../util/initial_main_group.dart';

@RoutePage()
class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 36,
              ),
              child: SearchTextField(),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: InitialMainGroup.values.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          InitialMainGroup.values[index].label,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          alignment: Alignment.centerRight,
                          iconSize: 20,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          icon: const Icon(CupertinoIcons.chevron_forward),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
