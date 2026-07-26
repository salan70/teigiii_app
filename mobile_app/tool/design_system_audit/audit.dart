// デザインシステム監査スクリプト（#259）。
//
// lib/ 配下の UI コードから、デザイン値の直書き箇所を機械的に抽出する。
// 分類作業と、後続の違反ベースライン（#262）の材料として使う。
//
// 使い方:
//   dart run tool/design_system_audit/audit.dart              # サマリを表示
//   dart run tool/design_system_audit/audit.dart --tsv        # 明細（診断用。行番号を含む）
//   dart run tool/design_system_audit/audit.dart --baseline   # 安定 ID 単位の件数（比較用）
import 'dart:io';

/// 抽出カテゴリと、その検出パターン。
const _rules = <String, String>{
  'color-literal': r'Color\(0x[0-9a-fA-F]{6,8}\)',
  'color-named': r'\bColors\.[a-zA-Z]+(\.shade[0-9]+|\[[0-9]+\])?',
  'text-style': r'\bTextStyle\(',
  'padding': r'\bEdgeInsets\.[a-zA-Z]+\(',
  'gap': r'\bGap\(\s*[0-9]+(\.[0-9]+)?\s*\)',
  'radius': r'\b(BorderRadius\.[a-zA-Z]+\(|Radius\.circular\()',
  'size-box': r'\bSizedBox\(',
  'elevation': r'\belevation:\s*[0-9]+(\.[0-9]+)?',
  'opacity': r'\b(withOpacity|withValues)\(',
  'font-size': r'\bfontSize:\s*[0-9]+(\.[0-9]+)?',
  'icon-size': r'\bsize:\s*[0-9]+(\.[0-9]+)?',
};

/// テーマ定義そのものなど、直書きが正当なファイル。
const _themeSources = <String>{
  'lib/util/constant/color_scheme.dart',
  'lib/util/constant/text_theme.dart',
  'lib/util/constant/theme_data.dart',
};

class _Hit {
  _Hit(this.category, this.path, this.line, this.snippet);

  final String category;
  final String path;
  final int line;
  final String snippet;

  /// ベースライン比較に使う安定 ID。行番号を含めないため、
  /// 無関係な行の挿入・削除では変化しない。
  String get id => '$category\t$path\t${_normalize(snippet)}';
}

/// snippet を安定 ID 用に正規化する。
///
/// 1. 文字列リテラルを `''` へマスクする（表示文言の変更で ID を変えない）
/// 2. 連続する空白を 1 つに畳む
/// 3. 末尾の `,` `;` を除去する
String _normalize(String snippet) {
  var s = snippet
      .replaceAll(RegExp("'(?:[^'\\\\]|\\\\.)*'"), "''")
      .replaceAll(RegExp('"(?:[^"\\\\]|\\\\.)*"'), "''")
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  while (s.endsWith(',') || s.endsWith(';')) {
    s = s.substring(0, s.length - 1).trimRight();
  }
  return s;
}

void main(List<String> args) {
  final asTsv = args.contains('--tsv');
  final asBaseline = args.contains('--baseline');

  final files =
      Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .where((f) => !f.path.endsWith('.g.dart'))
          .where((f) => !f.path.endsWith('.freezed.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  final patterns = _rules.map(
    (category, pattern) => MapEntry(category, RegExp(pattern)),
  );

  final hits = <_Hit>[];
  for (final file in files) {
    final path = file.path;
    // テーマ定義ファイルの色・タイポは意図的な正本なので除外する。
    if (_themeSources.contains(path)) {
      continue;
    }
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trimLeft().startsWith('//')) {
        continue;
      }
      for (final entry in patterns.entries) {
        if (!entry.value.hasMatch(line)) {
          continue;
        }
        hits.add(_Hit(entry.key, path, i + 1, line.trim()));
      }
    }
  }

  if (asBaseline) {
    // 同一 ID は複数行に現れるため、件数付きの multiset として出力する。
    final counts = <String, int>{};
    for (final hit in hits) {
      counts[hit.id] = (counts[hit.id] ?? 0) + 1;
    }
    final ids = counts.keys.toList()..sort();
    stdout.writeln('category\tpath\tnormalized\tcount');
    for (final id in ids) {
      stdout.writeln('$id\t${counts[id]}');
    }
    return;
  }

  if (asTsv) {
    stdout.writeln('category\tpath\tline\tsnippet');
    for (final hit in hits) {
      stdout.writeln(
        '${hit.category}\t${hit.path}\t${hit.line}\t${hit.snippet}',
      );
    }
    return;
  }

  final byCategory = <String, int>{};
  final byFile = <String, int>{};
  for (final hit in hits) {
    byCategory[hit.category] = (byCategory[hit.category] ?? 0) + 1;
    byFile[hit.path] = (byFile[hit.path] ?? 0) + 1;
  }

  stdout
    ..writeln('走査ファイル数: ${files.length}')
    ..writeln('検出件数: ${hits.length}')
    ..writeln()
    ..writeln('## カテゴリ別');
  final categories = byCategory.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  for (final entry in categories) {
    stdout.writeln('${entry.value}\t${entry.key}');
  }
  stdout
    ..writeln()
    ..writeln('## ファイル別（上位 20）');
  final topFiles = byFile.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  for (final entry in topFiles.take(20)) {
    stdout.writeln('${entry.value}\t${entry.key}');
  }
}
