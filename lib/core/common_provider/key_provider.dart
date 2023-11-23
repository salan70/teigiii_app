import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'key_provider.g.dart';

// [HomePage] の [NestedScrollView] の [key] として使用するために作成
// 他のWidgetでも使用する場合は、このproviderをfamilyにして、
// 使用するWidgetを引数で指定するようにする（使用するWidget名をenumで定義する）
@riverpod
GlobalKey globalKey(GlobalKeyRef ref) =>
    GlobalKey();
