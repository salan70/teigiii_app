import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../core/common_widget/button/back_icon_button.dart';
import '../../../util/initial_main_group.dart';
import '../component/index_tile.dart';

@RoutePage()
class IndexSecondPage extends StatelessWidget {
  const IndexSecondPage({
    super.key,
    required this.selectedInitialMainGroup,
  });

  final InitialMainGroup selectedInitialMainGroup;

  @override
  Widget build(BuildContext context) {
    final initialSubGroups = initialMapping[selectedInitialMainGroup]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedInitialMainGroup.label),
        leading: const BackIconButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
        ),
        child: ListView.builder(
          itemCount: initialSubGroups.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IndexTile(label: initialSubGroups[index].label),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
