import 'package:flutter/material.dart';

import '../design_system/component/ds_feedback.dart';

/// 読み込み中のプレースホルダ。
///
/// 任意の `shapeBorder` は受け取らない。pill 型が必要なら
/// [DsShimmer.pill] を使う。
@Deprecated('DsShimmer を使う。全参照の移行後に削除する (#278)')
class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : _isCircular = false;

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
  }) : _isCircular = true;

  final double width;
  final double height;
  final bool _isCircular;

  @override
  Widget build(BuildContext context) {
    if (_isCircular) {
      return DsShimmer.circular(width: width, height: height);
    }
    return DsShimmer.rectangular(width: width, height: height);
  }
}
