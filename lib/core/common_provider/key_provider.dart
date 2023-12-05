import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'key_provider.g.dart';

// HomePage の NestedScrollView の key として使用するために作成。
// 他の Widget でも使用する場合は、この provider を family にして、
// 使用する Widget を引数で指定するようにする（使用する Widget 名を enum で定義する。）
@riverpod
GlobalKey globalKey(GlobalKeyRef ref) => GlobalKey();

@riverpod
GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey(
  ScaffoldMessengerKeyRef ref,
  ScaffoldMessengerType type,
) =>
    GlobalKey<ScaffoldMessengerState>();

enum ScaffoldMessengerType {
  /// MyApp の builder メソッド内の ScaffoldMessenger に設定する Key.
  ///
  /// BottomNavigationBar を表示していない Page 上で
  /// Snackbar を表示する場合に使用する。
  topRoute,

  /// BasePage の ScaffoldMessenger に設定する Key.
  ///
  /// BottomNavigationBar を表示している Page 上で
  /// Snackbar を表示する場合に使用する。
  baseRoute;
}
