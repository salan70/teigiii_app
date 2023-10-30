import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget/button/to_setting_button.dart';
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
            const Divider(),
            for (final initialMainGroup in InitialMainGroup.values)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        initialMainGroup.label,
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
              ),
          ],
        ),
      ),
    );
  }
}
