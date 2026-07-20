import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// @doc doc/specs/mobile-app-functional-spec.md#2-2-最上位ナビゲーション
final topLevelScrollControllerProvider =
    Provider.family<ScrollController, TopLevelTab>((ref, tab) {
      final controller = ScrollController();
      ref.onDispose(controller.dispose);
      return controller;
    });

enum TopLevelTab { personalDictionary, communityDictionary, timeline }
