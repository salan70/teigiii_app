/// デザインシステムの公開 API。
///
/// feature からはこのファイルだけを import する。
/// 仕様の正本は `doc/specs/mobile-app-design-system.md`。
library;

export 'theme/ds_text_theme.dart' show dsFontFamily;
export 'theme/ds_theme.dart' show buildDsThemeData;
export 'token/ds_colors.dart';
export 'token/ds_elevation.dart';
export 'token/ds_opacity.dart';
export 'token/ds_radius.dart';
export 'token/ds_size.dart';
export 'token/ds_spacing.dart';
export 'token/ds_theme_context.dart';
export 'token/ds_typography.dart';
