import 'package:flutter/widgets.dart';

/// 余白の semantic token。
///
/// 値ではなく用途で選ぶ。同じ値でも役割が違えば別 member にしている
/// （[item] と [screenHorizontal] は共に 16）。
///
/// 選択フロー:
/// 1. 要素の内側の余白か、要素間の余白か
/// 2. 内側 — 画面本文の左右なら [screenHorizontal]、画面本文の内周なら
///    [screenContent]、カード・タイル・ダイアログの内周なら [containerContent]
/// 3. 間 — 結びつきが強い順に [tight] → [inline] → [item] → [section] →
///    [block]、画面末尾なら [screenEnd]
///
/// @doc doc/specs/mobile-app-design-system.md#3-1-dsspacing
abstract final class DsSpacing {
  /// アイコンと文言など、密結合した要素の間。
  static const double tight = 4;

  /// 同一ブロック内で隣接する要素の間。
  static const double inline = 8;

  /// リスト項目・フォーム部品など、独立した要素の間。
  static const double item = 16;

  /// セクションの間。
  static const double section = 24;

  /// 画面内の大きなまとまりの間。
  static const double block = 32;

  /// 画面末尾・空表示まわりの余白。
  static const double screenEnd = 40;

  /// 画面本文の左右 padding。
  static const double screenHorizontal = 16;

  /// 画面本文の内周 padding。
  static const double screenContent = 24;

  /// カード・タイル・ダイアログの内周 padding。
  static const double containerContent = 16;

  /// 画面本文の左右 padding を表す [EdgeInsets]。
  static const EdgeInsets screenHorizontalInsets = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
  );

  /// 画面本文の内周 padding を表す [EdgeInsets]。
  static const EdgeInsets screenContentInsets = EdgeInsets.all(screenContent);

  /// カード・タイル・ダイアログの内周 padding を表す [EdgeInsets]。
  static const EdgeInsets containerContentInsets = EdgeInsets.all(
    containerContent,
  );
}
