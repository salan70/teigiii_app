// デザインシステム違反検出（#262）。
//
// analyzer をライブラリとして使い、lib/ 配下の AST から
// デザイン値の直書き・禁止 widget の直接利用を検出する。
// 既存違反は tool/ds_baseline.json でベースライン化し、
// 新規違反・違反増加のみを失敗させる。
//
// 使い方:
//   dart run tool/ds_check.dart                    # 検査（CI と同じ）
//   dart run tool/ds_check.dart --all              # 全違反を明細表示
//   dart run tool/ds_check.dart --update-baseline  # baseline を再生成
import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

/// ルール ID。
const ruleColor = 'ds_hardcoded_color';
const ruleTextStyle = 'ds_hardcoded_text_style';
const ruleSpacing = 'ds_hardcoded_spacing';
const ruleRadius = 'ds_hardcoded_radius';
const ruleSize = 'ds_hardcoded_size';
const ruleElevation = 'ds_hardcoded_elevation';
const ruleOpacity = 'ds_hardcoded_opacity';
const ruleForbiddenWidget = 'ds_forbidden_widget';
const ruleSuppressionWithoutReason = 'ds_suppression_without_reason';

/// baseline に載せず、1 件でも失敗させるルール。
const _alwaysFailRules = <String>{ruleColor, ruleSuppressionWithoutReason};

/// 全ルール（サマリ表示の順序を兼ねる）。
const _allRules = <String>[
  ruleColor,
  ruleTextStyle,
  ruleSpacing,
  ruleRadius,
  ruleSize,
  ruleElevation,
  ruleOpacity,
  ruleForbiddenWidget,
  ruleSuppressionWithoutReason,
];

/// 直接インスタンス化を禁止する widget。
const _forbiddenWidgets = <String>{
  'ElevatedButton',
  'OutlinedButton',
  'TextButton',
  'FilledButton',
  'TextField',
  'TextFormField',
  'AlertDialog',
  'ListTile',
  'IconButton',
};

/// 検査対象から除外するパス（lib/ からの相対）。
///
/// デザインシステム内部だけを除外する。`lib/util/` には UI から使う helper が
/// あるため除外しない（除外すると規約を迂回できてしまう）。
const _excludedDirs = <String>['lib/core/design_system/'];

/// generated ファイルの拡張子。
const _generatedSuffixes = <String>['.g.dart', '.freezed.dart', '.gr.dart'];

const _baselinePath = 'tool/ds_baseline.json';

void main(List<String> args) {
  final updateBaseline = args.contains('--update-baseline');
  final showAll = args.contains('--all');

  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('lib/ が見つからない。mobile_app 直下で実行すること。');
    exit(2);
  }

  final violations = <Violation>[];
  for (final path in _targetFiles(libDir)) {
    violations.addAll(_analyzeFile(path));
  }
  violations.sort((a, b) {
    final byPath = a.path.compareTo(b.path);
    if (byPath != 0) {
      return byPath;
    }
    final byLine = a.line.compareTo(b.line);
    return byLine != 0 ? byLine : a.column.compareTo(b.column);
  });

  final counts = _countByFileAndRule(violations);

  if (updateBaseline) {
    _writeBaseline(counts);
    return;
  }

  exit(_judge(violations, counts, showAll: showAll));
}

/// 検査対象ファイルのパス（`lib/...` 形式）を返す。
List<String> _targetFiles(Directory libDir) {
  final files = <String>[];
  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File) {
      continue;
    }
    final path = entity.path.replaceAll(r'\', '/');
    if (!path.endsWith('.dart')) {
      continue;
    }
    if (_generatedSuffixes.any(path.endsWith)) {
      continue;
    }
    if (_excludedDirs.any(path.startsWith)) {
      continue;
    }
    files.add(path);
  }
  files.sort();
  return files;
}

/// 1 ファイルを解析して違反を返す。
List<Violation> _analyzeFile(String path) {
  final result = parseFile(
    path: File(path).absolute.path,
    featureSet: FeatureSet.latestLanguageVersion(),
  );
  if (result.errors.any((e) => e.severity.name == 'ERROR')) {
    // 構文エラーのあるファイルは解析対象外（analyze 側で検出される）。
    return const [];
  }

  final source = File(path).readAsStringSync();
  final lines = const LineSplitter().convert(source);
  final visitor = _DsVisitor(path, result.lineInfo);
  result.unit.accept(visitor);

  final suppressions = <Violation>[];
  final kept = <Violation>[];
  for (final violation in visitor.violations) {
    final ignore = _findIgnore(lines, violation.line, violation.rule);
    if (ignore == null) {
      kept.add(violation);
      continue;
    }
    if (ignore.hasReason && ignore.hasIssue) {
      continue;
    }
    // 理由・追跡 Issue のない抑制は、抑制せず追加で失敗させる。
    kept.add(violation);
    suppressions.add(
      Violation(
        rule: ruleSuppressionWithoutReason,
        path: path,
        line: ignore.line,
        column: 1,
        message:
            '理由（「理由:」）と追跡 Issue（#123）のない '
            '// ignore: ${violation.rule} は使えない',
      ),
    );
  }
  return [...kept, ...suppressions];
}

class _Ignore {
  _Ignore({
    required this.line,
    required this.hasReason,
    required this.hasIssue,
  });

  final int line;
  final bool hasReason;
  final bool hasIssue;
}

final _issuePattern = RegExp(r'#\d+');

/// 違反行の直前にある連続コメント行から、対象ルールの ignore を探す。
///
/// 理由・追跡 Issue は ignore 行の前後（同じコメントブロック内、直前 3 行以内）を見る。
_Ignore? _findIgnore(List<String> lines, int violationLine, String rule) {
  // violationLine は 1 始まり。直前の連続コメント行を集める。
  final block = <int>[];
  for (var i = violationLine - 2; i >= 0 && block.length < 6; i--) {
    final trimmed = lines[i].trim();
    if (!trimmed.startsWith('//')) {
      break;
    }
    block.add(i);
  }
  if (block.isEmpty) {
    return null;
  }

  final ignoreIndex = block.firstWhere(
    (i) => _ignoreMatches(lines[i], rule),
    orElse: () => -1,
  );
  if (ignoreIndex < 0) {
    return null;
  }

  // ignore 行の直前 3 行、および ignore 行と違反行の間を近傍とみなす。
  final from = ignoreIndex - 3 < 0 ? 0 : ignoreIndex - 3;
  final neighborhood = lines.sublist(from, violationLine - 1);
  return _Ignore(
    line: ignoreIndex + 1,
    hasReason: neighborhood.any((l) => l.contains('理由')),
    hasIssue: neighborhood.any(_issuePattern.hasMatch),
  );
}

/// `// ignore: a, b` の対象に [rule] が含まれるか。
bool _ignoreMatches(String line, String rule) {
  final match = RegExp(r'//\s*ignore(_for_file)?:\s*(.+)$').firstMatch(line);
  if (match == null) {
    return false;
  }
  return match.group(2)!.split(',').map((e) => e.trim()).any((e) => e == rule);
}

/// ファイル × ルールの件数に畳む。
Map<String, Map<String, int>> _countByFileAndRule(List<Violation> violations) {
  final counts = <String, Map<String, int>>{};
  for (final v in violations) {
    counts.putIfAbsent(v.path, () => <String, int>{});
    counts[v.path]![v.rule] = (counts[v.path]![v.rule] ?? 0) + 1;
  }
  return counts;
}

/// baseline を読む。無ければ空。
Map<String, Map<String, int>> _readBaseline() {
  final file = File(_baselinePath);
  if (!file.existsSync()) {
    return {};
  }
  final decoded = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return decoded.map(
    (path, rules) => MapEntry(
      path,
      (rules as Map<String, dynamic>).map(
        (rule, count) => MapEntry(rule, count as int),
      ),
    ),
  );
}

void _writeBaseline(Map<String, Map<String, int>> counts) {
  final baseline = <String, Map<String, int>>{};
  for (final path in counts.keys.toList()..sort()) {
    final rules = <String, int>{};
    for (final rule in _allRules) {
      if (_alwaysFailRules.contains(rule)) {
        continue;
      }
      final count = counts[path]![rule];
      if (count != null && count > 0) {
        rules[rule] = count;
      }
    }
    if (rules.isNotEmpty) {
      baseline[path] = rules;
    }
  }

  File(_baselinePath).writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(baseline)}\n',
  );

  final total = baseline.values
      .expand((rules) => rules.values)
      .fold<int>(0, (a, b) => a + b);
  stdout.writeln(
    'baseline を更新した: $_baselinePath（$total 件 / ${baseline.length} ファイル）',
  );

  for (final rule in _alwaysFailRules) {
    final count = counts.values.fold<int>(
      0,
      (sum, rules) => sum + (rules[rule] ?? 0),
    );
    if (count > 0) {
      stdout.writeln('警告: $rule は baseline 対象外。$count 件残っているため検査は失敗する。');
    }
  }
}

/// 判定して exit code を返す。
int _judge(
  List<Violation> violations,
  Map<String, Map<String, int>> counts, {
  required bool showAll,
}) {
  final baseline = _readBaseline();
  final baselineExists = File(_baselinePath).existsSync();

  final failures = <String, Set<String>>{}; // path -> rules
  final failureMessages = <String>[];
  final improvements = <String>[];

  // 違反が出たファイル × ルールを baseline と比較する。
  for (final path in counts.keys.toList()..sort()) {
    for (final rule in _allRules) {
      final count = counts[path]![rule] ?? 0;
      if (count == 0) {
        continue;
      }
      if (_alwaysFailRules.contains(rule)) {
        failures.putIfAbsent(path, () => <String>{}).add(rule);
        failureMessages.add('$path: $rule が $count 件（baseline 対象外。0 件必須）');
        continue;
      }
      final allowed = baseline[path]?[rule] ?? 0;
      if (count > allowed) {
        failures.putIfAbsent(path, () => <String>{}).add(rule);
        failureMessages.add('$path: $rule が $count 件（baseline $allowed 件を超過）');
      } else if (count < allowed) {
        improvements.add('$path: $rule が $count 件（baseline $allowed 件）');
      }
    }
  }

  // baseline にあって、いまは違反が消えているもの。
  for (final path in baseline.keys.toList()..sort()) {
    for (final rule in baseline[path]!.keys) {
      final count = counts[path]?[rule] ?? 0;
      if (count < baseline[path]![rule]!) {
        improvements.add(
          '$path: $rule が $count 件（baseline ${baseline[path]![rule]} 件）',
        );
      }
    }
  }

  final printed = violations.where(
    (v) =>
        showAll ||
        !baselineExists ||
        (failures[v.path]?.contains(v.rule) ?? false),
  );
  for (final v in printed) {
    stdout.writeln('${v.path}:${v.line}:${v.column} ${v.rule} ${v.message}');
  }

  stdout
    ..writeln()
    ..writeln('--- ルール別サマリ ---');
  for (final rule in _allRules) {
    final count = violations.where((v) => v.rule == rule).length;
    final allowed = _alwaysFailRules.contains(rule)
        ? 0
        : baseline.values.fold<int>(0, (sum, r) => sum + (r[rule] ?? 0));
    stdout.writeln('  ${rule.padRight(32)} $count 件（baseline $allowed 件）');
  }
  stdout.writeln('  ${'合計'.padRight(30)} ${violations.length} 件');

  if (!baselineExists) {
    stdout
      ..writeln()
      ..writeln(
        'baseline がない: $_baselinePath。'
        '`just mobile-ds-baseline-update` で生成すること。',
      );
    return 1;
  }

  if (improvements.isNotEmpty) {
    stdout
      ..writeln()
      ..writeln(
        '違反が baseline を下回った（`just mobile-ds-baseline-update` で更新すること）:',
      );
    for (final message in improvements.toSet().toList()..sort()) {
      stdout.writeln('  $message');
    }
  }

  if (failureMessages.isEmpty) {
    stdout
      ..writeln()
      ..writeln('OK: 新規違反・違反増加はない。');
    return 0;
  }

  stdout
    ..writeln()
    ..writeln('NG: 新規違反または違反増加がある:');
  for (final message in failureMessages) {
    stdout.writeln('  $message');
  }
  return 1;
}

class Violation {
  Violation({
    required this.rule,
    required this.path,
    required this.line,
    required this.column,
    required this.message,
  });

  final String rule;
  final String path;
  final int line;
  final int column;
  final String message;
}

/// AST を走査して違反を集める。
class _DsVisitor extends RecursiveAstVisitor<void> {
  _DsVisitor(this._path, this._lineInfo);

  final String _path;
  final LineInfo _lineInfo;
  final violations = <Violation>[];

  void _add(String rule, int offset, String message) {
    final location = _lineInfo.getLocation(offset);
    violations.add(
      Violation(
        rule: rule,
        path: _path,
        line: location.lineNumber,
        column: location.columnNumber,
        message: message,
      ),
    );
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final target = node.target;
    final name = target == null
        ? node.methodName.name
        : target is SimpleIdentifier
        ? '${target.name}.${node.methodName.name}'
        : null;
    if (name != null) {
      _check(name, node.argumentList, node.offset);
    }
    // `colorScheme.onSurface.withOpacity(0.3)` のようにターゲットが
    // SimpleIdentifier でない場合も検出したいので、メソッド名だけで判定する。
    _checkDesignValues(
      name ?? node.methodName.name,
      node.argumentList,
      node.offset,
    );
    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final constructorName = node.constructorName;
    final type = constructorName.type;
    // 未解決 AST では `EdgeInsets.symmetric` の `EdgeInsets` は import prefix として
    // 解析される（型名か prefix かは解決しないと決まらない）。両方を名前に含める。
    final prefix = type.importPrefix?.name.lexeme;
    final buffer = <String>[
      if (prefix != null) prefix,
      type.name2.lexeme,
      if (constructorName.name != null) constructorName.name!.name,
    ];
    final joined = buffer.join('.');
    _check(joined, node.argumentList, node.offset);
    _checkDesignValues(joined, node.argumentList, node.offset);
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.prefix.name == 'Colors') {
      _add(ruleColor, node.offset, '`${node.toSource()}` ではなく Theme の色を使う');
    }
    super.visitPrefixedIdentifier(node);
  }

  /// size / elevation / opacity の直書きを判定する。
  ///
  /// [_check] と違い早期 return しない。同じ呼び出しが複数のルールに
  /// 該当しうるため（`Icon(size: 24, ...)` など）。
  void _checkDesignValues(String name, ArgumentList args, int offset) {
    final parts = name.split('.');

    // 不透明度: `withOpacity(0.4)` / `withValues(alpha: 0.4)`
    if (parts.last == 'withOpacity') {
      if (_hasNumericLiteral(args)) {
        _add(ruleOpacity, offset, '`withOpacity` の数値直書きではなく DsOpacity を使う');
      }
    }
    if (parts.last == 'withValues') {
      if (_hasNumericLiteral(args, namedOnly: const {'alpha'})) {
        _add(
          ruleOpacity,
          offset,
          '`withValues(alpha:)` の数値直書きではなく DsOpacity を使う',
        );
      }
    }

    // 標高: どの widget でも `elevation:` は数値を直接書かせない。
    if (_hasNumericLiteral(args, namedOnly: const {'elevation'})) {
      _add(ruleElevation, offset, '`elevation` の数値直書きではなく DsElevation を使う');
    }

    // アイコンサイズ: `Icon(size:)` と `IconButton(iconSize:)`。
    if (parts.contains('Icon')) {
      if (_hasNumericLiteral(args, namedOnly: const {'size'})) {
        _add(ruleSize, offset, '`Icon` の size 直書きではなく DsSize を使う');
      }
    }
    if (_hasNumericLiteral(args, namedOnly: const {'iconSize'})) {
      _add(ruleSize, offset, '`iconSize` の直書きではなく DsSize を使う');
    }
  }

  /// コンストラクタ／ファクトリ呼び出しを判定する。
  ///
  /// [name] は `EdgeInsets.symmetric` のようなドット区切りの呼び出し名。
  /// import prefix が付く場合があるため、末尾からの部分一致で判定する。
  void _check(String name, ArgumentList args, int offset) {
    final parts = name.split('.');
    // 末尾からの部分名（`m.EdgeInsets.symmetric` → EdgeInsets.symmetric, symmetric）。
    final suffixes = <String>[
      for (var i = 0; i < parts.length; i++) parts.sublist(i).join('.'),
    ];
    bool has(String candidate) => suffixes.contains(candidate);

    if (has('Color')) {
      _add(ruleColor, offset, '`Color(0x...)` の直書きではなく Theme の色を使う');
      return;
    }
    if (has('TextStyle')) {
      _add(ruleTextStyle, offset, '`TextStyle` の直接生成ではなく TextTheme を使う');
      return;
    }
    for (final part in parts) {
      if (_forbiddenWidgets.contains(part)) {
        _add(ruleForbiddenWidget, offset, '`$part` ではなく Ds コンポーネントを使う');
        return;
      }
    }
    if (has('BorderRadius.circular') || has('Radius.circular')) {
      if (_hasNumericLiteral(args)) {
        _add(ruleRadius, offset, '`$name` の数値直書きではなく DsRadius を使う');
      }
      return;
    }
    if (has('Gap')) {
      if (_hasNumericLiteral(args)) {
        _add(ruleSpacing, offset, '`Gap` の数値直書きではなく DsSpacing を使う');
      }
      return;
    }
    if (parts.contains('EdgeInsets')) {
      if (_hasNumericLiteral(args)) {
        _add(ruleSpacing, offset, '`$name` の数値直書きではなく DsSpacing を使う');
      }
      return;
    }
    if (parts.contains('SizedBox')) {
      if (_hasNumericLiteral(args, namedOnly: const {'width', 'height'})) {
        _add(
          ruleSpacing,
          offset,
          '`SizedBox` の width/height 直書きではなく DsSpacing / DsSize を使う',
        );
      }
      return;
    }
  }

  /// 引数に数値リテラルが直接書かれているか。
  ///
  /// [namedOnly] を渡した場合、その名前付き引数だけを見る。
  bool _hasNumericLiteral(ArgumentList args, {Set<String>? namedOnly}) {
    for (final argument in args.arguments) {
      if (argument is NamedExpression) {
        if (namedOnly != null &&
            !namedOnly.contains(argument.name.label.name)) {
          continue;
        }
        if (_isNumericLiteral(argument.expression)) {
          return true;
        }
        continue;
      }
      if (namedOnly != null) {
        continue;
      }
      if (_isNumericLiteral(argument)) {
        return true;
      }
    }
    return false;
  }

  bool _isNumericLiteral(Expression expression) {
    if (expression is IntegerLiteral || expression is DoubleLiteral) {
      return true;
    }
    if (expression is PrefixExpression) {
      return _isNumericLiteral(expression.operand);
    }
    return false;
  }
}
