import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final dartSources = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));

  test('WillPopScope を使用しない', () {
    expect(_matchingLines(dartSources, 'WillPopScope'), isEmpty);
  });

  test('Color.withOpacity を使用しない', () {
    expect(_matchingLines(dartSources, '.withOpacity('), isEmpty);
  });
}

List<String> _matchingLines(Iterable<File> files, String pattern) {
  return [
    for (final file in files)
      for (final (index, line) in file.readAsLinesSync().indexed)
        if (line.contains(pattern)) '${file.path}:${index + 1}: ${line.trim()}',
  ];
}
