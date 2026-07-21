import '../../word/domain/word.dart';

class PublicDictionaryItem {
  const PublicDictionaryItem({
    required this.word,
    required this.publicDefinitionCount,
  });

  final Word word;
  final int publicDefinitionCount;
}
