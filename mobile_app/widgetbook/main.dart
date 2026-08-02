import 'package:flutter/material.dart';
import 'package:teigi_app/core/design_system/design_system.dart';
import 'package:widgetbook/widgetbook.dart';

import 'use_cases/ds_app_bar_action_use_cases.dart';
import 'use_cases/ds_button_use_cases.dart';
import 'use_cases/ds_chip_use_cases.dart';
import 'use_cases/ds_dialog_use_cases.dart';
import 'use_cases/ds_feedback_use_cases.dart';
import 'use_cases/ds_input_use_cases.dart';
import 'use_cases/ds_list_tile_use_cases.dart';

/// Ds コンポーネントのカタログ。
///
/// 起動: `just mobile-widgetbook`
/// production app からは参照されない（lib の外に置いている）。
void main() {
  runApp(const DsWidgetbook());
}

class DsWidgetbook extends StatelessWidget {
  const DsWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookFolder(
          name: 'component',
          children: [
            dsAppBarActionComponents(),
            dsButtonComponents(),
            dsChipComponents(),
            dsInputComponents(),
            dsListTileComponent(),
            dsDialogComponents(),
            dsFeedbackComponents(),
          ].expand((components) => components).toList(),
        ),
      ],
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: buildDsThemeData(Brightness.light),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: buildDsThemeData(Brightness.dark),
            ),
          ],
        ),
        TextScaleAddon(),
        ViewportAddon([
          Viewports.none,
          ...IosViewports.phones,
          ...AndroidViewports.phones,
        ]),
        AlignmentAddon(),
      ],
    );
  }
}
